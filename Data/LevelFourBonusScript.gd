extends BonusElement

var gameField = null
var image = load("res://Icons/Menu/levelFourBonus.png")

func _ready() -> void:
	set_icon(image)
	set_price(60)
	
func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.level_four()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return tr("LEVEL_FOUR_BONUS_TITLE")

func get_description():
	return tr("LEVEL_FOUR_BONUS_DESCRIPTION")
