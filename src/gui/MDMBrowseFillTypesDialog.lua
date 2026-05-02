-- MDMBrowseFillTypesDialog.lua
-- Scrollable list of all available fill types tracked by the market.
-- Opened from MDMEventFillTypeDialog footer.

MDMBrowseFillTypesDialog = {}
local MDMBrowseFillTypesDialog_mt = Class(MDMBrowseFillTypesDialog, MessageDialog)

function MDMBrowseFillTypesDialog.new(target, custom_mt)
    local self = MessageDialog.new(target, custom_mt or MDMBrowseFillTypesDialog_mt)

    self.isOpen = false
    self.scrollingLayout = nil

    return self
end

function MDMBrowseFillTypesDialog:onCreate()
    MDMBrowseFillTypesDialog:superClass().onCreate(self)
end

function MDMBrowseFillTypesDialog:onGuiSetupFinished()
    MDMBrowseFillTypesDialog:superClass().onGuiSetupFinished(self)
    self.scrollingLayout = self:getDescendantById("scrollingLayout")
end

function MDMBrowseFillTypesDialog:onOpen()
    MDMBrowseFillTypesDialog:superClass().onOpen(self)
    self.isOpen = true
    self._isPending = false
    self:_populate()
end

function MDMBrowseFillTypesDialog:setCallback(callback)
    self.callback = callback
end

function MDMBrowseFillTypesDialog:onClose()
    self.isOpen = false
    self._isPending = false
    self.callback = nil
    MDMBrowseFillTypesDialog:superClass().onClose(self)
end

function MDMBrowseFillTypesDialog:onCloseClick()
    self:close()
end

function MDMBrowseFillTypesDialog:_populate()
    if not self.scrollingLayout then return end
    
    -- Only populate once per session (fill types are static)
    -- Actually, if we want to change profiles or behavior, we might want to clear it,
    -- but usually fill types don't change.
    if #self.scrollingLayout.elements > 0 then return end

    if not g_fillTypeManager or not g_MarketDynamics then return end
    local engine = g_MarketDynamics.marketEngine
    
    local fillTypes = {}
    for _, ft in ipairs(g_fillTypeManager:getFillTypes()) do
        if ft and ft.index and ft.index > 1 and ft.name and ft.name ~= ""
           and engine and engine.prices[ft.index] then
            table.insert(fillTypes, { name = ft.name, title = ft.title or ft.name })
        end
    end
    table.sort(fillTypes, function(a, b) return a.title < b.title end)

    for _, data in ipairs(fillTypes) do
        local el = ButtonElement.new(self)
        el:loadProfile(g_gui:getProfile("mdmFt_row"), true)
        el:setText(string.format("%s  [%s]", data.title, data.name))
        
        -- Force disable background overlays (fixes the "white box" issue in Giants Engine)
        -- We must keep the tables but set colors to transparent to avoid internal engine crashes.
        el.overlay = { color = {0,0,0,0}, colorFocused = {0,0,0,0}, colorPressed = {0,0,0,0}, colorDisabled = {0,0,0,0}, colorHighlighted = {0,0,0,0} }
        el.icon    = { color = {0,0,0,0}, colorFocused = {0,0,0,0}, colorPressed = {0,0,0,0}, colorDisabled = {0,0,0,0}, colorHighlighted = {0,0,0,0} }
        el.textColor = {1, 1, 1, 1}
        el.textFocusedColor = {1, 0.85, 0.1, 1}

        -- Set callback for the button
        el.onClickCallback = function()
            if self.callback then
                self.callback(data.name)
            end
            self:close()
        end
        
        self.scrollingLayout:addElement(el)
        el:onGuiSetupFinished()
    end
    
    self.scrollingLayout:invalidateLayout()
end
