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

// Centered hitbox half-size
var hs = 12;

// Pixel-step collision
var blocked_x = (move_x != 0) && (collision_rectangle(x + move_x - hs, y - hs, x + move_x + hs, y + hs, obj_dirt, false, true) != noone);
var blocked_y = (move_y != 0) && (collision_rectangle(x - hs, y + move_y - hs, x + hs, y + move_y + hs, obj_dirt, false, true) != noone);

if (!blocked_x) x += move_x;
if (!blocked_y) y += move_y;

x = clamp(x, 16, room_width - 16);
y = clamp(y, 16, room_height - 16);

// Directional mining timer
var is_pressing = (input_x != 0 || input_y != 0);
if (is_pressing && (blocked_x || blocked_y)) {
    var hit = noone;

    // Probe exactly one block ahead (player edge + 44px = hs + one 32px block)
    if (blocked_x) {
        var dx  = sign(move_x);
        facing_x = dx;
        facing_y = 0;
        var ex  = x + dx * hs;           // player edge
        var ex2 = ex + dx * 34;          // 34px into the wall (stay within one 32px block)
        hit = collision_rectangle(min(ex, ex2), y - hs, max(ex, ex2), y + hs, obj_dirt, false, true);
    }

    if (hit == noone && blocked_y) {
        var dy  = sign(move_y);
        facing_x = 0;
        facing_y = dy;
        var ey  = y + dy * hs;
        var ey2 = ey + dy * 34;
        hit = collision_rectangle(x - hs, min(ey, ey2), x + hs, max(ey, ey2), obj_dirt, false, true);
    }

    if (hit != noone) {
        if (mine_target != hit) {
            mine_target = hit;
            mine_timer = 0;
        }
        mine_timer++;
        if (mine_timer >= mine_duration) {
            with (mine_target) {
                if (contains_mine) {
                    var state = variable_struct_get(global.mine_state, mine_type);
                    state.discovered = true;
                    variable_struct_set(global.mine_state, mine_type, state);
                    var entrance = instance_create_layer(x, y, "Instances", obj_mine_entrance);
                    entrance.ore_key = mine_type;
                }
                instance_destroy();
            }
            mine_target = noone;
            mine_timer = 0;
        }
    } else {
        mine_target = noone;
        mine_timer = 0;
    }
} else {
    mine_target = noone;
    mine_timer = 0;
}

// Weapon (mouse only)
aim_dir = point_direction(x, y, mouse_x, mouse_y);
if (mouse_check_button_pressed(mb_left)) {
    player_fire_weapon(x, y, aim_dir);
}
