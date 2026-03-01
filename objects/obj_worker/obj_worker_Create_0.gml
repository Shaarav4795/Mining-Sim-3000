ore_key    = "coal";
level      = 1;
anim       = 0;
walk_speed = 1.5;
face_dir   = 1;  // 1 = right, -1 = left

// Snake-path waypoints that match the spr_path tiles in the mine rooms
// Each waypoint is [x, y] in room coordinates (path tile centres +16)
path_pts = [
    [16,  80],  [400, 80],
    [400, 176], [64,  176],
    [64,  240], [400, 240],
    [400, 304], [64,  304],
    [64,  400], [400, 400],
    [400, 464], [64,  464],
    [64,  528], [400, 528],
    [400, 592], [64,  592],
    [64,  672], [400, 672],
    [400, 752], [64,  752],
];
path_idx = 0;
path_dir = 1;  // 1 = forward through array, -1 = reverse

x = path_pts[0][0];
y = path_pts[0][1];
depth = -50;  // draw above ore blocks
