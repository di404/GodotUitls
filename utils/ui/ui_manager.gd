##
## UIManager - UI and Scene Management Utilities
## UI和场景管理工具
##
## A modular utility for managing UI elements and scene transitions in Godot
## 用于在Godot中管理UI元素和场景转换的模块化工具
##

class_name UIManager
extends RefCounted

## Scene transition types / 场景转换类型
enum TransitionType {
	NONE,      ## 无转换
	FADE,      ## 淡入淡出
	SLIDE,     ## 滑动
	SCALE,     ## 缩放
	WIPE       ## 擦除
}

## Singleton instance / 单例实例
static var instance: UIManager

## Current scene reference / 当前场景引用
static var current_scene: Node

## Get or create singleton instance / 获取或创建单例实例
static func get_instance() -> UIManager:
	if not instance:
		instance = UIManager.new()
	return instance

## Initialize the UI Manager with the scene tree / 使用场景树初始化UI管理器
static func initialize(scene_tree: SceneTree) -> void:
	current_scene = scene_tree.current_scene

## Transition to a new scene / 转换到新场景
static func transition_to_scene(scene_path: String, transition: TransitionType = TransitionType.FADE, duration: float = 0.5) -> void:
	var scene_tree = Engine.get_main_loop() as SceneTree
	if not scene_tree:
		push_error("UIManager: SceneTree not available")
		return
	
	match transition:
		TransitionType.FADE:
			await _fade_transition(scene_tree, scene_path, duration)
		TransitionType.SLIDE:
			await _slide_transition(scene_tree, scene_path, duration)
		TransitionType.SCALE:
			await _scale_transition(scene_tree, scene_path, duration)
		TransitionType.WIPE:
			await _wipe_transition(scene_tree, scene_path, duration)
		_:
			_change_scene_direct(scene_tree, scene_path)

## Direct scene change without transition / 无转换直接切换场景
static func _change_scene_direct(scene_tree: SceneTree, scene_path: String) -> void:
	var error = scene_tree.change_scene_to_file(scene_path)
	if error != OK:
		push_error("UIManager: Failed to load scene: " + scene_path)

## Fade transition effect / 淡入淡出转换效果
static func _fade_transition(scene_tree: SceneTree, scene_path: String, duration: float) -> void:
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.modulate.a = 0.0
	scene_tree.current_scene.add_child(overlay)
	
	# Fade out / 淡出
	var tween = scene_tree.create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, duration * 0.5)
	await tween.finished
	
	# Change scene / 切换场景
	_change_scene_direct(scene_tree, scene_path)
	
	# Fade in / 淡入
	if scene_tree.current_scene:
		scene_tree.current_scene.add_child(overlay)
		tween = scene_tree.create_tween()
		tween.tween_property(overlay, "modulate:a", 0.0, duration * 0.5)
		await tween.finished
		overlay.queue_free()

## Slide transition effect / 滑动转换效果
static func _slide_transition(scene_tree: SceneTree, scene_path: String, duration: float) -> void:
	var viewport_size = scene_tree.root.get_visible_rect().size
	var current = scene_tree.current_scene
	
	var tween = scene_tree.create_tween()
	tween.tween_property(current, "position", Vector2(-viewport_size.x, 0), duration)
	await tween.finished
	
	_change_scene_direct(scene_tree, scene_path)

## Scale transition effect / 缩放转换效果
static func _scale_transition(scene_tree: SceneTree, scene_path: String, duration: float) -> void:
	var current = scene_tree.current_scene
	
	var tween = scene_tree.create_tween()
	tween.parallel().tween_property(current, "scale", Vector2.ZERO, duration)
	tween.parallel().tween_property(current, "modulate:a", 0.0, duration)
	await tween.finished
	
	_change_scene_direct(scene_tree, scene_path)

## Wipe transition effect / 擦除转换效果
static func _wipe_transition(scene_tree: SceneTree, scene_path: String, duration: float) -> void:
	var viewport_size = scene_tree.root.get_visible_rect().size
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.size = Vector2(0, viewport_size.y)
	overlay.position = Vector2(0, 0)
	scene_tree.current_scene.add_child(overlay)
	
	var tween = scene_tree.create_tween()
	tween.tween_property(overlay, "size:x", viewport_size.x, duration * 0.5)
	await tween.finished
	
	_change_scene_direct(scene_tree, scene_path)
	
	if scene_tree.current_scene:
		overlay.position.x = 0
		overlay.size.x = viewport_size.x
		scene_tree.current_scene.add_child(overlay)
		tween = scene_tree.create_tween()
		tween.tween_property(overlay, "position:x", viewport_size.x, duration * 0.5)
		await tween.finished
		overlay.queue_free()

## Show notification popup / 显示通知弹窗
static func show_notification(text: String, duration: float = 2.0, position: Vector2 = Vector2.ZERO) -> void:
	var scene_tree = Engine.get_main_loop() as SceneTree
	if not scene_tree or not scene_tree.current_scene:
		return
	
	var notification = Label.new()
	notification.text = text
	notification.add_theme_color_override("font_color", Color.WHITE)
	notification.add_theme_color_override("font_shadow_color", Color.BLACK)
	notification.add_theme_constant_override("shadow_offset_x", 2)
	notification.add_theme_constant_override("shadow_offset_y", 2)
	
	if position == Vector2.ZERO:
		notification.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	else:
		notification.position = position
	
	scene_tree.current_scene.add_child(notification)
	notification.modulate.a = 0.0
	
	var tween = scene_tree.create_tween()
	tween.tween_property(notification, "modulate:a", 1.0, 0.3)
	tween.tween_delay(duration - 0.6)
	tween.tween_property(notification, "modulate:a", 0.0, 0.3)
	await tween.finished
	notification.queue_free()

## Animate control with predefined animations / 使用预定义动画为控件添加动画
static func animate_control(control: Control, animation: String, duration: float = 0.5) -> void:
	var tween = control.create_tween()
	
	match animation:
		"bounce_in":
			control.scale = Vector2.ZERO
			control.modulate.a = 0.0
			tween.parallel().tween_property(control, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_BACK)
			tween.parallel().tween_property(control, "modulate:a", 1.0, duration)
		"slide_in_left":
			var original_pos = control.position
			control.position.x -= control.size.x
			tween.tween_property(control, "position", original_pos, duration).set_trans(Tween.TRANS_QUART)
		"fade_in":
			control.modulate.a = 0.0
			tween.tween_property(control, "modulate:a", 1.0, duration)
		"pulse":
			var original_scale = control.scale
			tween.tween_property(control, "scale", original_scale * 1.1, duration * 0.5)
			tween.tween_property(control, "scale", original_scale, duration * 0.5)