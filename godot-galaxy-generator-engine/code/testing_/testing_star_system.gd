extends Node

func _ready() -> void:
	var generator := StarSystemGenerator.new()
	add_child(generator)              # Node must be in the tree

	var system: StarSystem = generator.generate_system()
	# Pass a fixed seed while iterating:
	# var system: StarSystem = generator.generate_system(12345)

	print("Generated system: ", system.system_name)
	print("Stars: ", system.stars.size())
	print("Planets: ", system.planets.size())
	print("Asteroids: ", system.asteroids.size())
	print("Comets: ", system.comets.size())
