/// @description Are we chasing the player?
event_inherited();

hp_max = 15;
hp = hp_max;

alert = false;

//Distance we can start chasing the player
alert_dis = 160;

//Set distance we stop from the player
attack_dis = 12;

//The frame we perform the attack
attack_frame = 6;

//can we attack
can_attack = true;

//attack delay
attack_cooldown = 75;

//How much damage is dealt?
damage = 2;

//How long the player is knocked back for
knockback_time = 10;

//create path resources
path = path_add();

//Speed we chase the player
move_spd = 1;

//Set delay for calculating path
calc_path_delay = 30;

//Set a timer for when we calculate a path
calc_path_timer = irandom(60);