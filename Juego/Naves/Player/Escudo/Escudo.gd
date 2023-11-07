class_name Escudo
extends Area2D
## variables Export
export var energia: float = 8.0
export var radio_desgaste: float = -1.6

##variables
var esta_activado: bool = false setget ,get_esta_activado
var energia_original: float

## setters and getters
func get_esta_activado()-> bool:
	return esta_activado
	

##Metodos
func _ready()-> void:
	energia_original = energia
	set_process(false)
	controlar_colisionador(true)
	
func _process(delta:float)-> void:
	controlar_energia (radio_desgaste * delta)
	
##metodos customs

func controlar_energia(consumo: float)-> void:
	energia += consumo
	print("Energia Escudo: ", energia)
	
	
	if energia > energia_original:
		energia = energia_original
	elif energia <= 0.0:
		Eventos.emit_signal("ocultar_energia_escudo")
		desactivar()
		return
	



func controlar_colisionador(esta_desactivado : bool)-> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)


	
	
func activar()->void:
	if energia <= 0.0:
		return
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("Activando")
	
func desactivar()-> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("Activando")
	
	

##señales interna




func _on_AnimationPlayer_animation_finished(anim_name: String)-> void:
	if anim_name == "Activando" and esta_activado:
		$AnimationPlayer.play("Activado")
		set_process(true)


func _on_Escudo_body_entered(body: Node)-> void:
	body.queue_free()
