{if $product.extra.configuration}
<div class="product-notification-item clearfix">
{include file="common/image.tpl" image_width="50" image_height="50" images=$product.main_pair no_ids=true class="product-notification-image"}
    <div class="product-notification-content clearfix">
        <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product_id|fn_get_product_name}</a>
        <div class="product-notification-price">
            {$product.amount}&nbsp;x&nbsp;{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`" class="none"}
        </div>
        <ul>
            {if $product.product_option_data}
                <li>{include file="common/options_info.tpl" product_options=$product.product_option_data}</li>
            {/if}
            <li><ul>
            {foreach from=$added_products item="_product" key="_key"}
                {if $_product.extra.parent.configuration == $key}
                    <li>
                        {if $_product.is_accessible}
                            <a href="{"products.view?product_id=`$_product.product_id`"|fn_url}">{$_product.product_id|fn_get_product_name}</a>
                        {else}
                            {$_product.product_id|fn_get_product_name}
                        {/if}
                        <div class="product-notification-price">
                            {$_product.amount}&nbsp;x&nbsp;{include file="common/price.tpl" value=$_product.display_price span_id="price_`$_key`" class="none"}
                        </div>
                    </li>
                    {if $_product.product_option_data}
                        <li>{include file="common/options_info.tpl" product_options=$_product.product_option_data}</li>
                    {/if}
                {/if}
            {/foreach}
            </ul></li>
        </ul>
    </div>
</div>
{elseif $product.extra.parent.configuration}
    &nbsp;
{/if}