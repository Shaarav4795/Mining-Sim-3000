// Tint red when freshly hit
var gcol = (hit_flash_timer > 0) ? c_red : c_white;
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, gcol, 1);

// "HIT!" pop above goblin when struck
if (hit_flash_timer > 0) {
    draw_set_color(c_yellow);
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_text(x, y - 28, "HIT!");
}

// HP indicator
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(x, y - 20, string(hp));
draw_set_color(c_white);
draw_set_halign(fa_left);
