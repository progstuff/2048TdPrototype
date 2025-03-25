extends BonusElement

var gameField = null

func _ready() -> void:
	bonusName = "multiplyRandomTwo"
	set_price(3)

func set_game_field(_gameField: Node2D):
	gameField = _gameField
	
func activate_bonus():
	if(gameField == null):
		return
	gameField.double_two()
