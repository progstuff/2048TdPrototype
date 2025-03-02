extends PanelContainer

signal bullet_period_changed(_val: float)
signal bullet_speed_changed(_val: float)
signal bullet_power_mult_changed(_val: float)
signal bullet_power_shift_changed(_val: float)

signal enemy_period_changed(_val: float)
signal enemy_period_delta_changed(_val: float)
signal enemy_speed_changed(_val: float)
signal enemy_health_changed(_val: float)
signal enemy_health_delta_changed(_val: float)

signal difficult_period_changed(_val:float)
signal difficult_value_changed(_val: float)
signal coin_chance_value_changed(_val: float)

@onready var bulletPeriodLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/BulletPeriodLbl
@onready var bulletPeriodSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/BulletPeriodSlider

@onready var bulletSpeedLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer2/BulletSpeedLbl
@onready var bulletSpeedSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/BulletSpeedSlider

@onready var bulletPowerMultLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer3/BulletPowerMultLbl
@onready var bulletPowerMultSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/BulletPowerMultSlider

@onready var bulletPowerAdditionLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer4/BulletPowerAdditionLbl
@onready var bulletPowerAdditionSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer/BulletPowerAdditionSlider


@onready var enemyPeriodLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/HBoxContainer/EnemyPeriodLbl
@onready var enemyPeriodSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/EnemyPeriodSlider

@onready var enemyPeriodDeltaLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/HBoxContainer5/EnemyPeriodDeltaLbl
@onready var enemyPeriodDeltaSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/EnemyPeriodDeltaSlider

@onready var enemySpeedLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/HBoxContainer2/EnemySpeedLbl
@onready var enemySpeedSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/EnemySpeedSlider

@onready var enemyHealthLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/HBoxContainer3/EnemyHealthLbl
@onready var enemyHealthSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/EnemyHealthSlider

@onready var enemyHealthDeltaLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/HBoxContainer4/EnemyHealthDeltaLbl
@onready var enemyHealthDeltaSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer4/EnemyHealthDeltaSlider


@onready var difficultPeriodLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer/DifficultPeriodLbl
@onready var difficultPeriodSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/DifficultPeriodSlider

@onready var difficultValLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer2/DifficultValLbl
@onready var difficulValSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/DifficultValSlider

@onready var coinChanceLbl = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/HBoxContainer3/CoinChanceLbl
@onready var coinChanceSlider = $ScrollContainer/MarginContainer/VBoxContainer2/VBoxContainer3/CoinChanceSlider

func _ready() -> void:
	pass

func set_bullet_period(_val: float):
	bulletPeriodSlider.value = _val
func set_bullet_speed(_val: float):
	bulletSpeedSlider.value = _val
func set_bullet_power_mult(_val: float):
	bulletPowerMultSlider.value = _val
func set_bullet_shift_value(_val: float):
	bulletPowerAdditionSlider.value = _val
	
func set_enemy_period(_val: float):
	enemyPeriodSlider.value = _val
func set_enemy_period_delta(_val:float):
	enemyPeriodDeltaSlider.value = _val
func set_enemy_speed(_val: float):
	enemySpeedSlider.value = _val
func set_enemy_health(_val: float):
	enemyHealthSlider.value = _val
func set_enemy_health_delta(_val: float):
	enemyHealthDeltaSlider.value = _val

func set_difficult_period(_val: float):
	difficultPeriodSlider.value = _val
func set_difficult_value(_val: float):
	difficulValSlider.value = _val
func set_coin_chance_value(_val: float):
	coinChanceSlider.value = _val
	
func _on_bullet_period_slider_value_changed(value: float) -> void:
	bulletPeriodLbl.text = str(value)
	bullet_period_changed.emit(value)

func _on_bullet_speed_slider_value_changed(value: float) -> void:
	bulletSpeedLbl.text = str(value)
	bullet_speed_changed.emit(value)
	
func _on_bullet_power_mult_slider_value_changed(value: float) -> void:
	bulletPowerMultLbl.text = str(value)
	bullet_power_mult_changed.emit(value)

func _on_bullet_power_addition_slider_value_changed(value: float) -> void:
	bulletPowerAdditionLbl.text = str(value)
	bullet_power_shift_changed.emit(value)

func _on_enemy_period_slider_value_changed(value: float) -> void:
	enemyPeriodLbl.text = str(value)
	enemy_period_changed.emit(value)

func _on_enemy_period_delta_slider_value_changed(value: float) -> void:
	enemyPeriodDeltaLbl.text = str(value)
	enemy_period_delta_changed.emit(value)
	
func _on_enemy_speed_slider_value_changed(value: float) -> void:
	enemySpeedLbl.text = str(value)
	enemy_speed_changed.emit(value)
	
func _on_enemy_health_slider_value_changed(value: float) -> void:
	enemyHealthLbl.text = str(value)
	enemy_health_changed.emit(value)
	
func _on_enemy_health_delta_slider_value_changed(value: float) -> void:
	enemyHealthDeltaLbl.text = str(value)
	enemy_health_delta_changed.emit(value)
	
func _on_difficult_period_slider_value_changed(value: float) -> void:
	difficultPeriodLbl.text = str(value)
	difficult_period_changed.emit(value)
	
func _on_difficult_val_slider_value_changed(value: float) -> void:
	difficultValLbl.text = str(value)
	difficult_value_changed.emit(value)

func _on_coin_chance_slider_value_changed(value: float) -> void:
	coinChanceLbl.text = str(value)
	coin_chance_value_changed.emit(value)
