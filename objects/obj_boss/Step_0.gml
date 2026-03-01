if (hp <= 0) {
    global.game_won = true;
    instance_destroy();
    room_goto(rm_hub);
    exit;
}

if (!instance_exists(obj_player)) exit;

var dir = point_direction(x, y, obj_player.x, obj_player.y);
var dx = lengthdir_x(move_speed, dir);
var dy = lengthdir_y(move_speed, dir);

x += dx;
y += dy;

if (attack_cd > 0) attack_cd--;
var _safe_room = (room == rm_hub || room == rm_win || room == rm_afterlife
               || room == rm_credit || room == rm_tutorial || room == rm_play);
if (point_distance(x, y, obj_player.x, obj_player.y) < 32 && attack_cd <= 0 && !_safe_room) {
    global.player_hp -= 14;
    attack_cd = 35;
}
