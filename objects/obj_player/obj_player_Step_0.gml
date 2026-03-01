// Pause controls during minigame overlay
if (variable_global_exists("minigame_active") && global.minigame_active) exit;

var input_x = (keyboard_check(ord("D")) || keyboard_check(vk_right)) - (keyboard_check(ord("A")) || keyboard_check(vk_left));
var input_y = (keyboard_check(ord("S")) || keyboard_check(vk_down)) - (keyboard_check(ord("W")) || keyboard_check(vk_up));

// Update facing direction when moving
if (input_x != 0 || input_y != 0) {
    facing_x = input_x;
    facing_y = input_y;
    var flen = point_distance(0, 0, facing_x, facing_y);
    facing_x = facing_x / flen;
    facing_y = facing_y / flen;
}

var move_x = 0;
var move_y = 0;
if (input_x != 0 || input_y != 0) {
    var mlen = point_distance(0, 0, input_x, input_y);
    move_x = (input_x / mlen) * move_speed;
    move_y = (input_y / mlen) * move_speed;
}

// Hitbox half-size — kept small to match the scaled-down sprite visual
var hs = 8;

// ── Leading-edge collision: only probe the face advancing toward a wall ──
// This prevents the asymmetric gap/phasing caused by checking the full new bbox.
var blocked_x = false;
if (move_x > 0) {
    // Sweep the right edge from its current position to the new position
    blocked_x = collision_rectangle(x + hs, y - hs + 1,
                                    x + move_x + hs, y + hs - 1,
                                    obj_dirt, false, true) != noone;
} else if (move_x < 0) {
    // Sweep the left edge
    blocked_x = collision_rectangle(x + move_x - hs, y - hs + 1,
                                    x - hs, y + hs - 1,
                                    obj_dirt, false, true) != noone;
}

var blocked_y = false;
if (move_y > 0) {
    // Sweep the bottom edge
    blocked_y = collision_rectangle(x - hs + 1, y + hs,
                                    x + hs - 1, y + move_y + hs,
                                    obj_dirt, false, true) != noone;
} else if (move_y < 0) {
    // Sweep the top edge
    blocked_y = collision_rectangle(x - hs + 1, y + move_y - hs,
                                    x + hs - 1, y - hs,
                                    obj_dirt, false, true) != noone;
}

if (!blocked_x) x += move_x;
if (!blocked_y) y += move_y;

x = clamp(x, 16, room_width  - 16);
y = clamp(y, 16, room_height - 16);

// ── Directional mining timer ──
var is_pressing = (input_x != 0 || input_y != 0);
if (is_pressing && (blocked_x || blocked_y)) {
    var hit = noone;

    if (blocked_x) {
        var dx  = sign(move_x);
        facing_x = dx;
        facing_y = 0;
        var ex  = x + dx * hs;
        var ex2 = ex + dx * 34;
        hit = collision_rectangle(min(ex, ex2), y - hs, max(ex, ex2), y + hs,
                                  obj_dirt, false, true);
    }

    if (hit == noone && blocked_y) {
        var dy  = sign(move_y);
        facing_x = 0;
        facing_y = dy;
        var ey  = y + dy * hs;
        var ey2 = ey + dy * 34;
        hit = collision_rectangle(x - hs, min(ey, ey2), x + hs, max(ey, ey2),
                                  obj_dirt, false, true);
    }

    if (hit != noone) {
        if (mine_target != hit) {
            mine_target = hit;
            mine_timer  = 0;
        }
        mine_timer++;
        if (mine_timer >= global.pickaxe_mine_duration[global.pickaxe_tier]) {
            with (mine_target) {
                // Record this block's position so it stays removed when rm_mining_area reloads
                array_push(global.mined_dirt_positions, string(x) + "_" + string(y));
                if (contains_mine) {
                    var state = variable_struct_get(global.mine_state, mine_type);
                    state.discovered  = true;
                    state.entrance_x  = x;
                    state.entrance_y  = y;
                    variable_struct_set(global.mine_state, mine_type, state);
                    var entrance = instance_create_layer(x, y, "Instances", obj_mine_entrance);
                    entrance.ore_key = mine_type;
                }
                // Goblin trap: break spawns 3 goblins
                if (goblin_trap) {
                    for (var _gi = 0; _gi < 3; _gi++) {
                        instance_create_layer(x + irandom_range(-24, 24), y + irandom_range(-24, 24), "Instances", obj_goblin);
                    }
                }
                instance_destroy();
            }
            mine_target = noone;
            mine_timer  = 0;
        }
    } else {
        mine_target = noone;
        mine_timer  = 0;
    }
} else {
    mine_target = noone;
    mine_timer  = 0;
}

// ── Weapon (mouse only) ──
aim_dir = point_direction(x, y, mouse_x, mouse_y);
if (mouse_check_button_pressed(mb_left)) {
    player_fire_weapon(x, y, aim_dir);
}

// ── K: single closest goblin attack (weapon-range gated) ──
if (keyboard_check_pressed(ord("K")) && global.fire_cooldown <= 0) {
    // Attack ranges (px) and damage per weapon tier: Knife, Pistol, Grenade
    var _wranges = [50, 200, 250];
    var _wdmg    = [20,  30,  45];
    var _range   = _wranges[global.weapon_tier];
    var _dmg     = _wdmg[global.weapon_tier];

    var _nearest      = noone;
    var _nearest_dist = 999999;
    with (obj_goblin) {
        var _d = point_distance(other.x, other.y, x, y);
        if (_d < _range && _d < _nearest_dist) {
            _nearest_dist = _d;
            _nearest      = id;
        }
    }
    if (_nearest != noone && instance_exists(_nearest)) {
        _nearest.hp -= _dmg;
        _nearest.hit_flash_timer = 25;
        global.fire_cooldown = 20;  // share cooldown with normal weapon
    }
}
