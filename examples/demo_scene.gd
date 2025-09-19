##
## Example scene demonstrating GodotUtils functionality
## 演示GodotUtils功能的示例场景
##

extends Control

@onready var ui_demo_button = Button.new()
@onready var math_demo_button = Button.new()
@onready var save_demo_button = Button.new()
@onready var scene_demo_button = Button.new()
@onready var result_label = Label.new()

func _ready():
	setup_ui()
	
	# Add debug console
	DebugConsole.add_to_scene(self)
	
	# Register custom debug commands
	DebugConsole.register_command("test_ui", test_ui_animation)
	DebugConsole.register_command("test_math", test_math_functions)

func setup_ui():
	# Create main layout
	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "GodotUtils Demo / GodotUtils演示"
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	# Demo buttons
	ui_demo_button.text = "UI Animation Demo / UI动画演示"
	ui_demo_button.pressed.connect(_on_ui_demo)
	vbox.add_child(ui_demo_button)
	
	math_demo_button.text = "Math Functions Demo / 数学函数演示"
	math_demo_button.pressed.connect(_on_math_demo)
	vbox.add_child(math_demo_button)
	
	save_demo_button.text = "Save System Demo / 保存系统演示"
	save_demo_button.pressed.connect(_on_save_demo)
	vbox.add_child(save_demo_button)
	
	scene_demo_button.text = "Scene Management Demo / 场景管理演示"
	scene_demo_button.pressed.connect(_on_scene_demo)
	vbox.add_child(scene_demo_button)
	
	# Result display
	result_label.text = "Press F1 for Debug Console / 按F1打开调试控制台"
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(result_label)

func _on_ui_demo():
	UIManager.show_notification("UI Demo Started! / UI演示开始！", 2.0)
	UIManager.animate_control(ui_demo_button, "bounce_in", 0.5)
	result_label.text = "UI Animation completed! / UI动画完成！"

func _on_math_demo():
	# Demonstrate math functions
	var smooth_value = MathHelper.smooth_step_custom(0.0, 100.0, 0.5, 2.0)
	var bounce_value = MathHelper.ease_bounce_out(0.7)
	var random_point = MathHelper.random_point_in_circle(Vector2.ZERO, 100.0)
	
	result_label.text = "Math Demo Results / 数学演示结果:\n"
	result_label.text += "Smooth Step: %.2f\n" % smooth_value
	result_label.text += "Bounce Ease: %.2f\n" % bounce_value
	result_label.text += "Random Point: (%.1f, %.1f)" % [random_point.x, random_point.y]

func _on_save_demo():
	# Demonstrate save system
	var demo_data = {
		"player_name": "Demo Player",
		"level": 5,
		"score": 1000,
		"timestamp": Time.get_datetime_string_from_system()
	}
	
	SaveSystem.save_data("demo_save", demo_data)
	var loaded_data = SaveSystem.load_data("demo_save")
	
	result_label.text = "Save Demo / 保存演示:\n"
	result_label.text += "Data saved and loaded successfully! / 数据保存和加载成功！\n"
	result_label.text += "Player: %s\n" % loaded_data.get("player_name", "Unknown")
	result_label.text += "Level: %d\n" % loaded_data.get("level", 0)
	result_label.text += "Score: %d" % loaded_data.get("score", 0)

func _on_scene_demo():
	# Demonstrate scene management
	var current_scene_path = get_scene().scene_file_path
	SceneManager.preload_scene(current_scene_path, func(resource):
		result_label.text = "Scene preloaded successfully! / 场景预加载成功！"
	)
	
	var cache_info = SceneManager.get_cache_memory_usage()
	result_label.text = "Scene Management Demo / 场景管理演示:\n"
	result_label.text += "Cached scenes: %d\n" % cache_info.scene_count
	result_label.text += "Current scene preloaded! / 当前场景已预加载！"

# Debug command functions
func test_ui_animation(args):
	UIManager.animate_control(result_label, "pulse", 1.0)
	DebugConsole.log_static("UI animation test completed!", Color.GREEN)

func test_math_functions(args):
	var test_value = MathHelper.fibonacci(10)
	DebugConsole.log_static("Fibonacci(10) = " + str(test_value), Color.CYAN)