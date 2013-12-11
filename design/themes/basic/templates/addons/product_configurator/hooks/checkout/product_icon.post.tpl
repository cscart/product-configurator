{if $cart.products.$key.extra.configuration}
<p class="center">
    {include file="buttons/button.tpl" but_text=__("edit") but_href="products.view?product_id=`$product.product_id`&cart_id=`$key`" but_role="text"}
</p>
{/if}