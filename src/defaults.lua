local L = LibStub("AceLocale-3.0"):GetLocale("SilentRotate")

function SilentRotate:LoadDefaults()
	self.defaults = {
	    profile = {
			-- Messaging
	        enableAnnounces = true,
	        channelType = "YELL",
	        rotationReportChannelType = "RAID",
	        useMultilineRotationReport = false,
	        announceTranqshotSuccessMessage = L["DEFAULT_TRANQSHOT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceTranqshotFailMessage = L["DEFAULT_TRANQSHOT_FAIL_ANNOUNCE_MESSAGE"],
			whisperFailMessage = L["DEFAULT_TRANQSHOT_FAIL_WHISPER_MESSAGE"], -- not used anymore, kept for compatibility
	        announceLoathebMessage = L["DEFAULT_LOATHEB_ANNOUNCE_MESSAGE"],
	        announceDistractSuccessMessage = L["DEFAULT_DISTRACT_SUCCESS_ANNOUNCE_MESSAGE"],
	        announceDistractFailMessage = L["DEFAULT_DISTRACT_FAIL_ANNOUNCE_MESSAGE"],
	        announceFearWardMessage = L["DEFAULT_FEARWARD_ANNOUNCE_MESSAGE"],

			-- Modes
			currentMode = nil, -- Will be set based on *modeButton flags at the end of this file
			tranqModeButton    = SilentRotate:isPlayerWanted("player", nil, 'hunterz'),
			loathebModeButton  = SilentRotate:isPlayerWanted("player", nil, 'healerz'),
			distractModeButton = SilentRotate:isPlayerWanted("player", nil, 'roguez'),
			razModeButton = false, -- SilentRotate:isPlayerWanted("player", nil, 'priestz'), -- Do not allow Razuvious mode for now
			fearWardModeButton = SilentRotate:isPlayerWanted("player", nil, 'fearz'),
			tranqModeText    = L["FILTER_SHOW_HUNTERS"],
			loathebModeText  = L["FILTER_SHOW_HEALERS"],
			distractModeText = L["FILTER_SHOW_ROGUES"],
			razModeText      = L["FILTER_SHOW_PRIESTS"],
			fearWardModeText = L["FILTER_SHOW_DWARVES"],

			-- Names
			useClassColor = true,
			useNameOutline = false,
			appendGroup = false,
			groupSuffix = L["DEFAULT_GROUP_SUFFIX_MESSAGE"],
			groupSuffixColor = {SilentRotate.colors.lightGray:GetRGB()},

			-- Background
			neutralBackgroundColor = {SilentRotate.colors.lightGray:GetRGB()},
			activeBackgroundColor  = {SilentRotate.colors.purple:GetRGB()},
			deadBackgroundColor    = {SilentRotate.colors.red:GetRGB()},
			offlineBackgroundColor = {SilentRotate.colors.darkGray:GetRGB()},

			-- Sounds
			enableNextToTranqSound = true,
			enableTranqNowSound = true,
			tranqNowSound = 'alarm1',

			-- Miscellaneous
			lock = false,
			hideNotInRaid = false,
			doNotShowWindowOnRaidJoin = false,
			showWindowWhenTargetingBoss = false,
	    },
	
	}
	-- Find the default mode based on class compatibility
	if (self.defaults.profile.tranqModeButton) then
		self.defaults.profile.currentMode = 'hunterz'
	elseif (self.defaults.profile.loathebModeButton) then
		self.defaults.profile.currentMode = 'healerz'
	elseif (self.defaults.profile.distractModeButton) then
		self.defaults.profile.currentMode = 'roguez'
	elseif (self.defaults.profile.fearWardModeButton) then
		self.defaults.profile.currentMode = 'fearz'
	else
		-- Use Loatheb mode by default for classes who cannot fit other roles
		-- Also enable this option by default
		self.defaults.profile.tranqModeButton = true
		self.defaults.profile.currentMode = 'hunterz'
	end
end
