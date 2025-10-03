class_name TowerDefenseMap extends Node2D

@export var stripe: Node2D
@export var canvasModulateGradient: GradientTexture1D

@warning_ignore("unused_parameter")
func EnterRoom(character: TowerDefenseCharacter) -> void :
    await get_tree().create_timer(0.1, false).timeout

func FunctionExecute(functionName: String, variable: Array):
    match variable.size():
        0:
            call(functionName)
        1:
            call(functionName, variable[0])
        2:
            call(functionName, variable[0], variable[1])
        3:
            call(functionName, variable[0], variable[1], variable[2])
        4:
            call(functionName, variable[0], variable[1], variable[2], variable[3])
        5:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4])
        6:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4], variable[5])
        7:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4], variable[5], variable[6])
        8:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4], variable[5], variable[6], variable[7])
        9:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4], variable[5], variable[6], variable[7], variable[8])
        10:
            call(functionName, variable[0], variable[1], variable[2], variable[3], variable[4], variable[5], variable[6], variable[7], variable[8], variable[9])

func UseStripe(row: int) -> void :
    stripe.visible = true
    TowerDefenseMapControl.instance.strigeRow = row
    stripe.global_position.x = TowerDefenseManager.GetMapCellPos(Vector2i(row + 1, 1)).x - 10

func ShowShovel() -> void :
    var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
    seedBank.shovelNode.global_position.y = 0
    seedBank.shovelShow = true

func BackShovel() -> void :
    var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
    seedBank.shovelNode.position.y = 0

func CharacterClear() -> void :
    for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
        character.Destroy()

func LineUseSet(line: int, open: bool) -> void :
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    mapControl.lineUse[line] = open
