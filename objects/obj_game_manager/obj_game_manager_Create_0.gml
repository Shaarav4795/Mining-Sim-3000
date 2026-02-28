game_boot_init();

if (room == rm_hub && instance_number(obj_dirt_block) <= 0) {
    hub_generate_blocks();
}
