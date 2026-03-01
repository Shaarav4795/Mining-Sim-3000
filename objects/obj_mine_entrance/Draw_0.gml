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
    // Popup box
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

// Clamp popup anchor to camera view so it's never cut off at screen edges
var _cam   = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
var _pop_cx = clamp(x + 16, _cam_x + 110, _cam_x + _cam_w - 110);
var _pop_y  = max(y, _cam_y + 70);  // push down if too close to top

draw_set_halign(fa_center);

if (!state.unlocked) {
    if (state.cooldown > 0) {
        draw_set_color(c_red);
        draw_text(_pop_cx, _pop_y - 54, "LOCKED  (cooldown " + string_format(state.cooldown, 1, 1) + "s)");
        draw_set_color(c_ltgray);
        draw_text(_pop_cx, _pop_y - 36, "E: Retry ($" + string(ore.unlock_fee) + ")");
    } else if (global.money >= ore.unlock_fee) {
        draw_set_color(c_yellow);
        draw_text(_pop_cx, _pop_y - 54, "E: Hack " + ore.display + " Mine");
        draw_set_color(c_white);
        draw_text(_pop_cx, _pop_y - 36, "Cost: $" + string(ore.unlock_fee));
    } else {
        draw_set_color(c_red);
        draw_text(_pop_cx, _pop_y - 54, ore.display + " Mine  ($" + string(ore.unlock_fee) + ")");
        draw_set_color(c_ltgray);
        draw_text(_pop_cx, _pop_y - 36, "Not enough money");
    }
} else {
    draw_set_color(c_lime);
    draw_text(_pop_cx, _pop_y - 54, "E: Enter " + ore.display + " Mine");
    draw_set_color(c_ltgray);
    if (state.worker_level > 0) {
        draw_text(_pop_cx, _pop_y - 36, "Lv." + string(state.worker_level) + "/5 worker");
    } else {
        draw_text(_pop_cx, _pop_y - 36, "No worker hired");
    }
}

draw_set_halign(fa_left);
