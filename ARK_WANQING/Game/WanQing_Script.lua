-- WanQing_Script
-- Author: HaoJun0823
-- DateCreated: 8/27/2025 12:11:16 PM
--------------------------------------------------------------


function Do_C(mul,player)
	print("LEADER_RANDERION_ARK_WANQING Autumn Event!")
	for i,pUnit in player:GetUnits():Members() do
		pUnit:GetExperience():ChangeExperience(mul);
		pUnit:ChangeDamage(mul*-1)
	end
	print("WanQing 3 Done.");	
	
end

function Do_B(mul,player)
	print("LEADER_RANDERION_ARK_WANQING Summer Event!")
	for i,pCity in player:GetCities():Members() do
		local pBuildQueue = pCity:GetBuildQueue();
		local population = pCity:GetPopulation()
			if (pBuildQueue ~= nil) then
				pCity:GetBuildQueue():AddProgress(mul*population)
			else
				pPlayer:GetTreasury():ChangeGoldBalance(mul*population)
			end
	end
	print("WanQing 2 Done.");	
end

function Do_A(mul,player)
	print("LEADER_RANDERION_ARK_WANQING Spring Event!")
	local maintenance = player:GetTreasury():GetTotalMaintenance()
		player:GetCulture():ChangeCurrentCulturalProgress(maintenance*mul)
		player:GetTechs():ChangeCurrentResearchProgress(maintenance*mul)
	print("WanQing 1 Done.");	
end

function Do_D(mul,player)
	print("LEADER_RANDERION_ARK_WANQING Winter Event!")
	player:GetDiplomacy():ChangeFavor(mul);
	player:GetInfluence():ChangeTokensToGive(mul);
	print("WanQing 4 Done.");	
end



function GetWQPlayers()
	print("LEADER_RANDERION_ARK_WANQING Player Check!")
	local playerIDS = PlayerManager.GetAliveIDs();
	local result  = {}


	for i, playerId in ipairs(playerIDS) do
		local pPlayer = Players[playerId];
		local playerConfig = PlayerConfigurations[playerId];		
		if pPlayer:IsMajor() and pPlayer:IsAlive() and playerConfig:GetLeaderTypeName() == "LEADER_RANDERION_ARK_WANQING" then
			table.insert(result, pPlayer); 
		end
	end
	return result;

end

function CountDistrict(pPlayer)
	local index = GameInfo.Districts['DISTRICT_WANQING_SPECIAL'].Index
	local total = 0;
	for ix,pCity in pPlayer:GetCities():Members() do
		for i,pDistrict in pCity:GetDistricts():Members() do
			if pDistrict:GetType() == index then
				total = total + 1;
			end
		end
	end
	return total;
end

function GetCapitalToUnit(pUnit, pCity)
	local dist = 9999
	local iDistance = Map.GetPlotDistance(pUnit:GetX(), pUnit:GetY(), pCity:GetX(), pCity:GetY())
    if (iDistance > dist) then
		return 0;
    end
    return iDistance;
end


function WanQingTurn()
	print("Wanqing:Do Turn Start Event.");
	local turn = Game.GetCurrentGameTurn();
	local mod = turn % 4
	local pPlayers = GetWQPlayers();
	for ix,pPlayer in ipairs(pPlayers) do
		local mul = CountDistrict(pPlayer)
		if mod == 1 then
			Do_A(mul,pPlayer)
		end
		if mod == 2 then
			Do_B(mul,pPlayer)
		end
		if mod == 3 then
			Do_C(mul,pPlayer)
		end
		if mod == 4 then
			Do_D(mul,pPlayer)
		end
	end
	for ix,pPlayer in iparis(pPlayers) do
		local pCity = pPlayer:GetCities():GetCapitalCity();
		for i,pUnit in player:GetUnits():Members() do
			local distance = GetCapitalToUnit(pUnit,pCity);
			local yield = distance / 10
			UnitManager.ChangeMovesRemaining(pUnit, yield);
		end
	end
end


Events.TurnBegin.Add( WanQingTurn );