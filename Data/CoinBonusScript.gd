extends BonusElement

@export var coinChanceMultiplier = 10

var enemySpawners = null
var oldCoinChance = 0

func _ready() -> void:
	set_price(5)
	bonusTime = 20
	if(bonusTimer == null):
		bonusTimer = $BonusTimer
	bonusTimer.wait_time = bonusTime

func set_enemy_spawners(_enemySpawners: Node):
	enemySpawners = _enemySpawners
	
func activate_bonus():
	if(enemySpawners == null):
		return
	
	for enemySpawner in enemySpawners.get_children():
		oldCoinChance = enemySpawner.coinChance
		enemySpawner.coinChance *= coinChanceMultiplier
	
	bonusTimer.start()

func deactivate_bonus():
	if(enemySpawners == null):
		return
	
	for enemySpawner in enemySpawners.get_children():
		enemySpawner.coinChance /= coinChanceMultiplier
		
	bonusTimer.stop()
