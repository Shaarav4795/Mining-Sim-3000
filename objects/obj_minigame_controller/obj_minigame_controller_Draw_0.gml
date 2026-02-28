draw_set_color(c_white);
draw_text(bar_x - 220, bar_y - 80, "Kian Minigame: Press SPACE in the green zone");

var x0 = bar_x - bar_w * 0.5;
var x1 = bar_x + bar_w * 0.5;
draw_set_color(c_dkgray);
draw_rectangle(x0, bar_y - bar_h * 0.5, x1, bar_y + bar_h * 0.5, false);

var zx0 = x0 + bar_w * (zone_center - zone_width * 0.5);
var zx1 = x0 + bar_w * (zone_center + zone_width * 0.5);
draw_set_color(c_lime);
draw_rectangle(zx0, bar_y - bar_h * 0.5, zx1, bar_y + bar_h * 0.5, false);

var cx = x0 + bar_w * cursor_t;
draw_set_color(c_yellow);
draw_rectangle(cx - 3, bar_y - bar_h, cx + 3, bar_y + bar_h, false);
