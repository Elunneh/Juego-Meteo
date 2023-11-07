class_name HUD
extends CanvasLayer


##Atributos onready
onready var info_zona_recarga:contenedorInfo = $InfoZonaRecarga
onready var info_meteoritos: contenedorInfo = $InfoMeteoritos
onready var info_tiempo_restante: contenedorInfo = $InfoTiempoResta

var auto_ocultar: bool = true setget set_auto_ocultar

#Metodos
func _ready()-> void:
	conectar_seniales()
	
func get_auto_ocultar() -> bool:
	return auto_ocultar
	
func set_auto_ocultar(value: bool) -> void:
	auto_ocultar = value
	


#metodos customs
func conectar_seniales()-> void:
	Eventos.connect("nivel_iniciado", self, "fade_out")
	Eventos.connect("nivel_terminado", self, "fade_int")
	Eventos.connect("cambio_numero_meteoritos", self, "_on_cambio_numero_meteoritos")
	Eventos.connect("detecto_zona_recarga", self, "_on_detecto_zona_recarga")
	Eventos.connect("actualizar_tiempo", self, "_on_actualizar_info_tiempo")


func fade_in()-> void:
	$FadeCanvas/AnimationPlayer.play("fade_in")
	
func fade_out()-> void:
	$FadeCanvas/AnimationPlayer.play_backwards("fade_in")
	
func _on_detecto_zona_recarga(en_zona : bool)->void:
	if en_zona:
		info_zona_recarga.mostrar_suavisado()
	else:
		info_zona_recarga.ocultar_suavisado()


func _on_cambio_numero_meteoritos(numero:int)-> void:
	info_meteoritos.mostrar_suavisado()
	info_meteoritos.modificar_texto("Meteoritos Restantes\n {cantidad}".format({"cantidad":numero}))


func _on_actualizar_info_tiempo(tiempo_restante:int)-> void:
 
#warning-ignore: narrowing_conversion
	var minutos: int = floor(tiempo_restante * 0.01666666666667)
	var segundos: int = tiempo_restante % 60
	info_tiempo_restante.modificar_texto("Tiempo Restante\n%02d:%02d" % [minutos, segundos])
	
	if tiempo_restante % 10 == 0:
		info_tiempo_restante.mostrar_suavisado()
	
	if  tiempo_restante == 11:
		info_tiempo_restante.set_auto_ocultar(false)
	elif tiempo_restante == 0:
		info_tiempo_restante.ocultar()