extends Node2D

@onready var end_point_node: Area2D = $Area2D

func _ready():
	# make it "invisible" and non-interactive at start
	end_point_node.visible = false
	if end_point_node.has_node("CollisionShape2D"):
		end_point_node.get_node("CollisionShape2D").disabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var click_pos = get_global_mouse_position()

		if is_point_on_navigation(click_pos):
			move_endpoint(click_pos)
		else:
			print("Invalid click: not on road!")

func is_point_on_navigation(point: Vector2) -> bool:
	var nav_maps = NavigationServer2D.get_maps()
	if nav_maps.is_empty():
		return false

	var nav_map = nav_maps[0]
	var closest = NavigationServer2D.map_get_closest_point(nav_map, point)

	return point.distance_to(closest) < 8.0

func move_endpoint(pos: Vector2) -> void:
	end_point_node.global_position = pos
	end_point_node.visible = true
	if end_point_node.has_node("CollisionShape2D"):
		end_point_node.get_node("CollisionShape2D").disabled = false

	print("End point set at:", pos)
