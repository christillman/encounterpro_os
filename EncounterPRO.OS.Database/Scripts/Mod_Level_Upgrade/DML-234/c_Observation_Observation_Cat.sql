

delete
-- select '''' + observation_id + ''','
from c_Observation_Observation_Cat 
where observation_id in (
'24-hourUrineCreatini',
'24-hourUrineProtein',
'AdjustedCalcium',
'AFP',
'Albumin',
'Albumine/CreatinineR',
'AlbuminGestational',
'ALP',
'ALT',
'AMH',
'ANATitre',
'Anti-dsDNAIndetermin',
'Anti-dsDNANegative',
'Anti-dsDNAPositive',
'Anti-Myeloperoxidase',
'Anti-Proteinase3',
'Anti-TissueTransglut',
'AnylaseSerum',
'AST',
'Basophils',
'Bicarbonate',
'Calcium',
'CarbamazepineTherape',
'CardiolipinIgG',
'CardiolipinIgM',
'CCPantibodies',
'CEANonsmokers',
'Chloride',
'Cholesterol',
'CholesterolHDLratio',
'Creatinine',
'CreatinineClearance',
'CRP',
'DeamidatedGliadinPep',
'DHEAS',
'DigoxinTherapeuticra',
'DiluteThrombinclotti',
'DirectBilirubin',
'eGFR',
'Eosinophils',
'ESR',
'Ferritin',
'FIBFibrinogen',
'FreeT4',
'FreeT4Gestational',
'Freetestosterone',
'FSH',
'FSHFollicular',
'FSHLuteal',
'FSHMidcycle',
'FSHPost-menopausal',
'FSHPregnant',
'GGT',
'Globulin',
'GlucoseChallenge',
'GlucoseToleranceNP2H',
'GlucoseToleranceNPF',
'GlucoseToleranceP2H',
'GlucoseTolerancePF',
'Haemoglobin',
'HaemoglobinPrenatal',
'HCG',
'HCT(PCV)',
'HCT(PCV)Prenatal',
'HDLCholesterol',
'HepatitisATotalAbCon',
'Homocysteine',
'Insulin',
'LDH',
'LDLCholesterol',
'lgA',
'lgE',
'lgG',
'lgM',
'LH',
'LHFollicular',
'LHLuteal',
'LHMidcycle',
'LHPostmenopausal',
'LHPregnant',
'LipaseSerum',
'LithiumTrough(12hrsp',
'Lymphocytes',
'Magnesium',
'MCH',
'MCHC',
'MCV',
'Monocytes',
'Monomericprolactin',
'Neutrophils',
'NeutrophilsPrenatal',
'NTProBNP',
'Oestradiol',
'OestradiolFollicular',
'OestradiolLuteal',
'OestradiolMid-cycle',
'OestradiolPostMenopa',
'PhenytoinTherapeutic',
'Phosphate',
'PI(INR)',
'PI(INR)Highriskthera',
'PI(INR)Standardriskt',
'PlateletCount',
'Potassium',
'ProgesteroneOvConf',
'ProgesteroneOvPoss',
'ProgesteroneOvUnlk',
'ProgesteronePostMP',
'Prolactin',
'ProteinCreatinineRat',
'Prothrombintime',
'PSA',
'PTH',
'PTT',
'QuantiferonMitogenNI',
'QuantiferonMitogenNN',
'QuantiferonNilIndete',
'QuantiferonTB1TB2Mit',
'QuantiferonTB1TB2Pos',
'RabiesIgG',
'RDW',
'RedBloodCount',
'RedBloodCountPrenata',
'Ret-He',
'RheumatoidFactor',
'RubellalgGConsidered',
'RubellalgGNon-Immune',
'SerumCortisolmorning',
'SerumFolate',
'SHBG',
'SHBGPost-pubertal',
'SHBGPre-pubertal',
'Sodium',
'ThyroperoxidaseAb',
'TissueAutoantibody(A',
'TotalBilirubin',
'TotalProtein',
'TransferrinSaturatio',
'Triglycerides',
'TSH',
'TSHGestational',
'Urea',
'UricAcid',
'Urinecalcium/creatin',
'UrineChloride',
'UrinePotassium',
'UrineSodium',
'ValproicAcidTherapeu',
'VitaminDIntox',
'VitaminDMilddeficien',
'VitaminDModeratetose',
'VitaminDOptimaltarge',
'WhiteBloodCount',
'WhiteBloodCountPrena',
'981^801','981^802','981^803','981^804','981^805','981^806','981^807','981^808',
'981^809','981^810','981^811','981^812','981^813','981^814','981^815','981^816',
'981^817','981^818','981^819','981^820','981^821','981^822','981^823','981^824',
'981^825','981^826','981^827','981^828','981^829','981^830','981^831','981^832',
'981^833','981^834','981^835','981^836','981^838','981^839','981^840','981^841',
'981^842','981^843','981^844','981^845','981^846','981^847','981^848','981^849',
'981^850','981^851','981^852','981^853','981^854','981^855','981^856'
)


insert into c_Observation_Observation_Cat values
('LAB','CHEMISTRY','24-hourUrineCreatini'),
('LAB','CHEMISTRY','24-hourUrineProtein'),
('LAB','CHEMISTRY','AdjustedCalcium'),
('LAB','HAEM','AFP'),
('LAB','CHEMISTRY','Albumin'),
('LAB','CHEMISTRY','Albumine/CreatinineR'),
('LAB','CHEMISTRY','AlbuminGestational'),
('LAB','CHEMISTRY','ALP'),
('LAB','CHEMISTRY','ALT'),
('LAB','CHEMISTRY','AMH'),
('LAB','SEROIMM','ANATitre'),
('LAB','SEROIMM','Anti-dsDNAIndetermin'),
('LAB','SEROIMM','Anti-dsDNANegative'),
('LAB','SEROIMM','Anti-dsDNAPositive'),
('LAB','SEROIMM','Anti-Myeloperoxidase'),
('LAB','SEROIMM','Anti-Proteinase3'),
('LAB','SEROIMM','Anti-TissueTransglut'),
('LAB','CHEMISTRY','AnylaseSerum'),
('LAB','CHEMISTRY','AST'),
('LAB','HAEM','Basophils'),
('LAB','CHEMISTRY','Bicarbonate'),
('LAB','CHEMISTRY','Calcium'),
('LAB','CHEMISTRY','CarbamazepineTherape'),
('LAB','SEROIMM','CardiolipinIgG'),
('LAB','SEROIMM','CardiolipinIgM'),
('LAB','CHEMISTRY','CCPantibodies'),
('LAB','CHEMISTRY','CEANonsmokers'),
('LAB','CHEMISTRY','Chloride'),
('LAB','CHEMISTRY','Cholesterol'),
('LAB','CHEMISTRY','CholesterolHDLratio'),
('LAB','CHEMISTRY','Creatinine'),
('LAB','CHEMISTRY','CreatinineClearance'),
('LAB','SEROIMM','CRP'),
('LAB','SEROIMM','DeamidatedGliadinPep'),
('LAB','CHEMISTRY','DHEAS'),
('LAB','CHEMISTRY','DigoxinTherapeuticra'),
('LAB','HAEM','DiluteThrombinclotti'),
('LAB','CHEMISTRY','DirectBilirubin'),
('LAB','CHEMISTRY','eGFR'),
('LAB','HAEM','Eosinophils'),
('LAB','HAEM','ESR'),
('LAB','CHEMISTRY','Ferritin'),
('LAB','HAEM','FIBFibrinogen'),
('LAB','CHEMISTRY','FreeT4'),
('LAB','CHEMISTRY','FreeT4Gestational'),
('LAB','CHEMISTRY','Freetestosterone'),
('LAB','CHEMISTRY','FSH'),
('LAB','CHEMISTRY','FSHFollicular'),
('LAB','CHEMISTRY','FSHLuteal'),
('LAB','CHEMISTRY','FSHMidcycle'),
('LAB','CHEMISTRY','FSHPost-menopausal'),
('LAB','CHEMISTRY','FSHPregnant'),
('LAB','CHEMISTRY','GGT'),
('LAB','CHEMISTRY','Globulin'),
('LAB','CHEMISTRY','GlucoseChallenge'),
('LAB','CHEMISTRY','GlucoseToleranceNP2H'),
('LAB','CHEMISTRY','GlucoseToleranceNPF'),
('LAB','CHEMISTRY','GlucoseToleranceP2H'),
('LAB','CHEMISTRY','GlucoseTolerancePF'),
('LAB','HAEM','Haemoglobin'),
('LAB','HAEM','HaemoglobinPrenatal'),
('LAB','CHEMISTRY','HCG'),
('LAB','HAEM','HCT(PCV)'),
('LAB','HAEM','HCT(PCV)Prenatal'),
('LAB','CHEMISTRY','HDLCholesterol'),
('LAB','SEROIMM','HepatitisATotalAbCon'),
('LAB','CHEMISTRY','Homocysteine'),
('LAB','CHEMISTRY','Insulin'),
('LAB','CHEMISTRY','LDH'),
('LAB','CHEMISTRY','LDLCholesterol'),
('LAB','CHEMISTRY','lgA'),
('LAB','CHEMISTRY','lgE'),
('LAB','CHEMISTRY','lgG'),
('LAB','CHEMISTRY','lgM'),
('LAB','CHEMISTRY','LH'),
('LAB','CHEMISTRY','LHFollicular'),
('LAB','CHEMISTRY','LHLuteal'),
('LAB','CHEMISTRY','LHMidcycle'),
('LAB','CHEMISTRY','LHPostmenopausal'),
('LAB','CHEMISTRY','LHPregnant'),
('LAB','CHEMISTRY','LipaseSerum'),
('LAB','CHEMISTRY','LithiumTrough(12hrsp'),
('LAB','HAEM','Lymphocytes'),
('LAB','CHEMISTRY','Magnesium'),
('LAB','HAEM','MCH'),
('LAB','HAEM','MCHC'),
('LAB','HAEM','MCV'),
('LAB','HAEM','Monocytes'),
('LAB','CHEMISTRY','Monomericprolactin'),
('LAB','HAEM','Neutrophils'),
('LAB','HAEM','NeutrophilsPrenatal'),
('LAB','CHEMISTRY','NTProBNP'),
('LAB','CHEMISTRY','Oestradiol'),
('LAB','CHEMISTRY','OestradiolFollicular'),
('LAB','CHEMISTRY','OestradiolLuteal'),
('LAB','CHEMISTRY','OestradiolMid-cycle'),
('LAB','CHEMISTRY','OestradiolPostMenopa'),
('LAB','CHEMISTRY','PhenytoinTherapeutic'),
('LAB','CHEMISTRY','Phosphate'),
('LAB','HAEM','PI(INR)'),
('LAB','HAEM','PI(INR)Highriskthera'),
('LAB','HAEM','PI(INR)Standardriskt'),
('LAB','HAEM','PlateletCount'),
('LAB','CHEMISTRY','Potassium'),
('LAB','CHEMISTRY','ProgesteroneOvConf'),
('LAB','CHEMISTRY','ProgesteroneOvPoss'),
('LAB','CHEMISTRY','ProgesteroneOvUnlk'),
('LAB','CHEMISTRY','ProgesteronePostMP'),
('LAB','CHEMISTRY','Prolactin'),
('LAB','CHEMISTRY','ProteinCreatinineRat'),
('LAB','HAEM','Prothrombintime'),
('LAB','HAEM','PSA'),
('LAB','CHEMISTRY','PTH'),
('LAB','HAEM','PTT'),
('LAB','SEROIMM','QuantiferonMitogenNI'),
('LAB','SEROIMM','QuantiferonMitogenNN'),
('LAB','SEROIMM','QuantiferonNilIndete'),
('LAB','SEROIMM','QuantiferonTB1TB2Mit'),
('LAB','SEROIMM','QuantiferonTB1TB2Pos'),
('LAB','SEROIMM','RabiesIgG'),
('LAB','HAEM','RDW'),
('LAB','HAEM','RedBloodCount'),
('LAB','HAEM','RedBloodCountPrenata'),
('LAB','HAEM','Ret-He'),
('LAB','SEROIMM','RheumatoidFactor'),
('LAB','CHEMISTRY','RubellalgGConsidered'),
('LAB','CHEMISTRY','RubellalgGNon-Immune'),
('LAB','CHEMISTRY','SerumCortisolmorning'),
('LAB','CHEMISTRY','SerumFolate'),
('LAB','CHEMISTRY','SHBG'),
('LAB','CHEMISTRY','SHBGPost-pubertal'),
('LAB','CHEMISTRY','SHBGPre-pubertal'),
('LAB','CHEMISTRY','Sodium'),
('LAB','CHEMISTRY','ThyroperoxidaseAb'),
('LAB','SEROIMM','TissueAutoantibody(A'),
('LAB','CHEMISTRY','TotalBilirubin'),
('LAB','CHEMISTRY','TotalProtein'),
('LAB','CHEMISTRY','TransferrinSaturatio'),
('LAB','CHEMISTRY','Triglycerides'),
('LAB','CHEMISTRY','TSH'),
('LAB','CHEMISTRY','TSHGestational'),
('LAB','CHEMISTRY','Urea'),
('LAB','CHEMISTRY','UricAcid'),
('LAB','CHEMISTRY','Urinecalcium/creatin'),
('LAB','CHEMISTRY','UrineChloride'),
('LAB','CHEMISTRY','UrinePotassium'),
('LAB','CHEMISTRY','UrineSodium'),
('LAB','CHEMISTRY','ValproicAcidTherapeu'),
('LAB','CHEMISTRY','VitaminDIntox'),
('LAB','CHEMISTRY','VitaminDMilddeficien'),
('LAB','CHEMISTRY','VitaminDModeratetose'),
('LAB','CHEMISTRY','VitaminDOptimaltarge'),
('LAB','HAEM','WhiteBloodCount'),
('LAB','HAEM','WhiteBloodCountPrena')
 
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^801')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'ENDO', N'981^801')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^804')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'PANELS', N'981^804')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^805')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^806')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'ENDO', N'981^805')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'ENDO', N'981^806')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'PANELS', N'981^810')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'PANELS', N'981^812')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^810')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^811')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^812')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^813')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^814')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^815')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^816')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^817')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^818')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'DIAB', N'981^814')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'DIAB', N'981^815')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'DIAB', N'981^816')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'DIAB', N'981^817')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'DIAB', N'981^818')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^819')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^820')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^821')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^822')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^823')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^824')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^825')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'IRON', N'981^822')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'IRON', N'981^823')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'IRON', N'981^824')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'IRON', N'981^825')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'PANELS', N'981^826')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^827')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^828')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^829')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^830')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^831')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^832')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^833')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^834')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'COAG', N'981^830')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'COAG', N'981^831')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'COAG', N'981^832')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'COAG', N'981^833')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'COAG', N'981^834')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'BLOODPAR', N'981^835')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'BLOODPAR', N'981^836')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^835')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^836')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'BLOODPAR', N'981^838')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'BLOODPAR', N'981^839')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'BLOODPAR', N'981^840')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'TUMMARK', N'981^841')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'TUMMARK', N'981^842')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'TUMMARK', N'981^843')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^839')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^840')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^841')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^842')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HAEM', N'981^843')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^844')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^845')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^846')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^847')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^848')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^849')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^850')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^851')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^852')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^853')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^854')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'SEROIMM', N'981^855')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HEPBC', N'981^849')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HEPBC', N'981^850')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HEPBC', N'981^851')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HIV', N'981^852')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HIV', N'981^853')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HIV', N'981^854')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'HIV', N'981^855')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'CHEMISTRY', N'981^856')
INSERT [c_Observation_Observation_Cat] ([treatment_type], [observation_category_id], [observation_id]) VALUES (N'LAB', N'PANELS', N'981^856')
