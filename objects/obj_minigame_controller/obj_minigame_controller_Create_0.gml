depth = -9000;

// ── Hacking question pools per ore ──
// Each pool: [answer_idx, [opt0..opt5], clue1, clue2, clue3]
// 4 pools per ore for variety.

pools_coal = [
    [2, ["0x1A", "0xCC", "0xFF", "0x4B", "0x3E", "0xAA"],
        "CLUE: Decimal value is 75",    "CLUE: Hex range 0x40-0x4F",    "CLUE: Used as a bitwise XOR mask in FUEL protocols"],
    [4, ["BURN", "SOOT", "DARK", "DUST", "HEAT", "MINE"],
        "CLUE: Describes thermal energy",  "CLUE: Starts with H",   "CLUE: Category: COMBUSTION"],
    [1, ["FTP", "SSH", "RDP", "SMB", "DNS", "IRC"],
        "CLUE: Secure shell protocol",    "CLUE: Port 22",           "CLUE: Used for encrypted remote access"],
    [3, ["HARD", "CORE", "COAL", "DARK", "SLAB", "VEIN"],
        "CLUE: 4 letters; a type of ore deposit",  "CLUE: Starts with D",  "CLUE: Category: FUEL"],
];

pools_opal = [
    [0, ["IRIS", "FLUX", "NOVA", "JAZZ", "MIST", "GLOW"],
        "CLUE: Coloured part of the eye",      "CLUE: Starts with I",  "CLUE: Category: OPTICS"],
    [5, ["0x0F", "0xB2", "0x7C", "0x33", "0xE9", "0xD4"],
        "CLUE: Decimal value is 212",           "CLUE: Hex range 0xD0-0xDF",  "CLUE: Byte checksum in IRIS protocol v2"],
    [2, ["PING", "SCAN", "FUZZ", "PROX", "EMIT", "BEAM"],
        "CLUE: Penetration-test technique",     "CLUE: Starts with F",   "CLUE: Fires random data at a target"],
    [4, ["HAZE", "GLOW", "FIRE", "MIST", "PRISM","IRIS"],
        "CLUE: Atmospheric optical effect",  "CLUE: Rhymes with FIST",  "CLUE: Category: LIGHT PHENOMENA"],
];

pools_gold = [
    [3, ["HTTP", "SMTP", "IMAP", "GOLD", "COIN", "RICH"],
        "CLUE: 4-letter precious alloy code-name", "CLUE: Starts with G",  "CLUE: Category: WEALTH"],
    [1, ["0x01", "0xAU", "0xFE", "0x79", "0xC0", "0x1D"],
        "CLUE: Atomic number 79 in hex",    "CLUE: Hex: 0x4F",           "CLUE: Element Au; periodic table index"],
    [5, ["KING", "GILT", "BOLD", "COIN", "LORE", "RICH"],
        "CLUE: 4 letters; means wealthy",   "CLUE: Starts with R",  "CLUE: Opposite of POOR"],
    [0, ["ROOT", "SUDO", "EXEC", "PRIV", "ESCT", "DUMP"],
        "CLUE: Superuser account name",     "CLUE: Starts with R",  "CLUE: Category: SYSTEM ACCESS"],
];

pools_diamond = [
    [2, ["HARD", "RARE", "APEX", "EDGE", "FIRM", "PURE"],
        "CLUE: The highest point",       "CLUE: Starts with A",   "CLUE: Category: STRENGTH"],
    [4, ["0xDE", "0xAD", "0xBE", "0xEF", "0xFF", "0x00"],
        "CLUE: Famous magic hex sequence: DEAD????", "CLUE: 4th byte of 0xDEADBEEF", "CLUE: Hex value: 0xEF"],
    [1, ["AES", "RSA", "MD5", "SHA", "RC4", "DES"],
        "CLUE: Asymmetric key algorithm",  "CLUE: Named after Rivest Shamir Adleman", "CLUE: Used in HTTPS certificates"],
    [3, ["ZERO", "BYTE", "EDGE", "NULL", "FLAG", "CORE"],
        "CLUE: Represents absence of value", "CLUE: 4 letters; starts with N", "CLUE: Causes the feared NULL pointer exception"],
];

pools_uranium = [
    [2, ["235", "238", "239", "236", "232", "233"],
        "CLUE: Fissile isotope used in reactors",  "CLUE: Mass number between 238 and 235", "CLUE: Produced by neutron capture on U-238"],
    [0, ["ATOM", "FLUX", "HALF", "NOVA", "GLOW", "CORE"],
        "CLUE: Smallest unit of matter",   "CLUE: Starts with A",  "CLUE: Category: NUCLEAR PHYSICS"],
    [4, ["0xFF", "0x00", "0xE6", "0x2A", "0x55", "0xF0"],
        "CLUE: Decimal value 85",          "CLUE: Alternating bits: 01010101", "CLUE: Hex checksum in REACTOR-v5 firmware"],
    [3, ["TCP", "UDP", "TLS", "SSL", "IPV", "VPN"],
        "CLUE: Deprecated encryption wrapper",  "CLUE: Precursor to TLS",  "CLUE: Secure Sockets Layer (abbrev)"],
];

// Pick ore-specific pool list
var k = global.pending_ore;
var pool_list;
if      (k == "coal")    pool_list = pools_coal;
else if (k == "opal")    pool_list = pools_opal;
else if (k == "gold")    pool_list = pools_gold;
else if (k == "diamond") pool_list = pools_diamond;
else                     pool_list = pools_uranium;

// Pick a random pool
var pool = pool_list[irandom(array_length(pool_list) - 1)];

correct_idx  = pool[0];
options      = pool[1];
clue1        = pool[2];
clue2        = pool[3];
clue3        = pool[4];
correct_word = options[correct_idx];

// Eliminated slots
eliminated = array_create(6, false);

attempts_left = 3;
result        = ""; // "win" | "lose" | ""
result_timer  = 0;
flash_wrong   = 0;

ore_display = variable_struct_get(global.ore_data, k).display;
ore_color   = variable_struct_get(global.ore_data, k).color;
