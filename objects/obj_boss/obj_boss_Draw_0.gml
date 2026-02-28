draw_set_color(make_color_rgb(220, 70, 70));
draw_rectangle(x - 26, y - 26, x + 26, y + 26, false);
draw_set_color(c_white);
draw_text(x - 36, y - 44, "RIVAL CEO HP: " + string(hp));
