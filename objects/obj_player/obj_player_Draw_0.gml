// Draw player sprite (sprite origin 0,0 -> offset to center it)
var disp_w = sprite_get_width(spr_player)  * image_xscale;
var disp_h = sprite_get_height(spr_player) * image_yscale;
draw_sprite_ext(spr_player, 0, x - disp_w * 0.5, y - disp_h * 0.5,
                image_xscale, image_yscale, 0, c_white, 1);

// Draw pickaxe + progress bar while mining
if (mine_target != noone && instance_exists(mine_target)) {
    var tier   = global.pickaxe_tier;
    var pk_spr = spr_pickaxe_silver;
    if (tier == 2) pk_spr = spr_pickaxe_gold;
    if (tier >= 3) pk_spr = spr_pickaxe_diamond;

    var prog  = mine_timer / mine_duration;
    var swing = sin(prog * pi) * 45;

    // Point toward the centre of the target block
    var tx    = mine_target.x + sprite_get_width(mine_target.sprite_index)  * mine_target.image_xscale * 0.5;
    var ty    = mine_target.y + sprite_get_height(mine_target.sprite_index) * mine_target.image_yscale * 0.5;
    var base_a = point_direction(x, y, tx, ty);

    // Pickaxe scale reduced by 20 % from original 0.035
    var pk_sc = 0.028;
    draw_sprite_ext(pk_spr, 0, x, y, pk_sc, pk_sc, base_a + swing, c_white, 1);

    // Loading bar
    var bx = mine_target.x + 8;
    var by = mine_target.y - 10;
    draw_set_color(c_dkgray);
    draw_rectangle(bx - 16, by - 4, bx + 16, by + 4, false);
    draw_set_color(c_lime);
    draw_rectangle(bx - 16, by - 4, bx - 16 + 32 * prog, by + 4, false);
    draw_set_color(c_white);
}

// ──────── ORE ROOM HUD (drawn here because player Draw is always active) ────────
var _is_ore_room = (room == rm_coal || room == rm_diamond || room == rm_gold
                 || room == rm_opal || room == rm_uranium);
if (_is_ore_room) {
    var _ore_key = global.current_mine;
    // Fallback: infer from room
    if (_ore_key == "") {
        if      (room == rm_coal)    _ore_key = "coal";
        else if (room == rm_diamond) _ore_key = "diamond";
        else if (room == rm_gold)    _ore_key = "gold";
        else if (room == rm_opal)    _ore_key = "opal";
        else if (room == rm_uranium) _ore_key = "uranium";
    }

    if (_ore_key != "") {
        var _cam   = view_camera[0];
        var _cx    = camera_get_view_x(_cam);
        var _cy    = camera_get_view_y(_cam);

        var _ore   = variable_struct_get(global.ore_data,   _ore_key);
        var _state = variable_struct_get(global.mine_state, _ore_key);

        // Panel
        var px = _cx + 6;
        var py = _cy + 6;
        var pw = 264;
        var ph = 200;

        draw_set_alpha(0.88);
        draw_set_color(make_color_rgb(8, 6, 4));
        draw_rectangle(px, py, px + pw, py + ph, false);
        draw_set_alpha(1);

        // Coloured top-bar + title
        draw_set_color(_ore.color);
        draw_rectangle(px, py, px + pw, py + 22, false);
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_text(px + pw * 0.5, py + 4, string_upper(_ore.display) + " MINE");

        var _ty = py + 28;
        draw_set_halign(fa_left);

        draw_set_color(c_white);
        draw_text(px + 8, _ty, "Money:  $" + string(floor(global.money)));          _ty += 20;
        draw_text(px + 8, _ty, "HP:     " + string(global.player_hp) + " / " + string(global.player_hp_max)); _ty += 20;
        draw_text(px + 8, _ty, "Pick:   " + global.pickaxe_names[global.pickaxe_tier]); _ty += 20;
        draw_text(px + 8, _ty, "Gun:    " + global.weapon_names[global.weapon_tier]);   _ty += 20;

        // Worker row
        draw_set_color(c_white);
        draw_text(px + 8, _ty, "Worker: Lv." + string(_state.worker_level) + " / 5"); _ty += 20;

        if (_state.worker_level > 0) {
            var _ipm = floor(_ore.output_pm * worker_multiplier(_state.worker_level));
            draw_set_color(c_lime);
            draw_text(px + 8, _ty, "Income: $" + string(_ipm) + " / min");
        } else {
            draw_set_color(c_ltgray);
            draw_text(px + 8, _ty, "No worker hired.");
        }
        _ty += 20;

        // U hint
        if (_state.worker_level < 5) {
            var _wc  = worker_upgrade_cost(_state.worker_level);
            var _lbl = (_state.worker_level == 0) ? "Hire" : "Upgrade";
            if (global.money >= _wc) {
                draw_set_color(c_yellow);
            } else {
                draw_set_color(c_ltgray);
            }
            draw_text(px + 8, _ty, "[ U ]  " + _lbl + " Worker  ($" + string(_wc) + ")");
        } else {
            draw_set_color(c_lime);
            draw_text(px + 8, _ty, "Worker MAX level!");
        }
        draw_set_halign(fa_left);
        draw_set_alpha(1);
    }

    // Toast notification
    if (variable_global_exists("worker_msg_timer") && global.worker_msg_timer > 0) {
        var _cam2  = view_camera[0];
        var _cw    = camera_get_view_width(_cam2);
        var _ch    = camera_get_view_height(_cam2);
        var _cx2   = camera_get_view_x(_cam2);
        var _cy2   = camera_get_view_y(_cam2);
        var _a     = min(1.0, global.worker_msg_timer / 30.0);
        draw_set_alpha(_a);
        var _msg   = global.worker_msg;
        var _mw    = string_width(_msg) + 28;
        var _mh    = 32;
        var _mx    = _cx2 + (_cw - _mw) * 0.5;
        var _my    = _cy2 + _ch * 0.72;
        var _isbad = (string_pos("Not enough", _msg) > 0 || string_pos("max level", _msg) > 0);
        draw_set_color(_isbad ? make_color_rgb(120, 10, 10) : make_color_rgb(10, 80, 10));
        draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
        draw_set_color(_isbad ? c_red : c_lime);
        draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_cx2 + _cw * 0.5, _my + 8, _msg);
        draw_set_halign(fa_left);
        draw_set_alpha(1);
    }
}
