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
    'modes' => array (
        'delete_step' => array (
            'permissions' => 'manage_catalog'
        ),
        'delete_group' => array (
            'permissions' => 'manage_catalog'
        ),
        'delete_class' => array (
            'permissions' => 'manage_catalog'
        )
    ),
    'permissions' => array ('GET' => 'view_catalog', 'POST' => 'manage_catalog'),
);
$schema['tools']['modes']['update_status']['param_permissions']['table']['conf_groups'] = 'manage_catalog';
$schema['tools']['modes']['update_status']['param_permissions']['table']['conf_steps'] = 'manage_catalog';
$schema['tools']['modes']['update_status']['param_permissions']['table']['conf_classes'] = 'manage_catalog';

return $schema;
