# Holdfast — Claude Code Project Instructions

## Project Overview
Holdfast is a hex-based medieval settlement survival game built in Godot 4.6.
Players build a settlement by day and defend it from skeleton waves by night.
Win condition: Complete the Great Hall (3 days of construction) before night 10's siege.

## Tech Stack
- Godot 4.6 (GDScript, Forward Plus rendering)
- Jolt Physics 3D (used for Area3D click detection and CharacterBody3D merchants)
- KayKit 3D assets (CC0 licensed) — located in res://assets/kaykit/
- Unit/camera movement is tween-based and grid-based (no rigidbody physics)
- No external plugins required

## Asset Rules — CRITICAL
- NEVER hardcode asset file paths in scripts.
- ALL asset references go through AssetRegistry.gd using string keys.
- If you need a new asset, add its key+path to AssetRegistry.gd FIRST, then use the key.
- To discover actual filenames: read the directory tree under res://assets/kaykit/
- **File formats vary by pack:** Most packs use `.gltf` + `.bin` pairs. Adventurers 2.0,
  Skeletons 1.1, and Character Animations 1.1 use `.glb`. Always check the actual extension.
- **Directory names have full KayKit names** (e.g., `KayKit Medieval Hexagon Pack 1.0.1/`,
  NOT `medieval_hexagon/`). Use the exact directory names from disk.

## Architecture Rules
- ALL signals are declared in SignalBus.gd (autoload). No direct method calls between systems.
- ALL game data comes from JSON files in res://data/. No hardcoded stats or values.
- HexGrid.gd is a pure utility class (class_name HexGrid). No @onready, no nodes.
- Each system in res://systems/ does ONE thing. Keep them decoupled.
- Buildings extend Building.gd via ProductionBuilding.gd or MilitaryBuilding.gd.
- Units extend Unit.gd via Adventurer.gd or Skeleton.gd.
- Use typed arrays and return types everywhere.

## Code Style
- GDScript with static typing everywhere (var x: int, func foo() -> void:)
- Tabs for indentation (Godot default)
- snake_case for variables/functions, PascalCase for classes
- Assert for programmer errors, push_warning for recoverable issues
- No @tool scripts unless specifically needed for editor previews

## Autoload Order (project.godot)
1. SignalBus — must be first (others connect to its signals)
2. GameState
3. AssetRegistry
4. DataLoader
5. ResourceManager

## Key File Locations
- Autoloads: res://autoloads/
- Data JSON: res://data/
- Systems: res://systems/
- World/Map: res://world/
- Entities: res://entities/buildings/, res://entities/units/, res://entities/props/
- UI: res://ui/
- Scenes: res://scenes/
- Assets: res://assets/kaykit/

## Testing
- Debug.tscn is the test scene for isolated system testing
- Run with: Main scene set to res://scenes/Debug.tscn in project.godot
- Print to Output panel for debugging, not to UI (except DebugOverlay)
