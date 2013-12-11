<div id="content_groups">

<form action="{""|fn_url}" method="post" name="configurator_groups_form">

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order":"selected_section"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

{include file="common/pagination.tpl" save_current_page=true div_id="pagination_groups" save_current_url=true}

{if $groups}
<table class="table table-middle sortable hidden-inputs">
<thead>
    <tr>
        <th class="left" width="5%">
            {include file="common/check_items.tpl"}</th>
        <th width="25%">
            <a class="cm-ajax{if $search.sort_by == "group_name"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=group_name&sort_order=`$search.sort_order_rev`&selected_section=groups"|fn_url}" data-ca-target-id="pagination_groups">
            {__("name")} {if $search.sort_by == "group_name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
        </a>
        </th>
        <th width="25%">
            <a class="cm-ajax{if $search.sort_by == "step_name"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=step_name&sort_order=`$search.sort_order_rev`&selected_section=groups"|fn_url}" data-ca-target-id="pagination_groups">
                {__("step")} {if $search.sort_by == "step_name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="25%">
            <a class="cm-ajax{if $search.sort_by == "display_type"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=display_type&sort_order=`$search.sort_order_rev`&selected_section=groups"|fn_url}" data-ca-target-id="pagination_groups">
                {__("display_type")} {if $search.sort_by == "display_type"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="10%">&nbsp;</th>
        <th width="10%" class="right">
            <a class="cm-ajax{if $search.sort_by == "status"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`&selected_section=groups"|fn_url}" data-ca-target-id="pagination_groups">
                {__("status")} {if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
    </tr>
</thead>
<tbody>
{foreach from=$groups item=group}
{assign var="pair" value=$group.image_pairs}
{assign var="gr_id" value=$group.group_id}
<tr class="cm-row-status-{$group.status|lower}">
    <td class="left">
        <input type="checkbox" name="group_ids[]" value="{$group.group_id}" class="cm-item" /></td>
    <td>
        <a href="{"configurator.update_group?group_id=`$gr_id`"|fn_url}">{$group.configurator_group_name}</a>
    </td>
    <td>
        <select name="configurator_group_data[{$group.group_id}][step_id]">
            <option value="0">-&nbsp;{__("none")}&nbsp;-</option>
            {foreach from=$all_steps item="step"}
                <option value="{$step.step_id}" {if $group.step_id == $step.step_id}selected="selected"{/if}>{$step.step_name}</option>
            {/foreach}
        </select></td>
    <td>
        <select name="configurator_group_data[{$group.group_id}][configurator_group_type]">
            <option value="S" {if $group.configurator_group_type == "S"}selected="selected"{/if}>{__("selectbox")}</option>
            <option value="R" {if $group.configurator_group_type == "R"}selected="selected"{/if}>{__("radiogroup")}</option>
            <option value="C" {if $group.configurator_group_type == "C"}selected="selected"{/if}>{__("checkbox")}</option>
        </select></td>
    <td class="nowrap center">
        <div class="hidden-tools">
            {capture name="tools_list"}
                <li>{btn type="list" text=__("edit") href="configurator.update_group?group_id=$gr_id"}</li>
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="configurator.delete_group?group_id=`$gr_id`"}</li>
            {/capture}
            {dropdown content=$smarty.capture.tools_list}
        </div>
        </td>
    <td>
        {include file="common/select_popup.tpl" id=$group.group_id prefix="group" status=$group.status hidden="" object_id_name="group_id" table="conf_groups" popup_additional_class="pull-right"}
    </td>
</tr>
{/foreach}
</tbody>
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_groups"}

{capture name="buttons"}
    {if $groups}
        {capture name="tools_list"}
            <li>{btn type="delete_selected" dispatch="dispatch[configurator.m_delete_groups]" form="configurator_groups_form"}</li>
        {/capture}
        {dropdown content=$smarty.capture.tools_list}

        {include file="buttons/save.tpl" but_name="dispatch[configurator.m_update_groups]" but_role="submit-link" but_target_form="configurator_groups_form"}
    {/if}
{/capture}

{capture name="adv_buttons"}
    {btn type="add" href="configurator.add_group" title=__("add_group")}

    {hook name="product_configurator_groups:list_extra_links"}
    {/hook}
{/capture}
</form>

<!--content_groups--></div>