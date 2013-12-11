<div id="content_classes">

<form action="{""|fn_url}" method="post" name="classes_form" enctype="multipart/form-data">

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order":"selected_section"}
{assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
{assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}

<div id="pagination_classes">

{if $classes}
<table class="table table-middle sortable hidden-inputs">
<thead>
    <tr>
        <th class="left" width="5%">
            {include file="common/check_items.tpl"}</th>
        <th width="25%">
            <a class="cm-ajax{if $search.sort_by == "class_name"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=class_name&sort_order=`$search.sort_order_rev`&selected_section=classes"|fn_url}" data-ca-target-id="pagination_classes">
                {__("name")} {if $search.sort_by == "class_name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="50%">
            <a class="cm-ajax{if $search.sort_by == "group_name"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=group_name&sort_order=`$search.sort_order_rev`&selected_section=classes"|fn_url}" data-ca-target-id="pagination_classes">
                {__("group")} {if $search.sort_by == "group_name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
        <th width="10%">&nbsp;</th>
        <th width="10%" class="right">
            <a class="cm-ajax{if $search.sort_by == "status"} sort-link-{$search.sort_order_rev}{/if}" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`&selected_section=classes"|fn_url}" data-ca-target-id="pagination_classes">
                {__("status")} {if $search.sort_by == "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}
            </a>
        </th>
    </tr>
</thead>
{foreach from=$classes item=pclass}
    {assign var="cls_id" value=$pclass.class_id}
<tr class="cm-row-status-{$pclass.status|lower}">
    <td class="left"><input type="checkbox" name="class_ids[]" value="{$pclass.class_id}" class="cm-item"></td>
    <td class="nowrap">
        <a href="{"configurator.update_class?class_id=`$cls_id`"|fn_url}">{$pclass.class_name}</a>
    </td>
    <td class="nowrap">
        <select name="class_data[{$pclass.class_id}][group_id]">
            <option value="0">-&nbsp;{__("none")}&nbsp;-</option>
            {foreach from=$all_groups item="group"}
            <option value="{$group.group_id}" {if $pclass.group_id == $group.group_id}selected="selected"{/if}>{$group.configurator_group_name}</option>
            {/foreach}
        </select>
    </td>
    <td class="nowrap center">
        <div class="hidden-tools">
            {capture name="tools_list"}
                <li>{btn type="list" text=__("edit") href="configurator.update_class?class_id=$cls_id"}</li>
                <li>{btn type="list" class="cm-confirm" text=__("delete") href="configurator.delete_class?class_id=`$pclass.class_id`"}</li>
            {/capture}
            {dropdown content=$smarty.capture.tools_list}
        </div>
    </td>
    <td class="right">
        {include file="common/select_popup.tpl" id=$pclass.class_id prefix="class" status=$pclass.status hidden="" object_id_name="class_id" table="conf_classes"}
    </td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

<!--pagination_classes--></div>

{capture name="buttons"}
    {if $classes}
        {capture name="tools_list"}
            <li>{btn type="delete_selected" dispatch="dispatch[configurator.m_delete_classes]" form="classes_form"}</li>
        {/capture}
        {dropdown content=$smarty.capture.tools_list}

        {include file="buttons/save.tpl" but_name="dispatch[configurator.m_update_classes]" but_role="submit-link" but_target_form="classes_form"}
    {/if}
{/capture}

{capture name="adv_buttons"}
    {btn type="add" title=__("add_product_class") href="configurator.add_class"}
{/capture}

</form>

<!--content_classes--></div>