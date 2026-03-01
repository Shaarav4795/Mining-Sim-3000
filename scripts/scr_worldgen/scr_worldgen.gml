/// Assign ore blocks to pre-placed dirt instances in rm_mining_area.
/// Call this once when the player enters rm_mining_area.
function mining_area_assign_ores() {
    // Collect all existing dirt instances that have no ore yet
    var blocks = [];
    with (obj_dirt) {
        if (!contains_mine) array_push(blocks, id);
    }

    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        if (array_length(blocks) <= 0) break;
        var pick = irandom(array_length(blocks) - 1);
        var block = blocks[pick];
        array_delete(blocks, pick, 1);
        if (instance_exists(block)) {
            block.contains_mine = true;
            block.mine_type = keys[i];
            var ore = variable_struct_get(global.ore_data, keys[i]);
            block.hp = ore.block_hp;
              // debug: flash for a very long time (~1000 seconds) so ores stay highlighted
              block.flash_timer = room_speed * 1000;
        }
    }
}

function hub_generate_blocks() {
    var blocks = [];
    var start_x = 5;
    var start_y = 3;
    var cols = 18;
    var rows = 14;
    var cell = 48;

    for (var gx = 0; gx < cols; gx++) {
        for (var gy = 0; gy < rows; gy++) {
            if (abs(gx - 1) <= 1 && abs(gy - 1) <= 1) continue;

            var px = (start_x + gx) * cell;
            var py = (start_y + gy) * cell;
            var dirt = instance_create_layer(px, py, "Instances", obj_dirt);
            array_push(blocks, dirt);
        }
    }

    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        if (array_length(blocks) <= 0) break;

        var pick = irandom(array_length(blocks) - 1);
        var block = blocks[pick];
        array_delete(blocks, pick, 1);

        if (instance_exists(block)) {
            block.contains_mine = true;
            block.mine_type = keys[i];
            var ore = variable_struct_get(global.ore_data, keys[i]);
            block.hp = ore.block_hp;
              // debug: flash for a very long time (~1000 seconds) so ores stay highlighted
              block.flash_timer = room_speed * 1000;
        }
    }
}

/// Pick 20 non-ore dirt blocks in rm_mining_area and flag them as goblin traps.
/// Must be called after mining_area_assign_ores() so ore blocks are already marked.
function mining_area_assign_goblins() {
    var blocks = [];
    with (obj_dirt) {
        if (!contains_mine && !goblin_trap) array_push(blocks, id);
    }

    var count = min(20, array_length(blocks));
    repeat (count) {
        if (array_length(blocks) == 0) break;
        var pick = irandom(array_length(blocks) - 1);
        var block = blocks[pick];
        array_delete(blocks, pick, 1);
        if (instance_exists(block)) {
            block.goblin_trap = true;
        }
    }
}

/// Save ore/goblin block assignments into global lookup structs.
/// Call this right after the first-time mining_area_assign_ores/goblins.
function mining_area_save_assignments() {
    global.ore_block_map    = {};
    global.goblin_block_set = {};
    with (obj_dirt) {
        var _k = string(x) + "_" + string(y);
        if (contains_mine) {
            variable_struct_set(global.ore_block_map, _k, mine_type);
        }
        if (goblin_trap) {
            variable_struct_set(global.goblin_block_set, _k, true);
        }
    }
}

/// Restore ore/goblin assignments to room-reset dirt blocks.
/// Call this on every subsequent rm_mining_area Room Start.
function mining_area_restore_assignments() {
    with (obj_dirt) {
        var _k = string(x) + "_" + string(y);
        if (variable_struct_exists(global.ore_block_map, _k)) {
            contains_mine = true;
            mine_type     = variable_struct_get(global.ore_block_map, _k);
            var _ore_def  = variable_struct_get(global.ore_data, mine_type);
            hp            = _ore_def.block_hp;
            flash_timer   = room_speed * 1000;
        }
        if (variable_struct_exists(global.goblin_block_set, _k)) {
            goblin_trap = true;
        }
    }
}
