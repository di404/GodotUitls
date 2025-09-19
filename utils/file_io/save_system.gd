##
## SaveSystem - Save/Load Game Data Management
## 游戏数据保存/加载管理系统
##
## A modular system for handling game data persistence
## 用于处理游戏数据持久化的模块化系统
##

class_name SaveSystem
extends RefCounted

## Save file encryption key / 保存文件加密密钥
static var encryption_key: String = "default_key_change_this"

## Default save directory / 默认保存目录
static var save_directory: String = "user://saves/"

## Save data to file / 保存数据到文件
static func save_data(filename: String, data: Dictionary, encrypt: bool = false) -> bool:
	# Ensure save directory exists / 确保保存目录存在
	if not DirAccess.dir_exists_absolute(save_directory):
		DirAccess.open("user://").make_dir_recursive(save_directory)
	
	var file_path = save_directory + filename + ".save"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if not file:
		push_error("SaveSystem: Failed to open file for writing: " + file_path)
		return false
	
	var json_data = JSON.stringify(data)
	
	if encrypt:
		file.store_var(json_data, true)
		file.store_string(encryption_key)
	else:
		file.store_string(json_data)
	
	file.close()
	print("SaveSystem: Data saved to " + file_path)
	return true

## Load data from file / 从文件加载数据
static func load_data(filename: String, decrypt: bool = false) -> Dictionary:
	var file_path = save_directory + filename + ".save"
	
	if not FileAccess.file_exists(file_path):
		push_warning("SaveSystem: Save file not found: " + file_path)
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		push_error("SaveSystem: Failed to open file for reading: " + file_path)
		return {}
	
	var json_data: String
	
	if decrypt:
		json_data = file.get_var(true)
		var stored_key = file.get_string()
		if stored_key != encryption_key:
			push_error("SaveSystem: Invalid encryption key")
			file.close()
			return {}
	else:
		json_data = file.get_as_text()
	
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_data)
	
	if parse_result != OK:
		push_error("SaveSystem: Failed to parse JSON data")
		return {}
	
	print("SaveSystem: Data loaded from " + file_path)
	return json.data

## Delete save file / 删除保存文件
static func delete_save(filename: String) -> bool:
	var file_path = save_directory + filename + ".save"
	
	if not FileAccess.file_exists(file_path):
		push_warning("SaveSystem: Save file not found: " + file_path)
		return false
	
	var dir = DirAccess.open(save_directory)
	var result = dir.remove(filename + ".save")
	
	if result == OK:
		print("SaveSystem: Save file deleted: " + file_path)
		return true
	else:
		push_error("SaveSystem: Failed to delete save file: " + file_path)
		return false

## Check if save file exists / 检查保存文件是否存在
static func save_exists(filename: String) -> bool:
	var file_path = save_directory + filename + ".save"
	return FileAccess.file_exists(file_path)

## Get list of all save files / 获取所有保存文件列表
static func get_save_list() -> Array:
	var saves = []
	var dir = DirAccess.open(save_directory)
	
	if not dir:
		return saves
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".save"):
			saves.append(file_name.replace(".save", ""))
		file_name = dir.get_next()
	
	return saves

## Get save file metadata / 获取保存文件元数据
static func get_save_metadata(filename: String) -> Dictionary:
	var file_path = save_directory + filename + ".save"
	
	if not FileAccess.file_exists(file_path):
		return {}
	
	var file_time = FileAccess.get_modified_time(file_path)
	var file = FileAccess.open(file_path, FileAccess.READ)
	var file_size = file.get_length() if file else 0
	if file:
		file.close()
	
	return {
		"filename": filename,
		"file_path": file_path,
		"modified_time": file_time,
		"size": file_size,
		"exists": true
	}

## Auto-save data at intervals / 定时自动保存数据
static func setup_auto_save(data_provider: Callable, interval: float = 300.0) -> void:
	var tree = Engine.get_main_loop() as SceneTree
	if not tree:
		return
	
	var timer = Timer.new()
	timer.wait_time = interval
	timer.timeout.connect(_auto_save.bind(data_provider))
	timer.autostart = true
	tree.current_scene.add_child(timer)

## Auto-save callback / 自动保存回调
static func _auto_save(data_provider: Callable) -> void:
	var data = data_provider.call()
	if data is Dictionary:
		save_data("auto_save", data)
		print("SaveSystem: Auto-save completed")

## Backup save file / 备份保存文件
static func backup_save(filename: String) -> bool:
	var source_path = save_directory + filename + ".save"
	var backup_path = save_directory + filename + "_backup.save"
	
	if not FileAccess.file_exists(source_path):
		return false
	
	var source_file = FileAccess.open(source_path, FileAccess.READ)
	var backup_file = FileAccess.open(backup_path, FileAccess.WRITE)
	
	if not source_file or not backup_file:
		return false
	
	backup_file.store_buffer(source_file.get_buffer(source_file.get_length()))
	
	source_file.close()
	backup_file.close()
	
	print("SaveSystem: Backup created for " + filename)
	return true

## Restore from backup / 从备份恢复
static func restore_from_backup(filename: String) -> bool:
	var backup_path = save_directory + filename + "_backup.save"
	var target_path = save_directory + filename + ".save"
	
	if not FileAccess.file_exists(backup_path):
		return false
	
	var backup_file = FileAccess.open(backup_path, FileAccess.READ)
	var target_file = FileAccess.open(target_path, FileAccess.WRITE)
	
	if not backup_file or not target_file:
		return false
	
	target_file.store_buffer(backup_file.get_buffer(backup_file.get_length()))
	
	backup_file.close()
	target_file.close()
	
	print("SaveSystem: Restored from backup for " + filename)
	return true