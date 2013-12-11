{if $configurator_group.group_id}
    {assign var="id" value=$configurator_group.group_id}
{else}
    {assign var="id" value=0}
{/if}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" name="configurator_group_products_form" class=" form-horizontal" enctype="multipart/form-data">
<input type="hidden" name="group_id" value="{$id}" />
<input type="hidden" name="selected_section" value="{$smarty.request.selected_section}" />

{capture name="tabsbox"}

<input type="hidden" name="configurator_group_data[configurator_group_type]" value="{$configurator_group.configurator_group_type}" />

<div id="content_general">
<fieldset>
    <div class="control-group">
        <label class="cm-required control-label" for="elm_configurator_group_name">{__("name")}:</label>
        <div class="controls"><input type="text" name="configurator_group_data[configurator_group_name]" id="elm_configurator_group_name" value="{$configurator_group.configurator_group_name}" class="input-text-large main-input" size="25" />
            {assign var="pair" value=$configurator_group.image_pairs}</div>
    </div>
    
    <div class="control-group">
        <label class="control-label" >{__("images")}:</label>
        <div class="controls"><div class="text-type-value">{include file="common/attach_images.tpl" image_name="configurator_main" image_object_type="conf_group" image_pair=$configurator_group.main_pair image_object_id=$id no_thumbnail=true}</div></div>
    </div>
    
    <div class="control-group">
        <label class="control-label" for="elm_configurator_group_full_descr">{__("full_description")}:</label>
        <div class="controls">
            <textarea id="elm_configurator_group_full_descr" name="configurator_group_data[full_description]" cols="55" rows="8" class="cm-wysiwyg input-textarea-long">{$configurator_group.full_description}</textarea>
        </div>
        
    </div>
    
    <div class="control-group">
        <label class="control-label" for="elm_configurator_group_step_id">{__("step")}:</label>
        <div class="controls">
            <select name="configurator_group_data[step_id]" id="elm_configurator_group_step_id">
                <option value="0">--{__("none")}--</option>
                {foreach from=$steps item="step"}
                    <option value="{$step.step_id}" {if $configurator_group.step_id == $step.step_id}selected="selected"{/if}>{$step.step_name}</option>
                {/foreach}
            </select>
        </div>
    </div>
    
    <div class="control-group">
        <label class="control-label" for="elm_configurator_group_type">{__("display_type")}:</label>
        <div class="controls">
            <select name="configurator_group_data[configurator_group_type]" id="elm_configurator_group_type">
                <option value="S" {if $configurator_group.configurator_group_type == "S"}selected="selected"{/if}>{__("selectbox")}</option>
                <option value="R" {if $configurator_group.configurator_group_type == "R"}selected="selected"{/if}>{__("radiogroup")}</option>
                <option value="C" {if $configurator_group.configurator_group_type == "C"}selected="selected"{/if}>{__("checkbox")}</option>
            </select>
        </div>
    </div>
    
    {include file="common/select_status.tpl" input_name="configurator_group_data[status]" id="elm_configurator_group_status" obj=$configurator_group}
</fieldset>
<!--id="content_general"--></div>

<div id="content_products">
    {include file="pickers/products/picker.tpl" item_ids=$configurator_group.product_ids data_id="added_products" input_name="configurator_group_data[product_ids]" type="links"}
<!--id="content_products"--></div>

{capture name="buttons"}
    {include file="buttons/save_cancel.tpl" but_name="dispatch[configurator.update_group]" but_role="submit-link" but_target_form="configurator_group_products_form" save=$id}
{/capture}

{/capture}
{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

</form>
{/capture}
{if !$id}
    {assign var="title" value=__("new_group")}
{else}
    {assign var="title" value="{__("editing_group")}: `$configurator_group.configurator_group_name`"}
{/if}
{include file="common/mainbox.tpl" title=$title content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons}