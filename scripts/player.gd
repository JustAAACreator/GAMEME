extends CharacterBody2D


const SPEED = 145.0
const WALLJUMP_VELOCITY = -200
const JUMP_VELOCITY = -270.0
const WALL_JUMP_PUSH: float = 175
const WALL_JUMP_DISABLE_TIME: float = 0.12
const WALL_SLIDE_SPEED: float = 65.0
const COYOTE_TIME: float = 0.1


var kicktimer: float = 0
var airjumptimer: float = 0
var last_wall: Vector2 = Vector2.ZERO
var wall_jump_timer: float = 0.0
var dash_timer: float = 0.0
var dash: bool = false
var naprovlenie = 0
var dash_reload: float = 0.0
var walljumptrue: bool = false
var minjumptimer: float = 0.0
var moving: bool = true
var prev_dash = false
var prev_kick = false
var kick = false
var coyote_timer: float = 0.0
var was_on_floor: bool = false

@onready var kik: CollisionShape2D = $MyHitBox/kickcollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rect: ColorRect = $"../Gamemanager/CanvasLayer/ColorRect"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var my_hit_box: Area2D = $MyHitBox

func _ready():
	my_hit_box.area_entered.connect(_on_area_entered)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	if wall_jump_timer <= 0:
		walljumptrue = false
	if dash_timer > 0:
		dash_timer -= delta
	if dash_timer <= 0:
		dash = false
	if kicktimer > 0:
		kicktimer -= delta
	if kicktimer <= 0:
		kick = false
	if dash != prev_dash:
		if dash:
			moving=false
			print("not moving!")
		else:
			moving=true
			print("moving!")
		prev_dash = dash
	if kick != prev_kick:
		if kick:
			moving=false
			print("not moving!")
		else:
			moving=true
			print("moving!")
		prev_kick = kick
	if kicktimer <= 0.20:
		kik.disabled = false
	if minjumptimer > 0:
		minjumptimer -= delta
	if kicktimer <=0:
		kik.disabled = true
	if dash_reload >0:
		dash_reload -= delta
		var rectxsize = rect.size.x
		rect.size = Vector2(rectxsize - delta *220, 110)
	if is_on_floor():
		airjumptimer = 0
		coyote_timer = COYOTE_TIME
		was_on_floor = true
	elif was_on_floor:
		coyote_timer -= delta
		if coyote_timer <= 0:
			was_on_floor = false

	if not is_on_floor():
		airjumptimer += 1
		velocity += get_gravity() * delta

		var wall_normal = get_wall_normal()
		
		if is_on_wall() and velocity.y >0 and abs(wall_normal.x) > 0.9:
			if wall_normal != last_wall:
				if moving == true:
					animated_sprite.play("jump")
				animated_sprite.flip_h = wall_normal.x < 0
				velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
		else:
			if velocity.y >0:
				if moving == true:
					animated_sprite.play("jump")
		
	else:
		last_wall = Vector2.ZERO
	# Handle jump.
	
	if Input.is_action_just_pressed("jump"):
		minjumptimer = 0.10
		if is_on_floor() or (airjumptimer > 0 and airjumptimer <6):
			if moving == true:
				animation_player.play("jump")
			velocity.y = JUMP_VELOCITY
			was_on_floor = false
			coyote_timer = 0
		elif is_on_wall() and abs(get_wall_normal().x) > 0.9:
			walljumptrue = true
			wall_jump_timer = WALL_JUMP_DISABLE_TIME
	if walljumptrue:
		velocity.y = WALLJUMP_VELOCITY
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * WALL_JUMP_PUSH
		if moving == true:
			animated_sprite.play("jump")
		animated_sprite.flip_h = wall_normal.x <0
		last_wall = wall_normal
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !Input.is_action_pressed("jump") and velocity.y < 0 and minjumptimer >=0:
		velocity += get_gravity() * delta * 3
		
	if animated_sprite.flip_h == false:
		my_hit_box.scale = Vector2(1, 1)
	if animated_sprite.flip_h == true:
		my_hit_box.scale = Vector2(-1, 1)
	var direction := Input.get_axis("move_left", "move_right")
	if moving == true:
		if direction >0:
			animated_sprite.flip_h = false
		if direction <0:
			animated_sprite.flip_h = true
	
	if direction:
		if dash == true:
			if moving == true:
				animated_sprite.play("jump")
			velocity.x =0
			velocity.y =0
			if naprovlenie >0:
				velocity.x = 1 * 325
			if naprovlenie <0:
				velocity.x = -1 * 325
		if moving == true:
			velocity.x = move_toward(velocity.x, direction*SPEED, SPEED * 0.15)
		if is_on_floor():
			if moving == true:
				animated_sprite.play("run")
		if moving == true:
			animated_sprite.flip_h = direction <0
	else:
		if moving == true:
			velocity.x= move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if moving == true:
				animated_sprite.play("Idle")
				
	if Input.is_action_just_pressed("dash") and dash == false and dash_reload <=0 and kick == false:
		dash_reload = 0.50
		rect.size = Vector2(109, 110)
		if animated_sprite.flip_h == false:
			naprovlenie = 1
		else:
			naprovlenie = -1
		dash = true
		dash_timer = 0.10
	if Input.is_action_just_pressed("kick") and dash == false:
		velocity.x = velocity.x * 0
		velocity.y = velocity.y * 0
		kicktimer = 0.50
		kick = true
		animated_sprite.play("kick")
		
	#KICK SCRIPT
	move_and_slide()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		print("UDAR!")
	
