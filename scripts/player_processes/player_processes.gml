function reset_variables() 
{
	//Makes sure the variables are always set to 0 when keys are not being pressed
	left = 0;
	right = 0;
	up = 0;
	down = 0;
	
	hmove = 0;
	vmove = 0;
	
	dash = false;
}

function get_input() 
{
	//Gets input from player
	if keyboard_check(ord("A")) left = 1;
	if keyboard_check(ord("D")) right = 1;
	if keyboard_check(ord("W")) up = 1;
	if keyboard_check(ord("S")) down = 1;
	if keyboard_check_pressed(vk_space) dash = true;
}

function calc_movement() 
{
		//This is a local variable, so it doesn't get stored when the program runs
		hmove = right - left; 
		vmove = down - up;
		
		var _facing = (aim_dir < 90 or aim_dir > 270);
		if _facing == 0 _facing = -1;
		facing = _facing;
		
		if hmove != 0 or vmove != 0
		{
			//Get the direction we are moving
			var _dir = point_direction(0, 0, hmove, vmove);
			
			//Get the distance we are moving
			hmove = lengthdir_x(walk_spd, _dir);
			vmove = lengthdir_y(walk_spd, _dir);
			
			//Add movement to the players position
			x += hmove;
			y += vmove;
		}
		
		//apply knockback movement
		x += hsp;
		y += vsp;
		
		//apply drag to knockback
		switch(state)
		{
			default: var _drag = 0.15; break;
			case states.DEAD: var _drag = 0.08; break;
		}
		
		hsp = lerp(hsp, 0, _drag);
		vsp = lerp(vsp, 0, _drag);
		
		
		
}

function aim_bow()
{
	//@desc Gets and sets the bow aim
	aim_dir = point_direction(x, y, mouse_x, mouse_y);
	my_bow.image_angle = aim_dir;	
}

function collision() 
{
	//Set target values
	var _tx = x;
	var _ty = y;
	
	//Move back to last step position, out of the collision
	x = xprevious;
	y = yprevious;
	
	//Get max distance we want to move
	var _disx = ceil(abs(_tx - x));
	var _disy = ceil(abs(_ty - y));
	
	//Ensure we are using integers if colliding in the x/y axis
	if place_meeting(x + _disx * sign(_tx - x), y, o_solid) x = round(x);
	if place_meeting(x, y + _disy * sign(_ty - y), o_solid) y = round(y);
	
	//Move as far as in x and y before hitting the solid
	repeat(_disx) 
	{
		if !place_meeting(x + sign(_tx - x), y, o_solid) x += sign(_tx - x);		
	}
	repeat(_disx) 
	{
		if !place_meeting(x, y + sign(_ty - y), o_solid) y += sign(_ty - y);	
	}
	
}

function collision_bounce()
{
	collision();
	if place_meeting(x + sign(hsp), y, o_solid) hsp = -hsp;
	if place_meeting(x, y + sign(vsp), o_solid) vsp = -vsp;
}

function anim() 
{
	switch(state)
	{
		default:
			if hmove != 0 or vmove != 0
			{
				sprite_index = s_player_walk;	
			}
			else
			{
				sprite_index = s_player_idle;	
			}
		break;
		case states.DEAD:
			sprite_index = s_player_dead;
		break;
	}
	
	depth = -bbox_bottom;	
	
	//update previous position
	xp = x;
	yp = y;

}

function check_fire()
{
	if mouse_check_button(mb_left)
		{
			if can_attack
			{
				can_attack = false;
				alarm[0] = fire_rate;
				
				var _dir = point_direction(x, y, mouse_x, mouse_y);
				bow_dis = 5;
				
				var _inst = instance_create_layer(x, y, "Arrow", o_arrow);
				with(_inst)
				{
					speed = other.arrow_speed;
					direction = _dir;
					image_angle = _dir;
					owner_id = other;
				}
				
				audio_play_sound(snd_bow_fire, 50, 0, 1, 0, random_range(0.6, 1.4))
				
			}
		}
}

function check_bomb()
{
	if mouse_check_button(mb_right)
	{
		if can_throw_bomb 
		{
			can_throw_bomb = false;
			alarm[CAN_THROW_BOMB] = bomb_cooldown;
			var _dir = point_direction(x, y, mouse_x, mouse_y);
			var _inst = instance_create_layer(x, y, "Instances", o_bomb);
			with(_inst)
			{
				hsp = lengthdir_x(other.bomb_power, _dir);	
				vsp = lengthdir_y(other.bomb_power, _dir);
			}
			
			
		}
	}
}

function check_dash()
{
	if dash and can_dash
	{
		state = states.DASH;
		dash_timer = dash_timer_initial;
		//Get directions and distance we are moving
		var _dir = point_direction(0, 0, hmove, vmove);
		hsp = lengthdir_x(dash_spd, _dir);
		vsp = lengthdir_y(dash_spd, _dir);
		dash_arr = [];
	}
}