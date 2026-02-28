if (flash_timer > 0) flash_timer--;

var tcol = c_white;
if (contains_mine) {
    tcol = c_red; // DEBUG: highlight ore blocks red
}
if (flash_timer > 0) tcol = c_red;

draw_sprite_ext(spr_dirt, 0, x, y, image_xscale, image_yscale, 0, tcol, 1);
