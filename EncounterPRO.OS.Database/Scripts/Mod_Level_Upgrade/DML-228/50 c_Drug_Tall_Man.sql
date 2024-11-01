/*
select 'UPDATE c_Drug_Tall_Man SET spelling = ''' + a.name + ''' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = ''' + t.spelling collate SQL_Latin1_General_CP1_CS_AS + ''''
-- select spelling as current_spelling, name as Australia_name
from AustralianTallMan a
left join c_Drug_Tall_Man t on t.spelling collate SQL_Latin1_General_CP1_CI_AS = a.name
and t.spelling collate SQL_Latin1_General_CP1_CS_AS != a.name 
where t.spelling is not null
*/

UPDATE c_Drug_Tall_Man SET spelling = 'amiNOPHYLLine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'amINOPHYLLIne'
UPDATE c_Drug_Tall_Man SET spelling = 'amiODAROne' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'amIODAROne'
UPDATE c_Drug_Tall_Man SET spelling = 'amiTRIPTYLine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'amITRIPTYLIne'
UPDATE c_Drug_Tall_Man SET spelling = 'azATHIOPRINE' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'azaTHIOprine'
UPDATE c_Drug_Tall_Man SET spelling = 'aziTHROMYCIN' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'azITHROMYCIN'
UPDATE c_Drug_Tall_Man SET spelling = 'caPTOPRil' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'caPTOPRIl'
UPDATE c_Drug_Tall_Man SET spelling = 'CARBAMazepine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'carBAMazepine'
UPDATE c_Drug_Tall_Man SET spelling = 'carbiMAZOLe' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'carbIMAZOLe'
UPDATE c_Drug_Tall_Man SET spelling = 'cARBOplatin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'CARBOplatin'
UPDATE c_Drug_Tall_Man SET spelling = 'cefaZOLin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'ceFAZolin'
UPDATE c_Drug_Tall_Man SET spelling = 'cefOXITIN' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cefOXitin'
UPDATE c_Drug_Tall_Man SET spelling = 'cefTAZIDIME' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cefTAZidime'
UPDATE c_Drug_Tall_Man SET spelling = 'cefTRIAXONE' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cefTRIAXone'
UPDATE c_Drug_Tall_Man SET spelling = 'celEBREX' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'CeleBREX'
UPDATE c_Drug_Tall_Man SET spelling = 'cHLORPROMAZine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'chlorproMAZINE'
UPDATE c_Drug_Tall_Man SET spelling = 'ciPROFLOXAcin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cIPROFLOXAcin'
UPDATE c_Drug_Tall_Man SET spelling = 'ciSplatin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'CISplatin'
UPDATE c_Drug_Tall_Man SET spelling = 'cLOMIPRAMine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'clomiPRAMINE'
UPDATE c_Drug_Tall_Man SET spelling = 'CLONazepam' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'clonazePAM'
UPDATE c_Drug_Tall_Man SET spelling = 'cycLIZINE' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cyclIZINE'
UPDATE c_Drug_Tall_Man SET spelling = 'cyclosERINE' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'cycloSERINE'
UPDATE c_Drug_Tall_Man SET spelling = 'daCTINomycin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'DACTINomycin'
UPDATE c_Drug_Tall_Man SET spelling = 'daPTomycin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'DAPTOmycin'
UPDATE c_Drug_Tall_Man SET spelling = 'DEPO-medrol' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'DEPO-Medrol'
UPDATE c_Drug_Tall_Man SET spelling = 'DIAzepam' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'diazePAM'
UPDATE c_Drug_Tall_Man SET spelling = 'doXepin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'doXEpin'
UPDATE c_Drug_Tall_Man SET spelling = 'fluoxetine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'FLUoxetine'
UPDATE c_Drug_Tall_Man SET spelling = 'fluVOXAMine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'fluvoxaMINE'
UPDATE c_Drug_Tall_Man SET spelling = 'gliPIZide' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'glipiZIDE'
UPDATE c_Drug_Tall_Man SET spelling = 'humALOG' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'HumaLOG'
UPDATE c_Drug_Tall_Man SET spelling = 'humULIN' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'HumuLIN'
UPDATE c_Drug_Tall_Man SET spelling = 'hydrALAZINe' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'hydrALAZINE'
UPDATE c_Drug_Tall_Man SET spelling = 'hydrOCHLOROTHIAZIDe' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'hydroCHLOROthiazide'
UPDATE c_Drug_Tall_Man SET spelling = 'iDArubicin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'IDArubicin'
UPDATE c_Drug_Tall_Man SET spelling = 'iFOSFamide' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'IFOSFamide'
UPDATE c_Drug_Tall_Man SET spelling = 'iSOtretinoin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'ISOtretinoin'
UPDATE c_Drug_Tall_Man SET spelling = 'laMICTAl' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'LaMICtal'
UPDATE c_Drug_Tall_Man SET spelling = 'laMISil' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'LamISIL'
UPDATE c_Drug_Tall_Man SET spelling = 'lamOTRIGine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'lamoTRIgine'
UPDATE c_Drug_Tall_Man SET spelling = 'lanVis' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'lanVIs'
UPDATE c_Drug_Tall_Man SET spelling = 'laRGACTil' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'laRGACTIl'
UPDATE c_Drug_Tall_Man SET spelling = 'MOXifloxacin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'MOXIfloxacin'
UPDATE c_Drug_Tall_Man SET spelling = 'nexAVAR' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'NexAVAR'
UPDATE c_Drug_Tall_Man SET spelling = 'nexiUM' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'NexIUM'
UPDATE c_Drug_Tall_Man SET spelling = 'niFEDIPine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'NIFEdipine'
UPDATE c_Drug_Tall_Man SET spelling = 'niMODIPine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'niMODipine'
UPDATE c_Drug_Tall_Man SET spelling = 'OXCARBazepine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'OXcarbazepine'
UPDATE c_Drug_Tall_Man SET spelling = 'oxyCONTIN' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'OxyCONTIN'
UPDATE c_Drug_Tall_Man SET spelling = 'pAZOPanib' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'PAZOPanib'
UPDATE c_Drug_Tall_Man SET spelling = 'pONATinib' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'PONATinib'
UPDATE c_Drug_Tall_Man SET spelling = 'proZAC' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'PROzac'
UPDATE c_Drug_Tall_Man SET spelling = 'QUETIAPine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'QUEtiapine'
UPDATE c_Drug_Tall_Man SET spelling = 'rifaXIMin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'rifAXIMin'
UPDATE c_Drug_Tall_Man SET spelling = 'riSPERIDONe' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'risperiDONE'
UPDATE c_Drug_Tall_Man SET spelling = 'rOPINIROLe' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'rOPINIRole'
UPDATE c_Drug_Tall_Man SET spelling = 'Sirolimus' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SIrolimus'
UPDATE c_Drug_Tall_Man SET spelling = 'siTagliptin' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SITagliptin'
UPDATE c_Drug_Tall_Man SET spelling = 'solu-CORTEF' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'Solu-CORTEF'
UPDATE c_Drug_Tall_Man SET spelling = 'SOLU-medrol' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SOLU-Medrol'
UPDATE c_Drug_Tall_Man SET spelling = 'soRAFENib' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SORAfenib'
UPDATE c_Drug_Tall_Man SET spelling = 'sulfaDiazine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'sulfADIAZINE'
UPDATE c_Drug_Tall_Man SET spelling = 'sulfaSALazine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'sulfaSALAzine'
UPDATE c_Drug_Tall_Man SET spelling = 'sUMATRIPTAn' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SUMAtriptan'
UPDATE c_Drug_Tall_Man SET spelling = 'sUNITinib' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'SUNItinib'
UPDATE c_Drug_Tall_Man SET spelling = 'tEGRETOl' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'TEGretol'
UPDATE c_Drug_Tall_Man SET spelling = 'tRAMadol' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'traMADol'
UPDATE c_Drug_Tall_Man SET spelling = 'tRENTAl' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'TRENtal'
UPDATE c_Drug_Tall_Man SET spelling = 'vinBLASTine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'vinBLAStine'
UPDATE c_Drug_Tall_Man SET spelling = 'vinCRISTine' WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS = 'vinCRIStine'

/*
-- DELETE FROM c_Drug_Tall_Man WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS IN (
select '''' + a.name + ''','
-- select spelling as current_spelling, name as Australia_name
from AustralianTallMan a
left join c_Drug_Tall_Man t on t.spelling collate SQL_Latin1_General_CP1_CI_AS = a.name
and t.spelling collate SQL_Latin1_General_CP1_CS_AS != a.name
where t.spelling is null
*/

DELETE 
-- select *
FROM c_Drug_Tall_Man WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS IN (
'aCLin',
'actoNEL',
'actoS',
'aFATinib',
'aKAMin',
'alDACTONE',
'alDOMET',
'ALKeran',
'alODORM',
'amARYl',
'amLODIPine',
'amOXil',
'aPomine',
'arABLOC',
'arATAC',
'ARIPiprazole',
'arOPAX',
'aTRopt',
'avaSTIN',
'avaXIM',
'aVomine',
'aXITinib',
'aZopt',
'bARICITinib',
'beNRALizumab',
'beVACizumab',
'beZLOTOXumab',
'biNIMEtinib',
'bisACODYl',
'bisOPROLOl',
'buDESONide',
'buMETANide',
'CABAZitaxel',
'cABOZANtinib',
'caLTRate',
'caRAFate',
'caRVEDILOl',
'cefaLEXin',
'cefALOTIN',
'cefEPIME',
'cefOTAXIME',
'ceftAROLine',
'celAPRAM',
'ciclosPORIN',
'ciprAMIL',
'ciprOXIN',
'cLARITHROMYcin',
'cloBAZam',
'cLOMIFEne',
'cOBIMEtinib',
'coUMADIN',
'coVERSYL',
'cycLONEX',
'CYCLOPHOSPHamide',
'daBRAFEnib',
'daSATinib',
'DAUNOrubicin',
'depo-PROVERA',
'dePTRAn',
'deRALin',
'dexAMETHASOne',
'dexMEDETOMIDine',
'dilaNTIN',
'dilaUDID',
'diPRIVan',
'diPYRIDAMOLe',
'diSOPYRAMIDe',
'diTROPan',
'DOCEtaxel',
'doSULepin (doTHiepin)',
'DOXOrubicin',
'DULoxetine',
'eCULizumab',
'eFALizumab',
'eMICizumab',
'ERYthromycin',
'flucLOXACILLIN',
'flucONAZOLe',
'flucYTOSINe',
'gliBENCLAMide',
'gliCLAZide',
'gliMEPIRide',
'hydreA',
'hydreNE',
'HYDROmorphone',
'INDEral',
'isopto CARpine',
'isopto HOMATROpine',
'januMET',
'januVIA',
'ketALAR',
'ketOROLAC',
'lamiVUDine',
'LanTUs',
'laPAtinib',
'leNVAtinib',
'LEUKeran',
'linCOMYCIN',
'linEZOLID',
'LORazepam',
'loSEC',
'loVAN',
'mercaptAMine',
'mercaptOPURine',
'methADONe',
'methYLPHENIDATe',
'moBILis',
'morphine',
'moVALis',
'MS Contin',
'MYLeran',
'NEOral',
'niZATIDine',
'NORfloxacin',
'norMISON',
'norVASC',
'novoMIX',
'novoRAPID',
'oBINUTUZumab',
'oCRELizumab',
'oFATUMumab',
'oMALizumab',
'OXazepam',
'oxyNORM',
'PACLitaxel',
'pANITUMumab',
'paRIET',
'PARoxetine',
'paXTINE',
'pERTUZumab',
'pEXSIG',
'primaCIN',
'primaCOR',
'primaXIN',
'pRISTIQ',
'proCHLORPERazine',
'proGRAF',
'proMETHazine',
'propOFol',
'propRANOLol',
'RABEprazole',
'raMUCIRumab',
'raNIBIZumab',
'rifaMPICin',
'sAXagliptin',
'SERTRALine',
'soNIDEGib',
'TACrolimus',
'tAPENTadol',
'tEMOdal',
'tOFACitinib',
'toFRANIL',
'toPAMAX',
'tORadol',
'tRAMEtinib',
'tretinoin',
'trimEPRAZINE',
'trimETHOPRIM',
'valAciclovir',
'valGANciclovir',
'vinORELBine',
'xalaCOM',
'xalaTAN',
'zinNAt',
'zinVit',
'zoCOR',
'zoLOFT',
'zoTON'
)

/*
-- INSERT INTO c_Drug_Tall_Man VALUES
select '(''' + a.name + '''),'
-- select spelling as current_spelling, name as Australia_name
from AustralianTallMan a
left join c_Drug_Tall_Man t on t.spelling collate SQL_Latin1_General_CP1_CI_AS = a.name
and t.spelling collate SQL_Latin1_General_CP1_CS_AS != a.name
where t.spelling is null
*/

INSERT INTO c_Drug_Tall_Man VALUES
('aCLin'),
('actoNEL'),
('actoS'),
('aFATinib'),
('aKAMin'),
('alDACTONE'),
('alDOMET'),
('ALKeran'),
('alODORM'),
('amARYl'),
('amLODIPine'),
('amOXil'),
('aPomine'),
('arABLOC'),
('arATAC'),
('ARIPiprazole'),
('arOPAX'),
('aTRopt'),
('avaSTIN'),
('avaXIM'),
('aVomine'),
('aXITinib'),
('aZopt'),
('bARICITinib'),
('beNRALizumab'),
('beVACizumab'),
('beZLOTOXumab'),
('biNIMEtinib'),
('bisACODYl'),
('bisOPROLOl'),
('buDESONide'),
('buMETANide'),
('CABAZitaxel'),
('cABOZANtinib'),
('caLTRate'),
('caRAFate'),
('caRVEDILOl'),
('cefaLEXin'),
('cefALOTIN'),
('cefEPIME'),
('cefOTAXIME'),
('ceftAROLine'),
('celAPRAM'),
('ciclosPORIN'),
('ciprAMIL'),
('ciprOXIN'),
('cLARITHROMYcin'),
('cloBAZam'),
('cLOMIFEne'),
('cOBIMEtinib'),
('coUMADIN'),
('coVERSYL'),
('cycLONEX'),
('CYCLOPHOSPHamide'),
('daBRAFEnib'),
('daSATinib'),
('DAUNOrubicin'),
('depo-PROVERA'),
('dePTRAn'),
('deRALin'),
('dexAMETHASOne'),
('dexMEDETOMIDine'),
('dilaNTIN'),
('dilaUDID'),
('diPRIVan'),
('diPYRIDAMOLe'),
('diSOPYRAMIDe'),
('diTROPan'),
('DOCEtaxel'),
('doSULepin (doTHiepin)'),
('DOXOrubicin'),
('DULoxetine'),
('eCULizumab'),
('eFALizumab'),
('eMICizumab'),
('ERYthromycin'),
('flucLOXACILLIN'),
('flucONAZOLe'),
('flucYTOSINe'),
('gliBENCLAMide'),
('gliCLAZide'),
('gliMEPIRide'),
('hydreA'),
('hydreNE'),
('HYDROmorphone'),
('INDEral'),
('isopto CARpine'),
('isopto HOMATROpine'),
('januMET'),
('januVIA'),
('ketALAR'),
('ketOROLAC'),
('lamiVUDine'),
('lanTUs'),
('laPAtinib'),
('leNVAtinib'),
('LEUKeran'),
('linCOMYCIN'),
('linEZOLID'),
('LORazepam'),
('loSEC'),
('loVAN'),
('mercaptAMine'),
('mercaptOPURine'),
('methADONe'),
('methYLPHENIDATe'),
('moBILis'),
('morphine'),
('moVALis'),
('MS Contin'),
('MYLeran'),
('NEOral'),
('niZATIDine'),
('NORfloxacin'),
('norMISON'),
('norVASC'),
('novoMIX'),
('novoRAPID'),
('oBINUTUZumab'),
('oCRELizumab'),
('oFATUMumab'),
('oMALizumab'),
('OXazepam'),
('oxyNORM'),
('PACLitaxel'),
('pANITUMumab'),
('paRIET'),
('PARoxetine'),
('paXTINE'),
('pERTUZumab'),
('pEXSIG'),
('primaCIN'),
('primaCOR'),
('primaXIN'),
('pRISTIQ'),
('proCHLORPERazine'),
('proGRAF'),
('proMETHazine'),
('propOFol'),
('propRANOLol'),
('RABEprazole'),
('raMUCIRumab'),
('raNIBIZumab'),
('rifaMPICin'),
('sAXagliptin'),
('SERTRALine'),
('soNIDEGib'),
('TACrolimus'),
('tAPENTadol'),
('tEMOdal'),
('tOFACitinib'),
('toFRANIL'),
('toPAMAX'),
('tORadol'),
('tRAMEtinib'),
('tretinoin'),
('trimEPRAZINE'),
('trimETHOPRIM'),
('valAciclovir'),
('valGANciclovir'),
('vinORELBine'),
('xalaCOM'),
('xalaTAN'),
('zinNAt'),
('zinVit'),
('zoCOR'),
('zoLOFT'),
('zoTON')


DELETE 
-- select *
FROM c_Drug_Tall_Man
WHERE spelling COLLATE SQL_Latin1_General_CP1_CI_AS IN (
'pseudoePHEDrine', -- incorrectly applied from ePHEDrine
'yaZ', -- too short, applies into DyaZide
'migALAstat',
'migLUstat',
'cycloSPORINE',
'hydroxyUREA',
'iBRUtinib',
'iMAtinib',
'niLOtinib',
'niLUTAmide',
'vanDETanib',
'vemURAFenib'
)

INSERT INTO c_Drug_Tall_Man VALUES
('migALAstat'),
('migLUstat'),
('cycloSPORINE'),
('hydroxyUREA'),
('iBRUtinib'),
('iMAtinib'),
('niLOtinib'),
('niLUTAmide'),
('vanDETanib'),
('vemURAFenib')

-- Capitalize brand names
/*
select '''' + t.spelling + ''','
FROM c_Drug_Brand b
JOIN c_Drug_Tall_Man t on b.brand_name like t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
WHERE ascii(left(spelling,1)) > 90
AND spelling not in ('bisACODYl', 'metroNIDAZOLE','proMETHazine','clINDAmycin','quiNINE',
	'caPTOPRIl','aTENOLol','traMADol','metFORMIN','medroxyPROGESTERone','ePHEDrine')
	union
select '''' + t.spelling + ''',' 
FROM c_Drug_Tall_Man t 
left join c_Drug_Generic g on g.generic_name like '%' + t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%' 
where ascii(left(spelling,1)) > 90
and g.generic_name is null
order by 1
*/
UPDATE t
SET spelling = upper(left(spelling,1)) + substring(spelling,2,200)
FROM c_Drug_Tall_Man t
WHERE ascii(left(spelling,1)) > 90
and spelling in (
'aCLin',
'aKAMin',
'alODORM',
'aPomine',
'arABLOC',
'arATAC',
'arOPAX',
'aTRopt',
'aVomine',
'cefaCLOR ',
'cefALOTIN',
'celAPRAM',
'ciprAMIL',
'ciprOXIN',
'coUMADIN',
'coVERSYL',
'cyclOBLASTIN',
'cycLONEX',
'depo-PROVERA',
'dePTRAn',
'deRALin',
'fluVAx',
'hydreNE',
'imUPRine',
'isopto HOMATROpine',
'januMET',
'januVIA',
'ketALAR',
'lanVis',
'laRGACTil',
'loVAN',
'loxaLATe',
'maxiDEX',
'maxiTROL',
'moBILis',
'moVALis',
'neO-MERCAZOLe',
'neUROKARe',
'norMISON',
'oxyNORM',
'paXTINE',
'pEXSIG',
'primaCIN',
'primaCOR',
'proGRAF',
'tEMOdal',
'toFRANIL',
'toPAMAX',
'tORadol',
'tRENTAl',
'xalaCOM',
'yasMIN',
'yaZ',
'zinVit',
'zoTON'
)

DELETE 
FROM c_Drug_Tall_Man
WHERE spelling = lower(spelling)

exec sp_update_tallman
