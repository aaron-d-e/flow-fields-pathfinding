extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.insert_obstacle.emit(self.global_position)
