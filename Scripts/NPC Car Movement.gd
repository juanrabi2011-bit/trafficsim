extends CharacterBody2D
# IMPORTANT RULES FOR THE CODE TO WORK PROPERLY
# The NPC Car Must be a child of the tilemap
# The cars must have an initial position on the road, which has to be set manually

# Getting the timer reference
@onready var timer = $Timer
# Getting the reference of the Tilemap
@onready var tile_map = get_parent()
# Referencing the NPC Car
@onready var NPC_Car = $"."
# Initialising the speed and initial direction variable
var speed = 200
var direction = Vector2(0, 1)

# What the car does as soon as it returns into the program
func _ready():
	# Some code realated to the timer that will be relevant to generate random directions
	$"Road Checking Timer".wait_time = 1.0
	$"Road Checking Timer".one_shot = false
	$"Road Checking Timer".autostart = true
	# Some code related to checking if the car is stuck
	$"Road Checking Timer".wait_time = 2
	$"Road Checking Timer".one_shot = false
	$"Road Checking Timer".autostart = true

# Function that creates a random direction
func random_direction():
	# Creating an Array of Directions
	var directions_array = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	# Getting the choosen direction
	var chosen_direction = directions_array[randi_range(0, directions_array.size() - 1)]
	# Printing the random direction for debugging
	#print("New random direction: ", chosen_direction)
	# Returning the random direction
	return chosen_direction

# This is a Function To Check If There is a Road above and below the car
func _check_for_roads():
	# Get the coordinates of the tile the character is standing on.
	var current_tile_coords = tile_map.local_to_map(global_position)
	# Get the coordinates of the tile directly above the character.
	var tile_above_coords = current_tile_coords + Vector2i(0, 64)
	# Getting all the data of a specific cell above
	var tile_id_above = tile_map.get_cell_source_id(tile_above_coords)
	# Checks if the tile_data variable is valid
	if tile_id_above != -1: # A return value of -1 means no tile exists at the given coordinates.
		# Checking the type of tile
		if tile_id_above == 0:
			return (Vector2(0, 1))
		elif tile_id_above == 1:
			pass
		else:
			pass
	# Get the coordinates of the tile directly below the character.
	var tile_below_coords = current_tile_coords + Vector2i(0, -64)
	# Getting all the data of a specific cell below
	var tile_id_below = tile_map.get_cell_source_id(tile_below_coords)
	if tile_id_below != -1:
		# Checking the type of tile
		if tile_id_below == 0:
			return (Vector2(0, -1))
		elif tile_id_below == 1:
			pass
		else:
			pass
	# Get the coordinates of the tile directly to the right the character.
	var tile_right_coords = current_tile_coords + Vector2i(64, 0)
	# Getting all the data of a specific cell below
	var tile_id_right = tile_map.get_cell_source_id(tile_right_coords)
	if tile_id_right != -1:
		# Checking the type of tile
		if tile_id_right == 0:
			return (Vector2(1, 0))
		elif tile_id_right == 1:
			pass
		else:
			pass
	# Get the coordinates of the tile directly to the left the character.
	var tile_left_coords = current_tile_coords + Vector2i(64, 0)
	# Getting all the data of a specific cell below
	var tile_id_left = tile_map.get_cell_source_id(tile_left_coords)
	if tile_id_left != -1:
		# Checking the type of tile
		if tile_id_left == 0:
			return (Vector2(-1, 0))
		elif tile_id_left == 1:
			pass
		else:
			pass
	return null # Added to prevent errors when no road is found

# Occurs in every game frame
func _physics_process(delta):
	# If the character hits a wall, get a new direction
	if is_on_wall():
		direction = random_direction()
	# This ensures a new direction is chosen when the character gets stuck
	elif velocity == Vector2.ZERO:
		direction = random_direction()
		#print (self, "stuck")
	# After determining the correct direction, set the velocity
	velocity = direction * speed
	# Move the character
	move_and_slide()
	# Rotate the character to face the direction of movement
	if direction.length() > 0:
		rotation = direction.angle()
	if velocity == Vector2(0,0):
		print (self, "Stuck")

# Happens every 1 second in order to check the roads around it
func _on_timer_timeout() :
	# Setiing a variable to the return value of the check for roads function
	var value_road_checker = _check_for_roads()
	# If the value is up, change direction to up
	if value_road_checker == Vector2(0,1):
		NPC_Car.direction == value_road_checker
		#print(self, "going up")
	# If the value is down, change direction to down
	elif value_road_checker == Vector2(0,-1):
		NPC_Car.direction == value_road_checker
		#print(self, "going down")
	# If the value is right, change direction to right
	elif value_road_checker == Vector2(1, 0):
		NPC_Car.direction == value_road_checker
		#print(self, "going right")
	# If the value is left, change direction to left
	elif value_road_checker == Vector2(-1, 0):
		NPC_Car.direction == value_road_checker
		#print(self, "going left")


func _on_car_stuck_timer_timeout():
	if NPC_Car.velocity == Vector2(0,0):
		print(self, "is stuck")
