extends Node

var poisonPeriod = 0.2
var poisonDamage  = 1
var poisonDuration = 5
var effectDurationCnt = 0
var effectPeriodCnt = 0
var enemy = null
var manager = null

func init(_period: float, _duration: float, _damage: float):
	effectDurationCnt = 0
	
	poisonPeriod = _period
	poisonDuration = _duration
	poisonDamage = _damage

func set_manager(_manager:Node):
	manager = _manager
	
func set_enemy(_enemy: EnemyElement):
	enemy = _enemy
	enemy.set_poison(self)

func update():
	effectDurationCnt = 0
	
func _process(_delta: float) -> void:
	if(enemy == null):
		return
		
	if(!enemy.visible):
		enemy.remove_poison()
		enemy = null
		if(manager != null):
			manager.remove_poison_effect(self)
		return
	
	if(effectDurationCnt < poisonDuration):
		effectDurationCnt += _delta
		if(effectPeriodCnt < poisonPeriod):
			effectPeriodCnt += _delta
		else:
			enemy.damaged(poisonDamage)
			effectPeriodCnt = 0
			
	else:
		effectPeriodCnt = 0
		enemy.remove_poison()
		enemy = null
		if(manager != null):
			manager.remove_poison_effect(self)
