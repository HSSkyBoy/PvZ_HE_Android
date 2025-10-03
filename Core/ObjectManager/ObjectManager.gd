extends Node2D

var poolList: Array[PoolConfig] = []

func _ready() -> void :
    poolList.resize(ObjectManagerConfig.OBJECT.MAX)

    for i in range(ObjectManagerConfig.OBJECT.MAX):
        poolList[i] = null

    PoolCreate(preload("uid://dyrv5jg4hiu2l"), ObjectManagerConfig.OBJECT.PROJECTILE, 800, "Refresh", "Recycle")
    PoolCreate(preload("uid://bct1gvf1i8ohw"), ObjectManagerConfig.OBJECT.DAMAGEPART, 200, "Refresh", "Recycle")

    PoolCreate(preload("uid://dk3bkihnh1i0l"), ObjectManagerConfig.OBJECT.SUN, 100, "Refresh", "Recycle")
    PoolCreate(preload("uid://d161xee5m0kkw"), ObjectManagerConfig.OBJECT.SUN_BRAIN, 100, "Refresh", "Recycle")
    PoolCreate(preload("uid://da7lvlco511ds"), ObjectManagerConfig.OBJECT.SUN_JALAPENO, 100, "Refresh", "Recycle")

    PoolCreate(preload("uid://csynbfevdbiju"), ObjectManagerConfig.OBJECT.COIN_SILVER, 100, "Refresh", "Recycle")
    PoolCreate(preload("uid://kbif4idtgolo"), ObjectManagerConfig.OBJECT.COIN_GOLD, 100, "Refresh", "Recycle")
    PoolCreate(preload("uid://6b78y08u52f5"), ObjectManagerConfig.OBJECT.COIN_DIAMOND, 100, "Refresh", "Recycle")

    PoolCreate(preload("uid://cqehjuv8otn8k"), ObjectManagerConfig.OBJECT.PARTICLES_PEA_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://bmlgjv0djieap"), ObjectManagerConfig.OBJECT.PARTICLES_SNOW_PEA_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://fjtony2sxpu5"), ObjectManagerConfig.OBJECT.PARTICLES_FIRE_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://c5euyremx5if3"), ObjectManagerConfig.OBJECT.PARTICLES_PUFF_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://cn4yxuuid8kxl"), ObjectManagerConfig.OBJECT.PARTICLES_SPIKE_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://gwo4qka84n87"), ObjectManagerConfig.OBJECT.PARTICLES_BUTTER_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://b7h8n8k20miuu"), ObjectManagerConfig.OBJECT.PARTICLES_WINTER_MELON_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://djchpnx8iwbpe"), ObjectManagerConfig.OBJECT.PARTICLES_GLOOM_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://xh43v6jwid53"), ObjectManagerConfig.OBJECT.PARTICLES_ICE_FIRE_SPLATS, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://c5ijtocn0v2wx"), ObjectManagerConfig.OBJECT.PARTICLES_SPIKE_MELON_SPLATS, 200, "Refresh", "Recycle")

    PoolCreate(preload("uid://ueeii5v2dl8q"), ObjectManagerConfig.OBJECT.PARTICLES_SPLASH, 500, "Refresh", "Recycle")
    PoolCreate(preload("uid://lcop8me7nwde"), ObjectManagerConfig.OBJECT.PARTICLES_RISE_DIRT, 200, "Refresh", "Recycle")
    PoolCreate(preload("uid://b0wigigia32ny"), ObjectManagerConfig.OBJECT.PARTICLES_ICE_TRAP, 200, "Refresh", "Recycle")

    PoolCreate(preload("uid://dswe1rcdgitfr"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_PEA, 200, "", "")
    PoolCreate(preload("uid://5wxucmmmy8ne"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_SNOW_PEA, 200, "", "")
    PoolCreate(preload("uid://s48jlsqj8x0l"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_FIRE_PEA, 200, "", "")
    PoolCreate(preload("uid://bi0arf6lvcaaj"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_PUFF, 200, "Refresh", "")
    PoolCreate(preload("uid://csbj2fyqmusj"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_PUFF_BIG, 200, "Refresh", "")
    PoolCreate(preload("uid://cvg1cajrl4s4e"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_SPIKE, 200, "", "")
    PoolCreate(preload("uid://c5i60e3puevnc"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_KERNAL, 200, "", "")
    PoolCreate(preload("uid://bpu1ibbqp3m2"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_BUTTER, 200, "", "")
    PoolCreate(preload("uid://x8go376ra0lr"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_WINTER_MELON, 200, "", "")
    PoolCreate(preload("uid://66ajnsmq2qtq"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_GLOOM, 200, "", "")
    PoolCreate(preload("uid://yjbbnk8kl5qd"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_ICE_SWORD, 200, "", "")
    PoolCreate(preload("uid://btv02lfwnomhx"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_ICE_FIRE_PEA, 200, "", "")
    PoolCreate(preload("uid://bnl0hms7upsbj"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_ICE_SPEAR, 200, "", "")
    PoolCreate(preload("uid://bshbr6o1rfytt"), ObjectManagerConfig.OBJECT.PROJECTILE_SPRITE_SPIKE_MELON, 200, "", "")

func Clear() -> void :
    for i in range(poolList.size()):
        var pool = poolList[i]
        if is_instance_valid(pool):
            pool.Clear()

func PoolCreate(scene: PackedScene, id: ObjectManagerConfig.OBJECT, maxNum: int, popCallable: String = "", pushCallable: String = "") -> PoolConfig:

    if id < 0 or id >= ObjectManagerConfig.OBJECT.MAX:
        push_error("Invalid pool ID: " + str(id))
        return null


    if poolList[id] != null:
        poolList[id].Clear()


    var pool = PoolConfig.new()
    pool.scene = scene
    pool.maxNum = maxNum
    pool.popCallable = popCallable
    pool.pushCallable = pushCallable
    poolList[id] = pool
    return pool

func PoolPush(id: ObjectManagerConfig.OBJECT, node: Node) -> void :

    if !is_instance_valid(node):
        return
    if id < 0 or id >= ObjectManagerConfig.OBJECT.MAX:
        push_error("Invalid pool ID: " + str(id))
        return
    if poolList[id] == null:
        push_error("Pool not initialized for ID: " + str(id))
        return
    poolList[id].Push(node)

func PoolPop(id: ObjectManagerConfig.OBJECT, parent: Node) -> Node:

    if !is_instance_valid(parent):
        return null
    if id < 0 or id >= ObjectManagerConfig.OBJECT.MAX:
        push_error("Invalid pool ID: " + str(id))
        return null
    if poolList[id] == null:
        push_error("Pool not initialized for ID: " + str(id))
        return null
    return poolList[id].Pop(parent)
