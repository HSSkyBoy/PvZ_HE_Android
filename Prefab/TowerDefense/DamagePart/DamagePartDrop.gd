@tool
class_name DamagePartDrop extends TowerDefenseGroundItemBase

@onready var shadowSprite: Sprite2D = %ShadowSprite
@onready var spriteGroup: CanvasGroup = %SpriteGroup

@onready var spriteNode: Node2D = %Sprite
@onready var moveComponent: MoveComponent = %MoveComponent

var height: float = 60.0
var jumpSpeed: float = 300.0
var jumpTime: int = 3

var initVelocity: Vector2 = Vector2.ZERO

var over: bool = false

var sprite: Node2D = null

func Refresh() -> void :
    add_to_group("Effect", true)
    spriteNode.position = Vector2.ZERO
    spriteNode.rotation = 0.0
    spriteGroup.position = Vector2.ZERO
    scale = Vector2.ONE
    rotation = 0.0
    height = 100
    initVelocity = Vector2.ZERO
    modulate.a = 1.0
    jumpSpeed = 300.0
    jumpTime = 3

    over = false

    sprite = null

func Recycle() -> void :
    remove_from_group("Effect")
    if is_instance_valid(sprite):
        sprite.queue_free()

func Init(_sprite: Node2D, _height: float, _initVelocity = Vector2.ZERO):
    sprite = _sprite
    sprite.position = Vector2.ZERO
    spriteGroup.add_child(sprite)

    height = _height
    initVelocity = _initVelocity
    moveComponent.SetGravity(980.0 * 2.0)
    moveComponent.SetVelocity(initVelocity)

    shadowSprite.position.y = height + 10

func _physics_process(delta):
    if over:
        return
    shadowSprite.position.x = spriteNode.position.x
    if spriteNode.position.y > height:
        gridPos = TowerDefenseManager.GetMapGridPos(shadowSprite.global_position - Vector2(0, 20))
        if is_instance_valid(cell):
            if cell.IsWater():
                CreateSplash()
                Over()
                return
        spriteNode.position.y = height - 1
        jumpTime -= 1
        if jumpTime > 0 && jumpSpeed >= 10.0:
            moveComponent.SetVelocity(Vector2(moveComponent.velocity.x / 2, - jumpSpeed))
            jumpSpeed /= 2
        else:
            moveComponent.MoveClear()
            over = true
            await get_tree().create_timer(0.5, false).timeout
            var tween = create_tween()
            tween.tween_property(self, "modulate:a", 0.0, 0.1)
            tween.finished.connect(Over)
    else:
        if moveComponent.velocity.x != 0:
            spriteNode.global_rotation += moveComponent.velocity.x / 40 * delta

func Over():
    ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.DAMAGEPART, self)

func CreateSplash() -> TowerDefenseEffectSpriteOnce:
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var effect: TowerDefenseEffectSpriteOnce = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_SPLASH, characterNode)
    effect.gridPos = gridPos
    effect.global_position = shadowSprite.global_position - Vector2(0, 20)
    return effect
