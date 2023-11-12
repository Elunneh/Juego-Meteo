class_name MenuPausa
extends Control

func _ready()-> void:
	visible =  false
	
func _input(event)-> void:
	if event.is_action_pressed("pausa"):
		visible = not visible
		get_tree().paused = not get_tree().paused



	


func _on_ButtonContinuar_pressed():
	get_tree().paused = false
	visible =  false
	
