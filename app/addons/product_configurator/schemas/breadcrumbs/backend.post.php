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

$schema['configurator.update_group'] = array (
    array (
        'title' => 'product_groups',
        'link' => 'configurator.manage?selected_section=groups'
    )
);
$schema['configurator.add_group'] = array (
    array (
        'title' => 'product_groups',
        'link' => 'configurator.manage?selected_section=groups'
    )
);
$schema['configurator.update_class'] = array (
    array (
        'title' => 'product_classes',
        'link' => 'configurator.manage?selected_section=classes'
    )
);
$schema['configurator.add_class'] = array (
    array (
        'title' => 'product_classes',
        'link' => 'configurator.manage?selected_section=classes'
    )
);

return $schema;
