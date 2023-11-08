class_name ReleMasa
extends Node2D



##Metodos
func _ready()-> void:
	Eventos.emit_signal("minimapa_objeto_creado")

##metodo custom
func atraer_player(body:Node)->void:
	$Tween.interpolate_property(body, "global_position", body.global_position, global_position, 1.0, Tween.TRANS_CIRC, Tween.EASE_IN)
	$Tween.start()


##Señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String)-> void:
	if anim_name == "Spawn":
		$AnimationPlayer.play("Activado")


func _on_DetectorPlayer_body_entered(body: Node)-> void:
	$DetectorPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Super_Activado ")
	body.desactivar_controles()
	atraer_player(body)


func _on_Tween_tween_all_completed()-> void:
	print ("pasaste de galaxia")
