@tool
extends TowerDefensePlant

var over: bool = false

func AttackDeal(character: TowerDefenseCharacter, type: String) -> void :
    super .AttackDeal(character, type)
    if instance.sleep:
        return
    if over:
        return
    if type == "Eat":
        over = true
        character.Destroy()
        var zombiePacket: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("ZombieGargantuarRedEyes")
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        var zombie: TowerDefenseZombie = zombiePacket.Create(character.global_position, character.gridPos, 0.0)
        characterNode.add_child(zombie)
        zombie.Hypnoses()

        var tween = zombie.create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_BACK)
        tween.tween_property(zombie.transformPoint, ^"scale", Vector2.ONE, 0.5).from(Vector2.ONE * 0.5)
        tween.finished.connect(
            func():
                zombie.Walk()
        )
        Destroy()
