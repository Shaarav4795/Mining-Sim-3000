// Draw GUI — popup + ore-room HUD (always renders on top of room visuals)

// ── Upgrade confirmation popup ──
if (global.upgrade_popup_active) {
    draw_upgrade_popup();
    exit;
}

// ── Ore room corner HUD ──
var is_ore_room = (room == rm_coal || room == rm_diamond || room == rm_gold
                || room == rm_opal || room == rm_uranium);
if (is_ore_room) {
    var ore_key = global.current_mine;
    if (ore_key == "") exit;
    var ore   = variable_struct_get(global.ore_data,  ore_key);
    var state = variable_struct_get(global.mine_state, ore_key);
    draw_mine_ore_room_hud(ore_key, ore, state);
}
