extends Node

var freezeDuration = 5
var slowFactor = 0.5

var effectDurationCnt = 0

var enemy = null
var manager = null

func init(_duration: float, _slowFactor: float):
	effectDurationCnt = 0
	freezeDuration = _duration
	slowFactor = _slowFactor

func set_manager(_manager:Node):
	manager = _manager
	
func set_enemy(_enemy: EnemyElement):
	enemy = _enemy
	enemy.set_freeze(self)

func update():
	effectDurationCnt = 0

func get_slow_factor():
	return slowFactor
	
func _process(_delta: float) -> void:
	if(enemy == null):
		return
		
	if(!enemy.visible):
		enemy.remove_freeze()
		enemy = null
		if(manager != null):
			manager.remove_freeze_effect(self)
		return
	
	if(effectDurationCnt < freezeDuration):
		effectDurationCnt += _delta
	else:
		enemy.remove_freeze()
		enemy = null
		if(manager != null):
			manager.remove_freeze_effect(self)
