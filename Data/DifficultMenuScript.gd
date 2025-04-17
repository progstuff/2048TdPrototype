extends Control

var mainMenu = null
var world = null

var config = ConfigFile.new()

@onready var difficultLbl = $PanelContainer/PanelContainer2/MarginContainer/VBoxContainer/DifficultLbl

func set_world(_world:Node2D):
	world = _world
	
func set_main_menu(_mainMenu:Control):
	mainMenu = _mainMenu

func update_difficult():
	var difficultCoef = world.get_difficult_coef()
	if(difficultCoef == 1):
		difficultLbl.text =tr("EASY")
	elif(difficultCoef == 2):
		difficultLbl.text = tr("NORMAL")
	else:
		difficultLbl.text = tr("HARD")
		
func _on_easy_button_pressed() -> void:
	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		config.set_value("difficult", "coef", 1)
		config.save("user://prefs.cfg")
	world.set_difficult_coef(1)
	update_difficult()

func _on_medium_button_pressed() -> void:
	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		config.set_value("difficult", "coef", 2)
		config.save("user://prefs.cfg")
	world.set_difficult_coef(2)
	update_difficult()

func _on_hard_button_pressed() -> void:
	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		config.set_value("difficult", "coef", 3)
		config.save("user://prefs.cfg")
	world.set_difficult_coef(3)
	update_difficult()

func _on_back_button_pressed() -> void:
	mainMenu.show_menu()
