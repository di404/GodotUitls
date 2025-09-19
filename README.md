# GodotUtils - Godot瑞士军刀工具库

A plug-and-play Swiss army knife code library for Godot development, containing practical utilities organized in a modular fashion.

一个Godot开发过程中的即插即用瑞士军刀代码库，包含实用功能，模块化组织，即插即用。

## Features / 特性

- 🔧 **Modular Design** / **模块化设计**: Each utility is self-contained and can be used independently
- 🚀 **Plug-and-Play** / **即插即用**: Easy to integrate into existing projects
- 📚 **Well Documented** / **文档完善**: Clear documentation and examples for each utility
- 🎯 **Godot Focused** / **专为Godot设计**: Optimized for Godot Engine development

## Modules / 模块

### UI Utilities / UI工具
- **UIManager**: Scene and UI management utilities
- **AnimationHelper**: Common animation patterns and transitions
- **LayoutHelper**: Dynamic layout and responsive design utilities

### Math Utilities / 数学工具
- **MathHelper**: Extended math functions for game development
- **VectorUtils**: Vector manipulation and calculation utilities
- **GeometryUtils**: Geometric calculations and collision detection helpers

### File I/O Utilities / 文件操作工具
- **FileManager**: File and directory management utilities
- **SaveSystem**: Save/load game data management
- **ConfigManager**: Configuration file handling

### Scene Management / 场景管理
- **SceneManager**: Scene loading and transition utilities
- **ResourceLoader**: Optimized resource loading and caching
- **PoolManager**: Object pooling for performance optimization

### Debug Utilities / 调试工具
- **DebugConsole**: In-game debug console
- **PerformanceMonitor**: FPS and performance monitoring
- **Logger**: Advanced logging system

## Installation / 安装

1. Clone this repository into your Godot project:
   ```bash
   git clone https://github.com/fuyingdi/GodotUitls.git
   ```

2. Copy the desired utility modules to your project's script folder

3. Add the utilities as autoload singletons in your project settings (optional)

## Usage / 使用方法

Each module can be used independently. Simply copy the required `.gd` files to your project and use them according to the documentation.

每个模块都可以独立使用。只需将所需的 `.gd` 文件复制到您的项目中，并根据文档使用它们。

### Quick Example / 快速示例

```gdscript
# Using UIManager to handle scene transitions
UIManager.transition_to_scene("res://scenes/MainMenu.tscn", "fade")

# Using MathHelper for advanced calculations
var result = MathHelper.smooth_step_custom(0.0, 1.0, 0.5, 2.0)

# Using SaveSystem for game data
SaveSystem.save_data("player_data", {"level": 5, "score": 1000})
var data = SaveSystem.load_data("player_data")
```

## Contributing / 贡献

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

欢迎贡献！请随时提交拉取请求或为错误和功能请求开启问题。

## License / 许可证

This project is released under the MIT License. See [LICENSE](LICENSE) for details.

## Godot Version / Godot版本

Compatible with Godot 4.x. For Godot 3.x compatibility, please check the `godot3` branch.

兼容 Godot 4.x。如需 Godot 3.x 兼容性，请查看 `godot3` 分支。
