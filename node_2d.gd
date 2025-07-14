extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func _physics_process(delta: float) -> void:
	velocity.x= move_toward(velocity.x, 0, 2)
