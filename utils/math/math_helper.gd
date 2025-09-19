##
## MathHelper - Extended Math Functions for Game Development
## 游戏开发扩展数学函数
##
## A collection of useful mathematical functions commonly used in game development
## 游戏开发中常用的数学函数集合
##

class_name MathHelper
extends RefCounted

## Mathematical constants / 数学常量
const TAU := PI * 2.0
const GOLDEN_RATIO := 1.618033988749
const SQRT_2 := 1.414213562373
const SQRT_3 := 1.732050807569

## Custom smoothstep function with adjustable curve / 带可调曲线的自定义平滑步进函数
static func smooth_step_custom(from: float, to: float, weight: float, curve_power: float = 1.0) -> float:
	weight = clamp(weight, 0.0, 1.0)
	var smooth_weight = weight * weight * (3.0 - 2.0 * weight)
	smooth_weight = pow(smooth_weight, curve_power)
	return lerp(from, to, smooth_weight)

## Bounce easing function / 弹跳缓动函数
static func ease_bounce_out(t: float) -> float:
	if t < 1.0 / 2.75:
		return 7.5625 * t * t
	elif t < 2.0 / 2.75:
		t -= 1.5 / 2.75
		return 7.5625 * t * t + 0.75
	elif t < 2.5 / 2.75:
		t -= 2.25 / 2.75
		return 7.5625 * t * t + 0.9375
	else:
		t -= 2.625 / 2.75
		return 7.5625 * t * t + 0.984375

## Elastic easing function / 弹性缓动函数
static func ease_elastic_out(t: float, amplitude: float = 1.0, period: float = 0.3) -> float:
	if t == 0.0 or t == 1.0:
		return t
	return amplitude * pow(2.0, -10.0 * t) * sin((t - period / 4.0) * TAU / period) + 1.0

## Calculate distance between two points / 计算两点间距离
static func distance_2d(point1: Vector2, point2: Vector2) -> float:
	return point1.distance_to(point2)

## Calculate distance in 3D space / 计算3D空间距离
static func distance_3d(point1: Vector3, point2: Vector3) -> float:
	return point1.distance_to(point2)

## Check if point is inside circle / 检查点是否在圆内
static func point_in_circle(point: Vector2, circle_center: Vector2, radius: float) -> bool:
	return distance_2d(point, circle_center) <= radius

## Check if point is inside rectangle / 检查点是否在矩形内
static func point_in_rectangle(point: Vector2, rect_position: Vector2, rect_size: Vector2) -> bool:
	return point.x >= rect_position.x and point.x <= rect_position.x + rect_size.x and \
		   point.y >= rect_position.y and point.y <= rect_position.y + rect_size.y

## Convert degrees to radians / 角度转弧度
static func deg_to_rad(degrees: float) -> float:
	return degrees * PI / 180.0

## Convert radians to degrees / 弧度转角度
static func rad_to_deg(radians: float) -> float:
	return radians * 180.0 / PI

## Normalize angle to 0-360 range / 标准化角度到0-360范围
static func normalize_angle(angle: float) -> float:
	while angle < 0.0:
		angle += 360.0
	while angle >= 360.0:
		angle -= 360.0
	return angle

## Calculate angle between two vectors / 计算两个向量间的角度
static func angle_between_vectors(v1: Vector2, v2: Vector2) -> float:
	return v1.angle_to(v2)

## Rotate vector by angle / 按角度旋转向量
static func rotate_vector(vector: Vector2, angle: float) -> Vector2:
	return vector.rotated(angle)

## Linear interpolation with custom curve / 带自定义曲线的线性插值
static func lerp_custom(a: float, b: float, t: float, curve: Curve = null) -> float:
	if curve:
		t = curve.sample(t)
	return lerp(a, b, t)

## Vector2 lerp with custom curve / Vector2带自定义曲线插值
static func lerp_vector2(a: Vector2, b: Vector2, t: float, curve: Curve = null) -> Vector2:
	if curve:
		t = curve.sample(t)
	return a.lerp(b, t)

## Remap value from one range to another / 将数值从一个范围重映射到另一个范围
static func remap(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	var ratio = (value - from_min) / (from_max - from_min)
	return to_min + ratio * (to_max - to_min)

## Snap value to grid / 将值对齐到网格
static func snap_to_grid(value: float, grid_size: float) -> float:
	return round(value / grid_size) * grid_size

## Snap Vector2 to grid / 将Vector2对齐到网格
static func snap_vector2_to_grid(vector: Vector2, grid_size: Vector2) -> Vector2:
	return Vector2(
		snap_to_grid(vector.x, grid_size.x),
		snap_to_grid(vector.y, grid_size.y)
	)

## Calculate Fibonacci number / 计算斐波那契数
static func fibonacci(n: int) -> int:
	if n <= 1:
		return n
	var a = 0
	var b = 1
	for i in range(2, n + 1):
		var temp = a + b
		a = b
		b = temp
	return b

## Generate random point in circle / 在圆内生成随机点
static func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	var distance = sqrt(randf()) * radius
	return center + Vector2(cos(angle), sin(angle)) * distance

## Generate random point on circle edge / 在圆边缘生成随机点
static func random_point_on_circle(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	return center + Vector2(cos(angle), sin(angle)) * radius

## Clamp vector magnitude / 限制向量大小
static func clamp_vector_magnitude(vector: Vector2, max_magnitude: float) -> Vector2:
	if vector.length() > max_magnitude:
		return vector.normalized() * max_magnitude
	return vector

## Spring interpolation for smooth following / 弹簧插值用于平滑跟随
static func spring_interpolate(current: float, target: float, velocity: float, spring_strength: float, damping: float, delta: float) -> Dictionary:
	var force = (target - current) * spring_strength
	velocity += force * delta
	velocity *= (1.0 - damping * delta)
	current += velocity * delta
	return {"value": current, "velocity": velocity}

## Calculate parabolic trajectory / 计算抛物线轨迹
static func calculate_projectile_path(start_pos: Vector2, target_pos: Vector2, gravity: float, initial_speed: float) -> Array:
	var displacement = target_pos - start_pos
	var time_to_target = displacement.length() / initial_speed
	var points = []
	
	var steps = 20
	for i in range(steps + 1):
		var t = float(i) / float(steps) * time_to_target
		var x = start_pos.x + (displacement.x / time_to_target) * t
		var y = start_pos.y + (displacement.y / time_to_target) * t + 0.5 * gravity * t * t
		points.append(Vector2(x, y))
	
	return points