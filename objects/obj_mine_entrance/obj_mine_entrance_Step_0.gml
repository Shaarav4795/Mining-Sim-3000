if (!instance_exists(obj_player)) exit;

var dist = point_distance(x, y, obj_player.x, obj_player.y);
if (dist > 36) exit;

var state = variable_struct_get(global.mine_state, ore_key);
var ore = variable_struct_get(global.ore_data, ore_key);

if (keyboard_check_pressed(ord("E")) && !state.unlocked) {
    if (state.cooldown <= 0 && global.money >= ore.unlock_fee) {
        global.money -= ore.unlock_fee;
        minigame_start(ore_key);
    }
}

if (keyboard_check_pressed(ord("W")) && state.unlocked) {
    if (state.worker_level < 5) {
        var cost = worker_upgrade_cost(state.worker_level);
        if (global.money >= cost) {
            global.money -= cost;
            state.worker_level += 1;
            variable_struct_set(global.mine_state, ore_key, state);

            if (!instance_exists(worker_id)) {
                worker_id = instance_create_layer(x + 26, y, "Instances", obj_worker);
                worker_id.ore_key = ore_key;
            }
            worker_id.level = state.worker_level;
        }
    }
}
