<div class="control-group">
    <label for="configurable" class="control-label">{__("configurable")}:</label>
    <div class="controls">
    	<select name="configurable" id="configurable">
    	    <option value="">--</option>
    	    <option value="C" {if $search.configurable == "C"}selected="selected"{/if}>{__("yes")}</option>
    	    <option value="P" {if $search.configurable == "P"}selected="selected"{/if}>{__("no")}</option>
    	</select>
    </div>
</div>