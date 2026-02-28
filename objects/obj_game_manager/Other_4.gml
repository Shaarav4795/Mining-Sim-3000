// Room Start event — runs every time this persistent object enters a new room
if (room == rm_mining_area && instance_number(obj_dirt) > 0) {
    // Check if any ores have already been assigned (e.g. player returned to room)
    var already_assigned = false;
    with (obj_dirt) {
        if (contains_mine) { already_assigned = true; break; }
    }
    if (!already_assigned) {
        mining_area_assign_ores();
    }
}
