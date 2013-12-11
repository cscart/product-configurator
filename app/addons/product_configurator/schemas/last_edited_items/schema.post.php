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

$schema['configurator.update_group'] = array(
    'func' => array('fn_product_configurator_get_group_name', '@group_id'),
    'text' => 'product_group'
);
$schema['configurator.update_class'] = array(
    'func' => array('fn_product_configurator_get_class_name', '@class_id'),
    'text' => 'compatible_class'
);

return $schema;
