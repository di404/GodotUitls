##
## DebugConsole - In-Game Debug Console
## 游戏内调试控制台
##
## A powerful in-game debug console for development and testing
## 用于开发和测试的强大游戏内调试控制台
##

class_name DebugConsole
extends CanvasLayer

## Console visibility / 控制台可见性
var is_visible: bool = false

## Console UI elements / 控制台UI元素
var console_panel: Panel
var output_label: RichTextLabel
var input_field: LineEdit
var command_history: Array[String] = []
var history_index: int = -1

## Registered commands / 注册的命令
var commands: Dictionary = {}

## Console output / 控制台输出
var console_output: String = ""

## Singleton instance / 单例实例
static var instance: DebugConsole

## Initialize debug console / 初始化调试控制台
func _init():
	instance = self
	_setup_ui()
	_register_default_commands()

## Setup console UI / 设置控制台UI
func _setup_ui():
	# Main panel / 主面板
	console_panel = Panel.new()
	console_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	console_panel.modulate.a = 0.9
	console_panel.visible = false
	add_child(console_panel)
	
	# Layout container / 布局容器
	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 4)
	console_panel.add_child(vbox)
	
	# Output area / 输出区域
	output_label = RichTextLabel.new()
	output_label.fit_content = true
	output_label.scroll_following = true
	output_label.bbcode_enabled = true
	output_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(output_label)
	
	# Input field / 输入框
	input_field = LineEdit.new()
	input_field.placeholder_text = "Enter command..."
	input_field.text_submitted.connect(_on_command_submitted)
	vbox.add_child(input_field)
	
	# Style the console / 设置控制台样式
	_apply_console_style()

## Apply console styling / 应用控制台样式
func _apply_console_style():
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0, 0, 0, 0.8)
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	style_box.border_width_top = 2
	style_box.border_width_bottom = 2
	style_box.border_color = Color(0.3, 0.3, 0.3, 1.0)
	console_panel.add_theme_stylebox_override("panel", style_box)

## Handle input events / 处理输入事件
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1:  # Toggle console with F1 / 用F1切换控制台
				toggle_console()
			KEY_UP when is_visible and input_field.has_focus():
				_navigate_history(-1)
			KEY_DOWN when is_visible and input_field.has_focus():
				_navigate_history(1)

## Toggle console visibility / 切换控制台可见性
func toggle_console():
	is_visible = !is_visible
	console_panel.visible = is_visible
	if is_visible:
		input_field.grab_focus()
	get_viewport().set_input_as_handled()

## Navigate command history / 浏览命令历史
func _navigate_history(direction: int):
	if command_history.is_empty():
		return
	
	history_index = clamp(history_index + direction, -1, command_history.size() - 1)
	
	if history_index >= 0:
		input_field.text = command_history[history_index]
		input_field.caret_column = input_field.text.length()
	else:
		input_field.text = ""

## Handle command submission / 处理命令提交
func _on_command_submitted(command_text: String):
	if command_text.strip_edges().is_empty():
		return
	
	# Add to history / 添加到历史记录
	if command_history.is_empty() or command_history[-1] != command_text:
		command_history.append(command_text)
	history_index = -1
	
	# Log command / 记录命令
	log_command(command_text)
	
	# Execute command / 执行命令
	execute_command(command_text)
	
	# Clear input / 清除输入
	input_field.text = ""

## Log command to console / 将命令记录到控制台
func log_command(command: String):
	log("> " + command, Color.YELLOW)

## Execute command / 执行命令
func execute_command(command_text: String):
	var parts = command_text.split(" ", false)
	if parts.is_empty():
		return
	
	var command_name = parts[0].to_lower()
	var args = parts.slice(1)
	
	if commands.has(command_name):
		var command_func = commands[command_name]
		if command_func is Callable:
			command_func.call(args)
		else:
			log("Error: Invalid command function", Color.RED)
	else:
		log("Unknown command: " + command_name, Color.RED)
		log("Type 'help' for available commands", Color.CYAN)

## Register a new command / 注册新命令
static func register_command(name: String, function: Callable, description: String = ""):
	if instance:
		instance.commands[name.to_lower()] = function
		instance.log("Command registered: " + name, Color.GREEN)

## Log message to console / 向控制台记录消息
func log(message: String, color: Color = Color.WHITE):
	var timestamp = Time.get_datetime_string_from_system().split("T")[1].substr(0, 8)
	var formatted_message = "[color=#%s][%s] %s[/color]\n" % [color.to_html(), timestamp, message]
	console_output += formatted_message
	
	if output_label:
		output_label.append_text(formatted_message)
		
		# Limit output length / 限制输出长度
		if console_output.length() > 10000:
			var lines = console_output.split("\n")
			lines = lines.slice(-100)  # Keep last 100 lines
			console_output = "\n".join(lines)
			output_label.clear()
			output_label.append_text(console_output)

## Register default commands / 注册默认命令
func _register_default_commands():
	# Help command / 帮助命令
	commands["help"] = func(args):
		log("Available commands:", Color.CYAN)
		for cmd_name in commands.keys():
			log("  " + cmd_name, Color.WHITE)
	
	# Clear command / 清除命令
	commands["clear"] = func(args):
		console_output = ""
		if output_label:
			output_label.clear()
		log("Console cleared", Color.GREEN)
	
	# Quit command / 退出命令
	commands["quit"] = func(args):
		log("Quitting application...", Color.YELLOW)
		get_tree().quit()
	
	# FPS command / FPS命令
	commands["fps"] = func(args):
		log("Current FPS: " + str(Engine.get_frames_per_second()), Color.CYAN)
	
	# Memory command / 内存命令
	commands["memory"] = func(args):
		var memory_usage = OS.get_static_memory_usage()
		log("Memory usage: " + str(memory_usage / 1024 / 1024) + " MB", Color.CYAN)
	
	# Scene info command / 场景信息命令
	commands["scene"] = func(args):
		var current_scene = get_tree().current_scene
		if current_scene:
			log("Current scene: " + current_scene.scene_file_path, Color.CYAN)
			log("Node count: " + str(current_scene.get_child_count(true)), Color.CYAN)
		else:
			log("No current scene", Color.RED)
	
	# Set command for modifying properties / 设置命令用于修改属性
	commands["set"] = func(args):
		if args.size() < 3:
			log("Usage: set <object_path> <property> <value>", Color.RED)
			return
		
		var node = get_tree().current_scene.get_node_or_null(args[0])
		if not node:
			log("Node not found: " + args[0], Color.RED)
			return
		
		var property = args[1]
		var value = args[2]
		
		if node.has_method("set") and property in node:
			node.set(property, value)
			log("Set " + property + " to " + str(value), Color.GREEN)
		else:
			log("Property not found: " + property, Color.RED)

## Static function to add console to scene / 静态函数将控制台添加到场景
static func add_to_scene(scene: Node):
	var console = DebugConsole.new()
	scene.add_child(console)
	return console

## Static logging function / 静态记录函数
static func log_static(message: String, color: Color = Color.WHITE):
	if instance:
		instance.log(message, color)