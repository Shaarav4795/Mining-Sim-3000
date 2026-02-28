bar_x = room_width * 0.5;
bar_y = room_height * 0.5;
bar_w = 420;
bar_h = 24;

cursor_t = 0;
cursor_speed = 0.02;
move_dir = 1;

zone_center = random_range(0.25, 0.75);
zone_width = 0.35;

var ore = variable_struct_get(global.ore_data, global.pending_ore);
zone_width = clamp(0.42 - ore.minigame_difficulty * 0.25, 0.12, 0.4);
cursor_speed = 0.016 + ore.minigame_difficulty * 0.02;
