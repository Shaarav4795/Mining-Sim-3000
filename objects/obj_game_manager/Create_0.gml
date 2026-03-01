game_boot_init();

if (room == rm_hub && instance_number(obj_dirt) <= 0) {
    hub_generate_blocks();
}

// Safety-init variables that may be missing in an already-running session
if (!variable_global_exists("worker_msg"))       global.worker_msg       = "";
if (!variable_global_exists("worker_msg_timer")) global.worker_msg_timer = 0;
