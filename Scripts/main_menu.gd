extends Control
@export var main_game_scene: StringName = &""


func _on_quit_button_pressed() -> void:
	get_tree().quit() 


func _on_play_button_pressed() -> void:
	SceneLoaderManager.load_scene(main_game_scene)
	
