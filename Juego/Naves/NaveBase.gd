##NaveBase.gd
class_name NaveBase
extends RigidBody2D

##Enums
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}

##Atributos Export
export var hitpoints: float = 20.0
export var numero_explosiones: float = 20
##Atributos
var estado_actual:int = ESTADO.SPAWN

##Atributos Onready
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_sfx: AudioStreamPlayer = $ImpactoSFX
onready var canion:Canion = $Canion
onready var barra_salud : BarraSalud = $BarraSalud
## Metodos
func _ready()-> void:
	barra_salud.set_valores(hitpoints) ## lo agregue
	barra_salud.max_value = hitpoints
	barra_salud.value = hitpoints
	
	controlador_estados(estado_actual)

## Metodos Custom

func controlador_estados(nuevo_estado: int)-> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position, 3)
			queue_free()
		_:
			printerr("Error de Estado")
	estado_actual = nuevo_estado

## Destruccion
func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	Eventos.emit_signal("nave_destruida", self, global_position, 3)
	queue_free()


func recibir_danio(danio:float)-> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
		impacto_sfx.play() 
	barra_salud.controlar_barra(hitpoints, true)
		
		
		
		

##Señales internas

func _on_AnimationPlayer_animation_finished(anim_name: String)-> void:
	if anim_name == "Spawn":
		controlador_estados(ESTADO.VIVO)

func _on_body_entered(body: Node)-> void:
	if body is Meteoritos:
		body.destruir()
		destruir()
