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

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

    //
    // Apply configurator group to the product
    //
    if ($mode == 'apply_conf_group') {
        $exist = db_get_field("SELECT group_id FROM ?:conf_product_groups WHERE product_id = ?i AND group_id = ?i", $_REQUEST['product_id'], $_REQUEST['add_group_id']);
        if (!empty($_REQUEST['add_group_id']) && empty($exist)) {
            $_data = array (
                'product_id' => $_REQUEST['product_id'],
                'group_id' => $_REQUEST['add_group_id'],
                'default_product_ids' => '',
                'position' => '0'
            );
            db_query("INSERT INTO ?:conf_product_groups ?e", $_data);
        }

        return array(CONTROLLER_STATUS_REDIRECT, "products.update?product_id=$_REQUEST[product_id]");
    }

    //
    // Update product groups
    //
    if ($mode == 'update') {
        // Change related products order
        if (!empty($_REQUEST['conf_product_groups'])) {

            foreach ($_REQUEST['conf_product_groups'] as $k => $v) {
                $v['default_product_ids'] = (empty($v['default_product_ids'])) ? 0 : implode(':', $v['default_product_ids']);
                db_query("UPDATE ?:conf_product_groups SET ?u WHERE group_id = ?i AND product_id = ?i", $v, $k, $_REQUEST['product_id']);
            }
        }

    }

    //
    // Delete product groups
    //
    if ($mode == 'delete_configurator_groups') {

        if (!empty($_REQUEST['group_ids'])) {
            db_query("DELETE FROM ?:conf_product_groups WHERE group_id IN (?n) AND product_id = ?i", $_REQUEST['group_ids'], $_REQUEST['product_id']);
        }

        return array(CONTROLLER_STATUS_REDIRECT, "products.update?product_id=$_REQUEST[product_id]");
    }

    return;
}

if ($mode == 'update') {

    $product_data = Registry::get('view')->getTemplateVars('product_data');

    if (!empty($product_data) && $product_data['product_type'] == 'C') {
        $company_condition = fn_get_ult_company_condition('?:conf_groups.company_id', true, $product_data['company_id']);

        $configurator_groups = db_get_array(
                "SELECT ?:conf_groups.group_id, ?:conf_group_descriptions.configurator_group_name,"
                . " ?:conf_groups.configurator_group_type"
                . " FROM ?:conf_groups"
                . " LEFT JOIN ?:conf_group_descriptions ON ?:conf_group_descriptions.group_id ="
                  . " ?:conf_groups.group_id"
                . " WHERE ?:conf_groups.status = 'A' AND ?:conf_group_descriptions.lang_code = ?s AND ?:conf_groups.step_id > 0"
                . " $company_condition",
                DESCR_SL
            );

        $conf_product_groups = db_get_array(
                "SELECT ?:conf_groups.group_id,"
                . " ?:conf_group_descriptions.configurator_group_name, ?:conf_groups.configurator_group_type,"
                . " ?:conf_product_groups.position, ?:conf_product_groups.required,"
                . " ?:conf_product_groups.default_product_ids, ?:conf_step_descriptions.step_name"
                . " FROM ?:conf_groups"
                . " LEFT JOIN ?:conf_group_descriptions ON ?:conf_group_descriptions.group_id ="
                  . " ?:conf_groups.group_id"
                . " LEFT JOIN ?:conf_product_groups ON ?:conf_product_groups.group_id = ?:conf_groups.group_id"
                . " LEFT JOIN ?:conf_step_descriptions ON ?:conf_step_descriptions.step_id = ?:conf_groups.step_id"
                . " WHERE ?:conf_groups.status = 'A' AND ?:conf_group_descriptions.lang_code = ?s AND"
                  . " ?:conf_step_descriptions.lang_code = ?s AND ?:conf_product_groups.product_id = ?i"
                . " ORDER BY ?:conf_product_groups.position $company_condition",
                DESCR_SL, DESCR_SL, $product_data['product_id']
            );

        //$c_price = 0;
        if (!empty($conf_product_groups)) {
            foreach ($conf_product_groups as $k => $v) {
                $_products = db_get_hash_array(
                        "SELECT ?:product_descriptions.product, ?:product_descriptions.product_id ,"
                        . " IF(?:product_prices.percentage_discount = 0, ?:product_prices.price,"
                          . " ?:product_prices.price - (?:product_prices.price *"
                          . " ?:product_prices.percentage_discount)/100) as price"
                        . " FROM ?:product_descriptions"
                        . " LEFT JOIN ?:conf_group_products ON ?:conf_group_products.product_id ="
                          . " ?:product_descriptions.product_id"
                        . " LEFT JOIN ?:product_prices ON ?:product_prices.product_id ="
                          . " ?:product_descriptions.product_id"
                        . " WHERE ?:conf_group_products.group_id = ?i"
                          . " AND ?:product_descriptions.lang_code = ?s"
                          . " AND ?:product_prices.lower_limit = 1",
                        'product_id', $v['group_id'], DESCR_SL
                    );

                $tmp = explode(':', $v['default_product_ids']);
                foreach ($tmp as $kk => $vv) {
                    if (!empty($_products[$vv])) {
                        $_products[$vv]['default']	= 'Y';
                        //$c_price += $_products[$vv]['price'];
                    }
                }
                $conf_product_groups[$k]['products'] = $_products;
            }
        }

        Registry::get('view')->assign('configurator_groups', $configurator_groups);
        Registry::get('view')->assign('conf_product_groups', $conf_product_groups);

        if (!fn_allowed_for('ULTIMATE') || Registry::get('runtime.company_id')) {
            // Add new tab to page sections
            Registry::set('navigation.tabs.configurator_groups', array (
                'title' => __('configuration'),
                'js' => true
            ));
        }
    }
}
