wobble_timer++;

if (hp <= 0) {
    global.money += 8;
    instance_destroy();
    exit;
}

if (hit_flash_timer > 0) hit_flash_timer--;
if (!instance_exists(obj_player)) exit;

var px   = obj_player.x;
var py   = obj_player.y;
var dist = point_distance(x, y, px, py);

// ── Desired velocity toward player (with slight wobble per goblin) ──
var target_vx = 0;
var target_vy = 0;

if (dist > 1) {
    var chase_dir = point_direction(x, y, px, py);
    var wobble    = (dist > 70) ? sin(wobble_timer * 0.07) * 30 : 0;
    var final_dir = chase_dir + wobble + path_offset * 0.2;
    target_vx = lengthdir_x(move_speed, final_dir);
    target_vy = lengthdir_y(move_speed, final_dir);
}

// Smooth toward desired velocity
vx += (target_vx - vx) * 0.25;
vy += (target_vy - vy) * 0.25;

// ── Separation: push away from nearby goblins ──
with (obj_goblin) {
    if (id == other.id) continue;
    var _sd = point_distance(other.x, other.y, x, y);
    if (_sd < 28 && _sd > 0.5) {
        var _sdir = point_direction(x, y, other.x, other.y);
        var _str  = 1.8 * (28 - _sd) / 28;
        other.vx += lengthdir_x(_str, _sdir);
        other.vy += lengthdir_y(_str, _sdir);
    }
}

// Speed cap
var spd = point_distance(0, 0, vx, vy);
if (spd > move_speed) {
    vx = vx / spd * move_speed;
    vy = vy / spd * move_speed;
}

// ── Wall-slide movement: zero blocked axis, slide along free axis ──
var moved = false;

var can_x = !place_meeting(x + vx, y, obj_dirt);
var can_y = !place_meeting(x, y + vy, obj_dirt);

if (can_x && can_y) {
    x += vx;
    y += vy;
    moved = true;
} else if (can_x) {
    x += vx;
    vy = 0;
    moved = true;
} else if (can_y) {
    vx = 0;
    y += vy;
    moved = true;
} else {
    // Fully blocked — kill velocity
    vx = 0;
    vy = 0;
}

// ── Stuck escape: if surrounded by walls, nudge toward player ignoring walls ──
if (!moved) {
    stuck_timer++;
    if (stuck_timer > 20) {
        x += lengthdir_x(move_speed * 0.8, point_direction(x, y, px, py));
        y += lengthdir_y(move_speed * 0.8, point_direction(x, y, px, py));
        stuck_timer = 0;
    }
} else {
    stuck_timer = 0;
}

// ── Attack player on contact ──
if (attack_cd > 0) attack_cd--;
if (dist < 24 && attack_cd <= 0) {
    global.player_hp -= 8;
    attack_cd = 35;
    if (instance_exists(obj_player)) {
        obj_player.hurt_timer = 22;
    }
}
