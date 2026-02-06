-- Yan_Mod_Game
-- Author: HaoJun0823
--------------------------------------------------------------

-- 建立文明与领袖的关联（带存在性检测）
INSERT OR IGNORE INTO CivilizationLeaders 
(
    CivilizationType, 
    LeaderType, 
    CapitalName
)
SELECT 
    'CIVILIZATION_OP_YAN', 
    'LEADER_RANDERION_ARK_WANQING_RED', 
    'LOC_CITY_NAME_ARK_WANQING_REAL_CAPITAL'
WHERE EXISTS (SELECT 1 FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_OP_YAN');