// Room Start event — runs every time this persistent object enters a new room

if (room == rm_mining_area) {
    // Assign ores only once per session (flag persists with game_manager)
    if (!global.mining_area_initialized && instance_number(obj_dirt) > 0) {
        mining_area_assign_ores();
        global.mining_area_initialized = true;
    }

    // Recreate mine entrances for any discovered mines whose objects were lost
    // (obj_mine_entrance is not persistent, so this restores them on re-entry)
    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        var key   = keys[i];
        var state = variable_struct_get(global.mine_state, key);
        if (!state.discovered || state.entrance_x == 0) continue;

        // Only spawn if no entrance for this ore already exists in the room
        var already = false;
        with (obj_mine_entrance) {
            if (ore_key == key) { already = true; break; }
        }
        if (!already) {
            var ent = instance_create_layer(state.entrance_x, state.entrance_y,
                                            "Instances", obj_mine_entrance);
            ent.ore_key              = key;
            ent.discovery_popup_timer = 0; // don't re-flash old discoveries
        }
    }

    // Destroy dirt blocks that were mined in a previous visit
    // (room reload restores all room-placed instances, so we re-remove them here)
    if (array_length(global.mined_dirt_positions) > 0) {
        with (obj_dirt) {
            var _key = string(x) + "_" + string(y);
            var _found = false;
            for (var _mi = 0; _mi < array_length(global.mined_dirt_positions); _mi++) {
                if (global.mined_dirt_positions[_mi] == _key) {
                    _found = true;
                    break;
                }
            }
            if (_found) instance_destroy();
        }
    }
}
