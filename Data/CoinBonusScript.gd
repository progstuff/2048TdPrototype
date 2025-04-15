extends BonusElement

@export var coinChanceMultiplier = 10
var image = load("res://Icons/Menu/bonusCoin.png")

var enemySpawners = null
var oldCoinChance = 0

func _ready() -> void:
	bonusName = "coinChance"
	set_icon(image)
	set_price(30)
	bonusTime = 20

func set_enemy_spawners(_enemySpawners: Node):
	enemySpawners = _enemySpawners
	
func activate_bonus():
	if(enemySpawners == null):
		return
	
	for enemySpawner in enemySpawners.get_children():
		oldCoinChance = enemySpawner.coinChance
		enemySpawner.coinChanceMultiplier = coinChanceMultiplier

func deactivate_bonus():
	if(enemySpawners == null):
		return
	
	for enemySpawner in enemySpawners.get_children():
		enemySpawner.set_normal_coin_chance()


func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)

func get_title():
	return tr("COIN_BONUS_TITLE")

func get_description():
	return tr("COIN_BONUS_DESCRIPTION")
