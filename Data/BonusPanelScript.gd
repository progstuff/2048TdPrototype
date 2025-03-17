extends PanelContainer

@onready var container = $VBoxContainer/MarginContainer/VBoxContainer/BonusContainer
@onready var bonusTimer = $BonusTimer
@onready var bonusDescription = $BonusDescription
var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")
var fieldCellRemoveBonus = load("res://Data/FieldCellRemoveBonusScene.tscn")

var bonuses = {}

func _ready() -> void:
	pass
	
func init(_enemySpawners: Node, _wall: Node2D, _gameField: Node2D):
	
	if(!bonuses.is_empty()):
		return
		
	var coinBonus = coinBonusScene.instantiate()
	coinBonus.set_bonus_panel(self)
	coinBonus.set_enemy_spawners(_enemySpawners)
	coinBonus.deactivate()
	bonuses[0] = coinBonus
	
	var calibrBonus = calibrBonusScene.instantiate()
	calibrBonus.set_bonus_panel(self)
	calibrBonus.set_wall(_wall)
	calibrBonus.deactivate()
	bonuses[1] = calibrBonus
	
	var fieldBonus = fieldBonusScene.instantiate()
	fieldBonus.set_bonus_panel(self)
	fieldBonus.set_game_field(_gameField)
	fieldBonus.deactivate()
	bonuses[2] = fieldBonus
	
	var fieldVellRemoveBonus = fieldCellRemoveBonus.instantiate()
	fieldVellRemoveBonus.set_bonus_panel(self)
	fieldVellRemoveBonus.set_game_field(_gameField)
	fieldVellRemoveBonus.deactivate()
	bonuses[3] = fieldVellRemoveBonus
	
	bonusTimer.start()
	
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
	
func choose_bonus(_bonus: BonusElement):
	var hasChoosedBonus = false
	for bonus in container.get_children():
		if(bonus.isChoosed):
			hasChoosedBonus = true
	if(!hasChoosedBonus):
		_bonus.choose()

func restart():
	for bonusInd in bonuses:
		var bonus = bonuses[bonusInd]
		bonus.restart()
	
	get_tree().paused = false
	
	for bonus in container.get_children():
		container.remove_child(bonus)
		
	bonusTimer.stop()
	bonusTimer.start()
	visible = false

func _on_bonus_timer_timeout() -> void:
	show_bonus_panel()

func show_description():
	bonusDescription.show_description("","")

func _on_close_button_pressed() -> void:
	visible = false
	get_tree().paused = false
