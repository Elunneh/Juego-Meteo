class_name BaseEnemiga

extends Node2D

##Atributo Export
export var hitpoints : float = 30.0
export var orbital : PackedScene = null

##Antributo Onready

onready var impacto_sfx: AudioStreamPlayer = $ImpactoSFX

#Atributos

var esta_destruida: bool = false

#Metodos

func _ready()-> void:
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
	var pos_spawn: Vector2 = deteccion_cuadrante()
	
	var new_orbital: EnemigoOrbital = orbital.instance()
#	
	new_orbital.crear(global_position + pos_spawn, self)
	
	Eventos.emit_signal("spawn_orbital", new_orbital)
	
func deteccion_cuadrante()-> Vector2:
	var player_objetivo: Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return Vector2.ZERO
		
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
	if abs(angulo_player)<= 45.0:
	#player entra a la derecha
		return $PosicionesSpawn/Este.position
		
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
	#player entra por la izquierda
		return $PosicionesSpawn/Oeste.position
	
	elif abs(angulo_player) > 45.0 and abs (angulo_player) <= 135.0:
	#player entra por abajo
		return $PosicionesSpawn/Sur.position
		
	else:
	#player entra por arriba
		return $PosicionesSpawn/Norte. position

## Señales internas

func _on_AreaColision_body_entered(body: Node)-> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered()->void:
	#Spawn Orbital
	$VisibilityNotifier2D.queue_free()
	spawnear_orbital()
	
#
	

