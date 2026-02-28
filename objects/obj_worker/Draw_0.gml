var ybob = sin(anim * 0.05) * 3;
// Use spr_worker sprite if it exists
var ww = sprite_get_width(spr_worker);
var wh = sprite_get_height(spr_worker);
var wsc = 32.0 / max(ww, wh);
draw_sprite_ext(spr_worker, 0, x - ww * wsc * 0.5, y - wh * wsc + ybob,
                wsc, wsc, 0, c_white, 1);
// Level label
draw_set_color(c_yellow);
draw_set_halign(fa_center);
draw_text(x, y - wh * wsc - 14 + ybob, "Lv." + string(level));
draw_set_halign(fa_left);
