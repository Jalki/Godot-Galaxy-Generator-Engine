extends Resource
class_name CelestialBody

@export_group("Identity")
@export var body_name: String = ""
@export var body_id: int = 0

@export_group("Data")
@export var data: CelestialData

@export_group("Generated Properties")
@export var age: float = 0.0
@export var size: float = 0.0

@export_group("Orbit")
@export var orbital_distance: float = 0.0
@export var orbital_period: float = 0.0
@export var eccentricity: float = 0.0

@export_group("Children")
@export var moons: Array[CelestialBody] = []


func print_details(indent: int = 0) -> void:
	var prefix := " ".repeat(indent)

	print(prefix + "--------------------------------")
	print(prefix + "Name: ", body_name)
	print(prefix + "ID: ", body_id)

	if data == null:
		push_error("CelestialBody '%s' has no CelestialData!" % body_name)
		return

	print(prefix + "Type: ", data.get_class())
	print(prefix + "Size: ", size)
	print(prefix + "Age: ", age)

	if orbital_distance > 0:
		print(prefix + "Orbital Distance: %.3f AU" % orbital_distance)
		print(prefix + "Orbital Period: %.3f years" % orbital_period)
		print(prefix + "Eccentricity: %.3f" % eccentricity)

	if moons.size() > 0:
		print(prefix + "Moons: ", moons.size())

		for moon in moons:
			moon.print_details(indent + 4)

	print(prefix + "--------------------------------")
