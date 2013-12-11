{if $navigation.tabs}
<div class="tabs clearfix">
    <ul {if $tabs_section}id="tabs_{$tabs_section}"{/if}>
    {foreach from=$navigation.tabs item=tab key=key name=tabs}
        {if (!$tabs_section && !$tab.section) || ($tabs_section == $tab.section)}
        <li id="{$key}" class="cm-js{if $key == $active_tab} active{/if}" onclick="fn_check_step('{$key}');"><a>{$tab.title}</a></li>
        {/if}
    {/foreach}
    </ul>
</div>
<div class="cm-tabs-content tabs-content clearfix">
    {$content nofilter}
</div>

{else}
    {$content nofilter}
{/if}