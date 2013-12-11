<div id="content_description_{$group_id}_{$product.product_id}">
{script src="js/tygh/exceptions.js"}

<div class="clearfix">
    {assign var="id" value=$product.product_id}
    <div class="product-image border-image-wrap">
        {include file="common/image.tpl" show_detailed_link=true obj_id=$product.product_id images=$product.main_pair image_id="pconf_product_image_`$product.product_id`" image_width=$settings.Thumbnails.product_details_thumbnail_width image_height=$settings.Thumbnails.product_details_thumbnail_height}
    </div>
    
    <div class="product-description">
        {if $product.product_code}
        <p class="sku">{__("sku")}: {$product.product_code}</p>
        {/if}
        {************************ Discounted Price, Our Price, Price ********************}
        {if $product.price|floatval || $product.zero_price_action == "P"}
            <span class="price{if !$product.price|floatval} hidden{/if}" id="line_discounted_price_{$product.product_id}">{__("price")}: {include file="common/price.tpl" value=$product.price span_id="discounted_price_`$product.product_id`" class="price"}</span>
        {elseif $product.zero_price_action == "R"}
            <span class="no-price">{__("contact_us_for_price")}</span>
        {/if}

        {if $product.tax != ""}
            &nbsp;({__("including_tax")}&nbsp;{include file="common/price.tpl" value=$product.tax})
        {/if}
    </div>
</div>

{if $product.full_description || $product.short_description}
    <div class="tabs cm-j-tabs clearfix">
        <ul>
            <li id="description" class="cm-js active"><a>{__("description")}</a></li>
        </ul>
    </div>
    
    <div id="tabs_content" class="cm-tabs-content tabs-content clearfix">
        <div id="content_description" class="wysiwyg-content">
            {$product.full_description|default:$product.short_description nofilter}
        </div>
    </div>
{/if}

{include file="common/previewer.tpl"}
<!--content_description_{$group_id}_{$product.product_id}--></div>