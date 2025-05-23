extends Node2D

@onready var gameField = $GameField
@onready var wall = $Wall
@onready var scoreValLbl = $Interface/HBoxContainer/PanelContainer/VBoxContainer/ScoreCnt
@onready var coinValLbl = $Interface/HBoxContainer/PanelContainer2/VBoxContainer/CoinsCnt
@onready var enemyLines = $EnemyLines
@onready var timer =$Timer
@onready var timerLbl = $Interface/TimerLbl
@onready var switchers = $Interface/Switchers
@onready var coinSpawner = $CoinSpawner
@onready var bonusPanel = $Interface/BonusPanel
@onready var pauseMenu = $Interface/PauseMenu
@onready var gameOverMenu = $Interface/GameOverMenu
@onready var playerBonusPanel = $Interface/PlayerBonusPanel
@onready var effectsManager = $EffectsManager
@onready var bonusCooldownPanel = $Interface/BonusCooldownPanel
@onready var education = $Education
@onready var educationStartTimer = $EducationStartTimer
@onready var shopButton = $Interface/HBoxContainer2/ShopButton
@onready var helpText = $Education/Panel2/MarginContainer/VBoxContainer/HelpText

var difficultPeriod = 30
var difficultCoef = 1
var educationStage = 0

var mainMenu = null

var curSeconds = 0

var enemySpawnerScene = load("res://Data/EnemySpawnerScene.tscn")

var config = ConfigFile.new()
var score = 0

var gameMode = 1

func _ready() -> void:

	init_game(gameMode)
			
	#бонусы
	playerBonusPanel.set_bonus_cooldown_panel(bonusCooldownPanel)
	bonusPanel.init(enemyLines, wall, gameField, playerBonusPanel, effectsManager)
	
	gameOverMenu.init(self)
	pauseMenu.init(self)

	if(scoreValLbl == null):
		scoreValLbl = $VBoxContainer/HBoxContainer/ScoreCnt
	
	score = 0
	change_score(0)
	
func change_score(_score: float):
	score += _score*difficultCoef
	scoreValLbl.text = str(score)
	
func set_main_menu(_mainMenu:Control):
	mainMenu = _mainMenu

func show_main_menu():
	if(mainMenu == null):
		return
	mainMenu.show_menu()
		
func _on_game_field_max_value_changed() -> void:
	if(gameField == null):
		gameField = $GameField
		
	if(wall == null):
		wall = $Wall
	wall.change_lvl(gameField.maxNumbers)

	if(wall.damage > 0):
		gameOverMenu.show_menu()

func set_difficult_coef(_difficultCoef: float):
	difficultCoef = _difficultCoef

func get_difficult_coef():
	return difficultCoef

func set_game_mode(_gameMode:int):
	gameMode = _gameMode
	
func init_game(_gameMode:int):
	gameMode = _gameMode
	var rowsCnt = 4
	var columnsCnt = 4
	var towersCnt = rowsCnt
	var cellSize = 85
	
	if(gameMode == 1):
		rowsCnt = 4
		columnsCnt = 4
		towersCnt = rowsCnt
		cellSize = 100
	elif(gameMode == 2):
		rowsCnt = 4
		columnsCnt = 5
		towersCnt = rowsCnt
		cellSize = 100
	elif(gameMode == 3):
		rowsCnt = 5
		columnsCnt = 4
		towersCnt = rowsCnt
		cellSize = 85
	elif(gameMode == 4):
		rowsCnt = 5
		columnsCnt = 5
		towersCnt = rowsCnt
		cellSize = 85
		
	gameField.init(rowsCnt, columnsCnt, cellSize)
	var fieldWidth = gameField.get_width()
	var fieldHeight = gameField.get_height()
	wall.init(gameField.position, Vector2(fieldWidth, fieldHeight), cellSize, towersCnt)
	wall.position.x = gameField.position.x 
	wall.position.x += gameField.get_width()
	var ys = wall.get_twr_positions()
	
	for enemySpawner in enemyLines.get_children():
		enemyLines.remove_child(enemySpawner)
		enemySpawner.queue_free()
		
	for pos in ys:
		var enemySpawner = enemySpawnerScene.instantiate()
		enemySpawner.set_world(self)
		enemySpawner.coinSpawner = coinSpawner
		enemySpawner.position.x = get_viewport_rect().size.x
		enemySpawner.position.y = pos.y
		enemyLines.add_child(enemySpawner)

	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		var bulletPeriod = 2.6#config.get_value("bullet", "period", 2.3)
		var bulletSpeed = 120#config.get_value("bullet", "speed", 90)
		var bulletPowerMult = 1#config.get_value("bullet", "powerMult", 3)
		var bulletPowerShift = 0#config.get_value("bullet", "powerShift", 7)
		_on_switchers_bullet_period_changed(bulletPeriod)
		_on_switchers_bullet_speed_changed(bulletSpeed)
		_on_switchers_bullet_power_mult_changed(bulletPowerMult)
		_on_switchers_bullet_power_shift_changed(bulletPowerShift)
		#switchers.set_bullet_period(bulletPeriod)
		#switchers.set_bullet_speed(bulletSpeed)
		#switchers.set_bullet_power_mult(bulletPowerMult)
		#switchers.set_bullet_shift_value(bulletPowerShift)
		
		var enemyPeriod = 3#config.get_value("enemy", "period", 7)
		var enemyPeriodDelta = 0.5#config.get_value("enemy", "periodDelta", 3)
		var enemySpeed = 30#config.get_value("enemy", "speed", 30)
		var enemyHealth = 1#config.get_value("enemy", "health", 10)
		var enemyHealthDelta = 0#config.get_value("enemy", "healthDelta", 5)
		for enemySpawner in enemyLines.get_children():
			_on_switchers_enemy_period_changed(enemyPeriod)
			_on_switchers_enemy_period_delta_changed(enemyPeriodDelta)
			_on_switchers_enemy_speed_changed(enemySpeed)
			_on_switchers_enemy_health_changed(enemyHealth)
			_on_switchers_enemy_health_delta_changed(enemyHealthDelta)
			
			#switchers.set_enemy_period(enemyPeriod)
			#switchers.set_enemy_period_delta(enemyPeriodDelta)
			#switchers.set_enemy_speed(enemySpeed)
			#switchers.set_enemy_health(enemyHealth)
			#switchers.set_enemy_health_delta(enemyHealthDelta)
			break
		
		difficultPeriod = 48#config.get_value("difficult", "period", 30)
		var difficultVal = 1#config.get_value("difficult", "value", 2)
		difficultCoef = config.get_value("difficult", "coef", 1)
		var coinChanceVal = 0.065#config.get_value("coinChance", "value", 0.05)
		educationStage = config.get_value("educationStage", "value", 0)
		
		for enemySpawner in enemyLines.get_children():
			_on_switchers_difficult_period_changed(difficultPeriod / difficultCoef)
			_on_switchers_difficult_value_changed(difficultVal)
			_on_switchers_coin_chance_value_changed(coinChanceVal)
			break
	else:
		_on_switchers_bullet_period_changed(wall.get_bullet_period())
		_on_switchers_bullet_speed_changed(wall.get_bullet_speed())
		_on_switchers_bullet_power_mult_changed(wall.get_bullet_power_mult())
		_on_switchers_bullet_power_shift_changed(wall.get_bullet_power_shift())
		
		#switchers.set_bullet_period(wall.get_bullet_period())
		#switchers.set_bullet_speed(wall.get_bullet_speed())
		#switchers.set_bullet_power_mult(wall.get_bullet_power_mult())
		#switchers.set_bullet_shift_value(wall.get_bullet_power_shift())
		
		for enemySpawner in enemyLines.get_children():
			_on_switchers_enemy_period_changed(enemySpawner.enemyWaitTime)
			_on_switchers_enemy_period_delta_changed(enemySpawner.enemyWaitTimeDelta)
			_on_switchers_enemy_speed_changed(enemySpawner.speed)
			_on_switchers_enemy_health_changed(enemySpawner.health)
			_on_switchers_enemy_health_delta_changed(enemySpawner.healthDelta)
			
			#switchers.set_enemy_period(enemySpawner.enemyWaitTime)
			#switchers.set_enemy_period_delta(enemySpawner.enemyWaitTimeDelta)
			#switchers.set_enemy_speed(enemySpawner.speed)
			#switchers.set_enemy_health(enemySpawner.health)
			#switchers.set_enemy_health_delta(enemySpawner.healthDelta)
			break
		
		for enemySpawner in enemyLines.get_children():
			_on_switchers_difficult_period_changed(enemySpawner.difficultWaitTime)
			_on_switchers_difficult_value_changed(enemySpawner.difficultVal)
			_on_switchers_coin_chance_value_changed(enemySpawner.coinChance)
			break
	coinSpawner.remove_coins()
	
	gameOverMenu.visible = false
	
func restart_game():
	
	init_game(gameMode)
	
	timer.stop()
	curSeconds = 0
	timerLbl.text = "00:00 "
	timer.start()
	
	score = 0
	change_score(0)
	
	playerBonusPanel.restart()
	bonusPanel.restart()
	gameField.restart()
	bonusCooldownPanel.restart()
	educationStartTimer.start()
	
	for enemySpawner in enemyLines.get_children():
		enemySpawner.start_spawn_enemies()
		
func _on_restart_btn_pressed() -> void:
	restart_game()

func _on_game_field_need_restart() -> void:
	restart_game()

func _on_timer_timeout() -> void:
	curSeconds += 1
	var seconds = curSeconds % 60
	var minutes = (curSeconds - seconds)/60
	var rez = ""
	if(minutes < 10):
		rez = "0" + str(minutes)
	else:
		rez = str(minutes)
	if(seconds < 10):
		rez = rez + ":0" + str(seconds) + " "
	else:
		rez = rez + ":" + str(seconds) + " "
	timerLbl.text = rez

func _on_coin_spawner_coin_clicked_signal() -> void:
	if(coinValLbl == null):
		coinValLbl = $VBoxContainer/HBoxContainer2/CoinsCnt
	
	var coinsCnt = playerBonusPanel.coins()
	coinsCnt += 1
	playerBonusPanel.set_coins(coinsCnt)

func _on_config_button_button_down() -> void:
	switchers.visible = !switchers.visible

func _on_switchers_bullet_period_changed(_val: float) -> void:
	wall.set_bullet_period(_val)
	#config.set_value("bullet", "period", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_bullet_power_mult_changed(_val: float) -> void:
	wall.set_bullet_power_mult(_val)
	#config.set_value("bullet", "powerMult", _val)
	#config.save("user://prefs.cfg")
	
func _on_switchers_bullet_power_shift_changed(_val: float) -> void:
	wall.set_bullet_power_shift(_val)
	#config.set_value("bullet", "powerShift", _val)
	#config.save("user://prefs.cfg")
	
func _on_switchers_bullet_speed_changed(_val: float) -> void:
	wall.set_bullet_speed(_val)
	#config.set_value("bullet", "speed", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_enemy_health_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.health = _val
	#config.set_value("enemy", "health", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_enemy_health_delta_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.healthDelta = _val
	#config.set_value("enemy", "healthDelta", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_enemy_period_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_period(_val)
	#config.set_value("enemy", "period", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_enemy_period_delta_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_period_delta(_val)
	#config.set_value("enemy", "periodDelta", _val)
	#config.save("user://prefs.cfg")
	
func _on_switchers_enemy_speed_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_speed(_val)
	#config.set_value("enemy", "speed", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_difficult_period_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_difficult_period(_val)
	#config.set_value("difficult", "period", _val)
	#config.save("user://prefs.cfg")
	
func _on_switchers_difficult_value_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.difficultVal = _val
	#config.set_value("difficult", "value", _val)
	#config.save("user://prefs.cfg")

func _on_switchers_coin_chance_value_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.coinChance = _val
	#config.set_value("coinChance", "value", _val)
	#config.save("user://prefs.cfg")

func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pauseMenu.visible = true

func _on_shop_button_pressed() -> void:
	bonusPanel.show_bonus_panel()

func get_bonus_panel() -> PanelContainer:
	if(bonusPanel == null):
		bonusPanel = $Interface/BonusPanel
	return bonusPanel

func game_field_education():
	education.z_index = 10
	education.visible = true
	get_tree().paused = true
	
	gameField.z_index = 11
	helpText.text = tr("HELP_GAME_FIELD")
	educationStage = 1
	
func shop_education():
	education.z_index = 10
	education.visible = true
	get_tree().paused = true
	
	shopButton.z_index = 11
	gameField.z_index = 0
	helpText.text = tr("HELP_SHOP")
	educationStage = 2

func player_panel_education():
	education.z_index = 10
	education.visible = true
	get_tree().paused = true
	
	playerBonusPanel.z_index = 11
	shopButton.z_index = 0
	helpText.text = tr("HELP_PLAYER_PANEL")
	educationStage = 3

func towers_education():
	education.z_index = 10
	education.visible = true
	get_tree().paused = true
	
	wall.towersTree().z_index = 11
	playerBonusPanel.z_index = 0
	helpText.text = tr("HELP_TOWERS")
	educationStage = 4

func enemies_education():
	education.z_index = 10
	education.visible = true
	get_tree().paused = true
	
	enemyLines.z_index = 11
	wall.towersTree().z_index = 0
	helpText.text = tr("HELP_ENEMIES")
	educationStage = 5
		
func end_education():
	gameField.z_index = 0
	shopButton.z_index = 0
	playerBonusPanel.z_index = 0
	wall.towersTree().z_index = 0
	enemyLines.z_index = 0
	
	education.visible = false
	get_tree().paused = false

func _on_button_pressed() -> void:
	if(educationStage == 0):
		game_field_education()
		config.set_value("educationStage", "value", educationStage)
		config.save("user://prefs.cfg")
	elif(educationStage == 1):
		shop_education()
		config.set_value("educationStage", "value", educationStage)
		config.save("user://prefs.cfg")
	elif(educationStage == 2):
		player_panel_education()
		config.set_value("educationStage", "value", educationStage)
		config.save("user://prefs.cfg")
	elif(educationStage == 3):
		towers_education()
		config.set_value("educationStage", "value", educationStage)
		config.save("user://prefs.cfg")
	elif(educationStage == 4):
		enemies_education()
		config.set_value("educationStage", "value", educationStage)
		config.save("user://prefs.cfg")
	else:
		end_education()

func _on_education_start_timer_timeout() -> void:
	_on_button_pressed()

func _on_player_bonus_panel_coins_update() -> void:
	coinValLbl.text = str(playerBonusPanel.coins())
