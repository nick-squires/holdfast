# Holdfast — Complete Game Development Reference
### Hex-Based Medieval Settlement Survival | Godot 4 | KayKit Assets | Claude Code

---

## Table of Contents

1. [Game Design — Full Loop & Mechanics](#1-game-design)
2. [Architecture — Full Codebase Structure](#2-architecture)
3. [Asset Mapping — KayKit Files to Systems](#3-asset-mapping)
4. [CLAUDE.md — Project Instructions for Claude Code](#4-claudemd)
5. [Agent Prompt Library — Milestone by Milestone](#5-agent-prompt-library)

---

# 1. Game Design

## Core Fantasy

You are a medieval lord who arrived at an untamed hex landscape with a handful of adventurers and a small pile of supplies. By day, you build, gather, and grow. By night, the dead rise and walk toward your settlement. You must survive long enough to complete your Great Hall — the win condition.

The loop is inherently tense because **everything you build during the day becomes a liability at night**. Lumbermills near the forest edge are exposed. Mines on the outer ring are the first things skeletons pass. You are constantly balancing economic reach against defensive depth.

---

## The Day/Night Cycle (Detailed)

The game runs in **days**, each day split into four phases:

### ☀️ DAY (90 seconds)
The "city builder" phase. Full player agency.
- Buildings generate resources on a tick (every 5s, 18 ticks/day)
- Players place new buildings, assign workers, hire from tavern
- Adventurers animate working inside their assigned buildings
- Camera is free-roam, all UI is accessible
- A countdown timer and the day number are prominent in HUD
- Resource nodes (trees, ore veins, stone outcrops) visually shrink as they're harvested — when depleted they leave a stump/hole prop

### 🌅 DUSK (12 seconds)
The "prepare" phase. Soft time pressure.
- Building placement locks (can no longer place or assign)
- Gravestones from Halloween Bits rise with a tween on the 3 outermost hex rings
- Directional light begins shifting from warm orange to cold blue-grey
- A "Night approaches" banner slides in via WaveAnnouncer
- Skeletons are not yet visible but their count for this wave is revealed ("3 skeletons approaching...")
- Any unassigned adventurers auto-assign to the nearest barracks/archery range
- Audio: wind picks up, ambient birdsong fades

### 🌙 NIGHT (variable — ends when last skeleton dies OR settlement falls)
The "survival" phase. Mostly passive for the player.
- Skeletons spawn on the outermost ring and pathfind toward settlement center
- Adventurers leave their buildings and take up defensive positions
- Players can still click buildings to check status but cannot place or hire
- Barracks units patrol adjacent tiles; archery range units attack at range
- Skeletons prioritize the closest building, not always the center — this means outer buildings act as "buffers"
- If a skeleton reaches a building, that building takes damage. At 0 HP it collapses (mesh swapped to ruin variant) and its worker is killed
- Player watches, cheers, and counts losses
- Mini-map highlights active skeleton positions with a red glow

### 🌄 DAWN (10 seconds)
The "recover" phase.
- Last skeleton dies → DAWN triggers
- Gravestones sink back into the ground
- Ruined buildings show a "repair?" prompt (costs resources)
- Dead adventurers are counted; a summary card shows kills/losses
- Light warms back to morning tone
- Day number increments, DAY phase begins

---

## Resource Economy

Six resources, each backed by a specific KayKit Resource Bits model displayed on the tile and in the HUD:

| Resource | Source | Used For | KayKit Model |
|---|---|---|---|
| **Wood** | Lumbermill (adjacent to forest tile) | Most buildings, repairs | `log_stack.glb` |
| **Stone** | Mine (adjacent to mountain tile) | Advanced buildings, walls | `stone_pile.glb` |
| **Iron** | Mine (mountain tile, unlocked day 3) | Weapons, barracks upgrade | `iron_ingot.glb` |
| **Food** | Farm (grass tile, requires well nearby) | Adventurer upkeep per night | `food_basket.glb` |
| **Gold** | Market + Tavern income | Hiring adventurers, merchants | `gold_coins.glb` |
| **Textiles** | Windmill → Weaver (chain building) | Unlocking Series 4/5 merchants | `textile_bolt.glb` |

**Upkeep mechanic:** Each adventurer costs 1 Food/night. If food drops to 0, adventurers don't die — they fight at 50% effectiveness and complain (audio bark). This creates a soft ceiling on army size without hard-punishing the player.

---

## Buildings Reference

All from **Medieval Hexagon Pack**. Buildings come in 4 color variants (blue/red/green/yellow) — used in Holdfast for **upgrade tiers** (green=basic, blue=upgraded, red=fortified, yellow=legendary).

| Building | Terrain Req | Cost | Output | Special |
|---|---|---|---|---|
| **Lumbermill** | Adjacent to forest | 40w | 30 wood/day | Workers animate inside |
| **Mine** | On/adjacent to mountain | 60w 20s | 20 stone/day, 10 iron/day | Unlocks iron on day 3 |
| **Farm** | Grass, near well | 30w | 20 food/day | Requires well within 2 hexes |
| **Well** | Grass | 20w 10s | Enables farms | Passive |
| **Blacksmith** | Any | 50w 30s 10i | Unlocks weapon upgrades | Menu building |
| **Barracks** | Any | 60w 30s 10i | +2 melee defenders/night | Workers become knights at night |
| **Archery Range** | Any | 50w 20s | +2 ranged defenders/night | 3-tile attack range |
| **Church** | Any | 80w 40s | +5 settlement max HP | Passive; holy aura slows skeletons 1 tile radius |
| **Tavern** | Any | 60w 20g | +gold/day, hire menu | Series 4/5 merchants visit |
| **Market** | Near road tile | 40w 20s | +15 gold/day | Road adjacency bonus |
| **Windmill** | Open grass (no adj buildings) | 50w | Enables weaver | Visual rotating blades |
| **Great Hall** | Center tile only | 200w 100s 50i 50g | **WIN CONDITION** | Unlocks on day 7, takes 3 days to build |

---

## Unit Roster

### Adventurers (Character Pack Adventurers)
Each costs gold to hire at the Tavern. They work in buildings by day and fight by night.

| Unit | Cost | HP | DMG | Special |
|---|---|---|---|---|
| **Farmer** | 20g | 40 | 5 | +20% food output when assigned to farm |
| **Lumberjack** | 25g | 50 | 8 | +25% wood output at lumbermill |
| **Miner** | 30g | 60 | 8 | +25% stone/iron output |
| **Knight** | 60g | 120 | 20 | Melee, patrols 2 tiles |
| **Archer** | 50g | 70 | 15 | Ranged 3 tiles, stays at tower |
| **Mage** | 80g | 60 | 30 | AoE 2-tile radius, slow cooldown |

### Skeletons (Character Pack Skeletons)
Scale in type and count per wave.

| Type | Appears | HP | DMG | Special |
|---|---|---|---|---|
| **Skeleton Basic** | Night 1+ | 30 | 8 | Pathfinds to center |
| **Skeleton Soldier** | Night 3+ | 60 | 15 | Targets barracks first |
| **Skeleton Archer** | Night 5+ | 40 | 12 | Hangs back, ranged |
| **Skeleton Champion** | Night 7+ | 150 | 30 | Breaks building in 2 hits |
| **Skeleton King** | Siege Night | 500 | 50 | Boss, spawns 3 basics on death |

---

## Progression Arc (10 Nights)

| Night | Skeletons | New Mechanic Introduced |
|---|---|---|
| 1 | 4 basic | Tutorial: place lumbermill + barracks |
| 2 | 7 basic | Food upkeep introduced, farm unlocked |
| 3 | 10 basic + 2 soldier | Iron unlocked, blacksmith available |
| 4 | 12 mixed | Merchant visits (Series 4 character) |
| 5 | 15 mixed + 2 archer | Archery range available |
| 6 | 18 mixed | Second merchant visit, textiles introduced |
| 7 | 22 mixed | Great Hall construction unlocks |
| 8 | 25 mixed + 1 champion | Great Hall is under threat |
| 9 | 30 mixed + 2 champions | Skeletons prioritize Great Hall |
| 10 (SIEGE) | 50 all types + Skeleton King | Final boss wave |

**Win:** Great Hall construction completes (requires 3 full days uninterrupted).
**Loss:** Settlement HP reaches 0 (starts at 100, each skeleton reaching center = -10, building destruction = -5).

---

## Merchant System (Series 4 & 5 Characters)

On nights 4 and 6, a traveling merchant appears at a random road-adjacent hex during the day phase. They're a Series 4 or 5 character model with a floating shop icon. Clicking opens a trade menu:

- Offer 1: Trade excess resources (e.g., "30 wood → 20 gold")
- Offer 2: Buy a rare unit (e.g., a Mage you can't otherwise get)
- Offer 3: Buy a relic (passive buff, uses RPG Tools Bits icons)

Relics persist for the run and are shown in a small relic bar in the HUD. Examples:
- **Iron Shod Boots** — all knight movement +1 tile
- **Blessed Candle** — church aura radius +1
- **Mason's Hammer** — building repair costs -30%

---

# 2. Architecture

## Godot 4 Project Structure

```
holdfast/
├── CLAUDE.md                          ← Claude Code reads this first, every session
├── project.godot
├── autoloads/
│   ├── GameState.gd                   ← day number, phase, settlement HP, run flags
│   ├── AssetRegistry.gd               ← ALL asset paths by string key
│   ├── SignalBus.gd                   ← ALL cross-system signals declared here
│   ├── DataLoader.gd                  ← parses /data/*.json into typed Resources
│   └── ResourceManager.gd            ← tracks { wood, stone, iron, food, gold, textiles }
│
├── data/
│   ├── buildings.json
│   ├── units.json
│   ├── waves.json
│   ├── terrain.json
│   ├── relics.json
│   └── merchants.json
│
├── systems/
│   ├── HexGrid.gd                     ← pure hex math, no nodes, no dependencies
│   ├── DayNightCycle.gd               ← state machine, owns the cycle timer
│   ├── BuildingPlacer.gd              ← validates + instances buildings onto tiles
│   ├── WaveSpawner.gd                 ← reads waves.json, spawns on outer ring
│   ├── PathfindingSystem.gd           ← A* on hex grid, used by all unit movement
│   ├── CameraController.gd            ← isometric free-roam, zoom, edge-pan
│   └── MerchantSpawner.gd             ← places merchant on day 4 and 6
│
├── world/
│   ├── HexMap.tscn                    ← the game world; owns hex tile instances
│   ├── HexTile.tscn                   ← single tile: mesh + Area3D for click
│   ├── ResourceNode.tscn              ← harvestable prop (tree/rock/ore)
│   └── MapGenerator.gd                ← procedural hex layout from noise
│
├── entities/
│   ├── buildings/
│   │   ├── Building.tscn              ← base: @export mesh_key, @export data_id
│   │   ├── Building.gd
│   │   ├── ProductionBuilding.gd      ← extends Building; handles resource tick
│   │   ├── MilitaryBuilding.gd        ← extends Building; spawns defenders at night
│   │   └── GreatHall.tscn             ← special: win condition building
│   │
│   ├── units/
│   │   ├── Unit.tscn                  ← base: health, speed, AnimationTree
│   │   ├── Unit.gd
│   │   ├── Adventurer.tscn            ← extends Unit; has assignment + night behavior
│   │   ├── Adventurer.gd
│   │   ├── Skeleton.tscn              ← extends Unit; has pathfinding to target
│   │   └── Skeleton.gd
│   │
│   └── props/
│       ├── Gravestone.tscn            ← spawned on outer ring at dusk
│       ├── Gravestone.gd              ← handles rise/sink tween
│       └── FloatingText.tscn          ← "+30 wood" resource feedback
│
├── ui/
│   ├── HUD.tscn                       ← resource bar, day counter, settlement HP
│   ├── HUD.gd
│   ├── BuildPanel.tscn                ← building palette, opened by tile click
│   ├── BuildPanel.gd
│   ├── TavernMenu.tscn                ← hire adventurers
│   ├── TavernMenu.gd
│   ├── MerchantMenu.tscn              ← trade + relic shop
│   ├── WaveAnnouncer.tscn             ← "Night 3 approaches... 22 skeletons"
│   ├── RunSummary.tscn                ← win/loss screen
│   └── Tooltip.tscn                   ← hover-over building/unit info
│
├── scenes/
│   ├── Main.tscn                      ← root: HexMap + HUD + all autoloads
│   ├── MainMenu.tscn
│   └── Debug.tscn                     ← isolated test scene for each system
│
└── assets/
    └── kaykit/
        ├── medieval_hexagon/          ← see Asset Mapping section
        ├── resource_bits/
        ├── adventurers/
        ├── skeletons/
        ├── character_animations/
        ├── rpg_tools_bits/
        ├── halloween_bits/
        ├── furniture_bits/
        ├── forest_nature/
        ├── city_builder_bits/         ← road tiles, market props
        ├── dungeon_remastered/        ← mine interior subscene
        └── series_4_5/                ← merchant characters
```

---

## Core Autoloads (Full Signatures)

### `GameState.gd`
```gdscript
extends Node

# Run state
var day_number: int = 1
var current_phase: String = "day"   # "day" | "dusk" | "night" | "dawn"
var settlement_hp: int = 100
var settlement_max_hp: int = 100
var great_hall_progress: float = 0.0  # 0.0–3.0 (days of construction)
var is_great_hall_placed: bool = false
var siege_night: bool = false

# Persistent per-run
var relics: Array[String] = []
var buildings_placed: Array[Dictionary] = []  # [{hex, building_id, hp}]
var adventurers: Array[Dictionary] = []        # [{unit_id, assignment, hp}]

# Convenience
func is_day() -> bool: return current_phase == "day"
func is_night() -> bool: return current_phase == "night"
func add_relic(relic_id: String) -> void
func take_settlement_damage(amount: int) -> void
```

### `SignalBus.gd`
```gdscript
extends Node

# Phase
signal phase_changed(new_phase: String)
signal day_started(day_number: int)
signal night_started(wave_data: Dictionary)

# Economy
signal resource_changed(type: String, new_amount: int)
signal resource_depleted(type: String)         # food=0 triggers debuff

# World
signal tile_clicked(hex_coord: Vector2i)
signal building_placed(hex_coord: Vector2i, building_id: String)
signal building_damaged(hex_coord: Vector2i, remaining_hp: int)
signal building_destroyed(hex_coord: Vector2i, building_id: String)
signal resource_node_depleted(hex_coord: Vector2i)

# Units
signal adventurer_hired(unit_data: Dictionary)
signal adventurer_died(unit_node: Node3D)
signal skeleton_spawned(unit_node: Node3D)
signal skeleton_died(unit_node: Node3D)
signal skeleton_reached_building(unit_node: Node3D, hex_coord: Vector2i)
signal skeleton_reached_center()

# Waves
signal wave_cleared(wave_number: int, survivors: int, losses: int)
signal siege_wave_started()

# UI
signal tooltip_requested(data: Dictionary)
signal merchant_arrived(merchant_data: Dictionary)
signal relic_acquired(relic_id: String)
```

### `AssetRegistry.gd`
```gdscript
extends Node

# All asset references as string keys
# Paths are relative to res://assets/kaykit/
# Claude Code: populate these with actual filenames from the asset tree

const MESHES: Dictionary = {
  # Terrain tiles
  "tile_grass":           "medieval_hexagon/tiles/hex_grass.glb",
  "tile_forest":          "medieval_hexagon/tiles/hex_forest.glb",
  "tile_mountain":        "medieval_hexagon/tiles/hex_mountain.glb",
  "tile_water":           "medieval_hexagon/tiles/hex_water.glb",
  "tile_road":            "medieval_hexagon/tiles/hex_road.glb",
  "tile_coast":           "medieval_hexagon/tiles/hex_coast.glb",

  # Buildings (green = tier 1)
  "building_lumbermill":  "medieval_hexagon/buildings/lumbermill_green.glb",
  "building_mine":        "medieval_hexagon/buildings/mine_green.glb",
  "building_farm":        "medieval_hexagon/buildings/farm_green.glb",
  "building_well":        "medieval_hexagon/buildings/well.glb",
  "building_blacksmith":  "medieval_hexagon/buildings/blacksmith_green.glb",
  "building_barracks":    "medieval_hexagon/buildings/barracks_green.glb",
  "building_archery":     "medieval_hexagon/buildings/archery_range_green.glb",
  "building_church":      "medieval_hexagon/buildings/church_green.glb",
  "building_tavern":      "medieval_hexagon/buildings/tavern_green.glb",
  "building_market":      "medieval_hexagon/buildings/market_green.glb",
  "building_windmill":    "medieval_hexagon/buildings/windmill_green.glb",
  "building_great_hall":  "medieval_hexagon/buildings/castle_green.glb",

  # Units
  "unit_farmer":          "adventurers/farmer.glb",
  "unit_lumberjack":      "adventurers/lumberjack.glb",
  "unit_miner":           "adventurers/miner.glb",
  "unit_knight":          "adventurers/knight.glb",
  "unit_archer":          "adventurers/archer.glb",
  "unit_mage":            "adventurers/mage.glb",
  "unit_skeleton":        "skeletons/skeleton.glb",
  "unit_skeleton_soldier":"skeletons/skeleton_soldier.glb",
  "unit_skeleton_archer": "skeletons/skeleton_archer.glb",
  "unit_skeleton_champ":  "skeletons/skeleton_champion.glb",
  "unit_skeleton_king":   "skeletons/skeleton_king.glb",

  # Resources (world props)
  "resource_wood":        "resource_bits/log_stack.glb",
  "resource_stone":       "resource_bits/stone_pile.glb",
  "resource_iron":        "resource_bits/iron_ingot.glb",
  "resource_food":        "resource_bits/food_basket.glb",
  "resource_gold":        "resource_bits/gold_coins.glb",
  "resource_textiles":    "resource_bits/textile_bolt.glb",

  # Halloween props
  "prop_gravestone":      "halloween_bits/gravestone.glb",
  "prop_gravestone_cross":"halloween_bits/gravestone_cross.glb",
  "prop_lantern":         "halloween_bits/jack_o_lantern.glb",

  # Nature decorations
  "decor_tree_pine":      "forest_nature/tree_pine.glb",
  "decor_tree_oak":       "forest_nature/tree_oak.glb",
  "decor_rock_large":     "forest_nature/rock_large.glb",
  "decor_mushroom":       "forest_nature/mushroom.glb",

  # UI icons (RPG Tools Bits — used as Texture in Control nodes)
  "icon_wood":            "rpg_tools_bits/icons/wood.png",
  "icon_stone":           "rpg_tools_bits/icons/stone.png",
  "icon_iron":            "rpg_tools_bits/icons/iron.png",
  "icon_food":            "rpg_tools_bits/icons/food.png",
  "icon_gold":            "rpg_tools_bits/icons/gold.png",
  "icon_skull":           "rpg_tools_bits/icons/skull.png",
  "icon_heart":           "rpg_tools_bits/icons/heart.png",
  "icon_sword":           "rpg_tools_bits/icons/sword.png",
}

static func mesh_path(key: String) -> String:
  assert(key in MESHES, "AssetRegistry: unknown key '%s'" % key)
  return "res://assets/kaykit/" + MESHES[key]

static func load_mesh(key: String) -> Mesh:
  return load(mesh_path(key))

static func load_scene(key: String) -> PackedScene:
  return load(mesh_path(key))
```

### `HexGrid.gd` (Pure Math, No Nodes)
```gdscript
# Offset coordinates (col, row) ↔ Cube coordinates (q, r, s)
# Uses "odd-r" offset layout matching KayKit hex tile arrangement

static func offset_to_cube(hex: Vector2i) -> Vector3i
static func cube_to_offset(cube: Vector3i) -> Vector2i
static func hex_distance(a: Vector2i, b: Vector2i) -> int
static func hex_neighbors(hex: Vector2i) -> Array[Vector2i]  # returns 6 neighbors
static func hex_ring(center: Vector2i, radius: int) -> Array[Vector2i]
static func hex_to_world(hex: Vector2i, tile_size: float = 1.0) -> Vector3
static func world_to_hex(world: Vector3, tile_size: float = 1.0) -> Vector2i
static func astar_path(start: Vector2i, end: Vector2i,
                        passable_fn: Callable) -> Array[Vector2i]
```

---

## Data Schema (JSON)

### `buildings.json`
```json
{
  "lumbermill": {
    "display_name": "Lumbermill",
    "description": "Harvests wood from nearby forests.",
    "mesh_key": "building_lumbermill",
    "tier": 1,
    "cost": { "wood": 40 },
    "output": { "resource": "wood", "per_day": 30 },
    "requires_adjacent_terrain": "tile_forest",
    "max_workers": 2,
    "hp": 60,
    "worker_bonus": { "unit": "lumberjack", "multiplier": 1.25 }
  },
  "barracks": {
    "display_name": "Barracks",
    "description": "Trains soldiers who defend at night.",
    "mesh_key": "building_barracks",
    "tier": 1,
    "cost": { "wood": 60, "stone": 30, "iron": 10 },
    "output": null,
    "night_behavior": "spawn_defenders",
    "defender_type": "unit_knight",
    "defender_count": 2,
    "max_workers": 4,
    "hp": 80
  }
}
```

### `waves.json`
```json
{
  "1":  { "skeletons": [{"type":"unit_skeleton","count":4}], "spawn_edges": ["north","east"] },
  "2":  { "skeletons": [{"type":"unit_skeleton","count":7}], "spawn_edges": ["north","east","south"] },
  "3":  { "skeletons": [{"type":"unit_skeleton","count":8},{"type":"unit_skeleton_soldier","count":2}], "spawn_edges": ["all"] },
  "10": {
    "is_siege": true,
    "skeletons": [
      {"type":"unit_skeleton","count":20},
      {"type":"unit_skeleton_soldier","count":10},
      {"type":"unit_skeleton_archer","count":10},
      {"type":"unit_skeleton_champ","count":5},
      {"type":"unit_skeleton_king","count":1}
    ],
    "spawn_edges": ["all"],
    "message": "The Skeleton King has come. Hold the line."
  }
}
```

---

# 3. Asset Mapping

## How to Discover Exact Filenames with Claude Code

Since you have the assets downloaded, Claude Code can enumerate your actual file tree. Use this as the **first prompt in every session:**

```
Read the directory tree under res://assets/kaykit/ recursively and list all .glb 
and .png files grouped by subfolder. Then open AssetRegistry.gd and fill in any 
MESHES entries that have placeholder comments with the correct relative paths.
```

This means the asset mapping below uses **descriptive names** — Claude Code fills in the exact filenames from your disk. Here is the authoritative mapping of game system → pack → what to look for:

---

## Medieval Hexagon Pack
**Location:** `assets/kaykit/medieval_hexagon/`

| Game Need | What to Look For |
|---|---|
| Grass terrain tiles | Files named `hex_grass*` or `tile_grass*` |
| Forest terrain tiles | Files named `hex_forest*` or `tile_forest*` |
| Mountain terrain tiles | Files named `hex_mountain*` or `hex_rock*` |
| Water terrain tiles | Files named `hex_water*` or `hex_ocean*` |
| Coast tiles | Files named `hex_coast*` or `hex_shore*` |
| Road tiles | Files named `hex_road*` or `hex_path*` |
| River tiles | Files named `hex_river*` |
| Lumbermill | `lumbermill*` — 4 variants for tier colors |
| Mine | `mine*` |
| Farm | `farm*` |
| Well | `well*` |
| Blacksmith | `blacksmith*` |
| Barracks | `barracks*` |
| Archery Range | `archery*` or `tower*` |
| Church | `church*` |
| Tavern | `tavern*` |
| Market | `market*` |
| Windmill | `windmill*` — should have animated blade variant |
| Castle/Great Hall | `castle*` — use largest variant for Great Hall |
| Trees (hex props) | `tree*` in nature/decoration subfolder |
| Rocks (hex props) | `rock*` or `mountain*` in decoration |
| Clouds | `cloud*` — use as ambient sky props |
| Units (if included in your tier) | `unit_*` or character models in units subfolder |

**Notes:**
- The 4 color variants (blue/red/green/yellow) map to upgrade tiers. Green = tier 1, Blue = tier 2, Red = tier 3, Yellow = tier 4. Only green is needed for the base game.
- Pre-assembled hex tiles (hill + tree combos) can be used as non-buildable decorative tiles on the map edges.
- Windmill blades may be a separate mesh — if so, animate them with a rotation tween in `Building.gd`.

---

## Resource Bits Pack
**Location:** `assets/kaykit/resource_bits/`

| Resource | Look For | Used As |
|---|---|---|
| Wood | `log*`, `wood*`, `plank*` | World prop on lumbermill tile, HUD icon |
| Stone | `stone*`, `rock*` | World prop on mine tile |
| Iron | `iron*`, `ingot*` | World prop on mine tile (day 3+) |
| Food | `food*`, `basket*`, `grain*` | World prop on farm tile |
| Gold | `gold*`, `coin*` | World prop floating above market |
| Textiles | `textile*`, `cloth*`, `fabric*` | World prop on windmill tile |
| Containers (Extra tier) | `crate*`, `barrel*`, `chest*` | Decoration in tavern interior |
| Gems (Extra tier) | `gem*`, `crystal*` | Relic items in merchant menu |
| Money (Extra tier) | `bag*`, `purse*` | Merchant trade UI |

**In-game usage:** Resource world props are instanced at 0.3× scale and placed on the tile using `ResourceNode.tscn`. They scale up on collection (tween to 0) as a feedback animation.

---

## Character Pack Adventurers
**Location:** `assets/kaykit/adventurers/`

| Unit | Look For |
|---|---|
| Farmer | `farmer*`, or generic peasant with farming clothes |
| Lumberjack | `lumberjack*`, or character with axe prop |
| Miner | `miner*`, or character with pickaxe prop |
| Knight | `knight*`, `warrior*` |
| Archer | `archer*`, `ranger*` |
| Mage | `mage*`, `wizard*`, `sorcerer*` |
| Merchant (if present) | `merchant*`, `trader*` |

**Animation setup:** All adventurers use `Character Animations` pack. In Godot 4, import the character .glb and add an `AnimationTree` node pointing to `character_animations/animations.glb`. States: `idle`, `walk`, `attack`, `death`, `work` (if available — otherwise use idle).

---

## Character Pack Skeletons
**Location:** `assets/kaykit/skeletons/`

| Unit | Look For |
|---|---|
| Basic Skeleton | `skeleton*` base model |
| Skeleton Soldier | `skeleton_soldier*`, `skeleton_warrior*` |
| Skeleton Archer | `skeleton_archer*`, `skeleton_ranger*` |
| Skeleton Champion | `skeleton_champion*`, `skeleton_heavy*` |
| Skeleton King | `skeleton_king*`, `skeleton_boss*` |

**Same animation setup** as adventurers — the Character Animations pack is designed to work with all KayKit character models.

---

## Character Animations Pack
**Location:** `assets/kaykit/character_animations/`

| Animation | In-Game Use |
|---|---|
| `idle` | Standing in assigned building during day; standing at night |
| `walk` / `run` | Moving between tiles |
| `attack` | Combat against enemy |
| `death` | Play on 0 HP, freeze last frame, remove after 2s |
| `work` (if exists) | Worker inside production building |
| `cheer` (if exists) | Dawn phase celebration |

**Claude Code setup note:** The animation library is a shared `.glb` or `.res` file. In `Unit.gd`, reference it via:
```gdscript
@onready var animation_tree: AnimationTree = $AnimationTree
# AnimationTree → AnimationPlayer → imported animation library
```

---

## RPG Tools Bits
**Location:** `assets/kaykit/rpg_tools_bits/`

All used as **2D TextureRect icons** inside Control nodes — not as 3D meshes.

| UI Element | Look For |
|---|---|
| Resource icons (HUD) | `wood.png`, `stone.png`, `iron.png`, `food.png`, `gold.png` |
| Skull (night/death) | `skull.png`, `death.png` |
| Heart (settlement HP) | `heart.png`, `health.png` |
| Sword (attack) | `sword.png`, `attack.png` |
| Shield (defense) | `shield.png` |
| Star (upgrade) | `star.png`, `upgrade.png` |
| Scroll (quest/info) | `scroll.png`, `quest.png` |
| Relic slots | `slot_empty.png`, `slot_filled.png` |
| Day/Night icons | `sun.png`, `moon.png` |

---

## Halloween Bits
**Location:** `assets/kaykit/halloween_bits/`

| Use | Look For |
|---|---|
| Dusk gravestones (rise from outer ring) | `gravestone*`, `tombstone*` |
| Jack-o-lanterns (night atmosphere) | `lantern*`, `pumpkin*`, `jack*` |
| Corrupted ground tiles | `corrupted*`, `dark_ground*`, `hex_corrupted*` |
| Bones/skulls (decoration after battle) | `bone*`, `skull*` |
| Creepy trees | `dead_tree*`, `creepy_tree*` |

**Usage:** Gravestones spawn on the outermost 3 hex rings at Dusk using a Y-axis tween from -1.0 to 0.0 over 1.5 seconds. They sink back during Dawn. Jack-o-lanterns are placed statically on the outer ring tiles and become visible (via show/hide) at Dusk.

---

## Furniture Bits
**Location:** `assets/kaykit/furniture_bits/`

Used exclusively in the **Tavern subscene** — an isometric "open roof" view when clicking a Tavern building.

| Item | Look For |
|---|---|
| Bar/counter | `bar*`, `counter*`, `bartop*` |
| Stools | `stool*`, `barstool*` |
| Tables | `table*` |
| Chairs | `chair*` |
| Shelves | `shelf*`, `bookshelf*` |
| Candles | `candle*` |
| Barrels | `barrel*` (complement with resource_bits barrels) |
| Fireplace | `fireplace*`, `hearth*` |

---

## Forest Nature Pack
**Location:** `assets/kaykit/forest_nature/`

Used as **ambient decoration** on unexplored/neutral tiles outside the player's built area. Makes the world feel wild.

| Use | Look For |
|---|---|
| Dense trees (unexplored tiles) | `tree_pine*`, `tree_oak*`, `tree_birch*` |
| Undergrowth | `bush*`, `fern*`, `grass_tuft*` |
| Large rocks | `rock_large*`, `boulder*` |
| Mushrooms | `mushroom*` |
| Fallen logs | `fallen_log*`, `log*` (different from resource logs) |
| Flowers | `flower*` (meadow tiles) |

**Placement rule:** When `HexMap` generates a tile of type `forest`, place 2–4 random Forest Nature Pack trees on it at slight random offsets and rotations. These are purely decorative (no gameplay function). They are removed when a building is placed on the tile.

---

## Series 4 & 5 Characters
**Location:** `assets/kaykit/series_4_5/` (or separate subfolders per series)

Used as **merchant characters** that visit on days 4 and 6.

| Role | Look For |
|---|---|
| First merchant (day 4) | Any unique, non-combat character from Series 4 |
| Second merchant (day 6) | Any unique character from Series 5, visually distinct |
| Optional: quest giver | Any cloaked or robed character |

Each merchant is a `CharacterBody3D` that walks to a road-adjacent hex, plays idle animation, and shows a floating shop icon (RPG Tools Bits `shop.png` or `merchant.png`) above their head.

---

## City Builder Bits
**Location:** `assets/kaykit/city_builder_bits/`

Supplements the Medieval Hexagon Pack for road and market infrastructure.

| Use | Look For |
|---|---|
| Road intersection props | `road_cross*`, `road_t*` |
| Market stall decorations | `stall*`, `awning*`, `stand*` |
| Street props | `streetlamp*`, `post*`, `sign*` |
| Fence/wall segments | `fence*`, `wall_low*` |

---

## Dungeon Pack Remastered
**Location:** `assets/kaykit/dungeon_remastered/`

Used only for the **Mine interior subscene** — an optional click-to-open view of the mine interior showing workers animating.

| Use | Look For |
|---|---|
| Floor tiles | `floor_*`, `dungeon_floor*` |
| Wall tiles | `wall_*`, `dungeon_wall*` |
| Torches | `torch*` — use animated variant if available |
| Pillars | `pillar*`, `column*` |
| Ore vein props | `ore*`, `vein*`, `crystal*` |
| Mining cart | `cart*`, `minecart*` |
| Support beams | `beam*`, `support*` |

The mine subscene is a small 3×4 tile dungeon room rendered in a separate Viewport and shown as a panel when the mine building is clicked. Workers (miner units) animate inside it using the `work` animation.

---

# 4. CLAUDE.md

This file goes in the project root. Claude Code reads it at the start of every session.

```markdown
# Holdfast — Claude Code Project Instructions

## Project Overview
Holdfast is a hex-based medieval settlement survival game built in Godot 4.3.
Players build a settlement by day and defend it from skeleton waves by night.
Win condition: Complete the Great Hall (3 days of construction) before night 10's siege.

## Tech Stack
- Godot 4.3 (GDScript)
- KayKit 3D assets (CC0 licensed) — located in res://assets/kaykit/
- No physics engine use — all movement is tween-based, grid-based
- No external plugins required

## Asset Rules — CRITICAL
- NEVER hardcode asset file paths in scripts.
- ALL asset references go through AssetRegistry.gd using string keys.
- If you need a new asset, add its key+path to AssetRegistry.gd FIRST, then use the key.
- To discover actual filenames: read the directory tree under res://assets/kaykit/

## Signal Rules — CRITICAL
- NEVER connect signals directly between systems (e.g., WaveSpawner should never import BuildingPlacer).
- ALL cross-system signals are declared in SignalBus.gd (autoload).
- Emit signals via: SignalBus.emit_signal("signal_name", args)
- Connect via: SignalBus.signal_name.connect(my_callback)

## Data Rules
- ALL balance values live in res://data/*.json. Never hardcode numbers in scripts.
- DataLoader.gd (autoload) parses all JSON at startup.
- Access data via: DataLoader.buildings["lumbermill"].cost["wood"]
- To change balance: edit the JSON file only.

## Coordinate System
- All tile positions are Vector2i(col, row) in offset coordinates.
- Use HexGrid.gd for ALL hex math (neighbors, distance, world position, pathfinding).
- Tile size is 1.0 unit in world space (each hex = 1m diameter).

## Scene Authoring Rules
- Building scenes extend Building.tscn. Only set @export variables, swap the mesh node.
- Unit scenes extend Unit.tscn. Only set @export stat variables.
- Never duplicate logic that exists in a base scene/script.

## File Creation Rules
- New systems go in res://systems/
- New entity types go in res://entities/ (buildings/ or units/)
- New UI goes in res://ui/
- New autoloads go in res://autoloads/ AND must be registered in project.godot

## Testing
- Always create or update res://scenes/Debug.tscn to test your work in isolation.
- The debug scene should include a minimal setup: HexMap with 5×5 grid, HUD, 
  one of each entity type relevant to what you just built.
- Print a clear test checklist to the Godot output panel on scene start.

## Code Style
- Use typed GDScript (var x: int, func foo(a: String) -> bool)
- @export all designer-facing variables
- Every .gd file starts with a 2–3 line comment explaining what it does and what it connects to
- Max function length: 30 lines. Extract helpers if longer.
- No magic numbers. Use constants at the top of the file or pull from DataLoader.

## Current Milestone
[UPDATE THIS LINE before each session with the current milestone number and name]
Example: "Currently working on: Milestone 3 — Building Placement"
```

---

# 5. Agent Prompt Library

Each prompt below is a **self-contained Claude Code session starter**. Paste it as your opening message after Claude Code reads `CLAUDE.md`. Each prompt specifies exactly what to build, what files to create/edit, and what "done" looks like.

---

## Milestone 1 — Project Scaffold & Hex World

```
We're starting Holdfast from scratch. The assets are already in res://assets/kaykit/.

Step 1: Scaffold the project structure. Create all the empty .gd files and .tscn 
scenes listed in the architecture (CLAUDE.md has the full tree). For .tscn files, 
create minimal valid scenes with just a Node3D root. For .gd files, add the 2-line 
comment header and an empty class.

Step 2: Register all autoloads in project.godot:
  GameState, AssetRegistry, SignalBus, DataLoader, ResourceManager

Step 3: Read the directory tree under res://assets/kaykit/medieval_hexagon/ and 
identify the hex terrain tile .glb files for: grass, forest, mountain, water, coast, 
road. Fill in those entries in AssetRegistry.gd with correct paths.

Step 4: Implement HexGrid.gd (pure static functions, no Node):
  - offset_to_cube(hex: Vector2i) -> Vector3i
  - cube_to_offset(cube: Vector3i) -> Vector2i  
  - hex_distance(a: Vector2i, b: Vector2i) -> int
  - hex_neighbors(hex: Vector2i) -> Array[Vector2i]
  - hex_ring(center: Vector2i, radius: int) -> Array[Vector2i]
  - hex_to_world(hex: Vector2i, tile_size: float) -> Vector3
  - world_to_hex(world: Vector3, tile_size: float) -> Vector2i
  Use "odd-r" offset layout.

Step 5: Implement HexMap.tscn + MapGenerator.gd. The map is 15 columns × 12 rows.
  Use FastNoiseLite to assign tile types:
    noise > 0.3 → grass (60% of map)
    noise 0.1–0.3 → forest (20%)
    noise -0.1–0.1 → mountain (10%)
    noise < -0.1 → water (10%)
  For each tile, instance the correct mesh from AssetRegistry. Position using 
  HexGrid.hex_to_world(). Store all tile data in a Dictionary: 
  { Vector2i: { "type": String, "building": null, "units": [] } }

Step 6: Implement HexTile.tscn — a Node3D with a MeshInstance3D child and an 
  Area3D+CollisionShape for click detection. On input_event, emit 
  SignalBus.tile_clicked(hex_coord).

Step 7: Create Debug.tscn with the HexMap. Print "Tile clicked: (col, row) type=X" 
  to output when any tile is clicked. Print all neighbor coords for each clicked tile.

Done when: Running Debug.tscn shows a 15×12 hex grid with textured tiles, and 
clicking any tile prints its coordinates and type.
```

---

## Milestone 2 — Data Layer

```
Implement the complete data layer for Holdfast.

Step 1: Create all JSON files in res://data/ with the full content specified in the 
architecture document. Include at minimum:
  - buildings.json: all 11 building types with cost, output, hp, mesh_key
  - units.json: all 6 adventurer types + 5 skeleton types with stats
  - waves.json: all 10 nights including the siege (night 10)
  - terrain.json: tile types with movement_cost and buildable flag
  - relics.json: 6 relics with name, description, effect_key, mesh_key

Step 2: Implement DataLoader.gd as an autoload. It should:
  - Load and parse all JSON files on _ready()
  - Expose typed inner classes: BuildingData, UnitData, WaveData, TerrainData, RelicData
  - Store parsed data in dictionaries: DataLoader.buildings, .units, .waves, .terrain, .relics
  - Print a summary to output on load: "Loaded: X buildings, X units, X waves"
  - assert() with a clear error if any required field is missing from a JSON entry

Step 3: Implement ResourceManager.gd as an autoload:
  - var amounts: Dictionary = { "wood":100, "stone":50, "iron":0, "food":30, "gold":20, "textiles":0 }
  - func add(type: String, amount: int) -> void — adds resource, emits SignalBus.resource_changed
  - func spend(type: String, amount: int) -> bool — returns false if insufficient
  - func can_afford(cost: Dictionary) -> bool — checks all resource types
  - func apply_upkeep(upkeep: Dictionary) -> void — called at night start

Step 4: Write a validation script (tools/validate_data.gd) that can be run from 
  the Godot editor. It should verify:
  - Every building's mesh_key exists in AssetRegistry.MESHES
  - Every unit's mesh_key exists in AssetRegistry.MESHES  
  - Every wave references valid unit types
  - No cost dictionary references an unknown resource type

Done when: DataLoader prints correct counts on startup, ResourceManager.can_afford 
works correctly, and the validator reports 0 errors.
```

---

## Milestone 3 — Building Placement

```
Implement the building placement system.

Context: HexMap and tile clicking are working from Milestone 1. DataLoader and 
ResourceManager are working from Milestone 2.

Step 1: Implement BuildingPlacer.gd in res://systems/:
  - Listens to SignalBus.tile_clicked
  - Only acts when GameState.current_phase == "day"
  - func can_place(building_id: String, hex: Vector2i) -> bool:
      Check: tile is not water, no existing building, terrain requirement met 
      (e.g., lumbermill needs adjacent forest tile), ResourceManager.can_afford(cost)
  - func place_building(building_id: String, hex: Vector2i) -> void:
      Spend resources, instance Building.tscn, set mesh from AssetRegistry, 
      position at HexGrid.hex_to_world(hex), store in HexMap tile dict,
      emit SignalBus.building_placed(hex, building_id)

Step 2: Implement Building.tscn base scene:
  @export var building_id: String
  @export var mesh_key: String  
  @export var current_hp: int
  @export var max_hp: int
  @export var assigned_workers: Array[Node]
  func take_damage(amount: int) -> void
  func on_placed() -> void  (called after placement)
  func on_night_start() -> void  (override in subclasses)
  func on_day_start() -> void    (override in subclasses)

Step 3: Implement ProductionBuilding.gd extending Building.gd:
  - On day phase ticks (every 5 seconds), call ResourceManager.add(output_resource, amount)
  - Amount is scaled by assigned_workers.size() / max_workers (minimum 0.5 without workers)
  - Visually: show a small Resource Bits prop above the building using AssetRegistry
    that floats upward and fades (FloatingText.tscn — just a Label3D for now)

Step 4: Implement BuildPanel.tscn (UI):
  - Appears when a valid empty tile is clicked
  - Populates a grid of buttons from DataLoader.buildings
  - Each button shows: building name, resource cost icons (RPG Tools Bits), 
    greyed out if ResourceManager.can_afford() returns false
  - On button click: call BuildingPlacer.place_building(id, current_hex)
  - Panel closes after placement or if player clicks elsewhere

Step 5: Add 3 building types as concrete scenes using ProductionBuilding.gd:
  Lumbermill.tscn, Mine.tscn, Farm.tscn
  Each just sets the @export variables — no new logic needed.

Step 6: Update Debug.tscn: start with wood=200, stone=100. Verify you can place 
  a lumbermill on a forest-adjacent tile, a mine on a mountain tile, and a farm on 
  grass. Verify you cannot place on water or without enough resources.

Done when: Build panel appears on tile click, buildings place correctly with cost 
deduction, and terrain rules are enforced.
```

---

## Milestone 4 — Day/Night Cycle & Atmosphere

```
Implement the full day/night cycle with visual atmosphere changes.

Step 1: Implement DayNightCycle.gd as a Node (added to Main.tscn):
  State machine with phases: "day" (90s) → "dusk" (12s) → "night" (variable) → "dawn" (10s) → "day"
  On each transition: emit SignalBus.phase_changed(new_phase)
  On "day" transition: increment GameState.day_number, emit SignalBus.day_started(day_number)
  On "night" transition: emit SignalBus.night_started(DataLoader.waves[str(day_number)])
  Night ends when WaveSpawner emits wave_cleared OR settlement_hp reaches 0.

Step 2: Lighting transitions using a DirectionalLight3D in Main.tscn:
  - DAY: energy=1.2, color=warm white (1.0, 0.95, 0.8), sky bright
  - DUSK: tween over 12s to energy=0.6, color=orange (1.0, 0.5, 0.2)
  - NIGHT: tween over 3s to energy=0.3, color=cold blue (0.4, 0.4, 0.8)
  - DAWN: tween over 10s back to DAY values
  Also tween the WorldEnvironment ambient light color to match.

Step 3: Gravestone spawning. On "dusk" phase:
  - Get the outermost 3 hex rings using HexGrid.hex_ring(center, 7), hex_ring(center, 6), hex_ring(center, 5)
  - For each tile in those rings, instance Gravestone.tscn from AssetRegistry "prop_gravestone"
  - Animate: start at position.y = -1.0, tween to position.y = 0.0 over 1.5s with EASE_OUT
  - Store all spawned gravestones in an array
  On "dawn" phase: reverse tween all gravestones, then queue_free() them.

Step 4: Jack-o-lanterns. On map generation, place one lantern prop 
  (AssetRegistry "prop_lantern") on every 4th outermost ring tile. Set visible=false.
  On "dusk": set visible=true. On "dawn": set visible=false.

Step 5: Day counter in HUD. Add a Label showing "Day X" and a ProgressBar showing 
  time remaining in current phase. Use RPG Tools Bits sun/moon icons to indicate phase.

Step 6: WaveAnnouncer.tscn — a Control node that slides in from the top of screen 
  on phase transitions. Shows:
  - "Day 3 begins" on DAY (with sun icon)
  - "Night approaches... 12 skeletons" on DUSK (count from waves.json)
  - "Dawn breaks — 3 skeletons slain, 1 adventurer lost" on DAWN
  Slides out after 3 seconds.

Done when: The full cycle runs, lighting shifts smoothly, gravestones rise and sink, 
and the announcer shows correct information.
```

---

## Milestone 5 — Units & Pathfinding

```
Implement unit spawning, movement, and pathfinding for both skeletons and adventurers.

Step 1: Implement Unit.tscn base scene and Unit.gd:
  @export var unit_id: String
  @export var max_hp: int
  @export var move_speed: float  (tiles per second)
  @export var attack_damage: int
  @export var attack_range: int  (in hex tiles)
  @export var attack_cooldown: float

  var current_hp: int
  var current_hex: Vector2i
  var is_alive: bool = true

  func move_to_hex(target: Vector2i) -> void  — tween position, update current_hex
  func take_damage(amount: int) -> void  — reduce hp, play hurt flash, check death
  func die() -> void  — play death animation, emit SignalBus.unit_died(self), queue_free after 2s
  func find_attack_targets() -> Array[Node]  — returns units in attack_range hexes

Step 2: Implement PathfindingSystem.gd in res://systems/:
  Uses HexGrid.astar_path internally.
  func find_path(start: Vector2i, end: Vector2i, unit_type: String) -> Array[Vector2i]
    — "skeleton" treats buildings as passable (they attack them), 
    — "adventurer" treats buildings as obstacles
  The passable_fn checks HexMap tile dict for terrain type from DataLoader.terrain[type].movement_cost

Step 3: Implement Skeleton.gd extending Unit.gd:
  On spawn: set target to HexMap center (Vector2i(7, 6))
  In _ready: call PathfindingSystem.find_path(current_hex, target) 
  Follow path tile by tile using move_to_hex() with await
  If a building is on the next tile: stop, attack it repeatedly until dead, then continue
  If an adventurer is in attack range: attack adventurer instead of moving
  On reaching settlement center hex: emit SignalBus.skeleton_reached_center()

Step 4: Implement WaveSpawner.gd in res://systems/:
  Listens to SignalBus.night_started(wave_data)
  For each entry in wave_data.skeletons:
    Spawn count units of type on hex_ring based on spawn_edges
    Stagger spawns by 0.5 seconds between each unit
    Track all spawned skeletons in an array
  Listen to SignalBus.skeleton_died — remove from array
  When array is empty: emit SignalBus.wave_cleared(day_number, kills, losses)

Step 5: Implement Adventurer.gd extending Unit.gd:
  @export var assignment: String  (building_id they work in)
  @export var combat_role: String  ("melee" or "ranged")
  On SignalBus.night_started: leave assigned building, walk to defensive position
    Melee: walk to the outermost occupied hex ring and patrol (ping-pong between 2 hexes)
    Ranged: stay on building tile, attack any skeleton within attack_range
  On SignalBus.day_started: walk back to assigned building

Step 6: Animation integration. All units have an AnimationPlayer.
  Load the Character Animations library. Map states:
    idle → "idle" animation
    moving → "walk" animation  
    attacking → "attack" animation
    dying → "death" animation
  Use a simple state machine (enum) in Unit.gd to drive animation transitions.

Done when: Spawning skeletons on Debug.tscn walk toward center, attack buildings 
they encounter, and die correctly. Adventurers animate and respond to phase changes.
```

---

## Milestone 6 — Combat & Wave Completion

```
Implement the full combat loop: skeletons vs adventurers, building damage, 
settlement HP, and wave completion.

Step 1: Implement combat resolution in Unit.gd:
  func try_attack(target: Node) -> void:
    if attack_cooldown_timer > 0: return
    target.take_damage(attack_damage)
    play "attack" animation
    reset attack_cooldown_timer = attack_cooldown
  
  In _process: scan for targets in hex_neighbors up to attack_range
  Prioritize: adventurer attacks skeletons; skeletons attack buildings first, then adventurers

Step 2: Building damage. When SignalBus.building_damaged fires:
  Show a brief red flash on the building mesh (material override tween)
  Update HP bar above building (a small ProgressBar in a SubViewport or a 
  simple 3D quad mesh you scale)
  When HP reaches 0: swap mesh to a ruin variant if available in Medieval Hexagon Pack,
  or reduce scale to 0.3 and tint dark grey as fallback.
  Remove building from HexMap tile dict.
  Kill all workers assigned to that building.
  Emit SignalBus.building_destroyed(hex, building_id)

Step 3: Settlement HP. In GameState.gd:
  On SignalBus.skeleton_reached_center: call take_settlement_damage(10)
  On SignalBus.building_destroyed: call take_settlement_damage(5)
  func take_settlement_damage(amount):
    settlement_hp -= amount
    emit SignalBus.resource_changed("settlement_hp", settlement_hp)  (reuse signal)
    if settlement_hp <= 0: trigger game_over

Step 4: Settlement HP in HUD. Add a heart icon (RPG Tools Bits) + value label.
  On settlement_hp change: flash red, update label. 
  At 30 HP: label turns red and pulses.

Step 5: Wave cleared. On SignalBus.wave_cleared:
  - All surviving skeletons: die() immediately (they flee at dawn)
  - DayNightCycle transitions to DAWN
  - WaveAnnouncer shows kill count and losses
  - ResourceManager.add("gold", wave_number * 5) as a bonus reward

Step 6: Game Over screen. When settlement_hp reaches 0:
  - Pause tree (get_tree().paused = true)
  - Show RunSummary.tscn with: days survived, total skeletons killed, buildings built
  - "Try Again" button reloads Main.tscn, "Main Menu" loads MainMenu.tscn

Done when: A full night plays out — skeletons spawn, fight adventurers, damage 
buildings, and either the wave clears (DAWN triggers) or the settlement falls (game over).
```

---

## Milestone 7 — Tavern, Hiring & Merchant System

```
Implement the tavern hire screen and the merchant visit system.

Step 1: Implement TavernMenu.tscn:
  Triggered when player clicks a placed Tavern building during DAY phase.
  Opens as a full-screen overlay (dim background + centered panel).
  
  Interior layout using Furniture Bits props (rendered in a SubViewport for 3D feel):
  - Place bar counter, 2 stools, a table, candles in a small 3×2 unit space
  - Add 3 adventurer unit models sitting at the bar using Series 4/5 characters as patrons
  
  Hire panel (2D UI on top of viewport):
  - Show 3 randomly selected available unit types from DataLoader.units
  - For each: portrait icon (unit mesh rendered or use RPG Tools Bits equivalent), 
    name, stats (HP/ATK), hire cost in gold
  - "Hire" button: disabled if ResourceManager.can_afford fails
  - On hire: ResourceManager.spend("gold", cost), emit SignalBus.adventurer_hired(unit_data),
    add to GameState.adventurers pool, show "+1 Knight hired" floating text

Step 2: Adventurer assignment. After hiring, new adventurers need a building to work in.
  Show an assignment prompt: "Assign to building?" with a dropdown of placed buildings.
  On assignment: update GameState.adventurers entry, show unit walking to building.

Step 3: Implement MerchantSpawner.gd:
  On SignalBus.day_started(4) and day_started(6):
    Find a road-adjacent hex that has no building
    Spawn the merchant character (Series 4 on day 4, Series 5 on day 6)
    Character walks in from the map edge using PathfindingSystem
    When arrived: show floating shop icon (RPG Tools Bits icon above head using Label3D)
    Emit SignalBus.merchant_arrived(merchant_data from DataLoader.merchants)
    Merchant leaves 60 seconds before DUSK (walks back off map edge)

Step 4: Implement MerchantMenu.tscn:
  Triggered by clicking the merchant character.
  Shows 3 trade offers loaded from merchants.json:
    Offer 1: resource trade (exchange excess for needed)
    Offer 2: rare unit hire (unit not normally in tavern)
    Offer 3: relic purchase (from relics.json)
  Relics are shown with their RPG Tools Bits icon and description.
  On relic purchase: add to GameState.relics, show in a small relic bar in HUD.
  Apply relic effect immediately via effect_key (implement 3–4 effects for now).

Done when: Tavern opens, you can hire units, merchants appear on days 4 and 6, 
and relics appear in the HUD relic bar after purchase.
```

---

## Milestone 8 — Great Hall & Win Condition

```
Implement the Great Hall construction mechanic and win condition.

Step 1: Unlock Great Hall. In BuildingPlacer.gd:
  func is_great_hall_unlocked() -> bool:
    return GameState.day_number >= 7 and not GameState.is_great_hall_placed
  The Great Hall can only be placed on the center hex (Vector2i(7, 6)).
  Cost: wood=200, stone=100, iron=50, gold=50
  Show a special "Unlock Available" indicator on the center hex starting day 7.

Step 2: Great Hall construction is not instant — it takes 3 full days.
  Implement in GreatHall.gd extending Building.gd:
  @export var construction_progress: float = 0.0  (0.0 to 3.0 days)
  On each SignalBus.day_started: construction_progress += 1.0
  Visual: The Great Hall mesh starts at scale (0.3, 0.3, 0.3) and grows to (1, 1, 1)
    as progress increases. Use a tween at each day_started.
  Show a construction progress bar above the building.
  On construction_progress >= 3.0: emit "great_hall_completed" on SignalBus, trigger win.

Step 3: Skeletons prioritize Great Hall on nights 8–9.
  In Skeleton.gd: 
    if GameState.is_great_hall_placed and GameState.day_number >= 8:
      target = great_hall_hex  (read from GameState)
    else:
      target = center_hex

Step 4: Siege Night (Day 10).
  In DayNightCycle.gd: on night_started with day_number == 10:
    Set GameState.siege_night = true
    WaveSpawner reads the "10" entry from waves.json (the massive siege entry)
    Before wave starts: play a dramatic camera zoom-out + red vignette effect
    WaveAnnouncer shows: "THE SKELETON KING MARCHES. HOLD THE LINE."

Step 5: Skeleton King. Implement SkeletonKing.gd extending Skeleton.gd:
  On death: spawn 3 basic skeletons at its current hex
  Has an aura: skeletons within 3 hex tiles move 30% faster
  Play a loud audio bark on spawn and death.

Step 6: Win screen. On "great_hall_completed" signal:
  Show RunSummary.tscn in "win" mode:
  "Great Hall Complete! You survived [N] nights."
  Show: total skeletons killed, buildings at time of victory, adventurers alive.
  Fireworks particle effect using a CPUParticles3D node.

Done when: Great Hall unlocks on day 7, construction takes 3 days with visual 
progress, siege triggers on night 10 with Skeleton King, and winning triggers 
the celebration screen.
```

---

## Milestone 9 — Polish, Audio & Game Feel

```
Add the polish layer that makes Holdfast feel complete and alive.

Step 1: Camera feel improvements in CameraController.gd:
  - Smooth follow with lerp (lag=0.1) instead of hard-locking
  - Edge-scroll: if mouse is within 40px of screen edge, pan camera
  - Scroll wheel zoom: clamp between 8 and 25 units height
  - Camera shake function: shake(intensity: float, duration: float)
    Used on: skeleton_reached_center (intensity=0.8), building_destroyed (intensity=0.5)

Step 2: Resource feedback animations:
  - FloatingText.tscn: a Label3D that drifts upward 1.5 units over 1 second then fades
  - Used for: +X wood on production tick (green), -X wood on build (red/orange),
    +X gold on wave clear (gold colored), "Skeleton!" when one reaches center (red, larger)
  - Spawn from the relevant tile position

Step 3: Tile hover effects:
  - When mouse hovers a tile, scale it up slightly (1.0 → 1.05) and show 
    an outline (use a slightly larger flat hex mesh slightly below, brighter color)
  - Hovering a building shows Tooltip.tscn: building name, current HP, 
    assigned workers, production rate. Use RPG Tools Bits icons.
  - Hovering an empty tile during day shows ghost preview of selected building 
    (transparent mesh, green if placeable, red if not)

Step 4: Building placement feedback:
  - On successful placement: scale-up tween from 0.0 to 1.0 over 0.4s with 
    EASE_OUT bounce
  - Spawn 8 small Resource Bits wood/stone props that fly outward and fall 
    (simulating construction debris)

Step 5: Windmill animation. In Building.gd or a dedicated WindmillBuilding.gd:
  Get the blade mesh node (should be a separate child node in the windmill .glb).
  Rotate it continuously at 45°/second during DAY phase.
  Slow to stop during NIGHT.

Step 6: Atmospheric ambient details:
  - Forest tiles: add subtle idle animation to Forest Nature Pack trees 
    (gentle Y-axis sway using a Tween that loops with slight random offsets)
  - Night phase: add a moving fog plane mesh (a large flat quad with a 
    scrolling semi-transparent material) drifting across the map at low altitude
  - Halloween Bits jack-o-lanterns: add a PointLight3D child to each with 
    energy that flickers (random tween between 0.8 and 1.4 every 0.3–0.7 seconds)

Step 7: Audio setup (using placeholder AudioStreamPlayers until real audio added):
  - Implement AudioManager.gd autoload with named slots
  - DAY ambience: birds + wind (loop)
  - NIGHT ambience: crickets + distant howl (loop)  
  - SFX: building_placed, unit_attack, unit_death, skeleton_spawn, 
    wave_cleared, settlement_damaged
  - All volumes configurable from a Settings menu stub

Done when: The game feels polished — placement has satisfying feedback, 
the world feels alive with movement and light, and transitions are smooth.
```

---

## Milestone 10 — Main Menu, Save & Release Prep

```
Wire up the final pieces: main menu, settings, and verify everything connects end-to-end.

Step 1: MainMenu.tscn. 
  A 3D background showing a pre-built hex map settlement (place some buildings 
  procedurally using the same Medieval Hexagon assets). Slowly rotate the camera.
  UI overlay: "HEARTHFALL" title (styled Label), "New Game", "Settings", "Quit".
  New Game: loads Main.tscn and starts a fresh run.

Step 2: Settings menu stub. A panel accessible from Main Menu and from HUD:
  - Master volume slider (affects AudioManager)
  - Camera edge scroll: On/Off toggle
  - Show tooltips: On/Off
  Save settings to a simple .cfg file using ConfigFile.

Step 3: End-to-end run test. Play through nights 1–3 manually and verify:
  □ Day timer counts correctly
  □ Buildings produce resources on tick
  □ Wave spawns correct skeleton types and counts per waves.json  
  □ Combat resolves correctly (damage numbers match units.json)
  □ Wave clear triggers DAWN correctly
  □ Great Hall unlocks on day 7
  □ All signals in SignalBus.gd are actually being emitted by at least one system
  □ No orphaned nodes (check Remote Inspector during play)
  □ No GDScript errors in Output panel

Step 4: Asset audit. Run this check:
  - List every key in AssetRegistry.MESHES
  - Verify each path actually exists on disk using FileAccess.file_exists()
  - Print any broken paths as errors
  Fix any mismatched filenames discovered during the audit.

Step 5: Performance pass. In Debug.tscn:
  - Place all 11 building types simultaneously
  - Spawn 50 skeletons simultaneously
  - Enable Godot profiler and check: target 60fps, draw calls < 500
  - If over budget: enable MultiMesh for repeated hex tiles (grass tiles especially)
  - Ensure all building meshes share the single KayKit atlas texture (they should by default)

Done when: A complete run from Main Menu through night 10 plays without errors, 
the game can be won and lost, and performance is stable.
```

---

## Bonus: One-Shot Utility Prompts

Use these at any point during development when you need a specific thing fixed or added.

**Fix broken asset paths:**
```
Read res://assets/kaykit/ recursively. Read AssetRegistry.gd. Find every MESHES 
entry where the path does not exist on disk. For each broken path, search the 
kaykit folder for a filename that closely matches the key name and suggest 
the correct path. Update AssetRegistry.gd with confirmed matches.
```

**Add a new building:**
```
Add a new building type to Holdfast: [BUILDING NAME].
1. Add a complete entry to buildings.json following the existing schema.
2. Add its mesh_key to AssetRegistry.gd (find the correct .glb in medieval_hexagon/).
3. Create [BuildingName].tscn in res://entities/buildings/ extending Building.tscn.
4. Set all @export variables from the JSON entry.
5. Add a button for it in BuildPanel.tscn.
6. Test in Debug.tscn that it can be placed and produces/behaves correctly.
```

**Balance a wave:**
```
Night [N] is too hard/easy. Read waves.json entry "[N]" and units.json for all 
referenced unit types. Adjust the wave to [description of desired difficulty] 
by modifying skeleton counts and types. Explain the changes you made and why 
they achieve the target difficulty. Only edit waves.json.
```

**Add a new relic:**
```
Add a new relic: [RELIC NAME] — [EFFECT DESCRIPTION].
1. Add entry to relics.json with a unique effect_key.
2. In GameState.gd or the relevant system, implement the effect_key handler.
3. Add an icon reference in AssetRegistry.gd using an RPG Tools Bits icon.
4. Verify it appears in MerchantMenu and applies correctly when purchased.
```

**Debug a signal:**
```
SignalBus.[signal_name] doesn't seem to be working correctly. 
1. Find everywhere it is emitted in the codebase.
2. Find everywhere it is connected in the codebase.
3. Add temporary print() calls to confirm emission and reception.
4. Identify the root cause and fix it.
5. Remove the debug prints when done.
```
```
