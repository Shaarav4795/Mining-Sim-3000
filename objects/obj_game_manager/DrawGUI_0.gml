// ── Toast (upgrade / worker feedback) — drawn on the GUI layer so it is always on top ──
if (global.worker_msg_timer > 0) {
    var _gw  = display_get_gui_width();
    var _gh  = display_get_gui_height();
    var _ta  = min(1.0, global.worker_msg_timer / 30.0);
    draw_set_alpha(_ta);
    var _msg = global.worker_msg;
    var _mw  = string_width(_msg) + 28;
    var _mh  = 32;
    var _mx  = (_gw - _mw) * 0.5;
    var _my  = _gh * 0.72;
    var _isbad = (string_pos("Need", _msg) > 0 || string_pos("maxed", _msg) > 0
               || string_pos("Not enough", _msg) > 0 || string_pos("already", _msg) > 0
               || string_pos("max level", _msg) > 0);
    draw_set_color(_isbad ? make_color_rgb(120, 10, 10) : make_color_rgb(10, 80, 10));
    draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, false);
    draw_set_color(_isbad ? c_red : c_lime);
    draw_rectangle(_mx, _my, _mx + _mw, _my + _mh, true);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _my + 8, _msg);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}
draw_set_color(c_white);
