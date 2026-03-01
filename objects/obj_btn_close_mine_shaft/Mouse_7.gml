// Return to surface from mine room
if (instance_exists(obj_player)) {
    with (obj_player) {
        visible = true;
        x = 208;
        y = 752;
    }
}
global.current_mine = "";
room_goto(rm_mining_area);
