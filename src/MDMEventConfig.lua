-- MDMEventConfig.lua
-- Loads a user-editable XML configuration for event fill types.
-- Users can add custom fill type names (e.g. from custom maps / mods)
-- to any registered event so those crops are also affected.
--
-- Config file location: <savegameDirectory>/FS25_MarketDynamics_eventConfig.xml
-- An annotated example is shipped with the mod at: xml/MDMEventConfig_example.xml
--
-- Per-event extra fill types get the PRIMARY factor for that event.
-- (For multi-factor events like Protein Premium, that is the higher-intensity group.)
--
-- Author: tison (dev-1)

MDMEventConfig = {}

local _extraFillTypes = {}  -- { [eventId] = { fillTypeName, ... } }

-- Load user config from the savegame directory.
-- Called by MarketDynamics:onStartMission() once the savegame path is known.
function MDMEventConfig.load(savegameDir)
    _extraFillTypes = {}

    if not savegameDir or savegameDir == "" then
        MDMLog.info("MDMEventConfig: no savegame directory — skipping user event config")
        return
    end

    local path    = savegameDir .. "/FS25_MarketDynamics_eventConfig.xml"
    local xmlFile = loadXMLFile("MDMEventConfig", path)

    if not xmlFile or xmlFile == 0 then
        MDMLog.info("MDMEventConfig: no event config file found at " .. path .. " — using built-in crop lists")
        return
    end

    local total = 0
    local i = 0
    while true do
        local base    = "MDMEventConfig.event(" .. i .. ")"
        local eventId = getXMLString(xmlFile, base .. "#id")
        if not eventId then break end

        _extraFillTypes[eventId] = _extraFillTypes[eventId] or {}

        local j = 0
        while true do
            local ftBase = base .. ".fillType(" .. j .. ")"
            local name   = getXMLString(xmlFile, ftBase .. "#name")
            if not name then break end
            table.insert(_extraFillTypes[eventId], name)
            total = total + 1
            j = j + 1
        end

        i = i + 1
    end

    delete(xmlFile)
    MDMLog.info(string.format("MDMEventConfig: loaded %d extra fill type(s) across %d event(s)", total, i))
end

-- Returns the list of user-configured extra fill type names for an event.
function MDMEventConfig.getExtraFillTypes(eventId)
    return _extraFillTypes[eventId] or {}
end

-- Apply extra fill type modifiers for an event at the given factor.
-- Called from each event's onFire (and onLoad for events with state tracking).
function MDMEventConfig.applyExtra(eventId, factor)
    if not g_MarketDynamics then return end
    for _, name in ipairs(_extraFillTypes[eventId] or {}) do
        local ft = g_fillTypeManager:getFillTypeByName(name)
        if ft then
            g_MarketDynamics.marketEngine:addModifier({
                id            = eventId .. "_cfg_" .. name,
                fillTypeIndex = ft.index,
                factor        = factor,
            })
        end
    end
end

-- Remove extra fill type modifiers for an event.
-- Called from each event's onExpire.
function MDMEventConfig.removeExtra(eventId)
    if not g_MarketDynamics then return end
    for _, name in ipairs(_extraFillTypes[eventId] or {}) do
        local ft = g_fillTypeManager:getFillTypeByName(name)
        if ft then
            g_MarketDynamics.marketEngine:removeModifierById(ft.index, eventId .. "_cfg_" .. name)
        end
    end
end
