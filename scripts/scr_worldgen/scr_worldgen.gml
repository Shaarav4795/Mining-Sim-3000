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
            var dirt = instance_create_layer(px, py, "Instances", obj_dirt_block);
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
