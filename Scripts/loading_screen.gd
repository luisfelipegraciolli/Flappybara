class_name LoadingScreen extends CanvasLayer

signal loading_screen_ready

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()

	
func _on_progress_changed(_new_value: float) -> void:
	# Passa valor de 0 a 1, usado para estilo da tela de loading
	# Posso usar isso para fazer uma barra de carregamento no futuro
	pass
	
func _on_load_finished() -> void:
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	queue_free()
