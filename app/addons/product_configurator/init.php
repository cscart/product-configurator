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

if (!defined('BOOTSTRAP')) { die('Access denied'); }

fn_register_hooks(
    'clone_product',
    'delete_cart_product',
    'delete_wishlist_product',
    'generate_cart_id',
    'get_products',
    'prepare_product_quick_view',
    'pre_add_to_cart',
    'post_add_to_cart',
    'add_to_cart',
    'calculate_cart',
    'pre_add_to_wishlist',
    'gather_additional_products_data_post',
    'order_products_post',
    'buy_together_restricted_product',
    'calculate_options',
    'google_products',
    'amazon_products',
    'update_product_pre',
    'check_add_to_cart_post',
    'add_product_to_cart_check_price',
    'get_order_info',
    'update_cart_products_post'
);
