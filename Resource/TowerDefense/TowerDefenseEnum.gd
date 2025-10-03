class_name TowerDefenseEnum


enum GAMEMODE{
    TOWERDEFENSE = 0, 
    HAMMER = 1
}


enum LAYER_GROUNDITEM{
    DEFAULT = 0, 
    GROUNDITEM = 1, 
    PLANT_UNDER = 2, 
    PLANT_BACK = 3, 
    PLANT = 4, 
    PLANT_FRONT = 5, 
    PLANT_AIR = 6, 
    ZOMBIE = 7, 
    DAMAGEPART = 8, 
    PROJECTILE = 9, 
    EFFECT = 10, 

    MAX = 15
}


enum SUN_MOVING_METHOD{
    LAND = 0, 
    GRAVITY = 1, 
    MOVING = 2, 
}


enum PACKET_TYPE{
    NOONE = -1, 
    WHITE = 0, 
    GOLD = 1, 
    DIAMOND = 2, 
    COLOUR = 3, 
    STAR = 4, 
    ORIGINAL = 5, 
    ZOMBIE = 6, 

    COVER = 7, 
    GRAY = 8
}


enum CHARACTER_CAMP{
    NOONE = -1, 
    PLANT = 0, 
    ZOMBIE = 1, 
    ALL = 2
}

enum CHARACTER_HEIGHT{
    GROUND = 0, 
    LOW = 1, 
    NORMAL = 2, 
    TALL = 3
}

enum CHARACTER_COLLISION_FLAGS{
    GROUND_CHARACTRE = 1 << 0, 
    OFF_GROUND_CHARACTRE = 1 << 1, 
    DYING_CHARACTER = 1 << 2, 
    GRIDITEM = 1 << 3, 
    UNDER_GROUND = 1 << 4, 
    UNDER_WATER = 1 << 5
}

enum CHARACTER_BUFF_FLAGS{
    ICESPEEDDOWN = 1 << 0, 
    FROZEN = 1 << 1, 
    BUTTER = 1 << 2, 
    HYPNOSES = 1 << 3, 
    REDHEAT = 1 << 4, 
    ALL = 2 ** 32 - 1
}

enum CHARACTER_PHYSIQUE_TYPE{
    NUT = 1 << 0, 
    POT = 1 << 1, 
    LILYPAD = 1 << 2, 
    COFFEE = 1 << 3, 
    SPIKE = 1 << 4, 
    VASE = 1 << 5, 
    LIGHT = 1 << 6
}


enum ZOMBIE_PHYSIQUE{
    NOONE = 0, 
    SMALL = 1, 
    NORMAL = 2, 
    MID = 3, 
    HUGE = 4, 
    CAR = 5, 
    BOSS = 6, 
}


enum ARMOR_METHOD_FLAGS{
    NOONE = 1 << 0, 
    BODY = 1 << 1, 
    SHIELD = 1 << 2, 
    HELM = 1 << 3, 
    METALLIC = 1 << 4, 
    INVINCIBLE = 1 << 5, 
    DAMAGEABLE = 1 << 6, 
    DROPABLE = 1 << 7, 
    PASSDAMAGE = 1 << 8, 
    ABSORBOVERFLOW = 1 << 9, 
    CANT_PENETRATE = 1 << 10, 
}


enum PLANTGRIDTYPE{
    ALL = -1, 
    NOONE = 0, 
    SOIL = 1, 
    GROUND = 2, 
    WATER = 3, 
    AIR = 4, 
    LILYPAD = 5, 
    POT = 6, 
    SURROUND = 7, 
    GRAVESTONE = 8, 
    CRATER = 9, 
    BRICK = 10, 
}


enum ELEMENT_SYSTEM{
    ICE = 1 << 0, 
    FIRE = 1 << 1
}


enum PROJECTILE_DAMAGE_FLAG{
    HITSHIELD = 1 << 0, 
    HITBODY = 1 << 1, 
    FIRE = 1 << 2
}

enum PROJECTILE_FIRE_METHOD_FLAG{
    SHOOTER = 1 << 0, 
    CATAPULT = 1 << 1, 
    PENETRATE = 1 << 2, 
    BACK = 1 << 3, 
    ROLLING = 1 << 4, 
    TRACK = 1 << 5
}


enum RANGE_TYPE{
    NOONE = 0, 
    AREA = 1, 
    ROW = 2, 
    ENEMY = 3
}


enum TARGET_NEAR_METHOD{
    DEFAULT = 0, 
    POSITION = 1, 
}


enum LEVEL_FINISH_METHOD{
    WAVE, 
    VASE
}

enum LEVEL_REWARDTYPE{
    NOONE, 
    PACKET, 
    COLLECTABLE, 
    COIN, 
}

enum LEVEL_SEEDBANK_METHOD{
    NOONE = 0, 
    CHOOSE = 1, 
    PRESET = 2, 
    CONVEYOR = 3, 
    RAIN = 4, 
}

enum VASE_TYPE{
    NORMAL = 0, 
    PLANT = 1, 
    ZOMBIE = 2
}
