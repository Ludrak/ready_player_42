tool

extends Node2D

export (int) var		size_x = 4;
export (int) var		size_y = 20;

export (Texture) var	building_top_frame
export (Texture) var	building_frame


func _draw():
	for y in range (size_y) :
		for x in range (size_x) :
			if (y == 0) :
				draw_texture(building_top_frame, Vector2(x * building_top_frame.get_width(), y * building_frame.get_height()));
			else :
				draw_texture(building_frame, Vector2(x * building_frame.get_width(), (y - 1) * building_frame.get_height() + building_top_frame.get_height()));
	pass
	
	var points = PoolVector2Array([Vector2(0, 0), Vector2(building_frame.get_width() * size_x, 0), Vector2(building_frame.get_width() * size_x, 1000), Vector2(0, 1000)])
	$CollisionPolygon2D.polygon  = (points)


