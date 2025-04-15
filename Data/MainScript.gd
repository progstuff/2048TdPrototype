extends Control

@onready var world = $World
@onready var mainMenu = $MainMenu

var config = ConfigFile.new()

func _ready() -> void:
	
	var isOk = config.load("user://prefs.cfg")
	var locale = "en"
	if isOk == OK:
		locale = config.get_value("language", "value", "en")
	TranslationServer.set_locale(locale)
	
	get_tree().paused = true
	mainMenu.set_main_game_scene(world)
	world.set_main_menu(mainMenu)
