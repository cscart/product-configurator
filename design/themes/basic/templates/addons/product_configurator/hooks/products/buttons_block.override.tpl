{if $product.product_type == "C" && !$product.configuration_mode}
    {if $quick_view}
        {assign var="but_role" value="big"}
    {elseif $but_role == "action"}
        {assign var="but_role" value="action"}
    {else}
        {assign var="but_role" value="text"}
    {/if}
    <div class="qv-buttons-container">{include file="buttons/button.tpl" but_text=__("configure") but_role=$but_role but_href="products.view?product_id=`$product.product_id`"}</div>
{/if}