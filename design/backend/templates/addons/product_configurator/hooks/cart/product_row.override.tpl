{if $product.item_type == "P" && $product.extra.extra.configuration}
    <tr>
        <td>
            <a href="{"products.update?product_id=`$product.product_id`"|fn_url}">{$product.product nofilter}</a>
        </td>
        {if $show_price}
            <td class="center">{$product.amount}</td>
            <td class="right">{include file="common/price.tpl" value=$product.price span_id="c_`$customer.user_id`_$product.item_id"}</td>
        {/if}
    </tr>
    <tr><td {if $show_price}colspan="3"{/if}>
        <table cellpadding="0" cellspacing="0" border="0" width="90%" class="table margin-bottom" align="center">
        <tr>
            <th width="100%">{__("product")}</th>
            {if $show_price}
                <th class="center">{__("quantity")}</th>
                <th class="right">{__("price")}</th>
            {/if}
        </tr>
        {foreach from=$products item="_product"}
            {if $_product.extra.extra.parent.configuration && $_product.extra.extra.parent.configuration == $product.item_id}
            <tr>
                <td>
                    <a href="{"products.update?product_id=`$_product.product_id`"|fn_url}">{$_product.product nofilter}</a>
                </td>
                {if $show_price}
                    <td class="center">{$_product.amount}</td>
                    <td class="right">{include file="common/price.tpl" value=$_product.price span_id="c_`$customer.user_id`_$_product.item_id"}</td>
                {/if}
            </tr>
            {/if}
        {/foreach}
        </table>
    </td></tr>
{/if}