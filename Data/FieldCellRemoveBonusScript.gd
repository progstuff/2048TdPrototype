extends BonusElement

var gameField = null
var image = load("res://Icons/Menu/remove2bonus.png")

func _ready() -> void:
	set_icon(image)
	set_price(30)
	
func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.remove_min_cell()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return tr("FIELD_CELL_REMOVE_BONUS_TITLE")

func get_description():
	return tr("FIELD_CELL_REMOVE_BONUS_DESCRIPTION")
