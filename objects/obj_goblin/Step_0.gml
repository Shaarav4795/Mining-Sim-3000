if (hp <= 0) {
    global.money += 8;
    instance_destroy();
    exit;
}

if (!instance_exists(obj_player)) exit;

var dist = point_distance(x, y, obj_player.x, obj_player.y);
if (dist < 140) {
    move_dir = point_direction(x, y, obj_player.x, obj_player.y);
} else if (irandom(90) == 0) {
    move_dir = irandom(359);
}

var dx = lengthdir_x(move_speed, move_dir);
var dy = lengthdir_y(move_speed, move_dir);

if (!place_meeting(x + dx, y, obj_dirt)) x += dx; else move_dir += irandom_range(90, 180);
if (!place_meeting(x, y + dy, obj_dirt)) y += dy; else move_dir += irandom_range(90, 180);

if (attack_cd > 0) attack_cd--;
if (dist < 22 && attack_cd <= 0) {
    global.player_hp -= 6;
    attack_cd = 30;
}
