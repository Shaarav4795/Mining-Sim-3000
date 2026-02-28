var move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

if (move_x != 0 || move_y != 0) {
    var len = point_distance(0, 0, move_x, move_y);
    move_x = (move_x / len) * move_speed;
    move_y = (move_y / len) * move_speed;
}

if (!place_meeting(x + move_x, y, obj_dirt_block)) x += move_x;
if (!place_meeting(x, y + move_y, obj_dirt_block)) y += move_y;

aim_dir = point_direction(x, y, mouse_x, mouse_y);

if (mouse_check_button_pressed(mb_left)) {
    var mined = mine_try_break_nearby(x, y, global.pickaxe_power[global.pickaxe_tier]);
    if (!mined) {
        player_fire_weapon(x, y, aim_dir);
    }
}

if (keyboard_check_pressed(vk_space)) {
    mine_try_break_nearby(x, y, global.pickaxe_power[global.pickaxe_tier]);
}
