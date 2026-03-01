var is_mini_room = (room == rm_mini_1 || room == rm_mini_2 || room == rm_mini_3
                 || room == rm_mini_4 || room == rm_mini_5);
var is_ore_room  = (room == rm_coal || room == rm_diamond || room == rm_gold
                 || room == rm_opal || room == rm_uranium);
var is_mine_room = is_mini_room || is_ore_room;

// ── Ore rooms: HUD is drawn in obj_player Draw_0 (guaranteed to run there) ──
if (is_ore_room) exit;

// ──────── ORE MINE HUD (drawn inline — no function calls) ────────
if (false && is_ore_room) {
    var ore_key = global.current_mine;

    // Fallback: infer ore_key from room if global hasn't been set yet
    if (ore_key == "") {
        if (room == rm_coal)    ore_key = "coal";
        else if (room == rm_diamond) ore_key = "diamond";
        else if (room == rm_gold)    ore_key = "gold";
        else if (room == rm_opal)    ore_key = "opal";
        else if (room == rm_uranium) ore_key = "uranium";
    }
    if (ore_key == "") exit;

    var _ore   = variable_struct_get(global.ore_data,   ore_key);
    var _state = variable_struct_get(global.mine_state, ore_key);

    // Panel anchored to top-left of view (view is at 0,0)
    var px = 6;
    var py = 6;
    var pw = 260;
    var ph = 190;

    // Panel background
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(8, 6, 4));
    draw_rectangle(px, py, px + pw, py + ph, false);
    draw_set_alpha(1);

    // Coloured top-bar
    draw_set_color(_ore.color);
    draw_rectangle(px, py, px + pw, py + 22, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_text(px + pw * 0.5, py + 4, string_upper(_ore.display) + " MINE");

    var _ty = py + 28;
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(px + 8, _ty, "Money:  $" + string(floor(global.money)));
    _ty += 20;
    draw_text(px + 8, _ty, "HP:     " + string(global.player_hp) + " / " + string(global.player_hp_max));
    _ty += 20;
    draw_text(px + 8, _ty, "Pick:   " + global.pickaxe_names[global.pickaxe_tier]);
    _ty += 20;
    draw_text(px + 8, _ty, "Gun:    " + global.weapon_names[global.weapon_tier]);
    _ty += 20;

    // Worker row
    draw_set_color(c_white);
    draw_text(px + 8, _ty, "Worker: Lv." + string(_state.worker_level) + " / 5");
    _ty += 20;

    if (_state.worker_level > 0) {
        var _ipm = floor(_ore.output_pm * worker_multiplier(_state.worker_level));
        draw_set_color(c_lime);
        draw_text(px + 8, _ty, "Income: $" + string(_ipm) + " / min");
    } else {
        draw_set_color(c_ltgray);
        draw_text(px + 8, _ty, "No worker hired.");
    }
    _ty += 20;

    // U-key hint
    if (_state.worker_level < 5) {
        var _wc = worker_upgrade_cost(_state.worker_level);
        var _lbl = (_state.worker_level == 0) ? "Hire" : "Upgrade";
        if (global.money >= _wc) {
            draw_set_color(c_yellow);
            draw_text(px + 8, _ty, "[ U ]  " + _lbl + " Worker  ($" + string(_wc) + ")");
        } else {
            draw_set_color(c_ltgray);
            draw_text(px + 8, _ty, "[ U ]  " + _lbl + "  ($" + string(_wc) + ")  [no funds]");
        }
    } else {
        draw_set_color(c_lime);
        draw_text(px + 8, _ty, "Worker MAX level!");
    }
    draw_set_halign(fa_left);
    draw_set_alpha(1);

    // Worker feedback toast
    if (variable_global_exists("worker_msg_timer") && global.worker_msg_timer > 0) {
        var _a = min(1.0, global.worker_msg_timer / 30.0);
        draw_set_alpha(_a);
        var _msg = global.worker_msg;
        var _mw = string_width(_msg) + 28;
        var _mh = 32;
        var _mx = (room_width  - _mw) * 0.5;
        var _my = room_height  * 0.72;
        var _isbad = (string_pos("Not enough", _msg) > 0 || string_pos("max level", _msg) > 0);
        draw_set_color(_isbad ? make_color_rgb(120, 10, 10) : make_color_rgb(10, 80, 10));
        draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
        draw_set_color(_isbad ? c_red : c_lime);
        draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(room_width * 0.5, _my + 8, _msg);
        draw_set_halign(fa_left);
        draw_set_alpha(1);
    }

    exit;
}

// ──────── MINI MANAGEMENT SCREEN ────────
if (is_mini_room) {
    var ore_key = global.current_mine;
    if (ore_key == "") exit;

    var ore   = variable_struct_get(global.ore_data,  ore_key);
    var state = variable_struct_get(global.mine_state, ore_key);

    // Background
    draw_set_color(ore_get_bg_color(ore_key));
    draw_rectangle(0, 0, room_width, room_height, false);

    // Decorative rock pattern
    draw_set_alpha(0.08);
    draw_set_color(c_white);
    var seed = 42;
    for (var ri = 0; ri < 40; ri++) {
        var rx = (seed * 73 + ri * 137) mod room_width;
        var ry = (seed * 31 + ri *  97) mod room_height;
        draw_circle(rx, ry, 12 + (ri mod 8), true);
    }
    draw_set_alpha(1);

    var cx = room_width * 0.5;

    draw_set_color(ore.color);
    draw_set_halign(fa_center);
    draw_text(cx, 28, "=== " + string_upper(ore.display) + " MINE ===");

    var ore_spr = asset_get_index("spr_" + ore_key);
    if (ore_spr >= 0) {
        var sw   = sprite_get_width(ore_spr);
        var sh   = sprite_get_height(ore_spr);
        var disp = 96.0 / max(sw, sh);
        var glow_a = 0.25 + sin(current_time * 0.002) * 0.15;
        draw_set_alpha(glow_a);
        draw_set_color(ore.color);
        draw_circle(cx, 138, 58, false);
        draw_set_alpha(1);
        draw_sprite_ext(ore_spr, 0, cx - sw * disp * 0.5, 90, disp, disp, 0, c_white, 1);
    }

    draw_set_alpha(0.80);
    draw_set_color(make_color_rgb(18, 14, 10));
    draw_rectangle(50, 232, room_width - 50, 520, false);
    draw_set_alpha(1);

    var income_pm = 0;
    if (state.worker_level > 0) {
        income_pm = floor(ore.output_pm * worker_multiplier(state.worker_level));
    }

    draw_set_color(c_white);
    draw_text(cx, 248, "Worker Level:  " + string(state.worker_level) + " / 5");

    if (state.worker_level > 0) {
        draw_set_color(c_lime);
        draw_text(cx, 274, "Income: $" + string(income_pm) + " / min");
    } else {
        draw_set_color(c_ltgray);
        draw_text(cx, 274, "No worker hired yet.");
    }

    var ty2 = 316;
    if (state.worker_level < 5) {
        var cost = worker_upgrade_cost(state.worker_level);
        if (global.money >= cost) {
            draw_set_color(c_yellow);
            if (state.worker_level == 0) {
                draw_text(cx, ty2, "[ U ]  Hire Worker  ($" + string(cost) + ")");
            } else {
                draw_text(cx, ty2, "[ U ]  Upgrade Worker  ($" + string(cost) + ")");
                draw_set_color(c_ltgray);
                draw_text(cx, ty2 + 28,
                    "Next: $" + string(floor(ore.output_pm * worker_multiplier(state.worker_level + 1))) + " / min");
            }
        } else {
            draw_set_color(c_red);
            draw_text(cx, ty2, "Need $" + string(cost) + " to upgrade");
            draw_set_color(c_ltgray);
            draw_text(cx, ty2 + 28, "(you have $" + string(floor(global.money)) + ")");
        }
    } else {
        draw_set_color(c_lime);
        draw_text(cx, ty2, "Worker fully upgraded! (Max)");
    }

    draw_set_color(make_color_rgb(120, 120, 120));
    draw_text(cx, 720, "[ ESC ]  Return to Mine");
    draw_set_halign(fa_left);
    exit;
}

// ──────── NORMAL HUD (mining area + hub) ────────
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(6, 6, 218, 194, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var ty = 12;
draw_text(12, ty, "Money: $" + string(floor(global.money)));  ty += 22;
draw_text(12, ty, "HP: "    + string(global.player_hp) + "/" + string(global.player_hp_max)); ty += 22;
draw_text(12, ty, "Pick: "  + global.pickaxe_names[global.pickaxe_tier]); ty += 22;
draw_text(12, ty, "Gun: "   + global.weapon_names[global.weapon_tier]);   ty += 22;

var total_pm = 0;
var _keys = ore_keys();
for (var _i = 0; _i < array_length(_keys); _i++) {
    var _k  = _keys[_i];
    var _st = variable_struct_get(global.mine_state, _k);
    if (_st.unlocked && _st.worker_level > 0) {
        var _ore = variable_struct_get(global.ore_data, _k);
        total_pm += floor(_ore.output_pm * worker_multiplier(_st.worker_level));
    }
}
if (total_pm > 0) {
    draw_set_color(c_lime);
    draw_text(12, ty, "Income: $" + string(total_pm) + "/min");
}
ty += 20;

// ── Upgrade key hints ──
var _pk_costs = [35, 80, 150];
var _wp_costs = [40, 80, 90];
if (global.pickaxe_tier < 3) {
    draw_set_color(make_color_rgb(220, 220, 100));
    draw_text(12, ty, "[ P ] Pick: " + global.pickaxe_names[global.pickaxe_tier + 1] + " ($" + string(_pk_costs[global.pickaxe_tier]) + ")");
} else {
    draw_set_color(c_lime);
    draw_text(12, ty, "Pickaxe: MAX");
}
ty += 18;
if (global.weapon_tier < 3) {
    draw_set_color(make_color_rgb(220, 220, 100));
    draw_text(12, ty, "[ O ] Gun: " + global.weapon_names[global.weapon_tier + 1] + " ($" + string(_wp_costs[global.weapon_tier]) + ")");
} else {
    draw_set_color(c_lime);
    draw_text(12, ty, "Gun: MAX");
}

// ── Toast (upgrade / worker feedback) ──
if (global.worker_msg_timer > 0) {
    var _ta  = min(1.0, global.worker_msg_timer / 30.0);
    draw_set_alpha(_ta);
    var _msg = global.worker_msg;
    var _mw  = string_width(_msg) + 28;
    var _mh  = 32;
    var _mx  = (room_width  - _mw) * 0.5;
    var _my  = room_height  * 0.72;
    var _isbad = (string_pos("Need", _msg) > 0 || string_pos("maxed", _msg) > 0
               || string_pos("Not enough", _msg) > 0 || string_pos("already", _msg) > 0
               || string_pos("max level", _msg) > 0);
    draw_set_color(_isbad ? make_color_rgb(120, 10, 10) : make_color_rgb(10, 80, 10));
    draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
    draw_set_color(_isbad ? c_red : c_lime);
    draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(room_width * 0.5, _my + 8, _msg);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}
draw_set_color(c_white);

