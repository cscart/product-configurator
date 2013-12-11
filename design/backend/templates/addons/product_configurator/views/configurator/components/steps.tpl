<div id="content_steps">

<form action="{""|fn_url}" method="post" name="steps_form">

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order":"selected_section"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

<div id="pagination_steps">

{if $steps}
<table class="table table-middle sortable hidden-inputs">
<thead>
    <tr>
        <th class="left" width="5%">
            {include file="common/check_items.tpl"}</th>
        <th width="10%">
            <a class="cm-ajax{if $search.sort_by == "pos"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=pos&sort_order=`$search.sort_order_rev`&selected_section=steps"|fn_url}" data-ca-target-id="pagination_steps">
                {__("position_short")} {if $search.sort_by == "pos"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="70%">
            <a class="cm-ajax{if $search.sort_by == "step_name"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=step_name&sort_order=`$search.sort_order_rev`&selected_section=steps"|fn_url}" data-ca-target-id="pagination_steps">
                {__("name")} {if $search.sort_by == "step_name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="5%">&nbsp;</th>
        <th width="10%" class="right">
            <a class="cm-ajax{if $search.sort_by == "status"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`&selected_section=steps"|fn_url}" data-ca-target-id="pagination_steps">
                {__("status")} {if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
    </tr>
</thead>
<tbody>{foreach from=$steps item=step}
    <tr class="cm-row-status-{$step.status|lower}">
        <td class="left">
            <input type="checkbox" name="delete[]" value="{$step.step_id}" class="cm-item"></td>
        <td>
            <input type="text" name="step_data[{$step.step_id}][position]" value="{$step.position}" class="input-micro input-hidden" size="3"></td>
        <td>
            <input type="text" name="step_data[{$step.step_id}][step_name]" value="{$step.step_name}" size="60" class="input-xxlarge input-hidden"></td>
        <td class="nowrap">
            <div class="hidden-tools">
                {capture name="tools_list"}
                    <li>{btn type="list" class="cm-confirm" text=__("delete") href="configurator.delete_step?step_id=`$step.step_id`"}</li>
                {/capture}
                {dropdown content=$smarty.capture.tools_list}
            </div>
        </td>
        <td class="right">
            {include file="common/select_popup.tpl" id=$step.step_id prefix="step" status=$step.status hidden="" object_id_name="step_id" table="conf_steps"}
        </td>
    </tr>
    {/foreach}</tbody>
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

<!--pagination_steps--></div>

{capture name="buttons"}
    {if $steps}
        {capture name="tools_list"}
            <li>{btn type="delete_selected" dispatch="dispatch[configurator.m_delete_steps]" form="steps_form"}</li>
        {/capture}
        {dropdown content=$smarty.capture.tools_list}

        {include file="buttons/save.tpl" but_name="dispatch[configurator.m_update_steps]" but_role="submit-link" but_target_form="steps_form"}
    {/if}
{/capture}

{capture name="adv_buttons"}
    {include file="common/popupbox.tpl" id="add_new_steps" text=__("add_new_steps") title=__("add_step") act="general" content="" icon="icon-plus"}
{/capture}
</form>

{capture name="add_new_picker"}
<form action="{""|fn_url}" method="post" name="add_steps_form" class="form-horizontal">
<input type="hidden" name="step_id" value="0">

<div class="tabs cm-j-tabs">
    <ul class="nav nav-tabs">
        <li id="tab_steps_new" class="cm-js active"><a>{__("general")}</a></li>
    </ul>
</div>

<div class="cm-tabs-content" id="content_tab_steps_new">
<fieldset>
    <div class="control-group">
        <label class="cm-required control-label" for="elm_step_name">{__("name")}:</label>
        <div class="controls">
            <input type="text" id="elm_step_name" name="step_data[step_name]"  value="" class="input-text-large main-input" size="60" />
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_step_pos">{__("position")}:</label>
        <div class="controls">
            <input type="text" id="elm_step_pos" name="step_data[position]" value="" class="input-text-short" size="3" />
        </div>
    </div>

    {include file="common/select_status.tpl" input_name="step_data[status]" id="elm_step_data_0"}
</fieldset>
</div>

<div class="buttons-container">
    {include file="buttons/save_cancel.tpl" but_name="dispatch[configurator.update_step]" cancel_action="close"}
</div>

</form>
{/capture}
{include file="common/popupbox.tpl" id="add_new_steps" content=$smarty.capture.add_new_picker text=__("add_new_steps") act=""}

<!--content_steps--></div>
