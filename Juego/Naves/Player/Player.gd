class_name Player
extends RigidBody2D

enum ESTADO { SPAWN, VIVO, INVENCIBLE, MUERTO }

export var potencia_motor: int = 20
export var potencia_rotacion: int = 280
export var estela_maxima: int = 150

var empuje: Vector2 = Vector2.ZERO
var dir_rotacion: int = 0
var estado_actual: int = ESTADO.SPAWN

onready var canion: Canion = $Canion
onready var laser: RayoLaser = $LaserBeam2D
onready var estela: Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx: Motor = $MotorSFX
onready var colisionador: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	controlador_estados(estado_actual)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(delta: float) -> void:
	player_input()
	print ("estare funcionando")

func esta_input_activo() -> bool:
	return estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]

func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return

	# Disparo de rayo
	if event is InputEventAction:
		if event.action == "disparo_secundario" and event.pressed:
			laser.set_is_casting(true)
		elif event.action == "disparo_secundario" and not event.pressed:
			laser.set_is_casting(false)

	# Control de estela y sonido de motor
	if event is InputEventAction:
		if event.action == "mover_adelante" and event.pressed:
			estela.set_max_points(estela_maxima)
			motor_sfx.sonido_on()
		elif event.action == "mover_adelante" and not event.pressed:
			estela.set_max_points(0)
			motor_sfx.sonido_off()

func controlador_estados(nuevo_estado: int) -> void:
	if estado_actual != nuevo_estado:
		estado_actual = nuevo_estado
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
				canion.set_deferred("puede_disparar", false)
				queue_free()
			_:
				printerr("Error de estado")

func player_input() -> void:
	if not esta_input_activo():
		return

	# Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje.x = potencia_motor
	elif Input.is_action_pressed("mover_atras"):
		empuje.x = -potencia_motor

	# Rotación
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
	if Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1

	# Disparo
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	elif Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
		print("¡Estoy disparando!")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		controlador_estados(ESTADO.VIVO)
