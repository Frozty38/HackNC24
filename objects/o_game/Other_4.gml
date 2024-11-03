//Set grid / tile size
#macro TS	32

//Get tiles in the room
var _w = ceil(room_width / TS);
var _h = ceil(room_height / TS);

//create motion planning grid
global.mp_grid = mp_grid_create(0, 0, _w, _h, TS, TS);

//Loop through every tile and add a single solid if it's a wall
var _map = layer_tilemap_get_id("tiles_wall");
//create 1x1 solid
for (var yy = 0; yy < _h; ++yy)
{
	for(var xx = 0; xx < _w; ++xx)
	{
		var _t1 = tilemap_get(_map, xx, yy);
		if _t1 >= 1 and _t1 <= 47 
		{
			instance_create_layer(xx * TS, yy * TS, "Collisions", o_solid);	
		}
	}
}


//Add solid instances to grid
mp_grid_add_instances(global.mp_grid, o_solid, false);


//Loop through the grid positions again. Get solid id, and if a solid is to the right, absorb
for (var yy = 0; yy < _h; ++yy){
	for(var xx = 0; xx < _w; ++xx){
		var _t1 = tilemap_get(_map, xx, yy);
		if _t1 >= 1 and _t1 <= 47{
			//Get solid ID at this position 
			var _inst = collision_point(xx * TS, yy * TS, o_solid, 0, 1);
//If no solid found, move to the next grid position
			if _inst == noone continue;
			
			//Replace the solids to the right
			with(_inst) {
				do{
					var _change = false;
					var _inst_next = instance_place(x + 1, y, o_solid);
					if _inst_next != noone {
						image_xscale++;
						col = make_color_rgb(irandom(255), irandom(255), irandom(255));
						instance_destroy(_inst_next);
						_change = true;
					}
				} until _change == false;
				
				//Merge with any solids above that are the same shape
				var _inst_above = instance_place(x, y - 1, o_solid);
				if _inst_above != noone and _inst_above.bbox_left == bbox_left and _inst_above.bbox_right == bbox_right {
					y = _inst_above.y;
					image_yscale += _inst_above.image_yscale;
					instance_destroy(_inst_above);
				}
				
			}
		} else {
			//tile is empty so we should add an enemy >:)
			if random(1) <= 0.1 {
				instance_create_layer(xx * TS + TS / 2, yy * TS + TS / 2, "Enemy", o_enemy);	
			}
			//place scuff marks
			//each tile has a 20% chance of having a scuff applied
			var _map_marks = layer_tilemap_get_id("tiles_floor_marks");
			if random(1) <= 0.2 {
			    //get a random scuff, favouring the first 3 over the line scratch
			    var _t = choose(96, 96, 97, 97, 98, 98, 99);
			    //randomly flip the tile to give more variety
			    _t = tile_set_flip(_t, choose(0, 1));
			    //set the Tiles_floor_marks tilemap.
			    //We get the tilemap before the loop to save processing it every time
			    tilemap_set(_map_marks, _t, xx, yy);
			}
		}
	}
}



