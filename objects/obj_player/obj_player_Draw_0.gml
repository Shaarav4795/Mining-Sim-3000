draw_set_color(make_color_rgb(120, 180, 255));
draw_rectangle(x - 10, y - 10, x + 10, y + 10, false);

var lx = x + lengthdir_x(20, aim_dir);
var ly = y + lengthdir_y(20, aim_dir);
draw_set_color(c_white);
draw_line(x, y, lx, ly);
