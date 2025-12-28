extends CharacterBody2D
@onready var player: CharacterBody2D = $"../Player"

var speed = 150
var follow = false
var rightin: Marker2D
func _ready():
	rightin = get_node("../Player/flyenemyin/right")
func _physics_process(delta):
	if follow == true:
		print("what")
		var direction = global_position.direction_to(rightin.global_position)
		velocity = direction * speed
		move_and_slide()
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("what")
	if area.is_in_group("flyout"):
		follow = true
