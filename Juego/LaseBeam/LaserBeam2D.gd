class_name RayoLaser
extends RayCast2D


export var cast_speed : float = 7000.0

export var max_length : float = 1400.0

export var growth_time : float = 0.1

export var radio_danio: float = 4.0
export var energia: float = 4.0
export var radio_desgaste: float = -1.0



var is_casting : bool = false setget set_is_casting
var energia_original: float

onready var fill : Line2D = $FillLine2D
onready var tween : Tween = $Tween
onready var casting_particles : Particles2D = $CastingParticles2D
onready var collision_particles : Particles2D = $CollisionParticles2D
onready var beam_particles : Particles2D = $BeamParticles2D
onready var laser_sfx: AudioStreamPlayer2D = $LaserSFX

onready var line_width : float = fill.width

func _ready() -> void:
	energia_original = energia
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam(delta)

func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		laser_sfx.play()
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		
		laser_sfx.stop()

		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting


func cast_beam(delta: float) -> void:
	if is_casting:
		if energia <= 0.0:
			print("SIN ENERGIA")
			set_is_casting(false)
			return
		controlar_energia (radio_desgaste * delta)
		
	
	var cast_point : Vector2 = cast_to
	

	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		if get_collider().has_method("recibir_danio"):
			get_collider().recibir_danio(radio_danio * delta )
		

	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
func controlar_energia(consumo: float)-> void:
	energia += consumo
	if energia >  energia_original:
		energia = energia_original
	print("Energia Laser: ",energia )

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
