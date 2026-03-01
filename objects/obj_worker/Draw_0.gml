var ww   = sprite_get_width(spr_worker);
var wh   = sprite_get_height(spr_worker);
var wsc  = 32.0 / max(ww, wh);
var ybob = sin(anim * 0.12) * 2;

// Foot shadow
draw_set_alpha(0.30);
draw_set_color(c_black);
draw_ellipse(x - 10, y - 2, x + 10, y + 5, false);
draw_set_alpha(1);

// Worker sprite – flip horizontally based on direction
var sx   = wsc * face_dir;  // negative = face left
var draw_x;
if (face_dir >= 0) {
    draw_x = x - ww * wsc * 0.5;
} else {
    draw_x = x + ww * wsc * 0.5;
}
draw_sprite_ext(spr_worker, 0, draw_x, y - wh * wsc + ybob, sx, wsc, 0, c_white, 1);

// Level badge floating above worker
draw_set_color(c_yellow);
draw_set_halign(fa_center);
draw_text(x, y - wh * wsc - 12 + ybob, "Lv." + string(level));
draw_set_halign(fa_left);
