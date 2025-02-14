extends Node2D

@onready var cellManager = $CellManager


func _on_button_button_down() -> void:
	var vals = [2, 4, 8, 16, 32, 1024, 2048, 4096, 8192]
	var n = randi_range(0, vals.size()-1)
	var x = randi_range(300, 600)
	var y = randi_range(100, 500)
	var cell = cellManager.create_cell(vals[n], Vector2(x, y))
	add_child(cell)
	cell.timer.start()
