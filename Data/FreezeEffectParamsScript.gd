extends Node

var effectsManager = null

var duration = 2
var slowFactor = 0.1

func set_params(_duration: float, _slowFactor: float):
	duration = _duration
	slowFactor = _slowFactor

func get_slow_factor():
	return slowFactor
	
func set_manager(_manager: Node):
	effectsManager = _manager
	
func add_freeze_to_enemy(_enemy: EnemyElement):
	var needFreeze = false
	
	if(_enemy.is_freezed()):
		if(_enemy.get_freeze() != null):
			_enemy.get_freeze().update()
		else:
			needFreeze = true
	else:
		needFreeze = true
	
	if(needFreeze):
		var freezeEffect = effectsManager.create_freeze_effect()
		freezeEffect.init(duration, slowFactor)
		freezeEffect.set_enemy(_enemy)
