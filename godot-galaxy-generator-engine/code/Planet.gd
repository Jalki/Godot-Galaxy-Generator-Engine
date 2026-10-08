extends CelestialData
class_name Planet

@export_group("Planet Properties")
@export var atmosphere: bool
@export var atmosphere_density: float

@export var water_percentage: float
@export var volcanic_activity: float
@export var tectonic_activity: float

@export_group("Habitability")
@export var habitable: bool
@export var temperature: float


func generate() -> void:
	super.generate()

	generate_atmosphere()
	generate_geology()
	generate_minerals()


func generate_atmosphere() -> void:
	# Planet-specific generation
	pass


func generate_geology() -> void:
	# Planet-specific generation
	pass


func generate_minerals() -> void:
	minerals.generate_mineral_groups()
