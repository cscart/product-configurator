{if $oi.extra.configuration}
    {assign var="conf_price" value=$oi.price|default:"0"}
    {assign var="conf_subtotal" value=$oi.display_subtotal|default:"0"}
    {assign var="conf_discount" value=$oi.extra.discount|default:"0"}
    {assign var="conf_tax" value=$oi.tax_value|default:"0"}


    {assign var="_colspan" value=4}
    {assign var="c_oi" value=$oi}
    {foreach from=$order_info.products item="sub_oi"}
        {if $sub_oi.extra.parent.configuration && $sub_oi.extra.parent.configuration == $oi.cart_id}
            {capture name="is_conf"}1{/capture}
            {math equation="item_price + conf_price" item_price=$sub_oi.price|default:"0" conf_price=$conf_price assign="conf_price"}
            {math equation="discount + conf_discount" discount=$sub_oi.extra.discount|default:"0" conf_discount=$conf_discount assign="conf_discount"}
            {math equation="tax + conf_tax" tax=$sub_oi.tax_value|default:"0" conf_tax=$conf_tax assign="conf_tax"}
            {math equation="subtotal + conf_subtotal" subtotal=$sub_oi.display_subtotal conf_subtotal=$conf_subtotal|default:$oi.display_subtotal assign="conf_subtotal"}
        {/if}
    {/foreach}

    {assign var="option_key" value="gc_"|uniqid}

    <tr valign="top">
        <td>
            {if $smarty.capture.is_conf}
                <div class="pull-left">
                    <i id="on_{$option_key}" class="hand cm-combination exicon-expand"></i>
                    <i title="{__("collapse_sublist_of_items")}" id="off_{$option_key}" class="hand cm-combination hidden exicon-collapse"></i>
                </div>
            {/if}

            <a href="{"products.update?product_id=`$oi.product_id`"|fn_url}">{$oi.product}</a>
            {hook name="orders:product_info"}
                {if $oi.product_code}
                    <p>{__("sku")}:&nbsp;{$oi.product_code}</p>
                {/if}
            {/hook}
            {if $oi.product_options}
                <div class="options-info">
                    {include file="common/options_info.tpl" product_options=$oi.product_options}
                </div>
            {/if}
        </td>
        <td class="nowrap">{include file="common/price.tpl" value=$conf_price|default:0}</td>
        <td class="center">&nbsp;{$oi.amount}
            {if $settings.General.use_shipments == "Y" && $oi.shipped_amount > 0}
                <p><span class="small-note">(<span>{$oi.shipped_amount}</span>&nbsp;{__("shipped")})</span></p>
            {/if}
        </td>
        {if $order_info.use_discount}
        {assign var="_colspan" value=$_colspan+1}
        <td class="right nowrap">
            {include file="common/price.tpl" value=$conf_discount|default:0}</td>
        {/if}
        {if $order_info.taxes && $settings.General.tax_calculation != "subtotal"}
        {assign var="_colspan" value=$_colspan+1}
        <td class="nowrap">
            {include file="common/price.tpl" value=$conf_tax|default:0}</td>
        {/if}
        <td class="right">&nbsp;<span>{include file="common/price.tpl" value=$conf_subtotal|default:0}</span></td>
    </tr>
    {if $smarty.capture.is_conf}
    <tr class="row-more row-gray hidden" id="{$option_key}">
        <td colspan="{$_colspan}">
            <p>{__("configuration")}:</p>
            <table width="100%" class="table-condensed">
            <tr class="no-border">
                <th width="50%">{__("product")}</th>
                <th width="10%">{__("price")}</th>
                <th class="center" width="10%">{__("quantity")}</th>
                {if $order_info.use_discount}
                <th width="5%">{__("discount")}</th>
                {/if}
                {if $order_info.taxes && $settings.General.tax_calculation != "subtotal"}
                <th width="10%">{__("tax")}</th>
                {/if}
                <th class="right" width="10%">{__("subtotal")}</th>
            </tr>
            {foreach from=$order_info.products item="oi" key="sub_key"}
            {if $oi.extra.parent.configuration && $oi.extra.parent.configuration == $c_oi.cart_id}
            <tr valign="top">
                <td>
                    <a href="{"products.update?product_id=`$oi.product_id`"|fn_url}">{$oi.product|truncate:50:"...":true}</a>
                    {if $oi.product_code}
                    <p>{__("sku")}: {$oi.product_code}</p>
                    {/if}
                    {hook name="orders:product_info"}
                    {if $oi.product_options}<div style="padding-top: 1px; padding-bottom: 2px;">{include file="common/options_info.tpl" product_options=$oi.product_options}</div>{/if}
                    {/hook}
                </td>
                <td class="nowrap">
                    {include file="common/price.tpl" value=$oi.price}</td>
                <td class="center nowrap">
                    {$oi.amount}
                    {if $settings.General.use_shipments == "Y" && $oi.shipped_amount > 0}
                        <p><span class="small-note">(<span>{$oi.shipped_amount}</span>&nbsp;{__("shipped")})</span></p>
                    {/if}
                </td>
                {if $order_info.use_discount}
                <td class="right nowrap">
                    {if $oi.extra.discount|floatval}{include file="common/price.tpl" value=$oi.extra.discount}{else}-{/if}</td>
                {/if}
                {if $order_info.taxes && $settings.General.tax_calculation != "subtotal"}
                <td class="center nowrap">
                    {include file="common/price.tpl" value=$oi.tax_value}</td>
                {/if}
                <td class="right nowrap">
                    {include file="common/price.tpl" value=$oi.display_subtotal}</td>
            </tr>
            {/if}
            {/foreach}
            </table>
        </td>
    </tr>
    {/if}
{/if}