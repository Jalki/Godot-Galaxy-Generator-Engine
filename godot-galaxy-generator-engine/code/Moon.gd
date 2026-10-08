extends CelestialData
class_name Moon

@export_group("Moon Properties")
@export var tidal_activity: float
@export var parent_planet_mass: float
@export var orbital_distance: float


func generate() -> void:
	super.generate()

	generate_geology()
	generate_minerals()


func generate_geology() -> void:
	pass


func generate_minerals() -> void:
	minerals.generate_mineral_groups()
