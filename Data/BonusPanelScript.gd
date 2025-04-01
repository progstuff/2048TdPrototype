extends PanelContainer

@onready var container = $VBoxContainer/MarginContainer/VBoxContainer/BonusContainer
@onready var bonusTimer = $BonusTimer
@onready var bonusDescription = $BonusDescription
@onready var inventoryErrorPlayer = $InventoryErrorAnimation
@onready var inventoryErrorLabel = $InventoryError

var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")
var fieldCellRemoveBonus = load("res://Data/FieldCellRemoveBonusScene.tscn")
var poisonEffectBonus = load("res://Data/PoisonBonusScene.tscn")
var freezeEffectBonus = load("res://Data/FreezeBonusScene.tscn")

var playerPanel = null
var bonuses = {}

func _ready() -> void:
	pass

func get_bonuses() -> Dictionary:
	return bonuses

func init(_enemySpawners: Node, _wall: Node2D, _gameField: Node2D, _playerPanel: Control, _effectsManager: Node):
	
	if(!bonuses.is_empty()):
		return
	
	playerPanel = _playerPanel
	
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
	
	var fieldCellRemoveBonus = fieldCellRemoveBonus.instantiate()
	fieldCellRemoveBonus.set_bonus_panel(self)
	fieldCellRemoveBonus.set_game_field(_gameField)
	fieldCellRemoveBonus.deactivate()
	bonuses[3] = fieldCellRemoveBonus
	
	var poisonBonus = poisonEffectBonus.instantiate()
	poisonBonus.set_bonus_panel(self)
	poisonBonus.set_wall(_wall)
	poisonBonus.set_manager(_effectsManager)
	poisonBonus.deactivate()
	bonuses[4] = poisonBonus
	
	var freezeBonus = freezeEffectBonus.instantiate()
	freezeBonus.set_bonus_panel(self)
	freezeBonus.set_wall(_wall)
	freezeBonus.set_manager(_effectsManager)
	freezeBonus.deactivate()
	bonuses[5] = freezeBonus
	
	bonusTimer.start()
	
	random_bonuses()
	
func show_bonus_panel():
	get_tree().paused = true	
	visible = true
	inventoryErrorLabel.visible = false
	
func random_bonuses():
	for bonus in container.get_children():
		container.remove_child(bonus)
		
	var showedBonuses = {}
	
	var cnt = 0
	while(cnt < 3):
		var ind = randi_range(0, bonuses.size() - 1)
		if(showedBonuses.has(ind)):
			continue
		if(bonuses.has(ind)):
			var bonus = bonuses[ind]
			bonus.activate()
			
			container.add_child(bonus)
			showedBonuses[ind] = true
			cnt = cnt + 1
	
func choose_bonus(_bonus: BonusElement):
	if playerPanel.is_full():
		inventoryErrorPlayer.play("showInventoryError")
		return
	var hasChoosedBonus = false
	for bonus in container.get_children():
		if(bonus.isChoosed):
			hasChoosedBonus = true

	if(!hasChoosedBonus):
		_bonus.choose()
		playerPanel.add_bonus(_bonus)
		for bonus in container.get_children():
			if(!bonus.isChoosed):
				bonus.set_disabled()

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
	
	random_bonuses()

func _on_bonus_timer_timeout() -> void:
	random_bonuses()

func show_description(_title:String, _description: String):
	bonusDescription.show_description(_title, _description)

func _on_close_button_pressed() -> void:
	visible = false
	get_tree().paused = false
