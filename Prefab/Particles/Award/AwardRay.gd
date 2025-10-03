@tool
class_name AwardRay extends Node2D

@export_tool_button("Emit") var emitButton: Callable = Emit

@onready var awardRayFour = %AwardRayFour
@onready var awardRayGlow = %AwardRayGlow
@onready var awardRay1 = %AwardRay1
@onready var awardRay2 = %AwardRay2

func Emit():
    awardRayFour.restart()
    awardRay1.restart()
    awardRay2.restart()
    await get_tree().create_timer(5.0, false).timeout
    awardRayGlow.restart()
