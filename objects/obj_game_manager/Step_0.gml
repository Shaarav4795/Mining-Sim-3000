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

// ── Mine room controls ──
var is_mine_room = (room == rm_mini_1 || room == rm_mini_2 || room == rm_mini_3
                 || room == rm_mini_4 || room == rm_mini_5);

if (is_mine_room) {
    // ESC: exit to mining area
    if (keyboard_check_pressed(vk_escape)) {
        if (instance_exists(obj_player)) {
            with (obj_player) {
                visible = true;
                x = 208;
                y = 752;
            }
        }
        global.current_mine = "";
        room_goto(rm_mining_area);
    }

    // E: hire / upgrade worker
    if (keyboard_check_pressed(ord("E")) && global.current_mine != "") {
        var wkey  = global.current_mine;
        var wstate = variable_struct_get(global.mine_state, wkey);
        if (wstate.worker_level < 5) {
            var wcost = worker_upgrade_cost(wstate.worker_level);
            if (global.money >= wcost) {
                global.money -= wcost;
                wstate.worker_level++;
                variable_struct_set(global.mine_state, wkey, wstate);
            }
        }
    }
}
