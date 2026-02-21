# AssetRegistry.gd — ALL asset paths by string key
extends Node

# All asset references as string keys
# Paths are relative to res://assets/kaykit/
# IMPORTANT: Some packs use .gltf+.bin (Medieval Hexagon, Resource Bits, Halloween,
# RPG Tools, Furniture, Forest Nature, City Builder, Dungeon). Others use .glb
# (Adventurers, Skeletons, Character Animations). Use the correct extension.

const MESHES: Dictionary = {
	# --- Terrain tiles (Medieval Hexagon Pack — .gltf) ---
	"tile_grass": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_grass.gltf",
	"tile_grass_bottom": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_grass_bottom.gltf",
	"tile_grass_sloped_low": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_grass_sloped_low.gltf",
	"tile_grass_sloped_high": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_grass_sloped_high.gltf",
	"tile_water": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_water.gltf",
	"tile_transition": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/base/hex_transition.gltf",
	"tile_road_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/roads/hex_road_A.gltf",
	"tile_road_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/roads/hex_road_B.gltf",
	"tile_road_C": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/roads/hex_road_C.gltf",
	"tile_coast_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/coast/hex_coast_A.gltf",
	"tile_coast_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/coast/hex_coast_B.gltf",
	"tile_river_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/tiles/rivers/hex_river_A.gltf",

	# --- Buildings, green = tier 1 (Medieval Hexagon Pack — .gltf) ---
	"building_lumbermill": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_lumbermill_green.gltf",
	"building_mine": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_mine_green.gltf",
	"building_workshop": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_workshop_green.gltf",
	"building_well": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_well_green.gltf",
	"building_blacksmith": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_blacksmith_green.gltf",
	"building_barracks": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_barracks_green.gltf",
	"building_archery": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_archeryrange_green.gltf",
	"building_church": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_church_green.gltf",
	"building_tavern": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_tavern_green.gltf",
	"building_market": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_market_green.gltf",
	"building_windmill": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_windmill_green.gltf",
	"building_great_hall": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_castle_green.gltf",
	"building_home_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_home_A_green.gltf",
	"building_home_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_home_B_green.gltf",
	"building_watchtower": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_watchtower_green.gltf",
	"building_watermill": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/buildings/green/building_watermill_green.gltf",

	# --- Adventurer units (Adventurers 2.0 — .glb) ---
	"unit_farmer": "KayKit Adventurers 2.0/Characters/gltf/Engineer.glb",
	"unit_lumberjack": "KayKit Adventurers 2.0/Characters/gltf/Barbarian.glb",
	"unit_miner": "KayKit Adventurers 2.0/Characters/gltf/Rogue.glb",
	"unit_knight": "KayKit Adventurers 2.0/Characters/gltf/Knight.glb",
	"unit_archer": "KayKit Adventurers 2.0/Characters/gltf/Ranger.glb",
	"unit_mage": "KayKit Adventurers 2.0/Characters/gltf/Mage.glb",

	# --- Skeleton units (Skeletons 1.1 — .glb) ---
	"unit_skeleton": "KayKit Skeletons 1.1/characters/gltf/Skeleton_Minion.glb",
	"unit_skeleton_soldier": "KayKit Skeletons 1.1/characters/gltf/Skeleton_Warrior.glb",
	"unit_skeleton_archer": "KayKit Skeletons 1.1/characters/gltf/Skeleton_Rogue.glb",
	"unit_skeleton_champ": "KayKit Skeletons 1.1/characters/gltf/Skeleton_Golem.glb",
	"unit_skeleton_king": "KayKit Skeletons 1.1/characters/gltf/Necromancer.glb",

	# --- Resource world props (Resource Bits 1.0 — .gltf) ---
	"resource_wood": "KayKit Resource Bits 1.0/Assets/gltf/Wood_Log_Stack.gltf",
	"resource_stone": "KayKit Resource Bits 1.0/Assets/gltf/Stone_Bricks_Stack_Small.gltf",
	"resource_iron": "KayKit Resource Bits 1.0/Assets/gltf/Iron_Bar.gltf",
	"resource_food": "KayKit Resource Bits 1.0/Assets/gltf/Food_Basket_A_Berries.gltf",
	"resource_gold": "KayKit Resource Bits 1.0/Assets/gltf/Money_Coins_Stack_Small.gltf",
	"resource_textiles": "KayKit Resource Bits 1.0/Assets/gltf/Textiles_Stack_Small.gltf",

	# --- Halloween props (Halloween Bits 1.0 — .gltf) ---
	"prop_gravestone": "KayKit Halloween Bits 1.0/Assets/gltf/gravestone.gltf",
	"prop_grave_A": "KayKit Halloween Bits 1.0/Assets/gltf/grave_A.gltf",
	"prop_grave_B": "KayKit Halloween Bits 1.0/Assets/gltf/grave_B.gltf",
	"prop_lantern": "KayKit Halloween Bits 1.0/Assets/gltf/pumpkin_orange_jackolantern.gltf",

	# --- Nature decorations (Medieval Hexagon Pack — .gltf) ---
	"decor_tree_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/tree_single_A.gltf",
	"decor_tree_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/tree_single_B.gltf",
	"decor_tree_A_cut": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/tree_single_A_cut.gltf",
	"decor_tree_B_cut": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/tree_single_B_cut.gltf",
	"decor_trees_A_large": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/trees_A_large.gltf",
	"decor_trees_A_medium": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/trees_A_medium.gltf",
	"decor_trees_A_small": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/trees_A_small.gltf",
	"decor_trees_B_large": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/trees_B_large.gltf",
	"decor_rock_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/rock_single_A.gltf",
	"decor_rock_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/rock_single_B.gltf",
	"decor_rock_C": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/rock_single_C.gltf",
	"decor_mountain_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/mountain_A.gltf",
	"decor_mountain_A_grass": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/mountain_A_grass.gltf",
	"decor_mountain_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/mountain_B.gltf",
	"decor_hills_A": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/hills_A.gltf",
	"decor_hills_A_trees": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/hills_A_trees.gltf",
	"decor_hills_B": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/hills_B.gltf",
	"decor_cloud_big": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/cloud_big.gltf",
	"decor_cloud_small": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/nature/cloud_small.gltf",

	# --- Decoration props (Medieval Hexagon Pack — .gltf) ---
	"prop_barrel": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/barrel.gltf",
	"prop_crate_big": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/crate_A_big.gltf",
	"prop_crate_small": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/crate_A_small.gltf",
	"prop_haybale": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/haybale.gltf",
	"prop_resource_lumber": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/resource_lumber.gltf",
	"prop_resource_stone": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/resource_stone.gltf",
	"prop_wheelbarrow": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/wheelbarrow.gltf",
	"prop_target": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/target.gltf",
	"prop_flag_green": "KayKit Medieval Hexagon Pack 1.0.1/Assets/gltf/decoration/props/flag_green.gltf",
}

static func mesh_path(key: String) -> String:
	assert(key in MESHES, "AssetRegistry: unknown key '%s'" % key)
	return "res://assets/kaykit/" + MESHES[key]

static func load_scene(key: String) -> PackedScene:
	# .gltf and .glb files both import as PackedScene in Godot 4
	return load(mesh_path(key))

static func instance_mesh(key: String) -> Node3D:
	# Convenience: load the scene and instantiate it as a Node3D
	var scene: PackedScene = load_scene(key)
	return scene.instantiate() as Node3D
