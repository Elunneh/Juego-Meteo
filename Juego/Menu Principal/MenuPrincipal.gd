class_name MenuPrincipal
extends Node

export (String,FILE, "*.tscn" ) var nivel_inicial = ""

func _ready()-> void:
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)





func _on_ButtonJugar_pressed()-> void:
	MusicaJuego.play_boton()
	MusicaJuego.stop_todo()
	get_tree().change_scene(nivel_inicial)


func _on_ButtonSalir_pressed()-> void:
	get_tree().quit()