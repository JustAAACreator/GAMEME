extends Area2D
@onready var playeranim: AnimationPlayer = $"../Gamemanager/AnimationPlayer"
@onready var camera_2d_2: Camera2D = $"../Gamemanager/Camera2D2"
@onready var player: CharacterBody2D = $"../Player"
var endanimfinished = false
func _on_body_entered(body: CharacterBody2D) -> void:
	print("anim")
	body.animationON = true
	playeranim.play("ending")
	await get_tree().create_timer(1.0).timeout
	camera_2d_2.enabled = true
	camera_2d_2.make_current()

	


func _on_animation_player_animation_finished(ending: StringName) -> void:
	if endanimfinished == false:
		playeranim.play("uilevelend")
		endanimfinished = true
	pass # Replace with function body.
