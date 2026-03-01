var state = variable_struct_get(global.mine_state, ore_key);
var ore   = variable_struct_get(global.ore_data, ore_key);

// Pulsing glow ring
var glow_r = 22 + sin(current_time * 0.004) * 5;
var glow_a = 0.4 + sin(current_time * 0.003) * 0.2;
draw_set_alpha(glow_a);
draw_set_color(ore.color);
draw_circle(x + 16, y + 16, glow_r, false);
draw_set_alpha(1);

// Ore sprite (same 32x32 footprint as dirt)
var ore_spr = asset_get_index("spr_" + ore_key);
if (ore_spr >= 0) {
    var tw = sprite_get_width(ore_spr);
    var th = sprite_get_height(ore_spr);
    var ts = 32.0 / max(tw, th);
    draw_sprite_ext(ore_spr, 0, x, y, ts, ts, 0, c_white, 1);
} else {
    draw_set_color(ore.color);
    draw_rectangle(x, y, x + 32, y + 32, false);
}

// Discovery popup (shown while timer > 0)
if (discovery_popup_timer > 0) {
    var alpha = min(1.0, discovery_popup_timer / 30.0);
    draw_set_alpha(alpha);
    draw_set_color(make_color_rgb(10, 10, 30));
    draw_rectangle(x - 80, y - 74, x + 112, y - 10, false);
    draw_set_color(ore.color);
    draw_set_halign(fa_center);
    draw_text(x + 16, y - 68, "!! DISCOVERY !!");
    draw_set_color(c_white);
    draw_text(x + 16, y - 50, ore.display + " Mine Found!");
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    exit;
}

// Proximity UI
if (!instance_exists(obj_player)) exit;
var dist = point_distance(x, y, obj_player.x, obj_player.y);
if (dist > 52) exit;

// Only draw proximity label for the nearest entrance (prevents overlap)
var _is_nearest = true;
var _ent_count = instance_number(obj_mine_entrance);
for (var _ei = 0; _ei < _ent_count; _ei++) {
    var _ent = instance_find(obj_mine_entrance, _ei);
    if (_ent != id) {
        var _od = point_distance(_ent.x, _ent.y, obj_player.x, obj_player.y);
        if (_od < dist && _od <= 52) {
            _is_nearest = false;
            break;
        }
    }
}
if (!_is_nearest) exit;

// Clamp popup anchor to camera view
var _cam   = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
var _pop_cx = clamp(x + 16, _cam_x + 110, _cam_x + _cam_w - 110);
var _pop_y  = max(y, _cam_y + 70);

// Build the two text lines
var _line1 = "";
var _line2 = "";

draw_set_halign(fa_center);

if (!state.unlocked) {
    if (state.cooldown > 0) {
        _line1 = "LOCKED  (cooldown " + string_format(state.cooldown, 1, 1) + "s)";
        _line2 = "E: Retry ($" + string(ore.unlock_fee) + ")";
    } else if (global.money >= ore.unlock_fee) {
        _line1 = "E: Hack " + ore.display + " Mine";
        _line2 = "Cost: $" + string(ore.unlock_fee);
    } else {
        _line1 = ore.display + " Mine  ($" + string(ore.unlock_fee) + ")";
        _line2 = "Not enough money";
    }
} else {
    _line1 = "E: Enter " + ore.display + " Mine";
    if (state.worker_level > 0) {
        _line2 = "[ U ] Upgrade worker  Lv." + string(state.worker_level) + "/5";
    } else {
        _line2 = "[ U ] Hire worker";
    }
}

// Black background box behind both lines
var _pad = 6;
var _bw  = max(string_width(_line1), string_width(_line2)) + _pad * 2;
var _bh  = 44;
var _bx  = _pop_cx - _bw * 0.5;
var _by  = _pop_y - 58;
draw_set_alpha(0.78);
draw_set_color(c_black);
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
draw_set_alpha(1);

// Line 1
if (!state.unlocked) {
    if (state.cooldown > 0) {
        draw_set_color(c_red);
    } else if (global.money >= ore.unlock_fee) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_red);
    }
} else {
    draw_set_color(c_lime);
}
draw_text(_pop_cx, _pop_y - 54, _line1);

// Line 2
if (!state.unlocked) {
    draw_set_color(c_ltgray);
} else {
    if (state.worker_level < 5) {
        var _wc = worker_upgrade_cost(state.worker_level);
        draw_set_color(global.money >= _wc ? c_yellow : c_ltgray);
    } else {
        draw_set_color(c_lime);
    }
}
draw_text(_pop_cx, _pop_y - 36, _line2);

draw_set_halign(fa_left);
