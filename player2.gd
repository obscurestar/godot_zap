extends CharacterBody2D
# This is a comment.  Javascript doesn't allow comments.

const SPEED := 40.0

@export var move_right_action := "player2_right"
@export var move_left_action := "player2_left"
@export var move_down_action := "player2_down"
@export var move_up_action := "player2_up"

@onready var _animated_sprite = $AnimatedSprite2D

func get_input():
	var input_direction = Input.get_vector(move_left_action, 
											move_right_action, 
											move_up_action,
											move_down_action)
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	
	

func _process(_delta):
	if Input.is_action_pressed(move_right_action):
		_animated_sprite.play("march-right")
#		'advance' is in the tutorial but 
#		"Invalid call. Nonexistent function 'advance' in base 'AnimatedSprite2D'."
#		Need to switch to 'animation_player' from 'animated_sprite'
#		_animated_sprite.advance(0)
	elif Input.is_action_pressed(move_left_action):
		_animated_sprite.play("march-left")
	elif Input.is_action_pressed(move_up_action):
		_animated_sprite.play("march-up")
	elif Input.is_action_pressed(move_down_action):
		_animated_sprite.play("march-down")
	else:
#		This is supposed to stop the animation, but it seems to end it permanently.		
#		_animated_sprite.stop()
		_animated_sprite.play("parade")
