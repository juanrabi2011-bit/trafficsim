extends CharacterBody2D

func _physics_process(delta):
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
	move_and_slide()
		
			
	
