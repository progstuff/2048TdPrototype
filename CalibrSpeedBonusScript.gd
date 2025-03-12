extends BonusElement

@export var speedMultiplier = 4

var wall = null
var oldCoinChance = 0

func _ready() -> void:
	set_price(2)
	bonusTime = 20
	if(bonusTimer == null):
		bonusTimer = $BonusTimer
	bonusTimer.wait_time = bonusTime

func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	if(wall == null):
		return
	wall.change_main_calibr_shoot_speed(speedMultiplier)
	bonusTimer.start()

func deactivate_bonus():
	wall.set_normal_shoot_period()
