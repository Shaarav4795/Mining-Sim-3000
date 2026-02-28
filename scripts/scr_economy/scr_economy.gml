function worker_multiplier(level) {
    var table = [0, 1.0, 1.8, 2.8, 4.2, 6.0];
    level = clamp(level, 0, 5);
    return table[level];
}

function worker_upgrade_cost(level) {
    level = clamp(level, 0, 4);
    return [20, 40, 75, 120, 180][level];
}

function economy_step() {
    var dt_seconds = delta_time / 1000000;
    var total_per_second = 0;

    var keys = ore_keys();
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        var state = variable_struct_get(global.mine_state, key);

        if (state.cooldown > 0) {
            state.cooldown = max(0, state.cooldown - dt_seconds);
            variable_struct_set(global.mine_state, key, state);
        }

        if (state.unlocked && state.worker_level > 0) {
            var ore = variable_struct_get(global.ore_data, key);
            var per_second = (ore.output_pm / 60) * worker_multiplier(state.worker_level);
            total_per_second += per_second;
        }
    }

    global.passive_buffer += total_per_second * dt_seconds;
    if (global.passive_buffer >= 1) {
        var payout = floor(global.passive_buffer);
        global.money += payout;
        global.passive_buffer -= payout;
    }
}
