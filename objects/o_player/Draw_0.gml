/// @description Insert description here
// You can write your code in this editor

//Draw the dash anim
var _size = array_length(dash_arr);
for (var i = _size - 1; i >= 0; i--)
{
	dash_arr[i].image_alpha -= 0.05;
	if dash_arr[i].image_alpha > 0
	{
		draw_sprite_ext(s_player_dash, 0,
			dash_arr[i].x,
			dash_arr[i].y,
			facing, 1, 0, c_white, dash_arr[i].image_alpha);
	}
	else array_delete(dash_arr, i, 1);
}


// Inherit the parent event
event_inherited();



