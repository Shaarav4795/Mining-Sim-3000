var state = variable_struct_get(global.mine_state, ore_key);
var ore = variable_struct_get(global.ore_data, ore_key);

draw_set_color(make_color_rgb(94, 60, 28));
draw_rectangle(x - 16, y - 16, x + 16, y + 16, false);

draw_set_color(c_white);
if (!state.unlocked) {
    if (state.cooldown > 0) {
        draw_text(x - 44, y - 34, ore.display + " CD " + string_format(state.cooldown, 1, 1));
    } else {
        draw_text(x - 56, y - 34, "E: Unlock " + ore.display + " ($" + string(ore.unlock_fee) + ")");
    }
} else {
    var next_cost = (state.worker_level < 5) ? worker_upgrade_cost(state.worker_level) : 0;
    draw_text(x - 64, y - 34, ore.display + " Lv." + string(state.worker_level) + "/5");
    if (state.worker_level < 5) {
        draw_text(x - 64, y - 18, "W: Worker upgrade ($" + string(next_cost) + ")");
    }
}
