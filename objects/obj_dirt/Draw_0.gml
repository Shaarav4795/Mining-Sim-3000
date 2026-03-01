if (flash_timer > 0) flash_timer--;

var tcol = c_white;
if (flash_timer > 0) tcol = c_red;
// Debug: tint goblin traps bright green so they're easy to spot
if (goblin_trap) tcol = make_color_rgb(80, 220, 80);

draw_sprite_ext(spr_dirt, 0, x, y, image_xscale, image_yscale, 0, tcol, 1);
