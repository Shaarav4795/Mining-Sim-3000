depth = -9000;

// Password sets per ore type [6 options each]
// Layout: [word, word, word, word, word, word]
pw_coal    = ["DARK", "SOOT", "MINE", "BURN", "DUST", "HEAT"];
pw_opal    = ["FIRE", "GLOW", "IRIS", "JAZZ", "HAZE", "MIST"];
pw_gold    = ["RICH", "KING", "GILT", "COIN", "LORE", "BOLD"];
pw_diamond = ["HARD", "RARE", "APEX", "EDGE", "FIRM", "PURE"];
pw_uranium = ["ATOM", "GLOW", "NOVA", "FLUX", "CORE", "HALF"];

// Category hints per ore type
cat_coal    = "FUEL SOURCE";
cat_opal    = "LIGHT PHENOMENA";
cat_gold    = "WEALTH / ROYALTY";
cat_diamond = "STRENGTH";
cat_uranium = "NUCLEAR";

// Load word list for current ore
var k = global.pending_ore;
var all_words;
var category;
if (k == "coal")    { all_words = pw_coal;    category = cat_coal;    }
else if (k == "opal")    { all_words = pw_opal;    category = cat_opal;    }
else if (k == "gold")    { all_words = pw_gold;    category = cat_gold;    }
else if (k == "diamond") { all_words = pw_diamond; category = cat_diamond; }
else                     { all_words = pw_uranium; category = cat_uranium; }

// Pick a random correct answer
correct_idx = irandom(5);
correct_word = all_words[correct_idx];

// Build displayed options array (copy of all_words)
options = array_create(6);
for (var i = 0; i < 6; i++) options[i] = all_words[i];

// Eliminated slots (true = wrong guess, shown greyed)
eliminated = array_create(6, false);

// Clues
clue1 = "LETTERS: " + string(string_length(correct_word));
clue2 = "STARTS WITH: " + string_copy(correct_word, 1, 1);
clue3 = "CATEGORY:  " + category;

attempts_left = 3;
result = ""; // "win" | "lose" | ""
result_timer = 0;
flash_wrong = 0;

ore_display = variable_struct_get(global.ore_data, k).display;
ore_color   = variable_struct_get(global.ore_data, k).color;
