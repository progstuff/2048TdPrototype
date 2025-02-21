extends Node2D

@onready var gameField = $GameField
@onready var wall = $Wall

func _ready() -> void:
	gameField.position = Vector2(50, 50)
	wall.position.x = gameField.position.x 
	wall.position.x += gameField.get_width()
	wall.position.x += wall.get_width() + 10
	wall.change_position(wall.position.x)
