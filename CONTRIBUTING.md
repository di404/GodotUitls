# Contributing to GodotUtils / 为GodotUtils贡献

Thank you for your interest in contributing to GodotUtils! This document provides guidelines for contributing to this project.

感谢您对为GodotUtils贡献的兴趣！本文档提供了为此项目贡献的指导原则。

## Code of Conduct / 行为准则

- Be respectful and inclusive / 保持尊重和包容
- Help others learn and grow / 帮助他人学习和成长
- Focus on constructive feedback / 专注于建设性反馈

## How to Contribute / 如何贡献

### Reporting Bugs / 报告错误

When reporting bugs, please include:
报告错误时，请包含：

1. Godot version / Godot版本
2. Operating system / 操作系统
3. Steps to reproduce / 重现步骤
4. Expected vs actual behavior / 预期与实际行为

### Suggesting Features / 建议功能

For feature requests, please:
对于功能请求，请：

1. Check if the feature already exists / 检查功能是否已存在
2. Explain the use case / 解释用例
3. Describe the proposed solution / 描述建议的解决方案

### Submitting Pull Requests / 提交拉取请求

1. Fork the repository / Fork仓库
2. Create a feature branch / 创建功能分支
3. Make your changes / 进行更改
4. Add tests if applicable / 如果适用，添加测试
5. Update documentation / 更新文档
6. Submit a pull request / 提交拉取请求

## Coding Standards / 编码标准

### GDScript Style / GDScript样式

- Use snake_case for variables and functions / 变量和函数使用snake_case
- Use PascalCase for classes / 类使用PascalCase
- Use SCREAMING_SNAKE_CASE for constants / 常量使用SCREAMING_SNAKE_CASE
- Add type hints where possible / 尽可能添加类型提示
- Include documentation comments / 包含文档注释

Example / 示例:
```gdscript
##
## Brief description of the function
## 函数的简要描述
##
static func calculate_distance(point_a: Vector2, point_b: Vector2) -> float:
	return point_a.distance_to(point_b)
```

### Documentation / 文档

- Document all public functions / 记录所有公共函数
- Include examples in documentation / 在文档中包含示例
- Provide both English and Chinese descriptions / 提供英文和中文描述
- Update README.md if adding new utilities / 如果添加新工具，更新README.md

### Testing / 测试

While not strictly required, consider adding:
虽然不是严格要求，但请考虑添加：

- Unit tests for complex functions / 复杂函数的单元测试
- Example scenes demonstrating usage / 演示用法的示例场景
- Performance benchmarks for critical code / 关键代码的性能基准

## Utility Guidelines / 工具指导原则

When adding new utilities, ensure they:
添加新工具时，确保它们：

### Are Modular / 模块化
- Self-contained functionality / 自包含功能
- Minimal dependencies / 最小依赖
- Can be used independently / 可以独立使用

### Are Well-Documented / 文档完善
- Clear purpose and use cases / 明确的目的和用例
- Usage examples / 使用示例
- Parameter descriptions / 参数描述

### Follow Project Structure / 遵循项目结构
```
utils/
├── category_name/
│   ├── utility_name.gd
│   └── utility_helper.gd
└── examples/
    └── category_name/
        └── example_scene.gd
```

### Performance Considerations / 性能考虑
- Avoid unnecessary allocations in hot paths / 避免在热路径中进行不必要的分配
- Use object pooling for frequently created objects / 对频繁创建的对象使用对象池
- Profile performance-critical code / 分析性能关键代码

## Commit Message Format / 提交消息格式

Use clear, descriptive commit messages:
使用清晰、描述性的提交消息：

```
[Category] Brief description

Detailed description if needed
```

Examples / 示例:
- `[UI] Add slide transition animation`
- `[Math] Implement spring interpolation function`
- `[Docs] Update README with installation instructions`

## Review Process / 审查过程

All pull requests will be reviewed for:
所有拉取请求将被审查：

1. Code quality and style / 代码质量和样式
2. Documentation completeness / 文档完整性
3. Compatibility with Godot 4.x / 与Godot 4.x的兼容性
4. Performance implications / 性能影响

## Getting Help / 获取帮助

If you need help:
如果您需要帮助：

1. Check existing issues and discussions / 检查现有问题和讨论
2. Create a new issue with the "help wanted" label / 创建带有"help wanted"标签的新问题
3. Join our community discussions / 加入我们的社区讨论

## Recognition / 认可

Contributors will be recognized in:
贡献者将被认可在：

- README.md contributors section / README.md贡献者部分
- Release notes / 发布说明
- Project documentation / 项目文档

Thank you for helping make GodotUtils better! / 感谢您帮助改进GodotUtils！