var ybob = lengthdir_y(2, anim);
draw_set_color(make_color_rgb(220, 220, 220));
draw_rectangle(x - 6, y - 10 + ybob, x + 6, y + 10 + ybob, false);
draw_set_color(c_yellow);
draw_text(x - 8, y - 24, "W" + string(level));
