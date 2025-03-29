extends Node

var effectsManager = null

var period = 0.2
var duration = 4
var damage = 1

func set_params(_period: float, _duration: float, _damage: float):
	period = _period
	duration = _duration
	damage = _damage

func set_manager(_manager: Node):
	effectsManager = _manager
	
func add_poison_to_enemy(_enemy: EnemyElement):
	var needPoison = false
	
	if(_enemy.is_poisoned()):
		if(_enemy.get_poison() != null):
			_enemy.get_poison().update()
		else:
			needPoison = true
	else:
		needPoison = true
	
	if(needPoison):
		var poisonEffect = effectsManager.create_poison_effect()
		poisonEffect.init(period, duration, damage)
		poisonEffect.set_enemy(_enemy)
