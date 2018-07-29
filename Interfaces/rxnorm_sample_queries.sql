
-- How do I find the RxCUI for a given NDC (55160010201)?

SELECT rxcui FROM rxnsat 
WHERE atv = '55160010201';

-- How do I find all the NDC(s) for a given RxCUI (200938)?

SELECT atv FROM rxnsat 
WHERE atn = 'NDC' 
     AND rxcui = '200938';

-- How do I find only the RxNorm normalized NDC(s) for a given RxCUI (200938)?

SELECT atv FROM rxnsat 
WHERE atn = 'NDC' 
     AND rxcui = '200938' 
     AND sab = 'RXNORM';

-- How do I find the RxCUI, SAB, TTY, CODE, and STR for a given NDC (50458025303)?

SELECT rxcui, sab, tty, code, str FROM rxnconso
WHERE rxcui in (select rxcui FROM rxnsat WHERE atn = 'NDC' AND atv = '50458025303');

-- How do I find the RxCUI for a drug with a given NDDF GCN_SEQ_NO (023855)?

SELECT rxcui FROM rxnconso 
WHERE code='023855' 
     AND sab='NDDF';

-- How do I find the CODE for a drug with a given RxCUI (198872)?

SELECT code FROM rxnconso 
WHERE rxcui='198872' 
     AND sab='MMSL';

-- How do I find the current RxCUI(s) for a given retired RxCUI (102889)?

SELECT cui2 FROM rxncui 
WHERE cui1='102889';

-- How do I get the SAB=RXNORM SBD drug name (STR) for RXCUI 1049565 from the RXNCONSO file and the MTHSPL drug schedule from the RXNSAT file?

SELECT distinct a.rxcui, b.atv as schedule, a.str FROM rxnconso a, rxnsat b 
WHERE a.rxcui = '1049565'
     AND a.tty = 'SBD' 
     AND a.rxcui = b.rxcui 
     AND b.sab = 'MTHSPL' 
     AND b.atn = 'DCSA';

-- How do I find RxNorm drugs that are associated with HCPCS J codes?

SELECT distinct b.rxcui, a.atv as hcpcs, b.tty, b.str FROM rxnsat a, rxnconso b 
WHERE a.atn = 'DHJC'
     AND a.atv like 'J%' 
     AND a.rxcui = b.rxcui 
     AND b.tty in ('GPCK', 'BPCK', 'SCD', 'SBD') 
     ORDER BY a.atv;

-- How do I find SAB=RXNORM quantified form drug data related to a given RxCUI (1359714)?

SELECT rxcui, sab, tty, suppress, str FROM rxnconso
WHERE tty in ('SCD', 'SBD') 
     AND rxcui in (SELECT rxcui1 FROM rxnrel WHERE rxcui2='1359714' AND rela='has_quantified_form');
	 
Term Types
Dose Form Group (DFG) is a term type that serves as a grouping of dose forms (TTY=DF) related by 
route of administration (i.e., Topical) or dose form (i.e., Pill). A complete list of dose form 
groups and the dose forms they include can be found in Appendix 3.

Semantic Clinical Dose Form Group (SCDG) uses the ingredient(s) and dose form group and Semantic 
Branded Dose Form Group (SBDG) uses the branding information and dose form group.

SCDG and SBDG names are shorter, because the strength information is not included, and the lists 
of drugs containing a particular ingredient would also be shorter, because of the grouping of 
dose forms into dose form groups.

The RXN_AVAILABLE_STRENGTH attribute specifies all of the available strengths for a particular 
drug for all dose forms within the dose form group. For example, the SCDG 'Diazepam Pill' has 
multiple ATN=RXN_AVAILABLE_STRENGTH attributes with one value (ATV) for each of the available 
strengths for all of the dose forms (oral tablet, oral capsule, etc.) - 2 MG, 5 MG, 10 MG, and 15 MG. 
The corresponding SCD/SBD for each SCDG/SBDG will also have an ATN=RXN_AVAILABLE_STRENGTH attribute 
with only one value (ATV) for its particular strength.

The RXTERM_FORM attribute provides dose form strings, many of which are abbreviated, that are 
useful for drug application interfaces. These attributes are associated with SCD and SBD concepts. 
For example, the SCD 'Diazepam 2 MG Oral Tablet' has an ATN=RXTERM_FORM attribute with a value (ATV) of 'Tab'.

The following relationships are used to connect DFGs, SCDGs, and SBDGs to other RxNorm term types:
  doseformgroup_of / has_doseformgroup  between a DFG and a DF, an SCDG, or an SBDG.
  ingredient_of / has_ingredient  between an SCDG and an IN, and between an SBDG and a BN.
  isa / inverse_isa  between an SCDG and an SCD or an SCDF, and between an SBDG and an SBD or an SBDF.
  tradename_of / has_tradename  between an SCDG and an SBDG.

-- List of all dose form groups and their members
SELECT con_dfg.[STR], con_df.[STR], rel.RELA  
from vw_RXNCONSO_Prescribable con_dfg
JOIN RXNREL rel ON con_dfg.RXCUI = rel.RXCUI1
JOIN vw_RXNCONSO_Prescribable con_df ON rel.RXCUI2 = con_df.RXCUI
where con_dfg.TTY ='DFG' 
and rel.RELA = 'isa'
and con_df.TTY ='DF'
order by con_dfg.[STR], con_df.[STR]

-- Available strengths of Diazepam
SELECT con_drug.[STR], con_strgth.ATV
from vw_RXNCONSO_Prescribable con_drug
JOIN vw_RXNSAT_Prescribable con_strgth ON con_drug.RXCUI = con_strgth.RXCUI
where con_drug.TTY = 'SCDG' --,'SBDG')
and con_drug.RXCUI = 1155862
and con_strgth.ATN = 'RXN_AVAILABLE_STRENGTH'

-- Brand names for Diazepam
SELECT con_brandname.[STR], rel.RELA, con_generic.[STR] 
from vw_RXNCONSO_Prescribable con_generic
JOIN RXNREL rel ON con_generic.RXCUI = rel.RXCUI1
JOIN vw_RXNCONSO_Prescribable con_brandname ON rel.RXCUI2 = con_brandname.RXCUI
where con_generic.RXCUI = 1155862
and rel.RELA = 'tradename_of'

-- Dose forms of diazepam ingredient
SELECT -- ingredient.[STR], rel.RELA, con_generic.[STR], con_generic.TTY, rel2.RELA, 
	distinct doseformgroup.[STR]
from vw_RXNCONSO_Prescribable con_generic
JOIN RXNREL rel ON con_generic.RXCUI = rel.RXCUI1
JOIN vw_RXNCONSO_Prescribable ingredient ON rel.RXCUI2 = ingredient.RXCUI
JOIN RXNREL rel2 ON con_generic.RXCUI = rel2.RXCUI1
JOIN vw_RXNCONSO_Prescribable doseformgroup ON rel2.RXCUI2 = doseformgroup.RXCUI
where lower(ingredient.[STR]) like 'diaze%'
and con_generic.TTY IN ('SCDG','SCDF')
and ingredient.TTY IN ('IN','SU')
and rel.RELA = 'ingredient_of'
and rel2.RELA = 'doseformgroup_of'
