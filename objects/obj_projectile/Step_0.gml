life--;
if (life <= 0) {
    instance_destroy();
    exit;
}

if (place_meeting(x, y, obj_dirt)) {
    if (explode_radius <= 0) instance_destroy();
}

var hit = instance_place(x, y, obj_goblin);
if (hit != noone) {
    if (explode_radius > 0) {
        with (obj_goblin) {
            if (point_distance(other.x, other.y, x, y) <= other.explode_radius) hp -= other.damage;
        }
        with (obj_boss) {
            if (point_distance(other.x, other.y, x, y) <= other.explode_radius) hp -= other.damage;
        }
    } else {
        hit.hp -= damage;
    }
    instance_destroy();
    exit;
}

var boss_hit = instance_place(x, y, obj_boss);
if (boss_hit != noone) {
    if (explode_radius > 0) {
        with (obj_boss) {
            if (point_distance(other.x, other.y, x, y) <= other.explode_radius) hp -= other.damage;
        }
    } else {
        boss_hit.hp -= damage;
    }
    instance_destroy();
}
