unitDef = {
  unitname            = [[hoverdepthcharge]],
  name                = [[Morningstar]],
  description         = [[Antisub Hovercraft]],
  acceleration        = 0.048,
  activateWhenBuilt   = true,
  brakeRate           = 0.043,
  buildCostEnergy     = 300,
  buildCostMetal      = 300,
  builder             = false,
  buildPic            = [[hoversonic.png]],
  buildTime           = 300,
  canAttack           = true,
  canGuard            = true,
  canHover            = true,
  canMove             = true,
  canPatrol           = true,
  category            = [[HOVER]],
  collisionVolumeOffsets  = [[0 0 0]],
  collisionVolumeScales   = [[55 55 55]],
  collisionVolumeTest	  = 1,
  collisionVolumeType	  = [[ellipsoid]],
  corpse              = [[DEAD]],

  customParams        = {
    helptext        = [[The Morningstar is armed with a heavy depthcharge launcher and has no qualms about dropping it on land.]],
    description_pl  = [[Poduszkowiec przeciwpodwodny]],
    helptext_pl     = [[Morningstar jest uzbrojony w ciezkie ladunki glebinowe, ktore moze wyrzucac takze na ladzie.]],
    turnatfullspeed = [[1]],
  },

  explodeAs           = [[BIG_UNITEX]],
  footprintX          = 3,
  footprintZ          = 3,
  iconType            = [[hoverspecial]],
  idleAutoHeal        = 5,
  idleTime            = 1800,
  mass                = 184,
  maxDamage           = 900,
  maxSlope            = 36,
  maxVelocity         = 3.3,
  minCloakDistance    = 75,
  movementClass       = [[HOVER3]],
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[hoverassault.s3o]],
  script			  = [[hoverdepthcharge.lua]],
  seismicSignature    = 4,
  selfDestructAs      = [[BIG_UNITEX]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:HEAVYHOVERS_ON_GROUND]],
      [[custom:RAIDMUZZLE]],
    },

  },

  side                = [[CORE]],
  sightDistance       = 385,
  sonarDistance       = 300,
  turninplace         = 0,
  turnRate            = 300,
  workerTime          = 0,

  weapons             = {

    {
      def                = [[DEPTHCHARGE]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[SWIM FIXEDWING LAND SUB SINK TURRET FLOAT SHIP GUNSHIP HOVER]],
    },
	
	{
      def                = [[FAKEGUN]],
      onlyTargetCategory = [[LAND SINK TURRET SHIP SWIM FLOAT HOVER]],
    },

  },

  weaponDefs             = {

    DEPTHCHARGE = {
      name                    = [[Depth Charge]],
      areaOfEffect            = 290,
      avoidFriendly           = false,
	  bounceSlip              = 0.4,
	  bounceRebound           = 0.95,
      collideFriendly         = false,
      craterBoost             = 1,
      craterMult              = 2,

      damage                  = {
        default = 1150,
      },

      edgeEffectiveness       = 0.4,
      explosionGenerator      = [[custom:TORPEDOHITHUGE]],
      fixedLauncher           = true,
	  groundBounce            = true,
	  heightMod               = 0,
	  impulseBoost            = 0.5,
      impulseFactor           = 1,
      interceptedByShieldType = 1,
      model                   = [[depthcharge_big.s3o]],
	  myGravity               = 0.15,
      noSelfDamage            = false,
      numbounce               = 4,
      predictBoost            = 0,
      range                   = 180,
      reloadtime              = 8,
      soundHitDry             = [[explosion/mini_nuke]],
      soundHitWet             = [[explosion/wet/ex_underwater]],
      soundStart              = [[weapon/torp_land]],
      soundStartVolume        = 8,
      startVelocity           = 20,
      tolerance               = 1000000,
      tracks                  = true,
      turnRate                = 30000,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 20,
      weaponType              = [[TorpedoLauncher]],
      weaponVelocity          = 120,
    },
	
	FAKEGUN = {
      name                    = [[Fake Weapon]],
      areaOfEffect            = 8,
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 1E-06,
        planes  = 1E-06,
        subs    = 5E-08,
      },

      explosionGenerator      = [[custom:NONE]],
      fireStarter             = 0,
      impactOnly              = true,
      interceptedByShieldType = 1,
      range                   = 100,
      reloadtime              = 8,
      size                    = 1E-06,
      smokeTrail              = false,

      textures                = {
        [[null]],
        [[null]],
        [[null]],
      },

      turnrate                = 10000,
      turret                  = true,
	  waterWeapon             = true,
      weaponAcceleration      = 200,
      weaponTimer             = 0.1,
      weaponType              = [[StarburstLauncher]],
      weaponVelocity          = 200,
    },

  },


  featureDefs         = {

    DEAD  = {
      description      = [[Wreckage - Punisher]],
      blocking         = false,
      category         = [[corpses]],
      damage           = 1200,
      energy           = 0,
      featureDead      = [[DEAD2]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 96,
      object           = [[hoverassault_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 96,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    DEAD2 = {
      description      = [[Debris - Morningstar]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 750,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      hitdensity       = [[100]],
      metal            = 96,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 96,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Morningstar]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 750,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      hitdensity       = [[100]],
      metal            = 48,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 48,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ hoverdepthcharge = unitDef })