##
## GodotUtils - Main Utility Loader
## GodotUtils主工具加载器
##
## This script can be used as an autoload to initialize all GodotUtils
## 此脚本可用作自动加载以初始化所有GodotUtils
##

extends Node

## Version information / 版本信息
const VERSION = "1.0.0"
const AUTHOR = "GodotUtils Community"

## Utility references / 工具引用
var ui_manager: UIManager
var debug_console: DebugConsole

## Initialize all utilities / 初始化所有工具
func _ready():
	print("GodotUtils v%s initializing..." % VERSION)
	
	# Initialize UIManager
	ui_manager = UIManager.get_instance()
	UIManager.initialize(get_tree())
	
	# Add debug console to the scene tree (optional)
	if OS.is_debug_build():
		debug_console = DebugConsole.new()
		add_child(debug_console)
	
	print("GodotUtils initialization complete!")

## Get utility instances / 获取工具实例
func get_ui_manager() -> UIManager:
	return ui_manager

func get_debug_console() -> DebugConsole:
	return debug_console

## Quick access functions / 快速访问函数

## UI Functions / UI函数
func transition_to_scene(scene_path: String, transition_type = UIManager.TransitionType.FADE, duration: float = 0.5):
	UIManager.transition_to_scene(scene_path, transition_type, duration)

func show_notification(text: String, duration: float = 2.0, position: Vector2 = Vector2.ZERO):
	UIManager.show_notification(text, duration, position)

func animate_control(control: Control, animation: String, duration: float = 0.5):
	UIManager.animate_control(control, animation, duration)

## Math Functions / 数学函数
func smooth_step_custom(from: float, to: float, weight: float, curve_power: float = 1.0) -> float:
	return MathHelper.smooth_step_custom(from, to, weight, curve_power)

func point_in_circle(point: Vector2, circle_center: Vector2, radius: float) -> bool:
	return MathHelper.point_in_circle(point, circle_center, radius)

func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	return MathHelper.random_point_in_circle(center, radius)

## Save Functions / 保存函数
func save_data(filename: String, data: Dictionary, encrypt: bool = false) -> bool:
	return SaveSystem.save_data(filename, data, encrypt)

func load_data(filename: String, decrypt: bool = false) -> Dictionary:
	return SaveSystem.load_data(filename, decrypt)

func save_exists(filename: String) -> bool:
	return SaveSystem.save_exists(filename)

## Scene Management Functions / 场景管理函数
func preload_scene(scene_path: String, callback: Callable = Callable()):
	SceneManager.preload_scene(scene_path, callback)

func change_scene_cached(scene_path: String, use_cache: bool = true):
	SceneManager.change_scene_cached(scene_path, use_cache)

func is_scene_cached(scene_path: String) -> bool:
	return SceneManager.is_scene_cached(scene_path)

## Debug Functions / 调试函数
func log_debug(message: String, color: Color = Color.WHITE):
	if debug_console:
		debug_console.log(message, color)

func register_debug_command(name: String, function: Callable, description: String = ""):
	DebugConsole.register_command(name, function, description)

## Utility information / 工具信息
func get_version() -> String:
	return VERSION

func get_loaded_utilities() -> Array:
	return [
		"UIManager",
		"MathHelper", 
		"SaveSystem",
		"SceneManager",
		"DebugConsole" if debug_console else "DebugConsole (disabled in release)"
	]

func print_utility_info():
	print("=== GodotUtils v%s ===" % VERSION)
	print("Available utilities:")
	for utility in get_loaded_utilities():
		print("  - %s" % utility)
	print("========================")