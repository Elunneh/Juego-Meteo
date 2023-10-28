class_name MeteoritosSpawner
extends Position2D

## Atributos Export

export var direccion: Vector2 = Vector2(1,1)

##Metodos

func _ready()-> void:
	yield(owner, "ready")
	spawnear_meteoritos()
	
	
func spawnear_meteoritos()-> void:
	Eventos.emit_signal("spawn_meteoritos", global_position, direccion )
