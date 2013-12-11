<?php
/***************************************************************************
*                                                                          *
*   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
*                                                                          *
* This  is  commercial  software,  only  users  who have purchased a valid *
* license  and  accept  to the terms of the  License Agreement can install *
* and use this program.                                                    *
*                                                                          *
****************************************************************************
* PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
* "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
****************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'compability') {
    if (defined('AJAX_REQUEST')) {
        $current_product_ids = explode(',', $_REQUEST['product_id']);
        $current_group_id = intval($_REQUEST['group_id']);

        // Check if product has compatibility classes
        $classes = db_get_fields(
            "SELECT ?:conf_class_products.class_id FROM ?:conf_class_products "
                . "LEFT JOIN ?:conf_classes ON ?:conf_class_products.class_id = ?:conf_classes.class_id "
            . "WHERE product_id IN (?n) AND ?:conf_classes.status <> 'D'",
            $current_product_ids
        );

        $_all_products = db_get_hash_array(
            "SELECT ?:products.product_id, ?:conf_group_products.group_id "
                . "FROM ?:conf_class_products "
                    . "LEFT JOIN ?:conf_classes ON ?:conf_class_products.class_id = ?:conf_classes.class_id "
                    . "LEFT JOIN ?:products ON ?:products.product_id = ?:conf_class_products.product_id "
                    . "LEFT JOIN ?:conf_group_products ON ?:conf_group_products.product_id = ?:conf_class_products.product_id "
            . "WHERE ?:products.status IN ('A', 'H') AND ?:conf_classes.group_id <> ?i",
            'product_id',
            $current_group_id
        );

        $available_products = $_all_products;

        // if product does not have compatibility classes - it is compatible with all products
        if (!empty($current_product_ids) && !empty($classes)) {

            // Get all compatible products and place each in array;
            foreach ($current_product_ids as $product_id) {
                if ($product_id > 0) {
                    $available_products = array_intersect_assoc($available_products, fn_get_compatible_products_ids($product_id, $current_group_id));
                }
            }
        }

        Registry::get('ajax')->assign('available', $available_products);
        Registry::get('ajax')->assign('disavailable', array_diff_assoc($_all_products, $available_products));
        exit;
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($mode == 'options') {
        if (!empty($_REQUEST['product_data'])) {
            // Product data
            unset($_REQUEST['product_data']['custom_files']);
            reset($_REQUEST['product_data']);
            list($product_id, $_data) = each($_REQUEST['product_data']);

            if (!empty($_data['configuration'])) {
                define('GET_OPTIONS', true);

                // Backup cart before changes
                $cart = $_SESSION['cart'];

                $_cart = &$_SESSION['cart'];
                fn_clear_cart($_cart);

                $_data['product_id'] = $product_id;

                $_data['amount'] = (isset($_data['amount']) && intval($_data['amount']) <= 0) ? 1 : $_data['amount'];

                fn_add_product_to_cart(array($product_id => $_data), $_cart, $auth);
                list ($cart_products) = fn_calculate_cart_content($_cart, $auth, 'S', true, 'F', false);

                if (!empty($_cart['points_info'])) {
                    Registry::set("runtime.product_configurator.points_info.$product_id", $_cart['points_info']);
                }

                // Restore cart data
                $_SESSION['cart'] = $cart;

                if (!empty($_REQUEST['appearance'])) {
                    foreach ($_REQUEST['appearance'] as $setting => $value) {
                        Registry::get('view')->assign($setting, $value);
                    }

                    Registry::get('view')->assign('no_images', false);
                }

                $get_discounts = true;
                if (!empty($cart_products)) {
                    $product = reset($cart_products);
                    // if product data taken from cart discounts already applied
                    $get_discounts = false;
                } else {
                    $product = fn_get_product_data($product_id, $auth, CART_LANGUAGE, '', true, true, true, true, ($auth['area'] == 'A'));
                    if (!empty($_data['configuration'])) {
                        $product['price'] += fn_pconf_get_configuration_price($_data['configuration']);
                    }
                    $product['original_price'] = $product['price'];
                    $product['amount'] = $_data['amount'];
                }

                if (!empty($product['amount'])) {
                    $product['selected_amount'] = $product['amount'];
                }

                $additional_data = fn_get_product_data($product['product_id'], $auth, CART_LANGUAGE, '', true, true, true, true);

                if (!empty($additional_data)) {
                    $product = array_merge($additional_data, $product);
                }

                $product['configuration_mode'] = true;
                $product['conf_original_price'] = $product['original_price'];

                if (isset($_REQUEST['changed_option'])) {
                    $product['changed_option'] = reset($_REQUEST['changed_option']);
                }

                fn_gather_additional_products_data($product, array('get_icon' => true, 'get_detailed' => true, 'get_options' => true, 'get_discounts' => $get_discounts));

                if (!empty($product['product_options'])) {
                    $options = fn_get_product_options($product['product_id']);
                    foreach ($product['product_options'] as $id => $option) {
                        if (isset($options[$option['option_id']]) && !empty($options[$option['option_id']]['variants'])) {
                            foreach ($options[$option['option_id']]['variants'] as $variant_id => $variant) {
                                if (!empty($variant['image_pair'])) {
                                    $product['product_options'][$id]['variants'][$variant_id]['image_pair'] = $variant['image_pair'];
                                }
                            }

                        }
                    }
                }

                $product['list_price'] = $product['original_price'] = $product['conf_original_price'];

                $product['list_discount'] = fn_format_price($product['list_price'] - $product['price']);
                $product['list_discount_prc'] = sprintf('%d', !empty($product['list_price']) ? round($product['list_discount'] * 100 / $product['list_price']) : 0);
                $product['discount_prc'] = sprintf('%d', !empty($product['list_price']) ? round($product['list_discount'] * 100 / $product['list_price']) : 0);

                // Clear all the user notifications
                $_SESSION['notifications'] = array();

                if (isset($product['in_stock'])) {
                    $product['amount'] = $product['in_stock'];
                }

                Registry::get('view')->assign('product', $product);
                Registry::get('view')->display('views/products/view.tpl');
                exit;
            }

        } else {
            // Cart data
            $_cart = $_SESSION['cart'];
            foreach ($_REQUEST['cart_products'] as $cart_id => $item) {

                if (isset($_cart['products'][$cart_id]) && !empty($_cart['products'][$cart_id]['extra']['configuration']) && isset($item['amount'])) {
                    foreach ($_REQUEST['cart_products'] as $k => $v) {
                        if (!empty($_cart['products'][$k]['extra']['parent']['configuration']) && $_cart['products'][$k]['extra']['parent']['configuration'] == $cart_id) {
                            $_REQUEST['cart_products'][$k]['amount'] = $item['amount'];
                        }
                    }
                }
            }
        }
    }
}
