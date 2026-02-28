if (flash_timer > 0) flash_timer--;

var col = make_color_rgb(120, 82, 50);
if (contains_mine) {
    var ore = variable_struct_get(global.ore_data, mine_type);
    col = merge_color(col, ore.color, 0.25);
}
if (flash_timer > 0) {
    col = c_white;
}

draw_set_color(col);
draw_rectangle(x - 20, y - 20, x + 20, y + 20, false);
