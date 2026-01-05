class_name FlowFieldManager extends Node2D

@export var field_size: Vector2 # how many cells the grid is made of
@export var cell_size: Vector2 # how big each cell is

var directions: Dictionary[String, Vector2] = {
	"UP": Vector2.UP,
	"DOWN": Vector2.DOWN,
	"LEFT": Vector2.LEFT,
	"RIGHT": Vector2.RIGHT,
}

var cell_array: Array[Vector2] # array of every cell as a vector2
var field_directions: Dictionary[Vector2, Vector2] = {} # directions of each cell in grid
var field_costs: Dictionary[Vector2, int] = {} # cost of every cell in grid


const MAX_COST: int = 999999


func _ready() -> void:
	for x in field_size.x:
		for y in field_size.y:
			var loc_x := x * cell_size.x + (cell_size.x / 2.0)
			var loc_y := y * cell_size.y + (cell_size.y / 2.0)
			cell_array.append(Vector2(loc_x, loc_y))
	
	for vec in cell_array: # set all cell costs to max cost, cell directions to zeros
		field_costs[vec] = MAX_COST
		field_directions[vec] = Vector2.ZERO
