// Tick discovery popup
if (discovery_popup_timer > 0) {
    discovery_popup_timer--;
    exit;
}

// Tick cooldown
var state = variable_struct_get(global.mine_state, ore_key);
if (state.cooldown > 0) {
    state.cooldown = max(0, state.cooldown - delta_time / 1000000);
    variable_struct_set(global.mine_state, ore_key, state);
}

if (!instance_exists(obj_player)) exit;
if (global.minigame_active) exit;

var dist = point_distance(x, y, obj_player.x, obj_player.y);
if (dist > 52) exit;

var ore = variable_struct_get(global.ore_data, ore_key);

if (keyboard_check_pressed(ord("E"))) {
    if (!state.unlocked) {
        // Buy + start hacking minigame
        if (state.cooldown <= 0 && global.money >= ore.unlock_fee) {
            global.money -= ore.unlock_fee;
            minigame_start(ore_key);
        }
    } else {
        // Save player's current position so we can return them here on exit
        global.player_return_x = obj_player.x;
        global.player_return_y = obj_player.y;

        // Enter mine room
        global.current_mine = ore_key;
        if (instance_exists(obj_player)) {
            with (obj_player) visible = false;
        }
        room_goto(ore_get_room(ore_key));
    }
}
