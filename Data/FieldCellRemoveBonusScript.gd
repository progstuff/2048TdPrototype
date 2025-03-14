extends BonusElement

var gameField = null

func _ready() -> void:
	set_price(3)
func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.remove_min_cell()
