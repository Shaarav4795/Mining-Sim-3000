if (!instance_exists(obj_player)) exit;

var near = point_distance(x, y, obj_player.x, obj_player.y) < 48;
if (!near) exit;

var pickaxe_costs = [35, 80, 150];

if (keyboard_check_pressed(ord("1")) && global.pickaxe_tier < 3) {
    var p_cost = pickaxe_costs[global.pickaxe_tier];
    if (global.money >= p_cost) {
        global.money -= p_cost;
        global.pickaxe_tier += 1;
    }
}

if (keyboard_check_pressed(ord("2")) && global.weapon_tier < 1 && global.money >= 40) {
    global.money -= 40;
    global.weapon_tier = 1;
}

if (keyboard_check_pressed(ord("3")) && global.weapon_tier < 2 && global.money >= 120) {
    global.money -= 120;
    global.weapon_tier = 2;
}

if (keyboard_check_pressed(ord("4")) && global.money >= 90) {
    global.money -= 90;
    global.weapon_tier = 3;
}
