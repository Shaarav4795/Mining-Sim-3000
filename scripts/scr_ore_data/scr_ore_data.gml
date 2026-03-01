function ore_data_build() {
    return {
        coal:    { display: "Coal",    unlock_fee: 15,  output_pm: 50,  minigame_difficulty: 0.25, block_hp: 3, color: make_color_rgb(70, 70, 70) },
        opal:    { display: "Opal",    unlock_fee: 30,  output_pm: 100, minigame_difficulty: 0.40, block_hp: 4, color: make_color_rgb(113, 194, 230) },
        gold:    { display: "Gold",    unlock_fee: 50,  output_pm: 150, minigame_difficulty: 0.55, block_hp: 5, color: make_color_rgb(255, 200, 0) },
        diamond: { display: "Diamond", unlock_fee: 80,  output_pm: 250, minigame_difficulty: 0.70, block_hp: 6, color: make_color_rgb(170, 255, 255) },
        uranium: { display: "Uranium", unlock_fee: 120, output_pm: 400, minigame_difficulty: 0.85, block_hp: 7, color: make_color_rgb(80, 230, 120) }
    };
}

function ore_keys() {
    return ["coal", "opal", "gold", "diamond", "uranium"];
}

function ore_get_room(key) {
    if (key == "coal")    return rm_coal;
    if (key == "opal")    return rm_opal;
    if (key == "gold")    return rm_gold;
    if (key == "diamond") return rm_diamond;
    if (key == "uranium") return rm_uranium;
    return rm_mining_area;
}

function ore_get_bg_color(key) {
    if (key == "coal")    return make_color_rgb(14, 10, 8);
    if (key == "opal")    return make_color_rgb(8, 14, 20);
    if (key == "gold")    return make_color_rgb(20, 15, 2);
    if (key == "diamond") return make_color_rgb(8, 18, 22);
    if (key == "uranium") return make_color_rgb(6, 18, 8);
    return make_color_rgb(12, 8, 6);
}
