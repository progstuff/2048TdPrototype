extends Control

@onready var image = $MarginContainer/MarginContainer2/Image
@onready var cooldownLbl = $MarginContainer/MarginContainer/ColdownLbl
@onready var cooldownProgress = $MarginContainer/CooldownProgress

var isActivate = false
var bonusCooldownPanel = null
var cooldown = 20
var curTime = cooldown

func init(_bonusCooldownPanel:Control, _image:Texture2D, _cooldown:float):
	if(image == null):
		image = $MarginContainer/MarginContainer2/Image
	if(cooldownLbl == null):
		cooldownLbl = $MarginContainer/MarginContainer/ColdownLbl
	if(cooldownProgress == null):
		cooldownProgress = $MarginContainer/CooldownProgress
	
	bonusCooldownPanel = _bonusCooldownPanel
	image.texture = _image
	cooldownProgress.max_value = _cooldown
	curTime = _cooldown
	cooldownProgress.value = cooldown - curTime
	cooldownLbl.text = str(int(ceil(curTime)))

func activate():
	isActivate = true
	
func deactivate():
	isActivate = false
	
func _process(_delta: float) -> void:
	if(!isActivate):
		return
		
	if(curTime <= 0):
		bonusCooldownPanel.remove_bonus_cooldown(self)
		return
	
	curTime -= _delta
	cooldownProgress.value = cooldown - curTime
	cooldownLbl.text = str(int(ceil(curTime)))
