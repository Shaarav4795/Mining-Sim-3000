// Draw player sprite (sprite origin 0,0 -> offset to center it)
var disp_w = sprite_get_width(spr_player)  * image_xscale;
var disp_h = sprite_get_height(spr_player) * image_yscale;
draw_sprite_ext(spr_player, 0, x - disp_w * 0.5, y - disp_h * 0.5,
                image_xscale, image_yscale, 0, c_white, 1);

// Draw pickaxe + progress bar while mining
if (mine_target != noone && instance_exists(mine_target)) {
    var tier   = global.pickaxe_tier;
    var pk_spr = spr_pickaxe_silver;
    if (tier == 2) pk_spr = spr_pickaxe_gold;
    if (tier >= 3) pk_spr = spr_pickaxe_diamond;

    var prog  = mine_timer / mine_duration;
    var swing = sin(prog * pi) * 45;

    // Point toward the centre of the target block
    var tx    = mine_target.x + sprite_get_width(mine_target.sprite_index)  * mine_target.image_xscale * 0.5;
    var ty    = mine_target.y + sprite_get_height(mine_target.sprite_index) * mine_target.image_yscale * 0.5;
    var base_a = point_direction(x, y, tx, ty);

    // Pickaxe scale reduced by 20 % from original 0.035
    var pk_sc = 0.028;
    draw_sprite_ext(pk_spr, 0, x, y, pk_sc, pk_sc, base_a + swing, c_white, 1);

    // Loading bar
    var bx = mine_target.x + 8;
    var by = mine_target.y - 10;
    draw_set_color(c_dkgray);
    draw_rectangle(bx - 16, by - 4, bx + 16, by + 4, false);
    draw_set_color(c_lime);
    draw_rectangle(bx - 16, by - 4, bx - 16 + 32 * prog, by + 4, false);
    draw_set_color(c_white);
}
