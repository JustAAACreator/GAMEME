extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

var speed = -20
var hp: float = 20
var facing_right = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	area_2d.area_entered.connect(_on_area_entered)
func _physics_process(delta):
	if hp <=0:
		print("ENEMYHASBEENDESTROYED")
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
		
	velocity.x = speed
	move_and_slide()


func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("UDAR OT VRAGA!!!")
		var player = area.owner
		player.knockback(50, global_position.x, 4)
		player.udar(5)
func udar(damage):
	hp -=damage
		
