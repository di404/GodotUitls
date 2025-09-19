# GodotUtils Examples / GodotUtils示例

This directory contains example scenes and scripts demonstrating how to use the various utilities in the GodotUtils library.

本目录包含演示如何使用GodotUtils库中各种工具的示例场景和脚本。

## UI Examples / UI示例

### Scene Transitions / 场景转换
```gdscript
# Fade transition to main menu
UIManager.transition_to_scene("res://scenes/MainMenu.tscn", UIManager.TransitionType.FADE, 1.0)

# Slide transition with custom duration
UIManager.transition_to_scene("res://scenes/GameLevel.tscn", UIManager.TransitionType.SLIDE, 0.8)

# Show notification
UIManager.show_notification("Level Complete!", 2.0)

# Animate a button with bounce effect
UIManager.animate_control(my_button, "bounce_in", 0.5)
```

## Math Examples / 数学示例

### Advanced Interpolation / 高级插值
```gdscript
# Custom smooth step with curve
var smooth_value = MathHelper.smooth_step_custom(0.0, 100.0, 0.5, 2.0)

# Bounce easing
var bounce_value = MathHelper.ease_bounce_out(time_ratio)

# Spring interpolation for smooth following
var spring_result = MathHelper.spring_interpolate(current_pos, target_pos, velocity, 10.0, 0.8, delta)
current_pos = spring_result.value
velocity = spring_result.velocity
```

### Geometric Calculations / 几何计算
```gdscript
# Check if point is in circle
if MathHelper.point_in_circle(mouse_pos, circle_center, radius):
    print("Mouse is over circle!")

# Generate random point in circle
var random_spawn = MathHelper.random_point_in_circle(spawn_center, spawn_radius)

# Calculate projectile path
var trajectory = MathHelper.calculate_projectile_path(start_pos, target_pos, gravity, speed)
```

## File I/O Examples / 文件操作示例

### Save System / 保存系统
```gdscript
# Save player data
var player_data = {
    "name": "Player1",
    "level": 5,
    "score": 1500,
    "inventory": ["sword", "potion", "key"]
}
SaveSystem.save_data("player_save", player_data)

# Load player data
var loaded_data = SaveSystem.load_data("player_save")
if not loaded_data.is_empty():
    player_name = loaded_data.get("name", "Unknown")
    player_level = loaded_data.get("level", 1)

# Check if save exists
if SaveSystem.save_exists("player_save"):
    # Load existing save
    pass
else:
    # Create new game
    pass
```

## Scene Management Examples / 场景管理示例

### Preloading and Caching / 预加载和缓存
```gdscript
# Preload important scenes
SceneManager.preload_scene("res://scenes/BattleScene.tscn")
SceneManager.preload_scene("res://scenes/InventoryMenu.tscn")

# Use cached scene for instant loading
SceneManager.change_scene_cached("res://scenes/BattleScene.tscn")

# Smart preloading based on current scene
var preload_map = {
    "res://scenes/MainMenu.tscn": ["res://scenes/GameLevel.tscn", "res://scenes/Settings.tscn"],
    "res://scenes/GameLevel.tscn": ["res://scenes/PauseMenu.tscn", "res://scenes/GameOver.tscn"]
}
SceneManager.smart_preload(current_scene_path, preload_map)
```

## Debug Examples / 调试示例

### Debug Console / 调试控制台
```gdscript
# Add debug console to your main scene
func _ready():
    DebugConsole.add_to_scene(self)
    
    # Register custom commands
    DebugConsole.register_command("spawn_enemy", spawn_enemy_command, "Spawn an enemy at player position")
    DebugConsole.register_command("heal", heal_player_command, "Heal player to full health")

func spawn_enemy_command(args):
    # Your enemy spawning logic
    DebugConsole.log_static("Enemy spawned!", Color.GREEN)

func heal_player_command(args):
    # Your healing logic
    DebugConsole.log_static("Player healed!", Color.GREEN)
```

### Usage in Game / 游戏中使用
- Press F1 to toggle debug console / 按F1切换调试控制台
- Type `help` to see available commands / 输入`help`查看可用命令
- Use arrow keys to navigate command history / 使用方向键浏览命令历史

## Integration Tips / 集成提示

### Autoload Setup / 自动加载设置
For global access to utilities, consider adding them as autoload singletons in your project settings:

为了全局访问工具，考虑在项目设置中将它们添加为自动加载单例：

1. Go to Project Settings > Autoload / 转到项目设置 > 自动加载
2. Add the utility scripts you want to use globally / 添加您想要全局使用的工具脚本
3. Access them from anywhere in your code / 在代码中的任何地方访问它们

### Performance Considerations / 性能考虑
- Scene preloading uses memory, use it wisely / 场景预加载会占用内存，请明智使用
- Debug console should be disabled in release builds / 调试控制台应在发布版本中禁用
- Use object pooling for frequently created/destroyed objects / 对频繁创建/销毁的对象使用对象池

### Error Handling / 错误处理
All utilities include comprehensive error handling and logging. Check the console output for any issues.

所有工具都包含完整的错误处理和日志记录。检查控制台输出以查看任何问题。