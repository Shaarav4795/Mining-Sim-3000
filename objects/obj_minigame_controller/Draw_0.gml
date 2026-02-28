var cx = room_width * 0.5;
var panel_x1 = 30;
var panel_x2 = room_width - 30;

// Dim overlay
draw_set_alpha(0.88);
draw_set_color(make_color_rgb(4, 8, 4));
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Outer panel border
draw_set_color(make_color_rgb(0, 200, 80));
draw_rectangle(panel_x1, 40, panel_x2, room_height - 40, true);

// Header
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(0, 255, 100));
draw_text(cx, 55, "=== HACKING TERMINAL ===");
draw_set_color(make_color_rgb(180, 255, 180));
draw_text(cx, 80, "TARGET: " + ore_display + " Mine Password");

// Divider
draw_set_color(make_color_rgb(0, 120, 60));
draw_line(panel_x1 + 6, 105, panel_x2 - 6, 105);

// Clues section
draw_set_color(make_color_rgb(0, 200, 100));
draw_text(cx, 118, "> " + clue1);
draw_text(cx, 140, "> " + clue2);
draw_text(cx, 162, "> " + clue3);

// Divider
draw_line(panel_x1 + 6, 188, panel_x2 - 6, 188);

// Options list
draw_set_color(make_color_rgb(0, 180, 80));
draw_text(cx, 200, "--- SELECT PASSWORD ---");

var opt_labels = ["A", "B", "C", "D", "E", "F"];
var gy = 224;
for (var i = 0; i < 6; i++) {
    var gy2 = gy + i * 26;
    if (eliminated[i]) {
        draw_set_color(make_color_rgb(60, 60, 60));
        draw_text(cx, gy2, "[" + opt_labels[i] + "]  " + options[i] + "  (ELIMINATED)");
    } else {
        if (flash_wrong > 0) {
            draw_set_color(make_color_rgb(255, 50, 50));
        } else {
            draw_set_color(make_color_rgb(0, 255, 120));
        }
        draw_text(cx, gy2, "[" + opt_labels[i] + "]  " + options[i]);
    }
}

// Divider
draw_set_color(make_color_rgb(0, 120, 60));
draw_line(panel_x1 + 6, 384, panel_x2 - 6, 384);

// Attempts
var att_color = (attempts_left >= 2) ? make_color_rgb(0, 220, 100) : make_color_rgb(255, 100, 0);
draw_set_color(att_color);
draw_text(cx, 394, "ATTEMPTS REMAINING: " + string(attempts_left));

// Result overlays
if (result == "win") {
    draw_set_color(make_color_rgb(0, 255, 100));
    draw_text(cx, 440, ">>> ACCESS GRANTED <<<");
    draw_set_color(make_color_rgb(180, 255, 180));
    draw_text(cx, 468, "Mine unlocked!");
} else if (result == "lose") {
    draw_set_color(make_color_rgb(255, 50, 50));
    draw_text(cx, 440, ">>> ACCESS DENIED <<<");
    draw_set_color(make_color_rgb(255, 180, 180));
    draw_text(cx, 468, "10 second lockout.");
}

// Instructions
if (result == "") {
    draw_set_color(make_color_rgb(0, 140, 60));
    draw_text(cx, 700, "Press  A - F  to select");
}

draw_set_halign(fa_left);
