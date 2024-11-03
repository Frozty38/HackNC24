function calc_entity_movement()
{
	//@desc Moves enemy and applies drag
	
	//Apply movement
	x += hsp;
	y += vsp;
	
	//slowdown
	hsp *= global.drag;
	vsp *= global.drag;
	
	check_if_stopped();
}

function calc_knockback_movement() 
{
	//@desc moves enemy and applies drag during knockback
	
	//apply movement
	x += hsp;
	y += vsp;
	
	//slowdown
	hsp *= 0.91;
	vsp *= 0.91;
	
	check_if_stopped();
	
	//exit state
	if knockback_time <= 0 state = states.IDLE;
	
}


function check_facing()
{
	if knockback_time <= 0 
	{
		var _facing = sign(x - xp);
		if _facing != 0 facing = _facing;
	}
}

function check_for_player()
{
	///@desc	Check if the player is close enough to start chasing
	if o_player.state == states.DEAD exit;
	
	var _dis = distance_to_object(o_player);
	//Can we start chasing or are we already alert and out of attack dis?
	if (_dis <= (alert_dis) or alert) and _dis > attack_dis
	{
		//Enemy is now alert
		if alert == false
		{
			var _snd = choose(snd_enemy_alert_01, snd_enemy_alert_02, snd_enemy_alert_03);
			audio_play_sound(_snd, 50, 0, 1, 0, 1);
		}
		alert = true;
		
		
		//Checking if we should calc our path
		if calc_path_timer-- <= 0
		{
			//reset timer
			calc_path_timer = calc_path_delay;
		
			//Can we make a path to the player
			if x == xp and y == yp var _type = 0 else var _type = 1;
			var _found_player = mp_grid_path(global.mp_grid, path, x, y, o_player.x, o_player.y, _type);
	
			//Start path if we can reach the player
			if _found_player
			{
				path_start(path, move_spd, path_action_stop, false);	
			}
		}
	}
	else
	{
		//Are we close enough to attack?
		if _dis <= attack_dis
		{
			path_end();
			
			state = states.ATTACK;
		}
	}
}


function enemy_anim()
{
		switch(state)
	{
		case states.IDLE:
			sprite_index = s_idle;
			show_hurt();
		break;
		case states.MOVE:
			sprite_index = s_walk;
			show_hurt();
		break;
		case states.KNOCKBACK:
			show_hurt();
		break;
		case states.ATTACK:
			sprite_index = s_attack;
		break;
		case states.DEAD:
			sprite_index = s_dead;
		break;
	}
	//Set depth
	depth = -bbox_bottom;
	
	//update previous position
	xp = x;
	yp = y;
}

function perform_attack()
{
	//@desc attack player when at the correct frame
	
	if image_index >= attack_frame and can_attack
	{
		//reset for the next attack
		can_attack = false;
		alarm[0] = attack_cooldown;
		
		//Get attack direction
		var _dir = point_direction(x, y, o_player.x, o_player.y);
		
		//Get attack position
		var _xx = x + lengthdir_x(attack_dis, _dir);
		var _yy = y + lengthdir_y(attack_dis, _dir);
		
		//create hitbox and pass our variables to the hitbox
		var _inst = instance_create_layer(_xx, _yy, "Instances", o_enemy_hitbox);
		_inst.owner_id = id;
		_inst.damage = damage;
		_inst.knockback_time = knockback_time;
		var _snd = choose(snd_enemy_attack_01, snd_enemy_attack_02, snd_enemy_attack_03);
		audio_play_sound(_snd, 50, 0, 1, 0, 1);
	}
}


function show_hurt()
{
	//@desc Show the hurt sprite when being knocked back
	
	if knockback_time-- > 0 sprite_index = s_hurt;
}