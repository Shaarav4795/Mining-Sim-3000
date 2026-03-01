if (!instance_exists(obj_game_manager)) {
    instance_create_layer(64, 64, "Instances", obj_game_manager);
}

if (!instance_exists(obj_player)) {
    instance_create_layer(96, 96, "Instances", obj_player);
} else {
    with (obj_player) {
        x = 96;
        y = 96;
        visible = true;
    }
}

if (instance_number(obj_goblin) < 4) {
    for (var i = instance_number(obj_goblin); i < 4; i++) {
        instance_create_layer(irandom_range(420, 980), irandom_range(180, 620), "Instances", obj_goblin);
    }
}
