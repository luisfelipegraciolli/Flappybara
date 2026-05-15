class_name Capybara extends CharacterBody2D

signal get_score(new_score: int)
signal death

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
var dead: bool = false
var score: int = 0
var free_to_fly: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
	
func add_score() -> void:
	score+=1
	$ScoreSound.play()
	get_score.emit(score)

func die() -> void:    
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("death")
	$DeathSound.play()
	death.emit()

func jump() -> void:
	free_to_fly = true
	if not dead:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("flap")
			$JumpSound.pitch_scale = randf_range(0.9, 1.1)
			$JumpSound.play()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()

func _physics_process(delta: float) -> void:
	if free_to_fly:
		velocity += get_gravity() * delta
		move_and_slide()
