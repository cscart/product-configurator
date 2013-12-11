{if $product_class.class_id}
    {assign var="id" value=$product_class.class_id}
{else}
    {assign var="id" value=0}
{/if}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" name="class_products_form" class=" form-horizontal">
<input type="hidden" name="class_id" value="{$id}">
<input type="hidden" name="selected_section" value="{$smarty.request.selected_section}">

{capture name="tabsbox"}

<div id="content_general">
<fieldset>
    <div class="control-group">
        <label class="cm-required control-label" for="elm_configurator_class_name">{__("name")}:</label>
        <div class="controls">
            <input type="text" name="update_class_data[class_name]" id="elm_configurator_class_name" value="{$product_class.class_name}" class="input-text-large main-input" size="25" />
        </div>
    </div>
    
    <div class="control-group">
        <label class="cm-required control-label" for="elm_configurator_class_group_id">{__("group")}:</label>
        <div class="controls">
            <select name="update_class_data[group_id]" id="elm_configurator_class_group_id">
                <option value="0">-&nbsp;{__("none")}&nbsp;-</option>
                {foreach from=$groups item=group}
                    <option value="{$group.group_id}" {if $product_class.group_id == $group.group_id}selected="selected"{/if}>{$group.configurator_group_name}</option>
                {/foreach}
            </select>
        </div>
    </div>
    
    {if $classes}
    <div class="control-group">
        <label class="control-label">{__("compatible_classes")}:</label>
        <div class="controls">
            <div class="text-type-value">{html_checkboxes name="update_class_data[compatible_classes]" options=$classes selected=$product_class.compatible_classes columns=1}</div>
        </div>
    </div>
    {/if}
    
    {include file="common/select_status.tpl" input_name="update_class_data[status]" id="elm_configurator_class_status" obj=$product_class}
</fieldset>
<!--id="content_general"--></div>

<div id="content_products">
{include file="pickers/products/picker.tpl" item_ids=$product_class.product_ids data_id="added_products" input_name="update_class_data[product_ids]" type="links"}
<!--id="content_products"--></div>

{capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_name="dispatch[configurator.update_class]" but_role="submit-link" but_target_form="class_products_form" save=$id}
{/capture}

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

</form>
{/capture}
{if !$id}
    {assign var="title" value=__("new_class")}
{else}
    {assign var="title" value="{__("editing_class")}: `$product_class.class_name`"}
{/if}
{include file="common/mainbox.tpl" title=$title content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons}
