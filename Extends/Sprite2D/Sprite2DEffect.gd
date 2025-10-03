@tool
class_name Sprite2DEffect extends Sprite2D

@export var shake: bool = false
@export var shakeInterval: float = 0.05
@export var shakeSpread: Vector2 = Vector2(2.0, 2.0)
var shakeTime: float = 0.0

@export var modulateRandom: bool = false
@export var modulateRamdomInterval: float = 5.0
@export var modulateRamdomGradient: Gradient
var modulateRandomTime: float = 0.0

@export var modulateBlink: bool = false
@export var modulateBlinkSpeed: float = 1.0
var modulateBlinkTime: float = 0.0

func _physics_process(delta: float) -> void :
    if shake:
        shakeTime += delta
        if shakeTime > shakeInterval:
            offset = Vector2(randf_range( - shakeSpread.x, shakeSpread.x), randf_range( - shakeSpread.y, shakeSpread.y))
            shakeTime -= shakeInterval
    if modulateRandom:
        modulateRandomTime += delta
        if modulateRandomTime > modulateRamdomInterval:
            modulate = modulateRamdomGradient.sample(randf())
            modulateRandomTime -= modulateRamdomInterval
    if modulateBlink:
        modulateBlinkTime += delta * modulateBlinkSpeed
        modulate.a = abs(sin(modulateBlinkTime))
