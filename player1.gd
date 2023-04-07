extends CharacterBody2D

const WALK_SPEED := 40.0
const ZAP_SPEED := 60.0
const ZAP_RANGE := 600.0
const ZAP_RECHARGE_TIME := 0.5  #seconds

@onready var zap := $Hook
@onready var zap_shape := $Hook/CollisionShape2D

#For now limit zaps to 1 zap at a time and have a recharge time for them
enum ZapStates {NONE, ZAPPING, RECHARGE}

#TODO: Placeholder for different morphs having different zaps.
enum ZapType {BEAM, LOB}

var player_num := 1
var action_move_right := "player1_right"
var action_move_left := "player1_left"
var action_move_down := "player1_down"
var action_move_up := "player1_up"
var action_zap  := "player1_zap"
var input_direction := Vector2(0,0)      #Last direction of movement detected.
var zap_direction := Vector2(0,0)
var zap_state: ZapStates = ZapStates.NONE
var zap_recharge_timer = Timer.new()

func _on_zap_recharge():
	self.zap_state = ZapStates.NONE
	zap_hide()   #TODO probably don't need this here.

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
		self.action_zap = prefix + "_zap"
		add_child(self.zap_recharge_timer)
		#zap_recharge_timer.connect("timeout",self,"_on_zap_recharge")
		self.zap_recharge_timer.wait_time = ZAP_RECHARGE_TIME
		self.zap_recharge_timer.one_shot = false


		
		print("Settings set to " + self.action_move_right + " " + self.action_move_left)
		

func zap_hide():
	zap.hide()
	zap_shape.set_disabled.call_deferred(true) 
	

func get_input():
	self.input_direction = Input.get_vector(action_move_left, 
											action_move_right, 
											action_move_up,
											action_move_down)
	velocity = self.input_direction * WALK_SPEED

func do_zap():
	#Fire the zappy beam. 
	if self.input_direction == Vector2(0,0):	#No direction to zappy.
		return
	
	match self.zap_state:
		ZapStates.NONE:		#Zap the zapper
			if Input.is_action_just_pressed(self.action_zap):
				self.zap_state = ZapStates.ZAPPING
				zap.global_position = global_position
				self.zap_direction = self.input_direction
				zap.show()
				zap_shape.disabled = false
		ZapStates.RECHARGE:
			#Wait for cooldown.  This is handled in a callback.
			#TODO: Could add a sound to indicate waiting. *CLICK*
			pass 
		#ZapStates.ZAPPING:  We don't want an edge case later where we just 
		#changed from none so let's handle this outside the match.
			
	#State could have changed from NONE to ZAPPING so check here.
	if self.zap_state == ZapStates.ZAPPING:  
		zap.global_position += zap_direction * ZAP_SPEED
		if zap.global_position.distance_to(global_position) >= ZAP_RANGE:
			#TODO FIX TIMER zap_state = ZapStates.RECHARGE
			self.zap_state = ZapStates.NONE
			self.zap_recharge_timer.start()
			zap_hide()
			

	
func _physics_process(delta: float) -> void:
	get_input()
	do_zap()
	move_and_slide()


@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed(action_move_right):
		_animated_sprite.play("drgn-right")
#		'advance' is in the tutorial but 
#		"Invalid call. Nonexistent function 'advance' in base 'AnimatedSprite2D'."
#		Need to switch to 'animation_player' from 'animated_sprite'
#		_animated_sprite.advance(0)
	elif Input.is_action_pressed(action_move_left):
		_animated_sprite.play("drgn-left")
	elif Input.is_action_pressed(action_move_up):
		_animated_sprite.play("drgn-up")
	elif Input.is_action_pressed(action_move_down):
		_animated_sprite.play("drgn-down")
	else:
#		This is supposed to stop the animation, but it seems to end it permanently.		
#		_animated_sprite.stop()
		_animated_sprite.play("drgn-parade")
