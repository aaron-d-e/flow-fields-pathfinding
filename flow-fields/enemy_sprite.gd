extends Sprite2D

@onready var field_manager := $%FlowFieldManager
var cell_location: Vector2i

func _ready() -> void:
	cell_location = global_to_cell()
	move_to_target()
	
func _physics_process(_delta: float) -> void:
	pass
	
func global_to_cell() -> Vector2i:
		return Vector2i(
			floor(self.global_position.x / field_manager.cell_size.x),
			floor(self.global_position.y / field_manager.cell_size.y)
	)

func move_to_target():
	var next_direction : Vector2i = field_manager.field_directions[cell_location]
	self.global_position += Vector2(next_direction) * Vector2(field_manager.cell_size)
	await get_tree().create_timer(1.0).timeout
	cell_location = global_to_cell()
	move_to_target()
