if (result != "") {
    result_timer++;
    if (result_timer > 90) {
        minigame_resolve(result == "win");
    }
    exit;
}

if (flash_wrong > 0) { flash_wrong--; exit; }

// Key presses A-F to guess
var pressed = -1;
if (keyboard_check_pressed(ord("A"))) pressed = 0;
if (keyboard_check_pressed(ord("B"))) pressed = 1;
if (keyboard_check_pressed(ord("C"))) pressed = 2;
if (keyboard_check_pressed(ord("D"))) pressed = 3;
if (keyboard_check_pressed(ord("E"))) pressed = 4;
if (keyboard_check_pressed(ord("F"))) pressed = 5;

if (pressed >= 0 && !eliminated[pressed]) {
    if (pressed == correct_idx) {
        result = "win";
        result_timer = 0;
    } else {
        eliminated[pressed] = true;
        attempts_left--;
        flash_wrong = 20;
        if (attempts_left <= 0) {
            result = "lose";
            result_timer = 0;
        }
    }
}
