class_name Escudo
extends Area2D

##Metodos
func _ready()-> void:
	controlar_colisionador(true)
	
##metodos customs
func controlar_colisionador(esta_desactivado : bool)-> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)
	
func activar()->void:
	controlar_colisionador(false)
	$AnimationPlayer.play("Activando")
	

##señales interna




func _on_AnimationPlayer_animation_finished(anim_name: String)-> void:
	if anim_name == "Activando":
		$AnimationPlayer.play("Activado")
