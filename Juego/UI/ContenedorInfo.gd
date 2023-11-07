class_name contenedorInfo
extends NinePatchRect


##Atributos Export

export var auto_ocultar: bool = false setget set_auto_ocultar



##Atributos Onready

onready var texto_contenedor: Label = $Label
onready var auto_ocultar_timer: Timer = $AutoOcultarTimer
onready var animaciones: AnimationPlayer = $AnimationPlayer

##metodos
func mostrar()-> void:
	$AnimationPlayer.play("mostrar")
	
func ocultar()-> void:
	$AnimationPlayer.play("ocultar")
	
func mostrar_suavisado()-> void:
	$AnimationPlayer.play("mostrar_suavisado")
	if auto_ocultar:
		auto_ocultar_timer.start()
	
func ocultar_suavisado()-> void:
	$AnimationPlayer.play("ocultar_suavisado")
	
func modificar_texto(tex: String)-> void:
	texto_contenedor.text = tex


func _on_AutoOcultarTimer_timeout()-> void:
	ocultar_suavisado()

func get_auto_ocultar() -> bool:
	return auto_ocultar
	
func set_auto_ocultar(value: bool) -> void:
	auto_ocultar = value
