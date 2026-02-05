-- WanQing_Script
-- Author: HaoJun0823
-- DateCreated: 8/27/2025 12:11:16 PM
--------------------------------------------------------------
print("WanQing Script Loaded!");

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
    -- 依旧保持安全检查，如果 mul 为 0 则跳过，防止底层 Unknown production type 报错
    if (mul == nil or mul <= 0) then 
        print("WanQing Summer: Multiplier is 0, skipping logic.")
        return 
    end

    print("LEADER_RANDERION_ARK_WANQING Summer Event for Player " .. player:GetID())
    
    local pCities = player:GetCities()
    for _, pCity in pCities:Members() do
        local pBuildQueue = pCity:GetBuildQueue()
        local bonus = mul * pCity:GetPopulation()
        
        local currentEntry = pBuildQueue:CurrentlyBuilding()
        
        -- 判断逻辑：如果有当前的生产条目，且 bonus > 0
        if (currentEntry ~= nil) then
            -- 强制转为整数 math.floor 是为了防止 float 导致引擎报错
            pBuildQueue:AddProgress(math.floor(bonus))
            print("City " .. Locale.Lookup(pCity:GetName()) .. " added " .. bonus .. " production.")
        else
            -- 没有任何生产（比如队列为空），则转化为金币
            player:GetTreasury():ChangeGoldBalance(math.floor(bonus))
            print("City " .. Locale.Lookup(pCity:GetName()) .. " added " .. bonus .. " gold (no active production).")
        end
    end
end

-- 秋季事件：为所有单位增加经验并减少伤害
function Do_C(mul, player)
    print("LEADER_RANDERION_ARK_WANQING Autumn Event for Player " .. player:GetID())
    for _, pUnit in player:GetUnits():Members() do
        -- 核心修复：平民单位没有经验系统，必须判断
        local pExp = pUnit:GetExperience()
        if pExp ~= nil then
            pExp:ChangeExperience(mul)
			print("Unit at (" .. pUnit:GetX() .. "," .. pUnit:GetY() .. ") processed exp.")
        end
        
        -- 减少伤害（负值代表治疗）
        pUnit:ChangeDamage(math.floor(mul * -1))
        print("Unit at (" .. pUnit:GetX() .. "," .. pUnit:GetY() .. ") processed health.")
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

-- 统计玩家拥有的农事司总数（支持单城多个）
function CountDistrict(pPlayer)
    -- 获取区域的类型 ID (Index)
    local districtInfo = GameInfo.Districts["DISTRICT_WANQING_SPECIAL"]
    if not districtInfo then 
        print("Error Get DISTRICT_WANQING_SPECIAL")
        return 0 
    end
    
    local targetIndex = districtInfo.Index
    local totalCount = 0
    
    -- 获取玩家的所有城市
    local pPlayerCities = pPlayer:GetCities()
    for _, pCity in pPlayerCities:Members() do
        -- 使用 API 列表中的 GetNumDistrictsOfType 直接获取数量
        local pCityDistricts = pCity:GetDistricts()
        local cityDistrictCount = pCityDistricts:GetNumDistrictsOfType(targetIndex)
        
        if cityDistrictCount > 0 then
            -- 如果你需要检查是否已经建成（排除正在建设中的）
            -- 可以配合 IsComplete 使用，但如果是简单的总量统计，上面的代码已足够
            totalCount = totalCount + cityDistrictCount
            
            local cityName = Locale.Lookup(pCity:GetName())
            print(cityName .. " Has DISTRICT_WANQING_SPECIAL: " .. cityDistrictCount)
        end
    end
    
    print("Player " .. pPlayer:GetID() .. " DISTRICT_WANQING_SPECIAL Count: " .. totalCount)
    return totalCount
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
end

-- 2. 移动力逻辑
function WanQingMovementBonus(playerID)
    local pPlayer = Players[playerID]
    -- 校验是否为万顷领袖
    local playerConfig = PlayerConfigurations[playerID]
    if playerConfig:GetLeaderTypeName() ~= "LEADER_RANDERION_ARK_WANQING" then return end
    print("WanQing Movement Bonus Activated!");
    local pCapital = pPlayer:GetCities():GetCapitalCity()
    if pCapital then
		print("WanQing Movement Bonus:Get Capital.");
        for _, pUnit in pPlayer:GetUnits():Members() do
            local yield = GetCapitalToUnit(pUnit, pCapital) 
			print("WanQing Movement Bonus:Get Yield:"..yield);
            if yield > 0 then
                -- 在这个时间点调用，修改后的数值不会被引擎覆盖
                UnitManager.ChangeMovesRemaining(pUnit, yield)
                print("WanQing Movement: Unit at (" .. pUnit:GetX() .. "," .. pUnit:GetY() .. ") gained " .. yield .. " moves")
            end
        end
    else
        print("Player " .. playerID .. " has no capital city")
    end
end



-- 绑定到回合开始事件
Events.TurnBegin.Add(WanQingTurn)
Events.PlayerTurnActivated.Add(WanQingMovementBonus)