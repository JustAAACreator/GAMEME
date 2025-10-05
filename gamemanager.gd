extends Node
@onready var score_label: Label = $CanvasLayer/Label
var score = 0
const FILE_BEGIN = "res://Scenes/level_"

func add_point():
	score += 1
	score_label.text = "STARS : " + str(score)


func _on_next_pressed() -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene.to_int() + 1
	var next_level = FILE_BEGIN + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level)
	print(next_level_number)
	
	pass # Replace with function body.
