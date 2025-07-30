extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var timer: Timer = $Timer

var speed = -20
var hp: float = 5
var facing_right = false
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var deathfalse = false

func _ready():
	area_2d.area_entered.connect(_on_area_entered)
	timer.timeout.connect(_on_timer_timeout)
func _physics_process(delta):
	if hp <=0 and deathfalse == false:
		animated_sprite_2d.play("dead")
		death = true
		timer.start()
		velocity = Vector2(0,0)
		print("what")
		deathfalse = true
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !$RayCast2D.is_colliding() and is_on_floor() and death == false:
		flip()
	if death == false:	
		velocity.x = speed
	move_and_slide()


func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right and death == false:
		speed = abs(speed)
	else:
		if death == false:
			speed = abs(speed) * -1
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and death == false:
		print("UDAR OT VRAGA!!!")
		var player = area.owner
		player.knockback(50, global_position.x, 4)
		player.udar(5)
func udar(damage):
	hp -=damage
func _on_timer_timeout():
	print("what")
	queue_free()
		
