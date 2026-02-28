function minigame_start(ore_key) {
    global.pending_ore = ore_key;
    global.minigame_active = true;
    // Spawn overlay controller in current room
    if (!instance_exists(obj_minigame_controller)) {
        var ctrl = instance_create_layer(0, 0, "Instances", obj_minigame_controller);
    }
}

function minigame_resolve(success) {
    var key = global.pending_ore;
    global.minigame_active = false;

    if (key != "") {
        var state = variable_struct_get(global.mine_state, key);
        if (success) {
            state.unlocked = true;
            state.cooldown = 0;
        } else {
            state.cooldown = 10;
        }
        variable_struct_set(global.mine_state, key, state);
    }
    global.pending_ore = "";

    if (instance_exists(obj_minigame_controller)) {
        instance_destroy(obj_minigame_controller);
    }
}
