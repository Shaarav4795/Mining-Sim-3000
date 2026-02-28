// Mine room 3: gold
global.current_mine = "gold";

// Hide player while in mine management screen
if (instance_exists(obj_player)) {
    with (obj_player) visible = false;
}

// Ensure game manager is alive
if (!instance_exists(obj_game_manager)) {
    instance_create_layer(0, 0, "Instances", obj_game_manager);
}
