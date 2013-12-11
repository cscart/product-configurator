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

$schema['configurator'] = array (
    'manage' => array (
        'product_classes' => array (
            'dimension' => 1,
            'table_name' => 'conf_class_descriptions',
            'fields' => array ('class_name'),
            'where_fields' => array(
                'class_id' => 'class_id'
            )
        ),
        'configurator_steps' => array (
            'dimension' => 1,
            'table_name' => 'conf_step_descriptions',
            'fields' => array ('step_name'),
            'where_fields' => array(
                'step_id' => 'step_id'
            )
        ),
        'configurator_groups' => array (
            'dimension' => 1,
            'table_name' => 'conf_group_descriptions',
            'fields' => array ('configurator_group_name', 'full_description'),
            'where_fields' => array(
                'group_id' => 'group_id'
            )
        )
    ),
    'update_class' => array (
        'product_class' => array (
            'dimension' => 0,
            'table_name' => 'conf_class_descriptions',
            'fields' => array ('class_name'),
            'where_fields' => array(
                'class_id' => 'class_id'
            )
        ),
        'configurator_groups' => array (
            'dimension' => 1,
            'table_name' => 'conf_group_descriptions',
            'fields' => array ('configurator_group_name', 'full_description'),
            'where_fields' => array(
                'group_id' => 'group_id'
            )
        )
    ),
    'update_group' => array (
        'configurator_steps' => array (
            'dimension' => 1,
            'table_name' => 'conf_step_descriptions',
            'fields' => array ('step_name'),
            'where_fields' => array(
                'step_id' => 'step_id'
            )
        ),
        'configurator_group' => array (
            'dimension' => 0,
            'table_name' => 'conf_group_descriptions',
            'fields' => array ('configurator_group_name', 'full_description'),
            'where_fields' => array(
                'group_id' => 'group_id'
            )
        )
    )
);

return $schema;
