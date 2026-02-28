economy_step();

if (global.fire_cooldown > 0) {
    global.fire_cooldown--;
}

if (global.player_hp <= 0) {
    global.player_hp = global.player_hp_max;
    global.money = max(0, global.money - 20);
    room_goto(rm_hub);
}

if (keyboard_check_pressed(ord("M"))) {
    room_goto(rm_hub);
}

if (keyboard_check_pressed(ord("B")) && global.weapon_tier >= 2) {
    room_goto(rm_boss_arena);
}
