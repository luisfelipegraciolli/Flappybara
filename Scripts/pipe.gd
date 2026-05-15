extends Node2D

@export var pipe_speed: int
@onready var jaca: AnimatedSprite2D = $Jacare/Jaca
@onready var spider: AnimatedSprite2D = $Arana/Spider

func _ready() -> void:
	add_to_group("pipes")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:   
	self.queue_free()
		
func _process(delta: float) -> void:
	position.x -= pipe_speed * delta   
	
func _on_body_entered(body: Node2D) -> void:
	if body is Capybara:
		body.die()

func _on_gap_body_entered(body: Node2D) -> void:
	if body is Capybara:
		body.add_score()
func _stop() -> void:
	jaca.stop()
	spider.stop()
	set_process(false)
