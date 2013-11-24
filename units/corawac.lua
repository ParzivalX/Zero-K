unitDef = {
  unitname            = [[corawac]],
  name                = [[Vulture]],
  description         = [[Stealth Radar/Sonar Plane]],
  altfromsealevel     = [[1]],
  amphibious          = true,
  buildCostEnergy     = 340,
  buildCostMetal      = 340,
  builder             = false,
  buildPic            = [[CORAWAC.png]],
  buildTime           = 340,
  canAttack           = false,
  canDropFlare        = false,
  canFly              = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canSubmerge         = false,
  category            = [[UNARMED FIXEDWING]],
  collide             = false,
  collisionVolumeOffsets = [[0 0 0]],
  collisionVolumeScales  = [[35 12 60]],
  collisionVolumeTest    = 1,
  collisionVolumeType    = [[box]],
  corpse              = [[DEAD]],
  cruiseAlt           = 250,

  customParams        = {
    description_bp = [[Avi?o invisível a radar com radar e sonar]],
    description_fr = [[Avion Sonar/Radar Furtif]],
	description_de = [[Tarnkappen Radar/Sonar Flugzeug]],
	description_pl = [[Samolot zwiadowczy]],
    helptext       = [[The Vulture provides an unparalleled means for deep scouting, and can locate underwater targets with its sonar.]],
    helptext_bp    = [[Este avi?o possui radar, sonar e um grande raio de vis?o, e desta forma pode encontrar inimigos escondidos com maior facilidade que a maioria das unidades batedoras.]],
    helptext_fr    = [[Summum de la technologie d'information, ses multiples capteurs vous renseigneront sur toutes les activit?s ennemies: terrestre aerienne ou sousmarine.]],
	helptext_de    = [[Der Vulture bietet dir die beispiellose Möglichkeit zur unerkannten, weitläufigen Aufklärung und kann mit seinem Sonar auch Unterwasserziele lokalisieren.]],
	helptext_pl    = [[Vulture jest niedorownany w szybkim zwiadzie; oprocz radaru posiada takze sonar do wykrywania celow podwodnych oraz pasywny zaklocacz radaru.]],
	modelradius    = [[20]],
	specialreloadtime = [[600]],
  },

  energyUse           = 1.5,
  explodeAs           = [[GUNSHIPEX]],
  floater             = true,
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = [[radarplane]],
  idleAutoHeal        = 5,
  idleTime            = 1800,
  mass                = 182,
  maxAcc              = 0.5,
  maxDamage           = 950,
  maxAileron          = 0.018,
  maxElevator         = 0.02,
  maxRudder           = 0.008,
  maxVelocity         = 12,
  minCloakDistance    = 75,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM SATELLITE FIXEDWING GUNSHIP HOVER SHIP SWIM SUB LAND FLOAT SINK TURRET]],
  objectName          = [[armpnix.s3o]],
  radarDistance       = 2400,
  script              = [[corawac.lua]],
  seismicSignature    = 0,
  selfDestructAs      = [[GUNSHIPEX]],
  side                = [[CORE]],
  sightDistance       = 1400,
  smoothAnim          = true,
  sonarDistance       = 1400,
  stealth             = true,
  turnRadius          = 1,
  workerTime          = 0,

  featureDefs         = {

    DEAD = {
      description      = [[Wreckage - Vulture]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 850,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[40]],
      hitdensity       = [[100]],
      metal            = 136,
      object           = [[armpnix_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 136,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Vulture]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 850,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 68,
      object           = [[debris2x2b.s3o]],
      reclaimable      = true,
      reclaimTime      = 68,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ corawac = unitDef })
