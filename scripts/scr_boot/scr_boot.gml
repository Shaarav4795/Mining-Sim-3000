function game_boot_init() {
    if (variable_global_exists("boot_done") && global.boot_done) return;

    global.boot_done = true;
    global.money = 50;
    global.player_hp_max = 100;
    global.player_hp = global.player_hp_max;

    global.pickaxe_tier = 0;
    global.pickaxe_names = ["Silver", "Gold", "Diamond", "Diamond MAX"];
    global.pickaxe_power = [1, 2, 3, 9999];
    // Steps to mine one dirt block per tier (1.8s base at 60fps, +50% speed each tier)
    global.pickaxe_mine_duration = [108, 72, 48, 32];

    global.weapon_tier = 0;
    global.weapon_names = ["Knife", "Pistol", "Grenade"];

    global.fire_cooldown = 0;
    global.passive_buffer = 0;
    global.game_won = false;
    global.minigame_active = false;
    global.current_mine = "";

    // Mine entrance persistence helpers
    global.player_return_x = 208;
    global.player_return_y = 336;
    global.mining_area_initialized = false;

    // Upgrade confirmation popup
    global.worker_msg       = "";
    global.worker_msg_timer = 0;

    global.ore_data   = ore_data_build();
    global.mine_state = {};

    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        variable_struct_set(global.mine_state, key, {
            discovered:  false,
            unlocked:    false,
            worker_level: 0,
            cooldown:    0,
            entrance_x:  0,
            entrance_y:  0
        });
    }

    global.mined_dirt_positions = [];  // tracks mined block positions for room-reload cleanup
    global.pending_ore = "";
    global.hub_generated = false;

    // Saved mine-area block layouts (populated on first visit)
    global.ore_block_map    = {};
    global.goblin_block_set = {};
}
