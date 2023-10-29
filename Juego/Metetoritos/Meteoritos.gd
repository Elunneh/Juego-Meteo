class_name Meteoritos
extends RigidBody2D

## Atributos Export

export var vel_lineal_base:Vector2 = Vector2 (300.0,300.0 )
export var vel_ang_base: float = 3.0
export var hitpoints_base: float = 10

##Atributo

var hitpoints:float
var esta_en_sector: bool = true setget set_esta_en_sector
var pos_spawn_original: Vector2
var vel_spawn_original: Vector2

##atributo Onready
onready var impacto_sfx: AudioStreamPlayer2D = $Impacto_sfx
onready var animacion_impacto: AnimationPlayer = $AnimationPlayer
## Metodos

func _integrate_forces(state: Physics2DDirectBodyState)->void:
	if esta_en_sector:
		return
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_en_sector = true

func _ready()-> void:
	
	angular_velocity = vel_ang_base


##setters y getters
func set_esta_en_sector(valor: bool)->void:
	esta_en_sector = valor

##constructor

func crear(pos: Vector2, dir: Vector2, tamanio: float)-> void:
	position = pos
	pos_spawn_original = position
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	##radio = diametro/2
	var radio:int = int($Sprite.texture.get_size().x/2.3* tamanio)
	var forma_colision: CircleShape2D = CircleShape2D.new()
	forma_colision. radius = radio
	$CollisionShape2D.shape = forma_colision
	
##calcular velocidades

	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad()
	vel_spawn_original = linear_velocity
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
	
##Calcular Hitpoints

	hitpoints = hitpoints_base * tamanio
	print("hitpoints:", hitpoints )
##Metodo Custom

func aleatorizar_velocidad()-> float:
	randomize()
	return rand_range(1.1, 1.4)


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
		
		
	
