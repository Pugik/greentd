-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#

function _HOST:InitRules()
    self.GamemodeEntity = GameRules:GetGameModeEntity()
	if self.GamemodeEntity == nil then return end

    -- Gamemode Setup
    GameRules:SetSafeToLeave(GAME_SAFE_TO_LEAVE)
	GameRules:EnableCustomGameSetupAutoLaunch(GAME_AUTO_LAUNCH)
	GameRules:SetCustomGameSetupAutoLaunchDelay(GAME_AUTO_LAUNCH_DELAY)
    
	GameRules:SetSameHeroSelectionEnabled(GAME_ALLOW_SAME_HERO_SELECTION)
	GameRules:SetHeroRespawnEnabled(GAME_HERO_RESPAWN_ENABLED)
	self.GamemodeEntity:SetCustomGameForceHero(GAME_FORCE_HERO)
	
	self.GamemodeEntity:SetUseDefaultDOTARuneSpawnLogic(GAME_DOTARUNE_LOGIC)
	self.GamemodeEntity:SetFreeCourierModeEnabled(GAME_FREE_COURIER_ENABLED)
	
	self.GamemodeEntity:SetDaynightCycleDisabled(GAME_DAYNIGHT_DISABLED)
	self.GamemodeEntity:SetFogOfWarDisabled(GAME_FOG_DISABLED)
	self.GamemodeEntity:SetUnseenFogOfWarEnabled(GAME_FOG_EXPLORER_ENABLED)
		
	-- Pre Timers
	GameRules:SetHeroSelectionTime(GAME_HERO_SELECTION_TIME)
	GameRules:SetHeroSelectPenaltyTime(GAME_HERO_SELECTION_PENALTY)
	GameRules:SetStrategyTime(GAME_HERO_STRATEGY_TIME)
	GameRules:SetShowcaseTime(GAME_HERO_SHOWCASE_TIME)
	
	-- Main Timers
	GameRules:SetPreGameTime(GAME_PRE_TIME)
	GameRules:SetPostGameTime(GAME_POST_TIME)
		
	-- Teams
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 5)

	-- Camera
	self.GamemodeEntity:SetCameraZRange(CAMERA_Z_MIN, CAMERA_Z_MAX)
	self.GamemodeEntity:SetCameraDistanceOverride(CAMERA_DISTANCE)
	
	-- Announcer
	self.GamemodeEntity:SetAnnouncerDisabled(ANNOUNCER_DISABLED)
	self.GamemodeEntity:SetAnnouncerGameModeAnnounceDisabled(ANNOUNCER_GAMEMODE_DISABLED)
	self.GamemodeEntity:SetKillingSpreeAnnouncerDisabled(ANNOUNCER_KILLING_SPREE_DISABLED)
end