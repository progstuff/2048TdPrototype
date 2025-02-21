extends Node2D

var pool = {}

var enemy = load("res://Data/EnemyScene.tscn")
@onready var enemies = $Enemies
var timer = null

@export var minEnemiesCnt = 7
@export var maxEnemiesCnt = 15
@export var minPower = 1
@export var maxPower = 5
@export var minSpeed = 100
@export var maxSpeed = 500
@export var minWaitTime = 0.5
@export var maxWaitTime = 0.9

func _ready():
	start_spawn_enemies()
	
func start_spawn_enemies():
	if(enemies == null):
		enemies = $Enemies
	if(timer == null):
		timer = $Timer
	timer.start()

func stop_spawn_enemies():
	timer.stop()
	for item in enemies.get_children():
		remove_enemy(item)
		enemies.remove_child(item)
		
func create_enemy(_power: int, _health: int, _startPosition: Vector2, _speed: int):
	if(!pool.has(_power)):
		pool[_power] = Array()
	
	var data = pool[_power].pop_front()
	if(data == null):
		data = enemy.instantiate()
	data.init(_power, _health, _startPosition, _speed)
		
	return data

func remove_enemy(_enemy: EnemyElement):
	var power = _enemy.power
	if(!pool.has(power)):
		pool[power] = Array()
	#enemies.call_deferred('remove_child', _enemy)
	_enemy.deactivate()
	pool[power].push_back(_enemy)

func _on_timer_timeout() -> void:
	var sz = get_viewport().get_visible_rect().size
	var enemiesCount = randi_range(minEnemiesCnt, maxEnemiesCnt)
	
	for i in range(0, enemiesCount):
		var power = pow(2, randi_range(minPower, maxPower))
		var speed = randf_range(minSpeed, maxSpeed)
		var x = randi_range(sz.x, sz.x+100)
		var y = randi_range(16, sz.y-16)
		var obj = create_enemy(power, power, Vector2(x, y), speed)
		if(!obj.get_parent() == enemies):
			enemies.add_child(obj)
	
	var waitTime = randf_range(minWaitTime, maxWaitTime)
	timer.wait_time = waitTime
