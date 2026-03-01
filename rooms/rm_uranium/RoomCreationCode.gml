// rm_uranium: uranium mine
global.current_mine = "uranium";

// Player is visible in the mine so the player can see their worker
if (instance_exists(obj_player)) {
    with (obj_player) {
        visible = true;
        x = room_width  * 0.5;
        y = 64;
        mine_target = noone;
        mine_timer  = 0;
    }
}

// Ensure game manager is alive
if (!instance_exists(obj_game_manager)) {
    instance_create_layer(0, 0, "Instances_1", obj_game_manager);
}

// Spawn worker if one has been hired (and none exists in room yet)
var _state = variable_struct_get(global.mine_state, "uranium");
if (_state.worker_level > 0 && instance_number(obj_worker) == 0) {
    var _wk = instance_create_layer(room_width * 0.5, 80, "Instances_1", obj_worker);
    _wk.ore_key = "uranium";
} 
