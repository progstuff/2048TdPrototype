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
var educationStage = 0

var mainMenu = null

var coinsCnt = 0
var curSeconds = 0

var enemySpawnerScene = load("res://Data/EnemySpawnerScene.tscn")

var config = ConfigFile.new()
var score = 0

func _ready() -> void:

	gameField.init(4, 4)
	var fieldWidth = gameField.get_width()
	var fieldHeight = gameField.get_height()
	wall.init(gameField.position, Vector2(fieldWidth, fieldHeight),4)
	wall.position.x = gameField.position.x 
	wall.position.x += gameField.get_width()
	var ys = wall.get_twr_positions()
	
	for pos in ys:
		var enemySpawner = enemySpawnerScene.instantiate()
		enemySpawner.set_world(self)
		enemySpawner.coinSpawner = coinSpawner
		enemySpawner.position.x = get_viewport_rect().size.x
		enemySpawner.position.y = pos.y
		enemyLines.add_child(enemySpawner)

	var isOk = config.load("user://prefs.cfg")
	if isOk == OK:
		var bulletPeriod = config.get_value("bullet", "period", 2.3)
		var bulletSpeed = config.get_value("bullet", "speed", 90)
		var bulletPowerMult = config.get_value("bullet", "powerMult", 3)
		var bulletPowerShift = config.get_value("bullet", "powerShift", 7)
		switchers.set_bullet_period(bulletPeriod)
		switchers.set_bullet_speed(bulletSpeed)
		switchers.set_bullet_power_mult(bulletPowerMult)
		switchers.set_bullet_shift_value(bulletPowerShift)
		
		var enemyPeriod = config.get_value("enemy", "period", 7)
		var enemyPeriodDelta = config.get_value("enemy", "periodDelta", 3)
		var enemySpeed = config.get_value("enemy", "speed", 30)
		var enemyHealth = config.get_value("enemy", "health", 10)
		var enemyHealthDelta = config.get_value("enemy", "healthDelta", 5)
		for enemySpawner in enemyLines.get_children():
			switchers.set_enemy_period(enemyPeriod)
			switchers.set_enemy_period_delta(enemyPeriodDelta)
			switchers.set_enemy_speed(enemySpeed)
			switchers.set_enemy_health(enemyHealth)
			switchers.set_enemy_health_delta(enemyHealthDelta)
			break
		
		var difficultPeriod = config.get_value("difficult", "period", 17)
		var difficultVal = config.get_value("difficult", "value", 2)
		var coinChanceVal = config.get_value("coinChance", "value", 0.05)
		educationStage = config.get_value("educationStage", "value", 0)
		
		for enemySpawner in enemyLines.get_children():
			switchers.set_difficult_period(difficultPeriod)
			switchers.set_difficult_value(difficultVal)
			switchers.set_coin_chance_value(coinChanceVal)
			break
	else:
		switchers.set_bullet_period(wall.get_bullet_period())
		switchers.set_bullet_speed(wall.get_bullet_speed())
		switchers.set_bullet_power_mult(wall.get_bullet_power_mult())
		switchers.set_bullet_shift_value(wall.get_bullet_power_shift())
		
		for enemySpawner in enemyLines.get_children():
			switchers.set_enemy_period(enemySpawner.enemyWaitTime)
			switchers.set_enemy_period_delta(enemySpawner.enemyWaitTimeDelta)
			switchers.set_enemy_speed(enemySpawner.speed)
			switchers.set_enemy_health(enemySpawner.health)
			switchers.set_enemy_health_delta(enemySpawner.healthDelta)
			break
		
		for enemySpawner in enemyLines.get_children():
			switchers.set_difficult_period(enemySpawner.difficultWaitTime)
			switchers.set_difficult_value(enemySpawner.difficultVal)
			switchers.set_coin_chance_value(enemySpawner.coinChance)
			break
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
	score += _score
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

func restart_game():
	
	for enemySpawner in enemyLines.get_children():
		enemySpawner.stop_spawn_enemies()
		enemySpawner.start_spawn_enemies()
		
	coinSpawner.remove_coins()
	
	wall.restart()
	
	timer.stop()
	curSeconds = 0
	timerLbl.text = "00:00 "
	timer.start()
	
	score = 0
	change_score(0)
	
	coinsCnt = 0
	coinValLbl.text = str(coinsCnt)
	
	playerBonusPanel.restart()
	bonusPanel.restart()
	gameField.restart()
	bonusCooldownPanel.restart()
	
	if(true):
		educationStartTimer.start()
		
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
	coinsCnt += 1
	coinValLbl.text = str(coinsCnt)

func _on_config_button_button_down() -> void:
	switchers.visible = !switchers.visible

func _on_switchers_bullet_period_changed(_val: float) -> void:
	wall.set_bullet_period(_val)
	config.set_value("bullet", "period", _val)
	config.save("user://prefs.cfg")

func _on_switchers_bullet_power_mult_changed(_val: float) -> void:
	wall.set_bullet_power_mult(_val)
	config.set_value("bullet", "powerMult", _val)
	config.save("user://prefs.cfg")
	
func _on_switchers_bullet_power_shift_changed(_val: float) -> void:
	wall.set_bullet_power_shift(_val)
	config.set_value("bullet", "powerShift", _val)
	config.save("user://prefs.cfg")
	
func _on_switchers_bullet_speed_changed(_val: float) -> void:
	wall.set_bullet_speed(_val)
	config.set_value("bullet", "speed", _val)
	config.save("user://prefs.cfg")

func _on_switchers_enemy_health_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.health = _val
	config.set_value("enemy", "health", _val)
	config.save("user://prefs.cfg")

func _on_switchers_enemy_health_delta_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.healthDelta = _val
	config.set_value("enemy", "healthDelta", _val)
	config.save("user://prefs.cfg")

func _on_switchers_enemy_period_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_period(_val)
	config.set_value("enemy", "period", _val)
	config.save("user://prefs.cfg")

func _on_switchers_enemy_period_delta_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_period_delta(_val)
	config.set_value("enemy", "periodDelta", _val)
	config.save("user://prefs.cfg")
	
func _on_switchers_enemy_speed_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_enemy_speed(_val)
	config.set_value("enemy", "speed", _val)
	config.save("user://prefs.cfg")

func _on_switchers_difficult_period_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.set_difficult_period(_val)
	config.set_value("difficult", "period", _val)
	config.save("user://prefs.cfg")
	
func _on_switchers_difficult_value_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.difficultVal = _val
	config.set_value("difficult", "value", _val)
	config.save("user://prefs.cfg")

func _on_switchers_coin_chance_value_changed(_val: float) -> void:
	for enemySpawner in enemyLines.get_children():
		enemySpawner.coinChance = _val
	config.set_value("coinChance", "value", _val)
	config.save("user://prefs.cfg")

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
