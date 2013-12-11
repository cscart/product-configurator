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

if ($mode == 'configuration_group') {

    $product_configurator_group = db_get_row(
        "SELECT ?:conf_groups.group_id, ?:conf_group_descriptions.configurator_group_name, "
            . "?:conf_group_descriptions.full_description, ?:conf_groups.configurator_group_type, "
            . "?:conf_product_groups.position, ?:conf_product_groups.default_product_ids, ?:conf_product_groups.required "
        . "FROM ?:conf_groups "
            . "LEFT JOIN ?:conf_group_descriptions "
                . "ON ?:conf_group_descriptions.group_id = ?:conf_groups.group_id "
            . "LEFT JOIN ?:conf_product_groups "
                ."ON ?:conf_product_groups.group_id = ?:conf_groups.group_id "
        ."WHERE ?:conf_groups.status = 'A' AND ?:conf_group_descriptions.lang_code = ?s "
            . "AND ?:conf_groups.step_id = ?i AND ?:conf_groups.group_id = ?i",
        CART_LANGUAGE, $_REQUEST['step_id'], $_REQUEST['group_id']
    );

    $product_configurator_group['main_pair'] = fn_get_image_pairs($_REQUEST['group_id'], 'conf_group', 'M');

    Registry::get('view')->assign('product_configurator_group', $product_configurator_group);
    Registry::get('view')->assign('group_id', $_REQUEST['group_id']);
    Registry::get('view')->display('addons/product_configurator/views/products/components/group_info.tpl');
    exit;

} elseif ($mode == 'configuration_product') {
    if (!empty($_REQUEST['product_id'])) {
        $product = fn_get_product_data($_REQUEST['product_id'], $auth, CART_LANGUAGE);
        fn_gather_additional_product_data($product, false, false, true, true, false);

        Registry::get('view')->assign('group_id', $_REQUEST['group_id']);
        Registry::get('view')->assign('product', $product);
        Registry::get('view')->display('addons/product_configurator/views/products/components/configuration_product.tpl');
        exit;
    }
} elseif ($mode == 'view') {

    $product = Registry::get('view')->getTemplateVars('product');
    $product['configuration_mode'] = true;

    if (!empty($product) && $product['product_type'] == 'C') {
        if (!empty($_REQUEST['cart_id'])) {
            $cart = & $_SESSION['cart'];
            if (isset($cart['products'][$_REQUEST['cart_id']]['extra'])) {
                $product['extra'] = $cart['products'][$_REQUEST['cart_id']]['extra'];
                $product['selected_amount'] = $cart['products'][$_REQUEST['cart_id']]['amount'];
            }

            Registry::get('view')->assign('edit_configuration', $_REQUEST['cart_id']);
            Registry::get('view')->assign('cart_item', $cart['products'][$_REQUEST['cart_id']]);
            $selected_configuration = $cart['products'][$_REQUEST['cart_id']]['extra']['configuration'];

            // If product has options, select the appropriate
            // FIXME: duplicate selection, first was in gather_additional_product_data
            if (!empty($cart['products'][$_REQUEST['cart_id']]['product_options'])) {
                $product['product_options'] = fn_get_selected_product_options($product['product_id'], $cart['products'][$_REQUEST['cart_id']]['product_options'], CART_LANGUAGE);
            }
        }
        $company_condition = fn_get_ult_company_condition('?:conf_steps.company_id', true, $product['company_id']);

        $product_configurator_steps = db_get_hash_array(
            "SELECT ?:conf_steps.step_id, ?:conf_step_descriptions.step_name"
            . " FROM ?:conf_steps"
                . " LEFT JOIN ?:conf_step_descriptions "
                    . "ON ?:conf_steps.step_id = ?:conf_step_descriptions.step_id"
            . " WHERE ?:conf_steps.status = 'A' AND ?:conf_step_descriptions.lang_code = ?s $company_condition"
            . " ORDER BY ?:conf_steps.position",
            'step_id', CART_LANGUAGE
        );

        $current_step_id = 0;
        foreach ($product_configurator_steps as $step_id => $step_value) {

            $product_configurator_groups = db_get_array(
                "SELECT ?:conf_groups.group_id, ?:conf_group_descriptions.configurator_group_name, "
                    . "?:conf_group_descriptions.full_description, ?:conf_groups.configurator_group_type, "
                    . "?:conf_product_groups.position, ?:conf_product_groups.default_product_ids, ?:conf_product_groups.required "
                . "FROM ?:conf_groups "
                    . "LEFT JOIN ?:conf_group_descriptions "
                        . "ON ?:conf_group_descriptions.group_id = ?:conf_groups.group_id "
                    . "LEFT JOIN ?:conf_product_groups "
                        . "ON ?:conf_product_groups.group_id = ?:conf_groups.group_id  "
                . "WHERE ?:conf_groups.status = 'A' AND ?:conf_group_descriptions.lang_code = ?s "
                    . "AND ?:conf_product_groups.product_id = ?i AND ?:conf_groups.step_id = ?i "
                . "ORDER BY ?:conf_product_groups.position",
                CART_LANGUAGE, $product['product_id'], $step_id
            );

            $price_usergroup = db_quote(" AND ?:product_prices.usergroup_id IN (?n)", array_merge(array(USERGROUP_ALL), $auth['usergroup_ids']));

            if (!empty($product_configurator_groups)) {
                $c_price = 0;

                $where = $join = '';
                if (Registry::get('settings.General.inventory_tracking') == 'Y' && Registry::get('settings.General.allow_negative_amount') != "Y" && Registry::get('settings.General.show_out_of_stock_products') == 'N') {
                    $join = " LEFT JOIN ?:product_options_inventory as inventory ON inventory.product_id = ?:products.product_id";

                    $where = " AND (IF(?:products.tracking = 'O', inventory.amount > 0, ?:products.amount > 0) OR ?:products.tracking = 'D')";
                }

                foreach ($product_configurator_groups as $k => $v) {

                    $class_ids = db_get_fields("SELECT class_id FROM ?:conf_classes WHERE group_id = ?i", $v['group_id']);

                    $_products = db_get_array(
                        "SELECT ?:product_descriptions.product, ?:product_descriptions.product_id , "
                            . "MIN(IF(?:product_prices.percentage_discount = 0, ?:product_prices.price, "
                            . "?:product_prices.price - (?:product_prices.price * ?:product_prices.percentage_discount)/100)) as price, "
                            . "?:conf_class_products.class_id, ?:products.tax_ids, ?:products.amount "
                        . "FROM ?:conf_group_products "
                            . "LEFT JOIN ?:products "
                                . "ON ?:products.product_id = ?:conf_group_products.product_id "
                            . "LEFT JOIN ?:product_descriptions "
                                . "ON ?:product_descriptions.product_id = ?:conf_group_products.product_id "
                                    . "AND ?:product_descriptions.lang_code = ?s "
                            . "LEFT JOIN ?:product_prices "
                                . "ON ?:product_prices.product_id = ?:product_descriptions.product_id "
                                    . "AND ?:product_prices.lower_limit = '1' ?p "
                            . "LEFT JOIN ?:conf_class_products "
                                . "ON ?:conf_class_products.class_id IN (?n) "
                                    . "AND ?:conf_class_products.product_id = ?:conf_group_products.product_id ?p "
                        . "WHERE ?:conf_group_products.group_id = ?i AND ?:products.status IN ('A', 'H') ?p "
                        . "GROUP BY ?:product_prices.product_id ORDER BY ?:product_descriptions.product",
                        CART_LANGUAGE, $price_usergroup, $class_ids, $join, $v['group_id'], $where
                    );

                    if (empty($_products)) {
                        unset($product_configurator_groups[$k]);
                        continue;
                    }

                    $default_ids = explode(':', $v['default_product_ids']);
                    $selected_ids = empty($selected_configuration[$v['group_id']]) ? $default_ids : (!is_array($selected_configuration[$v['group_id']]) ? array($selected_configuration[$v['group_id']]) : $selected_configuration[$v['group_id']]);

                    foreach ($_products as $_k => $_v) {
                        // Selected products

                        if ($product_data = fn_get_product_data($_v['product_id'], $auth, CART_LANGUAGE, '', false, false, true, true, false, false, true)) {
                            $_v = array_merge($_v, $product_data);
                        } else {
                            unset($_products[$_k]);
                            continue;
                        }

                        $_products[$_k] = $_v;

                        if (in_array($_v['product_id'], $selected_ids)) {
                            $_products[$_k]['selected']	= 'Y';
                            $c_price += $_products[$_k]['price'];
                        } else {
                            $_products[$_k]['selected']	= 'N';
                        }

                        // Recommended products
                        if (in_array($_v['product_id'], $default_ids)) {
                            $_products[$_k]['recommended']	= 'Y';
                        }

                        $_products[$_k]['compatible_classes'] = db_get_hash_array("SELECT ?:conf_compatible_classes.slave_class_id, ?:conf_classes.group_id FROM ?:conf_compatible_classes LEFT JOIN ?:conf_classes ON ?:conf_classes.class_id = ?:conf_compatible_classes.slave_class_id WHERE ?:conf_compatible_classes.master_class_id = ?i AND ?:conf_classes.status = 'A'", 'slave_class_id', $_v['class_id']);
                        $_products[$_k]['is_accessible'] = fn_is_accessible_product($_products[$_k]);
                    }

                    if (empty($_products)) {
                        unset($product_configurator_groups[$k]);
                        continue;
                    }

                    fn_gather_additional_products_data($_products, array('get_icon' => false, 'get_detailed' => false, 'get_options'=> true, 'get_discounts'=> true));

                    $product_configurator_groups[$k]['products_count'] = count($_products);
                    $product_configurator_groups[$k]['products'] = $_products;
                    $product_configurator_groups[$k]['main_pair'] = fn_get_image_pairs($v['group_id'], 'conf_group', 'M');
                }
            }

            if (empty($product_configurator_groups)) {
                unset($product_configurator_steps[$step_id]);
                continue;
            }

            if (empty($current_step_id)) {
                $current_step_id = $step_id;
            }

            Registry::set('navigation.tabs.pc_' . $step_id, array (
                'title' => $step_value['step_name'],
                'section' => 'configurator',
                'js' => true
            ));

            // Substitute configuration price instead of product price
            if (!empty($c_price)) {
                $product['price'] = $c_price;
            }

            // Define list of incompatible products
            $tmp = $product_configurator_groups;
            foreach ($product_configurator_groups as $k => $v) {
                foreach ($v['products'] as $_k => $_v) {
                    if ($_v['selected'] == 'Y' && !empty($_v['compatible_classes'])) {
                        foreach ($tmp as $t_key => $t_val) {
                            if ($v['group_id'] !=  $t_val['group_id']) {
                                foreach ($t_val['products'] as $t_kk => $t_vv) {
                                    $compatible = false;
                                    foreach ($_v['compatible_classes'] as $c_class_id => $c_class_val) {
                                        if ($t_vv['class_id'] == $c_class_id) {
                                            $compatible = true;
                                            break;
                                        }
                                    }
                                    $t_val['products'][$t_kk]['disabled'] = !$compatible;
                                }
                            }
                        }
                    }
                }
            }

            $product_configurator_groups = $tmp;
            $product_configurator_steps[$step_id]['product_configurator_groups'] = $product_configurator_groups;
        }

        Registry::get('view')->assign('current_step_id', $current_step_id);
        Registry::get('view')->assign('product_configurator_steps', $product_configurator_steps);
    }

    Registry::get('view')->assign('product', $product);
}
/** /Body **/
