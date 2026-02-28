anim += 6;
var state = variable_struct_get(global.mine_state, ore_key);
level = state.worker_level;

if (!state.unlocked || level <= 0) {
    instance_destroy();
}
