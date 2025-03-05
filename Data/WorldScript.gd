extends Node2D

@onready var gameField = $GameField
@onready var wall = $Wall
@onready var damageValLbl = $Control/HBoxContainer/PanelContainer/VBoxContainer/DamageCnt
@onready var coinValLbl = $Control/HBoxContainer/PanelContainer2/VBoxContainer/CoinsCnt
@onready var enemyLines = $EnemyLines
@onready var timer =$Timer
@onready var timerLbl = $Control/TimerLbl
@onready var switchers = $Control/Switchers
@onready var coinSpawner = $CoinSpawner

var coinsCnt = 0
var curSeconds = 0

var enemySpawnerScene = load("res://Data/EnemySpawnerScene.tscn")

var config = ConfigFile.new()


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
			
func _on_game_field_max_value_changed() -> void:
	if(gameField == null):
		gameField = $GameField
	if(damageValLbl == null):
		damageValLbl = $VBoxContainer/HBoxContainer/DamageCnt
	if(wall == null):
		wall = $Wall
	wall.change_lvl(gameField.maxNumbers)
	damageValLbl.text = str(wall.damage)

func restart_game():
	
	for enemySpawner in enemyLines.get_children():
		enemySpawner.stop_spawn_enemies()
		enemySpawner.start_spawn_enemies()
		
	coinSpawner.remove_coins()
	
	wall.restart()
	
	curSeconds = 0
	timerLbl.text = "00:00 "
	
	coinsCnt = 0
	coinValLbl.text = str(coinsCnt)
	
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
