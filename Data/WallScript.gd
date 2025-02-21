extends Node2D

@onready var towers = $Towers
@onready var rect = $WallRect

var tower = load("res://Data/TowerScene.tscn")

var towersCnt = 5

func get_width() -> int:
	return rect.size.x

func change_position(newX: int):
	for twr in towers.get_children():
		twr.position.x = newX - twr.get_width() + get_width()
				
func _ready() -> void:
	var sz = get_viewport().get_visible_rect().size
	var dy = sz.y / towersCnt
	for i in range(0, towersCnt):
		var twr = tower.instantiate()
		towers.add_child(twr)
		twr.init(3, position + Vector2(-70, dy*i + 32))
