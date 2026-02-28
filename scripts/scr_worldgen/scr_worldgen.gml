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
        }
    }
}
