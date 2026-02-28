function game_boot_init() {
    if (variable_global_exists("boot_done") && global.boot_done) return;

    global.boot_done = true;
    global.money = 30;
    global.player_hp_max = 100;
    global.player_hp = global.player_hp_max;

    global.pickaxe_tier = 0;
    global.pickaxe_names = ["Starter", "Silver", "Gold", "Diamond"];
    global.pickaxe_power = [1, 2, 3, 9999];

    global.weapon_tier = 0;
    global.weapon_names = ["Knife", "Pistol", "RPG", "Grenade"];

    global.fire_cooldown = 0;
    global.passive_buffer = 0;
    global.game_won = false;
    global.minigame_active = false;
    global.current_mine = "";

    global.ore_data = ore_data_build();
    global.mine_state = {};

    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        variable_struct_set(global.mine_state, key, {
            discovered: false,
            unlocked: false,
            worker_level: 0,
            cooldown: 0
        });
    }

    global.pending_ore = "";
    global.hub_generated = false;
}
