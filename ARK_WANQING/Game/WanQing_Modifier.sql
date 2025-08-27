-- WanQing_Modifier
-- Author: HaoJun0823
-- DateCreated: 8/9/2025 7:13:43 PM
--------------------------------------------------------------

--春：获得当前维护费*基数的金币，平均分配给市政研究与科学研究。
--夏：每座城市获得人口*基数的生产力，若城市没有进行生产，则获得等量金币。
--秋：所有单位得到基数点治疗，并且获得基数点经验。
--冬：获得基数点影响力与外交决议。

--特性A：五四好青年：农场+5食物，+4科学，黄金时代+9艺术，黑暗时代+7生产力。（万顷的生日是5月4日）
--特性B：应东风：每回合开始时，所有单位基于首都的距离获得额外的移动力，每10格+1。
--特性C：问道天时：每4回合为1周期，每个回合开始会依次根据基数（基数：周期轮数+农事司数量）触发春夏秋冬效果。
--特性D：良田万倾:世界里所有城市基础食物产量提高25%。（我一定要让所有人都吃饱饭！）
--特色区域：农事司：每个相邻的农场改良提供2点科学，每个相邻的农事司提供2点文化，每回合结束后，统计所有农事司，获得城市*农事司的信仰。
--特色单位：实习天师：替代侦察兵，拥有更远的视野和远程攻击能力。

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_RANDERION_ARK_WANQING_GLOBAL', 'MODIFIER_ARK_WANQING_FOOD_GLOBAL');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_ARK_WANQING_FOOD_GLOBAL', 'MODIFIER_ALL_CITIES_ADJUST_CITY_YIELD_MODIFIER_WANQING', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_ARK_WANQING_FOOD_GLOBAL', 'Amount', '25'), 
('MODIFIER_ARK_WANQING_FOOD_GLOBAL', 'YieldType', 'YIELD_FOOD');

-- Custom ModifierType

INSERT INTO Types (Type, Kind) VALUES 
('MODIFIER_ALL_CITIES_ADJUST_CITY_YIELD_MODIFIER_WANQING', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES 
('MODIFIER_ALL_CITIES_ADJUST_CITY_YIELD_MODIFIER_WANQING', 'COLLECTION_ALL_CITIES', 'EFFECT_ADJUST_CITY_YIELD_MODIFIER');


---

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_RANDERION_ARK_WANQING', 'MODIFIER_ARK_WANQING_FARM_FOOD');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_ARK_WANQING_FARM_FOOD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQ_SET_WANQING_FARM');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_ARK_WANQING_FARM_FOOD', 'Amount', '5'), 
('MODIFIER_ARK_WANQING_FARM_FOOD', 'YieldType', 'YIELD_FOOD');

--

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_RANDERION_ARK_WANQING', 'MODIFIER_ARK_WANQING_FARM_SCIENCE');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_ARK_WANQING_FARM_SCIENCE', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 0, 0, 0, NULL, 'REQ_SET_WANQING_FARM');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_ARK_WANQING_FARM_SCIENCE', 'Amount', '4'), 
('MODIFIER_ARK_WANQING_FARM_SCIENCE', 'YieldType', 'YIELD_SCIENCE');

--

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_RANDERION_ARK_WANQING', 'MODIFIER_ARK_WANQING_FARM_CULTURE');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_ARK_WANQING_FARM_CULTURE', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 0, 0, 0, 'REQ_SET_WANQING_GOLD_AGE', 'REQ_SET_WANQING_FARM');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_ARK_WANQING_FARM_CULTURE', 'Amount', '9'), 
('MODIFIER_ARK_WANQING_FARM_CULTURE', 'YieldType', 'YIELD_CULTURE');

--

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
('TRAIT_LEADER_RANDERION_ARK_WANQING', 'MODIFIER_ARK_WANQING_FARM_PRODUCTION');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_ARK_WANQING_FARM_PRODUCTION', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', 0, 0, 0, 'REQ_SET_WANQING_DARK_AGE', 'REQ_SET_WANQING_FARM');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_ARK_WANQING_FARM_PRODUCTION', 'Amount', '7'), 
('MODIFIER_ARK_WANQING_FARM_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION');


-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQ_SET_WANQING_FARM', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQ_SET_WANQING_FARM', 'REQ_WANQING_FARM');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('REQ_WANQING_FARM', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
('REQ_WANQING_FARM', 'FeatureType', 'IMPROVEMENT_FARM');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQ_SET_WANQING_GOLD_AGE', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQ_SET_WANQING_GOLD_AGE', 'REQ_WANQING_GOLD_AGE');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('REQ_WANQING_GOLD_AGE', 'REQUIREMENT_PLAYER_HAS_GOLDEN_AGE');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('REQ_SET_WANQING_DARK_AGE', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('REQ_SET_WANQING_DARK_AGE', 'REQ_WANQING_DARK_AGE');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('REQ_WANQING_DARK_AGE', 'REQUIREMENT_PLAYER_HAS_DARK_AGE');