//var compatible_classes = {};
var error_message = 0;
var product_class = 0;
var compatible = {};
var group_has_selected = 0;
var current_step_id = 0;
var forbidden_groups = {}; // This variable will be used for hierarchical analysis of compatibilities

//
// Check required product for the step
//
function fn_check_required_products(step_id, show_section)
{
    for (var groups_ in conf[step_id]) {
        var selected_product = fn_define_selected_product(step_id, groups_);
        if (conf[step_id][groups_]['required'] == 'Y' && selected_product == false) {
            if (show_section == 'Y') {
                fn_alert(Tygh.tr('text_required_group_product').replace('[group_name]', conf[step_id][groups_]['name']));
            }
            return false;
        }
    }
    return true;
}

//
// Check whole configurable product for all required groups has selected products
//
function fn_check_all_steps()
{
    for (var step_id in conf) {
        if (fn_check_required_products(step_id, 'N') == false) {
            return false;
        }
    }
    return true;
}

//
// Check if user can go to the section
//
function fn_check_step(new_step_id)
{
    // If we use the "Next" button then find out the new section
    var $ = Tygh.$;
    var step_id = current_step_id;
    var get_next = false;
    var i;

    var sections = $('#tabs_configurator > li');
    for (i = 0; i < sections.length; i++) {
        if (!new_step_id) {
            if (get_next == true) {
                new_step_id = sections.eq(i).prop('id');
                get_next = false;
            }
            if (sections.eq(i).prop('id') == step_id) {
                get_next = true;
            }
        }
    }
    var j = sections.eq(i - 1).prop('id');

    // Check whether all required groups have products
    if (fn_check_required_products(step_id, 'Y') == false) {
        return false;
    }

    // if the last section is selected then hide the "Next" button, and show "Add to cart" button
    if (new_step_id == j) {
        $('#next_button').toggleBy(true);
        var sh = fn_check_all_steps();
        $('#pconf_buttons_block').toggleBy(!sh);
    } else {
        $('#next_button').toggleBy(false);
    }

    fn_swith_configurator_tabs(new_step_id);
    current_step_id = new_step_id;
    return true;
}

function fn_swith_configurator_tabs(tab_id)
{
    var $ = Tygh.$;
    $('#tabs_configurator > li').each(function()
    {
        $(this).removeClass('active');
        $('#content_' + $(this).prop('id')).hide();
    });

    $('#' + tab_id).addClass('active');
    $('#content_' + tab_id).show();
}

function fn_change_visibillyty(group_id, product_id, enabled)
{
    var $ = Tygh.$;
    if (enabled) {
        $('#group_' + group_id + '_product_' + product_id + ':not(.cm-configurator-disabled)').prop('disabled', true);
        $('#group_' + group_id + '_product_' + product_id + ':not(.cm-configurator-disabled)').prop('checked', false);
        $('#group_' + group_id + '_product_' + product_id + ':not(.cm-configurator-disabled)').prop('selected', false);
    } else {
        $('#group_' + group_id + '_product_' + product_id + ':not(.cm-configurator-disabled)').prop('disabled', false);
    }
}

// ************************************************** C O M P A T I B I L I T I E S ****************************************/
//
// Check all compatibilities
//
function fn_check_all_compatibilities()
{
    var $ = Tygh.$;
    for (var step_id in conf) {
        for (var group_id in conf[step_id]) {
            var selected_product = fn_define_selected_product(step_id, group_id);

            // If any product is selected then define compatibilities for it
            if (selected_product != false && selected_product.indexOf(':') != -1 && free_rec == 0) {
                do {
                    fn_check_compatibilities(group_id, selected_product.substring(0, selected_product.indexOf(':')), conf[step_id][group_id]['type'], false);
                    selected_product = selected_product.substr(selected_product.indexOf(':')+1);
                } while (selected_product.indexOf(':') != -1);
            } else if (selected_product != false && free_rec == 0) {
                fn_check_compatibilities(group_id, selected_product, conf[step_id][group_id]['type'], false);
            }
        }
    }
    // Check whether refresh was clicked on thу last step
    var s_section = $('#tabs_configurator > li.active').prop('id');
    if (s_section == step_id) {
        $('#next_button').toggleBy(true);
    }
    var sh = fn_check_all_steps();
    $('#pconf_buttons_block').toggleBy(!sh);
} 

//
// Check compatibilities for the selected product, update price and show/hide buttons
//
function fn_check_compatibilities(group_id, product_id, type)
{
    var $ = Tygh.$;
    var initial_product_id = [];

    // Define configuration products
    if (type == 'S' && $('#group_'+group_id).val()) {
        initial_product_id = [$('#group_'+group_id).val()];
    } else if (type == 'R' && product_id) {
        initial_product_id = [product_id];
    } else if (type == 'C') {
        for (var k in conf_prod[group_id]) {
            if ($('#group_' + group_id + '_product_' + k).prop('checked') == true) {
                initial_product_id.push(k);
            }
        }
    }

    // Hide selectbox 'details' link if 'none' option selected
    var detail_link_holder = $('#select_' + group_id);
    if (detail_link_holder.length) {
        $('a', detail_link_holder).hide();
        if (type == 'S' && initial_product_id) {
            $('#opener_description_' + group_id + '_' + initial_product_id, detail_link_holder).show();
        }
    }
    
    // Enable all products in selected group
    $('[id*=group_' + group_id + '_]:not(.cm-configurator-disabled)').prop('disabled', false);
    $('[id=group_' + group_id + ']:not(.cm-configurator-disabled) option:not(.cm-configurator-disabled)').prop('disabled', false);
    
    $.ceAjax('request', fn_url('products.compability?product_id=' + initial_product_id + '&group_id='+group_id), {
        hidden: true,
        method: 'get',
        callback: function(data) {
            for (var i in data.available) {
                fn_change_visibillyty(data.available[i].group_id, data.available[i].product_id, false);
            }
            
            for (i in data.unavailable) {
                fn_change_visibillyty(data.unavailable[i].group_id, data.unavailable[i].product_id, true);
            }

            var sh = fn_check_all_steps();
            Tygh.$('#pconf_buttons_block').toggleBy(!sh);
        }
    });
}

//
// This defines the selected product in the current group
//
function fn_define_selected_product(step_id, group_id)
{
    var $ = Tygh.$;
    var selected_product = false;
    // Define which product is selected in the group
    if ($('#group_one_'+group_id).length) { // This means that this group contains only one product and is should be selected
        selected_product = $('#group_one_'+group_id).val();

    } else if (conf[step_id][group_id]['type'] == 'S') {
        selected_product = $('#group_'+group_id).val();

    } else if (conf[step_id][group_id]['type'] == 'R') {
        selected_product = $('input[type=radio]:checked', '#group_' + group_id).val();

    } else if (conf[step_id][group_id]['type'] == 'C') {
        $('input[type=checkbox]:checked', '#group_' + group_id).each(function(){
            if (selected_product == false) {
                selected_product = '';
            }
            selected_product += $(this).val() + ':';
        });
    }

    if (typeof(selected_product) == 'undefined') {
        selected_product = false;
    }
    return selected_product;
}

Tygh.$(document).ready(function(){
    var $ = Tygh.$;
    var id = $('[id*=group_]:checked:first').prop('id');
    if (id != null) {
        re = /group_(\d+)_product_(\d+)/i;
        found = id.match(re);
        fn_check_compatibilities(found[1], found[2], fn_get_type($('#' + id)));
    }
    
    $(Tygh.doc).on('keypress', '[id*=qty_count]', function(event) {
        if (event.which == 13) {
            return fn_check_all_steps();
        }
    });
});

function fn_get_type(element)
{
    if (element.prop('type') == 'checkbox') {
        return 'C';
    } else if (element.prop('type') == 'radio') {
        return 'R';
    }
    return 'S';
}