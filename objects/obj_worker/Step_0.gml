anim += 4;
var state = variable_struct_get(global.mine_state, ore_key);
level = state.worker_level;

// Destroy only if worker level is 0 (not yet hired)
if (level <= 0) {
    instance_destroy();
    exit;
}

// Speed scales with worker level (Lv.1 = 1.5, Lv.5 = 3.0)
var spd = walk_speed * (1.0 + (level - 1) * 0.375);

// Move toward current waypoint
var tx   = path_pts[path_idx][0];
var ty   = path_pts[path_idx][1];
var dist = point_distance(x, y, tx, ty);

if (dist <= spd + 1) {
    x = tx;
    y = ty;
    // Advance index
    path_idx += path_dir;
    var total = array_length(path_pts);
    if (path_idx >= total) {
        path_dir = -1;
        path_idx = total - 2;
    } else if (path_idx < 0) {
        path_dir = 1;
        path_idx = 1;
    }
} else {
    var ang = point_direction(x, y, tx, ty);
    x += lengthdir_x(spd, ang);
    y += lengthdir_y(spd, ang);
    // Update face direction only when moving horizontally
    if (abs(tx - x) > 4) face_dir = sign(tx - x);
}
