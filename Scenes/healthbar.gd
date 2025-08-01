extends TextureProgressBar
@onready var timer: Timer = $Timer
@onready var damage_bar: TextureProgressBar = $TextureProgressBar2

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	if health < prev_health:
		timer.start()

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
	print("whatamidoing12312313213123")
