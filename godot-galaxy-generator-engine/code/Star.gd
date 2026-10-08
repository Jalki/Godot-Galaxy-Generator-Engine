extends CelestialData
class_name Star

enum StarClass {
	RED_DWARF,
	ORANGE_DWARF,
	YELLOW_DWARF,
	BLUE_GIANT,
	RED_GIANT,
	WHITE_DWARF,
	NEUTRON_STAR
}

@export_group("Star Properties")
@export var star_class: StarClass

@export var luminosity: float
@export var temperature: float
@export var metallicity: float

@export_group("Stellar Evolution")
@export var mass: float
@export var lifespan: float


func generate() -> void:
	super.generate()

	generate_stellar_properties()


func generate_stellar_properties() -> void:
	pass
