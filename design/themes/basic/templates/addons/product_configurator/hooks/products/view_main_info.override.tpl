{if $product_configurator_steps}
{assign var="product_id" value=$product.product_id}
{assign var="product_configurator_groups" value=$product_configurator_groups}

{script src="js/addons/product_configurator/compatibilities.js"}
{script src="js/tygh/tabs.js"}

<form {if !$config.tweaks.disable_dhtml && !$no_ajax && !$edit_configuration}class="cm-ajax cm-ajax-full-render"{/if} action="{""|fn_url}" method="post" name="product_form_{$obj_id}" enctype="multipart/form-data">
<input type="hidden" name="result_ids" value="cart_status*,wish_list*" />
<input type="hidden" name="product_data[{$product.product_id}][product_id]" value="{$product.product_id}" />
<input type="hidden" name="product_data[{$product.product_id}][amount]" value="{if $edit_configuration}{$cart_item.amount}{elseif $product.selected_amount}{$product.selected_amount}{else}1{/if}" />
<input type="hidden" name="product_data[{$product_id}][price]" value="0" />

{if !$edit_configuration}
<input type="hidden" name="redirect_url" value="{$config.current_url}" />
{/if}

{if ($product.price|floatval || $product.zero_price_action == "P" || $product.zero_price_action == "A" || (!$product.price|floatval && $product.zero_price_action == "R")) && !($settings.General.allow_anonymous_shopping == "hide_price_and_add_to_cart" && !$auth.user_id)}
    {assign var="show_price_values" value=true}
{else}
    {assign var="show_price_values" value=false}
{/if}

<div class="clearfix">

    {assign var=product value=$product}
    {assign var=show_sku value=true}
    {assign var=show_rating value=true}
    {assign var=show_price value=true}
    {assign var=show_clean_price value=true}
    {assign var=details_page value=true}
    {assign var=show_product_amount value=true}
    {assign var=show_product_options value=true}
    {assign var=show_qty value=true}
    {assign var=min_qty value=true}
    {assign var=show_edp value=true}
    {assign var=show_add_to_cart value=true}
    {assign var=but_role value="action"}
    {assign var=capture_buttons value=true}
    {assign var=hide_form value=true}
    {assign var=show_list_buttons value=true}
    {assign var=block_width value=true}
    
    {if $product}
    {assign var="obj_id" value=$product.product_id}
    {include file="common/product_data.tpl" product=$product}
    {assign var="form_open" value="form_open_`$obj_id`"}
    {$smarty.capture.$form_open nofilter}
    <div class="clearfix">
        <div class="image-wrap float-left">
        {hook name="products:image_wrap"}
            {if !$no_images}
                <div class="image-border float-left center cm-reload-{$product.product_id}" id="product_images_{$product.product_id}_update">
                    {include file="views/products/components/product_images.tpl" product=$product show_detailed_link=true image_width=$settings.Thumbnails.product_details_thumbnail_width image_height=$settings.Thumbnails.product_details_thumbnail_height}
                <!--product_images_{$product.product_id}_update--></div>
            {/if}
        {/hook}
        </div>
        
        <div id="product_info">
            <script type="text/javascript">
            //<![CDATA[
            Tygh.$(document).ready(function(){$ldelim}
                Tygh.$('#product_info').css({$ldelim}'margin-left': Tygh.$('#product_images_{$product.product_id}_update').outerWidth(true)+ 'px'{$rdelim});
            {$rdelim});
            //]]>
            </script>
            <div class="product-info">
                {hook name="products:main_info_title"}
                {if !$hide_title}<h1 class="mainbox-title">{$product.product nofilter}</h1>{/if}
                <div class="brand-wrapper">
                    {include file="views/products/components/product_features_short_list.tpl" features=$product.header_features}
                </div>
                {/hook}

                
                <hr class="indented" />
            
                <div>
                    {assign var="old_price" value="old_price_`$obj_id`"}
                    {assign var="price" value="price_`$obj_id`"}
                    {assign var="clean_price" value="clean_price_`$obj_id`"}
                    {assign var="list_discount" value="list_discount_`$obj_id`"}
                    {assign var="discount_label" value="discount_label_`$obj_id`"}
                    
                    <div class="product-note">
                        {$product.promo_text nofilter}
                    </div>
                    
                    <div class="{if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}prices-container {/if}price-wrap clearfix">
                    {if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
                        <div class="float-left product-prices">
                            {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}&nbsp;{/if}
                    {/if}
                    
                    {if !$smarty.capture.$old_price|trim || $details_page}<p class="actual-price">{/if}
                            {$smarty.capture.$price nofilter}
                    {if !$smarty.capture.$old_price|trim || $details_page}</p>{/if}
                
                    {if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
                            {$smarty.capture.$clean_price nofilter}
                            {$smarty.capture.$list_discount nofilter}
                        </div>
                    {/if}
                    {if $show_discount_label && $smarty.capture.$discount_label|trim}
                        <div class="float-left">
                            {$smarty.capture.$discount_label nofilter}
                        </div>
                    {/if}
                    </div>
                    
                    {if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
                        <div class="options-wrapper indented">
                            {assign var="product_options" value="product_options_`$obj_id`"}
                            {$smarty.capture.$product_options nofilter}
                        </div>
                    {if $capture_options_vs_qty}{/capture}{/if}
                        <div class="indented">
                    {if $capture_options_vs_qty}{capture name="product_options"}{$smarty.capture.product_options nofilter}{/if}
                        {assign var="advanced_options" value="advanced_options_`$obj_id`"}
                        {$smarty.capture.$advanced_options nofilter}
                    {if $capture_options_vs_qty}{/capture}{/if}
                            {$sku = "sku_`$obj_id`"}{$smarty.capture.$sku nofilter}
                        </div> 
                                        
                    <div class="indented">
                        <div class="product-fields-group">
                            {assign var="product_amount" value="product_amount_`$obj_id`"}
                            {$smarty.capture.$product_amount nofilter}
                            
                            {assign var="qty" value="qty_`$obj_id`"}
                            {$smarty.capture.$qty nofilter}    
                                  
                            {assign var="min_qty" value="min_qty_`$obj_id`"}
                            {$smarty.capture.$min_qty nofilter}
                        </div>
                    </div>               
                    
                    {assign var="product_edp" value="product_edp_`$obj_id`"}
                    {$smarty.capture.$product_edp nofilter}
    
                    {if $capture_buttons}{capture name="buttons"}{/if}
                        <div class="buttons-container nowrap">
                            {assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
                            {$smarty.capture.$add_to_cart nofilter}
                            
                            {assign var="list_buttons" value="list_buttons_`$obj_id`"}
                            {$smarty.capture.$list_buttons nofilter}
                        </div>
                    {if $capture_buttons}{/capture}{/if}
                </div>
            </div>
        </div>
    </div>
    {assign var="form_close" value="form_close_`$obj_id`"}
    {$smarty.capture.$form_close nofilter}
    {/if}
</div>

<h2 class="product-config-header">{__("product_configuration")}</h2>

{capture name="tabsbox"}
{foreach from=$product_configurator_steps item="step" name="configurator_steps"}
<div class="cm-reload-{$obj_id|default:$product.product_id}" id="content_pc_{$step.step_id}_update">
<div id="content_pc_{$step.step_id}"{if !$smarty.foreach.configurator_steps.first} class="hidden"{/if}>
{if $smarty.foreach.configurator_steps.first}
    {assign var="active_tab" value="pc_`$step.step_id`"}
{/if}
<table class="product-configuration table-width">
{foreach from=$step.product_configurator_groups item="po" name="groups_name"}
<tbody>
<tr>
    <td colspan="3" class="info-field-title-wrap{if !$smarty.foreach.groups_name.first} field-title{/if}">
    <div class="info-field-title">
        <div class="float-right">{include file="common/popupbox.tpl" id="description_`$po.group_id`" link_text="?" text=$po.configurator_group_name href="products.configuration_group?step_id=`$step.step_id`&group_id=`$po.group_id`&product_id=$product_id" show_brackets=true content=""}</div>
        <span>{$po.configurator_group_name}</span>
    </div>
    </td>
</tr>
</tbody>
{***************** if there is only one product and it is required - just show it **************}
{if $po.products_count == "1" && $po.required == "Y"}
    {foreach from=$po.products item="group_product"}
        <tbody>
        <tr>
            <td colspan="2" style="width: 100%">
            <input type="hidden" id="group_one_{$po.group_id}" name="product_data[{$product_id}][configuration][{$po.group_id}]" value="{$group_product.product_id}" />
            {if $group_product.is_accessible}{include file="common/popupbox.tpl" id="description_`$po.group_id`_`$group_product.product_id`" link_text=$group_product.product text=$group_product.product href="products.configuration_product?group_id=`$po.group_id`&product_id=`$group_product.product_id`" content=""}{else}{$group_product.product}{/if}</td>
            <td>&nbsp;{if $show_price_values == true}<span class="price">{include file="common/price.tpl" value=$group_product.price}</span>{/if}&nbsp;</td>
        </tr>
        </tbody>
    {/foreach}
{else}
{***************** display the list of products with ability to choose **************}
    {if $po.configurator_group_type == "S"}
        <tbody>
        {if $po.products}
        <tr>
            <td style="width: 100%" colspan="2">
            <select name="product_data[{$product_id}][configuration][{$po.group_id}]" id="group_{$po.group_id}" onchange="fn_change_options('{$obj_id|default:$product.product_id}', '{$obj_id|default:$product.product_id}', '0'); fn_check_compatibilities({$po.group_id},'select','{$po.configurator_group_type}');">
                <option id="product_0_{$po.group_id}" value="0">{__("none")}</option>
                {foreach from=$po.products item="group_product"}
                {if ($group_product.is_edp != "Y" && $group_product.tracking != "D" && ($group_product.amount <= 0 || $group_product.amount < $group_product.min_qty) && $settings.General.inventory_tracking == "Y" && $settings.General.allow_negative_amount != "Y") || ($group_product.zero_price_action != "P" && !$group_product.price|floatval)}
                    {assign var="disable_product" value=true}
                {else}
                    {assign var="disable_product" value=false}
                {/if}
                <option class="{if $disable_product}cm-configurator-disabled{/if}" id="product_{$group_product.product_id}" value="{$group_product.product_id}" {if $group_product.selected == "Y" && ($group_product.amount > 0 || $settings.General.inventory_tracking != "Y" || $settings.General.allow_negative_amount == "Y")}selected="selected"{/if} {if $group_product.disabled || $disable_product}disabled="disabled"{/if}>{$group_product.product}{if $show_price_values == true} - {include file="common/price.tpl" value=$group_product.price}{/if}{if $group_product.recommended == "Y"} ({__("recommended")}){/if}</option>
                {/foreach}
            </select>
            </td>
            <td>
                <div id="select_{$po.group_id}">
                    {foreach from=$po.products item="group_product" name="descr_links"}
                        {if $group_product.selected == "Y" && ($group_product.amount > 0 || $settings.General.inventory_tracking != "Y" || $settings.General.allow_negative_amount == "Y")}
                            {assign var="cur_class" value=""}
                        {else}
                            {assign var="cur_class" value="hidden"}
                        {/if}
                        {if $group_product.is_accessible}{include file="common/popupbox.tpl" id="description_`$po.group_id`_`$group_product.product_id`" link_text=__("details") text=$group_product.product href="products.configuration_product?group_id=`$po.group_id`&product_id=`$group_product.product_id`" link_meta=$cur_class content=""}{/if}
                    {/foreach}
                </div>
            </td>
        </tr>
        {else}
        <tr>
            <td style="width: 100%" colspan="3">
                <span class="price strong">{__("text_no_products_defined")}</span>
            </td>
        </tr>
        {/if}
        </tbody>
    {elseif $po.configurator_group_type == "R" }
        {if $po.products}
        <tbody id="group_{$po.group_id}">
            {foreach from=$po.products item="group_product" name="vars"}
            {if ($group_product.is_edp != "Y" && $group_product.tracking != "D" && ($group_product.amount <= 0 || $group_product.amount < $group_product.min_qty) && $settings.General.inventory_tracking == "Y" && $settings.General.allow_negative_amount != "Y") || ($group_product.zero_price_action != "P" && !$group_product.price|floatval)}
                {assign var="disable_product" value=true}
            {else}
                {assign var="disable_product" value=false}
            {/if}
            {if $smarty.foreach.vars.first && $po.required != "Y"}
            <tr>
                <td><input  id="group_{$po.group_id}_product_0" type="radio" class="radio {if $disable_product}cm-configurator-disabled{/if}" name="product_data[{$product_id}][configuration][{$po.group_id}]" value="0" onclick="fn_change_options('{$obj_id|default:$product.product_id}', '{$obj_id|default:$product.product_id}', '0'); fn_check_compatibilities({$po.group_id}, 0, '{$po.configurator_group_type}');" checked="checked" {if $group_product.disabled || $disable_product}disabled="disabled"{/if} /></td>
                <td>&nbsp;{__("none")}</td>
                <td>&nbsp;</td>
            </tr>
            {/if}
            
            <tr>
                <td><input type="radio" class="radio cm-no-change {if $disable_product}cm-configurator-disabled{/if}" id="group_{$po.group_id}_product_{$group_product.product_id}" name="product_data[{$product_id}][configuration][{$po.group_id}]" value="{$group_product.product_id}" onclick="fn_change_options('{$obj_id|default:$product.product_id}', '{$obj_id|default:$product.product_id}', '0'); fn_check_compatibilities({$po.group_id},{$group_product.product_id}, '{$po.configurator_group_type}');" {if $group_product.selected == "Y" && false == $disable_product}checked="checked"{/if} {if $group_product.disabled == true || $disable_product}disabled="disabled"{/if} /></td>
                <td style="width: 100%">{if $group_product.is_accessible}{include file="common/popupbox.tpl" id="description_`$po.group_id`_`$group_product.product_id`" link_text=$group_product.product text=$group_product.product href="products.configuration_product?group_id=`$po.group_id`&product_id=`$group_product.product_id`" content=""}{else}{$group_product.product}{/if}{if $group_product.recommended == "Y"} <span>({__("recommended")})</span>{/if}</td>
                <td class="right">&nbsp;{if $show_price_values == true}<span class="price">{include file="common/price.tpl" value=$group_product.price}</span>{/if}</td>
            </tr>
            {/foreach}
        </tbody>
        {else}
        <span class="price strong"> {__("text_no_products_defined")}</span>
        {/if}
    {elseif $po.configurator_group_type == "C"}
        {if $po.products}
            <tbody id="group_{$po.group_id}">
            {foreach from=$po.products item="group_product"}
            
            {if ($group_product.is_edp != "Y" && $group_product.tracking != "D" && ($group_product.amount <= 0 || $group_product.amount < $group_product.min_qty) && $settings.General.inventory_tracking == "Y" && $settings.General.allow_negative_amount != "Y") || ($group_product.zero_price_action != "P" && !$group_product.price|floatval)}
                {assign var="disable_product" value=true}
            {else}
                {assign var="disable_product" value=false}
            {/if}
            <tr>
                <td>
                    <input type="checkbox" class="checkbox cm-no-change {if $disable_product}cm-configurator-disabled{/if}" id="group_{$po.group_id}_product_{$group_product.product_id}" name="product_data[{$product_id}][configuration][{$po.group_id}][]" value="{$group_product.product_id}" onclick="fn_change_options('{$obj_id|default:$product.product_id}', '{$obj_id|default:$product.product_id}', '0'); fn_check_compatibilities({$po.group_id},{$group_product.product_id}, '{$po.configurator_group_type}');" {if $group_product.selected == "Y" && false == $disable_product}checked="checked"{/if} {if $group_product.disabled == true || $disable_product}disabled="disabled"{/if} /></td>
                <td style="width: 100%">{if $group_product.is_accessible}{include file="common/popupbox.tpl" id="description_`$po.group_id`_`$group_product.product_id`" link_text=$group_product.product text=$group_product.product href="products.configuration_product?group_id=`$po.group_id`&product_id=`$group_product.product_id`" content=""}{else}{$group_product.product}{/if}{if $group_product.recommended == "Y"} <span>({__("recommended")})</span>{/if}</td>
                <td class="right">&nbsp;{if $show_price_values == true}<span class="price">{include file="common/price.tpl" value=$group_product.price}</span>{/if}</td>
            </tr>
            {/foreach}
            </tbody>
        {else}
        <p class="price">{__("text_no_products_defined")}</p>
        {/if}

    {/if}
{/if}
{/foreach}
</table>
</div>
<!--content_pc_{$obj_id|default:$product.product_id}_update--></div>
{/foreach}
{/capture}
{include file="addons/product_configurator/views/products/components/tabsbox.tpl" content=$smarty.capture.tabsbox tabs_section="configurator"}

{hook name="products:buttons_content"}
<div class="pconf-buttons clearfix">
{if !$edit_configuration}
    <div class="float-left" id="pconf_buttons_block">
        {$smarty.capture.buttons nofilter}
    </div>

    <div class="float-right buttons-container">
        {include file="buttons/button.tpl" but_onclick="fn_check_step();" but_text=__("continue") but_role="submit" but_id="next_button"}
    </div>
{else}
    <div class="buttons-container" id="pconf_buttons_block">
        <input type="hidden" name="product_data[{$product.product_id}][cart_id]" value="{$edit_configuration}" />
        {include file="buttons/save.tpl" but_name="dispatch[checkout.add]"}
    </div>
{/if}
</div>
{/hook}

</form>

{if $show_product_tabs}
    {include file="views/tabs/components/product_popup_tabs.tpl"}
    {$smarty.capture.popupsbox_content nofilter}
{/if}

<script type="text/javascript">
//<![CDATA[

current_step_id = 'pc_{$current_step_id}';
{if $settings.General.inventory_tracking == "Y" && $settings.General.allow_negative_amount != "Y"}
    var hide_amount = true;
{else}
    var hide_amount = false;
{/if}

var depth = {$smarty.const.DIGG_DEPTH};
var free_rec = {$smarty.const.FREE_RECCOMMENDED};
var conf = {$ldelim}{$rdelim};
var conf_prod  = {$ldelim}{$rdelim};
var conf_product_id = {$product.product_id};
{foreach from=$product_configurator_steps item="step"}
     conf['pc_{$step.step_id}'] = {$ldelim}{$rdelim};
    {foreach from=$step.product_configurator_groups item="_group" name="__sect"}
         conf['pc_{$step.step_id}'][{$_group.group_id}] = {$ldelim}{$rdelim};
         conf_prod[{$_group.group_id}] = {$ldelim}{$rdelim};
         conf['pc_{$step.step_id}'][{$_group.group_id}]['required'] = '{$_group.required}';
         conf['pc_{$step.step_id}'][{$_group.group_id}]['type'] = '{$_group.configurator_group_type}';
         conf['pc_{$step.step_id}'][{$_group.group_id}]['name'] = '{$_group.configurator_group_name|escape:javascript nofilter}';
         {if $_group.configurator_group_type == "S"}
            conf_prod[{$_group.group_id}][0] = {$ldelim}{$rdelim};
            conf_prod[{$_group.group_id}][0]['product_id'] = 0;
            conf_prod[{$_group.group_id}][0]['type'] = '{$_group.configurator_group_type}';
            conf_prod[{$_group.group_id}][0]['required'] = '{$_group.required}';
            conf_prod[{$_group.group_id}][0]['price'] = 0;
            conf_prod[{$_group.group_id}][0]['product_name'] = '{__("none")}';
         {/if}
        {foreach from=$_group.products item="_products" name="__group"}
             conf_prod[{$_group.group_id}][{$_products.product_id}] = {$ldelim}{$rdelim};
             conf_prod[{$_group.group_id}][{$_products.product_id}]['product_id'] = {$_products.product_id};
             conf_prod[{$_group.group_id}][{$_products.product_id}]['type'] = '{$_group.configurator_group_type}';
             conf_prod[{$_group.group_id}][{$_products.product_id}]['required'] = '{$_group.required}';
             conf_prod[{$_group.group_id}][{$_products.product_id}]['price'] = {$_products.price};
             conf_prod[{$_group.group_id}][{$_products.product_id}]['amount'] = {$_products.amount};
             {if $_products.is_edp == "Y" || $_products.tracking == "D"}
                conf_prod[{$_group.group_id}][{$_products.product_id}]['no_amount'] = true;
             {/if}
             conf_prod[{$_group.group_id}][{$_products.product_id}]['product_name'] = {if $_group.configurator_group_type == 'S' && ($_group.products_count != '1' || $_group.required != "Y")}Tygh.$('#product_{$_products.product_id}').text() {else}"{$_products.product|escape:javascript nofilter}"{/if};
             conf_prod[{$_group.group_id}][{$_products.product_id}]['class_id'] = {if $_products.class_id}{$_products.class_id}{else}''{/if};
            conf_prod[{$_group.group_id}][{$_products.product_id}]['compatible_classes'] = {$ldelim}{$rdelim};
            {foreach from=$_products.compatible_classes item="compatible_class" key="class_key"  name="__compt"}
                conf_prod[{$_group.group_id}][{$_products.product_id}]['compatible_classes'][{$class_key}]='{$compatible_class.group_id}';
            {/foreach}
        {/foreach}
    {/foreach}
{/foreach}

Tygh.$(document).ready(function(){$ldelim}
    fn_change_options('{$obj_id|default:$product.product_id}', '{$obj_id|default:$product.product_id}', '0');
    fn_check_all_compatibilities();
{$rdelim});
//]]>
</script>

{/if}
