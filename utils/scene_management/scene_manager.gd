##
## SceneManager - Scene Loading and Transition Utilities
## 场景加载和转换工具
##
## A comprehensive system for managing scene transitions, preloading, and caching
## 用于管理场景转换、预加载和缓存的综合系统
##

class_name SceneManager
extends RefCounted

## Scene loading states / 场景加载状态
enum LoadingState {
	NOT_LOADED,    ## 未加载
	LOADING,       ## 正在加载
	LOADED,        ## 已加载
	ERROR          ## 错误
}

## Scene cache for preloaded scenes / 预加载场景缓存
static var scene_cache: Dictionary = {}

## Current loading operations / 当前加载操作
static var loading_operations: Dictionary = {}

## Scene loading progress callbacks / 场景加载进度回调
static var loading_callbacks: Dictionary = {}

## Preload a scene for faster access / 预加载场景以便快速访问
static func preload_scene(scene_path: String, callback: Callable = Callable()) -> void:
	if scene_cache.has(scene_path):
		if callback.is_valid():
			callback.call(scene_cache[scene_path])
		return
	
	if loading_operations.has(scene_path):
		# Already loading, add to callback list
		if not loading_callbacks.has(scene_path):
			loading_callbacks[scene_path] = []
		if callback.is_valid():
			loading_callbacks[scene_path].append(callback)
		return
	
	loading_operations[scene_path] = LoadingState.LOADING
	loading_callbacks[scene_path] = []
	if callback.is_valid():
		loading_callbacks[scene_path].append(callback)
	
	# Start async loading
	ResourceLoader.load_threaded_request(scene_path)
	_check_loading_progress(scene_path)

## Check loading progress / 检查加载进度
static func _check_loading_progress(scene_path: String) -> void:
	var tree = Engine.get_main_loop() as SceneTree
	if not tree:
		return
	
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(_update_loading_progress.bind(scene_path, timer))
	tree.current_scene.add_child(timer)
	timer.start()

## Update loading progress / 更新加载进度
static func _update_loading_progress(scene_path: String, timer: Timer) -> void:
	var status = ResourceLoader.load_threaded_get_status(scene_path)
	
	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			var resource = ResourceLoader.load_threaded_get(scene_path)
			scene_cache[scene_path] = resource
			loading_operations[scene_path] = LoadingState.LOADED
			
			# Call all callbacks
			if loading_callbacks.has(scene_path):
				for callback in loading_callbacks[scene_path]:
					if callback.is_valid():
						callback.call(resource)
				loading_callbacks.erase(scene_path)
			
			loading_operations.erase(scene_path)
			timer.queue_free()
			print("SceneManager: Scene preloaded successfully: " + scene_path)
		
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading_operations[scene_path] = LoadingState.ERROR
			push_error("SceneManager: Failed to preload scene: " + scene_path)
			
			if loading_callbacks.has(scene_path):
				loading_callbacks.erase(scene_path)
			loading_operations.erase(scene_path)
			timer.queue_free()

## Get cached scene / 获取缓存场景
static func get_cached_scene(scene_path: String) -> PackedScene:
	return scene_cache.get(scene_path, null)

## Check if scene is cached / 检查场景是否已缓存
static func is_scene_cached(scene_path: String) -> bool:
	return scene_cache.has(scene_path)

## Remove scene from cache / 从缓存中移除场景
static func uncache_scene(scene_path: String) -> void:
	if scene_cache.has(scene_path):
		scene_cache.erase(scene_path)
		print("SceneManager: Scene removed from cache: " + scene_path)

## Clear all cached scenes / 清除所有缓存场景
static func clear_cache() -> void:
	scene_cache.clear()
	print("SceneManager: All cached scenes cleared")

## Change scene with preloading support / 支持预加载的场景切换
static func change_scene_cached(scene_path: String, use_cache: bool = true) -> void:
	var tree = Engine.get_main_loop() as SceneTree
	if not tree:
		return
	
	if use_cache and scene_cache.has(scene_path):
		var scene_resource = scene_cache[scene_path] as PackedScene
		if scene_resource:
			tree.change_scene_to_packed(scene_resource)
			print("SceneManager: Changed to cached scene: " + scene_path)
			return
	
	# Fallback to normal loading
	var error = tree.change_scene_to_file(scene_path)
	if error != OK:
		push_error("SceneManager: Failed to change scene: " + scene_path)

## Preload multiple scenes / 预加载多个场景
static func preload_scenes(scene_paths: Array, callback: Callable = Callable()) -> void:
	var remaining_scenes = scene_paths.duplicate()
	var loaded_scenes = {}
	
	var check_completion = func():
		if remaining_scenes.is_empty():
			if callback.is_valid():
				callback.call(loaded_scenes)
	
	for scene_path in scene_paths:
		preload_scene(scene_path, func(resource):
			loaded_scenes[scene_path] = resource
			remaining_scenes.erase(scene_path)
			check_completion.call()
		)

## Get loading state of a scene / 获取场景的加载状态
static func get_loading_state(scene_path: String) -> LoadingState:
	if scene_cache.has(scene_path):
		return LoadingState.LOADED
	elif loading_operations.has(scene_path):
		return loading_operations[scene_path]
	else:
		return LoadingState.NOT_LOADED

## Create scene instance from cache / 从缓存创建场景实例
static func instantiate_cached_scene(scene_path: String) -> Node:
	if not scene_cache.has(scene_path):
		push_error("SceneManager: Scene not in cache: " + scene_path)
		return null
	
	var scene_resource = scene_cache[scene_path] as PackedScene
	if scene_resource:
		return scene_resource.instantiate()
	
	return null

## Get cache memory usage (approximate) / 获取缓存内存使用情况（大概）
static func get_cache_memory_usage() -> Dictionary:
	var total_size = 0
	var scene_count = scene_cache.size()
	
	# This is an approximation as Godot doesn't provide exact memory usage
	for scene_path in scene_cache:
		var resource = scene_cache[scene_path]
		if resource:
			total_size += 1  # Placeholder - actual size calculation would be complex
	
	return {
		"scene_count": scene_count,
		"estimated_size_mb": total_size,
		"cached_scenes": scene_cache.keys()
	}

## Smart preloader that preloads scenes based on current scene / 基于当前场景智能预加载器
static func smart_preload(current_scene_path: String, preload_map: Dictionary) -> void:
	if preload_map.has(current_scene_path):
		var scenes_to_preload = preload_map[current_scene_path]
		if scenes_to_preload is Array:
			for scene_path in scenes_to_preload:
				if not is_scene_cached(scene_path):
					preload_scene(scene_path)
					print("SceneManager: Smart preloading: " + scene_path)