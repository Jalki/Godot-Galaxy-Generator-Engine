extends Resource
class_name MineralData

#Each planet generates some type of mineral data upon generation or editing in the real-time editor!

@export var max : int
@export var min : int
@export var rarity : float

@export var Minerals: Array[ElementalGroup] = []

func _init():
	generate_mineral_groups()

func generate_mineral_groups():
	Minerals.clear()
	
	for preset in ElementalGroupDatabase.GROUPS:
		var group := preset.duplicate(true) as ElementalGroup
		Minerals.append(group)
