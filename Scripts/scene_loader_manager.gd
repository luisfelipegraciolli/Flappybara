extends Node

signal progress_changed(progress: float)
signal load_finished

var loading_screen: PackedScene = preload("uid://c5lweb6unh5qu")
var loaded_resource: PackedScene
var target_scene_path: String
var progress: Array = []
var use_sub_threads: bool = true


func _ready() -> void:
	set_process(false)
	
func load_scene(_scene_path: String) -> void:
	target_scene_path = _scene_path
	var new_load_screen: LoadingScreen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	
	await new_load_screen.loading_screen_ready
	
	start_load()

	
func start_load() -> void:
	# Se o método não retornar um error, queremos começar o processo
	var state: Error = ResourceLoader.load_threaded_request(target_scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
	
func _process(_delta: float) -> void:
	var load_status: int  = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(target_scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
			
