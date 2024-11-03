/// @description Insert description here
switch(state)
{
	case states.DEAD:
		image_index = image_number - 1;
		image_speed = 0;
	break;
	case states.ATTACK:
		image_index = 0;
		state = states.IDLE;
	break;
	
}
