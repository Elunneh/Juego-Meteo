class_name Meteoritos
extends RigidBody2D

## Atributos Export

export var vel_lineal_base:Vector2 = Vector2 (300.0,300.0 )
export var vel_ang_base: float = 3.0
export var hitpoints_base: float = 10

##Atributo

var hitpoints:float

##atributo Onready
onready var impacto_sfx: AudioStreamPlayer2D = $Impacto_sfx
onready var animacion_impacto: AnimationPlayer = $AnimationPlayer
## Metodos

func _ready()-> void:
	
	angular_velocity = vel_ang_base

##constructor

func crear(pos: Vector2, dir: Vector2, tamanio: float)-> void:
	position = pos
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	##radio = diametro/2
	var radio:int = int($Sprite.texture.get_size().x/2.3* tamanio)
	var forma_colision: CircleShape2D = CircleShape2D.new()
	forma_colision. radius = radio
	$CollisionShape2D.shape = forma_colision
	
##calcular velocidades

	linear_velocity = vel_lineal_base * dir / tamanio
	angular_velocity = vel_ang_base / tamanio
	
##Calcular Hitpoints

	hitpoints = hitpoints_base * tamanio
	print("hitpoints:", hitpoints )
##Metodo Custom
func recibir_danio(danio: float)-> void:
	hitpoints -= danio
	if hitpoints <= 0:
		destruir()
	impacto_sfx.play()
	animacion_impacto.play("Impacto")
	
func destruir()-> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()
		
		
	
