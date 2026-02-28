// Ensure game manager exists
if (!instance_exists(obj_game_manager)) {
    instance_create_layer(0, 0, "Instances", obj_game_manager);
}

// Kill duplicate player instances (keep only one)
var cnt = instance_number(obj_player);
for (var i = cnt - 1; i >= 1; i--) {
    instance_destroy(instance_find(obj_player, i));
}

// If no player at all, create one
if (!instance_exists(obj_player)) {
    instance_create_layer(208, 336, "Instances", obj_player);
}

// Restore player position and visibility (returning from mine rooms)
with (obj_player) {
    visible = true;
    x = 208;
    y = 336;
    mine_target = noone;
    mine_timer = 0;
}
