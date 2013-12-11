<div id="content_description_{$group_id}">

<table class="table-width">
<tr>
    <td>
    <table class="table-width">
    <tr>
        <td class="center product-image valign-top">
            {include file="common/image.tpl" show_detailed_link=true obj_id=$product_configurator_group.group_id images=$product_configurator_group.main_pair image_id="pconf_group_`$product_configurator_group.group_id`" image_width=$addons.product_configurator.thumbnails_width}</td>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td class="valign-top" style="width: 100%;">
            <div class="product-details-title">{$product_configurator_group.configurator_group_name}</div>
            <p>{$product_configurator_group.full_description nofilter}</p>
        </td>
    </tr>
    </table>
    </td>
</tr>
</table>

{include file="common/previewer.tpl"}

<!--content_description_{$group_id}--></div>