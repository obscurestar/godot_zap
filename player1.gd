extends CharacterBody2D

const SPEED := 400.0

var player_num := 1
var action_move_right := "player1_right"
var action_move_left := "player1_left"
var action_move_down := "player1_down"
var action_move_up := "player1_up"

# func _init():  //SET ONLY DON'T READ use _ready()

func _ready():
	#Do stuff once the object is fully loaded.
	
	#Pull the player number from the object's metadata and use it to define control inputs.
	if self.has_meta("player_num"):
		var player_num = self.get_meta("player_num")
		var prefix = "player" + str(player_num)
		self.action_move_right = prefix + "_right"
		self.action_move_left = prefix + "_left"
		self.action_move_up = prefix + "_up"
		self.action_move_down = prefix + "_down"
		
		print("Settings set to " + self.action_move_right + " " + self.action_move_left)
		


func get_input():
	var input_direction = Input.get_vector(action_move_left, 
											action_move_right, 
											action_move_up,
											action_move_down)
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed(action_move_right):
		_animated_sprite.play("run")
	else:
		_animated_sprite.stop()
