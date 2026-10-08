extends Resource
class_name CelestialData

@export_group("Size")
@export var min_size: float
@export var max_size: float

enum CelestialBodyType {
	STAR,
	PLANET,
	MOON,
	ASTEROID,
	COMET,
	BLACKHOLE
}

@export_group("General")
@export var body: CelestialBodyType

@export_group("Minerals")
@export var minerals: MineralData


func generate() -> void:
	pass
