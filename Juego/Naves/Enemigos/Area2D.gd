class_name AreaColision
extends Area2D

func recibir_danio(danio: float):
	owner.recibir_danio(danio)
	queue_free()
	print ("hago danio")

