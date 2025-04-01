extends BonusElement

var gameField = null
var image = load("res://Icons/Menu/2x2bonus.png")

func _ready() -> void:
	bonusName = "multiplyRandomTwo"
	set_icon(image)
	set_price(30)

func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.double_two()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return "Дважды два"

func get_description():
	return "Умножает на 2 все ячейки со значением 2. Действует однократно."
