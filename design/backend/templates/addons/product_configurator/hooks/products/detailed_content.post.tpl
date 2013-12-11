{include file="common/subheader.tpl" title=__("product_configurator") target="#product_configurator_product_settings"}
	<div id="product_configurator_product_settings" class="in collapse">
		<fieldset>
		    <div class="control-group">
		        <label for="product_product_type" class="control-label">{__("configurable")}:</label>
		        <div class="controls">
		        	<input type="hidden" name="product_data[product_type]" value="">
		        	<input type="checkbox" name="product_data[product_type]" id="product_product_type" value="C" {if $product_data.product_type == "C" || $smarty.request.product_type == "C"}checked="checked"{/if}>
		        </div>
		    </div>
		</fieldset>
	</div>