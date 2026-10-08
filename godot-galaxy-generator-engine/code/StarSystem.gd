extends Resource
class_name StarSystem

@export_group("System")
@export var system_name: String = ""
@export var seed: int = 0

@export_group("Celestial Bodies")
@export var stars: Array[CelestialBody] = []
@export var planets: Array[CelestialBody] = []
@export var asteroids: Array[CelestialBody] = []
@export var comets: Array[CelestialBody] = []


func print_details() -> void:
	print("")
	print("========================================")
	print("STAR SYSTEM: ", system_name)
	print("SEED: ", seed)
	print("========================================")

	print("")
	print("STARS: ", stars.size())

	for star in stars:
		star.print_details(2)

	print("")
	print("PLANETS: ", planets.size())

	for planet in planets:
		planet.print_details(2)

	print("")
	print("ASTEROIDS: ", asteroids.size())

	for asteroid in asteroids:
		asteroid.print_details(2)

	print("")
	print("COMETS: ", comets.size())

	for comet in comets:
		comet.print_details(2)

	print("")
	print("========================================")
	print("END STAR SYSTEM")
	print("========================================")
