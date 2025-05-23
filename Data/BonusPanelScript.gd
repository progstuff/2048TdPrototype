extends PanelContainer

@onready var container = $VBoxContainer/MarginContainer/VBoxContainer/BonusContainer
@onready var bonusTimer = $BonusTimer
@onready var bonusDescription = $BonusDescription
@onready var inventoryErrorPlayer = $InventoryErrorAnimation
@onready var inventoryErrorLabel = $InventoryError
@onready var coinsErrorPlayer = $CoinsErrorPlayer
@onready var coinsErrorLabel = $CoinsError
@onready var reminingTimeLbl = $VBoxContainer/MarginContainer2/HBoxContainer/ReminingTimeLbl
@onready var timeContainer = $VBoxContainer/MarginContainer2

var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")
var fieldCellRemoveBonusScene = load("res://Data/FieldCellRemoveBonusScene.tscn")
var fieldAllCellsRemoveBonusScene = load("res://Data/FieldRemoveAllCellsScene.tscn")
var fieldTwoFourCellsRemoveBonusScene = load("res://Data/FieldTwoFourRemoveBonusScene.tscn")
var poisonEffectBonusScene = load("res://Data/PoisonBonusScene.tscn")
var freezeEffectBonusScene = load("res://Data/FreezeBonusScene.tscn")
var calibrAttackBonusScene = load("res://Data/CalibrAttackBonusScene.tscn")
var globalFreezeEffectBonusScene = load("res://Data/GlobalFreezeBonusScene.tscn")
var globalPoisonEffectBonusScene = load("res://Data/GlobalPoisonBonusScene.tscn")
var globalCalibrBonusScene = load("res://Data/GlobalSpeedCalibrScene.tscn")
var globalAttackBonusScene = load("res://Data/GlobalAttackBonusScene.tscn")
var levelFourBonusScene = load("res://Data/LevelFourBonusScene.tscn")

var playerPanel = null
var bonuses = {}
var choosedBonuses = {}
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
	
	var poisonBonus = poisonEffectBonusScene.instantiate()
	poisonBonus.set_bonus_panel(self)
	poisonBonus.set_wall(_wall)
	poisonBonus.set_manager(_effectsManager)
	poisonBonus.deactivate()
	bonuses[2] = poisonBonus
	
	var freezeBonus = freezeEffectBonusScene.instantiate()
	freezeBonus.set_bonus_panel(self)
	freezeBonus.set_wall(_wall)
	freezeBonus.set_manager(_effectsManager)
	freezeBonus.deactivate()
	bonuses[3] = freezeBonus
	
	var calibrAttackBonus = calibrAttackBonusScene.instantiate()
	calibrAttackBonus.set_bonus_panel(self)
	calibrAttackBonus.set_wall(_wall)
	calibrAttackBonus.deactivate()
	bonuses[4] = calibrAttackBonus
	
	var globalFreezeBonus = globalFreezeEffectBonusScene.instantiate()
	globalFreezeBonus.set_bonus_panel(self)
	globalFreezeBonus.set_wall(_wall)
	globalFreezeBonus.set_manager(_effectsManager)
	globalFreezeBonus.deactivate()
	bonuses[5] = globalFreezeBonus
	
	var globalPoisonBonus = globalPoisonEffectBonusScene.instantiate()
	globalPoisonBonus.set_bonus_panel(self)
	globalPoisonBonus.set_wall(_wall)
	globalPoisonBonus.set_manager(_effectsManager)
	globalPoisonBonus.deactivate()
	bonuses[6] = globalPoisonBonus
	
	var globalCalibrBonus = globalCalibrBonusScene.instantiate()
	globalCalibrBonus.set_bonus_panel(self)
	globalCalibrBonus.set_wall(_wall)
	globalCalibrBonus.deactivate()
	bonuses[7] = globalCalibrBonus
	
	var globalAttackBonus = globalAttackBonusScene.instantiate()
	globalAttackBonus.set_bonus_panel(self)
	globalAttackBonus.set_wall(_wall)
	globalAttackBonus.deactivate()
	bonuses[8] = globalAttackBonus
	
	var fieldAllCellsRemoveBonus = fieldAllCellsRemoveBonusScene.instantiate()
	fieldAllCellsRemoveBonus.set_bonus_panel(self)
	fieldAllCellsRemoveBonus.set_game_field(_gameField)
	fieldAllCellsRemoveBonus.deactivate()
	bonuses[9] = fieldAllCellsRemoveBonus
	
	var fieldTwoFourCellsRemoveBonus = fieldTwoFourCellsRemoveBonusScene.instantiate()
	fieldTwoFourCellsRemoveBonus.set_bonus_panel(self)
	fieldTwoFourCellsRemoveBonus.set_game_field(_gameField)
	fieldTwoFourCellsRemoveBonus.deactivate()
	bonuses[10] = fieldTwoFourCellsRemoveBonus
	
	var levelFourBonus = levelFourBonusScene.instantiate()
	levelFourBonus.set_bonus_panel(self)
	levelFourBonus.set_game_field(_gameField)
	levelFourBonus.deactivate()
	bonuses[11] = levelFourBonus
	
	var fieldBonus = fieldBonusScene.instantiate()
	fieldBonus.set_bonus_panel(self)
	fieldBonus.set_game_field(_gameField)
	fieldBonus.deactivate()
	#bonuses[12] = fieldBonus
	
	var fieldCellRemoveBonus = fieldCellRemoveBonusScene.instantiate()
	fieldCellRemoveBonus.set_bonus_panel(self)
	fieldCellRemoveBonus.set_game_field(_gameField)
	fieldCellRemoveBonus.deactivate()
	#bonuses[13] = fieldCellRemoveBonus
	
	bonusTimer.start()
	
	random_bonuses()
	
func show_bonus_panel():
	get_tree().paused = true	
	visible = true
	inventoryErrorLabel.visible = false
	coinsErrorLabel.visible = false
	
	if(choosedBonuses.size() == bonuses.size()):
		timeContainer.visible = false
	else:
		timeContainer.visible = true
		reminingTimeLbl.text = str(ceil(bonusTimer.time_left))
func random_bonuses():
	for bonus in container.get_children():
		container.remove_child(bonus)
	
	var cnt = 0
	
	var bonusesInd = []
	for i in range(0, bonuses.size()):
		var bonusName = bonuses[i].name
		if(!choosedBonuses.has(bonusName)):
			bonusesInd.append(i)
			
	while(cnt < 3):
		if(bonusesInd.is_empty()):
			break
		var ind = randi_range(0, bonusesInd.size() - 1)	
		var bonusInd = bonusesInd[ind]
		
		var bonus = bonuses[bonusInd]
		bonus.activate()
		container.add_child(bonus)
		bonusesInd.remove_at(ind)
		
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
		
		if(_bonus.price > playerPanel.coins()):
			coinsErrorPlayer.play("showCoinsError")
			return
		
		var playerCoins = playerPanel.coins() - _bonus.price
		playerPanel.set_coins(playerCoins)
		
		choosedBonuses[_bonus.name] = _bonus
		_bonus.choose()
		playerPanel.add_bonus(_bonus)
		for bonus in container.get_children():
			if(!bonus.isChoosed):
				bonus.set_disabled()

func restart():
	for bonusInd in bonuses:
		var bonus = bonuses[bonusInd]
		bonus.restart()
	
	choosedBonuses.clear()
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
	
