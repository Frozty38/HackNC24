
event_inherited();
walk_spd = 1.5;
hp_max = 10;
hp = hp_max;

//bow
aim_dir = 0;
bow_dis = 11;
fire_rate = 30;
can_attack = true;
arrow_speed = 8;

my_bow = instance_create_layer(x, y, "Instances", o_bow);

cursor_sprite = s_cursor;
window_set_cursor(cr_none);

ready_to_restart = false; //Ensures we can restart after death animation

//bomb
can_throw_bomb = true;	//Can the player throw the bomb now?
bomb_cooldown = 120;	//How long until the bomb is ready to throw again?
bomb_power = 8;			//How far will we throw the bomb?

//dash
dash_spd = 4;
dash_arr = [];
can_dash = true;
dash_cooldown = 120;
dash_timer_initial = 15;
dash_timer = dash_timer_initial;