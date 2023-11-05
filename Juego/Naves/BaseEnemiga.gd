class_name BaseEnemiga

extends Node2D

##Atributo Export
export var hitpoints : float = 30.0
export var orbital : PackedScene = null
export var numero_orbitales: int= 10
export var intervalo_spawn: float = 0.8

##Antributo Onready

onready var impacto_sfx: AudioStreamPlayer = $ImpactoSFX
onready var timer_spawner: Timer = $TimerSpawnerEnemigo

#Atributos

var esta_destruida: bool = false
var posicion_spawn: Vector2 = Vector2.ZERO
#Metodos

func _ready()-> void:
	timer_spawner.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	

	
#Metodos Customs
	
func elegir_animacion_aleatoria()-> String:
	randomize()
	var num_anim : int = $AnimationPlayer.get_animation_list().size()-1
	var indice_anim_aleatoria: int = randi()% num_anim + 1
	var lista_animacion: Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func recibir_danio(danio: float)-> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
	impacto_sfx.play()

func destruir()-> void:
	var posicion_partes = [$Sprites/SpriteA.global_position, $Sprites/SpriteB.global_position, $Sprites/SpriteC.global_position, $Sprites/SpriteD.global_position]

	Eventos.emit_signal("base_destruida", self,  posicion_partes)
	queue_free()

func spawnear_orbital()->void:
	numero_orbitales -= 1
	var pos_spawn: Vector2 = deteccion_cuadrante()
	$RutaEnemiga.global_position = global_position
	
	var new_orbital: EnemigoOrbital = orbital.instance()
#	
	new_orbital.crear(global_position + pos_spawn, self, $RutaEnemiga)
	
	Eventos.emit_signal("spawn_orbital", new_orbital)
	
func deteccion_cuadrante()-> Vector2:
	var player_objetivo: Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return Vector2.ZERO
		
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
	if abs(angulo_player)<= 45.0:
	#player entra a la derecha
		$RutaEnemiga.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
		
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
	#player entra por la izquierda
		$RutaEnemiga.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	
	elif abs(angulo_player) > 45.0 and abs (angulo_player) <= 135.0:
	#player entra por abajo
		if sign(angulo_player) > 0:
			$RutaEnemiga.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		
	else:
	#player entra por arriba
		$RutaEnemiga.rotation_degrees = 90.0
		return $PosicionesSpawn/Norte. position
	return$PosicionesSpawn/Norte.position

## Señales internas

func _on_AreaColision_body_entered(body: Node)-> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered()->void:
	#Spawn Orbital
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawnear_orbital()
	timer_spawner.start()
	
#
	



func _on_TimerSpawnerEnemigo_timeout():
	if numero_orbitales == 0:
		timer_spawner.stop()
		return
	spawnear_orbital()
		
