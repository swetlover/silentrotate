local Addon = select(1, ...)
local SilentRotate = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

-- Is Tranqshot Mode? (default mode)
function SilentRotate:isTranqMode(mode)
    return not SilentRotate:isRazMode(mode) and not SilentRotate:isLoathebMode(mode) and not SilentRotate:isDistractMode(mode) and not SilentRotate:isFearWardMode(mode)
end

function SilentRotate:isRazMode(mode)
    if (not mode) then mode = SilentRotate.db.profile.currentMode end
    return mode == 'priestz'
end

function SilentRotate:isLoathebMode(mode)
    if (not mode) then mode = SilentRotate.db.profile.currentMode end
    return mode == 'healerz'
end

function SilentRotate:isDistractMode(mode)
    if (not mode) then mode = SilentRotate.db.profile.currentMode end
    return mode == 'roguez'
end

function SilentRotate:isFearWardMode(mode)
    if (not mode) then mode = SilentRotate.db.profile.currentMode end
    return mode == 'fearz'
end

-- -- Setters shown here to list available modes, but no one should ever call these functions
-- function SilentRotate:setTranqMode()
--     SilentRotate.db.profile.currentMode = 'hunterz'
-- end
-- function SilentRotate:setRazMode()
--     SilentRotate.db.profile.currentMode = 'priestz'
-- end
-- function SilentRotate:setLoathebMode()
--     SilentRotate.db.profile.currentMode = 'healerz'
-- end
-- function SilentRotate:setDistractMode()
--     SilentRotate.db.profile.currentMode = 'roguez'
-- end
-- function SilentRotate:setFearWardMode()
--     SilentRotate.db.profile.currentMode = 'fearz'
-- end

-- Activate the specific mode
function SilentRotate:activateMode(modeName)
    if modeName == SilentRotate.db.profile.currentMode then return end

    oldFrame = SilentRotate.mainFrame.modeFrames[SilentRotate.db.profile.currentMode]
    if oldFrame then
        oldFrame.texture:SetColorTexture(SilentRotate.colors.darkBlue:GetRGB())
    end

    newFrame = SilentRotate.mainFrame.modeFrames[modeName]
    if newFrame then
        SilentRotate.db.profile.currentMode = modeName
        newFrame.texture:SetColorTexture(SilentRotate.colors.blue:GetRGB())
        SilentRotate:updateRaidStatus()
        local AceConfigDialog = LibStub("AceConfigDialog-3.0")
        AceConfigDialog:ConfigTableChanged("", Addon)
    end
end

-- Return true if the player is recommended for a specific mode
-- If className is nil, the class is fetched from the unit
-- If mode is nil, use the current mode instead
function SilentRotate:isPlayerWanted(unit, className, mode)
    if className == nil then
        className = (select(2,UnitClass(unit)))
    end

    if SilentRotate:isRazMode(mode) then
        return className == 'PRIEST'
    elseif SilentRotate:isLoathebMode(mode) then
        return className == 'PRIEST' or className == 'PALADIN' or className == 'SHAMAN' or className == 'DRUID'
    elseif SilentRotate:isDistractMode(mode) then
        return className == 'ROGUE'
    elseif SilentRotate:isFearWardMode(mode) then
        return className == 'PRIEST' and select(2,UnitRace(unit)) == 'Dwarf'
    end
    return className == 'HUNTER' -- hunter is the default mode
end

-- Get the default duration known for a specific mode
-- If mode is nil, use the current mode instead
function SilentRotate:getModeDuration(mode)
    if (not mode) then mode = SilentRotate.db.profile.currentMode end

    local duration
    if SilentRotate:isTranqMode() then
        duration = 20 -- Cooldown of Hunter's Tranquilizing Shot
    elseif SilentRotate:isLoathebMode() then
        duration = 60 -- Corrupted Mind debuff that prevents healing spells
    elseif SilentRotate:isDistractMode() then
        duration = 30 -- Cooldown of Rogue's Distract
    elseif SilentRotate:isFearWardMode() then
        duration = 30
    else
        duration = 0 -- Duration should have no meaning for other modes
    end

    return duration
end

-- Each mode has a specific Broadcast text so that it does not conflict with other modes
function SilentRotate:getBroadcastHeaderText()
    if SilentRotate:isRazMode() then
        return L['BROADCAST_HEADER_TEXT_RAZUVIOUS']
    elseif SilentRotate:isLoathebMode() then
        return L['BROADCAST_HEADER_TEXT_LOATHEB']
    elseif SilentRotate:isDistractMode() then
        return L['BROADCAST_HEADER_TEXT_DISTRACT']
    elseif SilentRotate:isFearWardMode() then
        return L['BROADCAST_HEADER_TEXT_FEARWARD']
    end
    return L['BROADCAST_HEADER_TEXT']
end