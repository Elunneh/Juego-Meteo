class_name SectorMeteoritos
extends Node2D

#Atributos Export
export var cantidad_meteoritos: int = 10

#Atributos
var spawners:Array

##Metodos
func _ready()-> void:
	almacenar_spawners()
	conectar_seniales_detectores()
	
	
#Metodos Customs

func conectar_seniales_detectores()-> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered",self,"_on_detector_body_entered" )



func almacenar_spawners()-> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)
		
func spawner_aleatorio() -> int:
	randomize()
	return randi() % spawners.size()







## Señales internas

func _on_SpawnTimer_timeout()->void:
	if cantidad_meteoritos == 0:
		$SpawnTimer.stop()
		return
		
	spawners[spawner_aleatorio()].spawnear_meteoritos()
	cantidad_meteoritos -=1
	
		
		


func _on_DetectorIzquierda_body_entered(body: Node)->void:
	body.set_esta_en_sector(false)


func _on_DetectorDerecho_body_entered(body: Node)-> void:
	body.set_esta_en_sector(false)


func _on_DetectorSuperior_body_entered(body: Node)-> void:
	body.set_esta_en_sector(false)


func _on_DetectorInferior_body_entered(body)-> void:
	body.set_esta_en_sector(false)
