extends Node2D

var pool = {}

var enemyScene = load("res://Data/EnemyScene.tscn")
@onready var enemies = $Enemies
@onready var spawnTimer = $SpawnTimer
@onready var difficultyTimer = $DifficultyTimer

var difficult = 0
@export var coinChance = 0.8
@export var coinChanceMultiplier = 1
@export var health = 3
@export var healthDelta = 2
@export var speed = 40
@export var enemyWaitTime = 3
@export var enemyWaitTimeDelta = 1

@export var difficultVal = 8
@export var difficultWaitTime = 4

@export var coinSpawner = null

var world = null

func _ready():
	start_spawn_enemies()

func set_world(_world: Node2D):
	world = _world
	
func start_spawn_enemies():
	calculate_enemy_wait_time()
	spawnTimer.start()
	difficult = 0
	difficultyTimer.start()
	
func stop_spawn_enemies():
	spawnTimer.stop()
	difficultyTimer.stop()
	for item in enemies.get_children():
		remove_enemy(item)
		
func create_enemy(_health: int, _startPosition: Vector2, _speed: int):
	if(!pool.has(_health)):
		pool[_health] = Array()
	
	var data = pool[_health].pop_front()
	if(data == null):
		data = enemyScene.instantiate()
	data.init(_health, _startPosition, _speed)
		
	return data

func set_enemy_speed(_speed: float):
	speed = _speed
	for enemy in enemies.get_children():
		enemy.speed = _speed
		
func remove_enemy(_enemy: EnemyElement):
	var enemyHealth = _enemy.maxHealth
	if(!pool.has(enemyHealth)):
		pool[enemyHealth] = Array()
	var pos = _enemy.get_global_center_pos()
	enemies.call_deferred('remove_child', _enemy)
	_enemy.deactivate()
	pool[enemyHealth].push_back(_enemy)
	
	var isNeedCoin = randf_range(0, 1) <= coinChance*coinChanceMultiplier
	if(isNeedCoin):
		coinSpawner.create_coin(pos)
		
	world.change_score(enemyHealth)

func _on_spawn_timer_timeout() -> void:
	var minHealth = health - healthDelta
	if(minHealth < 1):
		minHealth = 1
	var maxHealth = health + healthDelta
	if(minHealth > maxHealth):
		maxHealth = minHealth
		
	var creepHealth = randi_range(minHealth, maxHealth) + difficult
	var obj = create_enemy(creepHealth, Vector2(0, 0), speed)
	if(!obj.get_parent() == enemies):
		enemies.add_child(obj)
	
	calculate_enemy_wait_time()

func set_enemy_period(_waitTime: float):
	enemyWaitTime = _waitTime
	calculate_enemy_wait_time()

func set_enemy_period_delta(_periodDelta: float):
	enemyWaitTimeDelta = _periodDelta
	calculate_enemy_wait_time()

func set_difficult_period(_waitTime: float):
	difficultWaitTime = _waitTime
	difficultyTimer.wait_time = difficultWaitTime
	
func calculate_enemy_wait_time():
	var minWaitTime = enemyWaitTime - enemyWaitTimeDelta
	var maxWaitTime = enemyWaitTime + enemyWaitTimeDelta
	if(minWaitTime < 0.1):
		minWaitTime = 0.1
	if(maxWaitTime < minWaitTime):
		maxWaitTime = minWaitTime
	var valTime = randf_range(minWaitTime, maxWaitTime)
	spawnTimer.wait_time = valTime
	
func _on_difficulty_timer_timeout() -> void:
	difficult += difficultVal

func set_normal_coin_chance():
	coinChanceMultiplier = 1
