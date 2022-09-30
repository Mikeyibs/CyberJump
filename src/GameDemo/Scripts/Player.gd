extends KinematicBody2D

# Constants
const UP = Vector2(0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 450
var MAXSPEED = 100
const ACCEL = 80
const TYPE = "player"
const MAXJUMPSPEED = 800

# Movement modifiers 
var JUMPFORCE = 400
var motion = Vector2()
var facing_right = true
var fallMultiplier = 1.5
var lowJumpMultiplier = 10
var speed 
var jumping_moveSpeed = 0
var _duration_pressed = 0
var _time_when_pushed = 0

# Animation timer variables
onready var animPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

# Actives animation tree
func _ready():
	animTree.active = true

# Tests to see if the buttom was pressed
func _pressed():
	_duration_pressed = 0
	
		
func _determine_TIME(_duration_pressed, delta):
	var speed_after_jump
	
	if _duration_pressed < 1:
		speed_after_jump = 1.25 + delta
	elif _duration_pressed > 1:
		speed_after_jump = 2 + delta

	return speed_after_jump
	

# Main Physics function
func _physics_process(delta):
	
	# Essentially adding gravity
	motion.y += GRAVITY
	
	# Capping the fall speed
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	# Jump function
	if is_on_floor():
		# When the space bar is pressed it will run both the
		# _pressed() and _process(delta) to see how long it
		# was held.
		if Input.is_action_just_pressed("jump"):
			_time_when_pushed = OS.get_ticks_msec()
		
		# Once released
		if Input.is_action_just_released("jump"):
			_duration_pressed = (OS.get_ticks_msec() - _time_when_pushed) / 1000.0
			print(_duration_pressed)
			# Calculuates the power of the jump in the y direction
			motion.y = -JUMPFORCE * (_determine_TIME(_duration_pressed, delta))
			# Calculuates the power of the jump in the rightward
			# x direction.
			if $Sprite.scale.x == -1.25:
				MAXSPEED = 250
				motion.x = 350 * _determine_TIME(_duration_pressed, delta)
			# Calculates the power of the jump in the leftward
			# x direction
			if $Sprite.scale.x == 1.25:
				MAXSPEED = 250
				motion.x = -350 * _determine_TIME(_duration_pressed, delta)
			
			_pressed()
	
	# Changes sprite direction.
	if facing_right == true:
		$Sprite.scale.x = -1.25
	else:
		$Sprite.scale.x = 1.25
	
	# Forces the user to not change x-direction in the air
	if !is_on_floor():
		speed = jumping_moveSpeed
	# While on the floor this sets the movement speed to the
	# constant acceleration value. 
	elif is_on_floor():
		speed = ACCEL
	
	# Caps the movement speed in the x direction
	
	motion.x = clamp(motion.x, -MAXSPEED,MAXSPEED)
	
	# Movement processes
	if Input.is_action_pressed("right"):
		MAXSPEED = 100
		motion.x += speed
		facing_right = true
		$AnimationPlayer.play("Demo")
	elif Input.is_action_pressed("left"):
		MAXSPEED = 100
		motion.x -= speed
		facing_right = false
		$AnimationPlayer.play("Demo")
	else:
		if is_on_floor():
			motion.x = lerp(motion.x,0,0.2)
		$AnimationPlayer.play("Idle")
	
	motion = move_and_slide(motion, UP)


func _on_Goal_body_entered(body):
	pass # Replace with function body.
