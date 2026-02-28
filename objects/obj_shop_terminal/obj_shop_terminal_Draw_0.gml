draw_set_color(make_color_rgb(110, 110, 130));
draw_rectangle(x - 18, y - 24, x + 18, y + 24, false);

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 48) {
    draw_set_color(c_white);
    draw_text(x - 130, y - 74, "SHOP: 1 Pickaxe | 2 Pistol ($40) | 3 RPG ($120) | 4 Grenade ($90)");
}
