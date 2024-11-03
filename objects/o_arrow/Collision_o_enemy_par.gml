
if other.hp > 0
{
	damage_entity(other, owner_id, damage, knockback_time);	
	arrow_die();
	audio_play_sound(snd_arrow_impact, 50, 0, random_range(0.6, 1.4))
}

