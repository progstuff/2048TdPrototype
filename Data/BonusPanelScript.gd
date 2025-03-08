extends PanelContainer

@onready var container = $MarginContainer/VBoxContainer/BonusContainer

var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")

var bonuses = {}

func _ready() -> void:
	pass
	
func init(_enemySpawners: Node):
	
	if(!bonuses.is_empty()):
		return
		
	var coinBonus = coinBonusScene.instantiate()
	coinBonus.set_bonus_panel(self)
	coinBonus.set_enemy_spawners(_enemySpawners)
	coinBonus.deactivate()
	bonuses[0] = coinBonus
	
	var calibrBonus = calibrBonusScene.instantiate()
	calibrBonus.set_bonus_panel(self)
	calibrBonus.deactivate()
	bonuses[1] = calibrBonus
	
	var fieldBonus = fieldBonusScene.instantiate()
	fieldBonus.set_bonus_panel(self)
	fieldBonus.deactivate()
	bonuses[2] = fieldBonus
	
func show_bonus_panel():
	get_tree().paused = true
	
	for bonus in container.get_children():
		container.remove_child(bonus)
		
	var showedBonuses = {}
	
	var cnt = 0
	while(cnt < 3):
		var ind = randi_range(0, bonuses.size()-1)
		if(showedBonuses.has(ind)):
			continue
		if(bonuses.has(ind)):
			var bonus = bonuses[ind]
			bonus.activate()
			
			container.add_child(bonus)
			showedBonuses[ind] = true
			cnt = cnt + 1
			
	visible = true
	
func choose_bonus():
	for bonus in container.get_children():
		if(bonus.isChoosed):
			visible = false
			bonus.activate_bonus()
			break
			
	get_tree().paused = false
