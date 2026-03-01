// Room Start event — runs every time this persistent object enters a new room

if (room == rm_mining_area) {
    // First visit: assign ores/goblins and save layout
    if (!global.mining_area_initialized && instance_number(obj_dirt) > 0) {
        mining_area_assign_ores();
        mining_area_assign_goblins();
        mining_area_save_assignments();   // persist layout for future reloads
        global.mining_area_initialized = true;
    } else if (global.mining_area_initialized) {
        // Re-entry: room reloads reset all dirt blocks — re-apply saved layout
        mining_area_restore_assignments();
    }

    // Recreate mine entrances for any discovered mines whose objects were lost
    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        var key   = keys[i];
        var state = variable_struct_get(global.mine_state, key);
        if (!state.discovered || state.entrance_x == 0) continue;

        var already = false;
        with (obj_mine_entrance) {
            if (ore_key == key) { already = true; break; }
        }
        if (!already) {
            var ent = instance_create_layer(state.entrance_x, state.entrance_y,
                                            "Instances", obj_mine_entrance);
            ent.ore_key               = key;
            ent.discovery_popup_timer = 0;  // don't re-flash old discoveries
        }
    }

    // Destroy dirt blocks that were mined in a previous visit
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
