
function damage_entity(_tid, _sid, _damage, _time)
{
	//@desc		Damage the target and return the dead status
	//@arg tid		real	target_id
	//@arg sid		real	source_id
	//@arg damage	real	how much damage to deal
	//@arg time		real	how long to knock back the target
	
	with(_tid)
	{
		if alarm[HURT] > 0 or (state == states.DEAD or state == states.DASH) exit;
		hp -= _damage;
		var _dead = is_dead();
		path_end();
		
		//set knockback distance
		if _dead var _dis = 5 else var _dis = 3;
		var _dir = point_direction(_sid.x, _sid.y, x, y);
		
		hsp += lengthdir_x(_dis, _dir);
		vsp += lengthdir_y(_dis, _dir);
		
		calc_path_delay = _time;
		alert = true;
		knockback_time = _time;
		alarm[HURT] = hurt_time;
		
		if !_dead state = states.KNOCKBACK;
		image_index = 0;
		var _inst = instance_create_layer(x, y, "Arrow", o_hit)
		_inst.depth = -room_height;
		return _dead;
	}
}

function is_dead()
{
	//@desc		Checks if the instance running this is dead
	
	if state != states.DEAD
	{
		if hp <= 0	
		{
			state = states.DEAD;
			hp = 0;
			image_index = 0;
			//set death sound
			switch(object_index)
			{
				default:
					//play sound
					audio_play_sound(snd_enemy_die, 50, 0, 1, 0, random_range(0.6, 1.4))
				break;
				case o_player:
					if instance_exists(my_bow) instance_destroy(my_bow);
					//player sound
				break;
			}
			return true;
		}
		else return true;
	}
}

function check_if_stopped()
{
	if abs(hsp) < 0.1 hsp = 0;
	if abs(vsp) < 0.1 vsp = 0;
}

function show_healthbar()
{
	//@desc Shows the health bar above entity's head
	if hp != hp_max and hp > 0
	{
		draw_healthbar(x - 7, y - 16, x + 7, y - 14, hp / hp_max * 100, $003300, $3232FF, $00B200, 0, 1, 1); 	
	}
}

function check_dust()
{
	//@desc Create the dust when the dust timer is zero
	
	//decrease our timer by 1 and check if we should create dust this step
	if create_dust_timer-- <= 0 
	{
		//Set timer for next time
		create_dust_timer = create_dust_timer_initial;
		
		//only create dust if we are moving
		if x != xp or y != yprevious
		{
			var _num = instance_number(o_dust);
			if _num < 100 or object_index == o_player
			{
				instance_create_layer(x + random_range(-4, 4), bbox_bottom + random_range(-3, 3), "Player", o_dust);	
			}
		}
	}
}