{capture name="mainbox"}

	{capture name="tabsbox"}
		{if $selected_section == "groups"}
		    {include file="addons/product_configurator/views/configurator/components/product_groups.tpl"}

		{elseif $selected_section == "classes"}
		    {include file="addons/product_configurator/views/configurator/components/product_classes.tpl"}

		{elseif $selected_section == "steps"}
		    {include file="addons/product_configurator/views/configurator/components/steps.tpl"}    
		{/if}
	{/capture}

	{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$selected_section}

{/capture}

{capture name="sidebar"}
	<div class="sidebar-row">
		<h6>{__("choose_action")}</h6>
		<ul class="nav nav-list">
			<li><a href="{"products.manage?type=extended&configurable=C"|fn_url}">{__("all_configurable")}</a></li>
			<li><a href="{"products.add?product_type=C"|fn_url}">{__("add_configurable_product")}</a></li>
		</ul>
    </div>
    <hr>
{/capture}

{include file="common/mainbox.tpl" title=__("product_configurator") content=$smarty.capture.mainbox select_languages=true buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons sidebar=$smarty.capture.sidebar}