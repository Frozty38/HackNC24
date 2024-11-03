var _dir = point_direction(x, y, other.x, other.y); //Get dir to push entity
var _force = force;		//Set force as a local variable for ease

with(other)
{
	hsp = lengthdir_x(_force, _dir);	//Push entity away horizontally	
	vsp = lengthdir_y(_force, _dir);	//Push entity away vertically
}

damage_entity(other, id, damage, random_range(45, 60));		//Damage entity