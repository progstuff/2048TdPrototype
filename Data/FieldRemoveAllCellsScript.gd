extends BonusElement

var gameField = null
var image = load("res://Icons/Menu/removeAllCellsBonus.png")

func _ready() -> void:
	set_icon(image)
	set_price(40)
	
func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.remove_all_cells()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return tr("FIELD_ALL_CELL_REMOVE_BONUS_TITLE")

func get_description():
	return tr("FIELD_ALL_CELL_REMOVE_BONUS_DESCRIPTION")
