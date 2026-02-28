cursor_t += cursor_speed * move_dir;
if (cursor_t >= 1) { cursor_t = 1; move_dir = -1; }
if (cursor_t <= 0) { cursor_t = 0; move_dir = 1; }

if (keyboard_check_pressed(vk_space)) {
    var z0 = zone_center - zone_width * 0.5;
    var z1 = zone_center + zone_width * 0.5;
    var success = (cursor_t >= z0 && cursor_t <= z1);
    minigame_resolve(success);
}
