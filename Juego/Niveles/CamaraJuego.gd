class_name CamaraJuego

extends Camera2D


## Atributos
var zoom_original: Vector2
var puede_hacer_zoom:bool=  true setget set_puede_hacer_zoom

##variable Onready
onready var tween_zoom: Tween = $TweenZoom



##setters and getters
func set_puede_hacer_zoom(puede:bool)->void:
	puede_hacer_zoom = puede


##Metodos

func _ready()->void:
	zoom_original = zoom


		
## metodos customs

func devolver_zoom_original()->void:
	puede_hacer_zoom = false
	zoom_suavisado(zoom_original.x,zoom_original.y, 1.5 )




	
func zoom_suavisado(nuevo_zoom_x: float, nuevo_zoom_y: float, tiempo_transicion: float)-> void:
	tween_zoom.interpolate_property(self, "zoom", zoom, Vector2(nuevo_zoom_x, nuevo_zoom_y), tiempo_transicion, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_zoom.start()



