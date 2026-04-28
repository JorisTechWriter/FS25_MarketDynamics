-- FS25_MarketDynamics / main.lua
-- Entry point. Loads all modules in dependency order, then hooks into the game lifecycle.
-- Log prefix: [MDM]  |  Global: g_MarketDynamics
--
-- Authors: TheCodingDad (tison) — core systems
--          LeGrizzly             — GUI systems

local modDirectory = g_currentModDirectory
local modName      = g_currentModName

-- Menu icon global (resolved by XML imageFilename via hook below)
g_MDMIconMenu = Utils.getFilename("images/menuIcon.dds", g_currentModDirectory)

-- Resolve mod icon globals in XML imageFilename attributes (EmployeeManager pattern)
local MDM_ICON_GLOBALS = {
    g_MDMIconMenu = true,
}

local function mdmResolveFilename(self, superFunc)
    local filename = superFunc(self)
    if MDM_ICON_GLOBALS[filename] then
        return _G[filename]
    end
    return filename
end

GuiOverlay.resolveFilename = Utils.overwrittenFunction(GuiOverlay.resolveFilename, mdmResolveFilename)

-- ---------------------------------------------------------------------------
-- Lifecycle hooks
-- ---------------------------------------------------------------------------

local mdm = nil  -- will hold the MarketDynamics instance

local function onLoad(mission)
    mdm = MarketDynamics.new(modDirectory, modName)
    getfenv(0)["g_MarketDynamics"] = mdm
    if g_currentMission then
        g_currentMission.MarketDynamics = mdm
    end
end

local function onLoadFinished(mission)
    if mdm then
        mdm:onMissionLoaded(mission)
    end
end

local function onStartMission(mission)
    if mdm then
        mdm:onStartMission(mission)
    end
end

local function onUpdate(mission, dt)
    if mdm then
        mdm:update(dt)
    end
end

local function onDraw(mission)
    if mdm then
        mdm:draw()
    end
end

local function onSave(mission, xmlFile)
    if mdm then
        mdm:save(xmlFile)
    end
end

local function onDelete(mission)
    if mdm then
        mdm:delete()
        mdm = nil
        getfenv(0)["g_MarketDynamics"] = nil
        if g_currentMission then
            g_currentMission.MarketDynamics = nil
        end
    end
end

-- Attach to game hooks
Mission00.load                  = Utils.prependedFunction(Mission00.load,                  onLoad)
Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished,  onLoadFinished)
Mission00.onStartMission        = Utils.appendedFunction(Mission00.onStartMission,         onStartMission)
FSBaseMission.update            = Utils.appendedFunction(FSBaseMission.update,             onUpdate)
FSBaseMission.draw              = Utils.appendedFunction(FSBaseMission.draw,               onDraw)
FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, onSave)
FSBaseMission.delete            = Utils.appendedFunction(FSBaseMission.delete,             onDelete)
