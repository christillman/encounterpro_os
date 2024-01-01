SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Query_Term') AND type in (N'U'))
BEGIN
	DROP TABLE [c_Query_Term]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Query_Term') AND type in (N'U'))
BEGIN
CREATE TABLE [c_Query_Term](
	[query_target] [varchar](24) NOT NULL,
	[user_query_term] [varchar](24) NOT NULL,
	[query_term] [varchar](250) NOT NULL,
	[sort_sequence] [int] NULL,
	[status] [varchar](10) NULL
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

GRANT DELETE ON [c_Query_Term] TO [cprsystem] AS [dbo]
GO

GRANT INSERT ON [c_Query_Term] TO [cprsystem] AS [dbo]
GO

GRANT REFERENCES ON [c_Query_Term] TO [cprsystem] AS [dbo]
GO

GRANT SELECT ON [c_Query_Term] TO [cprsystem] AS [dbo]
GO

GRANT UPDATE ON [c_Query_Term] TO [cprsystem] AS [dbo]
GO

create table #terms (abbr varchar(10), term varchar(100) )

INSERT INTO #terms VALUES('ACL', 'anterior cruciate ligament') 
INSERT INTO #terms VALUES('ADH', 'antidiuretic hormone') 
INSERT INTO #terms VALUES('AED', 'defibrillator') 
INSERT INTO #terms VALUES('AFib', 'atrial fibrillation') 
INSERT INTO #terms VALUES('AFR', 'acute renal failure') 
INSERT INTO #terms VALUES('ARDS', 'acute respiratory distress syndrome') 
INSERT INTO #terms VALUES('ARF', 'acute kidney failure') 
INSERT INTO #terms VALUES('ARF', 'acute renal failure') 
INSERT INTO #terms VALUES('BKA', 'below the knee amputation') 
INSERT INTO #terms VALUES('bld', 'blood') 
INSERT INTO #terms VALUES('BP', 'blood pressure') 
INSERT INTO #terms VALUES('Ca', 'calcium') 
INSERT INTO #terms VALUES('cad', 'coronary artery') 
INSERT INTO #terms VALUES('CKD', 'chronic kidney disease') 
INSERT INTO #terms VALUES('Cl', 'chlorine') 
INSERT INTO #terms VALUES('CNS', 'central nervous system') 
INSERT INTO #terms VALUES('CO2', 'carbon dioxide') 
INSERT INTO #terms VALUES('CSF', 'cerebrospinal fluid') 
INSERT INTO #terms VALUES('CT', 'chemotherapy') 
INSERT INTO #terms VALUES('DC', 'discharge') 
INSERT INTO #terms VALUES('DCIS', 'ductal Carcinoma In Situ') 
INSERT INTO #terms VALUES('DM', 'diabetes mellitus') 
INSERT INTO #terms VALUES('DVT', 'deep venous thrombosis') 
INSERT INTO #terms VALUES('EEG', 'electroencephalogram') 
INSERT INTO #terms VALUES('ESRD', '%end%stage renal disease%')
INSERT INTO #terms VALUES('ETOH', 'alcohol') 
INSERT INTO #terms VALUES('Ft', 'feet') 
INSERT INTO #terms VALUES('fib', 'fibrillation') 
INSERT INTO #terms VALUES('Ft', 'foot') 
INSERT INTO #terms VALUES('FUO', 'fever of unknown origin') 
INSERT INTO #terms VALUES('FX', 'fracture') 
INSERT INTO #terms VALUES('G6PD', 'glucose-6-phosphate dehydrogenase') 
INSERT INTO #terms VALUES('GI', 'gastrointestinal') 
INSERT INTO #terms VALUES('GVHD', 'graft-versus-host disease') 
INSERT INTO #terms VALUES('H', 'hour') 
INSERT INTO #terms VALUES('h/o', 'history of') 
INSERT INTO #terms VALUES('HA', 'headache') 
INSERT INTO #terms VALUES('Hb', 'hemoglobin') 
INSERT INTO #terms VALUES('HCl', 'hydrochloric acid') 
INSERT INTO #terms VALUES('Hct', 'hematocrit') 
INSERT INTO #terms VALUES('Hg', 'mercury') 
INSERT INTO #terms VALUES('HIV', 'human immunodeficiency virus') 
INSERT INTO #terms VALUES('HTN', 'hypertension') 
INSERT INTO #terms VALUES('ICD', 'defibrillator') 
INSERT INTO #terms VALUES('IPF', 'idiopathic pulmonary fibrosis') 
INSERT INTO #terms VALUES('IV', 'intravenous') 
INSERT INTO #terms VALUES('JT', 'joint') 
INSERT INTO #terms VALUES('LBP', 'low back pain') 
INSERT INTO #terms VALUES('LCIS', 'lobular Carcinoma In Situ') 
INSERT INTO #terms VALUES('M', 'molar') 
INSERT INTO #terms VALUES('MCL', 'medial collateral ligament') 
INSERT INTO #terms VALUES('Mg', 'magnesium') 
INSERT INTO #terms VALUES('MI', 'myocardial infarction') 
INSERT INTO #terms VALUES('mo', 'month') 
INSERT INTO #terms VALUES('N', 'nitrogen') 
INSERT INTO #terms VALUES('Na', 'sodium') 
INSERT INTO #terms VALUES('NSAID', 'nonsteroidal anti-inflammatory drug') 
INSERT INTO #terms VALUES('O.D.', 'right eye') 
INSERT INTO #terms VALUES('O.S.', 'left eye') 
INSERT INTO #terms VALUES('O2', 'oxygen') 
INSERT INTO #terms VALUES('P', 'phosphorus') 
INSERT INTO #terms VALUES('P', 'pressure') 
INSERT INTO #terms VALUES('PAF', 'paroxysmal atrial fibrillation') 
INSERT INTO #terms VALUES('PCL', 'posterior cruciate ligament') 
INSERT INTO #terms VALUES('Plt', 'platelets') 
INSERT INTO #terms VALUES('PMS', 'premenstrual') 
INSERT INTO #terms VALUES('PTSD', 'post-traumatic stress disorder') 
INSERT INTO #terms VALUES('RA', 'rheumatoid arthritis') 
INSERT INTO #terms VALUES('RBC', 'red blood cell') 
INSERT INTO #terms VALUES('RDS', 'respiratory distress syndrome') 
INSERT INTO #terms VALUES('REB', 'rebound') 
INSERT INTO #terms VALUES('RLQ', 'right lower quadrant') 
INSERT INTO #terms VALUES('RUQ', 'right upper quadrant') 
INSERT INTO #terms VALUES('s/p', 'status post') 
INSERT INTO #terms VALUES('sc', 'subcutaneous') 
INSERT INTO #terms VALUES('SIDS', 'sudden infant death syndrome') 
INSERT INTO #terms VALUES('SLE', 'systemic lupus erythematosus') 
INSERT INTO #terms VALUES('SOB', 'shortness of breath') 
INSERT INTO #terms VALUES('sp', 'species') 
INSERT INTO #terms VALUES('SSRI', 'selective serotonin reuptake inhibitor') 
INSERT INTO #terms VALUES('T', 'temperature') 
INSERT INTO #terms VALUES('TB', 'tuberculosis') 
INSERT INTO #terms VALUES('URI', 'upper respiratory infection') 
INSERT INTO #terms VALUES('UTI', 'urinary tract infection') 
INSERT INTO #terms VALUES('WBC', 'white blood cell') 

insert into c_query_term
	(query_target, user_query_term, query_term)
select 'ASSESSMENT', abbr, term from #terms
GO
