economy_step();

if (global.fire_cooldown > 0) {
    global.fire_cooldown--;
}

if (global.worker_msg_timer > 0) {
    global.worker_msg_timer--;
}

if (global.player_hp <= 0) {
    global.player_hp = global.player_hp_max;
    global.money     = max(0, global.money - 20);
    room_goto(rm_afterlife);
}

if (keyboard_check_pressed(ord("M"))) {
    room_goto(rm_hub);
}

if (keyboard_check_pressed(ord("B")) && global.weapon_tier >= 2) {
    room_goto(rm_boss_arena);
}

// ── Mine room controls ──
var is_mini_room = (room == rm_mini_1 || room == rm_mini_2 || room == rm_mini_3
                 || room == rm_mini_4 || room == rm_mini_5);
var is_ore_room  = (room == rm_coal || room == rm_diamond || room == rm_gold
                 || room == rm_opal || room == rm_uranium);
var is_mine_room = is_mini_room || is_ore_room;

if (is_mine_room) {
    // ── ESC: exit to mining area ──
    if (keyboard_check_pressed(vk_escape)) {
        if (instance_exists(obj_player)) {
            with (obj_player) {
                visible = true;
                x = global.player_return_x;
                y = global.player_return_y;
            }
        }
        global.current_mine = "";
        room_goto(rm_mining_area);
    }

    // ── U: directly hire / upgrade worker ──
    if (keyboard_check_pressed(ord("U")) && global.current_mine != "") {
        var wkey   = global.current_mine;
        var wstate = variable_struct_get(global.mine_state, wkey);
        if (wstate.worker_level < 5) {
            var wcost = worker_upgrade_cost(wstate.worker_level);
            if (global.money >= wcost) {
                global.money        -= wcost;
                wstate.worker_level++;
                wstate.unlocked      = true;
                variable_struct_set(global.mine_state, wkey, wstate);
                // Spawn worker sprite if just hired (level went 0→1)
                if (is_ore_room && wstate.worker_level == 1 && instance_number(obj_worker) == 0) {
                    var _wk = instance_create_layer(room_width * 0.5, 80, "Instances_1", obj_worker);
                    _wk.ore_key = wkey;
                }
                var ore = variable_struct_get(global.ore_data, wkey);
                var lbl = (wstate.worker_level == 1) ? "Worker hired!" : "Worker upgraded to Lv." + string(wstate.worker_level) + "!";
                global.worker_msg       = lbl;
                global.worker_msg_timer = 180;
            } else {
                var wcost2 = worker_upgrade_cost(wstate.worker_level);
                global.worker_msg       = "Not enough money!  (need $" + string(wcost2 - floor(global.money)) + " more)";
                global.worker_msg_timer = 180;
            }
        } else {
            global.worker_msg       = "Worker already at max level!";
            global.worker_msg_timer = 120;
        }
    }
}
