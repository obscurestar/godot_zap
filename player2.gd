extends CharacterBody2D
# This is a comment.  Javascript doesn't allow comments.

const SPEED := 400.0

@export var move_right_action := "player2_right"
@export var move_left_action := "player2_left"
@export var move_down_action := "player2_down"
@export var move_up_action := "player2_up"


func get_input():
	var input_direction = Input.get_vector(move_left_action, 
											move_right_action, 
											move_up_action,
											move_down_action)
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
	
