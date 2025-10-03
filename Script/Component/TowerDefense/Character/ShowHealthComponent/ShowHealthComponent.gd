class_name ShowHealthComponent extends ComponentBase

@onready var shieldHitpointLabel: Label = %ShieldHitpointLabel
@onready var helmetHitpointLabel: Label = %HelmetHitpointLabel
@onready var bodyHitpointLabel: Label = %BodyHitpointLabel

@onready var centerContainer: CenterContainer = %CenterContainer

var parent: TowerDefenseCharacter

func _ready() -> void :
    z_index = 10
    parent = get_parent()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !alive:
        shieldHitpointLabel.visible = false
        helmetHitpointLabel.visible = false
        bodyHitpointLabel.visible = false
        return
    global_transform = Transform2D(0.0, Vector2.ONE, 0.0, global_position)
    if parent.instance.armorShield.size() > 0:
        shieldHitpointLabel.visible = true
        shieldHitpointLabel.text = "HP:%d/%d" % [parent.instance.armorShield[0].hitPoints, parent.instance.armorShield[0].config.damagePoint * parent.instance.armorShield[0].hitpointScale]
    else:
        shieldHitpointLabel.visible = false

    if parent.instance.armorHelm.size() > 0:
        helmetHitpointLabel.visible = true
        helmetHitpointLabel.text = "HP:%d/%d" % [parent.instance.armorHelm[0].hitPoints, parent.instance.armorHelm[0].config.damagePoint * parent.instance.armorHelm[0].hitpointScale]
    else:
        helmetHitpointLabel.visible = false
    bodyHitpointLabel.visible = true
    bodyHitpointLabel.text = "HP:%d/%d" % [parent.instance.hitpoints, (parent.instance.config.hitpoints + parent.instance.config.hitpointsNearDeath) * parent.instance.hitpointScale]
