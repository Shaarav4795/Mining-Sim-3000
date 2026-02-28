function mine_try_break_nearby(px, py, power) {
    var target = instance_nearest(px, py, obj_dirt_block);
    if (target == noone) return false;
    if (point_distance(px, py, target.x, target.y) > 44) return false;

    with (target) {
        hp -= power;
        flash_timer = 4;

        if (hp <= 0) {
            if (contains_mine) {
                var state = variable_struct_get(global.mine_state, mine_type);
                state.discovered = true;
                variable_struct_set(global.mine_state, mine_type, state);

                var entrance = instance_create_layer(x, y, "Instances", obj_mine_entrance);
                entrance.ore_key = mine_type;
            }
            instance_destroy();
        }
    }

    return true;
}

function player_fire_weapon(px, py, angle) {
    if (global.fire_cooldown > 0) return;

    var cooldowns = [20, 12, 28, 35];
    global.fire_cooldown = cooldowns[global.weapon_tier];

    if (global.weapon_tier == 0) {
        with (obj_goblin) {
            if (point_distance(other.x, other.y, x, y) < 34) hp -= 20;
        }
        with (obj_boss) {
            if (point_distance(other.x, other.y, x, y) < 40) hp -= 12;
        }
        return;
    }

    var shot = instance_create_layer(px, py, "Instances", obj_projectile);
    shot.direction = angle;
    shot.image_angle = angle;

    if (global.weapon_tier == 1) {
        shot.speed = 9;
        shot.damage = 12;
        shot.life = 60;
        shot.explode_radius = 0;
    } else if (global.weapon_tier == 2) {
        shot.speed = 6;
        shot.damage = 30;
        shot.life = 70;
        shot.explode_radius = 0;
    } else {
        shot.speed = 5;
        shot.damage = 22;
        shot.life = 45;
        shot.explode_radius = 64;
    }
}
