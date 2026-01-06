class_name FlowFieldManager extends Node2D

@export var field_size: Vector2i # how many cells the grid is made of
@export var cell_size: Vector2i # how big each cell is
@export var target: CharacterBody2D

# debug print stuff
@export var debug_font: FontFile
@export var debug_font_size: int = 12

var last_target_position: Vector2i

var directions: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.ONE, 
	Vector2i(1,-1),
	Vector2i(-1,1),
	Vector2i(-1,-1),
]

var cell_array: Array[Vector2i] = []# array of every cell as a vector2
var field_directions: Dictionary[Vector2i, Vector2i] = {} # directions of each cell in grid
var field_costs: Dictionary[Vector2i, int] = {} # cost of every cell in grid

var cost_queue: Array[Vector2i] = []

const MAX_COST: int = 999999


func _ready() -> void:
	for x in range(field_size.x):
		for y in range(field_size.y):
			cell_array.append(Vector2i(x, y))
	
	for vec in cell_array: # set all cell costs to max cost, cell directions to zeros
		field_costs[vec] = MAX_COST
		field_directions[vec] = Vector2i.ZERO
	
	generate_flow_field()
				
func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * cell_size.x + cell_size.x * 0.5,
		cell.y * cell_size.y + cell_size.y * 0.5
	)
	
func _physics_process(_delta: float) -> void:
	if last_target_position != get_target_cell():
		generate_flow_field() # if target moves update field again
		queue_redraw()

func _draw() -> void:
	for cell in cell_array:
		var cost := field_costs[cell]
		if cost != MAX_COST:
			var world_pos := cell_to_world(cell)
			var dir := field_directions[cell]
			draw_string(debug_font, world_pos + Vector2(-4, 4), str(cost), HORIZONTAL_ALIGNMENT_CENTER, -1, debug_font_size, Color.BLUE)
			draw_line(world_pos, world_pos + Vector2(dir.x * 8, dir.y * 8) , Color.BLUE)
			
	
func generate_flow_field() -> void:
	cost_queue.clear() # need to this call every frame
	for cell in cell_array:
		field_costs[cell] = MAX_COST
	
	var target_cell := get_target_cell()
	last_target_position = target_cell
	cost_queue.append(target_cell)
	field_costs[target_cell] = 0 # target to itself will always be zero
	
	
	while not cost_queue.is_empty():
		var current_node: Vector2i = cost_queue.pop_front()
		var current_cost := field_costs[current_node]
		
		var neighbors: Array[Vector2i] = get_neighbors(current_node) # checks for bounds in function, neighbors should be valid
		for node in neighbors:
			var new_cost := current_cost + 1
			
			var dir := node - current_node
			if dir.x != 0 and dir.y != 0:
				new_cost += 1
				
			if new_cost < field_costs[node]:
				field_costs[node] = new_cost
				cost_queue.append(node) # add unseen neighbors to the frontiers
				
	for cell in cell_array: 
		var best_cost = field_costs[cell] # best cost is always to itself
		var best_dir = Vector2i.ZERO # best dir is to stay still
		for dir in directions:
			var neighbor: Vector2i = dir + cell
			if cell_array.has(neighbor) and field_costs[neighbor] < best_cost:
				best_cost = field_costs[neighbor]
				best_dir = dir
		field_directions[cell] = best_dir

	
	
func get_target_cell() -> Vector2i:
	return Vector2i(
		floor(target.global_position.x / cell_size.x),
		floor(target.global_position.y / cell_size.y)
	)

func get_neighbors(node: Vector2i) -> Array[Vector2i]:
	var ret_arr: Array[Vector2i] = []
	for dir in directions:
		var next := dir + node
		if is_in_bounds(next):
			ret_arr.append(next)
	return ret_arr
	
func is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 \
		and cell.x < field_size.x \
		and cell.y < field_size.y
