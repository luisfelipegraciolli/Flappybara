extends Control

@export var main_menu_scene_uid: StringName = &""



func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	SceneLoaderManager.load_scene(main_menu_scene_uid)
