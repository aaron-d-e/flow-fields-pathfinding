extends Sprite2D

@onready var field_manager := $%FlowFieldManager
var cell_location: Vector2i
var enemy_tween: Tween
var timer: float = 0.0

var id: int


func _ready() -> void:
	cell_location = global_to_cell()
	move_to_target()
	id = randi()
	
func _physics_process(delta: float) -> void:
	if !enemy_tween or !enemy_tween.is_running() and timer >= 1.0:
		move_to_target()
		SignalBus.insert_enemy.emit(id, self.global_position)
		SignalBus.enemy_debug_print.emit()
		timer = 0.0
	timer += delta
	
func global_to_cell() -> Vector2i:
		return Vector2i(
			floor(self.global_position.x / field_manager.cell_size.x),
			floor(self.global_position.y / field_manager.cell_size.y)
	)

func move_to_target():
		var next_direction : Vector2i = field_manager.field_directions[cell_location]
		self.global_position += Vector2(next_direction) * Vector2(field_manager.cell_size)
		cell_location = global_to_cell()
			
		if enemy_tween:
			enemy_tween.kill()
		enemy_tween = create_tween()
		enemy_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		enemy_tween.tween_property(self, "global_position", self.global_position, 0.185).set_trans(Tween.TRANS_SINE)
