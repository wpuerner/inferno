class_name Modifier extends Node

@export var display_name: String

func activate():
	push_error("Nodes that inherit from Modifier must implement the activate() method")
