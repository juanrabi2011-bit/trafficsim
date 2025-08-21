extends CharacterBody2D
# The NPC Car Must be a child of the tilemap!

# Getting the reference of the NPC Car in a variable as soon as the program starts
@onready var NPC_Car = $"."
# Getting the reference of the Tilemap
@onready var tile_map = get_parent()
# Getting the Timer Reference
@onready var timer = $Timer
# Initialising the speed and initial direction variable
var speed = 200
var direction = Vector2(0, 1)

# Function that creates a random direction
func random_direction():
	# Creating an Array of Directions
	var directions_array = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	# Getting the choosen direction
	var chosen_direction = directions_array[randi_range(0, directions_array.size() - 1)]
	# Printing the random direction for debugging
	print("New random direction: ", chosen_direction)
	# Returning the random direction
	return chosen_direction

# Fixed _position_generator to correctly get the tile ID
func _position_generator():
	# Generate a random position in the world
	var possible_position = Vector2(randf_range(-500, 1000), randf_range(-1000, 400))
	# Convert the world position to tile coordinates
	var tile_coords = tile_map.local_to_map(possible_position)
	# Get the tile ID at those coordinates from layer 0
	var tile_id = tile_map.get_cell_source_id(tile_coords)
	
	# Return a dictionary containing the position and the tile ID
	return {"position": tile_map.map_to_local(tile_coords), "id": tile_id}

# Fixed _ready() to correctly use the position generator
func _ready():
	direction = random_direction()
	# Set the timer's wait time to 4 seconds
	timer.wait_time = 4.0
	# Set one_shot to false so the timer repeats
	timer.one_shot = false
	# Start the timer when the scene is ready
	timer.start()
	# Connect the timeout signal to the function
	timer.timeout.connect(_on_timer_timeout)
	
	var position_data = _position_generator()
	
	# Loop a set number of times to avoid an infinite loop
	for i in range(100):
		position_data = _position_generator()
		# If a road tile (ID 0) is found, break the loop
		if position_data.id == 0:
			break
			
	# Set the character's position to the found road tile
	if position_data.id == 0:
		position = position_data.position
	else:
		printerr("Warning: Could not find a road tile to start on.")
			
# This is a Function To Check If There is a Road above and below the car
func _check_for_roads():
	# Get the coordinates of the tile the character is standing on.
	var current_tile_coords = tile_map.local_to_map(global_position)
	# Get the coordinates of the tile directly above the character.
	var tile_above_coords = current_tile_coords + Vector2i(0, -1)	
	# Getting all the data of a specific cell above
	var tile_id_above = tile_map.get_cell_source_id(tile_above_coords)
	# Checks if the tile_data variable is valid
	if tile_id_above != -1: # A return value of -1 means no tile exists at the given coordinates.
		# Checking the type of tile
		if tile_id_above == 0:
			print("Detected a road tile at ", tile_above_coords)
			return ("Road_Above")
		elif tile_id_above == 1:
			print("Detected a non road tile at ", tile_above_coords)
			return ("No_Road_Above")
		else:
			pass
	# Get the coordinates of the tile directly below the character.
	var tile_below_coords = current_tile_coords + Vector2i(0, 1)
	# Getting all the data of a specific cell below
	var tile_id_below = tile_map.get_cell_source_id(tile_below_coords)
	if tile_id_below != -1:
		# Checking the type of tile
		if tile_id_below == 0:
			print("Detected a road tile at ", tile_below_coords)
			return ("Road_Below")
		elif tile_id_below == 1:
			print("Detected a non road tile at ", tile_below_coords)
			return ("No_Road_Below")
		else:
			pass
	# Get the coordinates of the tile directly to the right the character.
	var tile_right_coords = current_tile_coords + Vector2i(1, 0)
	# Getting all the data of a specific cell below
	var tile_id_right = tile_map.get_cell_source_id(tile_right_coords)
	if tile_id_right != -1:
		# Checking the type of tile
		if tile_id_right == 0:
			print("Detected a road tile at ", tile_right_coords)
			return ("Road_Right")
		elif tile_id_right == 1:
			print("Detected a non road tile at ", tile_right_coords)
			return ("No_Road_RIght")
		else:
			pass
	# Get the coordinates of the tile directly to the left the character.
	var tile_left_coords = current_tile_coords + Vector2i(-1, 0)
	# Getting all the data of a specific cell below
	var tile_id_left = tile_map.get_cell_source_id(tile_left_coords)
	if tile_id_left != -1:
		# Checking the type of tile
		if tile_id_left == 0:
			print("Detected a road tile at ", tile_left_coords)
			return ("Road_Left")
		elif tile_id_left == 1:
			print("Detected a non road tile at ", tile_left_coords)
			return ("No_Road_Left")
		else:
			pass
	return null # Added to prevent errors when no road is found
			
# Checks if there is a road in all directions
func _check_for_road():
	print ("Timer Code Running")
	# Getting the coordinates of the current tile
	var current_tile_coords = tile_map.local_to_map(global_position)
	# Getting the coordinates of the future above tile
	var above_tile_coords = current_tile_coords + Vector2i(0,3)
	# Getting the tile id of the future tile
	var tile_id_above = tile_map.get_cell_source_id(above_tile_coords)
	# Checking if there is a road above
	if _check_for_roads() == "Road_Above":
		# Checking if the tile is valid
		if tile_id_above == 0:
			print ("Found another possible road Above! Changing Direction")
			direction = random_direction()
	# Getting the coordinates of the future below tile
	var below_tile_coords = current_tile_coords + Vector2i(0,-3)
	# Getting the tile id of the future tile
	var tile_id_below = tile_map.get_cell_source_id(below_tile_coords)
	# Checking if there is a road above
	if _check_for_roads() == "Road_Below":
		# Checking if the tile is valid
		if tile_id_below == 0:
			print ("Found another possible road Below! Changing Direction")
			direction = random_direction()
	# Getting the coordinates of the future right tile
	var right_tile_coords = current_tile_coords + Vector2i(3,0)
	# Getting the tile id of the future tile
	var tile_id_right = tile_map.get_cell_source_id(right_tile_coords)
	# Checking if there is a road to the right
	if _check_for_roads() == "Road_Right":
		# Checking if the tile is valid
		if tile_id_right == 0:
			print ("Found another possible road Right! Changing Direction")
			direction = random_direction()
	# Getting the coordinates of the future below left
	var left_tile_coords = current_tile_coords + Vector2i(0, 0)
	# Getting the tile id of the future tile
	var tile_id_left = tile_map.get_cell_source_id(left_tile_coords)
	# Checking if there is a road left
	if _check_for_roads() == "Road_Left":
		# Checking if the tile is valid
		if tile_id_left == 0:
			print ("Found another possible road Left! Changing Direction")
			direction = random_direction()

# Occurs in every game frame
func _physics_process(delta):
	# Setting the car's position to a variable
	var car_global_pos = NPC_Car.global_position
	# Converting the car's position to a position on a tilemap
	var tilemap_local_pos = tile_map.to_local(car_global_pos)
	# Converting the position to a specific tile
	var character_tile_coords = tile_map.local_to_map(car_global_pos)
	# This ensures a new direction is chosen when the character gets stuck
	if velocity == Vector2.ZERO:
		direction = random_direction()
	# If the character hits a wall, get a new direction
	if is_on_wall():
		print("Hit a wall! Changing direction.")
		direction = random_direction()
	# After determining the correct direction, set the velocity
	velocity = direction * speed
	# Move the character
	move_and_slide()
	# Rotate the character to face the direction of movement
	if direction.length() > 0:
		rotation = direction.angle()

# Happens evry 4 seconds
func _on_timer_timeout():
	print ("Timer Code Running")
	_check_for_road()
