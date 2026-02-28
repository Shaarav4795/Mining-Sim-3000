var is_mine_room = (room == rm_mini_1 || room == rm_mini_2 || room == rm_mini_3
                 || room == rm_mini_4 || room == rm_mini_5);

// ──────── MINE ROOM MANAGEMENT SCREEN ────────
if (is_mine_room) {
    var ore_key = global.current_mine;
    if (ore_key == "") exit;

    var ore   = variable_struct_get(global.ore_data, ore_key);
    var state = variable_struct_get(global.mine_state, ore_key);

    // Background
    draw_set_color(ore_get_bg_color(ore_key));
    draw_rectangle(0, 0, room_width, room_height, false);

    // Decorative rock pattern (simple dots)
    draw_set_alpha(0.08);
    draw_set_color(c_white);
    var seed = 42;
    for (var ri = 0; ri < 40; ri++) {
        var rx = (seed * 73 + ri * 137) mod room_width;
        var ry = (seed * 31 + ri * 97)  mod room_height;
        draw_circle(rx, ry, 12 + (ri mod 8), true);
    }
    draw_set_alpha(1);

    var cx = room_width * 0.5;

    // Title banner
    draw_set_color(ore.color);
    draw_set_halign(fa_center);
    draw_text(cx, 28, "=== " + string_upper(ore.display) + " MINE ===");

    // Large ore sprite decoration
    var ore_spr = asset_get_index("spr_" + ore_key);
    if (ore_spr >= 0) {
        var sw = sprite_get_width(ore_spr);
        var sh = sprite_get_height(ore_spr);
        var disp = 96.0 / max(sw, sh);
        var glow_a = 0.25 + sin(current_time * 0.002) * 0.15;
        draw_set_alpha(glow_a);
        draw_set_color(ore.color);
        draw_circle(cx, 138, 58, false);
        draw_set_alpha(1);
        draw_sprite_ext(ore_spr, 0, cx - sw * disp * 0.5, 90, disp, disp, 0, c_white, 1);
    }

    // Stats panel background
    draw_set_alpha(0.80);
    draw_set_color(make_color_rgb(18, 14, 10));
    draw_rectangle(50, 232, room_width - 50, 520, false);
    draw_set_alpha(1);

    // Worker stats
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

    // Upgrade / hire button
    var ty2 = 316;
    if (state.worker_level < 5) {
        var cost = worker_upgrade_cost(state.worker_level);
        if (global.money >= cost) {
            draw_set_color(c_yellow);
            if (state.worker_level == 0) {
                draw_text(cx, ty2, "[ E ]  Hire Worker  ($" + string(cost) + ")");
            } else {
                draw_text(cx, ty2, "[ E ]  Upgrade Worker  ($" + string(cost) + ")");
                draw_set_color(c_ltgray);
                draw_text(cx, ty2 + 28, "Next level income: $" + string(floor(ore.output_pm * worker_multiplier(state.worker_level + 1))) + " / min");
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

    // Exit hint
    draw_set_color(make_color_rgb(120, 120, 120));
    draw_text(cx, 720, "[ ESC ]  Return to Mine");
    draw_set_halign(fa_left);
    exit;
}

// ──────── NORMAL HUD (mining + hub) ────────
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(6, 6, 210, 106, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var ty = 12;
draw_text(12, ty, "Money: $" + string(floor(global.money)));    ty += 22;
draw_text(12, ty, "HP: "    + string(global.player_hp) + "/" + string(global.player_hp_max)); ty += 22;
draw_text(12, ty, "Pick: "  + global.pickaxe_names[global.pickaxe_tier]); ty += 22;
draw_text(12, ty, "Gun: "   + global.weapon_names[global.weapon_tier]);
