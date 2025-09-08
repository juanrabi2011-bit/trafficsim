extends Control

@onready var label: Label = $Label  # Reference to your Label child
@onready var car: CharacterBody2D = get_node_or_null("../Car")  # Path to car
@onready var end_point: Area2D = get_node_or_null("../Area2D")  # Path to endpoint

var car_speed: float = 250.0  # Hardcoded from car script; matches const speed

func _ready():
	var parent = get_parent()
	if parent and parent.has_signal("endpoint_changed"):
		parent.endpoint_changed.connect(_on_endpoint_changed)
	else:
		print("Error: No 'endpoint_changed' signal in parent")
	update_display()

func _process(_delta: float):
	if car and end_point and car.has_node("NavigationAgent2D"):
		update_display()
	else:
		label.text = "Error: Invalid car or endpoint reference"

func update_display():
	var distance: float = 0.0
	var time: float = 0.0
	
	var nav_ag = car.get_node_or_null("NavigationAgent2D") as NavigationAgent2D
	if not nav_ag:
		label.text = "Error: NavigationAgent2D not found"
		return
	
	# Check if navigation is finished (car arrived)
	if nav_ag.is_navigation_finished():
		distance = 0.0
		time = 0.0
	else:
		# Get the current navigation path from NavigationAgent2D
		var path: PackedVector2Array = nav_ag.get_current_navigation_path()
		
		# Calculate total remaining distance by summing path segments
		if path.size() > 1:
			for i in range(1, path.size()):
				distance += path[i-1].distance_to(path[i])
		else:
			# Fallback: straight-line if no full path
			distance = car.global_position.distance_to(end_point.global_position)
		
		# Calculate time: distance / speed (in seconds)
		if car_speed > 0:
			time = distance / car_speed
		else:
			time = 0.0
	
	# Format and set label text
	label.text = "Time: %.1fs, Distance: %.0fpx" % [time, distance]

func _on_endpoint_changed(new_pos: Vector2):
	var nav_ag = car.get_node_or_null("NavigationAgent2D") as NavigationAgent2D
	if nav_ag:
		nav_ag.target_position = new_pos  # Update agent's target
		update_display()
	else:
		print("Error: NavigationAgent2D not found in _on_endpoint_changed")
