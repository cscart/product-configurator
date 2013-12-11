{if $runtime.company_id && $product_data.shared_product == "Y" && $product_data.company_id != $runtime.company_id}
{assign var="allow_edit" value=false}
{else}
{assign var="allow_edit" value=true}
{/if}
<div id="content_configurator_groups" class="hidden cm-hide-save-button">
<fieldset>

{include file="common/subheader.tpl" title=__("product_groups") target="#product_configurator_products"}

<div id="product_configurator_products" class="in collapse">

{if $configurator_groups}    
    <div class="clearfix">
        <div class="pull-right">
        {capture name="add_new_picker"}
        <div class="form-horizontal">
            <fieldset>
                <div class="control-group">
                    <label for="add_group_id" class="control-label">{__("group")}:</label>
                    <div class="controls">
                        <select name="add_group_id" id="add_group_id">
                            {foreach from=$configurator_groups item="group_" key="group_id"}
                            <option value="{$group_.group_id}">{$group_.configurator_group_name}</option>
                            {/foreach}
                        </select>
                        <p><small>
                            {__("only_product_groups_notice")} <a href="{"configurator.manage"|fn_url}">{__("product_groups_page")}</a>
                        </small></p>
                    </div>
                </div>
            </fieldset>
        </div>
    
        <div class="buttons-container">
            {include file="buttons/save_cancel.tpl" but_text=__("add") but_name="dispatch[products.apply_conf_group]" cancel_action="close"}
        </div>
        {/capture}
    
        {include file="common/popupbox.tpl" id="add_new_pconf_group" text=__("add_product_group") link_text=__("add_product_group") content=$smarty.capture.add_new_picker act="general"}
        
        {if $allow_edit}
            {if $conf_product_groups}
                {btn type="delete_selected" dispatch="dispatch[products.delete_configurator_groups]" form="product_update_form" icon="icon-trash"}
            {/if}
        {/if}
        </div>
    </div><br>
{/if}

{if $conf_product_groups}
<table class="table">
    <thead>
        <tr>
            <th width="5%" class="left">
                {include file="common/check_items.tpl"}</th>
            <th width="5%">{__("position_short")}</th>
            <th width="20%">{__("step")}</th>
            <th width="20%">{__("group_name")}</th>
            <th width="45%">{__("default_configuration_products")}</th>
            <th width="10%">{__("required")}</th>
        </tr>
    </thead>
    {foreach from=$conf_product_groups item="po"}
    <tr>
        <td class="left">
            <input type="checkbox" name="group_ids[]" value="{$po.group_id}" class="cm-item"></td>
        <td class="center">
            <input type="text" name="conf_product_groups[{$po.group_id}][position]" value="{$po.position}" size="3" class="input-micro"></td>
        <td class="nowrap"><div class="text-type-value">{$po.step_name}</div></td>
        <td class="nowrap"><div class="text-type-value">{$po.configurator_group_name}</div></td>
        <td class="nowrap">
                {if $po.configurator_group_type == "S" || $po.configurator_group_type == "R"}
                    {if $po.products}
                        <select name="conf_product_groups[{$po.group_id}][default_product_ids][]" class="span6" id="products_{$po.group_id}">
                            <option value="0">{__("none")}</option>
                            {foreach from=$po.products item="group_product"}
                            <option value="{$group_product.product_id}" {if $group_product.default == "Y"} selected="selected" {/if}>{$group_product.product}</option>
                            {/foreach}
                        </select>
                    {else}
                        {__("text_no_products_defined")}
                    {/if}
                {elseif $po.configurator_group_type == "C"}
                    {if $po.products}
                        <select name="conf_product_groups[{$po.group_id}][default_product_ids][]" class="span6" multiple="multiple" id="products_{$po.group_id}">
                            {foreach from=$po.products item="group_product"}
                            <option value="{$group_product.product_id}" {if $group_product.default == "Y"} selected="selected" {/if}>{$group_product.product}</option>
                            {/foreach}
                        </select>
                    {else}
                        {__("text_no_products_defined")}
                    {/if}
                {/if}    
        </td>
        <td class="center">
            <input type="hidden" name="conf_product_groups[{$po.group_id}][required]" value="N" />
            <input type="checkbox" id="required_{$po.group_id}" name="conf_product_groups[{$po.group_id}][required]" value="Y" {if $po.required == "Y"}checked="checked"{/if}></td>
    </tr>
    {/foreach}
    </table>
    {else}
        <p class="no-items">{__("no_data")}</p>
    {/if}
</div>
</fieldset>

</div>
{** /Product groups section **}