/// draw_mine_ore_room_hud — compact overlay when player is in an ore mine room.
function draw_mine_ore_room_hud(ore_key, ore, state) {
    var panel_x = 6;
    var panel_y = 6;
    var panel_w = 250;
    var panel_h = 180;

    // Panel background
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(12, 8, 6));
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_alpha(1);

    // Coloured top-bar
    draw_set_color(ore.color);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + 22, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_text(panel_x + panel_w * 0.5, panel_y + 4, string_upper(ore.display) + " MINE");

    var ty = panel_y + 28;
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_text(panel_x + 8, ty, "Worker: Lv." + string(state.worker_level) + " / 5");
    ty += 22;

    if (state.worker_level > 0) {
        var ipm = floor(ore.output_pm * worker_multiplier(state.worker_level));
        draw_set_color(c_lime);
        draw_text(panel_x + 8, ty, "Income: $" + string(ipm) + " / min");
    } else {
        draw_set_color(c_ltgray);
        draw_text(panel_x + 8, ty, "No worker hired.");
    }
    ty += 22;

    // Upgrade hint
    if (state.worker_level < 5) {
        var wcost = worker_upgrade_cost(state.worker_level);
        if (global.money >= wcost) {
            draw_set_color(c_yellow);
            var lbl = (state.worker_level == 0) ? "Hire" : "Upgrade";
            draw_text(panel_x + 8, ty,
                "[ U ]  " + lbl + " Worker  ($" + string(wcost) + ")");
        } else {
            draw_set_color(c_red);
            draw_text(panel_x + 8, ty,
                "Need $" + string(worker_upgrade_cost(state.worker_level)) + " to hire/upgrade");
        }
    } else {
        draw_set_color(c_lime);
        draw_text(panel_x + 8, ty, "Worker fully upgraded!  (Max)");
    }
    ty += 22;

    draw_set_color(make_color_rgb(140, 140, 140));
    draw_text(panel_x + 8, ty, "[ ESC ]  Return to Surface");
    ty += 18;
    draw_text(panel_x + 8, ty, "[ M ]  World Map");

    draw_set_halign(fa_left);
    draw_set_alpha(1);
}

/// draw_upgrade_popup — modal confirmation dialog for hiring / upgrading a worker.
/// Called from obj_game_manager Draw_0 when global.upgrade_popup_active is true.
function draw_upgrade_popup() {
    var wkey   = global.upgrade_popup_ore;
    var ore    = variable_struct_get(global.ore_data,  wkey);
    var wstate = variable_struct_get(global.mine_state, wkey);
    var wcost  = worker_upgrade_cost(wstate.worker_level);

    var cx = display_get_gui_width()  * 0.5;
    var cy = display_get_gui_height() * 0.5;
    var pw = 320;
    var ph = 210;

    // Dim background
    draw_set_alpha(0.70);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    // Panel
    draw_set_color(make_color_rgb(20, 15, 8));
    draw_rectangle(cx - pw / 2, cy - ph / 2, cx + pw / 2, cy + ph / 2, false);
    draw_set_color(ore.color);
    draw_rectangle(cx - pw / 2, cy - ph / 2, cx + pw / 2, cy + ph / 2, true);

    draw_set_halign(fa_center);

    // Title
    draw_set_color(ore.color);
    var title = (wstate.worker_level == 0) ? "HIRE WORKER" : "UPGRADE WORKER";
    draw_text(cx, cy - ph / 2 + 12, title + "  —  " + string_upper(ore.display));

    // Cost and wallet
    draw_set_color(c_white);
    draw_text(cx, cy - 50, "Cost:  $" + string(wcost));

    if (global.money >= wcost) {
        draw_set_color(c_lime);
        draw_text(cx, cy - 26,
            "Wallet:  $" + string(floor(global.money))
            + "  →  $" + string(floor(global.money) - wcost) + "  after");

        // Income preview
        var cur_ipm  = floor(ore.output_pm * worker_multiplier(wstate.worker_level));
        var next_ipm = floor(ore.output_pm * worker_multiplier(wstate.worker_level + 1));
        draw_set_color(c_yellow);
        if (wstate.worker_level == 0) {
            draw_text(cx, cy + 4, "New income:  $" + string(next_ipm) + " / min");
        } else {
            draw_text(cx, cy + 4,
                "$" + string(cur_ipm) + "/min  →  $" + string(next_ipm) + "/min");
        }

        draw_set_color(c_lime);
        draw_text(cx, cy + ph / 2 - 44, "[ Y ]  or  [ ENTER ]  Confirm");
        draw_set_color(c_red);
        draw_text(cx, cy + ph / 2 - 22, "[ N ]  or  [ ESC ]  Cancel");
    } else {
        draw_set_color(c_red);
        draw_text(cx, cy - 26,
            "Not enough money!  (need $" + string(wcost - floor(global.money)) + " more)");
        draw_set_color(make_color_rgb(160, 160, 160));
        draw_text(cx, cy + ph / 2 - 22, "[ N ]  or  [ ESC ]  Cancel");
    }

    draw_set_halign(fa_left);
}
