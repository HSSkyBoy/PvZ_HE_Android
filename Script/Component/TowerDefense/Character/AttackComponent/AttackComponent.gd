class_name AttackComponent extends ComponentBase

@export_enum("Default", "Eat", "Smash", "Chomp") var attackType: String = "Eat"
@export var checkArea: Area2D
@export var checkIntreval: int = 5
@export var checkLine: bool = false
@export var checkTall: bool = false

var parent: TowerDefenseCharacter

var target: TowerDefenseCharacter

var timer: float = 0.0

var checkIntrevalNow: int = 5

func _ready() -> void :
    parent = get_parent()
    checkArea.area_exited.connect(ExitCheck)

func CanAttack(fliterBowling: bool = true, checkAll: bool = false, checkGravestone: bool = true) -> bool:
    if !alive:
        return false
    if !checkArea:
        return false
    if !parent.instance.canCollection:
        return false
    if checkTall:
        target = GetTargetTall(fliterBowling, checkGravestone)
        if is_instance_valid(target):
            return true
    if parent is TowerDefenseZombie:
        if is_instance_valid(target):
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(target.gridPos)
            if is_instance_valid(cell):
                if is_instance_valid(cell.characterLadder) && parent.config.physique < TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE && parent.scale.x > 0.0:
                    target = null
                    return false
        if parent.isGarlic || parent.isChangeLine:
            return false

    if is_instance_valid(target):
        if !is_instance_valid(target.hitBox):
            target = null
            return false
        if !parent.CanCollision(target.instance.maskFlags):
            target = null
            return false
        if target is TowerDefensePlant && !target is TowerDefensePlantBowlingBase:
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(target.gridPos)
            target = cell.GetTarget(parent.instance.maskFlags)
        return is_instance_valid(target)

    if checkIntrevalNow > 0:
        checkIntrevalNow -= 1
        return false
    checkIntrevalNow = checkIntreval
    timer = 0.0
    if !checkAll:
        GetTarget(fliterBowling, checkGravestone)
        if is_instance_valid(target):
            if parent is TowerDefenseZombie:
                var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(target.gridPos)
                if is_instance_valid(cell):
                    if is_instance_valid(cell.characterLadder) && parent.config.physique < TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE && parent.scale.x > 0.0:
                        target = null
                        return false
            if target is TowerDefensePlant && !target is TowerDefensePlantBowlingBase:
                var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(target.gridPos)
                if is_instance_valid(cell):
                    target = cell.GetTarget(parent.instance.maskFlags)
        return is_instance_valid(target)
    else:
        var characterList = TowerDefenseManager.GetCharacterTargetFromArea(parent, checkArea, false, false)
        if checkGravestone:
            characterList = characterList.filter(
                func(checkCharacter):
                    return !checkCharacter is TowerDefenseGravestone
            )
        return characterList.size() > 0

func GetTargetTall(fliterBowling: bool = true, checkGravestone: bool = true) -> TowerDefenseCharacter:
    var characterList = GetTargetList(fliterBowling, checkGravestone)
    if characterList.size() > 0:
        for checkCharacter in characterList:
            if checkCharacter.config.height >= TowerDefenseEnum.CHARACTER_HEIGHT.TALL:
                return checkCharacter
    return null

func GetTarget(fliterBowling: bool = true, checkGravestone: bool = true) -> TowerDefenseCharacter:
    var characterList = GetTargetList(fliterBowling, checkGravestone)
    if characterList.size() > 0:
        var character: TowerDefenseCharacter = characterList[0]
        if character is TowerDefensePlant:
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(character.gridPos)
            if character is not TowerDefensePlantBowlingBase:
                var _target: TowerDefenseCharacter = cell.GetTarget(parent.instance.collisionFlags)
                if _target:
                    character = _target
        target = character
        return character
    else:
        return null

func GetTargetList(fliterBowling: bool = true, checkGravestone: bool = true) -> Array:
    var characterList: Array = []
    if !checkTall:
        characterList = TowerDefenseManager.GetCharacterTargetFromArea(parent, checkArea, false, false, attackType != "Smash")
    else:
        var areas = checkArea.get_overlapping_areas()
        for area: Area2D in areas:
            var checkCharacter = area.get_parent()
            if checkCharacter is TowerDefenseCharacter:
                if checkCharacter.die || checkCharacter.nearDie:
                    continue
                if !parent.CanTarget(checkCharacter):
                    continue
                if checkCharacter.config.height >= TowerDefenseEnum.CHARACTER_HEIGHT.TALL:
                    characterList.append(checkCharacter)
                    continue
                if !parent.CanCollision(checkCharacter.instance.maskFlags):
                    continue
                if checkCharacter is TowerDefenseCrater:
                    continue
                if checkCharacter is TowerDefenseItem:
                    if attackType != "Smash":
                        continue
                    elif !checkCharacter is TowerDefenseVase:
                        continue
                if checkGravestone:
                    if checkCharacter is TowerDefenseGravestone:
                        continue
                characterList.append(checkCharacter)
    if fliterBowling:
        characterList = characterList.filter(
            func(checkCharacter: TowerDefenseCharacter):
                return !(checkCharacter is TowerDefensePlantBowlingBase)
        )
    if !checkGravestone:
        characterList = characterList.filter(
            func(checkCharacter: TowerDefenseCharacter):
                return !(checkCharacter is TowerDefenseGravestone)
        )
    if checkLine:
        characterList = characterList.filter(
            func(checkCharacter: TowerDefenseCharacter):
                return checkCharacter.gridPos.y == parent.gridPos.y
        )
    return characterList

func AttackDps(delta: float, num: float) -> float:
    var character: TowerDefenseCharacter = target
    if !character:
        return num
    character.AttackDeal(parent, attackType)
    var numGet: float = character.instance.Hurt(num * delta, false, Vector2.ZERO, false)
    if numGet > 0:
        AudioManager.AudioPlay("Gulp", AudioManagerEnum.TYPE.SFX)
    if timer > 0.0:
        timer -= delta
    else:
        timer = 1.5 / parent.sprite.timeScale
        character.Bright()
        AudioManager.AudioPlay("Chomp", AudioManagerEnum.TYPE.SFX)
    return numGet

func Attack(num: float) -> float:
    var character: TowerDefenseCharacter = target
    if !character:
        return num
    character.AttackDeal(parent, attackType)
    return character.Hurt(num, true, Vector2.ZERO)

func AttackAll(num: float) -> void :
    var characterList = TowerDefenseManager.GetCharacterTargetFromArea(parent, checkArea)
    for character: TowerDefenseCharacter in characterList:
        if character:
            character.AttackDeal(parent, attackType)
            character.Hurt(num, true, Vector2.ZERO)

func SmashAttack(num: float) -> float:
    var character: TowerDefenseCharacter = GetTarget()
    if !character:
        return num
    return character.SmashHurt(num, true, Vector2.ZERO)

func SmashAttackCell(num: float) -> void :
    if !is_instance_valid(target):
        return
    if target is TowerDefenseZombie || target is TowerDefenseGravestone || target is TowerDefenseVase:
        target.SmashHurt(num, true, Vector2.ZERO)
    elif target is TowerDefensePlant:
        target = GetTarget()
        if is_instance_valid(target):
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(target.gridPos)
            for cellCharacter: TowerDefenseCharacter in cell.characterList.duplicate():
                if !is_instance_valid(cellCharacter):
                    continue
                if cellCharacter is TowerDefenseGravestone:
                    continue
                if cellCharacter is TowerDefenseCrater:
                    continue
                if cellCharacter.CanTarget(parent) && cellCharacter.CanCollision(parent.instance.collisionFlags):
                    cellCharacter.SmashHurt(num, true, Vector2.ZERO)

func ExitCheck(area: Area2D) -> void :
    if area.get_parent() == target:
        target = null
