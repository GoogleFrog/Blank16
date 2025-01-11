local mapInfo = {
  author = "Your Name Here",
  description = "Blank 16x16 map",
  modtype = 3,
  name = "Blank16",
  shortname = "Blank16",
  version = "v0.0",
  voidGround = false,
  voidWater = false,
  custom = {},
  depend = {
    "Map Helper v1",
  },
  grass = {},
  replace = {},
  maphardness     = 350,
  gravity         = 130,
  tidalStrength   = 0,
  maxMetal        = 1.7,
  extractorRadius = 100.0,
	resources = {
		splatDetailTex = "Zsplat.dds",
		splatDetailNormalDiffuseAlpha = 1,
		splatDetailNormalTex1 = "grass.tga",
		splatDetailNormalTex2 = "AngledRock.dds", 
		splatDetailNormalTex3 = "highground.dds",
		splatDistrTex = "fake.png",
	},
  splats = {
	texScales = { 0.004, 0.003, .0018, .000001},
	texMults  = { 0.5,    0.8,     .9,   0.0001},
  },
  smf = {
    maxheight = 200,
    minheight = -100,
    smtFileName0 = "Blank.smt",
  },
  teams = {
    [0] = {
      startPos = {
        x = 3072,
        z = 3072,
      },
    },
    [1] = {
      startPos = {
        x = 3072,
        z = 3072,
      },
    },
    [2] = {
      startPos = {
        x = 3072,
        z = 3072,
      },
    },
  },
  terrainTypes = {},
	atmosphere = {
		minWind      = 5.0,
		maxWind      = 25.0,

		fogStart     = 0,
		fogEnd       = 500,
		fogColor     = {0.7, 0.7, 0.8},

		sunColor     = {1.0, 1.0, 1.0},
		skyColor     = {0.1, 0.15, 0.7},
		skyDir       = {0.0, 0.0, -1.0},
		skyBox       = "",

		cloudDensity = 0.5,
		cloudColor   = {1.0, 1.0, 1.0},
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sundir        = { 0.5, 0.4, 0.3 },

		--// unit & ground lighting
         groundambientcolor            = { 0.6, 0.6, 0.3 },
         grounddiffusecolor            = { 0.76, 0.76, 0.46 },
         groundshadowdensity           = 0.85,
         unitambientcolor           = { 0.8, 0.8, 0.4 },
         unitdiffusecolor           = { 1.0, 1.0, 1.0 },
         unitshadowdensity          = 0.85,
		 specularsuncolor           = { 0.8, 0.8, 0.4 },
		 
		specularExponent    = 100.0,
	},
	
	water = {
		damage =  0,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = { 0.012, 0.006, 0.0045 },
		basecolor = { 0.70, 0.9, 1.0 },
		mincolor  = { 0.0, 0.05, 0.30 },

		ambientFactor  = 1.3,
		diffuseFactor  = 1.0,
		specularFactor = 1.4,
		specularPower  = 40.0,

		surfacecolor  = { 0.6, 0.54, 0.86 },
		surfaceAlpha  = 0.16,
		--diffuseColor  = {0.0, 0.0, 0.0},
		specularColor = {0.5, 0.5, 0.5},
		planeColor = {0.0, 0.36, 0.44},

		fresnelMin   = 0.3,
		fresnelMax   = 0.8,
		fresnelPower = 8.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  8.0,
		perlinLacunarity = 3.0,
		perlinAmplitude  =  0.9,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = true,
		forceRendering = false,
		
		hasWaterPlane = true,

		--// undefined == load them from resources.lua!
		--texture =       "",
		--foamTexture =   "",
		--normalTexture = "",
		--caustics = {
		--	"",
		--	"",
		--},
	},
}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Helper

local function lowerkeys(ta)
    local fix = {}
    for i,v in pairs(ta) do
        if (type(i) == "string") then
            if (i ~= i:lower()) then
                fix[#fix+1] = i
            end
        end
        if (type(v) == "table") then
            lowerkeys(v)
        end
    end

    for i=1,#fix do
        local idx = fix[i]
        ta[idx:lower()] = ta[idx]
        ta[idx] = nil
    end
end

lowerkeys(mapInfo)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Options

if (Spring) then
    local function tmerge(t1, t2)
        for i,v in pairs(t2) do
            if (type(v) == "table") then
                t1[i] = t1[i] or {}
                tmerge(t1[i], v)
            else
                t1[i] = v
            end
        end
    end

    -- make code safe in unitsync
    if (not Spring.GetMapOptions) then
        Spring.GetMapOptions = function() return {} end
    end
    function tobool(val)
        local t = type(val)
        if (t == 'nil') then
            return false
        elseif (t == 'boolean') then
            return val
        elseif (t == 'number') then
            return (val ~= 0)
        elseif (t == 'string') then
            return ((val ~= '0') and (val ~= 'false'))
        end
        return false
    end

    getfenv()["mapInfo"] = mapInfo
        local files = VFS.DirList("mapconfig/mapinfo/", "*.lua")
        table.sort(files)
        for i=1,#files do
            local newcfg = VFS.Include(files[i])
            if newcfg then
                lowerkeys(newcfg)
                tmerge(mapInfo, newcfg)
            end
        end
    getfenv()["mapInfo"] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapInfo
