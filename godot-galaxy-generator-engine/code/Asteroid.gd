extends CelestialData
class_name Asteroid

@export_group("Asteroid Properties")
@export var composition: float
@export var metallicity: float
@export var rotation_speed: float
@export var irregularity: float


func generate() -> void:
	super.generate()

	generate_minerals()


func generate_minerals() -> void:
	minerals.generate_mineral_groups()
