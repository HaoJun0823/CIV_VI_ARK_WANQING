-- WanQing_Script
-- Author: HaoJun0823
-- DateCreated: 8/27/2025 12:11:16 PM
--------------------------------------------------------------

-- 春季事件：基于维护费用增加文化和科技进度
function Do_A(mul, player)
    print("LEADER_RANDERION_ARK_WANQING Spring Event for Player " .. player:GetID())
    local maintenance = player:GetTreasury():GetTotalMaintenance()
    player:GetCulture():ChangeCurrentCulturalProgress(maintenance * mul)
    player:GetTechs():ChangeCurrentResearchProgress(maintenance * mul)
    print("WanQing Spring Done: Added " .. maintenance * mul .. " culture and tech for Player " .. player:GetID())
end

-- 夏季事件：基于人口增加建造进度或金币
function Do_B(mul, player)
    print("LEADER_RANDERION_ARK_WANQING Summer Event for Player " .. player:GetID())
    for _, pCity in player:GetCities():Members() do
        local cityName = Locale.Lookup(pCity:GetName())
        local pBuildQueue = pCity:GetBuildQueue()
        local population = pCity:GetPopulation()
        if pBuildQueue:HasProduction() then
            pBuildQueue:AddProgress(mul * population)
            print("City " .. cityName .. " added " .. mul * population .. " production")
        else
            player:GetTreasury():ChangeGoldBalance(mul * population)
            print("City " .. cityName .. " added " .. mul * population .. " gold")
        end
    end
    print("WanQing Summer Done for Player " .. player:GetID())
end

-- 秋季事件：为所有单位增加经验并减少伤害
function Do_C(mul, player)
    print("LEADER_RANDERION_ARK_WANQING Autumn Event for Player " .. player:GetID())
    for _, pUnit in player:GetUnits():Members() do
        pUnit:GetExperience():ChangeExperience(mul)
        pUnit:ChangeDamage(mul * -1)
        print("Unit at (" .. pUnit:GetX() .. "," .. pUnit:GetY() .. ") gained " .. mul .. " XP and healed " .. mul)
    end
    print("WanQing Autumn Done for Player " .. player:GetID())
end

-- 冬季事件：增加外交支持和影响力点数
function Do_D(mul, player)
    print("LEADER_RANDERION_ARK_WANQING Winter Event for Player " .. player:GetID())
    player:GetDiplomacy():ChangeFavor(mul)
    player:GetInfluence():ChangeTokensToGive(mul)
    print("WanQing Winter Done: Added " .. mul .. " favor and influence for Player " .. player:GetID())
end

-- 获取所有使用WANQING领袖的玩家
function GetWQPlayers()
    print("LEADER??
    local playerIDS = PlayerManager.GetAliveIDs()
    local result = {}
    for _, playerId in ipairs(playerIDS) do
        local pPlayer = Players[playerId]
        local playerConfig = PlayerConfigurations[playerId]
        if pPlayer:IsMajor() and pPlayer:IsAlive() and playerConfig:GetLeaderTypeName() == "LEADER_RANDERION_ARK_WANQING" then
            table.insert(result, pPlayer)
            print("Found WanQing player: " .. playerId)
        end
    end
    return result
end

-- 统计玩家的WANQING特殊区域数量
function CountDistrict(pPlayer)
    local index = GameInfo.Districts["DISTRICT_WANQING_SPECIAL"].Index
    if not index then
        print("Error: DISTRICT_WANQING_SPECIAL not found in GameInfo.Districts")
        return 0
    end
    local total = 0
    for _, pCity in pPlayer:GetCities():Members() do
        local cityName = Locale.Lookup(pCity:GetName())
        for _, pDistrict in ipairs(pCity:GetDistricts():GetDistricts()) do
            if pDistrict:GetType() == index then
                total = total + 1
                print("Found DISTRICT_WANQING_SPECIAL in " .. cityName)
            end
        end
    end
    print("Player " .. pPlayer:GetID() .. " has " .. total .. " DISTRICT_WANQING_SPECIAL")
    return total
end

-- 计算单位到首都的距离并返回移动力加成
function GetCapitalToUnit(pUnit, pCity)
    if not pCity then return 0 end
    local iDistance = Map.GetPlotDistance(pUnit:GetX(), pUnit:GetY(), pCity:GetX(), pCity:GetY())
    return math.floor(iDistance / 10) -- 每10格距离提供1点移动力
end

-- 每回合触发WANQING事件和移动力调整
function WanQingTurn()
    print("WanQing: Do Turn Start Event, Turn " .. Game.GetCurrentGameTurn())
    local turn = Game.GetCurrentGameTurn()
    local mod = (turn - 1) % 4 + 1 -- 确保mod值为1到4
    local pPlayers = GetWQPlayers()
    
    -- 季节性事件
    for _, pPlayer in ipairs(pPlayers) do
        local mul = CountDistrict(pPlayer)
        print("Player " .. pPlayer:GetID() .. " multiplier: " .. mul)
        if mod == 1 then
            Do_A(mul, pPlayer)
        elseif mod == 2 then
            Do_B(mul, pPlayer)
        elseif mod == 3 then
            Do_C(mul, pPlayer)
        elseif mod == 4 then
            Do_D(mul, pPlayer)
        end
		--特殊区域增加信仰
		local citiesCount = pPlayer:GetCities():GetCount();
		pPlayer:GetReligion():ChangeFaithBalance(citiesCount*mul)
    end
    
    -- 移动力调整
    for _, pPlayer in ipairs(pPlayers) do
        local pCity = pPlayer:GetCities():GetCapitalCity()
        if pCity then
            for _, pUnit in pPlayer:GetUnits():Members() do
                local yield = GetCapitalToUnit(pUnit, pCity)
                if yield > 0 then
                    UnitManager.ChangeMovesRemaining(pUnit, yield)
                    print("Unit at (" .. pUnit:GetX() .. "," .. pUnit:GetY() .. ") gained " .. yield .. " moves")
                end
            end
        else
            print("Player " .. pPlayer:GetID() .. " has no capital city")
        end
    end
end

-- 绑定到回合开始事件
Events.TurnBegin.Add(WanQingTurn)