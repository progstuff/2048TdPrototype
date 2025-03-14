extends Control

@onready var world = $World
@onready var mainMenu = $MainMenu

func _ready() -> void:
	get_tree().paused = true
	mainMenu.set_main_game_scene(world)
	world.set_main_menu(mainMenu)
