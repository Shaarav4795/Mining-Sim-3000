draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var y = 12;
draw_text(12, y, "Money: $" + string(floor(global.money))); y += 20;
draw_text(12, y, "HP: " + string(global.player_hp) + "/" + string(global.player_hp_max)); y += 20;
draw_text(12, y, "Pickaxe: " + global.pickaxe_names[global.pickaxe_tier]); y += 20;
draw_text(12, y, "Weapon: " + global.weapon_names[global.weapon_tier]); y += 20;

if (global.weapon_tier < 2) {
    draw_text(12, y, "Objective: Buy RPG/Grenade and press B for boss room");
} else if (!global.game_won) {
    draw_text(12, y, "Objective: Press B to fight rival boss");
} else {
    draw_set_color(c_lime);
    draw_text(12, y, "Victory! Family rescued from Mega-Mining Corp.");
}
