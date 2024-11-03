/// @description
state = states.IDLE;

//initialize previous positions
xp = x;
yp = y;

facing = 1;

hsp = 0;
vsp = 0;

//How long we are knocked back for
knockback_time = 0;

hurt_time = 30; //Hurt frames (invincibility frames essentially)

flash_initial = 16;
flash = flash_initial / 2;
show_flash_initial = 4;
show_flash = show_flash_initial;

//dust
create_dust_timer_initial = 8;
create_dust_timer = 0;