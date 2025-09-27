extends Area2D
@onready var playeranim: AnimationPlayer = $"../Gamemanager/AnimationPlayer"
@onready var camera_2d_2: Camera2D = $"../Gamemanager/Camera2D2"
@onready var player: CharacterBody2D = $"../Player"

func _on_body_entered(body: CharacterBody2D) -> void:
	print("anim")
	body.animationON = true
	playeranim.play("ending")
	await get_tree().create_timer(1.0).timeout
	camera_2d_2.enabled = true
	camera_2d_2.make_current()

	
