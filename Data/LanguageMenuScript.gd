extends Control
var mainMenu = null

var config = ConfigFile.new()

func set_main_menu(_mainMenu:Control):
	mainMenu = _mainMenu

func _on_english_button_pressed() -> void:
	TranslationServer.set_locale("en")
	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		config.set_value("language", "value", "en")
		config.save("user://prefs.cfg")

func _on_russian_button_pressed() -> void:
	TranslationServer.set_locale("ru")
	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		config.set_value("language", "value", "ru")
		config.save("user://prefs.cfg")

func _on_back_button_pressed() -> void:
	mainMenu.show_menu()
