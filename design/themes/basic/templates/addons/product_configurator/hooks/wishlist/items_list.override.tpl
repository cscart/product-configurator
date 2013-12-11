{if $wishlist.products.$key.extra.configuration}
    <form {if !$config.tweaks.disable_dhtml && !$no_ajax}class="cm-ajax"{/if} action="{""|fn_url}" method="post" name="{$form_prefix}productform_{$key}" enctype="multipart/form-data">
    <input type="hidden" name="result_ids" value="cart_status*" />
    <input type="hidden" name="product_data[{$key}][product_id]" value="{$product.product_id}" />
    <input type="hidden" name="product_data[{$key}][amount]" value="1" />

    {foreach from=$wishlist.products.$key.extra.configuration key="g_id" item="p_id"}
    {if $p_id|is_array}
    {foreach from=$p_id item="p"}
    <input type="hidden" name="product_data[{$key}][configuration][{$g_id}][]" value="{$p}" />
    {/foreach}
    {else}
    <input type="hidden" name="product_data[{$key}][configuration][{$g_id}]" value="{$p_id}" />
    {/if}
    {/foreach}

    {if $show_hr}
    <hr />
    {else}
        {assign var="show_hr" value=true}
    {/if}

    <div class="product-container clearfix">
        <div class="product-image cm-reload-{$key}" id="image_update_{$key}">
            <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{include file="common/image.tpl" image_width=$settings.Thumbnails.product_lists_thumbnail_width image_height=$settings.Thumbnails.product_lists_thumbnail_height obj_id=$key images=$product.main_pair}</a>
        <!--image_update_{$key}--></div>
        <div class="product-description">
            <a href="{"products.view?product_id=`$product.product_id`"|fn_url}" class="product-title">{$product.product nofilter}</a>&nbsp;<a href="{"wishlist.delete?cart_id=`$key`"|fn_url}" class="icon-delete-big" title="{__("remove")}"><i class="icon-cancel-circle"></i></a>

            <p class="sku{if !$product.product_code} hidden{/if}" id="sku_{$key}">{__("sku")}: <span class="cm-reload-{$key}" id="product_code_update_{$key}">{$product.product_code}<!--product_code_update_{$key}--></span></p>

            <span class="cm-reload-{$key}" id="product_options_update_{$key}">
                <input type="hidden" name="appearance[wishlist]" value="1" />
                {include file="views/products/components/product_options.tpl" product_options=$product.product_options product=$product name="product_data" id=$key location="cart"}
            <!--product_options_update_{$key}--></span>

            <p><strong>{__("configuration")}:</strong></p>
            
            <span class="cm-reload-{$key}" id="configuration_update_{$key}">
            <table style="width: 85%" class="table">
            <tr>
                <th style="width: 50%">{__("product")}</th>
                <th style="width: 10%">{__("price")}</th>
                <th style="width: 10%">{__("quantity")}</th>
                <th class="right" style="width: 10%">{__("subtotal")}</th>
            </tr>
            {foreach from=$products item="product_conf" key="key_conf"}
            {if $wishlist.products.$key_conf.extra.parent.configuration == $key}
            <tr {cycle values=",class=\"table-row\""}>                
                <td><a href="{"products.view?product_id=`$product_conf.product_id`"|fn_url}">{$product_conf.product}</a></td>
                <td class="center nowrap">
                    {include file="common/price.tpl" value=$product_conf.price}&nbsp;&nbsp;</td>
                <td>{$product_conf.display_amount}</td>
                <td class="center nowrap">
                    {include file="common/price.tpl" value=$product_conf.display_subtotal}&nbsp;&nbsp;</td>
                {math equation="item_price + conf_" item_price=$product_conf.display_subtotal|default:"0" conf_=$conf_price|default:"0" assign="conf_price"}
            </tr>
            {/if}
            {/foreach}
            <tr {cycle values="class=\"table-row\","}>
                <td colspan="4"><hr /></td>
            </tr>
            <tr {cycle values=",class=\"table-row\""}>
                <td colspan="3"><strong>{__("product_summary")}:</strong></td>
                <td class="center">
                    {assign var="obj_id" value=$key}
                    {hook name="products:prices_block"}
                        {math equation="item_price + conf_" item_price=$product.price|default:"0" conf_=$conf_price|default:"0" assign="conf_price"}
                        <strong>{include file="common/price.tpl" value=$conf_price}</strong>
                    {/hook}
                </td>
            </tr>
            <tr class="table-footer">
                <td colspan="3">&nbsp;</td>
            </tr>
            </table>

            {hook name="products:product_option_content"}
            {/hook}
            <!--configuration_update_{$key}--></span>

            {if !($product.zero_price_action == "R" && $product.price == 0) && !($settings.General.inventory_tracking == "Y" && $product.amount <= 0 && $product.is_edp != "Y" && $product.tracking == "B")}
            <div class="buttons-container">
                {include file="buttons/add_to_cart.tpl" but_name="dispatch[checkout.add]" but_role="action"}
            </div>
            {/if}
        </div>
    </div>
    </form>
{/if}