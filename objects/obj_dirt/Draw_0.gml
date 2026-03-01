if (flash_timer > 0) flash_timer--;

var tcol = c_white;
if (flash_timer > 0) {
    // coal blocks get a special blue flash; all other debug colours hidden
    if (mine_type == "coal") tcol = c_blue;
}
// Debug: goblin trap tint hidden
// if (goblin_trap) tcol = make_color_rgb(80, 220, 80);

draw_sprite_ext(spr_dirt, 0, x, y, image_xscale, image_yscale, 0, tcol, 1);
