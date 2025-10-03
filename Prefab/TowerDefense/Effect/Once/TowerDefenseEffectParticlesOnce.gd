@tool
class_name TowerDefenseEffectParticlesOnce extends TowerDefenseEffectBase

@export var objectId: ObjectManagerConfig.OBJECT = ObjectManagerConfig.OBJECT.NOONE
@export var particles: GPUParticles2DMerge

func Refresh() -> void :
    add_to_group("Effect")
    particles.Init()

func Recycle() -> void :
    remove_from_group("Effect")

func _ready() -> void :
    if particles:
        if !particles.finished.is_connected(Finish):
            particles.finished.connect(Finish)

func Init(particlesScene: PackedScene) -> void :
    add_to_group("Effect")
    particles = particlesScene.instantiate()
    particles.Init()
    add_child(particles)
    particles.finished.connect(Finish)

@warning_ignore("unused_parameter")
func Finish() -> void :
    if objectId == ObjectManagerConfig.OBJECT.NOONE:
        queue_free()
    else:
        ObjectManager.PoolPush(objectId, self)
