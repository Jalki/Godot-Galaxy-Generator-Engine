extends Node
class_name StarSystemGenerator


# ============================================================
# CONFIGURATION
# ============================================================

@export_group("System Generation")

@export var min_planets: int = 1
@export var max_planets: int = 10

@export var min_moons: int = 0
@export var max_moons: int = 5

@export var min_asteroids: int = 10
@export var max_asteroids: int = 100

@export_group("Orbital Generation")

@export var min_orbit: float = 0.25
@export var max_orbit: float = 30.0

@export_group("Debug")

@export var print_generation: bool = true
@export var print_minerals: bool = true


var rng := RandomNumberGenerator.new()

var current_system: StarSystem


# ============================================================
# PUBLIC ENTRY POINT
# ============================================================

func generate_system(system_seed: int = -1) -> StarSystem:

	print("")
	print("########################################")
	print("# STAR SYSTEM GENERATION START")
	print("########################################")

	# --------------------------------------------------------
	# Seed
	# --------------------------------------------------------

	if system_seed == -1:
		system_seed = randi()

	rng.seed = system_seed

	print("Seed: ", system_seed)

	# --------------------------------------------------------
	# Create system
	# --------------------------------------------------------

	current_system = StarSystem.new()

	current_system.seed = system_seed
	current_system.system_name = "System_%s" % system_seed

	# --------------------------------------------------------
	# Generate components
	# --------------------------------------------------------

	generate_stars()
	generate_planets()
	generate_asteroids()
	generate_comets()

	# --------------------------------------------------------
	# Print final system
	# --------------------------------------------------------

	if print_generation:
		current_system.print_details()

	print("")
	print("########################################")
	print("# STAR SYSTEM GENERATION COMPLETE")
	print("########################################")

	return current_system


# ============================================================
# STARS
# ============================================================

func generate_stars() -> void:

	print("")
	print("[STAR GENERATION]")

	# Current implementation = single-star system.
	# You can expand this to binary/trinary systems later.

	var star := CelestialBody.new()

	star.body_id = 0
	star.body_name = "Primary Star"

	var star_data := Star.new()

	# Random stellar properties
	star_data.star_class = Star.StarClass.values()[
		rng.randi_range(
			0,
			Star.StarClass.values().size() - 1
		)
	]

	star_data.mass = rng.randf_range(0.1, 3.0)
	star_data.temperature = rng.randf_range(2500.0, 15000.0)
	star_data.luminosity = rng.randf_range(0.01, 100.0)

	star.data = star_data

	star.size = rng.randf_range(
		star_data.min_size,
		star_data.max_size
	) if star_data.max_size > star_data.min_size else rng.randf_range(1.0, 10.0)

	star.age = rng.randf_range(
		0.1,
		10.0
	)

	current_system.stars.append(star)

	print("Generated star: ", star.body_name)
	print("  Class: ", star_data.star_class)
	print("  Mass: %.2f solar masses" % star_data.mass)
	print("  Temperature: %.2f K" % star_data.temperature)
	print("  Luminosity: %.2f solar" % star_data.luminosity)


# ============================================================
# PLANETS
# ============================================================

func generate_planets() -> void:

	print("")
	print("[PLANET GENERATION]")

	if current_system.stars.is_empty():
		push_error(
			"Cannot generate planets because the star system has no stars."
		)
		return

	var planet_count := rng.randi_range(
		min_planets,
		max_planets
	)

	print("Planet count: ", planet_count)

	for i in range(planet_count):

		var planet := generate_planet(i)

		if planet == null:
			push_error(
				"Failed to generate planet index %d." % i
			)
			continue

		current_system.planets.append(planet)


# ============================================================
# INDIVIDUAL PLANET
# ============================================================

func generate_planet(index: int) -> CelestialBody:

	var body := CelestialBody.new()

	body.body_id = 1000 + index
	body.body_name = "Planet_%02d" % (index + 1)

	var planet := Planet.new()

	# --------------------------------------------------------
	# Orbital position
	# --------------------------------------------------------

	body.orbital_distance = calculate_planet_orbit(index)

	body.orbital_period = sqrt(
		pow(body.orbital_distance, 3)
	)

	body.eccentricity = rng.randf_range(
		0.0,
		0.15
	)

	# --------------------------------------------------------
	# Planet properties
	# --------------------------------------------------------

	planet.water_percentage = rng.randf_range(
		0.0,
		100.0
	)

	planet.volcanic_activity = rng.randf_range(
		0.0,
		1.0
	)

	planet.tectonic_activity = rng.randf_range(
		0.0,
		1.0
	)

	planet.temperature = calculate_planet_temperature(
		body.orbital_distance
	)

	planet.atmosphere = rng.randf() > 0.2

	planet.atmosphere_density = rng.randf_range(
		0.0,
		10.0
	)

	# --------------------------------------------------------
	# Determine habitability
	# --------------------------------------------------------

	planet.habitable = determine_habitability(
		planet
	)

	# --------------------------------------------------------
	# Size
	# --------------------------------------------------------

	body.size = rng.randf_range(
		0.5,
		2.5
	)

	body.age = rng.randf_range(
		0.1,
		10.0
	)

	body.data = planet

	# --------------------------------------------------------
	# Minerals
	# --------------------------------------------------------

	if planet.minerals == null:
		planet.minerals = MineralData.new()

	planet.minerals.generate_mineral_groups()

	apply_planet_mineral_modifiers(
		planet
	)

	# --------------------------------------------------------
	# Moons
	# --------------------------------------------------------

	generate_moons(
		body,
		index
	)

	# --------------------------------------------------------
	# Debug
	# --------------------------------------------------------

	if print_generation:
		print("")
		print("Generated ", body.body_name)
		print("  Orbit: %.3f AU" % body.orbital_distance)
		print("  Period: %.3f years" % body.orbital_period)
		print("  Temperature: %.2f K" % planet.temperature)
		print("  Water: %.2f%%" % planet.water_percentage)
		print("  Volcanism: %.2f" % planet.volcanic_activity)
		print("  Tectonics: %.2f" % planet.tectonic_activity)
		print("  Atmosphere: ", planet.atmosphere)
		print("  Habitable: ", planet.habitable)
		print("  Moons: ", body.moons.size())

	return body


# ============================================================
# PLANET ORBITS
# ============================================================

func calculate_planet_orbit(index: int) -> float:

	var spacing: float = (
		max_orbit - min_orbit
	) / float(maxi(1, max_planets))

	var base_orbit: float = (
		min_orbit +
		spacing * index
	)

	var variation := rng.randf_range(
		-spacing * 0.25,
		spacing * 0.25
	)

	return maxf(
		0.1,
		base_orbit + variation
	)


# ============================================================
# TEMPERATURE
# ============================================================

func calculate_planet_temperature(
	distance: float
) -> float:

	if current_system.stars.is_empty():
		push_error(
			"Cannot calculate planet temperature without a star."
		)
		return 0.0

	var star := current_system.stars[0]
	var star_data := star.data as Star

	if star_data == null:
		push_error(
			"Primary star does not contain Star data."
		)
		return 0.0

	# Simplified inverse-square approximation.
	var temperature := (
		star_data.temperature /
		sqrt(max(distance, 0.1))
	)

	return temperature


# ============================================================
# HABITABILITY
# ============================================================

func determine_habitability(
	planet: Planet
) -> bool:

	if not planet.atmosphere:
		return false

	if planet.temperature < 240.0:
		return false

	if planet.temperature > 330.0:
		return false

	if planet.water_percentage < 5.0:
		return false

	if planet.water_percentage > 95.0:
		return false

	if planet.volcanic_activity > 0.95:
		return false

	return true


# ============================================================
# MINERALS
# ============================================================

func apply_planet_mineral_modifiers(
	planet: Planet
) -> void:

	if planet.minerals == null:
		push_error(
			"Planet has no MineralData."
		)
		return

	if planet.minerals.Minerals.is_empty():
		push_error(
			"Planet MineralData contains no elemental groups."
		)
		return

	for group in planet.minerals.Minerals:

		if group == null:
			push_error(
				"Planet contains a null elemental group."
			)
			continue

		# Base generation
		group.Amt = rng.randi_range(
			planet.minerals.min,
			max(
				planet.minerals.min,
				planet.minerals.max
			)
		)

		# Example volcanic modifier.
		# Replace GroupID == 8 with however your
		# actual IronGroup is identified.
		if group.GroupID == 8:
			group.Amt = int(
				group.Amt *
				lerp(
					1.0,
					3.0,
					planet.volcanic_activity
				)
			)

		if print_minerals:
			print(
				"    Mineral: %s | Amount: %d | Rarity: %.3f"
				% [
					group.GroupName,
					group.Amt,
					group.BaseRarity
				]
			)


# ============================================================
# MOONS
# ============================================================

func generate_moons(
	planet: CelestialBody,
	planet_index: int
) -> void:

	var moon_count := rng.randi_range(
		min_moons,
		max_moons
	)

	# Small planets have fewer moons.
	if planet.size < 1.0:
		moon_count = min(
			moon_count,
			1
		)

	for i in range(moon_count):

		var moon := generate_moon(
			planet,
			planet_index,
			i
		)

		if moon == null:
			push_error(
				"Failed to generate moon %d for %s."
				% [i, planet.body_name]
			)
			continue

		planet.moons.append(moon)


# ============================================================
# INDIVIDUAL MOON
# ============================================================

func generate_moon(
	parent: CelestialBody,
	planet_index: int,
	moon_index: int
) -> CelestialBody:

	var body := CelestialBody.new()

	body.body_id = (
		2000 +
		planet_index * 100 +
		moon_index
	)

	body.body_name = "%s-Moon_%02d" % [
		parent.body_name,
		moon_index + 1
	]

	var moon := Moon.new()

	moon.orbital_distance = rng.randf_range(
		0.001,
		0.05
	)

	moon.tidal_activity = rng.randf_range(
		0.0,
		1.0
	)

	body.size = rng.randf_range(
		0.05,
		0.5
	)

	body.age = parent.age

	body.orbital_distance = moon.orbital_distance

	body.data = moon

	if print_generation:
		print(
			"    Generated moon: %s"
			% body.body_name
		)

	return body


# ============================================================
# ASTEROIDS
# ============================================================

func generate_asteroids() -> void:

	print("")
	print("[ASTEROID GENERATION]")

	var asteroid_count := rng.randi_range(
		min_asteroids,
		max_asteroids
	)

	print("Asteroid count: ", asteroid_count)

	for i in range(asteroid_count):

		var asteroid := CelestialBody.new()

		asteroid.body_id = 3000 + i
		asteroid.body_name = "Asteroid_%04d" % (i + 1)

		var asteroid_data := Asteroid.new()

		asteroid_data.composition = rng.randf()
		asteroid_data.metallicity = rng.randf()
		asteroid_data.rotation_speed = rng.randf_range(
			0.01,
			10.0
		)

		asteroid.size = rng.randf_range(
			0.001,
			0.1
		)

		asteroid.age = rng.randf_range(
			0.1,
			10.0
		)

		asteroid.data = asteroid_data

		current_system.asteroids.append(
			asteroid
		)


# ============================================================
# COMETS
# ============================================================

func generate_comets() -> void:

	print("")
	print("[COMET GENERATION]")

	var comet_count := rng.randi_range(
		0,
		10
	)

	for i in range(comet_count):

		var comet := CelestialBody.new()

		comet.body_id = 4000 + i
		comet.body_name = "Comet_%03d" % (i + 1)

		var comet_data := Comet.new()

		comet.size = rng.randf_range(
			0.001,
			0.05
		)

		comet.age = rng.randf_range(
			0.1,
			10.0
		)

		comet.data = comet_data

		current_system.comets.append(
			comet
		)
