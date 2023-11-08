class_name contenedorInfo
extends NinePatchRect


##Atributos
var esta_activo : bool = true setget set_esta_activo


##Atributos Export

export var auto_ocultar: bool = false setget set_auto_ocultar



##Atributos Onready

onready var texto_contenedor: Label = $Label
onready var auto_ocultar_timer: Timer = $AutoOcultarTimer
onready var animaciones: AnimationPlayer = $AnimationPlayer

##metodos
func mostrar()-> void:
	if esta_activo:
		animaciones.play("mostrar")
	
func ocultar()-> void:
	if not esta_activo:
		animaciones.stop()
	animaciones.play("ocultar")
	
func mostrar_suavisado()-> void:
	if not esta_activo:
		return
	animaciones.play("mostrar_suavisado")
	if auto_ocultar:
		auto_ocultar_timer.start()
	
func ocultar_suavisado()-> void:
	if esta_activo:
		animaciones.play("ocultar_suavisado")
	
func modificar_texto(tex: String)-> void:
	texto_contenedor.text = tex

## setter y gettters

func get_auto_ocultar() -> bool:
	return auto_ocultar
	
func set_auto_ocultar(value: bool) -> void:
	auto_ocultar = value

func set_esta_activo(valor: bool)-> void:
	esta_activo = valor

func _on_AutoOcultarTimer_timeout()-> void:
	ocultar_suavisado()
	

