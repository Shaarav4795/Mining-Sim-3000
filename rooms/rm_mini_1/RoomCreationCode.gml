if (!instance_exists(obj_game_manager)) {
    instance_create_layer(64, 64, "Instances", obj_game_manager);
}

if (instance_exists(obj_player)) {
    with (obj_player) visible = false;
}

if (!instance_exists(obj_minigame_controller)) {
    instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", obj_minigame_controller);
}
