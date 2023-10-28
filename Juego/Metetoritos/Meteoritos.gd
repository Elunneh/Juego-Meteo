class_name Meteoritos
extends RigidBody2D

## Atributos Export

export var vel_lineal_base:Vector2 = Vector2 (300.0,300.0 )
export var vel_ang_base: float = 3.0

## Metodos

func _ready()-> void:
	linear_velocity = vel_lineal_base
	angular_velocity = vel_ang_base

##constructor

func crear(pos: Vector2, dir: Vector2)-> void:
	position = pos
	linear_velocity = vel_lineal_base * dir
