extends CharacterBody2D

'''func _physics_process(delta):
	# Seting The Speed
	var speed = 200
	
	# Getting The Direction From the User
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Normalising Direction
	direction = direction.normalized()
	
	# Getting Velocity
	velocity = direction * speed
	
	# Setting The Rotation
	rotation = direction.angle()
	
	# Moving
	move_and_slide()'''
	
const speed = 250

#EP means End Point
@export var EP: Node2D
@onready var nav_ag := $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_ag.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
func makepath() -> void:
	nav_ag.target_position = EP.global_position

func _on_timer_timeout() -> void:
	makepath()
