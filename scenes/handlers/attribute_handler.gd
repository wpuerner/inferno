extends Node

@export var attributes: Array[Attribute]

func reset():
	for attribute in attributes:
		attribute.reset()
