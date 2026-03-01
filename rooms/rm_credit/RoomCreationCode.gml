if (!instance_exists(obj_game_manager)) {
    instance_create_layer(64, 64, "Instances", obj_game_manager);
}

if (!instance_exists(obj_player)) {
    instance_create_layer(150, room_height * 0.5, "Instances", obj_player);
} else {
    with (obj_player) {
        x = 150;
        y = room_height * 0.5;
        visible = true;
    }
}

if (!instance_exists(obj_boss)) {
    instance_create_layer(room_width - 220, room_height * 0.5, "Instances", obj_boss);
}
