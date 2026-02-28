function minigame_start(ore_key) {
    global.pending_ore = ore_key;
    room_goto(rm_mini_1);
}

function minigame_resolve(success) {
    var key = global.pending_ore;
    if (key == "") {
        room_goto(rm_hub);
        return;
    }

    var state = variable_struct_get(global.mine_state, key);

    if (success) {
        state.unlocked = true;
        state.cooldown = 0;
    } else {
        state.cooldown = 10;
    }

    variable_struct_set(global.mine_state, key, state);
    global.pending_ore = "";
    room_goto(rm_hub);
}
