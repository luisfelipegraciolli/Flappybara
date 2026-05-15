extends Node
@export var pipe_scene: PackedScene
@export var start_pipe_position_x: int = 850
@onready var score_label: Label = $ScoreLabel
@onready var pipe_timer: Timer = $PipeTimer
@onready var capybara: Capybara = $Capybara
@onready var tutorial_label: Label = $TutorialLabel


var global_score: int
var pipes_on_screen: Array = []

func load_high_score() -> int:
	if FileAccess.file_exists("user://save.txt"):
		var file: FileAccess = FileAccess.open("user://save.txt", FileAccess.READ)
		var score_read: int = file.get_16()
		print("Retrived Latest Highscore sucefully! " + str(score_read))
		return score_read
	else:
		print("File Does not exists")
		return 0   
func save_high_score(highscore: int, score_achieved: int) -> void:
	var file: FileAccess = FileAccess.open("user://save.txt", FileAccess.WRITE)
	if score_achieved > highscore:
		print("NEW HIGHSCORE!!!!" + str(score_achieved))
		highscore = score_achieved   
	#Save to same file    
		if file:
			file.store_16(highscore)
			print(str(highscore) + " Saved to file")
		else:
			print("Error saving highscore: ", FileAccess.get_open_error())
	else:
		file.store_16(highscore)

func _on_pipe_timer_timeout() -> void:
		var rand_pip_y: int = randi_range(-185, 120)
		var pipe: Node2D = pipe_scene.instantiate()
		pipe.position = Vector2(start_pipe_position_x, rand_pip_y)
		add_child(pipe)
		pipes_on_screen.append(pipe)
		

func _on_capybara_get_score(new_score: Variant) -> void:
	score_label.text = str(new_score)    
	global_score = new_score

func _on_capybara_death() -> void:

	await get_tree().create_timer(1).timeout
	var highscore: int = load_high_score()
	save_high_score(highscore, global_score) 
	$DeathScreenUI/VBoxContainer/Score.text = "Score: " + str(global_score)
	highscore = load_high_score() # Load again so it syncs with ui
	$DeathScreenUI/VBoxContainer/HighScore.text = "Highscore: " + str(highscore)
	$DeathScreenUI.visible = true
	await get_tree().create_timer(0).timeout
	stop_game()

func start_game() -> void:
	if capybara.free_to_fly:
		if pipe_timer.is_stopped():
			pipe_timer.start()
			tutorial_label.visible = false
			set_process(false)

func stop_game() -> void:
	# Background e timer dos pipes param
	pipe_timer.stop()
	get_tree().call_group("pipes", "_stop")
	$Background/j3.autoscroll.x = 0
	$Background/j2.autoscroll.x = 0
	$Background/j1.autoscroll.x = 0
	
	
func _process(delta: float) -> void:
	start_game()
