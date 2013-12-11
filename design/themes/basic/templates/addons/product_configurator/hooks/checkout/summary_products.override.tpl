{if $cart.products.$key.extra.configuration}
{if $smarty.capture.prods}
    <hr class="dark-hr" />
{else}
    {capture name="prods"}Y{/capture}
{/if}

<div class="clearfix">
    <a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="product-title">{$product.product nofilter}</a>
    <p class="step-complete-wrapper">{__("sku")}: {$product.product_code}</p>
    {include file="common/options_info.tpl" product_options=$product.product_options no_block=true}

    {foreach from=$cart_products item="_product" key="key_conf"}
        {if $cart.products.$key_conf.extra.parent.configuration == $key}
            {capture name="is_conf_prod"}1{/capture}
        {/if}
    {/foreach}

    {if $smarty.capture.is_conf_prod}
        <p><strong>{__("configuration")}:</strong></p>
        
        <table style="width: 85%" class="table margin-top">
        <tr>
            <th style="width: 50%">{__("product")}</th>
            <th style="width: 10%">{__("price")}</th>
            <th style="width: 10%">{__("quantity")}</th>
            <th class="right" style="width: 10%">{__("subtotal")}</th>
        </tr>
        {foreach from=$cart_products item="_product" key="key_conf"}
        {if $cart.products.$key_conf.extra.parent.configuration == $key}
        <tr {cycle values=",class=\"table-row\""}>
            <td>{if $_product.is_accessible}<a href="{"products.view?product_id=`$_product.product_id`"|fn_url}">{$_product.product}</a>{else}{$_product.product}{/if}</td>
            <td class="center">
                {include file="common/price.tpl" value=$_product.price}</td>
            <td class="center">
                <input type="hidden" name="cart_products[{$key_conf}][product_id]" value="{$_product.product_id}" />
                {$_product.amount}
            </td>
            <td class="right">
                {include file="common/price.tpl" value=$_product.display_subtotal}</td>
        </tr>
        {/if}
        {/foreach}
        <tr class="table-footer">
            <td colspan="4">&nbsp;</td>
        </tr>
        </table>
    {/if}
</div>
{/if}