-- From ProposedDescriptionFix-DuplicateICD10_final_sheet1.xlsx 18/3/2019

-- Delete elsewhere

DELETE FROM c_Age_Range_Assessment 
WHERE assessment_id IN (
'WELL20Y', 'WELL21Y', 'WELL40Y', 'WELL65Y')

DELETE FROM c_Maintenance_Assessment 
WHERE assessment_id IN (
'DEMO10487',
'DEMO10543',
'DEMO10606',
'DEMO10618',
'DEMO1572',
'DEMO1573',
'DEMO1574',
'DEMO1578',
'DEMO4636',
'DEMO4648',
'DEMO4649',
'DEMO4663',
'DEMO4664')

DELETE FROM c_Workplan_Item_Attribute
WHERE attribute = 'assessment_id'
AND value IN (
'DEMO10433',
'DEMO10481',
'DEMO11301',
'DEMO11302',
'DEMO11315',
'DEMO11318',
'DEMO11319',
'DEMO11334',
'DEMO11335',
'VAGINITIS',
'WELL20Y',
'WELL21Y',
'WELL40Y',
'WELL65Y');

DISABLE TRIGGER tr_p_Assessment_delete ON p_Assessment

DELETE FROM p_Assessment 
WHERE assessment_id IN (
'DEMO10314',
'DEMO10391',
'DEMO10428',
'DEMO219',
'WELL20Y',
'WELL21Y')
GO

ENABLE TRIGGER tr_p_Assessment_delete ON p_Assessment

DELETE FROM p_Encounter_Assessment 
WHERE assessment_id IN (
'DEMO10391',
'DEMO10428',
'DEMO219')


DELETE FROM c_Assessment_Definition
where assessment_id 
IN (
'DEMO97',
'DEMO602',
'DEMO10200',
'DEMO1978',
'DEMO8798',
'DEMO8813',
'DEMO8813a',
'DEMO8857',
'DEMO8857a',
'DEMO8858',
'DEMO8858a',
'DEMO8860',
'DEMO8861',
'DEMO8863',
'DEMO8863a',
'DEMO9560a',
'DEMO9563',
'DEMO642',
'DEMO10359',
'DEMO587',
'DEMO8355',
'DEMO659',
'DEMO8378',
'DEMO8379',
'DEMO8380',
'DEMO696',
'DEMO8542',
'DEMO8568',
'DEMO7530',
'DEMO7532',
'DEMO7533',
'DEMO7534',
'DEMO7535',
'DEMO7536',
'DEMO4649',
'DEMO4664',
'DEMO4648',
'DEMO4663',
'DEMO4636',
'DEMO4748',
'DEMO4754',
'DEMO8952',
'DEMO4767',
'DEMO4768',
'DEMO4769',
'DEMO4802',
'DEMO4808',
'DEMO4789',
'DEMO4812',
'DEMO9731',
'PHOB',
'DEMO9749',
'DEMO9758',
'DEMO9764',
'BRU',
'ASSESSMENT24',
'SUIC',
'DEMO7321',
'DEMO9774',
'DEMO1824',
'DEMO1827',
'DEMO7356',
'DEMO7342',
'DEMO6924',
'DEMO6376',
'DEMO6377',
'DEMO6451',
'DEMO6452',
'DEMO6461',
'DEMO6464',
'DEMO6334',
'DEMO5451',
'DEMO5534',
'DEMO5526',
'DEMO5544',
'DEMO5549',
'DEMO5552',
'DEMO5405',
'DEMO5408',
'DEMO5409',
'DEMO5407',
'DEMO5413',
'DEMO5421',
'DEMO5423',
'DEMO5393',
'DEMO5394',
'DEMO5432',
'DEMO5430',
'DEMO5434',
'DEMO4474',
'DEMO5334',
'DEMO5387',
'DEMO5398',
'DEMO5515',
'DEMO5513',
'DEMO5514',
'DEMO5517',
'DEMO5518',
'DEMO5498',
'DEMO5499',
'DEMO5503',
'DEMO5306',
'DEMO5316',
'DEMO6483',
'DEMO6485',
'DEMO6580',
'DEMO6551',
'DEMO6566',
'DEMO6590',
'DEMO5576',
'DEMO5578',
'DEMO5260',
'DEMO5232',
'DEMO5238',
'DEMO5255',
'DEMO5263',
'DEMO5264',
'DEMO5266',
'DEMO5269',
'DEMO5271',
'DEMO5268',
'DEMO5265',
'DEMO5237',
'DEMO5239',
'DEMO5272',
'DEMO5273',
'DEMO5274',
'DEMO5276',
'DEMO5277',
'DEMO6632',
'DEMO6761',
'DEMO10373',
'DEMO10413',
'DEMO6779',
'DEMO6780',
'DEMO6785',
'DEMO6788',
'TYM',
'DEMO6882',
'DEMO6888',
'DEMO6895',
'DEMO10520',
'DEMO10149',
'DEMO1641',
'DEMO1655',
'DEMO1656',
'DEMO1578',
'DEMO1584',
'DEMO1586',
'DEMO1583',
'DEMO1585',
'DEMO1618',
'DEMO1620',
'DEMO1617',
'DEMO1608',
'DEMO1611',
'DEMO1595',
'DEMO1607',
'DEMO1610',
'DEMO1613',
'DEMO1606',
'DEMO1612',
'DEMO1572',
'DEMO1574',
'DEMO10543',
'DEMO1573',
'DEMO1676b',
'DEMO1698',
'DEMO1702a',
'DEMO1706',
'DEMO1707',
'DEMO1708',
'DEMO10546',
'DEMO10547',
'DEMO10425',
'DEMO10622',
'DEMO1624',
'DEMO1626',
'DEMO1627',
'DEMO10417',
'DEMO10548',
'DEMO4475',
'DEMO1732a',
'DEMO1748',
'DEMO1721',
'DEMO1750',
'DEMO4476',
'000112xxx',
'000125xxx',
'DEMO1753',
'DEMO1755',
'DEMO1761',
'DEMO1772b',
'DEMO1773',
'DEMO1778',
'ATR',
'DEMO1828',
'DEMO1829',
'DEMO1830',
'DEMO1879',
'DEMO8330',
'DEMO1917',
'DEMO1921',
'DEMO9993',
'DEMO1924',
'DEMO1927',
'DEMO1930',
'DEMO1931',
'DEMO1932',
'DEMO1933',
'DEMO1796',
'DEMO1974',
'DEMO10433',
'INFLU',
'DEMO529',
'DEMO10391',
'DEMO10428',
'DEMO10487',
'DEMO10618',
'DEMO10630',
'DEMO10430',
'DEMO10489',
'DEMO10490',
'DEMO10481',
'DEMO10381',
'0^520.6^0',
'DEMO7586',
'DEMO7587',
'DEMO7588',
'DENTALPL',
'DEMO7614',
'DEMO7615',
'DEMO7616',
'0^536.8^0',
'DEMO136',
'DEMO152',
'DEMO1955',
'DEMO8036a',
'DEMO8035a',
'DEMO8039a',
'DEMO8040a',
'DEMO8040b',
'DEMO8040c',
'FURN',
'DEMO5023',
'DEMO5027',
'DEMO5030',
'DEMO5038',
'DEMO5039',
'DEMO5034',
'DEMO5042',
'BOIL',
'DEMO5043',
'DEMO5049',
'PARONYCHIAF',
'PARY',
'DEMO10606',
'ASSESSMENT40',
'DEMO5057',
'DEMO5058',
'DEMO5061',
'DEMO5062',
'DEMO5063',
'DEMO5064',
'DEMO5053',
'DEMO5060',
'DEMO5055',
'CELLULITISO',
'DEMO5065',
'DEMO10609',
'DEMO5069',
'DEMO5070',
'DEMO5071',
'DEMO5194',
'DEMO10188',
'DERMS',
'DEMO5078',
'DEMO10621',
'DEMO5091',
'DEMO5092',
'DERNEU',
'DEMO5114',
'DEMO590',
'DEMO5147',
'DEMO260',
'DEMO262',
'DEMO631',
'ACNENEW',
'DEMO10393',
'DEMO5143',
'DEMO5196',
'DEMO5197',
'DEMO5198',
'0001106x',
'DEMO5130',
'DEMO5132',
'DEMO5133',
'DEMO5134',
'FOL',
'DEMO10645',
'DEMO5139',
'DEMO5140',
'DEMO5115',
'DEMO10397',
'INT',
'DEMO10398',
'DEMO5156',
'DEMO5158',
'DEMO5159',
'DEMO219',
'DEMO5203',
'DEMO4422',
'DEMO3564',
'DEMO3597',
'DEMO3583',
'DEMO4584',
'DEMO3555',
'DEMO3947',
'TORSTIB',
'DEMO275',
'DEMO8004',
'DEMO62',
'DEMO10290',
'00017x',
'DEMO10521',
'DEMO3680',
'DEMO3681',
'DEMO7622',
'TMJ',
'DEMO1902',
'DEMO4561',
'DEMO2002',
'DEMO111',
'DEMO3696',
'DEMO3698',
'DEMO10112',
'DEMO3699',
'HNP',
'DEMO3704',
'DDD',
'DEMO10073',
'DEMO3705',
'DEMO3701',
'DEMO3706',
'DEMO3732',
'DEMO10194',
'DEMO10117',
'DEMO3735',
'DEMO3717',
'DEMO10083',
'DEMO3806',
'RORS',
'DEMO8006',
'TENHIP',
'TENKNE',
'TENWRI',
'TENFOO',
'TENARM',
'DEMO3780',
'DEMO3765',
'DEMO8021',
'DEMO118',
'DEMO3793',
'DEMO3779',
'DEMO10089',
'DEMO8012',
'DEMO8024',
'DEMO8029',
'TENSHO',
'DEMO8025',
'DEMO4582',
'DEMO4583',
'DEMO8014',
'DEMO8023',
'DEMO8026',
'DEMO8027',
'DEMO8028',
'BURSHIP',
'BURSTRO',
'DEMO8031',
'DEMO3767',
'DEMO3761',
'DEMO3758',
'DEMO8011',
'DEMO254',
'NEUR',
'DEMO10493',
'DEMO10511',
'DEMO10523',
'DEMO10504',
'MYALGIA',
'MYOSI',
'DEMO400',
'DEMO3934',
'OS',
'DEMO427',
'DEMO3711',
'DEMO3712',
'DEMO3713',
'DEMO6949',
'GLO',
'DEMO6977',
'DEMO8958',
'DEMO8962',
'INC',
'DEMO7060',
'ORC',
'DEMO10051',
'DEMO7092',
'DEMO8928',
'PHIM',
'DEMO218',
'DEMO7103',
'DEMO308',
'DEMO7119',
'DEMO7120',
'DEMO7121',
'DEMO7122',
'DEMO7123',
'DEMO8974',
'DEMO8975',
'DEMO646',
'DEMO7105',
'DEMO7144',
'DEMO7145',
'DEMO8984',
'DEMO8985',
'DEMO8986',
'DEMO8987',
'DEMO8988',
'DEMO8992',
'NEURA',
'DEMO735',
'DEMO749',
'DEMO751',
'DEMO753',
'DEMO768',
'DEMO769',
'DEMO770',
'DEMO771',
'DEMO757',
'DEMO758',
'DEMO759',
'DEMO762',
'VAGINITIS',
'PROU',
'DEMO801',
'DEMO803',
'DEMO804',
'DEMO812',
'DEMO813',
'DEMO809',
'DEMO810',
'DEMO875a',
'DEMO877w4',
'DEMO1133',
'DEMO1132',
'DEMO11001',
'DEMO11003',
'DEMO11005',
'DEMO10678',
'DEMO897',
'DEMO10681',
'DEMO904a',
'DEMO905c',
'DEMO904d',
'DEMO905a',
'DEMO905d',
'DEMO905',
'DEMO10686',
'DEMO901a',
'DEMO10694',
'PREa',
'DEMO902',
'DEMO902c',
'DEMO902e',
'DEMO900',
'DEMO903c',
'DEMO903b',
'DEMO903e',
'DEMO444r',
'DEMO11205',
'DEMO11208',
'DEMO11209',
'DEMO11210',
'DEMO11213',
'DEMO11216',
'DEMO11226',
'DEMO11222',
'DEMO11231',
'DEMO11234',
'DEMO10737',
'DEMO10789',
'DEMO10719',
'DEMO10726',
'DEMO10723',
'DEMO10827',
'DEMO10845',
'DEMO10716',
'DEMO10847',
'DEMO10849',
'DEMO10851',
'DEMO10853',
'DEMO10855',
'DEMO10857',
'DEMO10859',
'DEMO10861',
'DEMO10868',
'DEMO10816',
'DEMO10817',
'DEMO10876',
'DEMO10880',
'DEMO10884',
'DEMO10886',
'DEMO10892',
'DEMO10893',
'DEMO10896',
'DEMO10897',
'DEMO10899',
'DEMO10911',
'DEMO10912',
'DEMO10914',
'DEMO10915',
'DEMO10916',
'DEMO10901',
'DEMO10902',
'DEMO10903',
'DEMO10906',
'DEMO10907',
'DEMO10939',
'DEMO10922',
'DEMO10923',
'DEMO10924',
'DEMO10928',
'DEMO10929',
'DEMO10931',
'DEMO10933',
'DEMO10935',
'DEMO10937',
'DEMO10941',
'DEMO10943',
'DEMO10947',
'DEMO10949',
'DEMO10955',
'DEMO10959',
'DEMO10961',
'DEMO10963',
'DEMO10970',
'DEMO10975',
'DEMO10984',
'DEMO10986',
'DEMO10988',
'DEMO10991',
'DEMO10951',
'DEMO10965',
'DEMO888r',
'DEMO890r',
'DEMO457r',
'DEMO10709',
'DEMO10714',
'DEMO11060',
'DEMO11064',
'DEMO11066',
'DEMO11062',
'DEMO11025',
'DEMO1064',
'DEMO11018',
'DEMO11020',
'DEMO11022',
'DEMO11029',
'DEMO11031',
'DEMO11033',
'DEMO11035',
'DEMO11041',
'DEMO11068',
'DEMO11071',
'DEMO11073',
'DEMO11075',
'DEMO11077',
'DEMO11083',
'DEMO11086',
'DEMO11090',
'DEMO11094',
'DEMO11093',
'DEMO11096',
'DEMO11105',
'DEMO11107',
'DEMO11108',
'DEMO11110',
'DEMO11111',
'DEMO11112',
'DEMO11119',
'DEMO11100',
'DEMO11128',
'DEMO11129',
'DEMO11102',
'DEMO11103',
'DEMO11133',
'DEMO11134',
'DEMO11149',
'DEMO11163',
'DEMO11165',
'DEMO11167',
'DEMO11168',
'DEMO11169',
'DEMO11170',
'DEMO11172',
'DEMO11173',
'DEMO11174',
'DEMO10999',
'DEMO10982',
'DEMO11013',
'DEMO11196',
'DEMO11197',
'DEMO11198',
'DEMO11199',
'DEMO11200',
'DEMO11011',
'DEMO11214',
'DEMO11206',
'DEMO11230',
'DEMO11235',
'DEMO1094a',
'DEMO11241',
'DEMO11245',
'DEMO11249',
'DEMO11256',
'DEMO1098',
'DEMO11254',
'DEMO11253',
'DEMO11257',
'DEMO11261',
'DEMO11166',
'DEMO11265',
'DEMO11269',
'DEMO11271',
'DEMO11276',
'DEMO11277',
'DEMO11280',
'DEMO11284',
'DEMO11297',
'DEMO11298',
'DEMO11301',
'DEMO11302',
'DEMO11306',
'DEMO11309',
'DEMO11310',
'DEMO11315',
'DEMO11318',
'DEMO11319',
'DEMO11326',
'DEMO11327',
'DEMO11334',
'DEMO11335',
'DEMO11330',
'DEMO11331',
'DEMO10763',
'DEMO10750',
'DEMO10754',
'DEMO10759',
'DEMO10775',
'DEMO10771',
'DEMO10776',
'DEMO10767',
'DEMO10785',
'DEMO10797',
'0^649.14^0',
'DEMO10824',
'DEMO10793',
'DEMO10801',
'DEMO10805',
'DEMO10812',
'DEMO10810',
'DEMO10809',
'DEMO10811',
'DEMO10813',
'DEMO11263',
'DEMO942',
'DEMO10821',
'DEMO6705',
'UMBGRAN',
'HYMAG',
'DEMO5716',
'DEMO5717',
'DEMO6030',
'DEMO5774',
'DEMO2017',
'DEMO2018',
'DEMO2019',
'DEMO71',
'DEMO2052',
'DEMO6043',
'LARY',
'DEMO5866',
'DEMO5867',
'DEMO5870',
'DEMO5880',
'DEMO6014',
'DEMO6018',
'DEMO6027',
'DEMO6037',
'DEMO6042',
'DEMO7079',
'UNDET',
'DEMO5960',
'DEMO5961',
'DEMO5962',
'DEMO5963',
'DEMO5964',
'DEMO5965',
'DEMO5966',
'DEMO5967',
'DEMO5991',
'DEMO6034',
'EQIUNO',
'PPC',
'DEMO6124',
'DEMO6125',
'DEMO6237',
'DEMO6243',
'DEMO6244',
'DEMO6255',
'DEMO6256',
'DEMO6257',
'DEMO6258',
'DEMO6259',
'DEMO6260',
'SPO',
'DEMO6130',
'DEMO6051',
'HEMI',
'DEMO10614',
'DYSP',
'SNORE',
'DEMO10503',
'DEMO10611',
'DEMO7143',
'DEMO10314',
'SPL',
'DEMO1255',
'DEMO1227',
'DEMO273',
'NUM',
'RASH',
'DEMO2106',
'DEMO56',
'TRE',
'DEMO231',
'DEMO8994',
'DEMO10525',
'HAT',
'DEMO2122',
'DEMO2108',
'EDE',
'DEMO11121',
'DEMO632',
'DEMO9068',
'DEMO9133',
'DEMO1275',
'HYGLY',
'HYPUR',
'DEMO1286',
'DEMO1477',
'DEMO3094',
'DEMO2807A',
'DEMO2808A',
'DEMO2809A',
'DEMO2802A',
'DEMO2803A',
'DEMO2812',
'DEMO2815A',
'DEMO2816A',
'DEMO2817A',
'DEMO2818A',
'DEMO2813A',
'DEMO2142',
'DEMO2144',
'DEMO2154',
'DEMO2141',
'DEMO2149',
'DEMO2161',
'DEMO2163',
'DEMO2167',
'DEMO2160',
'TOOTHIA',
'DEMO2219',
'DEMO2228',
'DEMO2230',
'DEMO2235',
'DEMO2213',
'DEMO2214',
'DEMO2205',
'DEMO4576',
'DEMO445',
'DEMO3093',
'DEMO541',
'DEMO10295',
'DEMO10293',
'DEMO2810A',
'TMPERFA',
'DEMO2086A',
'DEMO2804A',
'DEMO3220',
'DEMO205A',
'DEMO381A',
'DEMO452',
'DEMO2999',
'DEMO503',
'DEMO3003',
'DEMO3001',
'DEMO2310',
'DEMO2311',
'DEMO6837',
'DEMO6852',
'DEMO6839',
'DEMO6844',
'DEMO3207',
'DEMO2295',
'DEMO2288',
'DEMO496',
'DEMO6850',
'DEMO6851',
'DEMO504',
'DEMO2827',
'DEMO2874',
'DEMO2876',
'DEMO2836A',
'DEMO2832A',
'DEMO2271',
'DEMO6848',
'DEMO2284',
'DEMO2917',
'DEMO2918',
'CONSHO',
'DEMO3105',
'DEMO454',
'DEMO3016',
'DEMO3020',
'DEMO3018',
'DEMO2851',
'DEMO2851B',
'DEMO380',
'DEMO380B',
'DEMO2838A',
'DEMO2839A',
'DEMO2851A',
'DEMO380A',
'DEMO2841A',
'DEMO2838B',
'DEMO2839B',
'DEMO2840B',
'DEMO2841B',
'FXRADS',
'DEMO447',
'DEMO3054',
'DEMO3058',
'DEMO3056',
'DEMO449',
'DEMO3045',
'DEMO3049',
'DEMO3047',
'DEMO446',
'DEMO3025',
'DEMO3029',
'DEMO3027',
'DEMO2450',
'DEMO2849B',
'DEMO3226',
'DEMO505',
'DEMO2864B',
'DEMO2860',
'DEMO2860A',
'DEMO2860B',
'DEMO3139',
'FXTIBFIB',
'DEMO2533',
'DEMO2534',
'DEMO2535',
'DEMO2539',
'DEMO2648',
'DEMO2652',
'DEMO360',
'DEMO3064',
'DEMO3067',
'DEMO3066',
'DEMO448',
'DEMO3073',
'DEMO3077',
'DEMO3075',
'DEMO2862',
'DEMO2862A',
'DEMO2863A',
'DEMO501',
'DEMO501A',
'DEMO2861B',
'DEMO2862B',
'DEMO2863B',
'DEMO382B',
'DEMO501B',
'DEMO2540',
'DEMO3098',
'DEMO2985',
'DEMO10407',
'DEMO10408',
'DEMO10405',
'DEMO508',
'DEMO3239',
'DEMO512',
'HEATSTR',
'HEAT',
'DEMO3343',
'DEMO3347',
'DEMO3345',
'DEMO3346',
'DEMO3393',
'DEMO3396',
'DEMO9143',
'DEMO9837',
'DEMO9929',
'DEMO9933',
'DEMO9936',
'DEMO10268',
'DEMO9918',
'WELL20Y',
'WELL21Y',
'WELL40Y',
'WELL65Y',
'VISPROBA',
'DEMO1480A',
'DEMO3633A',
'DEMO9297',
'DEMO10320',
'DEMO1207',
'DEMO1208',
'DEMO9295',
'DEMO622',
'DEMO365',
'DEMO724',
'DEMO9312',
'DEMO9313',
'DEMO9355',
'DEMO9356',
'DEMO9362',
'DEMO9363',
'DEMO630',
'DEMO877w4b',
'DEMO877z4b',
'DEMO9479',
'0^V58.31^1',
'PROBFAM',
'DIET',
'DEMO9491',
'PROBPC',
'DEMO9262',
'DEMO10214',
'DEMO3394')

-- Update assessment reference

 UPDATE u_top_20 SET item_id = 'ICD-B027' WHERE item_id = 'DEMO8864' and top_20_code like '%assess%' 
 UPDATE u_assessment_treat_definition set assessment_id = 'ICD-B027' WHERE assessment_id = 'DEMO8864' 
 UPDATE c_Common_Assessment set assessment_id = 'ICD-B027' WHERE assessment_id = 'DEMO8864' 

-- Delete elsewhere

DELETE FROM c_Assessment_Definition
where assessment_id 
IN (
'DEMO4028',
'DEMO4029',
'DEMO4030',
'DEMO4031',
'DEMO4032',
'DEMO4033',
'DEMO4034',
'DEMO4035',
'DEMO4037',
'DEMO4038',
'DEMO4039',
'DEMO4040',
'0^052.7^1',
'0^052.8^0',
'0^052.8^1',
'DEMO4247',
'0^12312',
'DEMO4154',
'DEMO8358',
'DEMO8152',
'DEMO8153',
'DEMO8154',
'DEMO8232',
'DEMO8239',
'DEMO8240',
'DEMO8201',
'DEMO8202',
'DEMO8203',
'DEMO8204',
'DEMO8205',
'DEMO8206',
'DEMO8328',
'DEMO3486',
'DEMO3487',
'DEMO3484',
'DEMO8907',
'DEMO8919',
'DEMO8493',
'DEMO8522',
'DEMO8526',
'DEMO8527',
'DEMO8775',
'DEMO8776',
'DEMO8910',
'DEMO8915',
'DEMO7422',
'DEMO7463',
'DEMO7555',
'DEMO7556',
'DEMO7557',
'DEMO7558',
'DEMO4630',
'DEMO4645',
'DEMO4653',
'DEMO4656',
'DEMO4660',
'0^12006',
'DEMO4640',
'DEMO4644',
'DEMO4652',
'DEMO4655',
'DEMO4659',
'DEMO4744',
'DEMO4759',
'DEMO4760',
'DEMO4761',
'DEMO4749',
'DEMO4750',
'DEMO4762',
'DEMO4752',
'DEMO4753',
'DEMO4803',
'0^11648',
'0^11649',
'0^11650',
'DEMO9567',
'DEMO9569',
'DEMO9571',
'DEMO9578',
'DEMO9579',
'DEMO9628',
'DEMO9636',
'DEMO9783',
'DEMO9662',
'DEMO9748',
'DEMO9750',
'DEMO9751',
'DEMO9760',
'0^11734',
'DEMO9761',
'DEMO9763',
'DEMO9686',
'DEMO9805',
'DEMO9811',
'DEMO9812',
'DEMO9814',
'DEMO9816',
'DEMO9817',
'DEMO9785',
'DEMO9786',
'DEMO9789',
'DEMO4473',
'DEMO7165',
'DEMO7166',
'DEMO7168',
'DEMO7180',
'0^323.42^0',
'0^323.63^0',
'DEMO7237',
'DEMO7244',
'DEMO7246',
'DEMO7248',
'DEMO7202',
'DEMO7316',
'DEMO7317',
'DEMO7306',
'DEMO7331',
'0^11966',
'DEMO2092',
'DEMO2094',
'DEMO2098',
'DEMO7397',
'DEMO7398',
'DEMO7413',
'DEMO7283',
'DEMO7277',
'DEMO6346',
'DEMO6347',
'DEMO6775',
'DEMO6865',
'DEMO6866',
'DEMO6867',
'DEMO6869',
'DEMO6878',
'DEMO6880',
'DEMO6881',
'DEMO6884',
'DEMO6891',
'DEMO6892',
'DEMO6893',
'DEMO6894',
'DEMO6897',
'DEMO6898',
'DEMO6899',
'DEMO6900',
'DEMO6902',
'DEMO6903',
'DEMO6904',
'DEMO6905',
'DEMO6906',
'DEMO6907',
'DEMO6934',
'DEMO6909',
'DEMO6910',
'DEMO6918',
'DEMO6919',
'DEMO6914',
'DEMO6916',
'DEMO6933',
'DEMO10513',
'DEMO6937',
'DEMO6941',
'DEMO6943',
'DEMO1822',
'DEMO10550',
'DEMO4477',
'DEMO4959',
'DEMO4960',
'DEMO4961',
'DEMO5008',
'DEMO4925',
'DEMO4927',
'0^11663',
'DEMO10561',
'DEMO7695',
'DEMO10566',
'GASa',
'DEMO7796a',
'DUITa',
'DEMO7737',
'DEMO7738',
'DEMO7739',
'DEMO7740',
'DEMO7741',
'DEMO7865',
'DEMO7886',
'DEMO7887',
'DEMO7888',
'DEMO7889',
'DEMO7890',
'DEMO7827',
'DEMO7828',
'DEMO7829',
'DEMO7824',
'DEMO7825',
'DEMO7826',
'DEMO7832',
'DEMO7842',
'DEMO7972',
'DEMO7973',
'DEMO7974',
'DEMO7975',
'DEMO7976',
'DEMO7947',
'DEMO7948',
'DEMO7988',
'DEMO7978',
'DEMO7987',
'DEMO8032',
'DEMO8070',
'DEMO8074',
'DEMO8089',
'DEMO8090',
'DEMO7961',
'DEMO7963',
'DEMO4219',
'DEMO11357',
'DEMO3666',
'DEMO3667',
'DEMO4786',
'0^12251',
'0^12147',
'0^12148',
'0^12149',
'0^12153',
'0^12154',
'0^12156',
'0^12157',
'0^12158',
'0^12162',
'0^12163',
'DEMO3600',
'DEMO8003',
'DEMO8002',
'DEMO3969',
'DEMO3971',
'DEMO3954',
'DEMO6249',
'DEMO3642',
'DEMO3643',
'DEMO3644',
'DEMO3647',
'0^12181',
'DEMO3646',
'0^12197',
'DEMO3649',
'0^12216',
'DEMO3651',
'DEMO3660',
'0^12225',
'0^12226',
'DEMO10576',
'DEMO10576f',
'DEMO10576h',
'DEMO10576i',
'DEMO10576a',
'DEMO10576b',
'DEMO10576c',
'DEMO10576d',
'DEMO8005',
'DEMO10576e',
'DEMO10576g',
'0^12228',
'0^12229',
'0^12230',
'0^12231',
'0^12232',
'0^12233',
'0^12234',
'0^12235',
'0^12245',
'DEMO3752',
'DEMO3679',
'DEMO7625',
'DEMO7638',
'DEMO7641',
'DEMO3980',
'0^12207',
'DEMO3697a',
'DEMO3733',
'DEMO4149',
'DEMO3777',
'DEMO3778',
'DEMO8019',
'DEMO3795',
'DEMO3797',
'DEMO3799',
'DEMO3763',
'DEMO8007',
'DEMO8008',
'DEMO8010',
'DEMO8013',
'DEMO8030',
'DEMO3825',
'0^729.71^1',
'0^729.72^1',
'DEMO3922',
'DEMO3927',
'DEMO3935',
'DEMO3943',
'DEMO6994',
'DEMO6995',
'DEMO6996',
'DEMO6997',
'DEMO6998',
'DEMO7001',
'DEMO7002',
'DEMO7012',
'DEMO7013',
'DEMO7014',
'DEMO7029',
'DEMO8965',
'DEMO7019',
'DEMO7020',
'DEMO7021',
'DEMO7041',
'DEMO8967',
'DEMO7055',
'DEMO7056',
'DEMO7057',
'DEMO7058',
'DEMO8968',
'DEMO8969',
'DEMO8970',
'DEMO7067',
'DEMO7068',
'DEMO7071',
'DEMO7073',
'DEMO7074',
'DEMO7075',
'DEMO7076',
'DEMO7077',
'DEMO7085',
'DEMO7086',
'DEMO7096',
'DEMO7097',
'DEMO7098',
'DEMO7099',
'DEMO8972',
'DEMO7124',
'DEMO8979',
'DEMO8980',
'DEMO7135',
'DEMO7136',
'DEMO7137',
'DEMO8981',
'DEMO7089',
'DEMO7090',
'DEMO7131',
'DEMO877w9',
'DEMO877w6',
'DEMO877w5',
'DEMO877w8',
'DEMO876r',
'DEMO877b',
'DEMO877q',
'DEMO877r',
'DEMO443x9q',
'DEMO443x9r',
'DEMO877w9b',
'DEMO877w9q',
'DEMO877w9r',
'DEMO877z9b',
'DEMO877z9q',
'DEMO877z9r',
'DEMO443x6q',
'DEMO443x6r',
'DEMO877w6b',
'DEMO877w6q',
'DEMO877w6r',
'DEMO877z6b',
'DEMO877z6q',
'DEMO877z6r',
'DEMO443x2q',
'DEMO443x2r',
'DEMO877w2b',
'DEMO877w2q',
'DEMO877w2r',
'DEMO877z2b',
'DEMO877z2q',
'DEMO877z2r',
'DEMO443x5q',
'DEMO443x5r',
'DEMO877w5b',
'DEMO877w5q',
'DEMO877w5r',
'DEMO877z5b',
'DEMO877z5q',
'DEMO877z5r',
'DEMO874q',
'DEMO875q',
'DEMO443x8q',
'DEMO443x8r',
'DEMO877w8b',
'DEMO877w8q',
'DEMO877w8r',
'DEMO877z8b',
'DEMO877z8q',
'DEMO877z8r',
'DEMO881',
'DEMO1134',
'DEMO8sq',
'DEMO8sr',
'DEMO889q',
'DEMO889r',
'DEMO907',
'DEMO1092',
'DEMO11228',
'DEMO11232',
'DEMO921',
'DEMO10735',
'DEMO10736',
'DEMO10722',
'0^649.53^0',
'DEMO1316',
'DEMO10829',
'DEMO10840',
'0^12051',
'DEMO10842',
'DEMO950',
'DEMO10850',
'DEMO951',
'DEMO952',
'DEMO10854',
'DEMO953',
'DEMO954',
'DEMO955',
'DEMO956',
'DEMO10866',
'DEMO10867',
'DEMO957',
'DEMO10815',
'DEMO10869',
'DEMO10870',
'DEMO6106',
'DEMO940',
'DEMO963',
'DEMO964',
'DEMO965',
'DEMO10882',
'DEMO966',
'DEMO968',
'DEMO10891',
'DEMO10895',
'DEMO971',
'DEMO10910',
'DEMO10904',
'DEMO10905',
'DEMO10927',
'DEMO978',
'DEMO979',
'DEMO981',
'DEMO982',
'DEMO983',
'DEMO984',
'DEMO985',
'DEMO986',
'DEMO987',
'DEMO989',
'DEMO977',
'DEMO990',
'DEMO995',
'DEMO998',
'DEMO999',
'DEMO988',
'DEMO10972',
'DEMO10987',
'DEMO1008',
'DEMO10952',
'DEMO1193',
'DEMO11059',
'DEMO11063',
'DEMO11065',
'DEMO11061',
'DEMO11024',
'DEMO11190',
'DEMO11017',
'DEMO11019',
'DEMO11026',
'DEMO11028',
'DEMO11030',
'DEMO1079',
'DEMO1080',
'DEMO11032',
'DEMO11034',
'DEMO11186',
'DEMO11040',
'DEMO11067',
'DEMO1044',
'DEMO11069',
'DEMO11079',
'DEMO11080',
'DEMO11070',
'DEMO11072',
'DEMO11074',
'DEMO11076',
'DEMO11081',
'DEMO11082',
'DEMO11085',
'DEMO11089',
'DEMO11092',
'DEMO11095',
'DEMO11117',
'DEMO11122',
'DEMO11126',
'DEMO11127',
'DEMO11130',
'DEMO11131',
'DEMO11132',
'DEMO10981',
'DEMO11012',
'DEMO1002',
'DEMO10966',
'DEMO11191',
'DEMO11233',
'DEMO11255',
'DEMO1104',
'DEMO11268',
'DEMO11270',
'DEMO11295',
'DEMO11296',
'DEMO11305',
'DEMO11307',
'DEMO11308',
'DEMO11311',
'DEMO11312',
'DEMO11313',
'DEMO11317',
'DEMO11325',
'DEMO11332',
'DEMO11333',
'DEMO11329',
'DEMO930',
'DEMO10773',
'DEMO10774',
'DEMO932',
'0^649.34^0',
'DEMO10822',
'DEMO10823',
'0^649.04^0',
'0^649.44^0',
'DEMO11262',
'0^649.24^0',
'0^12037',
'0^12038',
'DEMO6697',
'DEMO6698',
'DEMO6699',
'DEMO6715',
'DEMO6726',
'DEMO6747',
'0^779.2^0',
'DEMO5708',
'DEMO5709',
'DEMO5756',
'DEMO5758',
'DEMO5728',
'DEMO5729',
'DEMO5730',
'DEMO5731',
'DEMO5732',
'DEMO5733',
'DEMO5734',
'DEMO5775',
'DEMO5780',
'DEMO5787',
'DEMO6010',
'DEMO2050',
'DEMO2051',
'DEMO2054',
'DEMO5999',
'DEMO2058',
'DEMO5801',
'DEMO6021',
'DEMO6040',
'DEMO5805',
'DEMO6007',
'DEMO6024',
'DEMO5815',
'DEMO5816',
'DEMO5817',
'DEMO5818',
'DEMO5823',
'DEMO5820',
'DEMO5821',
'DEMO5827',
'DEMO5824',
'DEMO5825',
'DEMO5844',
'DEMO5845',
'DEMO5846',
'DEMO5847',
'DEMO5848',
'DEMO5849',
'DEMO6022',
'DEMO6006',
'DEMO5863',
'DEMO5864',
'DEMO6019',
'DEMO6023',
'DEMO6039',
'DEMO5893',
'DEMO5894',
'DEMO5895',
'DEMO6005',
'DEMO6012',
'DEMO5899',
'DEMO5900',
'DEMO5993',
'DEMO5903',
'DEMO5992',
'DEMO5922',
'DEMO5923',
'DEMO5924',
'DEMO5915',
'DEMO5916',
'DEMO5929',
'DEMO5930',
'DEMO5931',
'DEMO5952',
'DEMO5970',
'DEMO5971',
'DEMO5972',
'DEMO5997',
'DEMO5976',
'DEMO5977',
'DEMO5978',
'DEMO6038',
'DEMO5982',
'DEMO5983',
'DEMO5984',
'DEMO5985',
'DEMO5986',
'DEMO5987',
'DEMO5988',
'DEMO5989',
'DEMO5990',
'DEMO6132',
'DEMO6141',
'DEMO6146',
'DEMO6226',
'DEMO6227',
'DEMO6228',
'DEMO6229',
'DEMO6230',
'DEMO6231',
'DEMO6159',
'DEMO6167',
'DEMO6168',
'DEMO6169',
'DEMO6170',
'DEMO6171',
'DEMO6172',
'DEMO6173',
'DEMO6175',
'DEMO6180',
'DEMO6181',
'DEMO6182',
'DEMO6183',
'DEMO6164',
'DEMO6165',
'DEMO6188',
'DEMO6189',
'DEMO6190',
'DEMO6191',
'DEMO6197',
'DEMO6195',
'DEMO6200',
'DEMO6201',
'DEMO6185',
'DEMO6186',
'DEMO6192',
'DEMO6234',
'DEMO6153',
'DEMO6154',
'DEMO6155',
'DEMO6235',
'DEMO6264',
'DEMO6265',
'DEMO6268',
'DEMO6269',
'DEMO6273',
'DEMO6274',
'DEMO6275',
'DEMO6286',
'DEMO6289',
'DEMO6290',
'DEMO6291',
'DEMO6052',
'DEMO6067',
'DEMO6068',
'NIP',
'DEMO6063',
'DEMO6064',
'DEMO6065',
'DEMO6072',
'DEMO6073',
'DEMO6086',
'VACTERL',
'DEMO6081',
'DEMO6082',
'DEMO6079',
'DEMO6080',
'DEMO2118',
'DEMO6241',
'0^11625',
'0^11621',
'0^11623',
'0^11624',
'0^11626',
'0^11627',
'0^11630',
'DEMO3827',
'DEMO2105',
'DEMO9777',
'DEMO2123',
'DEMO2124',
'0^11629',
'DEMO11426c',
'DEMO11426d',
'DEMO7674',
'DEMO9130',
'DEMO9131',
'DEMO9132',
'DEMO9134',
'DEMO9135',
'DEMO9136',
'DEMO9137',
'DEMO9138',
'DEMO9149',
'DEMO9151',
'DEMO9152',
'DEMO9153',
'DEMO9154',
'DEMO9155',
'DEMO9156',
'DEMO9158',
'DEMO9159',
'DEMO9160',
'DEMO9161',
'DEMO9162',
'DEMO9163',
'DEMO9164',
'DEMO9165',
'DEMO9166',
'DEMO9167',
'DEMO1293',
'DEMO1321',
'DEMO1322',
'DEMO2139',
'DEMO2786',
'DEMO2807',
'DEMO2808',
'DEMO2809',
'DEMO2803',
'DEMO2816',
'DEMO2817',
'DEMO2818',
'DEMO2813',
'DEMO2145',
'DEMO2146',
'DEMO2158',
'DEMO2148',
'DEMO2150',
'DEMO2151',
'DEMO2152',
'DEMO2156',
'DEMO2157',
'DEMO2164',
'DEMO2165',
'DEMO2166',
'DEMO2169',
'DEMO2170',
'DEMO2171',
'DEMO2172',
'DEMO2173',
'DEMO2174',
'DEMO2175',
'DEMO2200',
'DEMO2201',
'DEMO2202',
'DEMO2207',
'DEMO2208',
'DEMO2209',
'DEMO2186',
'HBPL',
'DEMO2215',
'DEMO2216',
'DEMO2217',
'DEMO2218',
'DEMO2229',
'DEMO2231',
'DEMO2232',
'DEMO2233',
'DEMO2234',
'DEMO2221',
'DEMO2222',
'DEMO2223',
'DEMO2224',
'DEMO2225',
'DEMO2226',
'DEMO2227',
'DEMO2236',
'DEMO2237',
'DEMO2238',
'DEMO2239',
'DEMO2241',
'DEMO2242',
'DEMO2243',
'DEMO2211',
'DEMO3164',
'DEMO3170',
'DEMO3173',
'DEMO3082',
'DEMO2793',
'DEMO2795',
'DEMO2789',
'DEMO2844',
'DEMO3083',
'DEMO2804',
'DEMO2805',
'DEMO2806',
'DEMO2822',
'DEMO2312',
'DEMO2314',
'DEMO2315',
'DEMO6826',
'DEMO7106',
'DEMO7717',
'DEMO7727',
'DEMO7718',
'DEMO7719',
'DEMO7720',
'DEMO7721',
'DEMO7722',
'DEMO7723',
'DEMO7724',
'DEMO6828',
'DEMO2880',
'DEMO2881',
'DEMO2882',
'DEMO2296',
'DEMO2289',
'DEMO2290',
'DEMO2291',
'DEMO2292',
'DEMO2293',
'DEMO2298',
'DEMO2299',
'DEMO2300',
'DEMO2301',
'DEMO2302',
'DEMO2303',
'DEMO2304',
'DEMO2308',
'DEMO7726',
'DEMO6824',
'DEMO6825',
'DEMO2890',
'DEMO2892',
'DEMO2893',
'DEMO2896',
'DEMO2897',
'DEMO2781',
'DEMO2784',
'DEMO3118',
'DEMO3119',
'DEMO2709',
'DEMO2836',
'DEMO2873',
'DEMO2875',
'DEMO2963',
'DEMO2832',
'DEMO2272',
'DEMO7725',
'DEMO2627',
'DEMO2690',
'DEMO2691',
'DEMO2693',
'DEMO2760',
'DEMO2761',
'DEMO2763',
'DEMO2764',
'DEMO2772',
'DEMO2286',
'DEMO2287',
'DEMO3180',
'DEMO3183',
'DEMO3200',
'DEMO10286',
'DEMO10287',
'DEMO2901',
'DEMO2907',
'DEMO2903',
'DEMO2904',
'DEMO2905',
'DEMO2921',
'DEMO2922',
'DEMO2914',
'DEMO2925',
'DEMO2926',
'DEMO2927',
'DEMO3116',
'DEMO3100',
'DEMO3101',
'DEMO3103',
'DEMO3022',
'DEMO2838',
'DEMO2839',
'DEMO2841',
'DEMO2352',
'DEMO2357',
'DEMO2358',
'DEMO2570',
'DEMO2571',
'DEMO2572',
'DEMO2573',
'DEMO2575',
'DEMO2574',
'DEMO2692',
'DEMO2715',
'DEMO2717',
'DEMO2718',
'DEMO2931',
'DEMO2720',
'DEMO2721',
'DEMO2722',
'DEMO3121',
'DEMO3122',
'DEMO3123',
'DEMO3124',
'DEMO3128',
'DEMO3129',
'DEMO2856A',
'DEMO2857',
'DEMO2857A',
'DEMO2442',
'DEMO2647',
'DEMO2645',
'DEMO2400',
'DEMO2405',
'DEMO2457',
'DEMO2458',
'DEMO2454',
'DEMO2641',
'DEMO2702',
'DEMO2576',
'DEMO2577',
'DEMO2579',
'DEMO2701',
'DEMO2877',
'DEMO2855A',
'DEMO2855B',
'DEMO3032',
'DEMO3033',
'DEMO3034',
'DEMO3035',
'DEMO3038',
'DEMO3040',
'DEMO3036',
'DEMO3037',
'DEMO3031',
'DEMO3041',
'DEMO3042',
'DEMO3051',
'DEMO3060',
'DEMO4585',
'DEMO4586',
'DEMO2654',
'DEMO2452',
'DEMO2653',
'DEMO2710',
'DEMO2582',
'DEMO2583',
'DEMO2584',
'DEMO2585',
'DEMO2586',
'DEMO2587',
'DEMO2588',
'DEMO2589',
'DEMO2852A',
'DEMO2853A',
'DEMO2854A',
'DEMO3225',
'DEMO3107',
'DEMO2591',
'DEMO2592',
'DEMO2593',
'DEMO2594',
'DEMO2937',
'DEMO3137',
'DEMO3138',
'DEMO2504',
'DEMO2663',
'DEMO2706',
'DEMO2665',
'DEMO2666',
'DEMO2667',
'DEMO2668',
'DEMO2943',
'DEMO2948',
'DEMO2751',
'DEMO2868A',
'DEMO2868B',
'DEMO2867A',
'DEMO2870A',
'DEMO2871',
'DEMO2871A',
'DEMO2961',
'DEMO2869A',
'DEMO3062',
'DEMO3070',
'DEMO3079',
'DEMO2863',
'DEMO2669',
'DEMO2676',
'DEMO2675',
'DEMO2703',
'DEMO2671',
'DEMO2672',
'DEMO2707',
'DEMO2673',
'DEMO2613',
'DEMO2674',
'DEMO2677',
'DEMO2971',
'DEMO2994',
'DEMO2995',
'DEMO2865A',
'DEMO2866A',
'DEMO2541',
'0^11825',
'0^11826',
'0^11827',
'0^11828',
'0^11861',
'0^11865',
'0^11862',
'0^11866',
'0^11863',
'0^11867',
'0^11864',
'0^11868',
'0^11894',
'0^11896',
'0^11895',
'0^11786',
'0^11787',
'0^11788',
'0^11947',
'0^11948',
'DEMO3243',
'DEMO3240',
'DEMO3241',
'DEMO3246',
'DEMO3248',
'0^995.27^1',
'DEMO3263',
'DEMO3264',
'DEMO3265',
'DEMO3300',
'DEMO3273',
'DEMO3274',
'DEMO3276',
'DEMO3259',
'DEMO3260',
'DEMO3287',
'DEMO3302',
'DEMO3303',
'DEMO3304',
'DEMO3298',
'DEMO3329',
'DEMO3219',
'DEMO3382',
'DEMO3363',
'DEMO3368',
'DEMO3369',
'DEMO3371',
'DEMO3376',
'DEMO3378',
'DEMO3380',
'DEMO2980',
'981^E001.1^1',
'DEMO9286',
'DEMO9287',
'DEMO9305',
'DEMO9289',
'DEMO9290',
'DEMO9291',
'DEMO9292',
'DEMO9294',
'DEMO9293',
'DEMO9551',
'DEMO1478',
'DEMO4870',
'DEMO9296',
'DEMO1188',
'DEMO9544',
'DEMO9316',
'DEMO9318',
'DEMO9319',
'DEMO9329',
'DEMO9334',
'DEMO9344',
'DEMO9347',
'DEMO9348',
'DEMO9349',
'DEMO9350',
'DEMO4885',
'DEMO516',
'DEMO9346',
'DEMO9351',
'DEMO9352',
'DEMO9357',
'DEMO9358',
'DEMO9366',
'DEMO9360',
'DEMO9361',
'0^12309',
'0^V82.79^0',
'DEMO4886',
'DEMO4887',
'DEMO9345',
'DEMO9364',
'DEMO9365',
'DEMO9367',
'DEMO9369',
'DEMO9370',
'DEMO9371',
'DEMO9417',
'DEMO9382',
'DEMO9383',
'DEMO9389',
'DEMO9413',
'DEMO9456',
'0^V26.31^0',
'DEMO877w4q',
'DEMO877w4r',
'DEMO877z4q',
'DEMO877z4r',
'DEMO9214',
'DEMO9217',
'DEMO9237',
'DEMO9265b',
'DEMO9265j',
'DEMO9278',
'DEMO1464',
'DEMO9260',
'DEMO9261',
'DEMO9268',
'DEMO9269',
'DEMO9270',
'DEMO9272',
'DEMO9273',
'DEMO9274',
'DEMO9275',
'DEMO9276',
'DEMO9534',
'DEMO9535',
'DEMO9536',
'DEMO9538',
'DEMO9539',
'DEMO9541',
'DEMO9543',
'DEMO9504',
'DEMO9493',
'DEMO9495',
'DEMO9513',
'DEMO9528',
'DEMO9530',
'DEMO9531',
'DEMO9533',
'DEMO9519',
'DEMO9520',
'DEMO4849A',
'DEMO9043',
'DEMO9053',
'DEMO4853',
'DEMO9063',
'DEMO9055',
'DEMO1428',
'DEMO1428A',
'DEMO1429',
'DEMO1429A',
'0^11951',
'0^11763A',
'0^12284',
'DEMO9119',
'0^12269',
'0^12270',
'0^12271',
'0^12272',
'0^12273',
'0^12274',
'0^12275',
'0^12276',
'0^12277',
'0^12278',
'0^12279',
'0^12280',
'0^12281',
'0^12282',
'0^12283',
'0^12286',
'0^12287',
'0^12290',
'0^12292',
'0^12293',
'DEMO9110',
'DEMO9079',
'DEMO1452',
'DEMO9117',
'DEMO9115',
'DEMO9128')

-- Remove orphans
DELETE a 
FROM c_Common_Assessment a
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition d
	WHERE d.assessment_id = a.assessment_id)

DELETE a 
FROM [u_assessment_treat_definition] a
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition d
	WHERE d.assessment_id = a.assessment_id)

DELETE a 
FROM [u_top_20] a
WHERE top_20_code like '%assess%' 
AND NOT EXISTS (SELECT 1 FROM c_Assessment_Definition d
	WHERE d.assessment_id = a.item_id)

-- UPDATE

update c_Assessment_Definition SET last_updated=getdate(), description ='(Induced) termination of pregnancy with other complications' where assessment_id = 'DEMO443x8b'
update c_Assessment_Definition SET last_updated=getdate(), description ='(Induced) termination of pregnancy with unspecified complications' where assessment_id = 'DEMO443x9b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal findings on diagnostic imaging of other specified body structures' where assessment_id = '0^793.99^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal glucose complicating pregnancy' where assessment_id = 'DEMO10820'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal glucose complicating the puerperium' where assessment_id = 'DEMO10819'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal result of other cardiovascular function study' where assessment_id = 'DEMO2136'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormalities of size and form of teeth' where assessment_id = 'DEMO7572'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormality in fetal heart rate and rhythm complicating labor and delivery' where assessment_id = 'DEMO1016'
update c_Assessment_Definition SET last_updated=getdate(), description ='ABO isoimmunization of newborn' where assessment_id = 'DEMO6712'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion of unspecified finger, initial encounter' where assessment_id = 'DEMO3052'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion of unspecified hand, initial encounter' where assessment_id = 'DEMO3043'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion of unspecified part of neck, initial encounter' where assessment_id = 'DEMO2997'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion of unspecified upper arm, initial encounter' where assessment_id = 'DEMO3014'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion of unspecified wrist, initial encounter' where assessment_id = 'DEMO3023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion, unspecified ankle, initial encounter' where assessment_id = 'DEMO200'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abrasion, unspecified foot, initial encounter' where assessment_id = 'DEMO3071'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of breast associated with pregnancy, third trimester' where assessment_id = 'DEMO11282'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of breast associated with the puerperium' where assessment_id = 'DEMO11283'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of epididymis or testis' where assessment_id = 'DEMO7084'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of the breast and nipple' where assessment_id = 'ASSESSMENT34'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of the breast and nipple' where assessment_id = 'ASSESSMENT34'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence epileptic syndrome, intractable, without status epilepticus' where assessment_id = 'DEMO7303'
update c_Assessment_Definition SET last_updated=getdate(), description ='Achilles tendinitis, unspecified leg' where assessment_id = 'DEMO3766'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acquired absence of other specified parts of digestive tract' where assessment_id = 'DEMO6239'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acquired coagulation factor deficiency' where assessment_id = 'DEMO7494'
update c_Assessment_Definition SET last_updated=getdate(), description ='Activity, running' where assessment_id = '981^E001.1^0'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Acute and subacute allergic otitis media (mucoid) (sanguinous) (serous), unspecified ear' where assessment_id = 'DEMO10371'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute hepatitis E' where assessment_id = 'DEMO4245'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute kidney failure with acute cortical necrosis' where assessment_id = 'DEMO6950'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute kidney failure with medullary necrosis' where assessment_id = 'DEMO6951'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute lymphangitis of neck' where assessment_id = 'DEMO5052'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute lymphangitis of trunk, unspecified' where assessment_id = 'DEMO5054'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute lymphangitis of unspecified part of limb' where assessment_id = 'DEMO5056'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute lymphangitis of unspecified toe' where assessment_id = 'DEMO5046'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute lymphangitis, unspecified' where assessment_id = 'DEMO10402'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute obstructive laryngitis [croup]' where assessment_id = 'DEMO5192'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute parametritis and pelvic cellulitis' where assessment_id = 'DEMO754'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute pyelonephritis' where assessment_id = 'PYE'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute salpingitis and oophoritis' where assessment_id = 'ASALP'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute stress reaction' where assessment_id = 'DEMO9778'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transverse myelitis in demyelinating disease of central nervous system' where assessment_id = '0^341.22^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute upper respiratory infection, unspecified' where assessment_id = 'DEMO4897'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions and ankylosis of temporomandibular joint, unspecified side' where assessment_id = 'DEMO7637'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesive capsulitis of unspecified shoulder' where assessment_id = 'DEMO11348'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesive middle ear disease, unspecified ear' where assessment_id = 'DEMO6864'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adjustment disorder with depressed mood' where assessment_id = 'DEMO9782'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Adverse effect of other drugs, medicaments and biological substances, initial encounter' where assessment_id = '0^995.27^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Agalactia' where assessment_id = 'DEMO1115'
update c_Assessment_Definition SET last_updated=getdate(), description ='Age-related osteoporosis without current pathological fracture' where assessment_id = 'DEMO3916'
update c_Assessment_Definition SET last_updated=getdate(), description ='Air embolism in pregnancy, unspecified trimester' where assessment_id = 'DEMO1094'
update c_Assessment_Definition SET last_updated=getdate(), description ='Air embolism in the puerperium' where assessment_id = 'DEMO11239'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alcoholic gastritis without bleeding' where assessment_id = 'GAS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergic rhinitis, unspecified' where assessment_id = 'DEMO10141'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to eggs' where assessment_id = '00016x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to eggs' where assessment_id = 'DEMO10210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to milk products' where assessment_id = 'ALLERGY_COWMILK'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to milk products' where assessment_id = 'DEMO10209'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to peanuts' where assessment_id = 'ALLERGY_PEANUTS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to peanuts' where assessment_id = 'DEMO10208'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to seafood' where assessment_id = 'ALLERGY_SHELLFISH'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alternating esotropia with other noncomitancies' where assessment_id = 'DEMO6555'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alternating exotropia with other noncomitancies' where assessment_id = 'DEMO6565'
update c_Assessment_Definition SET last_updated=getdate(), description ='Amniotic fluid embolism in the puerperium' where assessment_id = 'DEMO11243'
update c_Assessment_Definition SET last_updated=getdate(), description ='Amyotrophic lateral sclerosis' where assessment_id = 'DEMO7243'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anaphylactic reaction due to fruits and vegetables, initial encounter' where assessment_id = 'DEMO10328'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anaphylactic reaction due to other fish, initial encounter' where assessment_id = 'DEMO10330'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anaphylactic reaction due to peanuts, initial encounter' where assessment_id = 'DEMO10326'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anaphylactic reaction due to tree nuts and seeds, initial encounter' where assessment_id = 'DEMO10329'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ancylostomiasis' where assessment_id = 'DEMO4525'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia complicating the puerperium' where assessment_id = 'DEMO10795'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia due to other disorders of glutathione metabolism' where assessment_id = 'ANEMIAG6'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm of artery of lower extremity' where assessment_id = 'DEMO1878'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm of heart' where assessment_id = 'DEMO1399'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm of other specified arteries' where assessment_id = 'DEMO1890'
update c_Assessment_Definition SET last_updated=getdate(), description ='Angina pectoris, unspecified' where assessment_id = '00012241x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ankylosis of ear ossicles, unspecified ear' where assessment_id = 'DEMO6868'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ankylosis, unspecified joint' where assessment_id = 'DEMO3659'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Anterior dislocation of proximal end of tibia, unspecified knee, initial encounter' where assessment_id = 'DEMO2598'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anterior dislocation of unspecified humerus, initial encounter' where assessment_id = 'DEMO2544'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anterior dislocation of unspecified ulnohumeral joint, initial encounter' where assessment_id = 'DEMO2550'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anuria and oliguria' where assessment_id = 'ASSESSMENT37'
update c_Assessment_Definition SET last_updated=getdate(), description ='Arthrogryposis multiplex congenita' where assessment_id = 'DEMO6152'
update c_Assessment_Definition SET last_updated=getdate(), description ='Articular disc disorder of temporomandibular joint, unspecified side' where assessment_id = 'DEMO7640'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atherosclerosis of coronary artery bypass graft(s) without angina pectoris' where assessment_id = 'DEMO1628'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atherosclerotic heart disease of native coronary artery without angina pectoris' where assessment_id = 'DEMO10422'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrioventricular block, second degree' where assessment_id = 'DEMO1766'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrioventricular septal defect' where assessment_id = 'DEMO2016'
update c_Assessment_Definition SET last_updated=getdate(), description ='Attempted application of vacuum extractor and forceps' where assessment_id = 'DEMO1028'
update c_Assessment_Definition SET last_updated=getdate(), description ='Attention-deficit hyperactivity disorder, unspecified type' where assessment_id = 'ADD'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aural vertigo, unspecified ear' where assessment_id = 'DEMO6887'
update c_Assessment_Definition SET last_updated=getdate(), description ='Autoimmune polyglandular failure' where assessment_id = 'DEMO4706'
update c_Assessment_Definition SET last_updated=getdate(), description ='Azoospermia due to other extratesticular causes' where assessment_id = 'DEMO7095'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bariatric surgery status complicating the puerperium' where assessment_id = '0^649.22^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Behcet''s disease' where assessment_id = 'DEMO3664'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of bones of skull and face' where assessment_id = 'DEMO3525'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of connective and other soft tissue, unspecified' where assessment_id = 'DEMO10429'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of hypopharynx' where assessment_id = 'DEMO8490'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of other specified male genital organs' where assessment_id = 'DEMO8759'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of soft tissue of peritoneum' where assessment_id = 'DEMO8521'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of unspecified bronchus and lung' where assessment_id = 'DEMO8540'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of unspecified lacrimal gland and duct' where assessment_id = 'DEMO8770'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of unspecified part of unspecified eye' where assessment_id = 'DEMO401'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bifascicular block' where assessment_id = 'DEMO1772a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bipolar II disorder' where assessment_id = 'DEMO9635'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness left eye category 3, normal vision right eye' where assessment_id = 'DEMO5270'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness left eye category 4, normal vision right eye' where assessment_id = 'DEMO5267'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness left eye category 5, normal vision right eye' where assessment_id = 'DEMO5262'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness right eye category 3, blindness left eye category 3' where assessment_id = 'DEMO5258'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness, one eye, low vision other eye, unspecified eyes' where assessment_id = 'DEMO5227'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blindness, one eye, unspecified eye' where assessment_id = 'DEMO5252'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal) of unspecified finger, initial encounter' where assessment_id = 'DEMO3053'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal) of unspecified hand, initial encounter' where assessment_id = 'DEMO3044'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal) of unspecified part of neck, initial encounter' where assessment_id = 'DEMO2998'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal) of unspecified upper arm, initial encounter' where assessment_id = 'DEMO3015'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal) of unspecified wrist, initial encounter' where assessment_id = 'DEMO3024'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal), unspecified ankle, initial encounter' where assessment_id = 'DEMO3063'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blister (nonthermal), unspecified foot, initial encounter' where assessment_id = 'DEMO3072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Borderline personality disorder' where assessment_id = 'DEMO9688'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bouchard''s nodes (with arthropathy)' where assessment_id = 'DEMO7998'
update c_Assessment_Definition SET last_updated=getdate(), description ='Boutonniere deformity of unspecified finger(s)' where assessment_id = 'DEMO3960'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bradycardia, unspecified' where assessment_id = '000155xx'
update c_Assessment_Definition SET last_updated=getdate(), description ='Burn of left eye and adnexa, part unspecified, initial encounter' where assessment_id = '0^11785'
update c_Assessment_Definition SET last_updated=getdate(), description ='Burn of unspecified body region, unspecified degree' where assessment_id = 'DEMO10406'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bursitis of unspecified shoulder' where assessment_id = 'BURSSHO'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bursopathy, unspecified' where assessment_id = 'DEMO3798'
update c_Assessment_Definition SET last_updated=getdate(), description ='Caisson disease [decompression sickness], initial encounter' where assessment_id = 'DECOM'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calcific tendinitis of unspecified shoulder' where assessment_id = 'DEMO10088'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calcium deposit in bursa, unspecified site' where assessment_id = 'DEMO3794'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus in bladder' where assessment_id = 'DEMO7003'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of bile duct without cholangitis or cholecystitis without obstruction' where assessment_id = 'DEMO8039'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of gallbladder and bile duct without cholecystitis without obstruction' where assessment_id = 'DEMO8040'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of gallbladder with acute cholecystitis without obstruction' where assessment_id = 'DEMO8036'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of gallbladder with other cholecystitis without obstruction' where assessment_id = 'DEMO8035'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of kidney' where assessment_id = 'DEMO253'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of buttock' where assessment_id = 'DEMO5035'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of face' where assessment_id = 'CARB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of limb, unspecified' where assessment_id = 'DEMO5029'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of neck' where assessment_id = 'DEMO5022'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of trunk, unspecified' where assessment_id = 'DEMO5026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of unspecified foot' where assessment_id = 'DEMO5041'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of unspecified hand' where assessment_id = 'DEMO5033'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle, unspecified' where assessment_id = 'DEMO10604'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of anus and anal canal' where assessment_id = 'DEMO8833'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of other parts of respiratory system' where assessment_id = 'DEMO8854'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of other specified sites' where assessment_id = 'DEMO8902'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cardiomyopathy in diseases classified elsewhere' where assessment_id = 'DEMO1760'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carrier of infections with a predominantly sexual mode of transmission' where assessment_id = 'DEMO9388'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carrier of other intestinal infectious diseases' where assessment_id = 'DEMO9380'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cataract in diseases classified elsewhere' where assessment_id = 'DEMO5546'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Cataract secondary to ocular disorders (degenerative) (inflammatory), unspecified eye' where assessment_id = 'DEMO5542'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of buttock' where assessment_id = 'DEMO5059'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of unspecified finger' where assessment_id = 'DEMO5045'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of unspecified toe' where assessment_id = 'DEMO5048'
update c_Assessment_Definition SET last_updated=getdate(), description ='Central hemorrhagic necrosis of liver' where assessment_id = 'DEMO7977'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cerebral venous thrombosis in the puerperium' where assessment_id = 'DEMO11221'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cerebrospinal fluid leak' where assessment_id = 'DEMO7348'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cervical disc disorder, unspecified, unspecified cervical region' where assessment_id = 'DEMO10069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chondromalacia patellae, unspecified knee' where assessment_id = 'DEMO11362'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chorioretinal disorders in diseases classified elsewhere' where assessment_id = 'DEMO4467'
update c_Assessment_Definition SET last_updated=getdate(), description ='Choroidal degeneration, unspecified, right eye' where assessment_id = 'DEMO5392'
update c_Assessment_Definition SET last_updated=getdate(), description ='Choroidal dystrophy (central areolar) (generalized) (peripapillary)' where assessment_id = 'DEMO5431'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic instability of knee, unspecified knee' where assessment_id = 'DEMO3641'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic ischemic heart disease, unspecified' where assessment_id = 'DEMO1401'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic mucoid otitis media, unspecified ear' where assessment_id = 'DEMO6787'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic obstructive pulmonary disease with (acute) exacerbation' where assessment_id = 'DEMO10617'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic obstructive pulmonary disease with acute lower respiratory infection' where assessment_id = '0^11661'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic rhinitis' where assessment_id = 'DEMO10470'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic salpingitis and oophoritis' where assessment_id = 'DEMO750'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic serous otitis media, unspecified ear' where assessment_id = 'DEMO6784'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cicatricial pemphigoid' where assessment_id = 'DEMO5099'
update c_Assessment_Definition SET last_updated=getdate(), description ='Circadian rhythm sleep disorder, irregular sleep wake type' where assessment_id = '0^11979'
update c_Assessment_Definition SET last_updated=getdate(), description ='Circadian rhythm sleep disorder, unspecified type' where assessment_id = '0^11985'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cleft lip, bilateral' where assessment_id = 'DEMO5822'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cleft lip, unilateral' where assessment_id = 'DEMO5819'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cleft palate, unspecified' where assessment_id = 'DEMO5814'
update c_Assessment_Definition SET last_updated=getdate(), description ='Clicking hip' where assessment_id = '0^11622'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coarctation of aorta' where assessment_id = 'DEMO2043'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complete loss of teeth, unspecified cause, unspecified class' where assessment_id = 'DEMO7650'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complete or unspecified spontaneous abortion with other complications' where assessment_id = 'DEMO443x8'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complete or unspecified spontaneous abortion without complication' where assessment_id = 'DEMO443x4'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Complete traumatic amputation of left lower leg, level unspecified, initial encounter' where assessment_id = 'DEMO2870'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complete traumatic amputation of nose, initial encounter' where assessment_id = 'DEMO2810'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Complete traumatic amputation of unspecified lower leg, level unspecified, sequela' where assessment_id = 'DEMO10501'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complication of anesthesia during labor and delivery, unspecified' where assessment_id = 'DEMO1072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complication of anesthesia during the puerperium, unspecified' where assessment_id = 'DEMO11164'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complication of surgical and medical care, unspecified, sequela' where assessment_id = 'DEMO2979'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complication of the puerperium, unspecified' where assessment_id = 'DEMO1108'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Complication of vein following a procedure, not elsewhere classified, initial encounter' where assessment_id = 'DEMO10595'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complications of reattached (part of) unspecified lower extremity' where assessment_id = 'DEMO3379'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complications of reattached (part of) unspecified upper extremity' where assessment_id = 'DEMO3375'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conduct disorder, adolescent-onset type' where assessment_id = 'DEMO9799'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conduct disorder, childhood-onset type' where assessment_id = 'DEMO9798'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conductive hearing loss, unspecified' where assessment_id = 'DEMO6912'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of both lower leg and foot, unspecified lower limb' where assessment_id = 'DEMO6196'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of unspecified hand and finger' where assessment_id = 'DEMO6179'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of unspecified upper arm and forearm with hand present' where assessment_id = 'DEMO6174'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence, atresia and stenosis of large intestine, part unspecified' where assessment_id = 'DEMO5865'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence, atresia and stenosis of small intestine, part unspecified' where assessment_id = 'DEMO5862'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital cataract' where assessment_id = 'DEMO5727'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital complete absence of unspecified lower limb' where assessment_id = 'DEMO6187'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital complete absence of unspecified upper limb' where assessment_id = 'DEMO6166'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital corneal opacity' where assessment_id = 'DEMO5740'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital cutaneous mastocytosis' where assessment_id = 'DEMO10448'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital deformity of knee' where assessment_id = 'DEMO6135'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital deformity of sternocleidomastoid muscle' where assessment_id = 'DEMO6126'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hypoplasia and dysplasia of lung' where assessment_id = 'DEMO5803'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital insufficiency of aortic valve' where assessment_id = 'DEMO2028'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital lordosis, sacral and sacrococcygeal region' where assessment_id = 'DEMO6129'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of ear ossicles' where assessment_id = 'DEMO5765'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of face and neck, unspecified' where assessment_id = 'DEMO5786'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of female genitalia, unspecified' where assessment_id = 'DEMO5914'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of heart, unspecified' where assessment_id = 'CONHRT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of heart, unspecified' where assessment_id = 'DEMO2063'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of knee' where assessment_id = 'DEMO6220'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of nervous system, unspecified' where assessment_id = 'DEMO5715'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of skull and face bones, unspecified' where assessment_id = 'DEMO5551'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of upper alimentary tract, unspecified' where assessment_id = 'DEMO5858'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformations of adrenal gland' where assessment_id = 'DEMO6085'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformations of intestinal fixation' where assessment_id = 'DEMO5874'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformations of other endocrine glands' where assessment_id = 'DEMO10446'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformations of salivary glands and ducts' where assessment_id = 'DEMO5834'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformations of spleen' where assessment_id = 'DEMO6083'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital non-neoplastic nevus' where assessment_id = 'CAV'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital partial dislocation of unspecified hip, unilateral' where assessment_id = 'DEMO6131'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital pulmonary valve insufficiency' where assessment_id = 'DEMO2024'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital spondylolisthesis' where assessment_id = 'DEMO10094'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital talipes calcaneovalgus' where assessment_id = 'DEMO6144'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital talipes equinovarus' where assessment_id = 'DEMO6140'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital vertical talus deformity, unspecified foot' where assessment_id = 'DEMO6145'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congestion and hemorrhage of prostate' where assessment_id = 'DEMO7070'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conjoined twins' where assessment_id = 'DEMO6091'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Contact with and (suspected) exposure to infections with a predominantly sexual mode of transmission' where assessment_id = '000167x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contact with and (suspected) exposure to lead' where assessment_id = 'DEMO4849'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Continuing pregnancy after elective fetal reduction of one fetus or more, third trimester, not applicable or unspecified' where assessment_id = '0^12050'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Continuing pregnancy after spontaneous abortion of one fetus or more, first trimester, not applicable or unspecified' where assessment_id = 'DEMO10839'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Contour of existing restoration of tooth biologically incompatible with oral health' where assessment_id = '0^525.65^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contracture, unspecified joint' where assessment_id = '0^12215'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Contusion and laceration of cerebrum, unspecified, without loss of consciousness, initial encounter' where assessment_id = 'DEMO10291'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of eyeball and orbital tissues, unspecified eye, initial encounter' where assessment_id = 'DEMO3092'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Contusion of heart, unspecified with or without hemopericardium, initial encounter' where assessment_id = 'DEMO2780'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of lower back and pelvis, initial encounter' where assessment_id = 'CONBAC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of unspecified eyelid and periocular area, initial encounter' where assessment_id = 'DEMO3091'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of unspecified part of neck, initial encounter' where assessment_id = 'CONFAC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of unspecified shoulder, initial encounter' where assessment_id = 'CONARM'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contusion of unspecified thigh, initial encounter' where assessment_id = 'CONLEG'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corneal transplant status' where assessment_id = 'DEMO9077'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of first degree of chest wall, initial encounter' where assessment_id = '0^11822'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of first degree of unspecified elbow, initial encounter' where assessment_id = '0^11853'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Corrosion of first degree of unspecified multiple fingers (nail), including thumb, initial encounter' where assessment_id = '0^11890'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of first degree of unspecified upper arm, initial encounter' where assessment_id = '0^11857'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of second degree of chest wall, initial encounter' where assessment_id = '0^11823'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of second degree of unspecified elbow, initial encounter' where assessment_id = '0^11854'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Corrosion of second degree of unspecified multiple fingers (nail), including thumb, initial encounter' where assessment_id = '0^11891'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of second degree of unspecified upper arm, initial encounter' where assessment_id = '0^11858'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of third degree of chest wall, initial encounter' where assessment_id = '0^11824'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of third degree of unspecified elbow, initial encounter' where assessment_id = '0^11855'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Corrosion of third degree of unspecified multiple fingers (nail), including thumb, initial encounter' where assessment_id = '0^11892'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of third degree of unspecified upper arm, initial encounter' where assessment_id = '0^11859'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of unspecified body region, unspecified degree' where assessment_id = '0^11946'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of unspecified degree of chest wall, initial encounter' where assessment_id = '0^11821'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Corrosion of unspecified degree of head, face, and neck, unspecified site, sequela' where assessment_id = 'DEMO2982'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of unspecified degree of unspecified elbow, initial encounter' where assessment_id = '0^11852'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corrosion of unspecified degree of unspecified upper arm, initial encounter' where assessment_id = '0^11856'
update c_Assessment_Definition SET last_updated=getdate(), description ='Counseling, unspecified' where assessment_id = 'DEMO9525'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cracked nipple associated with lactation' where assessment_id = 'DEMO11304'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cracked nipple associated with pregnancy, third trimester' where assessment_id = 'DEMO11303'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crohn''s disease of large intestine without complications' where assessment_id = 'DEMO7823'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crohn''s disease of small intestine without complications' where assessment_id = 'DEMO7822'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crohn''s disease, unspecified, without complications' where assessment_id = 'DEMO113'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crossing vessel and stricture of ureter without hydronephrosis' where assessment_id = 'DEMO8960'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crushed chest, initial encounter' where assessment_id = 'DEMO3117'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crushing injury of abdomen, lower back, and pelvis, initial encounter' where assessment_id = 'DEMO3115'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crushing injury of shoulder and upper arm, unspecified arm, initial encounter' where assessment_id = 'DEMO3120'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crushing injury of unspecified hip with thigh, initial encounter' where assessment_id = 'DEMO3136'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cutaneous leishmaniasis' where assessment_id = 'DEMO4313'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cystic fibrosis with other intestinal manifestations' where assessment_id = 'DEMO10013'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cytomegaloviral disease, unspecified' where assessment_id = 'DEMO640'
update c_Assessment_Definition SET last_updated=getdate(), description ='Damage to pelvic organs following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x3'
update c_Assessment_Definition SET last_updated=getdate(), description ='Decreased fetal movements, unspecified trimester, not applicable or unspecified' where assessment_id = 'DEMO10945'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deep phlebothrombosis in pregnancy, third trimester' where assessment_id = 'DEMO11215'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deep phlebothrombosis in the puerperium' where assessment_id = 'DEMO1089'
update c_Assessment_Definition SET last_updated=getdate(), description ='Defects in glycoprotein degradation' where assessment_id = 'DEMO4592'
update c_Assessment_Definition SET last_updated=getdate(), description ='Defects in the complement system' where assessment_id = 'DEMO4811'
update c_Assessment_Definition SET last_updated=getdate(), description ='Degenerative disease of nervous system, unspecified' where assessment_id = 'DEMO7197'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delayed and secondary postpartum hemorrhage' where assessment_id = 'DEMO1066'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delayed delivery after artificial rupture of membranes' where assessment_id = 'DEMO10980'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delayed delivery of second twin, triplet, etc.' where assessment_id = 'DEMO1041'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delayed or excessive hemorrhage following (induced) termination of pregnancy' where assessment_id = 'DEMO443b'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Delayed or excessive hemorrhage following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delirium due to known physiological condition' where assessment_id = 'DEMO9568'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delusional disorders' where assessment_id = 'DEMO9642'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dental caries on smooth surface penetrating into pulp' where assessment_id = 'DEMO10558'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dental caries, unspecified' where assessment_id = 'DEMO10555'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dependence on other enabling machines and devices' where assessment_id = 'DEMO9127'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deposits [accretions] on teeth' where assessment_id = 'DEMO7612'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dietary counseling and surveillance' where assessment_id = 'DEMO9524'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Direct infection of unspecified joint in infectious and parasitic diseases classified elsewhere' where assessment_id = 'DEMO3544'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disease of appendix, unspecified' where assessment_id = 'DEMO7736'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disease of capillaries, unspecified' where assessment_id = 'DEMO10399'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diseases of lips' where assessment_id = 'DEMO7692'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diseases of the circulatory system complicating childbirth' where assessment_id = 'DEMO10806'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diseases of the circulatory system complicating pregnancy, third trimester' where assessment_id = 'DEMO10808'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diseases of the circulatory system complicating the puerperium' where assessment_id = 'DEMO10807'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diseases of the nervous system complicating the puerperium' where assessment_id = '0^649.42^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C0/C1 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7107'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C1/C2 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7108'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C2/C3 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7109'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C3/C4 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7110'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C4/C5 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7111'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C5/C6 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7112'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of C7/T1 cervical vertebrae, initial encounter' where assessment_id = 'DEMO7113'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of distal radioulnar joint of unspecified wrist, initial encounter' where assessment_id = 'DEMO2555'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of interphalangeal joint of unspecified toe(s), initial encounter' where assessment_id = 'DEMO2612'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Dislocation of metacarpal (bone), proximal end of unspecified hand, initial encounter' where assessment_id = 'DEMO2562'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Dislocation of metacarpophalangeal joint of unspecified finger, initial encounter' where assessment_id = 'DEMO2563'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Dislocation of metatarsophalangeal joint of unspecified toe(s), initial encounter' where assessment_id = 'DEMO2611'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of midcarpal joint of unspecified wrist, initial encounter' where assessment_id = 'DEMO2557'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Dislocation of other carpometacarpal joint of unspecified hand, initial encounter' where assessment_id = 'DEMO2558'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of other parts of lumbar spine and pelvis, initial encounter' where assessment_id = 'DEMO2629'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of radiocarpal joint of unspecified wrist, initial encounter' where assessment_id = 'DEMO2556'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of sacroiliac and sacrococcygeal joint, initial encounter' where assessment_id = 'DEMO2626'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of tarsal joint of unspecified foot, initial encounter' where assessment_id = 'DEMO2608'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of tarsometatarsal joint of unspecified foot, initial encounter' where assessment_id = 'DEMO2609'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of unspecified ankle joint, initial encounter' where assessment_id = 'DEMO2602'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of unspecified cervical vertebrae, initial encounter' where assessment_id = 'DEMO4936'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of unspecified lumbar vertebra, initial encounter' where assessment_id = 'DEMO7114'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dislocation of unspecified thoracic vertebra, initial encounter' where assessment_id = 'DEMO7115'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Disorder of amniotic fluid and membranes, unspecified, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10990'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of bilirubin metabolism, unspecified' where assessment_id = 'DEMO4807'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of brain, unspecified' where assessment_id = 'DEMO7194'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of branched-chain amino-acid metabolism, unspecified' where assessment_id = '0^11773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of external ear, unspecified, bilateral' where assessment_id = 'DEMO6778'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of penis, unspecified' where assessment_id = 'DEMO10516'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of prostate, unspecified' where assessment_id = 'DEMO10529'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder of urinary system, unspecified' where assessment_id = 'DEMO7059'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorders of histidine metabolism, unspecified' where assessment_id = 'DEMO4758'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorders of male genital organs in diseases classified elsewhere' where assessment_id = 'DEMO7065'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorders of unspecified acoustic nerve' where assessment_id = 'DEMO6925'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disruption of cesarean delivery wound' where assessment_id = 'DEMO1101'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disruption of perineal obstetric wound' where assessment_id = 'DEMO1102'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disseminated intravascular coagulation [defibrination syndrome]' where assessment_id = 'DEMO7488'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dissociative and conversion disorder, unspecified' where assessment_id = 'DEMO9657'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disturbance of temperature regulation of newborn, unspecified' where assessment_id = 'DEMO6746'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diverticulum of esophagus, acquired' where assessment_id = 'DEMO7760'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dorsalgia, unspecified' where assessment_id = 'DEMO10502'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dorsopathy, unspecified' where assessment_id = 'DEMO10289'
update c_Assessment_Definition SET last_updated=getdate(), description ='Drug use complicating the puerperium' where assessment_id = 'DEMO10799'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dry mouth, unspecified' where assessment_id = 'DEMO426'
update c_Assessment_Definition SET last_updated=getdate(), description ='Duodenitis without bleeding' where assessment_id = 'DUIT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dyslexia and alexia' where assessment_id = 'DEMO1234'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dysthymic disorder' where assessment_id = 'DEMO9684'
update c_Assessment_Definition SET last_updated=getdate(), description ='Early-onset cerebellar ataxia' where assessment_id = 'DEMO7232'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eclampsia complicating the puerperium' where assessment_id = 'DEMO10690'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eclampsia, unspecified as to time period' where assessment_id = 'DEMO902a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Edema, unspecified' where assessment_id = 'DEMO2107'
update c_Assessment_Definition SET last_updated=getdate(), description ='Effusion, unspecified joint' where assessment_id = 'JOINTEFFUS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO443x7b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Embolism following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x7'
update c_Assessment_Definition SET last_updated=getdate(), description ='Embryonic cyst of broad ligament' where assessment_id = 'DEMO5906'
update c_Assessment_Definition SET last_updated=getdate(), description ='Emphysema, unspecified' where assessment_id = 'EMPHY'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for adequacy testing for hemodialysis' where assessment_id = 'DEMO10231'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for care and examination of mother immediately after delivery' where assessment_id = 'DEMO10644'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for cesarean delivery without indication' where assessment_id = 'DEMO1082'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for change or removal of surgical wound dressing' where assessment_id = '0^V58.31^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for elective termination of pregnancy' where assessment_id = 'DEMO443x4b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for examination and observation for unspecified reason' where assessment_id = 'ABUSES'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for examination for adolescent development state' where assessment_id = 'DEMO9425'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for examination of eyes and vision with abnormal findings' where assessment_id = 'DEMO10637'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for general adult medical examination without abnormal findings' where assessment_id = 'DEMO1213'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for immunization' where assessment_id = '0^12304'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for mental health services for perpetrator of other abuse' where assessment_id = 'DEMO9512'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for mental health services for perpetrator of spousal or partner abuse' where assessment_id = 'DEMO9494'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for mental health services for victim of spousal or partner abuse' where assessment_id = 'DEMO9492'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for observation for other suspected diseases and conditions ruled out' where assessment_id = 'DEMO9288'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other administrative examinations' where assessment_id = 'DEMO9552'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other contraceptive management' where assessment_id = '000196x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other general examination' where assessment_id = 'DEMO9282'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other orthopedic aftercare' where assessment_id = 'DEMO4864'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other specified aftercare' where assessment_id = 'DEMO10455'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other specified special examinations' where assessment_id = 'DEMO1210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for other specified surgical aftercare' where assessment_id = 'DEMO9265'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Encounter for procedure for purposes other than remedying health state, unspecified' where assessment_id = 'DEMO10396'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for prophylactic measures, unspecified' where assessment_id = 'DEMO1482'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for prophylactic removal of breast' where assessment_id = 'DEMO1455'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for prophylactic removal of ovary(s)' where assessment_id = 'DEMO1456'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for reversal of previous sterilization' where assessment_id = 'DEMO9455'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for routine child health examination without abnormal findings' where assessment_id = '0^11772'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for cardiovascular disorders' where assessment_id = 'DEMO3891'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Encounter for screening for diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism' where assessment_id = 'DEMO517'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for eye and ear disorders' where assessment_id = 'DEMO9354'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Encounter for screening for infections with a predominantly sexual mode of transmission' where assessment_id = '0^12308'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for malignant neoplasm of other sites' where assessment_id = 'DEMO9343'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other bacterial diseases' where assessment_id = 'DEMO9317'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other disorder' where assessment_id = 'DEMO4884'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other infectious and parasitic diseases' where assessment_id = 'DEMO4876'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other infectious and parasitic diseases' where assessment_id = 'DEMO9320'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other infectious and parasitic diseases' where assessment_id = 'DEMO9321'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other infectious and parasitic diseases' where assessment_id = 'DEMO9322'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other metabolic disorders' where assessment_id = 'DEMO4883'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other musculoskeletal disorder' where assessment_id = 'DEMO518'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for other protozoal diseases and helminthiases' where assessment_id = 'DEMO4877'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for respiratory disorder NEC' where assessment_id = 'DEMO9359'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening for respiratory tuberculosis' where assessment_id = '0^11615'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening mammogram for malignant neoplasm of breast' where assessment_id = 'DEMO4888'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for screening, unspecified' where assessment_id = 'BLOODCHOL'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for surveillance of contraceptives, unspecified' where assessment_id = 'DEMO9449'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Encounter of female for testing for genetic disease carrier status for procreative management' where assessment_id = '0^12073'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endocarditis and heart valve disorders in diseases classified elsewhere' where assessment_id = 'DEMO4469'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endocarditis, valve unspecified' where assessment_id = '0001120x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endocrine, nutritional and metabolic diseases complicating childbirth' where assessment_id = 'DEMO10790'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Endocrine, nutritional and metabolic diseases complicating pregnancy, third trimester' where assessment_id = 'DEMO10792'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endocrine, nutritional and metabolic diseases complicating the puerperium' where assessment_id = 'DEMO10791'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enlarged lymph nodes, unspecified' where assessment_id = 'LYM'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enterostomy complication, unspecified' where assessment_id = 'DEMO7960'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enterostomy infection' where assessment_id = 'DEMO7962'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enterostomy malfunction' where assessment_id = 'DEMO7964'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enteroviral meningitis' where assessment_id = 'DEMO4167'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enthesopathy, unspecified' where assessment_id = 'DEMO10090'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eosinophilia' where assessment_id = 'DEMO7526'
update c_Assessment_Definition SET last_updated=getdate(), description ='Epididymo-orchitis' where assessment_id = 'EPI'
update c_Assessment_Definition SET last_updated=getdate(), description ='Esophageal web' where assessment_id = '0^11597'
update c_Assessment_Definition SET last_updated=getdate(), description ='Esophagitis, unspecified' where assessment_id = 'GER'
update c_Assessment_Definition SET last_updated=getdate(), description ='Essential (primary) hypertension' where assessment_id = 'DEMO1575'
update c_Assessment_Definition SET last_updated=getdate(), description ='Excessive and frequent menstruation with regular cycle' where assessment_id = 'DEMO856'
update c_Assessment_Definition SET last_updated=getdate(), description ='Excessive and redundant skin and subcutaneous tissue' where assessment_id = 'DEMO5117'
update c_Assessment_Definition SET last_updated=getdate(), description ='Excessive weight gain in pregnancy, third trimester' where assessment_id = 'DEMO10717'
update c_Assessment_Definition SET last_updated=getdate(), description ='Exposure to excessive natural cold, initial encounter' where assessment_id = 'DEMO9934'
update c_Assessment_Definition SET last_updated=getdate(), description ='Exposure to excessive natural heat, initial encounter' where assessment_id = 'DEMO9931'
update c_Assessment_Definition SET last_updated=getdate(), description ='Exposure to other specified smoke, fire and flames, initial encounter' where assessment_id = 'DEMO9928'
update c_Assessment_Definition SET last_updated=getdate(), description ='Extremely low birth weight newborn, 750-999 grams' where assessment_id = 'DEMO10219'
update c_Assessment_Definition SET last_updated=getdate(), description ='Extremely low birth weight newborn, less than 500 grams' where assessment_id = 'DEMO10218'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed instrumental induction of labor' where assessment_id = 'DEMO1009'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed medical induction of labor' where assessment_id = 'DEMO1010'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed trial of labor, unspecified' where assessment_id = 'DEMO1026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failure of sterile precautions during unspecified surgical and medical care' where assessment_id = 'DEMO9915'
update c_Assessment_Definition SET last_updated=getdate(), description ='False labor at or after 37 completed weeks of gestation' where assessment_id = 'DEMO10647'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Family history of diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism' where assessment_id = 'DEMO1122'
update c_Assessment_Definition SET last_updated=getdate(), description ='Family history of epilepsy and other diseases of the nervous system' where assessment_id = 'DEMO9052'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Family history of ischemic heart disease and other diseases of the circulatory system' where assessment_id = '0^12291'
update c_Assessment_Definition SET last_updated=getdate(), description ='Family history of malignant neoplasm of trachea, bronchus and lung' where assessment_id = 'DEMO9042'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Family history of other congenital malformations, deformations and chromosomal abnormalities' where assessment_id = 'DEMO1123'
update c_Assessment_Definition SET last_updated=getdate(), description ='Febrile neutrophilic dermatosis [Sweet]' where assessment_id = 'GRAN'
update c_Assessment_Definition SET last_updated=getdate(), description ='Female pelvic peritoneal adhesions (postinfective)' where assessment_id = 'DEMO685'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetomaternal placental transfusion syndrome, first trimester' where assessment_id = 'DEMO10950'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibromyalgia' where assessment_id = 'DEMO10109'
update c_Assessment_Definition SET last_updated=getdate(), description ='First degree perineal laceration during delivery' where assessment_id = 'DEMO1049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fistula of bile duct' where assessment_id = 'DEMO8063'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fistula of stomach and duodenum' where assessment_id = 'DEMO7816'
update c_Assessment_Definition SET last_updated=getdate(), description ='Flaccid hemiplegia affecting unspecified side' where assessment_id = '0^12141'
update c_Assessment_Definition SET last_updated=getdate(), description ='Flaccid neuropathic bladder, not elsewhere classified' where assessment_id = 'DEMO7023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Flail chest, initial encounter for open fracture' where assessment_id = 'DEMO2307'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal chorioretinal inflammation of posterior pole, unspecified eye' where assessment_id = 'DEMO5403'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal chorioretinal inflammation, juxtapapillary, unspecified eye' where assessment_id = 'DEMO5402'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal chorioretinal inflammation, macular or paramacular, unspecified eye' where assessment_id = 'DEMO5406'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal chorioretinal inflammation, peripheral, unspecified eye' where assessment_id = 'DEMO5404'
update c_Assessment_Definition SET last_updated=getdate(), description ='Follicular disorder, unspecified' where assessment_id = 'DEMO10649'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fourth degree perineal laceration during delivery' where assessment_id = 'DEMO1052'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Fracture of base of skull, unspecified side, initial encounter for closed fracture' where assessment_id = 'DEMO2159'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of base of skull, unspecified side, initial encounter for open fracture' where assessment_id = 'DEMO2168'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of coccyx, initial encounter for closed fracture' where assessment_id = 'DEMO2269'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of coccyx, initial encounter for open fracture' where assessment_id = 'DEMO2270'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Fracture of mandible of other specified site, initial encounter for closed fracture' where assessment_id = 'DEMO2177'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Fracture of mandible of other specified site, initial encounter for open fracture' where assessment_id = 'DEMO2195'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of neck, unspecified, initial encounter' where assessment_id = 'DEMO6821'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of one rib, unspecified side, initial encounter for closed fracture' where assessment_id = 'DEMO167'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of one rib, unspecified side, initial encounter for open fracture' where assessment_id = 'DEMO2294'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of other parts of neck, initial encounter' where assessment_id = 'DEMO2309'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of tooth (traumatic), initial encounter for open fracture' where assessment_id = 'TOOTHI'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of vault of skull, initial encounter for closed fracture' where assessment_id = 'DEMO2140'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fracture of vault of skull, initial encounter for open fracture' where assessment_id = 'DEMO2147'
update c_Assessment_Definition SET last_updated=getdate(), description ='Functional disorders of polymorphonuclear neutrophils' where assessment_id = 'DEMO7512'
update c_Assessment_Definition SET last_updated=getdate(), description ='Functional dyspepsia' where assessment_id = 'DEMO7809'
update c_Assessment_Definition SET last_updated=getdate(), description ='Galactorrhea' where assessment_id = 'DEMO11324'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ganglion, unspecified ankle and foot' where assessment_id = 'DEMO3781'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gastroduodenitis, unspecified, without bleeding' where assessment_id = 'DEMO7802'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gastroenteritis and colitis due to radiation' where assessment_id = 'DEMO7841'
update c_Assessment_Definition SET last_updated=getdate(), description ='Genetic anomalies of leukocytes' where assessment_id = 'DEMO7517'
update c_Assessment_Definition SET last_updated=getdate(), description ='Genital tract and pelvic infection following (induced) termination of pregnancy' where assessment_id = 'DEMO874b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Genital varices in pregnancy, third trimester' where assessment_id = 'DEMO11207'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Gestational [pregnancy-induced] hypertension without significant proteinuria, complicating the puerperium' where assessment_id = 'DEMO10684'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Gestational [pregnancy-induced] hypertension without significant proteinuria, unspecified trimester' where assessment_id = 'DEMO10683'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gestational alloimmune liver disease' where assessment_id = '0^775.89^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glaucoma secondary to drugs, unspecified eye, stage unspecified' where assessment_id = 'DEMO5497'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glaucoma secondary to eye inflammation, unspecified eye, stage unspecified' where assessment_id = 'DEMO5453'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glaucoma secondary to other eye disorders, unspecified eye, stage unspecified' where assessment_id = 'DEMO5511'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glomerular disorders in diseases classified elsewhere' where assessment_id = 'DEMO5165'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal cervicitis, unspecified' where assessment_id = 'DEMO601'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal cystitis and urethritis, unspecified' where assessment_id = 'DEMO4392'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal female pelvic inflammatory disease' where assessment_id = 'DEMO4396'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal heart infection' where assessment_id = 'DEMO4416'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal infection of lower genitourinary tract, unspecified' where assessment_id = 'DEMO598'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal prostatitis' where assessment_id = 'DEMO4393'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonorrhea complicating the puerperium' where assessment_id = 'DEMO10752'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gout, unspecified' where assessment_id = 'DEMO4785'
update c_Assessment_Definition SET last_updated=getdate(), description ='Headache' where assessment_id = '000198x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Heat exhaustion, unspecified, initial encounter' where assessment_id = 'DEMO3324'
update c_Assessment_Definition SET last_updated=getdate(), description ='Heatstroke and sunstroke, initial encounter' where assessment_id = 'DEMO513'
update c_Assessment_Definition SET last_updated=getdate(), description ='HELLP syndrome (HELLP), unspecified trimester' where assessment_id = 'DEMO901'
update c_Assessment_Definition SET last_updated=getdate(), description ='HELLP syndrome, complicating the puerperium' where assessment_id = 'DEMO10692'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemangioma of other sites' where assessment_id = 'DEMO8802'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemarthrosis, unspecified joint' where assessment_id = '0^12236'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hematoma of obstetric wound' where assessment_id = 'DEMO1103'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage in early pregnancy, unspecified' where assessment_id = 'DEMO889'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary deficiency of other clotting factors' where assessment_id = 'DEMO7480G'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary disturbances in tooth structure, not elsewhere classified' where assessment_id = 'DEMO7583'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary lymphedema' where assessment_id = 'DEMO6050'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary motor and sensory neuropathy' where assessment_id = 'DEMO7388'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral infection, unspecified' where assessment_id = 'DEMO10175'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral keratitis' where assessment_id = 'DEMO4201'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral vulvovaginitis' where assessment_id = 'DEMO4195'
update c_Assessment_Definition SET last_updated=getdate(), description ='Histoplasmosis duboisii' where assessment_id = 'DEMO4472'
update c_Assessment_Definition SET last_updated=getdate(), description ='Histrionic personality disorder' where assessment_id = 'DEMO9691'
update c_Assessment_Definition SET last_updated=getdate(), description ='Horizontal alveolar bone loss' where assessment_id = 'DEMO7613'
update c_Assessment_Definition SET last_updated=getdate(), description ='Human immunodeficiency virus [HIV] disease' where assessment_id = 'DEMO1505'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hydrops of gallbladder' where assessment_id = 'DEMO8044'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hyperemesis gravidarum with metabolic disturbance' where assessment_id = 'DEMO10698'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypersensitivity angiitis' where assessment_id = 'DEMO10459'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypersensitivity pneumonitis due to other organic dusts' where assessment_id = 'DEMO4988'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypersomnia, unspecified' where assessment_id = '0^11969'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive chronic kidney disease with stage 1 through stage 4 chronic kidney disease, or unspecified chronic kidney disease' where assessment_id = 'DEMO1619'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive chronic kidney disease with stage 5 chronic kidney disease or end stage renal disease' where assessment_id = 'DEMO1616'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive heart and chronic kidney disease with heart failure and stage 1 through stage 4 chronic kidney disease, or unspecified chronic kidney disease' where assessment_id = 'DEMO1596'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive heart and chronic kidney disease with heart failure and with stage 5 chronic kidney disease, or end stage renal disease' where assessment_id = 'DEMO10418'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive heart and chronic kidney disease without heart failure, with stage 1 through stage 4 chronic kidney disease, or unspecified chronic kidney disease' where assessment_id = 'DEMO1603'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hypertensive heart and chronic kidney disease without heart failure, with stage 5 chronic kidney disease, or end stage renal disease' where assessment_id = 'DEMO1598'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypertensive heart disease with heart failure' where assessment_id = 'DEMO10416'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypertensive heart disease without heart failure' where assessment_id = 'DEMO1579'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypertrophy of tongue papillae' where assessment_id = 'DEMO7707'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypopituitarism' where assessment_id = 'ASSESSMENT3'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypothyroidism due to medicaments and other exogenous substances' where assessment_id = 'DEMO4615'
update c_Assessment_Definition SET last_updated=getdate(), description ='Idiopathic aseptic necrosis of unspecified femur' where assessment_id = 'DEMO10577'
update c_Assessment_Definition SET last_updated=getdate(), description ='Idiopathic aseptic necrosis of unspecified femur' where assessment_id = 'DEMO10577'
update c_Assessment_Definition SET last_updated=getdate(), description ='Idiopathic aseptic necrosis of unspecified femur' where assessment_id = 'DEMO10577'
update c_Assessment_Definition SET last_updated=getdate(), description ='Iliac crest spur, unspecified hip' where assessment_id = 'DEMO8018'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ill-defined and unknown cause of mortality' where assessment_id = 'DEMO1318'
update c_Assessment_Definition SET last_updated=getdate(), description ='Impacted teeth' where assessment_id = 'DEMO7584'
update c_Assessment_Definition SET last_updated=getdate(), description ='Incomplete lesion of unspecified level of lumbar spinal cord, initial encounter' where assessment_id = 'DEMO6836'
update c_Assessment_Definition SET last_updated=getdate(), description ='Incomplete uterovaginal prolapse' where assessment_id = 'DEMO784'
update c_Assessment_Definition SET last_updated=getdate(), description ='Indeterminate sex, unspecified' where assessment_id = 'DEMO5927'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infantile and juvenile cortical, lamellar, or zonular cataract, unspecified eye' where assessment_id = 'DEMO5525'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infantile idiopathic scoliosis, site unspecified' where assessment_id = 'DEMO3979'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infantile papular acrodermatitis [Gianotti-Crosti]' where assessment_id = 'DEMO4218'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Infection and inflammatory reaction due to other cardiac and vascular devices, implants and grafts, initial encounter' where assessment_id = 'DEMO3362'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection of nipple associated with pregnancy, third trimester' where assessment_id = 'DEMO11278'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection of nipple associated with the puerperium' where assessment_id = 'DEMO11279'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infectious gastroenteritis and colitis, unspecified' where assessment_id = 'DEMO3885'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infective myositis, unspecified site' where assessment_id = 'DEMO3800'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inferior dislocation of unspecified humerus, initial encounter' where assessment_id = 'DEMO2546'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infestation, unspecified' where assessment_id = 'DEMO4555'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inflammatory conditions of jaws' where assessment_id = 'DEMO7661'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inflammatory disease of cervix uteri' where assessment_id = 'CERV'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inflammatory disease of uterus, unspecified' where assessment_id = 'DEMO765'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inflammatory disorder of unspecified male genital organ' where assessment_id = 'DEMO7126'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of acoustic nerve, unspecified side, initial encounter' where assessment_id = 'DEMO10154'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Injury of conjunctiva and corneal abrasion without foreign body, unspecified eye, initial encounter' where assessment_id = 'DEMO3081'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of lumbosacral plexus, initial encounter' where assessment_id = 'DEMO10285'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of optic nerve, unspecified eye, initial encounter' where assessment_id = 'DEMO3160'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of other cranial nerves, unspecified side, initial encounter' where assessment_id = 'DEMO3172'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of unspecified iliac artery, initial encounter' where assessment_id = 'DEMO2919'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of unspecified iliac vein, initial encounter' where assessment_id = 'DEMO2920'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of unspecified nerve at ankle and foot level, unspecified leg, sequela' where assessment_id = 'DEMO2970'
update c_Assessment_Definition SET last_updated=getdate(), description ='Injury of unspecified nerves of neck, initial encounter' where assessment_id = 'DEMO3206'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous) of unspecified finger, initial encounter' where assessment_id = 'DEMO3055'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous) of unspecified hand, initial encounter' where assessment_id = 'DEMO3046'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous) of unspecified upper arm, initial encounter' where assessment_id = 'DEMO3017'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous) of unspecified wrist, initial encounter' where assessment_id = 'DEMO3026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous), unspecified ankle, initial encounter' where assessment_id = 'DEMO3065'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite (nonvenomous), unspecified foot, initial encounter' where assessment_id = 'DEMO3074'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insect bite of unspecified part of neck, initial encounter' where assessment_id = 'DEMO3000'
update c_Assessment_Definition SET last_updated=getdate(), description ='Insomnia due to medical condition' where assessment_id = '0^11965'
update c_Assessment_Definition SET last_updated=getdate(), description ='Intestinal bypass and anastomosis status' where assessment_id = 'DEMO9114'
update c_Assessment_Definition SET last_updated=getdate(), description ='Joint derangement, unspecified' where assessment_id = '0^12227'
update c_Assessment_Definition SET last_updated=getdate(), description ='Kaposi''s sarcoma of other sites' where assessment_id = 'DEMO656'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labor and delivery complicated by abnormality of fetal acid-base balance' where assessment_id = 'DEMO10956'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by cord around neck, with compression, not applicable or unspecified' where assessment_id = 'DEMO1043'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by cord complication, unspecified, not applicable or unspecified' where assessment_id = 'DEMO11084'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labor and delivery complicated by meconium in amniotic fluid' where assessment_id = 'DEMO1001'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by other cord complications, not applicable or unspecified' where assessment_id = 'DEMO1048'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by other cord entanglement, with compression, not applicable or unspecified' where assessment_id = 'DEMO11078'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by prolapse of cord, not applicable or unspecified' where assessment_id = 'DEMO1042'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labor and delivery complicated by short cord, not applicable or unspecified' where assessment_id = 'DEMO1045'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labor and delivery complicated by vasa previa, not applicable or unspecified' where assessment_id = 'DEMO1046'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Labor and delivery complicated by vascular lesion of cord, not applicable or unspecified' where assessment_id = 'DEMO1047'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labyrinthine dysfunction, unspecified ear' where assessment_id = 'DEMO6901'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labyrinthine fistula, unspecified ear' where assessment_id = 'DEMO6896'
update c_Assessment_Definition SET last_updated=getdate(), description ='Labyrinthitis, unspecified ear' where assessment_id = 'DEMO10150'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration of unspecified muscle and tendon at ankle and foot level, unspecified foot, initial encounter' where assessment_id = 'AVULSB'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration of unspecified muscle, fascia and tendon at shoulder and upper arm level, unspecified arm, initial encounter' where assessment_id = 'DEMO2837B'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration of unspecified muscle, fascia and tendon at wrist and hand level, unspecified hand, initial encounter' where assessment_id = 'DEMO2848B'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration of unspecified muscles, fascia and tendons at forearm level, unspecified arm, initial encounter' where assessment_id = 'DEMO2846B'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration of unspecified muscles, fascia and tendons at thigh level, unspecified thigh, initial encounter' where assessment_id = 'DEMO2859B'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration with foreign body of lower back and pelvis without penetration into retroperitoneum, initial encounter' where assessment_id = 'DEMO2827A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of oral cavity, initial encounter' where assessment_id = 'DEMO2814A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of other part of head, initial encounter' where assessment_id = 'DEMO209A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of unspecified ear, initial encounter' where assessment_id = 'DEMO2801A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of unspecified shoulder, initial encounter' where assessment_id = 'DEMO2837A'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Laceration with foreign body of unspecified toe(s) without damage to nail, initial encounter' where assessment_id = 'AVULSA'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of unspecified upper arm, initial encounter' where assessment_id = 'DEMO2840A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body of vagina and vulva, initial encounter' where assessment_id = 'DEMO2831A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body, unspecified ankle, initial encounter' where assessment_id = 'DEMO2861A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration with foreign body, unspecified thigh, initial encounter' where assessment_id = 'DEMO2859A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Laceration without foreign body of oral cavity, initial encounter' where assessment_id = 'DEMO2815'
update c_Assessment_Definition SET last_updated=getdate(), description ='Late syphilitic neuropathy' where assessment_id = 'DEMO4375'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Lateral dislocation of proximal end of tibia, unspecified knee, initial encounter' where assessment_id = 'DEMO2601'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lateral dislocation of unspecified ulnohumeral joint, initial encounter' where assessment_id = 'DEMO2580'
update c_Assessment_Definition SET last_updated=getdate(), description ='Latex allergy status' where assessment_id = 'DEMO10215'
update c_Assessment_Definition SET last_updated=getdate(), description ='Latex allergy status' where assessment_id = 'DEMO1989'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukoplakia of oral mucosa, including tongue' where assessment_id = 'DEMO7694'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukoplakia of penis' where assessment_id = 'DEMO7100'
update c_Assessment_Definition SET last_updated=getdate(), description ='Liver disease, unspecified' where assessment_id = 'DEMO10436'
update c_Assessment_Definition SET last_updated=getdate(), description ='Liver disorders in diseases classified elsewhere' where assessment_id = 'DEMO7996'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Localization-related (focal) (partial) symptomatic epilepsy and epileptic syndromes with simple partial seizures, intractable, without status epilepticus' where assessment_id = 'DEMO7312'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Localization-related (focal) (partial) symptomatic epilepsy and epileptic syndromes with simple partial seizures, not intractable, without status epilepticus' where assessment_id = 'DEMO7313'
update c_Assessment_Definition SET last_updated=getdate(), description ='Localized swelling, mass and lump, unspecified' where assessment_id = '0^11633'
update c_Assessment_Definition SET last_updated=getdate(), description ='Long labor, unspecified' where assessment_id = 'DEMO1039'
update c_Assessment_Definition SET last_updated=getdate(), description ='Longitudinal reduction defect of unspecified femur' where assessment_id = 'DEMO6194'
update c_Assessment_Definition SET last_updated=getdate(), description ='Loose body in unspecified joint' where assessment_id = '0^12189'
update c_Assessment_Definition SET last_updated=getdate(), description ='Low lying placenta NOS or without hemorrhage, third trimester' where assessment_id = 'DEMO888q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Low lying placenta with hemorrhage, third trimester' where assessment_id = 'DEMO890q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Low vision right eye category 2, low vision left eye category 2' where assessment_id = 'DEMO5236'
update c_Assessment_Definition SET last_updated=getdate(), description ='Low vision, one eye, unspecified eye' where assessment_id = 'DEMO5228'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lymphedema, not elsewhere classified' where assessment_id = 'DEMO1963'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Macula scars of posterior pole (postinflammatory) (post-traumatic), unspecified eye' where assessment_id = 'DEMO5420'
update c_Assessment_Definition SET last_updated=getdate(), description ='Major depressive disorder, single episode, unspecified' where assessment_id = 'DEMO10119'
update c_Assessment_Definition SET last_updated=getdate(), description ='Male erectile dysfunction, unspecified' where assessment_id = 'DEMO645'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malformation of urachus' where assessment_id = 'DEMO5979'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of aortic body and other paraganglia' where assessment_id = 'DEMO8393'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of craniopharyngeal duct' where assessment_id = 'DEMO8389'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of extrahepatic bile duct' where assessment_id = 'DEMO8184'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of gum, unspecified' where assessment_id = 'DEMO8115'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of lower third of esophagus' where assessment_id = 'DEMO8151'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of major salivary gland, unspecified' where assessment_id = 'DEMO8354'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of meninges, unspecified' where assessment_id = 'DEMO8377'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of middle third of esophagus' where assessment_id = 'DEMO8150'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of overlapping sites of brain' where assessment_id = 'DEMO8349'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of overlapping sites of male genital organs' where assessment_id = 'DEMO8299'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of overlapping sites of oropharynx' where assessment_id = 'DEMO8133'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of overlapping sites of retroperitoneum and peritoneum' where assessment_id = 'DEMO8200'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of overlapping sites of tongue' where assessment_id = 'DEMO8106'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of pleura' where assessment_id = 'DEMO8238'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of thyroid gland' where assessment_id = 'DEMO8381'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of unspecified lacrimal gland and duct' where assessment_id = 'DEMO8323'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of upper lobe, unspecified bronchus or lung' where assessment_id = 'DEMO8231'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of upper third of esophagus' where assessment_id = 'DEMO8149'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malingerer [conscious simulation]' where assessment_id = 'DEMO10095'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mandibular hypoplasia' where assessment_id = 'DEMO7621'
update c_Assessment_Definition SET last_updated=getdate(), description ='Manic episode without psychotic symptoms, unspecified' where assessment_id = 'DEMO9627'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) central nervous system malformation in fetus, not applicable or unspecified' where assessment_id = 'DEMO10930'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) chromosomal abnormality in fetus, not applicable or unspecified' where assessment_id = 'DEMO10932'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) damage to fetus by drugs, not applicable or unspecified' where assessment_id = 'DEMO10940'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) damage to fetus by radiation, not applicable or unspecified' where assessment_id = 'DEMO10942'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) damage to fetus from alcohol, not applicable or unspecified' where assessment_id = 'DEMO10938'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) damage to fetus from viral disease in mother, not applicable or unspecified' where assessment_id = 'DEMO10936'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) fetal abnormality and damage, unspecified, not applicable or unspecified' where assessment_id = 'DEMO10948'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for (suspected) hereditary disease in fetus, not applicable or unspecified' where assessment_id = 'DEMO10934'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for abnormality of pelvic organ, unspecified, third trimester' where assessment_id = 'DEMO10926'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for abnormality of vulva and perineum, third trimester' where assessment_id = 'DEMO10921'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for benign tumor of corpus uteri, third trimester' where assessment_id = 'DEMO10894'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for breech presentation, not applicable or unspecified' where assessment_id = 'DEMO10848'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for cervical incompetence, third trimester' where assessment_id = 'DEMO10909'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion due to deformity of maternal pelvic bones' where assessment_id = 'DEMO10814'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for disproportion due to hydrocephalic fetus, not applicable or unspecified' where assessment_id = 'DEMO10881'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion due to other fetal deformities, other fetus' where assessment_id = 'DEMO10883'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for disproportion due to outlet contraction of pelvis, not applicable or unspecified' where assessment_id = 'DEMO10875'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for disproportion due to unusually large fetus, not applicable or unspecified' where assessment_id = 'DEMO10879'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for disproportion of mixed maternal and fetal origin, not applicable or unspecified' where assessment_id = 'DEMO10877'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion of other origin' where assessment_id = 'DEMO10885'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion, unspecified' where assessment_id = 'DEMO10887'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for excessive fetal growth, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10962'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for excessive fetal growth, unspecified trimester, not applicable or unspecified' where assessment_id = 'DEMO997'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for face, brow and chin presentation, not applicable or unspecified' where assessment_id = 'DEMO10856'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for fetal problem, unspecified, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10969'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for high head at term, not applicable or unspecified' where assessment_id = 'DEMO10858'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for intrauterine death, not applicable or unspecified' where assessment_id = 'DEMO10958'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for malpresentation of fetus, unspecified, not applicable or unspecified' where assessment_id = 'DEMO10860'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for other (suspected) fetal abnormality and damage, not applicable or unspecified' where assessment_id = 'DEMO10946'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for other abnormalities of cervix, third trimester' where assessment_id = 'DEMO10913'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for other abnormalities of gravid uterus, third trimester' where assessment_id = 'DEMO10878'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for other isoimmunization, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10954'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for other known or suspected poor fetal growth, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10960'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Maternal care for other known or suspected poor fetal growth, unspecified trimester, not applicable or unspecified' where assessment_id = 'DEMO996'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for retroversion of gravid uterus, third trimester' where assessment_id = 'DEMO10900'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for transverse and oblique lie, not applicable or unspecified' where assessment_id = 'DEMO10852'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for unspecified congenital malformation of uterus, third trimester' where assessment_id = 'DEMO10890'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for unspecified type scar from previous cesarean delivery' where assessment_id = 'DEMO10898'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for unstable lie, not applicable or unspecified' where assessment_id = 'DEMO10846'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal distress during labor and delivery' where assessment_id = 'DEMO1075'
update c_Assessment_Definition SET last_updated=getdate(), description ='Medial dislocation of proximal end of tibia, unspecified knee, initial encounter' where assessment_id = 'DEMO2600'
update c_Assessment_Definition SET last_updated=getdate(), description ='Medial dislocation of unspecified ulnohumeral joint, initial encounter' where assessment_id = 'DEMO2552'
update c_Assessment_Definition SET last_updated=getdate(), description ='Meniere''s disease, unspecified ear' where assessment_id = 'DEMO10153'
update c_Assessment_Definition SET last_updated=getdate(), description ='Meningitis in other infectious and parasitic diseases classified elsewhere' where assessment_id = 'DEMO4466'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mental disorder, not otherwise specified' where assessment_id = 'DEMO9678'
update c_Assessment_Definition SET last_updated=getdate(), description ='Metabolic disorder following (induced) termination of pregnancy' where assessment_id = 'DEMO443x5b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Metabolic disorder following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x5'
update c_Assessment_Definition SET last_updated=getdate(), description ='Metabolic disorder, unspecified' where assessment_id = '0^11651'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microphthalmos' where assessment_id = 'DEMO5720'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mild hyperemesis gravidarum' where assessment_id = 'DEMO10696'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mild intermittent asthma with (acute) exacerbation' where assessment_id = 'DEMO10483'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mild intermittent asthma with status asthmaticus' where assessment_id = 'DEMO10488'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mild intermittent asthma, uncomplicated' where assessment_id = 'DEMO10014'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mild intermittent asthma, uncomplicated' where assessment_id = 'DEMO10014'
update c_Assessment_Definition SET last_updated=getdate(), description ='Molybdenum deficiency' where assessment_id = 'DEMO4743'
update c_Assessment_Definition SET last_updated=getdate(), description ='Monocular esotropia with other noncomitancies, left eye' where assessment_id = 'DEMO6550'
update c_Assessment_Definition SET last_updated=getdate(), description ='Monocular exotropia with other noncomitancies, left eye' where assessment_id = 'DEMO6560'
update c_Assessment_Definition SET last_updated=getdate(), description ='Monocytic leukemia, unspecified, not having achieved remission' where assessment_id = 'DEMO3512'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Motorcycle rider (driver) (passenger) injured in unspecified traffic accident, initial encounter' where assessment_id = 'DEMO9836'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mucinosis of the skin' where assessment_id = 'DEMO5120'
update c_Assessment_Definition SET last_updated=getdate(), description ='Multifocal fibrosclerosis' where assessment_id = 'DEMO2001'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Multiple fractures of ribs, unspecified side, initial encounter for closed fracture' where assessment_id = 'DEMO156'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Multiple fractures of ribs, unspecified side, initial encounter for open fracture' where assessment_id = 'DEMO2297'
update c_Assessment_Definition SET last_updated=getdate(), description ='Multiple gestation, unspecified, third trimester' where assessment_id = 'DEMO10844'
update c_Assessment_Definition SET last_updated=getdate(), description ='Muscle wasting and atrophy, not elsewhere classified, unspecified site' where assessment_id = 'DEMO3805'
update c_Assessment_Definition SET last_updated=getdate(), description ='Myelitis in diseases classified elsewhere' where assessment_id = '0^323.02^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Myelitis, unspecified' where assessment_id = '981^323.9^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Myopathy in diseases classified elsewhere' where assessment_id = 'DEMO7412'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neonatal candidiasis' where assessment_id = 'DEMO6704'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neonatal coma' where assessment_id = 'DEMO6753'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neonatal conjunctivitis and dacryocystitis' where assessment_id = 'DEMO6702'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm of uncertain behavior of connective and other soft tissue' where assessment_id = 'DEMO544'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm of uncertain behavior of other specified sites' where assessment_id = 'DEMO9201'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm of unspecified behavior of bone, soft tissue, and skin' where assessment_id = 'DEMO8912'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm related pain (acute) (chronic)' where assessment_id = '0^338.3^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neuralgia and neuritis, unspecified' where assessment_id = 'DEMO546'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neuralgia and neuritis, unspecified' where assessment_id = 'DEMO546'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neuromuscular dysfunction of bladder, unspecified' where assessment_id = 'DEMO7027'
update c_Assessment_Definition SET last_updated=getdate(), description ='Newborn affected by maternal nutritional disorders' where assessment_id = 'DEMO6503'
update c_Assessment_Definition SET last_updated=getdate(), description ='Noise effects on inner ear, unspecified ear' where assessment_id = 'DEMO6932'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Nondisplaced fracture of medial phalanx of unspecified finger, initial encounter for closed fracture' where assessment_id = 'DEMO1181'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Nondisplaced fracture of medial phalanx of unspecified finger, initial encounter for open fracture' where assessment_id = 'DEMO2638'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Noninflammatory disorder of ovary, fallopian tube and broad ligament, unspecified' where assessment_id = 'DEMO811'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nonpurulent mastitis associated with lactation' where assessment_id = 'DEMO11291'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nonscarring hair loss, unspecified' where assessment_id = 'DEMO10403'
update c_Assessment_Definition SET last_updated=getdate(), description ='Non-ST elevation (NSTEMI) myocardial infarction' where assessment_id = 'DEMO1705'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nontoxic goiter, unspecified' where assessment_id = 'DEMO4604'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nontoxic single thyroid nodule' where assessment_id = 'DEMO117'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nontraumatic compartment syndrome of unspecified lower extremity' where assessment_id = '0^729.72^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nontraumatic compartment syndrome of unspecified upper extremity' where assessment_id = '0^729.71^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nonvenereal syphilis' where assessment_id = 'DEMO4449'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obesity complicating the puerperium' where assessment_id = '0^649.12^0'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Observation and evaluation of newborn for suspected metabolic condition ruled out' where assessment_id = 'DEMO1187'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric damage to pelvic joints and ligaments' where assessment_id = 'DEMO1062'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric hematoma of pelvis' where assessment_id = 'DEMO1054'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric high vaginal laceration alone' where assessment_id = 'DEMO1060'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric laceration of cervix' where assessment_id = 'DEMO1059'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric trauma, unspecified' where assessment_id = 'DEMO11101'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor due to breech presentation, not applicable or unspecified' where assessment_id = 'DEMO1081'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor due to fetopelvic disproportion, unspecified' where assessment_id = 'DEMO1022'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Obstructed labor due to incomplete rotation of fetal head, not applicable or unspecified' where assessment_id = 'DEMO11023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor due to locked twins' where assessment_id = 'DEMO1025'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Obstructed labor due to malposition and malpresentation, unspecified, not applicable or unspecified' where assessment_id = 'DEMO1021'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor due to maternal pelvic abnormality, unspecified' where assessment_id = 'DEMO1023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor due to shoulder dystocia' where assessment_id = 'DEMO1024'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructed labor, unspecified' where assessment_id = 'DEMO11039'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstruction of duodenum' where assessment_id = 'DEMO7814'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstruction of gallbladder' where assessment_id = 'DEMO8043'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obturator dislocation of unspecified hip, initial encounter' where assessment_id = 'DEMO2567'
update c_Assessment_Definition SET last_updated=getdate(), description ='Occlusion and stenosis of unspecified cerebral artery' where assessment_id = 'DEMO1819'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Ocular laceration and rupture with prolapse or loss of intraocular tissue, unspecified eye, initial encounter' where assessment_id = 'DEMO2792'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Ocular laceration without prolapse or loss of intraocular tissue, unspecified eye, initial encounter' where assessment_id = 'DEMO2791'
update c_Assessment_Definition SET last_updated=getdate(), description ='Oligohydramnios, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10974'
update c_Assessment_Definition SET last_updated=getdate(), description ='Oligomenorrhea, unspecified' where assessment_id = 'DEMO854'
update c_Assessment_Definition SET last_updated=getdate(), description ='Open bite of nose, initial encounter' where assessment_id = 'DEMO210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Open bite of unspecified eyelid and periocular area, initial encounter' where assessment_id = 'DEMO2785'
update c_Assessment_Definition SET last_updated=getdate(), description ='Organic oligospermia' where assessment_id = 'DEMO7094'
update c_Assessment_Definition SET last_updated=getdate(), description ='Otalgia, unspecified ear' where assessment_id = 'EARACHE'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other abnormal auditory perceptions, unspecified ear' where assessment_id = 'DEMO6938'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other abnormal bowel sounds' where assessment_id = 'DEMO1253'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other abnormal findings in urine' where assessment_id = 'DEMO10205'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other abnormalities of breathing' where assessment_id = 'BRET'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other acne' where assessment_id = 'DEMO5144'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other acquired deformities of unspecified foot' where assessment_id = 'DEMO3968'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other acquired hemolytic anemias' where assessment_id = 'DEMO7461'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other acquired stenosis of external ear canal, unspecified ear' where assessment_id = 'DEMO6773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other age-related cataract' where assessment_id = 'DEMO5528'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other allergic and dietetic gastroenteritis and colitis' where assessment_id = 'DEMO10382'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other and unspecified ventral hernia with gangrene' where assessment_id = 'DEMO7863'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other and unspecified ventral hernia with obstruction, without gangrene' where assessment_id = 'DEMO7873'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other anemias due to enzyme disorders' where assessment_id = 'DEMO7433'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other anterior dislocation of unspecified hip, initial encounter' where assessment_id = 'DEMO2568'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other apocrine sweat disorders' where assessment_id = 'DEMO5138'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other appendicitis' where assessment_id = 'DEMO7734'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other articular cartilage disorders, unspecified site' where assessment_id = '0^12180'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other artificial opening status' where assessment_id = 'DEMO9109'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other asthma' where assessment_id = 'DEMO550'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other atopic dermatitis' where assessment_id = 'DEMO10478'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other atresia and stenosis of urethra and bladder neck' where assessment_id = 'DEMO5975'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other bacterial meningitis' where assessment_id = 'DEMO7153'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other benign mammary dysplasias of unspecified breast' where assessment_id = 'DEMO734'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other benign neoplasm of skin, unspecified' where assessment_id = 'DEMO701'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other brachial plexus birth injuries' where assessment_id = 'ERB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other branchial cleft malformations' where assessment_id = 'DEMO5778'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other bursal cyst, unspecified site' where assessment_id = 'DEMO3782'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other bursitis, not elsewhere classified, unspecified site' where assessment_id = 'DEMO8022'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cardiac sounds' where assessment_id = 'DEMO2117'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cardiomyopathies' where assessment_id = '000112xx'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cerebrovascular disease' where assessment_id = 'DEMO1832'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cervical disc degeneration, unspecified cervical region' where assessment_id = 'DEMO10071'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cervical disc displacement, unspecified cervical region' where assessment_id = 'DEMO10076'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other chest pain' where assessment_id = '000122x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other childhood disorders of social functioning' where assessment_id = 'DEMO9784'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other childhood emotional disorders' where assessment_id = 'DEMO9809'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other chlamydial genitourinary infection' where assessment_id = 'DEMO4427'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other chorioretinal scars, unspecified eye' where assessment_id = 'DEMO5422'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other chronic thyroiditis' where assessment_id = 'DEMO4621'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other complications of obstetric surgery and procedures' where assessment_id = 'DEMO11181'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other complications of procedures, not elsewhere classified, initial encounter' where assessment_id = 'DEMO11345'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other complications specific to multiple gestation, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10841'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other conduct disorders' where assessment_id = 'DEMO9797'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital deformities of skull, face and jaw' where assessment_id = 'DEMO6119'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital lens malformations' where assessment_id = 'DEMO5512'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformation of ovary' where assessment_id = 'DEMO5901'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of abdominal wall' where assessment_id = 'DEMO6287'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of aorta' where assessment_id = 'DEMO2057'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of bladder and urethra' where assessment_id = 'DEMO5981'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of breast' where assessment_id = 'DEMO6066'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of bronchus' where assessment_id = 'DEMO5793'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of diaphragm' where assessment_id = 'DEMO6283'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of esophagus' where assessment_id = 'DEMO5850'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of eyelid' where assessment_id = 'DEMO5754'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of fallopian tube and broad ligament' where assessment_id = 'DEMO5904'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of great veins' where assessment_id = 'DEMO2072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of hair' where assessment_id = 'DEMO6060'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of iris' where assessment_id = 'COLOB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of liver' where assessment_id = 'DEMO5886'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of lower limb(s), including pelvic girdle' where assessment_id = 'DEMO6216'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of musculoskeletal system' where assessment_id = 'DEMO6048'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of nails' where assessment_id = 'DEMO6069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of nose' where assessment_id = 'DEMO5789'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of pancreas and pancreatic duct' where assessment_id = 'DEMO5896'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of spine, not associated with scoliosis' where assessment_id = 'DEMO6263'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of tongue' where assessment_id = 'DEMO5829'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of upper limb(s), including shoulder girdle' where assessment_id = 'DEMO6207'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of ureter' where assessment_id = 'DEMO5969'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital malformations of vagina' where assessment_id = 'DEMO5917'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other congenital valgus deformities of feet' where assessment_id = 'DEMO6147'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other conjunctivitis' where assessment_id = 'DEMO6341'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cystitis with hematuria' where assessment_id = 'DEMO7009'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cysts of jaw' where assessment_id = 'DEMO7657'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other cysts of oral region, not elsewhere classified' where assessment_id = 'DEMO7690'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other dermatophytoses' where assessment_id = 'DEMO10369'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diphtheritic complications' where assessment_id = 'DEMO4116'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of larynx' where assessment_id = 'DEMO4932'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of pharynx' where assessment_id = 'DEMO4922'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of salivary glands' where assessment_id = 'DEMO7676'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of spleen' where assessment_id = 'DEMO421'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism complicating the puerperium' where assessment_id = '0^649.32^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of thymus' where assessment_id = 'DEMO4684'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of tongue' where assessment_id = 'DEMO7715'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other diseases of vocal cords' where assessment_id = 'DEMO4941'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other dislocation of unspecified foot, initial encounter' where assessment_id = 'DEMO2610'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other dislocation of unspecified shoulder joint, initial encounter' where assessment_id = 'DEMO2548'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other dislocation of unspecified wrist and hand, initial encounter' where assessment_id = 'DEMO2560'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorder of circulatory system' where assessment_id = 'DEMO1973'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders affecting eyelid function' where assessment_id = 'DEMO6399'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of amino-acid transport' where assessment_id = 'DEMO4746'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of breast associated with pregnancy and the puerperium' where assessment_id = 'DEMO1114'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of calcium metabolism' where assessment_id = 'PSEUD'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of copper metabolism' where assessment_id = 'DEMO4787'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of facial nerve' where assessment_id = 'DEMO7355'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of lactation' where assessment_id = 'DEMO1118'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of magnesium metabolism' where assessment_id = 'DEMO4790'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of orbit' where assessment_id = 'DEMO6450'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of prepuce' where assessment_id = 'DEMO7091'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of purine and pyrimidine metabolism' where assessment_id = 'DEMO4804'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of retroperitoneum' where assessment_id = '0^12026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of sulfur-bearing amino-acid metabolism' where assessment_id = 'DEMO4757'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other disorders of urea cycle metabolism' where assessment_id = 'DEMO4766'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other dystrophies primarily involving the sensory retina' where assessment_id = 'DEMO5389'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other early complications of trauma, initial encounter' where assessment_id = 'DEMO3214'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other embolism in the puerperium' where assessment_id = 'DEMO11259'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other enthesopathy of unspecified foot' where assessment_id = 'DEMO10087'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other family member, perpetrator of maltreatment and neglect' where assessment_id = 'DEMO10267'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other fecal abnormalities' where assessment_id = '0^11588'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other female genital tract fistulae' where assessment_id = 'DEMO794'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other forms of acute ischemic heart disease' where assessment_id = 'DEMO10545'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other fracture of upper end of unspecified ulna, initial encounter for open fracture type IIIA, IIIB, or IIIC' where assessment_id = 'DEMO2385'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other general symptoms and signs' where assessment_id = 'DEMO10507'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other gonococcal genitourinary infections' where assessment_id = 'DEMO4398'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other gonococcal infections' where assessment_id = 'DEMO4414'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hair color and hair shaft abnormalities' where assessment_id = 'DEMO5125'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hammer toe(s) (acquired), unspecified foot' where assessment_id = 'DEMO3946'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hemoglobinopathies' where assessment_id = 'DEMO7448'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hemorrhage in early pregnancy' where assessment_id = 'DEMO8s'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hemorrhoids' where assessment_id = 'DEMO1950'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hereditary ataxias' where assessment_id = 'DEMO7236'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hereditary choroidal dystrophy' where assessment_id = 'DEMO5429'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hereditary corneal dystrophies' where assessment_id = 'DEMO6322'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other herpes zoster eye disease' where assessment_id = 'DEMO10161'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other herpesviral disease of eye' where assessment_id = 'DEMO10172'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other herpesviral infection' where assessment_id = 'DEMO10173'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other Hodgkin lymphoma, extranodal and solid organ sites' where assessment_id = 'DEMO3485'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hypersomnia not due to a substance or known physiological condition' where assessment_id = 'DEMO9759'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other hypoglycemia' where assessment_id = '000111x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other ill-defined heart diseases' where assessment_id = 'DEMO1800'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other immediate postpartum hemorrhage' where assessment_id = 'DEMO11138'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other impaction of intestine' where assessment_id = 'DEMO7893'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other infection during labor' where assessment_id = 'DEMO1012'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other infections with a predominantly sexual mode of transmission complicating the puerperium' where assessment_id = 'DEMO10757'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other inflammatory diseases of prostate' where assessment_id = 'DEMO7066'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other inflammatory disorders of penis' where assessment_id = 'DEMO7102'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other injury of unspecified body region, initial encounter' where assessment_id = 'CONTUSION'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other insect allergy status' where assessment_id = 'DEMO10213'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other insomnia not due to a substance or known physiological condition' where assessment_id = 'DEMO9757'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other intervertebral disc degeneration, lumbosacral region' where assessment_id = 'DEMO133'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other intervertebral disc degeneration, thoracolumbar region' where assessment_id = 'DEMO10072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other intervertebral disc displacement, lumbosacral region' where assessment_id = 'DEMO10077'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other intervertebral disc displacement, thoracolumbar region' where assessment_id = 'DEMO10078'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other intestinal malabsorption' where assessment_id = 'DEMO10457'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other iron deficiency anemias' where assessment_id = 'DEMO7418'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other irregular eye movements' where assessment_id = 'DEMO6631'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other keratoconjunctivitis, unspecified eye' where assessment_id = 'DEMO5664'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other long term (current) drug therapy' where assessment_id = 'DEMO1463'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other low birth weight newborn, 1250-1499 grams' where assessment_id = 'DEMO10220'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other low birth weight newborn, 1750-1999 grams' where assessment_id = 'DEMO10221'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other low birth weight newborn, 2000-2499 grams' where assessment_id = 'DEMO10222'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other low birth weight newborn, unspecified weight' where assessment_id = 'DEMO10217'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other mast cell neoplasms of uncertain behavior' where assessment_id = 'DEMO9198'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other measles complications' where assessment_id = 'DEMO10176'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other mechanical complication of cardiac pulse generator (battery), initial encounter' where assessment_id = 'DEMO9140'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other megaloblastic anemias, not elsewhere classified' where assessment_id = 'DEMO7424'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other mental disorders complicating the puerperium' where assessment_id = 'DEMO10803'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other microdeletions' where assessment_id = '0^11731'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other migraine, intractable, without status migrainosus' where assessment_id = 'DEMO7329'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other migraine, not intractable, without status migrainosus' where assessment_id = 'DEMO242'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other mucopurulent conjunctivitis, unspecified eye' where assessment_id = 'CONBACT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other myocardial infarction type' where assessment_id = 'DEMO1671b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other nail disorders' where assessment_id = 'DEMO5122'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other nonautoimmune hemolytic anemias' where assessment_id = 'DEMO7457'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other nondisplaced fracture of upper end of unspecified humerus, initial encounter for closed fracture' where assessment_id = 'DEMO2351'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other nondisplaced fracture of upper end of unspecified humerus, initial encounter for open fracture' where assessment_id = 'DEMO2355'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other non-follicular lymphoma, extranodal and solid organ sites' where assessment_id = 'DEMO653'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other nonrheumatic mitral valve disorders' where assessment_id = 'DEMO1732'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other nonthrombocytopenic purpura' where assessment_id = 'DEMO7503'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other obstetric injury to pelvic organs' where assessment_id = 'DEMO1061'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other obstructive defects of renal pelvis and ureter' where assessment_id = 'DEMO5951'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other optic atrophy, unspecified eye' where assessment_id = 'DEMO6482'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other osteoporosis without current pathological fracture' where assessment_id = 'DEMO3918'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other phakomatoses, not elsewhere classified' where assessment_id = 'DEMO5508'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other phobic anxiety disorders' where assessment_id = 'DEMO9670'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other porphyria' where assessment_id = 'DEMO10479'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other postherpetic nervous system involvement' where assessment_id = 'DEMO4186'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other postprocedural cardiac functional disturbances following cardiac surgery' where assessment_id = 'DEMO1797'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other pruritus' where assessment_id = 'DEMO434'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other psychoactive substance abuse, uncomplicated' where assessment_id = 'DEMO9739'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other psychoactive substance dependence, uncomplicated' where assessment_id = 'DEMO10096'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other reactions to severe stress' where assessment_id = 'DEMO9792'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other recurrent vertebral dislocation, site unspecified' where assessment_id = '0^12206'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other reduction defects of unspecified limb(s)' where assessment_id = 'DEMO6202'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other reduction defects of unspecified lower limb' where assessment_id = 'DEMO6184'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other reduction deformities of brain' where assessment_id = 'DEMO5698'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other secondary hypertension' where assessment_id = 'DEMO1571'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other secondary syphilitic conditions' where assessment_id = 'DEMO4353'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sequelae following unspecified cerebrovascular disease' where assessment_id = 'DEMO10062'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sexual disorders' where assessment_id = 'DEMO9700'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sexual dysfunction not due to a substance or known physiological condition' where assessment_id = 'IMPO'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other shock' where assessment_id = 'DEMO2121'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other shoulder lesions, unspecified shoulder' where assessment_id = 'DEMO3755'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other signs and symptoms in breast' where assessment_id = 'DEMO741'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sites of candidiasis' where assessment_id = 'DEMO634'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sleep disorders not due to a substance or known physiological condition' where assessment_id = 'NIGHT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other sleep disorders' where assessment_id = '0^12004'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other somatoform disorders' where assessment_id = 'DEMO9740'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified elbow, not elsewhere classified' where assessment_id = '0^12219'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified foot, not elsewhere classified' where assessment_id = '0^12224'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified hand, not elsewhere classified' where assessment_id = '0^12221'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified hip, not elsewhere classified' where assessment_id = '0^12222'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified joint, not elsewhere classified' where assessment_id = '0^12218'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specific joint derangements of unspecified shoulder, not elsewhere classified' where assessment_id = '0^12217'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific joint derangements of unspecified wrist, not elsewhere classified' where assessment_id = '0^12220'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specific personality disorders' where assessment_id = 'DEMO9683'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified abdominal hernia without obstruction or gangrene' where assessment_id = 'DEMO7885'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified abnormal findings of blood chemistry' where assessment_id = '0^790.6^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified abnormal uterine and vaginal bleeding' where assessment_id = '000183x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified acquired deformities of unspecified forearm' where assessment_id = 'DEMO3953'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified acquired deformities of unspecified lower leg' where assessment_id = 'DEMO3964'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified anemias' where assessment_id = 'DEMO7471'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified bacterial agents as the cause of diseases classified elsewhere' where assessment_id = 'DEMO4159'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified bacterial diseases' where assessment_id = 'DEMO4148'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified bacterial foodborne intoxications' where assessment_id = 'DEMO3852'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified bacterial intestinal infections' where assessment_id = 'DEMO3868'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified bursopathies, unspecified site' where assessment_id = 'DEMO3796'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified complications of labor and delivery' where assessment_id = 'DEMO1019'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specified conditions associated with female genital organs and menstrual cycle' where assessment_id = '0^11618'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified conduction disorders' where assessment_id = 'DEMO10420'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital deformities of feet' where assessment_id = 'CLUB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital deformities of hip' where assessment_id = 'DEMO6219'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital infectious and parasitic diseases' where assessment_id = 'DEMO6696'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of brain' where assessment_id = 'DEMO5702'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of ear' where assessment_id = 'DEMO5769'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of female genitalia' where assessment_id = 'DEMO5921'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of intestine' where assessment_id = 'DEMO5877'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of kidney' where assessment_id = 'DEMO5957'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of nervous system' where assessment_id = 'DEMO5710'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of respiratory system' where assessment_id = 'DEMO5809'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of skin' where assessment_id = 'DEMO10447'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of spinal cord' where assessment_id = 'DEMO5707'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations of stomach' where assessment_id = 'DEMO5855'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital malformations' where assessment_id = 'DEMO6103'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified congenital musculoskeletal deformities' where assessment_id = 'DEMO6205'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified counseling' where assessment_id = 'DEMO9490'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified degenerative diseases of basal ganglia' where assessment_id = 'DEMO7207'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diabetes mellitus with ketoacidosis without coma' where assessment_id = 'DEMO4634'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of biliary tract' where assessment_id = 'DEMO8069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of esophagus' where assessment_id = 'DEMO7763'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of gallbladder' where assessment_id = 'DEMO8053'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of intestine' where assessment_id = 'DEMO7971'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of jaws' where assessment_id = 'DEMO7665'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of pancreas' where assessment_id = 'DEMO8075'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of pericardium' where assessment_id = 'DEMO1730a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified diseases of spinal cord' where assessment_id = 'DEMO7256'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specified disorders of amniotic fluid and membranes, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10985'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specified disorders of amniotic fluid and membranes, unspecified trimester, not applicable or unspecified' where assessment_id = 'DEMO1007'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of arteries and arterioles' where assessment_id = 'DEMO1915'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of cartilage, unspecified sites' where assessment_id = 'DEMO11347'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of kidney and ureter' where assessment_id = 'DEMO8961'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of middle ear and mastoid, unspecified ear' where assessment_id = 'DEMO6877'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of muscle' where assessment_id = 'DEMO3807'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of parathyroid gland' where assessment_id = 'DEMO4673'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of penis' where assessment_id = '0^11631'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of pigmentation' where assessment_id = 'LEUKO'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of prostate' where assessment_id = 'DEMO7072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of temporomandibular joint' where assessment_id = 'DEMO7642'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of the male genital organs' where assessment_id = 'DEMO7138'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of the skin and subcutaneous tissue' where assessment_id = 'DEMO10641'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of thyroid' where assessment_id = 'DEMO4629'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of urethra' where assessment_id = 'DEMO7051'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disorders of white blood cells' where assessment_id = 'DEMO7528'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified dorsopathies, cervical region' where assessment_id = 'DEMO3726'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified endocrine disorders' where assessment_id = 'DEMO4713'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified enthesopathies of unspecified lower limb, excluding foot' where assessment_id = 'DEMO3760'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified fluke infections' where assessment_id = 'DEMO4503'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified follicular disorders' where assessment_id = 'DEMO5129'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified forms of tremor' where assessment_id = 'DEMO7210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified glaucoma' where assessment_id = 'DEMO5509'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified hearing loss, unspecified ear' where assessment_id = '0^12145'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified heart block' where assessment_id = 'DEMO1775'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified hemorrhagic conditions' where assessment_id = 'DEMO7505'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified inflammations of eyelid' where assessment_id = 'DEMO6375'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified local infections of the skin and subcutaneous tissue' where assessment_id = 'DEMO5072'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified mycoses' where assessment_id = 'DEMO4492'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specified neoplasms of uncertain behavior of lymphoid, hematopoietic and related tissue' where assessment_id = '0^238.79^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified noninfective disorders of lymphatic vessels and lymph nodes' where assessment_id = 'DEMO1966'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified noninflammatory disorders of cervix uteri' where assessment_id = 'DEMO830'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified noninflammatory disorders of uterus' where assessment_id = 'DEMO822'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified noninflammatory disorders of vagina' where assessment_id = 'DEMO838'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified noninflammatory disorders of vulva and perineum' where assessment_id = 'DEMO846'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified nonpsychotic mental disorders' where assessment_id = 'DEMO9677'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified obstetric trauma' where assessment_id = 'DEMO11125'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified osteochondrodysplasias' where assessment_id = 'DEMO6278'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified peripheral vascular diseases' where assessment_id = 'DEMO1893'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified protozoal diseases' where assessment_id = 'DEMO4562'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified protozoal intestinal diseases' where assessment_id = 'DEMO4563'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified retinal disorders' where assessment_id = 'DEMO5395'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified soft tissue disorders' where assessment_id = '0^12295'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other specified symptoms and signs involving the circulatory and respiratory systems' where assessment_id = 'DEMO1239'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified symptoms and signs involving the digestive system and abdomen' where assessment_id = '0^11616'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified trauma to perineum and vulva' where assessment_id = 'DEMO1055'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified types of non-Hodgkin lymphoma, extranodal and solid organ sites' where assessment_id = 'DEMO671'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified viral infections of central nervous system' where assessment_id = 'DEMO4172'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other spinal muscular atrophies and related syndromes' where assessment_id = 'DEMO7242'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other streptococcus as the cause of diseases classified elsewhere' where assessment_id = 'DEMO4152'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other subjective visual disturbances' where assessment_id = 'DEMO5577'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other symptomatic late syphilis' where assessment_id = 'DEMO10358'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other symptoms and signs involving the musculoskeletal system' where assessment_id = '0^11619'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other synovitis and tenosynovitis, unspecified ankle and foot' where assessment_id = 'DEMO3775'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other synovitis and tenosynovitis, unspecified hand' where assessment_id = 'DEMO545'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other synovitis and tenosynovitis, unspecified site' where assessment_id = 'TENELB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other syphilitic heart involvement' where assessment_id = 'DEMO4365'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Other tear of medial meniscus, current injury, unspecified knee, initial encounter' where assessment_id = 'DEMO2595'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other transitory neonatal disorders of calcium and magnesium metabolism' where assessment_id = 'DEMO6725'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other tuberculosis of eye' where assessment_id = 'DEMO4068'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other ulcerative colitis without complications' where assessment_id = 'DEMO7831'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other urethritis' where assessment_id = 'DEMO7035'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other urticaria' where assessment_id = 'DEMO11355'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other varicella complications' where assessment_id = '0^052.7^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other venous complications in pregnancy, third trimester' where assessment_id = 'DEMO11224'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other venous complications in the puerperium' where assessment_id = 'DEMO11225'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other viral diseases complicating childbirth' where assessment_id = 'DEMO10768'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other viral diseases complicating pregnancy, third trimester' where assessment_id = 'DEMO10770'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other viral diseases complicating pregnancy, unspecified trimester' where assessment_id = 'DEMO10772'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other viral diseases complicating the puerperium' where assessment_id = 'DEMO10769'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other vitamin B12 deficiency anemias' where assessment_id = 'DEMO7421'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pain in unspecified joint' where assessment_id = '0^12263'
update c_Assessment_Definition SET last_updated=getdate(), description ='Painful ejaculation' where assessment_id = 'DEMO10512'
update c_Assessment_Definition SET last_updated=getdate(), description ='Palsy (spasm) of conjugate gaze' where assessment_id = 'DEMO6589'
update c_Assessment_Definition SET last_updated=getdate(), description ='Papyraceous fetus, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10715'
update c_Assessment_Definition SET last_updated=getdate(), description ='Parageusia' where assessment_id = 'DEMO2104'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paralysis of vocal cords and larynx, bilateral' where assessment_id = 'DEMO4926'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paralysis of vocal cords and larynx, unilateral' where assessment_id = 'DEMO4924'
update c_Assessment_Definition SET last_updated=getdate(), description ='Partial traumatic amputation at elbow level, unspecified arm, initial encounter' where assessment_id = 'DEMO2855'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation at knee level, unspecified lower leg, initial encounter' where assessment_id = 'DEMO2868'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation at level between knee and ankle, unspecified lower leg, initial encounter' where assessment_id = 'DEMO2867'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation of two or more unspecified lesser toes, initial encounter' where assessment_id = 'DEMO2865'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation of unspecified foot, level unspecified, initial encounter' where assessment_id = 'DEMO2866'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation of unspecified lower leg, level unspecified, initial encounter' where assessment_id = 'DEMO2869'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic amputation of unspecified shoulder and upper arm, level unspecified, initial encounter' where assessment_id = 'DEMO2856'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic transmetacarpal amputation of unspecified hand, initial encounter' where assessment_id = 'DEMO2854'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic transphalangeal amputation of unspecified finger, initial encounter' where assessment_id = 'DEMO2853'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Partial traumatic transphalangeal amputation of unspecified thumb, initial encounter' where assessment_id = 'DEMO2852'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pathological dislocation of unspecified joint, not elsewhere classified' where assessment_id = '0^12196'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Pathological fracture, unspecified tibia and fibula, initial encounter for fracture' where assessment_id = 'DEMO3926'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Pathological fracture, unspecified ulna and radius, initial encounter for fracture' where assessment_id = 'DEMO3923'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pauciarticular juvenile rheumatoid arthritis, unspecified site' where assessment_id = 'DEMO3563'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pelvic and perineal pain' where assessment_id = 'DEMO10648'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Penetrating wound of orbit with or without foreign body, unspecified eye, initial encounter' where assessment_id = 'DEMO2788'
update c_Assessment_Definition SET last_updated=getdate(), description ='Penetrating wound with foreign body of unspecified eyeball, initial encounter' where assessment_id = 'DEMO2843'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perforation of esophagus' where assessment_id = 'DEMO7756'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perianal venous thrombosis' where assessment_id = 'DEMO1954'
update c_Assessment_Definition SET last_updated=getdate(), description ='Periarthritis, unspecified wrist' where assessment_id = 'DEMO8009'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pericarditis in diseases classified elsewhere' where assessment_id = 'DEMO4468'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perineal laceration during delivery, unspecified' where assessment_id = 'DEMO1053'
update c_Assessment_Definition SET last_updated=getdate(), description ='Periorbital cellulitis' where assessment_id = 'DEMO5051'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peritoneal adhesions (postprocedural) (postinfection)' where assessment_id = 'DEMO7944'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of benign neoplasm of the brain' where assessment_id = 'DEMO9018'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of benign neoplasm of the brain' where assessment_id = 'DEMO9018a'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism' where assessment_id = 'DEMO9017'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism' where assessment_id = 'DEMO9017A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of leukemia' where assessment_id = 'DEMO1427'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of leukemia' where assessment_id = 'DEMO1427A'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of malignant neoplasm of other respiratory and intrathoracic organs' where assessment_id = 'DEMO1412'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of malignant neoplasm of other respiratory and intrathoracic organs' where assessment_id = 'DEMO1412A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified digestive organ' where assessment_id = 'DEMO1404'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of malignant neoplasm of unspecified digestive organ' where assessment_id = 'DEMO1404A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of nicotine dependence' where assessment_id = '0^12285'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of other complications of pregnancy, childbirth and the puerperium' where assessment_id = 'DEMO11428'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of other diseases of the musculoskeletal system and connective tissue' where assessment_id = '0^11765A'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of other diseases of the musculoskeletal system and connective tissue' where assessment_id = '0^11766A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of other diseases of the respiratory system' where assessment_id = '0^12066'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Personal history of other malignant neoplasm of rectum, rectosigmoid junction, and anus' where assessment_id = 'DEMO8999A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of other medical treatment' where assessment_id = '0^12268'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO10023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9129'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of other specified conditions' where assessment_id = 'DEMO9185'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of peptic ulcer disease' where assessment_id = 'DEMO9021'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of peptic ulcer disease' where assessment_id = 'DEMO9021A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personality change due to known physiological condition' where assessment_id = 'DEMO9794'
update c_Assessment_Definition SET last_updated=getdate(), description ='Phlebitis and thrombophlebitis of other sites' where assessment_id = 'DEMO1934'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Phlebitis and thrombophlebitis of unspecified deep vessels of unspecified lower extremity' where assessment_id = 'DEMO1920'
update c_Assessment_Definition SET last_updated=getdate(), description ='Phlebitis of portal vein' where assessment_id = 'DEMO7992'
update c_Assessment_Definition SET last_updated=getdate(), description ='Placentitis, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10983'
update c_Assessment_Definition SET last_updated=getdate(), description ='Plasmodium malariae malaria without complication' where assessment_id = 'DEMO4307'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pleurodynia' where assessment_id = 'DEMO10497'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pneumocystosis' where assessment_id = 'DEMO688'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pneumonia due to other streptococci' where assessment_id = 'DEMO4946'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pneumonia in diseases classified elsewhere' where assessment_id = 'DEMO4258'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pneumonic plague' where assessment_id = 'DEMO4079'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Poisoning by cardiac-stimulant glycosides and drugs of similar action, undetermined, initial encounter' where assessment_id = 'DEMO3242'
update c_Assessment_Definition SET last_updated=getdate(), description ='Poisoning by coronary vasodilators, undetermined, initial encounter' where assessment_id = 'DEMO3245'
update c_Assessment_Definition SET last_updated=getdate(), description ='Poisoning by other antidysrhythmic drugs, undetermined, initial encounter' where assessment_id = 'DEMO3238'
update c_Assessment_Definition SET last_updated=getdate(), description ='Poisoning by other antihypertensive drugs, undetermined, initial encounter' where assessment_id = 'DEMO3247'
update c_Assessment_Definition SET last_updated=getdate(), description ='Poisoning by vitamins, undetermined, initial encounter' where assessment_id = 'DEMO282'
update c_Assessment_Definition SET last_updated=getdate(), description ='Polycythemia vera' where assessment_id = 'DEMO9197'
update c_Assessment_Definition SET last_updated=getdate(), description ='Polyhydramnios, third trimester, not applicable or unspecified' where assessment_id = 'DEMO10971'
update c_Assessment_Definition SET last_updated=getdate(), description ='Polyneuropathy in diseases classified elsewhere' where assessment_id = 'DEMO7395'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Posterior dislocation of proximal end of tibia, unspecified knee, initial encounter' where assessment_id = 'DEMO2599'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterior dislocation of unspecified hip, initial encounter' where assessment_id = 'DEMO2566'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterior dislocation of unspecified humerus, initial encounter' where assessment_id = 'DEMO2545'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterior dislocation of unspecified radial head, initial encounter' where assessment_id = 'DEMO2551'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postlaminectomy syndrome, not elsewhere classified' where assessment_id = 'DEMO10067'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postpartum inversion of uterus' where assessment_id = 'DEMO1058'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postprocedural hypothyroidism' where assessment_id = 'DEMO4612'
update c_Assessment_Definition SET last_updated=getdate(), description ='Post-term pregnancy' where assessment_id = 'DEMO10711'
update c_Assessment_Definition SET last_updated=getdate(), description ='Preauricular sinus and cyst' where assessment_id = 'DEMO5779'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pre-excitation syndrome' where assessment_id = 'WOLF'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pre-existing hypertension with pre-eclampsia, complicating childbirth' where assessment_id = 'DEMO904c'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pre-existing hypertension with pre-eclampsia, complicating the puerperium' where assessment_id = 'DEMO904'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pre-existing hypertension with pre-eclampsia, third trimester' where assessment_id = 'DEMO10679'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pre-existing secondary hypertension complicating the puerperium' where assessment_id = 'DEMO10676'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pregnancy care for patient with recurrent pregnancy loss, third trimester' where assessment_id = 'DEMO10725'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pregnancy related renal disease, third trimester' where assessment_id = 'DEMO10721'
update c_Assessment_Definition SET last_updated=getdate(), description ='Premature separation of placenta, unspecified, third trimester' where assessment_id = 'DEMO457q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prepatellar bursitis, unspecified knee' where assessment_id = 'DEMO3776'
update c_Assessment_Definition SET last_updated=getdate(), description ='Presence of (intrauterine) contraceptive device' where assessment_id = 'DEMO1445'
update c_Assessment_Definition SET last_updated=getdate(), description ='Presence of intraocular lens' where assessment_id = 'DEMO11442'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary osteoarthritis, unspecified hand' where assessment_id = 'DEMO3595'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary osteoarthritis, unspecified site' where assessment_id = 'DEMO3590'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary respiratory tuberculosis' where assessment_id = 'DEMO4022'
update c_Assessment_Definition SET last_updated=getdate(), description ='Problem related to primary support group, unspecified' where assessment_id = 'DEMO9515'
update c_Assessment_Definition SET last_updated=getdate(), description ='Problems related to unwanted pregnancy' where assessment_id = 'DEMO9503'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prolapse and hernia of left ovary and fallopian tube' where assessment_id = 'DEMO800'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prolonged first stage (of labor)' where assessment_id = 'DEMO1038'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prolonged pregnancy' where assessment_id = 'DEMO10185'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prolonged second stage (of labor)' where assessment_id = 'DEMO1040'
update c_Assessment_Definition SET last_updated=getdate(), description ='Protozoal diseases complicating the puerperium' where assessment_id = 'DEMO10765'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prurigo nodularis' where assessment_id = 'DEMO5112'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pseudocyst of pancreas' where assessment_id = 'DEMO8073'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pseudosarcomatous fibromatosis' where assessment_id = 'DEMO3812'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pulmonary anthrax' where assessment_id = 'DEMO4089'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pulmonary heart disease, unspecified' where assessment_id = 'DEMO1570a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pulmonary mycobacterial infection' where assessment_id = 'DEMO4110'
update c_Assessment_Definition SET last_updated=getdate(), description ='Puncture wound with foreign body of nose, initial encounter' where assessment_id = 'DEMO210A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyemic and septic embolism in childbirth' where assessment_id = 'DEMO11250'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyemic and septic embolism in pregnancy, third trimester' where assessment_id = 'DEMO11252'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyemic and septic embolism in pregnancy, unspecified trimester' where assessment_id = 'DEMO1097'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyemic and septic embolism in the puerperium' where assessment_id = 'DEMO11251'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyothorax with fistula' where assessment_id = 'DEMO7765'
update c_Assessment_Definition SET last_updated=getdate(), description ='Qualitative platelet defects' where assessment_id = 'DEMO7498'
update c_Assessment_Definition SET last_updated=getdate(), description ='Radial styloid tenosynovitis [de Quervain]' where assessment_id = 'TENFIG'
update c_Assessment_Definition SET last_updated=getdate(), description ='Radiculopathy, cervicothoracic region' where assessment_id = 'DEMO98'
update c_Assessment_Definition SET last_updated=getdate(), description ='Radiculopathy, lumbosacral region' where assessment_id = 'DEMO10084'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rash and other nonspecific skin eruption' where assessment_id = 'PUST'
update c_Assessment_Definition SET last_updated=getdate(), description ='Reiter''s disease, unspecified site' where assessment_id = 'DEMO3663'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal and perinephric abscess' where assessment_id = 'DEMO6976'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal failure following (induced) termination of pregnancy' where assessment_id = 'DEMO443x2b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal failure following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x2'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal sclerosis, unspecified' where assessment_id = 'DEMO8957'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renovascular hypertension' where assessment_id = 'DEMO10542'
update c_Assessment_Definition SET last_updated=getdate(), description ='Residual hemorrhoidal skin tags' where assessment_id = 'DEMO1951'
update c_Assessment_Definition SET last_updated=getdate(), description ='Residual ovary syndrome' where assessment_id = 'DEMO807'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to other single specified antibiotic' where assessment_id = 'DEMO1472'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to other specified beta lactam antibiotics' where assessment_id = 'DEMO1471'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to quinolones and fluoroquinolones' where assessment_id = 'DEMO9416'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to unspecified antimicrobial drugs' where assessment_id = 'DEMO623'
update c_Assessment_Definition SET last_updated=getdate(), description ='Restlessness and agitation' where assessment_id = 'DEMO9776'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Retained (nonmagnetic) (old) foreign body in iris or ciliary body, unspecified eye' where assessment_id = 'DEMO5315'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retained (old) magnetic foreign body in iris or ciliary body, unspecified eye' where assessment_id = 'DEMO5305'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retained placenta without hemorrhage' where assessment_id = 'DEMO11146'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retained portions of placenta and membranes, without hemorrhage' where assessment_id = 'DEMO1069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retracted nipple associated with lactation' where assessment_id = 'DEMO11300'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retracted nipple associated with pregnancy, third trimester' where assessment_id = 'DEMO11299'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retropharyngeal and parapharyngeal abscess' where assessment_id = 'DEMO4918'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rheumatic disorders of both mitral and aortic valves' where assessment_id = 'DEMO1639'
update c_Assessment_Definition SET last_updated=getdate(), description ='Right aortic arch' where assessment_id = 'DEMO2047'
update c_Assessment_Definition SET last_updated=getdate(), description ='Right aortic arch' where assessment_id = 'DEMO2049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rupture of uterus before onset of labor, third trimester' where assessment_id = 'DEMO11104'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rupture of uterus during labor' where assessment_id = 'DEMO1057'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sacrococcygeal disorders, not elsewhere classified' where assessment_id = 'DEMO10496'
update c_Assessment_Definition SET last_updated=getdate(), description ='Salpingitis and oophoritis, unspecified' where assessment_id = 'DEMO752'
update c_Assessment_Definition SET last_updated=getdate(), description ='Scar conditions and fibrosis of skin' where assessment_id = 'HEALS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Schizoid personality disorder' where assessment_id = 'DEMO9685'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sclerodactyly' where assessment_id = 'DEMO10400'
update c_Assessment_Definition SET last_updated=getdate(), description ='Seborrheic dermatitis, unspecified' where assessment_id = 'DEMO10144'
update c_Assessment_Definition SET last_updated=getdate(), description ='Second degree perineal laceration during delivery' where assessment_id = 'DEMO1050'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary syphilitic oculopathy' where assessment_id = 'DEMO4349'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sensorineural hearing loss, bilateral' where assessment_id = 'DEMO6913'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sepsis following (induced) termination of pregnancy' where assessment_id = 'DEMO10468'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sepsis following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO874'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sepsis following ectopic and molar pregnancy' where assessment_id = 'DEMO880'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sepsis, unspecified organism' where assessment_id = '981^995.91^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Shock during or following labor and delivery' where assessment_id = 'DEMO1076'
update c_Assessment_Definition SET last_updated=getdate(), description ='Shock following (induced) termination of pregnancy' where assessment_id = 'DEMO443x6b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Shock following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x6'
update c_Assessment_Definition SET last_updated=getdate(), description ='Short rib syndrome' where assessment_id = 'DEMO6271'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sickle-cell disease without crisis' where assessment_id = 'SICKLECELL'
update c_Assessment_Definition SET last_updated=getdate(), description ='Single liveborn infant, delivered vaginally' where assessment_id = 'DEMO1191'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sinus, fistula and cyst of branchial cleft' where assessment_id = 'DEMO5776'
update c_Assessment_Definition SET last_updated=getdate(), description ='Situs inversus' where assessment_id = 'DEMO6089'
update c_Assessment_Definition SET last_updated=getdate(), description ='Skin transplant status' where assessment_id = 'DEMO9075'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sleep apnea, unspecified' where assessment_id = '0^11976'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sleep disorder, unspecified' where assessment_id = 'DEMO10097'
update c_Assessment_Definition SET last_updated=getdate(), description ='Smallpox' where assessment_id = 'DEMO4177'
update c_Assessment_Definition SET last_updated=getdate(), description ='Smoking (tobacco) complicating the puerperium' where assessment_id = '0^649.02^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Somatoform disorder, unspecified' where assessment_id = 'DEMO10110'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spastic diplegic cerebral palsy' where assessment_id = '0^12142'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spastic hemiplegic cerebral palsy' where assessment_id = 'DEMO7280'
update c_Assessment_Definition SET last_updated=getdate(), description ='Specific developmental disorder of motor function' where assessment_id = 'DEMO9680'
update c_Assessment_Definition SET last_updated=getdate(), description ='Specific reading disorder' where assessment_id = 'DEMO9820'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spinal muscular atrophy, unspecified' where assessment_id = 'DEMO7238'
update c_Assessment_Definition SET last_updated=getdate(), description ='Splenomegaly, not elsewhere classified' where assessment_id = '0^11632'
update c_Assessment_Definition SET last_updated=getdate(), description ='Split foot, unspecified lower limb' where assessment_id = 'ABTOE'
update c_Assessment_Definition SET last_updated=getdate(), description ='Splitting of urinary stream' where assessment_id = 'DEMO1266'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spondylopathy, unspecified' where assessment_id = 'DEMO3695'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spondylosis without myelopathy or radiculopathy, site unspecified' where assessment_id = 'DEMO10086'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spontaneous ecchymoses' where assessment_id = 'ECC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spotted fever due to Rickettsia rickettsii' where assessment_id = 'DEMO10410'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spotting complicating pregnancy, third trimester' where assessment_id = '0^649.51^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sprain of other parts of lumbar spine and pelvis, initial encounter' where assessment_id = 'DEMO131'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Sprain of other specified parts of unspecified shoulder girdle, initial encounter' where assessment_id = 'DEMO2713'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='ST elevation (STEMI) myocardial infarction involving other coronary artery of anterior wall' where assessment_id = 'DEMO1684'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='ST elevation (STEMI) myocardial infarction involving other coronary artery of inferior wall' where assessment_id = 'DEMO1697'
update c_Assessment_Definition SET last_updated=getdate(), description ='ST elevation (STEMI) myocardial infarction involving other sites' where assessment_id = 'DEMO1702'
update c_Assessment_Definition SET last_updated=getdate(), description ='ST elevation (STEMI) myocardial infarction involving right coronary artery' where assessment_id = 'DEMO1676'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stereotyped movement disorders' where assessment_id = 'DEMO9756'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stiffness of unspecified joint, not elsewhere classified' where assessment_id = 'DEMO3670'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Strain of other muscle(s) and tendon(s) at lower leg level, unspecified leg, initial encounter' where assessment_id = 'DEMO2750'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Strain of other muscles, fascia and tendons at shoulder and upper arm level, unspecified arm, initial encounter' where assessment_id = 'DEMO2719'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Strain of unspecified muscle(s) and tendon(s) at lower leg level, unspecified leg, initial encounter' where assessment_id = 'DEMO2746'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Strain of unspecified muscles, fascia and tendons at thigh level, unspecified thigh, initial encounter' where assessment_id = 'DEMO2742'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stress incontinence (female) (male)' where assessment_id = 'DEMO1259'
update c_Assessment_Definition SET last_updated=getdate(), description ='Subacute and chronic vulvitis' where assessment_id = 'DEMO773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body of unspecified finger, initial encounter' where assessment_id = 'DEMO3057'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body of unspecified hand, initial encounter' where assessment_id = 'DEMO3048'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body of unspecified part of neck, initial encounter' where assessment_id = 'DEMO3002'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body of unspecified upper arm, initial encounter' where assessment_id = 'DEMO3019'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body of unspecified wrist, initial encounter' where assessment_id = 'DEMO3028'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body, unspecified ankle, initial encounter' where assessment_id = 'DEMO11123'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial foreign body, unspecified foot, initial encounter' where assessment_id = 'DEMO3076'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial thrombophlebitis in pregnancy, third trimester' where assessment_id = 'DEMO11211'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superficial thrombophlebitis in the puerperium' where assessment_id = 'DEMO11212'
update c_Assessment_Definition SET last_updated=getdate(), description ='Supervision of elderly multigravida, third trimester' where assessment_id = 'DEMO11004'
update c_Assessment_Definition SET last_updated=getdate(), description ='Supervision of elderly primigravida, third trimester' where assessment_id = 'DEMO11002'
update c_Assessment_Definition SET last_updated=getdate(), description ='Supervision of pregnancy with grand multiparity, third trimester' where assessment_id = 'DEMO11000'
update c_Assessment_Definition SET last_updated=getdate(), description ='Supervision of pregnancy with grand multiparity, unspecified trimester' where assessment_id = 'DEMO1013'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Supervision of pregnancy with other poor reproductive or obstetric history, first trimester' where assessment_id = 'DEMO1130'
update c_Assessment_Definition SET last_updated=getdate(), description ='Suppressed lactation' where assessment_id = 'DEMO11320'
update c_Assessment_Definition SET last_updated=getdate(), description ='Supravalvular aortic stenosis' where assessment_id = 'DEMO6008'
update c_Assessment_Definition SET last_updated=getdate(), description ='Swan-neck deformity of unspecified finger(s)' where assessment_id = 'DEMO3961'
update c_Assessment_Definition SET last_updated=getdate(), description ='Symptomatic postprocedural ovarian failure' where assessment_id = 'DEMO4697'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syndactyly, unspecified' where assessment_id = 'DEMO6158'
update c_Assessment_Definition SET last_updated=getdate(), description ='Synovial cyst of popliteal space [Baker], unspecified knee' where assessment_id = 'BC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Synovitis and tenosynovitis, unspecified' where assessment_id = 'DEMO3773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilis complicating the puerperium' where assessment_id = 'DEMO10748'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilis of other musculoskeletal tissue' where assessment_id = 'DEMO4384'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilitic endocarditis' where assessment_id = 'DEMO4360'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Systemic inflammatory response syndrome (SIRS) of non-infectious origin with acute organ dysfunction' where assessment_id = '981^995.94^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Systemic involvement of connective tissue, unspecified' where assessment_id = 'DEMO4830'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tension-type headache, unspecified, not intractable' where assessment_id = '981^339.10^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Third [oculomotor] nerve palsy, unspecified eye' where assessment_id = 'DEMO6579'
update c_Assessment_Definition SET last_updated=getdate(), description ='Third degree perineal laceration during delivery, IIIc' where assessment_id = 'DEMO1051'
update c_Assessment_Definition SET last_updated=getdate(), description ='Third-stage hemorrhage' where assessment_id = 'DEMO11136'
update c_Assessment_Definition SET last_updated=getdate(), description ='Threatened abortion' where assessment_id = '000199x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thromboembolism in the puerperium' where assessment_id = 'DEMO11247'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thyrotoxicosis with toxic multinodular goiter with thyrotoxic crisis or storm' where assessment_id = 'DEMO4609'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thyrotoxicosis with toxic multinodular goiter without thyrotoxic crisis or storm' where assessment_id = 'DEMO178'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tinnitus, unspecified ear' where assessment_id = 'DEMO6936'
update c_Assessment_Definition SET last_updated=getdate(), description ='Torsion of ovary, ovarian pedicle and fallopian tube' where assessment_id = 'DEMO802'
update c_Assessment_Definition SET last_updated=getdate(), description ='Total anomalous pulmonary venous connection' where assessment_id = 'DEMO2069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Total retinal detachment, unspecified eye' where assessment_id = 'DEMO5331'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of corrosive acids and acid-like substances, undetermined, initial encounter' where assessment_id = 'DEMO3272'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of corrosive alkalis and alkali-like substances, undetermined, initial encounter' where assessment_id = 'DEMO3275'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxic effect of lead and its compounds, undetermined, initial encounter' where assessment_id = 'DEMO3258'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of organophosphate and carbamate insecticides, undetermined, initial encounter' where assessment_id = 'DEMO3301'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of other specified gases, fumes and vapors, accidental (unintentional), initial encounter' where assessment_id = 'DEMO3286'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxic effect of petroleum products, undetermined, initial encounter' where assessment_id = 'DEMO3262'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxic effect of strychnine and its salts, undetermined, initial encounter' where assessment_id = 'DEMO3297'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of unspecified gases, fumes and vapors, undetermined, initial encounter' where assessment_id = 'DEMO3293'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Toxic effect of unspecified halogen derivatives of aliphatic and aromatic hydrocarbons, accidental (unintentional), initial encounter' where assessment_id = 'DEMO3299'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxoplasmosis with other organ involvement' where assessment_id = 'DEMO4546'
update c_Assessment_Definition SET last_updated=getdate(), description ='Transsexualism' where assessment_id = 'DEMO9706'
update c_Assessment_Definition SET last_updated=getdate(), description ='Traumatic arthropathy, unspecified site' where assessment_id = 'ARTT'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Traumatic hemorrhage of cerebrum, unspecified, without loss of consciousness, initial encounter' where assessment_id = 'DEMO10292'
update c_Assessment_Definition SET last_updated=getdate(), description ='Traumatic rupture of unspecified ear drum, initial encounter' where assessment_id = 'TMPERF'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Triplet pregnancy, unspecified number of placenta and unspecified number of amniotic sacs, third trimester' where assessment_id = 'DEMO10828'
update c_Assessment_Definition SET last_updated=getdate(), description ='Trisomy 13, unspecified' where assessment_id = 'DEMO6075'
update c_Assessment_Definition SET last_updated=getdate(), description ='Trisomy 18, unspecified' where assessment_id = 'DEMO6076'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculoma of brain and spinal cord' where assessment_id = 'DEMO4046'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis complicating the puerperium' where assessment_id = 'DEMO10761'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of kidney and ureter' where assessment_id = 'DEMO4060'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of larynx, trachea and bronchus' where assessment_id = 'DEMO4036'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of lung' where assessment_id = 'DEMO4006'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of other bones' where assessment_id = 'DEMO4056'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous arthritis of other joints' where assessment_id = 'DEMO4054'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous peripheral lymphadenopathy' where assessment_id = 'DEMO4004'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Twin pregnancy, unspecified number of placenta and unspecified number of amniotic sacs, third trimester' where assessment_id = 'DEMO10826'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tympanosclerosis, unspecified ear' where assessment_id = 'DEMO6863'
update c_Assessment_Definition SET last_updated=getdate(), description ='Type 1 diabetes mellitus with hyperglycemia' where assessment_id = 'DEMO4637'
update c_Assessment_Definition SET last_updated=getdate(), description ='Type 1 diabetes mellitus with other specified complication' where assessment_id = 'DEMO4639'
update c_Assessment_Definition SET last_updated=getdate(), description ='Type 1 diabetes mellitus with unspecified complications' where assessment_id = 'DEMO4662'
update c_Assessment_Definition SET last_updated=getdate(), description ='Type 2 diabetes mellitus with hyperglycemia' where assessment_id = 'DEMO4632'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Type 2 diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema, unspecified eye' where assessment_id = '0^12005'
update c_Assessment_Definition SET last_updated=getdate(), description ='Type 2 diabetes mellitus with unspecified complications' where assessment_id = 'DEMO4661'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unavailability and inaccessibility of health-care facilities' where assessment_id = 'DEMO9516'
update c_Assessment_Definition SET last_updated=getdate(), description ='Underimmunization status' where assessment_id = '981^V15.83^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Undescended testicle, unspecified' where assessment_id = 'CRY'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified abdominal hernia without obstruction or gangrene' where assessment_id = 'DEMO7883'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified abdominal pain' where assessment_id = 'COLIC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified abnormal finding in specimens from other organs, systems and tissues' where assessment_id = 'DEMO11387'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified abnormal findings on antenatal screening of mother' where assessment_id = 'DEMO1291'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified abnormal involuntary movements' where assessment_id = 'DEMO2103'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified acquired deformity of unspecified lower leg' where assessment_id = 'DEMO3966'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified anomaly of jaw-cranial base relationship' where assessment_id = 'DEMO7624'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified atrial fibrillation' where assessment_id = '0^11767'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified behavioral syndromes associated with physiological disturbances and physical factors' where assessment_id = 'DEMO9752'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified chronic gastritis without bleeding' where assessment_id = 'DEMO7796'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified cleft palate with bilateral cleft lip' where assessment_id = 'DEMO5826'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified cleft palate with unilateral cleft lip' where assessment_id = 'CLEFT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified complication following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO443x9'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified complication of cardiac and vascular prosthetic device, implant and graft, initial encounter' where assessment_id = 'DEMO3367'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified complication of internal orthopedic prosthetic device, implant and graft, initial encounter' where assessment_id = 'DEMO3370'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified congenital malformation of limb(s)' where assessment_id = 'DEMO6204'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified contact dermatitis due to drugs in contact with skin' where assessment_id = 'DEMO10401'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified contact dermatitis due to other agents' where assessment_id = 'DEMO5090'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified contact dermatitis, unspecified cause' where assessment_id = 'DEMO10636'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dementia without behavioral disturbance' where assessment_id = 'DEMO9565'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified diabetes mellitus in the puerperium' where assessment_id = 'DEMO10787'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified dislocation of unspecified acromioclavicular joint, initial encounter' where assessment_id = 'DEMO2547'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified finger, initial encounter' where assessment_id = 'DEMO2561'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified foot, initial encounter' where assessment_id = 'DEMO2603'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified hip, initial encounter' where assessment_id = 'DEMO2565'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified knee, initial encounter' where assessment_id = 'DEMO2597'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified patella, initial encounter' where assessment_id = 'DEMO2596'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified shoulder joint, initial encounter' where assessment_id = 'DEMO2543'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified sternoclavicular joint, initial encounter' where assessment_id = 'DEMO2628'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified ulnohumeral joint, initial encounter' where assessment_id = 'DEMO2549'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified dislocation of unspecified wrist and hand, initial encounter' where assessment_id = 'DEMO2581'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified disorders of lactation' where assessment_id = 'DEMO1119'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified disseminated chorioretinal inflammation, unspecified eye' where assessment_id = 'CHORIO'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified disturbances of skin sensation' where assessment_id = '0^12296'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of facial bones, initial encounter for closed fracture' where assessment_id = 'DEMO2204'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of facial bones, initial encounter for open fracture' where assessment_id = 'DEMO2210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of left forearm, initial encounter for closed fracture' where assessment_id = 'DEMO2456'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of left forearm, initial encounter for open fracture type I or II' where assessment_id = 'DEMO2453'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of left lower leg, initial encounter for closed fracture' where assessment_id = 'DEMO2532'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of left lower leg, initial encounter for open fracture type I or II' where assessment_id = 'DEMO2538'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of lower end of unspecified ulna, initial encounter for closed fracture' where assessment_id = 'DEMO2399'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of lower end of unspecified ulna, initial encounter for open fracture type IIIA, IIIB, or IIIC' where assessment_id = 'DEMO2404'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of shaft of left fibula, initial encounter for closed fracture' where assessment_id = 'DEMO2496'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of shaft of left fibula, initial encounter for open fracture type I or II' where assessment_id = 'DEMO2501'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of shaft of unspecified radius, initial encounter for closed fracture' where assessment_id = 'DEMO2391'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of shaft of unspecified radius, initial encounter for open fracture type IIIA, IIIB, or IIIC' where assessment_id = 'DEMO2395'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of shaft of unspecified ulna, initial encounter for open fracture type IIIA, IIIB, or IIIC' where assessment_id = 'DEMO2394'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of skull, initial encounter for closed fracture' where assessment_id = 'DEMO2212'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified fracture of skull, initial encounter for open fracture' where assessment_id = 'DEMO2220'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of unspecified wrist and hand, initial encounter for closed fracture' where assessment_id = 'DEMO159'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified fracture of unspecified wrist and hand, initial encounter for open fracture' where assessment_id = 'DEMO2451'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified genitourinary tract infection in pregnancy, third trimester' where assessment_id = 'DEMO10732'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified genitourinary tract infection in pregnancy, unspecified trimester' where assessment_id = 'DEMO920'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury at C4 level of cervical spinal cord, initial encounter' where assessment_id = 'DEMO3175'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury at C7 level of cervical spinal cord, initial encounter' where assessment_id = 'DEMO6833'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury at T11-T12 level of thoracic spinal cord, initial encounter' where assessment_id = 'DEMO3178'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury at T2-T6 level of thoracic spinal cord, initial encounter' where assessment_id = 'DEMO3177'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of axillary or brachial vein, unspecified side, initial encounter' where assessment_id = 'DEMO2930'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of branches of celiac and mesenteric artery, initial encounter' where assessment_id = 'DEMO2902'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of ear, initial encounter' where assessment_id = 'DEMO205'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of face, initial encounter' where assessment_id = 'DEMO381'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of femoral artery, unspecified leg, initial encounter' where assessment_id = 'DEMO2936'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of head, initial encounter' where assessment_id = 'DEMO2819'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of inferior vena cava, initial encounter' where assessment_id = 'DEMO2900'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of other blood vessels at abdomen, lower back and pelvis level, initial encounter' where assessment_id = 'DEMO2913'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of other blood vessels at lower leg level, unspecified leg, initial encounter' where assessment_id = 'DEMO2946'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of other blood vessels of thorax, unspecified side, initial encounter' where assessment_id = 'DEMO2895'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of popliteal vein, unspecified leg, initial encounter' where assessment_id = 'DEMO2941'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of superior mesenteric artery, initial encounter' where assessment_id = 'DEMO2906'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of superior vena cava, initial encounter' where assessment_id = 'DEMO2889'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified injury of unspecified blood vessel at ankle and foot level, unspecified leg, sequela' where assessment_id = 'DEMO2993'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified carotid artery, initial encounter' where assessment_id = 'DEMO2879'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified eye and orbit, initial encounter' where assessment_id = 'DEMO2800'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified middle and inner ear, initial encounter' where assessment_id = 'DEMO2085A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified pulmonary blood vessels, initial encounter' where assessment_id = 'DEMO2891'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified renal vein, initial encounter' where assessment_id = 'DEMO2915'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury of unspecified wrist, hand and finger(s), initial encounter' where assessment_id = 'DEMO3224'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified injury to sacral spinal cord, initial encounter' where assessment_id = 'DEMO2283'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified internal derangement of unspecified knee' where assessment_id = 'DEMO3645'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified iridocyclitis' where assessment_id = 'DEMO312'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified maternal hypertension, third trimester' where assessment_id = 'DEMO10685'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified maternal hypertension, unspecified trimester' where assessment_id = 'DEMO903'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified maternal infectious and parasitic disease complicating pregnancy, unspecified trimester' where assessment_id = 'DEMO931'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified maternal infectious and parasitic disease complicating the puerperium' where assessment_id = 'DEMO10783'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified mood [affective] disorder' where assessment_id = 'DEMO9638'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified nephritic syndrome with unspecified morphologic changes' where assessment_id = 'DEMO5188'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified open wound of abdominal wall, unspecified quadrant without penetration into peritoneal cavity, sequela' where assessment_id = 'DEMO2962'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified open wound of lower back and pelvis without penetration into retroperitoneum, initial encounter' where assessment_id = 'DEMO10052'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of other part of head, initial encounter' where assessment_id = 'DEMO209'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of trachea, initial encounter' where assessment_id = 'DEMO2820'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified open wound of unspecified cheek and temporomandibular area, initial encounter' where assessment_id = 'DEMO2811'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of unspecified ear, initial encounter' where assessment_id = 'DEMO2801'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of unspecified shoulder, initial encounter' where assessment_id = 'DEMO2837'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified open wound of unspecified toe(s) without damage to nail, initial encounter' where assessment_id = 'AVULS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of unspecified upper arm, initial encounter' where assessment_id = 'DEMO2840'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound of vagina and vulva, initial encounter' where assessment_id = 'DEMO2831'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound, unspecified ankle, initial encounter' where assessment_id = 'DEMO2861'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound, unspecified hip, initial encounter' where assessment_id = 'DEMO2864'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified open wound, unspecified thigh, initial encounter' where assessment_id = 'DEMO2859'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified osteoarthritis, unspecified site' where assessment_id = '0^12146'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified parametritis and pelvic cellulitis' where assessment_id = 'DEMO756'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified placental disorder, third trimester' where assessment_id = 'DEMO10964'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified pre-eclampsia, unspecified trimester' where assessment_id = 'PRE'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Unspecified pre-existing hypertension complicating pregnancy, unspecified trimester' where assessment_id = 'DEMO10345'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified protozoal disease' where assessment_id = 'DEMO4327'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified purulent endophthalmitis, unspecified eye' where assessment_id = 'DEMO5284'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified reduction defect of unspecified upper limb' where assessment_id = 'DEMO6163'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified sensorineural hearing loss' where assessment_id = 'HEARSENS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified severe protein-calorie malnutrition' where assessment_id = 'DEMO4718'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified ankle, initial encounter' where assessment_id = 'DEMO3069'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified finger, initial encounter' where assessment_id = 'DEMO3059'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified hand, initial encounter' where assessment_id = 'DEMO3050'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified lesser toe(s), initial encounter' where assessment_id = 'DEMO3078'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified upper arm, initial encounter' where assessment_id = 'DEMO3021'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified superficial injury of unspecified wrist, initial encounter' where assessment_id = 'DEMO3030'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified thoracic, thoracolumbar and lumbosacral intervertebral disc disorder' where assessment_id = 'DEMO3700'
-- update c_Assessment_Definition SET last_updated=getdate(), description ='UPDATE' where assessment_id = 'DEMO5160'
update c_Assessment_Definition SET last_updated=getdate(), description ='Urethral caruncle' where assessment_id = 'DEMO7049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Urethral stricture, unspecified' where assessment_id = 'DEMO7046'
update c_Assessment_Definition SET last_updated=getdate(), description ='Urticaria due to cold and heat' where assessment_id = 'DEMO11351'
update c_Assessment_Definition SET last_updated=getdate(), description ='Variations in hair color' where assessment_id = 'DEMO5127'
update c_Assessment_Definition SET last_updated=getdate(), description ='Varicose veins of lower extremity in pregnancy, third trimester' where assessment_id = 'DEMO11203'
update c_Assessment_Definition SET last_updated=getdate(), description ='Varicose veins of lower extremity in the puerperium' where assessment_id = 'DEMO11204'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vascular dementia with behavioral disturbance' where assessment_id = 'DEMO9574'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vascular disorders of male genital organs' where assessment_id = 'DEMO7118'
update c_Assessment_Definition SET last_updated=getdate(), description ='Venous complication in pregnancy, unspecified, third trimester' where assessment_id = 'DEMO11220'
update c_Assessment_Definition SET last_updated=getdate(), description ='Venous complication in pregnancy, unspecified, unspecified trimester' where assessment_id = 'DEMO1091'
update c_Assessment_Definition SET last_updated=getdate(), description ='Venous complication in the puerperium, unspecified' where assessment_id = 'DEMO11229'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vertebro-basilar artery syndrome' where assessment_id = 'DEMO10424'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vesical fistula, not elsewhere classified' where assessment_id = 'DEMO7018'
update c_Assessment_Definition SET last_updated=getdate(), description ='Villonodular synovitis (pigmented), unspecified knee' where assessment_id = '0^12250'
update c_Assessment_Definition SET last_updated=getdate(), description ='Viral pneumonia, unspecified' where assessment_id = 'PNEV'
update c_Assessment_Definition SET last_updated=getdate(), description ='Visual agnosia' where assessment_id = 'DEMO5580'
update c_Assessment_Definition SET last_updated=getdate(), description ='Visual distortions of shape and size' where assessment_id = 'DEMO5574'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vitreoretinal dystrophy' where assessment_id = 'DEMO5388'
update c_Assessment_Definition SET last_updated=getdate(), description ='Zoster with other complications' where assessment_id = 'DEMO10170'
update c_Assessment_Definition SET last_updated=getdate(), description ='Zygomatic fracture, left side, initial encounter for closed fracture' where assessment_id = 'DEMO2199'
update c_Assessment_Definition SET last_updated=getdate(), description ='Zygomatic fracture, left side, initial encounter for open fracture' where assessment_id = 'DEMO2206'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal chest percussion', long_description='Abnormal chest percussion' where assessment_id = 'DEMO2126'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal electrophysiological intracardiac studies', long_description='Abnormal electrophysiological intracardiac studies' where assessment_id = 'DEMO2137'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal hemoglobin NOS', long_description='Abnormal hemoglobin NOS' where assessment_id = 'DEMO7449'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal palmar creases', long_description='Abnormal palmar creases' where assessment_id = 'DEMO6054'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal phonocardiogram', long_description='Abnormal phonocardiogram' where assessment_id = 'DEMO2138'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormal stool color', long_description='Abnormal stool color' where assessment_id = 'DEMO1254'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormality of thyroid-binding globulin', long_description='Abnormality of thyroid-binding globulin' where assessment_id = 'DEMO6116'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abnormality of white blood cells NEC', long_description='Abnormality of white blood cells NEC' where assessment_id = 'DEMO222'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess brain tuberculous', long_description='Abscess brain tuberculous ' where assessment_id = 'DEMO4048'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of larynx', long_description='Abscess of larynx' where assessment_id = 'DEMO4942'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of lips', long_description='Abscess of lips' where assessment_id = 'DEMO7691'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of unspecified male genital organ', long_description='Abscess of unspecified male genital organ' where assessment_id = 'DEMO7127'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess of vocal cords', long_description='Abscess of vocal cords' where assessment_id = 'DEMO4930'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess prostate gonococcal', long_description='Abscess prostate gonococcal' where assessment_id = 'DEMO4401'
update c_Assessment_Definition SET last_updated=getdate(), description ='Abscess spinal cord tuberculous', long_description='Abscess spinal cord tuberculous ' where assessment_id = 'DEMO4049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence of bronchus', long_description='Absence of bronchus' where assessment_id = 'DEMO5795'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence of diaphragm', long_description='Absence of diaphragm' where assessment_id = 'DEMO6284'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence of fallopian tube and broad ligament', long_description='Absence of fallopian tube and broad ligament' where assessment_id = 'DEMO5905'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence of part of brain', long_description='Absence of part of brain' where assessment_id = 'DEMO5699'
update c_Assessment_Definition SET last_updated=getdate(), description ='Absence of vena cava (inferior) (superior)', long_description='Absence of vena cava (inferior) (superior)' where assessment_id = 'DEMO2073'
update c_Assessment_Definition SET last_updated=getdate(), description ='AC globulin deficiency', long_description='AC globulin deficiency' where assessment_id = 'DEMO7480'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory carpal bones', long_description='Accessory carpal bones' where assessment_id = 'DEMO6208'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory fallopian tube and broad ligament', long_description='Accessory fallopian tube and broad ligament' where assessment_id = 'DEMO5908'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory liver', long_description='Accessory liver' where assessment_id = 'DEMO5889'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory nose', long_description='Accessory nose' where assessment_id = 'DEMO5790'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory pancreas', long_description='Accessory pancreas' where assessment_id = 'DEMO5898'
update c_Assessment_Definition SET last_updated=getdate(), description ='Accessory skin tags', long_description='Accessory skin tags' where assessment_id = 'DEMO6057'
update c_Assessment_Definition SET last_updated=getdate(), description ='Achlorhydria anemia', long_description='Achlorhydria anemia' where assessment_id = 'DEMO7417'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acrocyanosis', long_description='Acrocyanosis' where assessment_id = 'DEMO1896'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute crisis reaction', long_description='Acute crisis reaction' where assessment_id = 'DEMO9779'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute endophthalmitis', long_description='Acute endophthalmitis' where assessment_id = 'DEMO5282'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute or subacute brain syndrome', long_description='Acute or subacute brain syndrome' where assessment_id = 'DEMO9600'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute or subacute confusional state (nonalcoholic)', long_description='Acute or subacute confusional state (nonalcoholic)' where assessment_id = 'DEMO9570'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute or subacute infective psychosis', long_description='Acute or subacute infective psychosis' where assessment_id = 'DEMO9601'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute subendocardial myocardial infarction', long_description='Acute subendocardial myocardial infarction' where assessment_id = 'DEMO1703'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transmural myocardial infarction of anterior wall', long_description='Acute transmural myocardial infarction of anterior wall' where assessment_id = 'DEMO1663'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transmural myocardial infarction of inferior wall', long_description='Acute transmural myocardial infarction of inferior wall' where assessment_id = 'DEMO1665'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transmural myocardial infarction of other sites', long_description='Acute transmural myocardial infarction of other sites' where assessment_id = 'DEMO1660'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transverse myelitis NOS', long_description='Acute transverse myelitis NOS' where assessment_id = '0^341.20^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute transverse myelopathy', long_description='Acute transverse myelopathy' where assessment_id = '0^341.21^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Acute tubulo-interstitial nephritis', long_description='Acute tubulo-interstitial nephritis' where assessment_id = 'DEMO6975'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adenocarcinoma basal cell unspecififed site', long_description='Adenocarcinoma basal cell unspecififed site' where assessment_id = 'DEMO8438'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adenoma alveolar', long_description='Adenoma alveolar' where assessment_id = 'DEMO8541'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adenoma apocrine unspecified', long_description='Adenoma apocrine unspecified' where assessment_id = 'DEMO10449'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adenopathy tracheobronchial tuberculous primary', long_description='Adenopathy tracheobronchial tuberculous primary' where assessment_id = 'DEMO4007'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adherent placenta, without hemorrhage', long_description='Adherent placenta, without hemorrhage' where assessment_id = 'DEMO11147'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) abdominal (wall)', long_description='Adhesions (of) abdominal (wall)' where assessment_id = 'DEMO7936'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) diaphragm', long_description='Adhesions (of) diaphragm' where assessment_id = 'DEMO7937'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) intestine', long_description='Adhesions (of) intestine' where assessment_id = 'DEMO7938'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) male pelvis', long_description='Adhesions (of) male pelvis' where assessment_id = 'DEMO7939'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) omentum', long_description='Adhesions (of) omentum' where assessment_id = 'DEMO7940'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions (of) stomach', long_description='Adhesions (of) stomach' where assessment_id = 'DEMO7941'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions of biliary tract', long_description='Adhesions of biliary tract' where assessment_id = 'DEMO8065'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions of cystic duct or gallbladder', long_description='Adhesions of cystic duct or gallbladder' where assessment_id = 'DEMO8049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesions of vulva', long_description='Adhesions of vulva' where assessment_id = 'DEMO848'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adhesive bands', long_description='Adhesive bands' where assessment_id = 'DEMO7942'
update c_Assessment_Definition SET last_updated=getdate(), description ='Adiaspiromycosis', long_description='Adiaspiromycosis' where assessment_id = 'DEMO4493'
update c_Assessment_Definition SET last_updated=getdate(), description ='Affective psychosis NOS', long_description='Affective psychosis NOS' where assessment_id = 'DEMO9639'
update c_Assessment_Definition SET last_updated=getdate(), description ='Afibrinogenemia following (induced) termination of pregnancy', long_description='Afibrinogenemia following (induced) termination of pregnancy' where assessment_id = 'DEMO443q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Afibrinogenemia following complete or unspecified spontaneous abortion', long_description='Afibrinogenemia following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO876'
update c_Assessment_Definition SET last_updated=getdate(), description ='Afibrinogenemia, acquired', long_description='Afibrinogenemia, acquired' where assessment_id = 'DEMO7489'
update c_Assessment_Definition SET last_updated=getdate(), description ='African histoplasmosis', long_description='African histoplasmosis' where assessment_id = 'DEMO4478'
update c_Assessment_Definition SET last_updated=getdate(), description ='Agenesis of bronchus', long_description='Agenesis of bronchus' where assessment_id = 'DEMO5798'
update c_Assessment_Definition SET last_updated=getdate(), description ='Agenesis of nerve', long_description='Agenesis of nerve' where assessment_id = 'DEMO5712'
update c_Assessment_Definition SET last_updated=getdate(), description ='Agenesis of part of brain', long_description='Agenesis of part of brain' where assessment_id = 'DEMO5700'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aggressive personality (disorder)', long_description='Aggressive personality (disorder)' where assessment_id = 'DEMO9696'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aglossia', long_description='Aglossia' where assessment_id = 'DEMO5831'
update c_Assessment_Definition SET last_updated=getdate(), description ='Agraphia (absolute) with alexia', long_description='Agraphia (absolute) with alexia' where assessment_id = 'DEMO9821'
update c_Assessment_Definition SET last_updated=getdate(), description ='Air embolism following (induced) termination of pregnancy', long_description='Air embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO443x7q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Air embolism following complete or unspecified spontaneous abortion', long_description='Air embolism following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO877w7'
update c_Assessment_Definition SET last_updated=getdate(), description ='Akinesia', long_description='Akinesia' where assessment_id = '0^11620'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alagille''s syndrome', long_description='Alagille''s syndrome' where assessment_id = 'DEMO5890'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alastrim', long_description='Alastrim ' where assessment_id = 'DEMO4175'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alder syndrome', long_description='Alder syndrome' where assessment_id = 'DEMO7516'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alexia secondary to organic lesion', long_description='Alexia secondary to organic lesion' where assessment_id = 'DEMO2113'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alkalosis of newborn', long_description='Alkalosis of newborn' where assessment_id = 'DEMO6727'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergic eosinophilia', long_description='Allergic eosinophilia' where assessment_id = 'DEMO10376'
update c_Assessment_Definition SET last_updated=getdate(), description ='Allergy to shellfish', long_description='Allergy to shellfish' where assessment_id = 'DEMO10211'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alteration in sensation following unspecified cerebrovascular disease', long_description='Alteration in sensation following unspecified cerebrovascular disease' where assessment_id = 'DEMO10063'
update c_Assessment_Definition SET last_updated=getdate(), description ='Alternating esotropia with x and/or y pattern', long_description='Alternating esotropia with x and/or y pattern' where assessment_id = 'DEMO6556'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ambiguous genitalia', long_description='Ambiguous genitalia' where assessment_id = 'DEMO5928'
update c_Assessment_Definition SET last_updated=getdate(), description ='Amelogenesis imperfecta', long_description='Amelogenesis imperfecta' where assessment_id = 'DEMO7581'
update c_Assessment_Definition SET last_updated=getdate(), description ='Amniotic fluid embolism following (induced) termination of pregnancy', long_description='Amniotic fluid embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO443x7r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Amyotrophia congenita', long_description='Amyotrophia congenita' where assessment_id = 'DEMO6049'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anal intraepithelial neoplasia III [AIN III]', long_description='Anal intraepithelial neoplasia III [AIN III]' where assessment_id = 'DEMO8906'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ancylostoma (braziliense)', long_description='Ancylostoma (braziliense)' where assessment_id = 'DEMO4528'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Anemia (due to) enzyme deficiencies, except G6PD, related to the hexose monophosphate [HMP] shunt pathway' where assessment_id = 'DEMO7430'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia (due to) hemolytic nonspherocytic (hereditary), type I', long_description='Anemia (due to) hemolytic nonspherocytic (hereditary), type I' where assessment_id = 'DEMO7431'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia hemolytic nonspherocytic congenital or hereditary NEC', long_description='Anemia hemolytic nonspherocytic congenital or hereditary NEC' where assessment_id = 'DEMO7432'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia myelogenous', long_description='Anemia myelogenous ' where assessment_id = 'DEMO7472'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia myeloproliferative', long_description='Anemia myeloproliferative ' where assessment_id = '0^238.79^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anemia von Jaksch''s', long_description='Anemia von Jaksch''s ' where assessment_id = 'DEMO7473'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm celiac', long_description='Aneurysm celiac' where assessment_id = 'DEMO1883'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm gastroduodenal', long_description='Aneurysm gastroduodenal' where assessment_id = 'DEMO1886'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm gastroepiploic', long_description='Aneurysm gastroepiploic' where assessment_id = 'DEMO1889'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm hepatic', long_description='Aneurysm hepatic' where assessment_id = 'DEMO1884'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm mediastinal (nonsyphilitic)', long_description='Aneurysm mediastinal (nonsyphilitic)' where assessment_id = 'DEMO1887'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm Rasmussen NEC', long_description='Aneurysm Rasmussen NEC ' where assessment_id = 'DEMO4024'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm spinal (cord)', long_description='Aneurysm spinal (cord)' where assessment_id = 'DEMO1888'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm splenic', long_description='Aneurysm splenic' where assessment_id = 'DEMO1882'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysm superior mesenteric', long_description='Aneurysm superior mesenteric ' where assessment_id = 'DEMO1885'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aneurysmal cyst of jaw', long_description='Aneurysmal cyst of jaw' where assessment_id = 'DEMO7658'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anginal syndrome', long_description='Anginal syndrome' where assessment_id = 'DEMO10467'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anisocoria, congenital', long_description='Anisocoria, congenital' where assessment_id = 'DEMO5742'
update c_Assessment_Definition SET last_updated=getdate(), description ='Annular detachment of cervix', long_description='Annular detachment of cervix' where assessment_id = 'DEMO11109'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anteroapical transmural (Q wave) infarction (acute)', long_description='Anteroapical transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1663a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anterolateral transmural (Q wave) infarction (acute)', long_description='Anterolateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1663b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anteroseptal transmural (Q wave) infarction (acute)', long_description='Anteroseptal transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1673'
update c_Assessment_Definition SET last_updated=getdate(), description ='Anteversion of femoral neck', long_description='Anteversion of femoral neck' where assessment_id = 'HIPD'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aphakic glaucoma', long_description='Aphakic glaucoma' where assessment_id = 'DEMO5516'
update c_Assessment_Definition SET last_updated=getdate(), description ='Apical-lateral transmural (Q wave) infarction (acute)', long_description='Apical-lateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1664'
update c_Assessment_Definition SET last_updated=getdate(), description ='Arnold-Chiari syndrome, type IV', long_description='Arnold-Chiari syndrome, type IV' where assessment_id = 'DEMO5703'
update c_Assessment_Definition SET last_updated=getdate(), description ='Aspartylglucosaminuria', long_description='Aspartylglucosaminuria' where assessment_id = 'DEMO4773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Asphyxia antenatal', long_description='Asphyxia antenatal' where assessment_id = '0^775.81^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Asphyxia postnatal', long_description='Asphyxia postnatal' where assessment_id = '0^770.88^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Asphyxia prenatal', long_description='Asphyxia prenatal' where assessment_id = '0^770.88^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Asphyxiating thoracic dysplasia [Jeune]', long_description='Asphyxiating thoracic dysplasia [Jeune]' where assessment_id = 'DEMO6272'
update c_Assessment_Definition SET last_updated=getdate(), description ='Assmann''s focus NEC', long_description='Assmann''s focus NEC' where assessment_id = 'DEMO4025'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atherosclerosis of coronary artery bypass graft NOS', long_description='Atherosclerosis of coronary artery bypass graft NOS' where assessment_id = 'DEMO1629'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atonic (motor) (sensory) neuropathic bladder', long_description='Atonic (motor) (sensory) neuropathic bladder' where assessment_id = 'DEMO7026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atresia of bronchus', long_description='Atresia of bronchus' where assessment_id = 'DEMO5799'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atresia of fallopian tube and broad ligament', long_description='Atresia of fallopian tube and broad ligament' where assessment_id = 'DEMO5909'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atresia of pupil', long_description='Atresia of pupil' where assessment_id = 'DEMO5744'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atresia of salivary glands and ducts', long_description='Atresia of salivary glands and ducts' where assessment_id = 'DEMO5835'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy cervix', long_description='Atrophy cervix' where assessment_id = 'DEMO832'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of biliary tract', long_description='Atrophy of biliary tract' where assessment_id = 'DEMO8066'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of cystic duct or gallbladder', long_description='Atrophy of cystic duct or gallbladder' where assessment_id = 'DEMO8051'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of pancreas', long_description='Atrophy of pancreas' where assessment_id = 'DEMO8076'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of thymus', long_description='Atrophy of thymus' where assessment_id = 'DEMO4683'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of tongue', long_description='Atrophy of tongue' where assessment_id = 'DEMO7711'
update c_Assessment_Definition SET last_updated=getdate(), description ='Atrophy of uterus, acquired', long_description='Atrophy of uterus, acquired' where assessment_id = 'DEMO823'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Attempted application of vacuum or forceps, with subsequent delivery by forceps or cesarean delivery' where assessment_id = 'DEMO1029'
update c_Assessment_Definition SET last_updated=getdate(), description ='Attention-deficit hyperactivity disorder of childhood or adolescence NOS', long_description='Attention-deficit hyperactivity disorder of childhood or adolescence NOS' where assessment_id = 'ADDH'
update c_Assessment_Definition SET last_updated=getdate(), description ='Autogenous skin transplant status', long_description='Autogenous skin transplant status' where assessment_id = 'DEMO9087'
update c_Assessment_Definition SET last_updated=getdate(), description ='Back pain NOS', long_description='Back pain NOS' where assessment_id = 'DEMO10494'
update c_Assessment_Definition SET last_updated=getdate(), description ='Balanitis xerotica obliterans', long_description='Balanitis xerotica obliterans' where assessment_id = 'DEMO7117'
update c_Assessment_Definition SET last_updated=getdate(), description ='Basal-lateral transmural (Q wave) infarction (acute)', long_description='Basal-lateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1664a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bejel', long_description='Bejel' where assessment_id = 'DEMO4450'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign familial pemphigus [Hailey-Hailey]', long_description='Benign familial pemphigus [Hailey-Hailey]' where assessment_id = 'DEMO6058'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign mucous membrane pemphigoid', long_description='Benign mucous membrane pemphigoid' where assessment_id = 'DEMO10625'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of maxilla (superior)', long_description='Benign neoplasm of maxilla (superior)' where assessment_id = 'DEMO3526'
update c_Assessment_Definition SET last_updated=getdate(), description ='Benign neoplasm of seminal vesicle', long_description='Benign neoplasm of seminal vesicle' where assessment_id = 'DEMO8760'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bernard-Soulier [giant platelet] syndrome', long_description='Bernard-Soulier [giant platelet] syndrome' where assessment_id = 'DEMO7499'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bicuspid aortic valve', long_description='Bicuspid aortic valve' where assessment_id = 'DEMO76'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bifid tongue', long_description='Bifid tongue' where assessment_id = 'DEMO5833'
update c_Assessment_Definition SET last_updated=getdate(), description ='Birthmark NOS', long_description='Birthmark NOS' where assessment_id = 'VASC'
update c_Assessment_Definition SET last_updated=getdate(), description ='Black hairy tongue', long_description='Black hairy tongue' where assessment_id = 'DEMO78'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bleeding nipple', long_description='Bleeding nipple' where assessment_id = 'DEMO743'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blennorrhea', long_description='Blennorrhea ' where assessment_id = 'DEMO4397'
update c_Assessment_Definition SET last_updated=getdate(), description ='Blood-clot embolism following (induced) termination of pregnancy', long_description='Blood-clot embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877w7b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Boil of unspecified male genital organ', long_description='Boil of unspecified male genital organ' where assessment_id = 'DEMO7128'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bone spur NOS', long_description='Bone spur NOS' where assessment_id = 'DEMO10091'
update c_Assessment_Definition SET last_updated=getdate(), description ='Branchial vestige', long_description='Branchial vestige' where assessment_id = 'DEMO5777'
update c_Assessment_Definition SET last_updated=getdate(), description ='Breath-holding (spells)', long_description='Breath-holding (spells)' where assessment_id = 'PERIOD'
update c_Assessment_Definition SET last_updated=getdate(), description ='Bullous retinoschisis', long_description='Bullous retinoschisis' where assessment_id = 'DEMO5337'
update c_Assessment_Definition SET last_updated=getdate(), description ='C1 esterase inhibitor [C1-INH] deficiency', long_description='C1 esterase inhibitor [C1-INH] deficiency' where assessment_id = 'DEMO4810'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calcification of basal ganglia', long_description='Calcification of basal ganglia' where assessment_id = 'DEMO7209'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus in diverticulum of bladder', long_description='Calculus in diverticulum of bladder' where assessment_id = 'DEMO7004'
update c_Assessment_Definition SET last_updated=getdate(), description ='Calculus of pancreas', long_description='Calculus of pancreas' where assessment_id = 'DEMO8077'
update c_Assessment_Definition SET last_updated=getdate(), description ='Canal of Nuck cyst, congenital', long_description='Canal of Nuck cyst, congenital' where assessment_id = 'DEMO5918'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cancer associated pain', long_description='Cancer associated pain' where assessment_id = '0^338.3^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Candidal osteomyelitis', long_description='Candidal osteomyelitis' where assessment_id = 'DEMO636'
update c_Assessment_Definition SET last_updated=getdate(), description ='Capsulitis NOS', long_description='Capsulitis NOS' where assessment_id = 'DEMO10092'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of breast', long_description='Carbuncle of breast' where assessment_id = 'DEMO8993'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of gluteal region', long_description='Carbuncle of gluteal region' where assessment_id = 'DEMO5037'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carbuncle of unspecified male genital organ', long_description='Carbuncle of unspecified male genital organ' where assessment_id = 'DEMO7129'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of accessory sinuses', long_description='Carcinoma in situ of accessory sinuses' where assessment_id = 'DEMO8856'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of middle ear', long_description='Carcinoma in situ of middle ear' where assessment_id = 'DEMO8865'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carcinoma in situ of nasal cavities', long_description='Carcinoma in situ of nasal cavities' where assessment_id = 'DEMO8866'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cardiac arrest following obstetric surgery or procedures', long_description='Cardiac arrest following obstetric surgery or procedures' where assessment_id = 'DEMO11182'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cardiac dullness, increased or decreased', long_description='Cardiac dullness, increased or decreased' where assessment_id = 'DEMO2119'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cardiac failure following obstetric surgery or procedures', long_description='Cardiac failure following obstetric surgery or procedures' where assessment_id = 'DEMO11183'
update c_Assessment_Definition SET last_updated=getdate(), description ='Carditis (acute)(chronic)', long_description='Carditis (acute)(chronic)' where assessment_id = 'DEMO1803'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Care and observation in uncomplicated cases when the delivery occurs outside a healthcare facility' where assessment_id = 'DEMO1145'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cell membrane receptor complex [CR3] defect', long_description='Cell membrane receptor complex [CR3] defect' where assessment_id = 'DEMO7513'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of larynx', long_description='Cellulitis of larynx' where assessment_id = 'DEMO4939'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of lips', long_description='Cellulitis of lips' where assessment_id = 'DEMO100'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cellulitis of unspecified male genital organ', long_description='Cellulitis of unspecified male genital organ' where assessment_id = 'DEMO7130'
update c_Assessment_Definition SET last_updated=getdate(), description ='Central hearing loss NOS', long_description='Central hearing loss NOS' where assessment_id = '981^389.14^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cerebral anoxia following obstetric surgery or procedures', long_description='Cerebral anoxia following obstetric surgery or procedures' where assessment_id = 'DEMO11184'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cerebrovenous sinus thrombosis in the puerperium', long_description='Cerebrovenous sinus thrombosis in the puerperium' where assessment_id = 'DEMO11223'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cervical auricle', long_description='Cervical auricle' where assessment_id = 'DEMO5781'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cervicitis (acute) gonococcal', long_description='Cervicitis (acute) gonococcal' where assessment_id = 'DEMO4404'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cervicitis', long_description='Cervicitis ' where assessment_id = 'DEMO772'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cheese-washer''s lung', long_description='Cheese-washer''s lung' where assessment_id = 'DEMO4982'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chest tympany', long_description='Chest tympany' where assessment_id = 'DEMO1250'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chlamydial epididymitis', long_description='Chlamydial epididymitis' where assessment_id = 'DEMO4423'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chlorotic anemia', long_description='Chlorotic anemia' where assessment_id = 'DEMO7416'
update c_Assessment_Definition SET last_updated=getdate(), description ='Choledochoduodenal fistula', long_description='Choledochoduodenal fistula' where assessment_id = 'DEMO8062'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic (childhood) granulomatous disease', long_description='Chronic (childhood) granulomatous disease' where assessment_id = 'DEMO7514'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic appendicitis', long_description='Chronic appendicitis' where assessment_id = 'DEMO536'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic cardiopulmonary disease', long_description='Chronic cardiopulmonary disease' where assessment_id = 'DEMO1570'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic fibrous thyroiditis', long_description='Chronic fibrous thyroiditis' where assessment_id = 'DEMO4619'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic obstructive airway disease NOS', long_description='Chronic obstructive airway disease NOS' where assessment_id = 'COPD'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chronic urticaria', long_description='Chronic urticaria' where assessment_id = 'DEMO5151'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chylocele (nonfilarial)', long_description='Chylocele (nonfilarial)' where assessment_id = 'DEMO1967'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chylocele, tunica vaginalis (nonfilarial) NOS', long_description='Chylocele, tunica vaginalis (nonfilarial) NOS' where assessment_id = 'DEMO7139'
update c_Assessment_Definition SET last_updated=getdate(), description ='Chylous ascites', long_description='Chylous ascites' where assessment_id = 'DEMO1968'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cicatrix', long_description='Cicatrix' where assessment_id = 'DEMO5155'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cirrhosis of pancreas', long_description='Cirrhosis of pancreas' where assessment_id = 'DEMO8078'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cleidocranial dysostosis', long_description='Cleidocranial dysostosis' where assessment_id = 'DEMO6210'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coarctation of aorta (preductal) (postductal)', long_description='Coarctation of aorta (preductal) (postductal)' where assessment_id = 'DEMO2044'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coated tongue', long_description='Coated tongue' where assessment_id = 'DEMO7708'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coccygodynia', long_description='Coccygodynia' where assessment_id = 'DEMO107'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coffee-worker''s lung', long_description='Coffee-worker''s lung' where assessment_id = 'DEMO4983'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coitus, painful male', long_description='Coitus, painful male ' where assessment_id = 'DEMO10517'
update c_Assessment_Definition SET last_updated=getdate(), description ='Colitis regional infectious', long_description='Colitis regional infectious' where assessment_id = 'DEMO3886'
update c_Assessment_Definition SET last_updated=getdate(), description ='Colloid nodule (cystic) (thyroid)', long_description='Colloid nodule (cystic) (thyroid)' where assessment_id = 'DEMO4602'
update c_Assessment_Definition SET last_updated=getdate(), description ='Combat and operational stress reaction', long_description='Combat and operational stress reaction' where assessment_id = 'DEMO9780'
update c_Assessment_Definition SET last_updated=getdate(), description ='Combat fatigue', long_description='Combat fatigue' where assessment_id = 'DEMO9781'
update c_Assessment_Definition SET last_updated=getdate(), description ='Complex primary tuberculous', long_description='Complex primary tuberculous' where assessment_id = 'DEMO4008'
update c_Assessment_Definition SET last_updated=getdate(), description ='Concrescence of teeth', long_description='Concrescence of teeth' where assessment_id = 'DEMO7570'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conduct disorder, group type', long_description='Conduct disorder, group type' where assessment_id = 'DEMO9807'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conduct disorder, solitary aggressive type', long_description='Conduct disorder, solitary aggressive type' where assessment_id = 'DEMO9806'
update c_Assessment_Definition SET last_updated=getdate(), description ='Conductive deafness NOS', long_description='Conductive deafness NOS' where assessment_id = 'DEMO6911'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital (sternomastoid) torticollis', long_description='Congenital (sternomastoid) torticollis' where assessment_id = 'DEMO6127'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of esophagus', long_description='Congenital absence of esophagus' where assessment_id = 'DEMO5852'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of liver', long_description='Congenital absence of liver' where assessment_id = 'DEMO5891'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of lobe of ear', long_description='Congenital absence of lobe of ear' where assessment_id = 'DEMO5773'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of patella', long_description='Congenital absence of patella' where assessment_id = 'DEMO6221'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence of salivary glands and ducts', long_description='Congenital absence of salivary glands and ducts' where assessment_id = 'DEMO6028'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital absence or agenesis of cilia', long_description='Congenital absence or agenesis of cilia' where assessment_id = 'DEMO5755'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital accessory salivary glands and ducts', long_description='Congenital accessory salivary glands and ducts' where assessment_id = 'DEMO6035'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital acetabular dysplasia', long_description='Congenital acetabular dysplasia' where assessment_id = 'TORSFEM'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital adhesion of tongue', long_description='Congenital adhesion of tongue' where assessment_id = 'DEMO6004'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital afibrinogenemia', long_description='Congenital afibrinogenemia' where assessment_id = 'DEMO7478'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital anomaly of nasal sinus wall', long_description='Congenital anomaly of nasal sinus wall' where assessment_id = 'DEMO6253'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital asymmetric talipes', long_description='Congenital asymmetric talipes' where assessment_id = 'DEMO6150'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital blind loop syndrome', long_description='Congenital blind loop syndrome' where assessment_id = 'DEMO5878'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital clubnail', long_description='Congenital clubnail' where assessment_id = 'DEMO6070'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital constricting bands', long_description='Congenital constricting bands' where assessment_id = 'DEMO6292'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital deafness NOS', long_description='Congenital deafness NOS' where assessment_id = 'DEMO6915'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital deformity of clavicle', long_description='Congenital deformity of clavicle' where assessment_id = 'DEMO6206'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital depressions in skull', long_description='Congenital depressions in skull' where assessment_id = 'DEMO6120'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital dislocation of patella', long_description='Congenital dislocation of patella' where assessment_id = 'DEMO6222'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital displacement of esophagus', long_description='Congenital displacement of esophagus' where assessment_id = 'DEMO5853'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital diverticulitis, colon', long_description='Congenital diverticulitis, colon' where assessment_id = 'DEMO5879'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital diverticulum of bronchus', long_description='Congenital diverticulum of bronchus' where assessment_id = 'DEMO5800'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital diverticulum of stomach', long_description='Congenital diverticulum of stomach' where assessment_id = 'DEMO5856'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital diverticulum, intestine', long_description='Congenital diverticulum, intestine' where assessment_id = 'DEMO5881'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital dysphagocytosis', long_description='Congenital dysphagocytosis' where assessment_id = 'DEMO7515'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital fissure of tongue', long_description='Congenital fissure of tongue' where assessment_id = 'DEMO7081'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital fusion of ear ossicles', long_description='Congenital fusion of ear ossicles' where assessment_id = 'DEMO5766'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital fusion of sacroiliac joint', long_description='Congenital fusion of sacroiliac joint' where assessment_id = 'DEMO6224'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital genu recurvatum', long_description='Congenital genu recurvatum' where assessment_id = 'DEMO6136'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital genu valgum', long_description='Congenital genu valgum' where assessment_id = 'DEMO6223'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital Heinz body anemia', long_description='Congenital Heinz body anemia' where assessment_id = 'DEMO7450'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hemifacial atrophy or hypertrophy', long_description='Congenital hemifacial atrophy or hypertrophy' where assessment_id = 'DEMO6121'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hepatomegaly', long_description='Congenital hepatomegaly' where assessment_id = 'DEMO5892'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hourglass stomach', long_description='Congenital hourglass stomach' where assessment_id = 'DEMO5857'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hyperammonemia, type i', long_description='Congenital hyperammonemia, type i' where assessment_id = 'DEMO4764'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital hypertrichosis', long_description='Congenital hypertrichosis' where assessment_id = 'DEMO6061'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital koilonychia', long_description='Congenital koilonychia' where assessment_id = 'DEMO6071'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of ankle joint', long_description='Congenital malformation of ankle joint' where assessment_id = 'DEMO6232'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of myocardium', long_description='Congenital malformation of myocardium' where assessment_id = 'DEMO2039'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of parathyroid or thyroid gland', long_description='Congenital malformation of parathyroid or thyroid gland' where assessment_id = 'DEMO6087'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of pericardium', long_description='Congenital malformation of pericardium' where assessment_id = 'DEMO2037'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital malformation of sacroiliac joint', long_description='Congenital malformation of sacroiliac joint' where assessment_id = 'DEMO6233'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital metatarsus valgus', long_description='Congenital metatarsus valgus' where assessment_id = 'DEMO6148'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital poikiloderma', long_description='Congenital poikiloderma' where assessment_id = 'DEMO6059'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital pseudarthrosis of clavicle', long_description='Congenital pseudarthrosis of clavicle' where assessment_id = 'DEMO6211'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital pulmonary valve regurgitation', long_description='Congenital pulmonary valve regurgitation' where assessment_id = 'DEMO2025'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital renal calculi', long_description='Congenital renal calculi' where assessment_id = 'DEMO5959'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital shortening of tendon', long_description='Congenital shortening of tendon' where assessment_id = 'DEMO6293'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital splenomegaly', long_description='Congenital splenomegaly' where assessment_id = 'DEMO6084'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital tarsal coalition', long_description='Congenital tarsal coalition' where assessment_id = 'DEMO6151'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congenital urticaria pigmentosa', long_description='Congenital urticaria pigmentosa' where assessment_id = 'DEMO6056'
update c_Assessment_Definition SET last_updated=getdate(), description ='Congestion, pelvic female', long_description='Congestion, pelvic female' where assessment_id = '0^629.89^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Consumption coagulopathy', long_description='Consumption coagulopathy' where assessment_id = 'DEMO7490'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contact dermatitis (occupational) NOS', long_description='Contact dermatitis (occupational) NOS' where assessment_id = 'DEMO5195'
update c_Assessment_Definition SET last_updated=getdate(), description ='Contraction(s) kidney tuberculous', long_description='Contraction(s) kidney tuberculous' where assessment_id = 'DEMO4062'
update c_Assessment_Definition SET last_updated=getdate(), description ='Corectopia', long_description='Corectopia' where assessment_id = 'DEMO6026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coxsackie central nervous system NEC', long_description='Coxsackie central nervous system NEC' where assessment_id = 'DEMO4173'
update c_Assessment_Definition SET last_updated=getdate(), description ='Coxsackievirus meningitis', long_description='Coxsackievirus meningitis' where assessment_id = 'DEMO4168'
update c_Assessment_Definition SET last_updated=getdate(), description ='Craniopagus', long_description='Craniopagus' where assessment_id = 'DEMO6092'
update c_Assessment_Definition SET last_updated=getdate(), description ='Crenated tongue', long_description='Crenated tongue' where assessment_id = 'DEMO7712'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cricopharyngeal spasm', long_description='Cricopharyngeal spasm' where assessment_id = 'DEMO8020'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cyst cervix nabothian', long_description='Cyst cervix nabothian' where assessment_id = 'DEMO831'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cyst of cystic duct or gallbladder', long_description='Cyst of cystic duct or gallbladder' where assessment_id = 'DEMO8052'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cyst of parathyroid', long_description='Cyst of parathyroid' where assessment_id = 'DEMO4674'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cyst of pharynx', long_description='Cyst of pharynx' where assessment_id = 'DEMO4921'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cyst of urachus', long_description='Cyst of urachus' where assessment_id = 'DEMO5980'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cystathioninuria', long_description='Cystathioninuria' where assessment_id = 'DEMO4755'
update c_Assessment_Definition SET last_updated=getdate(), description ='Cystitis gonococcal', long_description='Cystitis gonococcal' where assessment_id = 'DEMO4400'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deep vein thrombosis, postpartum', long_description='Deep vein thrombosis, postpartum' where assessment_id = 'DEMO11217'
update c_Assessment_Definition SET last_updated=getdate(), description ='Defibrination syndrome following (induced) termination of pregnancy', long_description='Defibrination syndrome following (induced) termination of pregnancy' where assessment_id = 'DEMO443r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of coagulation factor due to liver disease', long_description='Deficiency of coagulation factor due to liver disease' where assessment_id = 'DEMO7495'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of coagulation factor due to vitamin K deficiency', long_description='Deficiency of coagulation factor due to vitamin K deficiency' where assessment_id = 'DEMO7496'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor I [fibrinogen]', long_description='Deficiency of factor I [fibrinogen]' where assessment_id = 'DEMO7480A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor II [prothrombin]', long_description='Deficiency of factor II [prothrombin]' where assessment_id = 'DEMO7480B'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor V [labile]', long_description='Deficiency of factor V [labile]' where assessment_id = 'DEMO7480C'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor VII [stable]', long_description='Deficiency of factor VII [stable]' where assessment_id = 'DEMO7480D'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor X [Stuart-Prower]', long_description='Deficiency of factor X [Stuart-Prower]' where assessment_id = 'DEMO7480E'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor XII [Hageman]', long_description='Deficiency of factor XII [Hageman]' where assessment_id = 'DEMO7480F'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficiency of factor XIII [fibrin stabilizing]', long_description='Deficiency of factor XIII [fibrin stabilizing]' where assessment_id = 'DEMO7481'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deficient blink reflex', long_description='Deficient blink reflex' where assessment_id = 'DEMO6400'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dehiscence of cesarean delivery wound', long_description='Dehiscence of cesarean delivery wound' where assessment_id = 'DEMO11264'
update c_Assessment_Definition SET last_updated=getdate(), description ='Delirium superimposed on dementia', long_description='Delirium superimposed on dementia' where assessment_id = 'DEMO9572'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dementia NOS', long_description='Dementia NOS' where assessment_id = 'DEMO9566'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dentinogenesis imperfecta', long_description='Dentinogenesis imperfecta' where assessment_id = 'DEMO7582'
update c_Assessment_Definition SET last_updated=getdate(), description ='Depressed fetal heart rate tones complicating labor and delivery', long_description='Depressed fetal heart rate tones complicating labor and delivery' where assessment_id = 'DEMO1017'
update c_Assessment_Definition SET last_updated=getdate(), description ='Depression NOS', long_description='Depression NOS' where assessment_id = 'DEP'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dermatoglyphic anomalies', long_description='Dermatoglyphic anomalies' where assessment_id = 'DEMO286'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dermatophilosis', long_description='Dermatophilosis' where assessment_id = 'DEMO4150'
update c_Assessment_Definition SET last_updated=getdate(), description ='Developmental coordination disorder', long_description='Developmental coordination disorder' where assessment_id = 'DEMO9827'
update c_Assessment_Definition SET last_updated=getdate(), description ='Developmental dyslexia', long_description='Developmental dyslexia' where assessment_id = 'DEMO9822'
update c_Assessment_Definition SET last_updated=getdate(), description ='Deviation of nasal septum, congenital', long_description='Deviation of nasal septum, congenital' where assessment_id = 'DEMO6122'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dextrocardia with situs inversus', long_description='Dextrocardia with situs inversus' where assessment_id = 'DEMO6090'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diabetes type 1 with osteomyelitis', long_description='Diabetes type 1 with osteomyelitis' where assessment_id = 'DEMO4641'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diarrhea due to Clostridium perfringens', long_description='Diarrhea due to Clostridium perfringens' where assessment_id = 'DEMO3876'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diarrhea due to staphylococcus', long_description='Diarrhea due to staphylococcus' where assessment_id = 'DEMO3877'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diarrhea endemic', long_description='Diarrhea endemic' where assessment_id = 'DEMO3887'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diarrhea infectious', long_description='Diarrhea infectious' where assessment_id = 'DIARRHEA'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diarrrhea dysenteric', long_description='Diarrrhea dysenteric' where assessment_id = 'DEMO3890'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dicephaly', long_description='Dicephaly' where assessment_id = 'DEMO6093'
update c_Assessment_Definition SET last_updated=getdate(), description ='Diffuse or disseminated intravascular coagulation [DIC]', long_description='Diffuse or disseminated intravascular coagulation [DIC]' where assessment_id = 'DEMO7491'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disease bacterial, specified NEC', long_description='Disease bacterial, specified NEC' where assessment_id = 'DEMO4146'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disease cytomegalic inclusion (generalized)', long_description='Disease cytomegalic inclusion (generalized)' where assessment_id = 'DEMO641'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disease, cytomegalic inclusion (generalized)', long_description='Disease, cytomegalic inclusion (generalized)' where assessment_id = 'CMV'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disorder (of) tubulo-insterstitial sepsis', long_description='Disorder (of) tubulo-insterstitial sepsis' where assessment_id = 'DEMO11426a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Displacement of brachial plexus', long_description='Displacement of brachial plexus' where assessment_id = 'DEMO5713'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disruption of wound of episiotomy', long_description='Disruption of wound of episiotomy' where assessment_id = 'DEMO11266'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disruption of wound of perineal laceration', long_description='Disruption of wound of perineal laceration' where assessment_id = 'DEMO11267'
update c_Assessment_Definition SET last_updated=getdate(), description ='Distal intestinal obstruction syndrome', long_description='Distal intestinal obstruction syndrome' where assessment_id = 'DEMO4819'
update c_Assessment_Definition SET last_updated=getdate(), description ='Distress fetal', long_description='Distress fetal' where assessment_id = '0^768.9^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Disturbance of vision following unspecified cerebrovascular disease', long_description='Disturbance of vision following unspecified cerebrovascular disease' where assessment_id = 'DEMO10066'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dolichocolon', long_description='Dolichocolon' where assessment_id = 'DEMO5882'
update c_Assessment_Definition SET last_updated=getdate(), description ='Drug-induced myelopathy', long_description='Drug-induced myelopathy' where assessment_id = 'DEMO7257'
update c_Assessment_Definition SET last_updated=getdate(), description ='Drug-induced osteoporosis without current pathological fracture', long_description='Drug-induced osteoporosis without current pathological fracture' where assessment_id = 'DEMO3917'
update c_Assessment_Definition SET last_updated=getdate(), description ='Duodenal ileus (chronic)', long_description='Duodenal ileus (chronic)' where assessment_id = 'DEMO7812'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dyskinesia of cystic duct or gallbladder', long_description='Dyskinesia of cystic duct or gallbladder' where assessment_id = 'DEMO8054'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dyspareunia male', long_description='Dyspareunia male ' where assessment_id = 'DEMO10571'
update c_Assessment_Definition SET last_updated=getdate(), description ='Dysplasia of eye', long_description='Dysplasia of eye' where assessment_id = 'DEMO5721'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eccentric personality disorder', long_description='Eccentric personality disorder' where assessment_id = 'DEMO9697'
update c_Assessment_Definition SET last_updated=getdate(), description ='Edema of pharynx', long_description='Edema of pharynx' where assessment_id = 'DEMO4920'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Edema of scrotum, seminal vesicle, spermatic cord, tunica vaginalis and vas deferens' where assessment_id = 'DEMO7140'
update c_Assessment_Definition SET last_updated=getdate(), description ='Edema vulva', long_description='Edema vulva' where assessment_id = 'DEMO851'
update c_Assessment_Definition SET last_updated=getdate(), description ='Edentulism NOS', long_description='Edentulism NOS' where assessment_id = '0^12011'
update c_Assessment_Definition SET last_updated=getdate(), description ='Elective agalactia', long_description='Elective agalactia' where assessment_id = 'DEMO11321'
update c_Assessment_Definition SET last_updated=getdate(), description ='Elephantiasis (nonfilarial) NOS', long_description='Elephantiasis (nonfilarial) NOS' where assessment_id = 'DEMO229'
update c_Assessment_Definition SET last_updated=getdate(), description ='Emphysematous bleb', long_description='Emphysematous bleb' where assessment_id = 'DEMO4970'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enamel pearls', long_description='Enamel pearls' where assessment_id = 'DEMO7576'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for examination for admission to prison', long_description='Encounter for examination for admission to prison' where assessment_id = '0^12137'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for examination for admission to summer camp', long_description='Encounter for examination for admission to summer camp' where assessment_id = '0^12138'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for health examination in population surveys', long_description='Encounter for health examination in population surveys' where assessment_id = 'DEMO9284'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for immigration examination', long_description='Encounter for immigration examination' where assessment_id = 'DEMO10316'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for naturalization examination', long_description='Encounter for naturalization examination' where assessment_id = 'DEMO10317'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for postvasectomy sperm count', long_description='Encounter for postvasectomy sperm count' where assessment_id = 'DEMO9437'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for premarital examination', long_description='Encounter for premarital examination' where assessment_id = 'DEMO10318'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for prophylactic removal of ovary(s) and fallopian tube(s)', long_description='Encounter for prophylactic removal of ovary(s) and fallopian tube(s)' where assessment_id = 'DEMO9215'
update c_Assessment_Definition SET last_updated=getdate(), description ='Encounter for puberty development state', long_description='Encounter for puberty development state' where assessment_id = 'DEMO9426'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endometritis', long_description='Endometritis ' where assessment_id = 'DEMO766'
update c_Assessment_Definition SET last_updated=getdate(), description ='Endometritis following (induced) termination of pregnancy', long_description='Endometritis following (induced) termination of pregnancy' where assessment_id = 'DEMO874r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Engorgement breast', long_description='Engorgement breast' where assessment_id = 'DEMO744'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enlargement of tongue', long_description='Enlargement of tongue' where assessment_id = 'DEMO7713'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enteritis infectious due to Aerobacter aerogenes', long_description='Enteritis infectious due to Aerobacter aerogenes' where assessment_id = 'DEMO3869'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enteritis infectious due to Clostridium perfringens', long_description='Enteritis infectious due to Clostridium perfringens' where assessment_id = 'DEMO3870'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enteritis infectious due to Enterobacter aerogenes', long_description='Enteritis infectious due to Enterobacter aerogenes' where assessment_id = 'DEMO3872'
update c_Assessment_Definition SET last_updated=getdate(), description ='Enteritis infectious due to Staphylococcus', long_description='Enteritis infectious due to Staphylococcus' where assessment_id = 'DEMO3873'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eosinophilia (secondary)(idiopathic)', long_description='Eosinophilia (secondary)(idiopathic) ' where assessment_id = 'DEMO7527'
update c_Assessment_Definition SET last_updated=getdate(), description ='Epigastric hernia causing obstruction, without gangrene', long_description='Epigastric hernia causing obstruction, without gangrene' where assessment_id = 'DEMO7875'
update c_Assessment_Definition SET last_updated=getdate(), description ='Epituberculosis', long_description='Epituberculosis' where assessment_id = 'DEMO4016'
update c_Assessment_Definition SET last_updated=getdate(), description ='Epoophoron cyst', long_description='Epoophoron cyst' where assessment_id = 'DEMO5907'
update c_Assessment_Definition SET last_updated=getdate(), description ='Erythremia, chronic', long_description='Erythremia, chronic' where assessment_id = 'DEMO3514'
update c_Assessment_Definition SET last_updated=getdate(), description ='Erythrocyanosis', long_description='Erythrocyanosis' where assessment_id = 'DEMO1897'
update c_Assessment_Definition SET last_updated=getdate(), description ='Esophageal pouch, acquired', long_description='Esophageal pouch, acquired' where assessment_id = 'DEMO7759'
update c_Assessment_Definition SET last_updated=getdate(), description ='Eventration of diaphragm', long_description='Eventration of diaphragm' where assessment_id = 'DEMO6285'
update c_Assessment_Definition SET last_updated=getdate(), description ='Excessive sexual drive', long_description='Excessive sexual drive' where assessment_id = 'DEMO8955'
update c_Assessment_Definition SET last_updated=getdate(), description ='External hemorrhoids with thrombosis', long_description='External hemorrhoids with thrombosis' where assessment_id = 'HEMT'
update c_Assessment_Definition SET last_updated=getdate(), description ='External hemorrhoids, NOS', long_description='External hemorrhoids, NOS' where assessment_id = 'DEMO1952'
update c_Assessment_Definition SET last_updated=getdate(), description ='Extracutaneous mastocytoma', long_description='Extracutaneous mastocytoma' where assessment_id = 'DEMO9199'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed induction (of labor) by oxytocin', long_description='Failed induction (of labor) by oxytocin' where assessment_id = 'DEMO10993'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed mechanical induction (of labor)', long_description='Failed mechanical induction (of labor)' where assessment_id = 'DEMO10994'
update c_Assessment_Definition SET last_updated=getdate(), description ='Failed surgical induction (of labor)', long_description='Failed surgical induction (of labor)' where assessment_id = 'DEMO10995'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fanconi (-de Toni) (-Debré) syndrome, unspecified', long_description='Fanconi (-de Toni) (-Debré) syndrome, unspecified' where assessment_id = 'DEMO4747'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fat embolism following (induced) termination of pregnancy', long_description='Fat embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877w7q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal acidemia complicating labor and delivery', long_description='Fetal acidemia complicating labor and delivery' where assessment_id = 'DEMO10957'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal acidosis complicating labor and delivery', long_description='Fetal acidosis complicating labor and delivery' where assessment_id = 'DEMO10967'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal alkalosis complicating labor and delivery', long_description='Fetal alkalosis complicating labor and delivery' where assessment_id = 'DEMO994'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal bradycardia complicating labor and delivery', long_description='Fetal bradycardia complicating labor and delivery' where assessment_id = 'DEMO1018'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal heart rate abnormal variability complicating labor and delivery', long_description='Fetal heart rate abnormal variability complicating labor and delivery' where assessment_id = 'DEMO11008'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal heart rate decelerations complicating labor and delivery', long_description='Fetal heart rate decelerations complicating labor and delivery' where assessment_id = 'DEMO11006'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal heart rate irregularity complicating labor and delivery', long_description='Fetal heart rate irregularity complicating labor and delivery' where assessment_id = 'DEMO11007'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fetal tachycardia complicating labor and delivery', long_description='Fetal tachycardia complicating labor and delivery' where assessment_id = 'DEMO11009'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fever quartan', long_description='Fever quartan' where assessment_id = 'DEMO4305'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrinolytic purpura', long_description='Fibrinolytic purpura' where assessment_id = 'DEMO7492'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrosis cervix', long_description='Fibrosis cervix' where assessment_id = 'DEMO833'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrosis of pancreas', long_description='Fibrosis of pancreas' where assessment_id = 'DEMO8079'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrosis of spleen NOS', long_description='Fibrosis of spleen NOS' where assessment_id = 'DEMO7551'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrosis of uterus', long_description='Fibrosis of uterus ' where assessment_id = 'DEMO824'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fibrous dysplasia', long_description='Fibrous dysplasia' where assessment_id = 'DEMO7666'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fish-meal worker''s lung', long_description='Fish-meal worker''s lung' where assessment_id = 'DEMO4984'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fistula cervix', long_description='Fistula cervix' where assessment_id = 'DEMO796'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fistula of lips', long_description='Fistula of lips' where assessment_id = 'DEMO10392'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fistula vagina', long_description='Fistula vagina' where assessment_id = 'DEMO795'
update c_Assessment_Definition SET last_updated=getdate(), description ='Flat retinoschisis', long_description='Flat retinoschisis' where assessment_id = 'DEMO5336'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal mucinosis', long_description='Focal mucinosis' where assessment_id = 'DEMO5118'
update c_Assessment_Definition SET last_updated=getdate(), description ='Focal pericardial adhesions', long_description='Focal pericardial adhesions' where assessment_id = 'DEMO1730'
update c_Assessment_Definition SET last_updated=getdate(), description ='Follicular thyroid carcinoma', long_description='Follicular thyroid carcinoma' where assessment_id = 'DEMO8383'
update c_Assessment_Definition SET last_updated=getdate(), description ='Food hypersensitivity gastroenteritis or colitis', long_description='Food hypersensitivity gastroenteritis or colitis' where assessment_id = 'DEMO10374'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fragilitas crinium', long_description='Fragilitas crinium' where assessment_id = 'DEMO6109'
update c_Assessment_Definition SET last_updated=getdate(), description ='Friction sounds in chest', long_description='Friction sounds in chest' where assessment_id = 'DEMO2127'
update c_Assessment_Definition SET last_updated=getdate(), description ='Friedreich''s ataxia (autosomal recessive)', long_description='Friedreich''s ataxia (autosomal recessive)' where assessment_id = 'DEMO7229'
update c_Assessment_Definition SET last_updated=getdate(), description ='Frozen pelvis (female)', long_description='Frozen pelvis (female)' where assessment_id = 'DEMO867'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fucosidosis', long_description='Fucosidosis' where assessment_id = 'DEMO4774'
update c_Assessment_Definition SET last_updated=getdate(), description ='Functional hyperinsulinism', long_description='Functional hyperinsulinism' where assessment_id = 'DEMO4666'
update c_Assessment_Definition SET last_updated=getdate(), description ='Functional nonhyperinsulinemic hypoglycemia', long_description='Functional nonhyperinsulinemic hypoglycemia' where assessment_id = 'DEMO4667'
update c_Assessment_Definition SET last_updated=getdate(), description ='Furrier''s lung', long_description='Furrier''s lung' where assessment_id = 'DEMO4985'
update c_Assessment_Definition SET last_updated=getdate(), description ='Fusion of teeth', long_description='Fusion of teeth' where assessment_id = 'DEMO7571'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gartner''s duct cyst', long_description='Gartner''s duct cyst' where assessment_id = 'DEMO5919'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gastrocolic fistula', long_description='Gastrocolic fistula' where assessment_id = 'DEMO7817'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gender dysphoria in adolescents and adults', long_description='Gender dysphoria in adolescents and adults' where assessment_id = 'DEMO9708'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gender identity disorder in adolescence and adulthood', long_description='Gender identity disorder in adolescence and adulthood' where assessment_id = 'DEMO9707'
update c_Assessment_Definition SET last_updated=getdate(), description ='Genital varices in the puerperium', long_description='Genital varices in the puerperium' where assessment_id = 'DEMO11227'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ghon tubercle, primary infection', long_description='Ghon tubercle, primary infection' where assessment_id = 'DEMO4017'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glanzmann''s disease', long_description='Glanzmann''s disease' where assessment_id = 'DEMO7500'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glomerulonephritis', long_description='Glomerulonephritis' where assessment_id = 'DEMO5186'
update c_Assessment_Definition SET last_updated=getdate(), description ='Glossocele', long_description='Glossocele' where assessment_id = 'DEMO7714'
update c_Assessment_Definition SET last_updated=getdate(), description ='Goiter multinodular toxic or with hyperthyroidism with thyroid storm', long_description='Goiter multinodular toxic or with hyperthyroidism with thyroid storm ' where assessment_id = 'DEMO4610'
update c_Assessment_Definition SET last_updated=getdate(), description ='Goiter multinodular toxic or with hyperthyroidism', long_description='Goiter multinodular toxic or with hyperthyroidism' where assessment_id = 'DEMO4608'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal endocarditis', long_description='Gonococcal endocarditis' where assessment_id = 'DEMO4417'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal keratoderma', long_description='Gonococcal keratoderma' where assessment_id = 'DEMO4419'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcal pelviperitonitis', long_description='Gonococcal pelviperitonitis' where assessment_id = 'DEMO4405'
update c_Assessment_Definition SET last_updated=getdate(), description ='Gonococcus, genitourinary upper', long_description='Gonococcus, genitourinary upper' where assessment_id = 'DEMO4406'
update c_Assessment_Definition SET last_updated=getdate(), description ='Goodpasture''s syndrome', long_description='Goodpasture''s syndrome' where assessment_id = 'DEMO10540'
update c_Assessment_Definition SET last_updated=getdate(), description ='Grey platelet syndrome', long_description='Grey platelet syndrome' where assessment_id = 'DEMO7501'
update c_Assessment_Definition SET last_updated=getdate(), description ='"Haltlose" type personality disorder', long_description='"Haltlose" type personality disorder' where assessment_id = 'DEMO9698'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hammer toe, congenital', long_description='Hammer toe, congenital' where assessment_id = 'DEMO6225'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hb-SS disease without crisis', long_description='Hb-SS disease without crisis' where assessment_id = 'COX'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemangioma cavernous specified site NEC', long_description='Hemangioma cavernous specified site NEC' where assessment_id = 'DEMO8806'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hematocele female NEC', long_description='Hematocele female NEC' where assessment_id = 'DEMO853'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hematocele, NOS, of male genital organs', long_description='Hematocele, NOS, of male genital organs' where assessment_id = 'DEMO7132'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemolysis following (induced) termination of pregnancy', long_description='Hemolysis following (induced) termination of pregnancy' where assessment_id = 'DEMO876b'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Hemorrhage associated with retained portions of placenta or membranes after the first 24 hours following delivery of placenta' where assessment_id = 'DEMO11141'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage associated with retained, trapped or adherent placenta', long_description='Hemorrhage associated with retained, trapped or adherent placenta' where assessment_id = 'DEMO11137'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage following delivery of placenta', long_description='Hemorrhage following delivery of placenta' where assessment_id = 'DEMO11140'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage of esophagus NOS', long_description='Hemorrhage of esophagus NOS' where assessment_id = 'DEMO7764'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage of male genital organs', long_description='Hemorrhage of male genital organs' where assessment_id = 'DEMO7133'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage of thyroid', long_description='Hemorrhage of thyroid' where assessment_id = 'DEMO4625'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage specified as due to threatened abortion', long_description='Hemorrhage specified as due to threatened abortion' where assessment_id = 'DEMO444q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhage tuberculous NEC', long_description='Hemorrhage tuberculous NEC' where assessment_id = 'DEMO4026'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hemorrhagic cyst of jaw', long_description='Hemorrhagic cyst of jaw' where assessment_id = 'DEMO7659'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary coproporphyria', long_description='Hereditary coproporphyria' where assessment_id = 'DEMO4801'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary eosinophilia', long_description='Hereditary eosinophilia' where assessment_id = 'DEMO7525'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary leukocytic hypersegmentation', long_description='Hereditary leukocytic hypersegmentation' where assessment_id = 'DEMO7518'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary leukocytic hyposegmentation', long_description='Hereditary leukocytic hyposegmentation' where assessment_id = 'DEMO7519'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary leukomelanopathy', long_description='Hereditary leukomelanopathy' where assessment_id = 'DEMO7520'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary motor and sensory neuropathy, types I-IV', long_description='Hereditary motor and sensory neuropathy, types I-IV' where assessment_id = 'DEMO7390'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hereditary xanthinuria', long_description='Hereditary xanthinuria' where assessment_id = 'DEMO4805'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral [herpes simplex] ulceration', long_description='Herpesviral [herpes simplex] ulceration' where assessment_id = 'DEMO4196'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral dermatitis of eyelid', long_description='Herpesviral dermatitis of eyelid' where assessment_id = 'DEMO4200'
update c_Assessment_Definition SET last_updated=getdate(), description ='Herpesviral keratoconjunctivitis', long_description='Herpesviral keratoconjunctivitis' where assessment_id = 'DEMO4202'
update c_Assessment_Definition SET last_updated=getdate(), description ='Heterochromia of hair', long_description='Heterochromia of hair' where assessment_id = 'DEMO5128'
update c_Assessment_Definition SET last_updated=getdate(), description ='High lateral transmural (Q wave) infarction (acute)', long_description='High lateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1668'
update c_Assessment_Definition SET last_updated=getdate(), description ='Histiocytic tumors of uncertain behavior', long_description='Histiocytic tumors of uncertain behavior' where assessment_id = 'DEMO10456'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hyperammonemia, type iii', long_description='Hyperammonemia, type iii' where assessment_id = 'DEMO4765'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Hyperemesis gravidarum, mild or unspecified, starting before the end of the 20th week of gestation' where assessment_id = 'DEMO10697'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Hyperemesis gravidarum, starting before the end of the 20th week of gestation, with metabolic disturbance such as carbohydrate depletion' where assessment_id = 'DEMO908'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Hyperemesis gravidarum, starting before the end of the 20th week of gestation, with metabolic disturbance such as dehydration' where assessment_id = 'DEMO10699'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hyperglycemia due to type 1 diabetes mellitus', long_description='Hyperglycemia due to type 1 diabetes mellitus' where assessment_id = 'DEMO4633'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypersomnia NOS', long_description='Hypersomnia NOS' where assessment_id = 'DEMO2095'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypertrophy of biliary tract', long_description='Hypertrophy of biliary tract' where assessment_id = 'DEMO8067'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypertrophy of clitoris', long_description='Hypertrophy of clitoris' where assessment_id = 'DEMO849'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Hypertrophy of scrotum, seminal vesicle, spermatic cord, tunica vaginalis and vas deferens' where assessment_id = 'DEMO7141'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypoeosinophilia', long_description='Hypoeosinophilia' where assessment_id = 'DEMO7529'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypomenorrhea NOS', long_description='Hypomenorrhea NOS' where assessment_id = 'DEMO855'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypoplasia of eye', long_description='Hypoplasia of eye' where assessment_id = 'DEMO5722'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hypothyroidism due to P-aminosalicylic acid', long_description='Hypothyroidism due to P-aminosalicylic acid' where assessment_id = 'DEMO4614'
update c_Assessment_Definition SET last_updated=getdate(), description ='Hysterical personality (disorder)', long_description='Hysterical personality (disorder)' where assessment_id = 'DEMO9690'
update c_Assessment_Definition SET last_updated=getdate(), description ='Identity disorder', long_description='Identity disorder' where assessment_id = 'DEMO9810'
update c_Assessment_Definition SET last_updated=getdate(), description ='Idiopathic osteoporosis without current pathological fracture', long_description='Idiopathic osteoporosis without current pathological fracture' where assessment_id = 'DEMO3919'
update c_Assessment_Definition SET last_updated=getdate(), description ='Immediate gastrointestinal hypersensitivity', long_description='Immediate gastrointestinal hypersensitivity' where assessment_id = 'DEMO10377'
update c_Assessment_Definition SET last_updated=getdate(), description ='Impacted shoulders', long_description='Impacted shoulders' where assessment_id = 'DEMO11027'
update c_Assessment_Definition SET last_updated=getdate(), description ='Impacted tooth, non-supranumerary', long_description='Impacted tooth, non-supranumerary' where assessment_id = 'DEMO7585'
update c_Assessment_Definition SET last_updated=getdate(), description ='Incomplete rotation of cecum and colon', long_description='Incomplete rotation of cecum and colon' where assessment_id = 'DEMO5876'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infantile pseudoleukemia', long_description='Infantile pseudoleukemia' where assessment_id = 'DEMO7474'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infarction of thyroid', long_description='Infarction of thyroid' where assessment_id = 'DEMO4627'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection Clostridium NEC difficile as cause of disease classified elsewhere', long_description='Infection Clostridium NEC difficile as cause of disease classified elsewhere  ' where assessment_id = 'DEMO585'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection due to Ancylostoma species', long_description='Infection due to Ancylostoma species' where assessment_id = 'DEMO4527'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection due to Mycobacterium avium', long_description='Infection due to Mycobacterium avium' where assessment_id = 'DEMO677'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection Heterophyes', long_description='Infection Heterophyes' where assessment_id = 'DEMO4504'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection of bone NOS', long_description='Infection of bone NOS' where assessment_id = 'DEMO3909'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Infection, bacterial NOS as cause of disease classified elsewhere Enterobacter sakazakii' where assessment_id = 'DEMO584'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection, Leishmania aethiopica', long_description='Infection, Leishmania aethiopica' where assessment_id = 'DEMO4311'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection, Leishmania mexicana', long_description='Infection, Leishmania mexicana' where assessment_id = 'DEMO4314'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infection, Leishmania tropica', long_description='Infection, Leishmania tropica' where assessment_id = 'DEMO4328'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infectious colitis NOS', long_description='Infectious colitis NOS' where assessment_id = 'COLI'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infectious enteritis NOS', long_description='Infectious enteritis NOS' where assessment_id = 'DEMO3888'
update c_Assessment_Definition SET last_updated=getdate(), description ='Infectious gastroenteritis NOS', long_description='Infectious gastroenteritis NOS' where assessment_id = 'DEMO10015'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inferolateral transmural (Q wave) infarction (acute)', long_description='Inferolateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1675'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inferoposterior transmural (Q wave) infarction (acute)', long_description='Inferoposterior transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1676a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inhalation anthrax', long_description='Inhalation anthrax' where assessment_id = 'DEMO4957'
update c_Assessment_Definition SET last_updated=getdate(), description ='Intention tremor', long_description='Intention tremor' where assessment_id = 'DEMO7211'
update c_Assessment_Definition SET last_updated=getdate(), description ='Interference dissociation', long_description='Interference dissociation' where assessment_id = 'DEMO10421'
update c_Assessment_Definition SET last_updated=getdate(), description ='Internal hemorrhoids, without mention of degree', long_description='Internal hemorrhoids, without mention of degree' where assessment_id = 'DEMO1948'
update c_Assessment_Definition SET last_updated=getdate(), description ='Interstitial mastitis associated with lactation', long_description='Interstitial mastitis associated with lactation' where assessment_id = 'DEMO11292'
update c_Assessment_Definition SET last_updated=getdate(), description ='Intestinal trichomoniasis', long_description='Intestinal trichomoniasis' where assessment_id = 'DEMO3862'
update c_Assessment_Definition SET last_updated=getdate(), description ='Intoxication foodborne due to bacterium specified NEC', long_description='Intoxication foodborne due to bacterium specified NEC' where assessment_id = 'DEMO3850'
update c_Assessment_Definition SET last_updated=getdate(), description ='Intravascular coagulation following (induced) termination of pregnancy', long_description='Intravascular coagulation following (induced) termination of pregnancy' where assessment_id = 'DEMO876q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Inversion nipple', long_description='Inversion nipple' where assessment_id = 'DEMO742'
update c_Assessment_Definition SET last_updated=getdate(), description ='Iron deficiency anemia due to inadequate dietary iron intake', long_description='Iron deficiency anemia due to inadequate dietary iron intake' where assessment_id = 'DEMO7415'
update c_Assessment_Definition SET last_updated=getdate(), description ='Iron pigmentation', long_description='Iron pigmentation' where assessment_id = 'DEMO213'
update c_Assessment_Definition SET last_updated=getdate(), description ='Irregular sleep-wake pattern', long_description='Irregular sleep-wake pattern' where assessment_id = '0^11988'
update c_Assessment_Definition SET last_updated=getdate(), description ='Isorhythmic dissociation', long_description='Isorhythmic dissociation' where assessment_id = 'DEMO1781'
update c_Assessment_Definition SET last_updated=getdate(), description ='Jackson''s membrane', long_description='Jackson''s membrane' where assessment_id = 'DEMO5875'
update c_Assessment_Definition SET last_updated=getdate(), description ='Jaundice acholuric acquired', long_description='Jaundice acholuric acquired' where assessment_id = 'DEMO7462'
update c_Assessment_Definition SET last_updated=getdate(), description ='Jaw-winking syndrome', long_description='Jaw-winking syndrome' where assessment_id = 'DEMO5714'
update c_Assessment_Definition SET last_updated=getdate(), description ='Kinking and stricture of ureter without hydronephrosis', long_description='Kinking and stricture of ureter without hydronephrosis' where assessment_id = 'DEMO6987'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Laceration, perforation, tear or chemical damage of bladder following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO877w3'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lapsed immunization schedule status', long_description='Lapsed immunization schedule status' where assessment_id = '981^V15.83^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Late syphilitic acoustic neuritis', long_description='Late syphilitic acoustic neuritis' where assessment_id = 'DEMO4373'
update c_Assessment_Definition SET last_updated=getdate(), description ='Late syphilitic bursitis', long_description='Late syphilitic bursitis' where assessment_id = 'DEMO4385'
update c_Assessment_Definition SET last_updated=getdate(), description ='Late syphilitic leukoderma', long_description='Late syphilitic leukoderma' where assessment_id = 'DEMO4388'
update c_Assessment_Definition SET last_updated=getdate(), description ='Late syphilitic optic (nerve) atrophy', long_description='Late syphilitic optic (nerve) atrophy' where assessment_id = 'DEMO4374'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lateral (wall) NOS transmural (Q wave) infarction (acute)', long_description='Lateral (wall) NOS transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1690'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lesion(s) angiocentric immunoproliferative', long_description='Lesion(s) angiocentric immunoproliferative' where assessment_id = '0^238.79^2'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukokeratosis of oral mucosa', long_description='Leukokeratosis of oral mucosa' where assessment_id = 'DEMO535'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukoplakia of gingiva, lips, tongue', long_description='Leukoplakia of gingiva, lips, tongue' where assessment_id = 'DEMO649'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukoplakia of vocal cords', long_description='Leukoplakia of vocal cords' where assessment_id = 'DEMO4929'
update c_Assessment_Definition SET last_updated=getdate(), description ='Leukorrhea', long_description='Leukorrhea' where assessment_id = 'DEMO843'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lichen myxedematosus', long_description='Lichen myxedematosus' where assessment_id = 'DEMO5119'
update c_Assessment_Definition SET last_updated=getdate(), description ='Longitudinal reduction deformity of unspecified limb(s)', long_description='Longitudinal reduction deformity of unspecified limb(s)' where assessment_id = 'DEMO6203'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lown-Ganong-Levine syndrome', long_description='Lown-Ganong-Levine syndrome' where assessment_id = 'DEMO1779'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lymphadenopathy due to toxoplasmosis', long_description='Lymphadenopathy due to toxoplasmosis ' where assessment_id = 'DEMO691'
update c_Assessment_Definition SET last_updated=getdate(), description ='Lymphangitis of breast associated with lactation', long_description='Lymphangitis of breast associated with lactation' where assessment_id = 'DEMO11293'
update c_Assessment_Definition SET last_updated=getdate(), description ='Macrodactylia (fingers)', long_description='Macrodactylia (fingers)' where assessment_id = 'DEMO6213'
update c_Assessment_Definition SET last_updated=getdate(), description ='Macrodontia', long_description='Macrodontia' where assessment_id = 'DEMO7573'
update c_Assessment_Definition SET last_updated=getdate(), description ='Macrogyria', long_description='Macrogyria' where assessment_id = 'DEMO5704'
update c_Assessment_Definition SET last_updated=getdate(), description ='Madelung''s deformity', long_description='Madelung''s deformity' where assessment_id = 'DEMO6214'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Major neurocognitive disorder due to vascular disease, with behavioral disturbance' where assessment_id = 'DEMO9576'
update c_Assessment_Definition SET last_updated=getdate(), description ='Major neurocognitive disorder with aggressive behavior', long_description='Major neurocognitive disorder with aggressive behavior' where assessment_id = 'DEMO9577'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of biliary duct or passage NOS', long_description='Malignant neoplasm of biliary duct or passage NOS' where assessment_id = 'DEMO8188'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of junctional region of oropharynx', long_description='Malignant neoplasm of junctional region of oropharynx' where assessment_id = 'DEMO8136'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of two or more contiguous sites of tongue', long_description='Malignant neoplasm of two or more contiguous sites of tongue' where assessment_id = 'DEMO8352'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malposition of heart', long_description='Malposition of heart' where assessment_id = 'DEMO2038'
update c_Assessment_Definition SET last_updated=getdate(), description ='Malignant neoplasm of two or more contiguous sites of tongue', long_description='Malignant neoplasm of two or more contiguous sites of tongue' where assessment_id = 'DEMO2041'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mannosidosis', long_description='Mannosidosis' where assessment_id = 'DEMO4775'
update c_Assessment_Definition SET last_updated=getdate(), description ='Marcus Gunn''s syndrome', long_description='Marcus Gunn''s syndrome' where assessment_id = 'DEMO5813'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mastalgia', long_description='Mastalgia' where assessment_id = '000181x'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mastitis with abscess', long_description='Mastitis with abscess' where assessment_id = 'MAS'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion due to cephalopelvic disproportion NOS', long_description='Maternal care for disproportion due to cephalopelvic disproportion NOS' where assessment_id = 'DEMO10888'
update c_Assessment_Definition SET last_updated=getdate(), description ='Maternal care for disproportion due to fetopelvic disproportion NOS', long_description='Maternal care for disproportion due to fetopelvic disproportion NOS' where assessment_id = 'DEMO10889'
update c_Assessment_Definition SET last_updated=getdate(), description ='May-Hegglin (granulation) (granulocyte) anomaly', long_description='May-Hegglin (granulation) (granulocyte) anomaly' where assessment_id = 'DEMO7521'
update c_Assessment_Definition SET last_updated=getdate(), description ='May-Hegglin syndrome', long_description='May-Hegglin syndrome' where assessment_id = 'DEMO7522'
update c_Assessment_Definition SET last_updated=getdate(), description ='Meatitis, urethral', long_description='Meatitis, urethral' where assessment_id = 'DEMO7037'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mechanical complication of enterostomy', long_description='Mechanical complication of enterostomy' where assessment_id = 'DEMO7965'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mechanical hemolytic anemia', long_description='Mechanical hemolytic anemia' where assessment_id = 'DEMO7459'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mediastinal fistula', long_description='Mediastinal fistula' where assessment_id = 'DEMO534'
update c_Assessment_Definition SET last_updated=getdate(), description ='Megaloappendix', long_description='Megaloappendix' where assessment_id = 'DEMO5883'
update c_Assessment_Definition SET last_updated=getdate(), description ='Megaloblastic anemia NOS', long_description='Megaloblastic anemia NOS' where assessment_id = 'DEMO7425'
update c_Assessment_Definition SET last_updated=getdate(), description ='Meningitis due to Escherichia coli', long_description='Meningitis due to Escherichia coli' where assessment_id = 'DEMO7162'
update c_Assessment_Definition SET last_updated=getdate(), description ='Meningomyelitis in diseases classified elsewhere', long_description='Meningomyelitis in diseases classified elsewhere' where assessment_id = '0^323.02^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Menkes'' (kinky hair) (steely hair) disease', long_description='Menkes'' (kinky hair) (steely hair) disease' where assessment_id = 'DEMO4788'
update c_Assessment_Definition SET last_updated=getdate(), description ='Menorrhagia (primary)', long_description='Menorrhagia (primary)' where assessment_id = 'MENOR'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mesenteric adhesions', long_description='Mesenteric adhesions' where assessment_id = 'DEMO7943'
update c_Assessment_Definition SET last_updated=getdate(), description ='Metamorphopsia', long_description='Metamorphopsia' where assessment_id = 'DEMO5575'
update c_Assessment_Definition SET last_updated=getdate(), description ='Methioninemia', long_description='Methioninemia' where assessment_id = 'DEMO4756'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microangiopathic hemolytic anemia', long_description='Microangiopathic hemolytic anemia' where assessment_id = 'DEMO7460'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microdontia', long_description='Microdontia' where assessment_id = 'DEMO7574'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microphakia', long_description='Microphakia' where assessment_id = 'DEMO5736'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microscopic cystic corneal dystrophy', long_description='Microscopic cystic corneal dystrophy' where assessment_id = 'DEMO6316'
update c_Assessment_Definition SET last_updated=getdate(), description ='Microsporidiosis', long_description='Microsporidiosis' where assessment_id = 'DEMO10271'
update c_Assessment_Definition SET last_updated=getdate(), description ='Miller-Dieker syndrome', long_description='Miller-Dieker syndrome' where assessment_id = '0^11732'
update c_Assessment_Definition SET last_updated=getdate(), description ='Monocular exotropia of left eye with noncommitance other than a or v pattern', long_description='Monocular exotropia of left eye with noncommitance other than a or v pattern' where assessment_id = 'DEMO6561'
update c_Assessment_Definition SET last_updated=getdate(), description ='Monocytic leukemia, unspecified NOS', long_description='Monocytic leukemia, unspecified NOS' where assessment_id = 'DEMO3511'
update c_Assessment_Definition SET last_updated=getdate(), description ='Mucocele of gallbladder', long_description='Mucocele of gallbladder' where assessment_id = 'DEMO8045'
update c_Assessment_Definition SET last_updated=getdate(), description ='Muir-torre syndrome', long_description='Muir-torre syndrome' where assessment_id = 'DEMO8903'
update c_Assessment_Definition SET last_updated=getdate(), description ='Muscle (sheath) hernia', long_description='Muscle (sheath) hernia' where assessment_id = 'DEMO3808'
update c_Assessment_Definition SET last_updated=getdate(), description ='Myocardial infarction associated with revascularization procedure', long_description='Myocardial infarction associated with revascularization procedure' where assessment_id = 'DEMO10626'
update c_Assessment_Definition SET last_updated=getdate(), description ='Myocardial infarction type 3', long_description='Myocardial infarction type 3' where assessment_id = 'DEMO1671'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neonatal chlamydial conjunctivitis', long_description='Neonatal chlamydial conjunctivitis' where assessment_id = 'DEMO6703'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neonatal hemochromatosis', long_description='Neonatal hemochromatosis' where assessment_id = '0^775.89^1'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm of uncertain behavior of connective tissue of ear', long_description='Neoplasm of uncertain behavior of connective tissue of ear' where assessment_id = 'DEMO9195'
update c_Assessment_Definition SET last_updated=getdate(), description ='Neoplasm of uncertain behavior of eye', long_description='Neoplasm of uncertain behavior of eye' where assessment_id = 'DEMO9202'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nephritis', long_description='Nephritis' where assessment_id = 'DEMO5176'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nodular fasciitis', long_description='Nodular fasciitis' where assessment_id = 'DEMO3811'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nodular goiter (nontoxic) NOS', long_description='Nodular goiter (nontoxic) NOS' where assessment_id = 'GOI'
update c_Assessment_Definition SET last_updated=getdate(), description ='Noninfective mastitis of newborn', long_description='Noninfective mastitis of newborn' where assessment_id = 'DEMO6750'
update c_Assessment_Definition SET last_updated=getdate(), description ='Nonparoxysmal AV nodal tachycardia', long_description='Nonparoxysmal AV nodal tachycardia' where assessment_id = 'DEMO1783'
update c_Assessment_Definition SET last_updated=getdate(), description ='Non-Q wave myocardial infarction NOS', long_description='Non-Q wave myocardial infarction NOS' where assessment_id = 'DEMO1679'
update c_Assessment_Definition SET last_updated=getdate(), description ='Non-reassuring fetal heart rate or rhythm complicating labor and delivery', long_description='Non-reassuring fetal heart rate or rhythm complicating labor and delivery' where assessment_id = 'DEMO11010'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric avulsion of inner symphyseal cartilage', long_description='Obstetric avulsion of inner symphyseal cartilage' where assessment_id = 'DEMO11113'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric damage to coccyx', long_description='Obstetric damage to coccyx' where assessment_id = 'DEMO11114'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric hematoma of perineum', long_description='Obstetric hematoma of perineum' where assessment_id = 'DEMO1063'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric hematoma of vagina', long_description='Obstetric hematoma of vagina' where assessment_id = 'DEMO11097'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric hematoma of vulva', long_description='Obstetric hematoma of vulva' where assessment_id = 'DEMO11098'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric injury to bladder', long_description='Obstetric injury to bladder' where assessment_id = 'DEMO11115'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric injury to urethra', long_description='Obstetric injury to urethra' where assessment_id = 'DEMO11116'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric periurethral trauma', long_description='Obstetric periurethral trauma' where assessment_id = 'DEMO11099'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstetric shock following labor and delivery', long_description='Obstetric shock following labor and delivery' where assessment_id = 'DEMO11171'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructive laryngitis (acute) NOS', long_description='Obstructive laryngitis (acute) NOS' where assessment_id = 'DEMO10552'
update c_Assessment_Definition SET last_updated=getdate(), description ='Obstructive laryngotracheitis NOS', long_description='Obstructive laryngotracheitis NOS' where assessment_id = 'DEMO4894'
update c_Assessment_Definition SET last_updated=getdate(), description ='Old vaginal laceration', long_description='Old vaginal laceration' where assessment_id = 'DEMO839'
update c_Assessment_Definition SET last_updated=getdate(), description ='Oliguria', long_description='Oliguria ' where assessment_id = 'DEMO1265'
update c_Assessment_Definition SET last_updated=getdate(), description ='Oophoritis following (induced) termination of pregnancy', long_description='Oophoritis following (induced) termination of pregnancy' where assessment_id = 'DEMO875ab'
update c_Assessment_Definition SET last_updated=getdate(), description ='Orchitis blennorrhagic (gonococcal)', long_description='Orchitis blennorrhagic (gonococcal)' where assessment_id = 'DEMO4403'
update c_Assessment_Definition SET last_updated=getdate(), description ='Orchitis gonococcal acute', long_description='Orchitis gonococcal acute' where assessment_id = 'DEMO4395'
update c_Assessment_Definition SET last_updated=getdate(), description ='Orchitis gonococcal chronic', long_description='Orchitis gonococcal chronic' where assessment_id = 'DEMO4402'
update c_Assessment_Definition SET last_updated=getdate(), description ='Osteopoikilosis', long_description='Osteopoikilosis' where assessment_id = 'DEMO6282'
update c_Assessment_Definition SET last_updated=getdate(), description ='Osteoradionecrosis jaw(s)', long_description='Osteoradionecrosis jaw(s)' where assessment_id = 'DEMO7662'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other (or unknown) substance use disorder, mild', long_description='Other (or unknown) substance use disorder, mild' where assessment_id = 'DEMO9738'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other (or unknown) substance use disorder, moderate', long_description='Other (or unknown) substance use disorder, moderate' where assessment_id = 'DEMO9727'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other (or unknown) substance use disorder, severe', long_description='Other (or unknown) substance use disorder, severe' where assessment_id = 'DEMO9728'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified disruptive disorder', long_description='Other specified disruptive disorder' where assessment_id = 'DEMO9808'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified sleep-wake disorder', long_description='Other specified sleep-wake disorder' where assessment_id = 'DEMO2097'
update c_Assessment_Definition SET last_updated=getdate(), description ='Other specified trauma and stressor-related disorder', long_description='Other specified trauma and stressor-related disorder' where assessment_id = 'DEMO9793'
update c_Assessment_Definition SET last_updated=getdate(), description ='Owren''s disease', long_description='Owren''s disease' where assessment_id = 'DEMO7479'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pain genital organ', long_description='Pain genital organ ' where assessment_id = 'DEMO868'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pancarditis (acute)(chronic)', long_description='Pancarditis (acute)(chronic)' where assessment_id = 'DEMO1802'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pancreatic fat necrosis, unrelated to acute pancreatitis', long_description='Pancreatic fat necrosis, unrelated to acute pancreatitis' where assessment_id = 'DEMO8080'
update c_Assessment_Definition SET last_updated=getdate(), description ='Panhypopituitarism', long_description='Panhypopituitarism' where assessment_id = 'PANH'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paraganglioma aortic body malignant', long_description='Paraganglioma aortic body malignant' where assessment_id = 'DEMO8396'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paraganglioma glomus jugulare malignant', long_description='Paraganglioma glomus jugulare malignant' where assessment_id = 'DEMO8395'
update c_Assessment_Definition SET last_updated=getdate(), description ='Parametritis following (induced) termination of pregnancy', long_description='Parametritis following (induced) termination of pregnancy' where assessment_id = 'DEMO875ar'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paranoia querulans', long_description='Paranoia querulans' where assessment_id = 'DEMO9645'
update c_Assessment_Definition SET last_updated=getdate(), description ='Paranoia', long_description='Paranoia' where assessment_id = 'DEMO9641'
update c_Assessment_Definition SET last_updated=getdate(), description ='Parenchymatous mastitis associated with lactation', long_description='Parenchymatous mastitis associated with lactation' where assessment_id = 'DEMO11294'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peg-shaped [conical] teeth', long_description='Peg-shaped [conical] teeth' where assessment_id = 'DEMO7575'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pelger-Huët (granulation) (granulocyte) anomaly', long_description='Pelger-Huët (granulation) (granulocyte) anomaly' where assessment_id = 'DEMO7523'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pelvic cellulitis, female', long_description='Pelvic cellulitis, female' where assessment_id = 'DEMO755'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pelvic peritonitis following (induced) termination of pregnancy', long_description='Pelvic peritonitis following (induced) termination of pregnancy' where assessment_id = 'DEMO875b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pelvic thrombophlebitis, postpartum', long_description='Pelvic thrombophlebitis, postpartum' where assessment_id = 'DEMO11218'
update c_Assessment_Definition SET last_updated=getdate(), description ='Periarthritis NOS', long_description='Periarthritis NOS' where assessment_id = 'DEMO3771'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perineal laceration, rupture or tear involving fourchette during delivery', long_description='Perineal laceration, rupture or tear involving fourchette during delivery' where assessment_id = 'DEMO11087'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perineal laceration, rupture or tear involving labia during delivery', long_description='Perineal laceration, rupture or tear involving labia during delivery' where assessment_id = 'DEMO11088'
update c_Assessment_Definition SET last_updated=getdate(), description ='Periostitis without osteomyelitis', long_description='Periostitis without osteomyelitis' where assessment_id = 'DEMO3908'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peripharyngeal abscess', long_description='Peripharyngeal abscess' where assessment_id = 'DEMO4919'
update c_Assessment_Definition SET last_updated=getdate(), description ='Perisplenitis', long_description='Perisplenitis' where assessment_id = 'DEMO7552'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peritonitis diphtheritic', long_description='Peritonitis diphtheritic ' where assessment_id = 'DEMO4120'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peroneal muscular atrophy (axonal type) (hypertrophic type)', long_description='Peroneal muscular atrophy (axonal type) (hypertrophic type)' where assessment_id = 'DEMO7389'
update c_Assessment_Definition SET last_updated=getdate(), description ='Persistent lanugo', long_description='Persistent lanugo' where assessment_id = 'DEMO6062'
update c_Assessment_Definition SET last_updated=getdate(), description ='Persistent right aortic arch', long_description='Persistent right aortic arch' where assessment_id = 'DEMO2053'
update c_Assessment_Definition SET last_updated=getdate(), description ='Persistent thyroglossal duct', long_description='Persistent thyroglossal duct' where assessment_id = 'DEMO6088'
update c_Assessment_Definition SET last_updated=getdate(), description ='Person feigning illness (with obvious motivation)', long_description='Person feigning illness (with obvious motivation)' where assessment_id = 'DEMO9523'
update c_Assessment_Definition SET last_updated=getdate(), description ='Personal history of trophoblastic disease', long_description='Personal history of trophoblastic disease' where assessment_id = 'DEMO11428A'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pessary ulcer of vagina', long_description='Pessary ulcer of vagina' where assessment_id = 'DEMO841'
update c_Assessment_Definition SET last_updated=getdate(), description ='Petechiae', long_description='Petechiae' where assessment_id = 'DEMO2084'
update c_Assessment_Definition SET last_updated=getdate(), description ='Peutz-Jeghers Syndrome', long_description='Peutz-Jeghers Syndrome' where assessment_id = 'DEMO6098'
update c_Assessment_Definition SET last_updated=getdate(), description ='Phobic anxiety disorder of childhood', long_description='Phobic anxiety disorder of childhood' where assessment_id = 'DEMO9671'
update c_Assessment_Definition SET last_updated=getdate(), description ='Plague pulmonary', long_description='Plague pulmonary' where assessment_id = 'DEMO4080'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pleurisy with effusion tuberculous primary', long_description='Pleurisy with effusion tuberculous primary ' where assessment_id = 'DEMO4018'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Pneumonia (acute) (double) (migratory) (purulent) (septic) (unresolved) in (due to) Yersinia pestis' where assessment_id = 'DEMO4081'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pneumonia due to Pneumocystis jiroveci', long_description='Pneumonia due to Pneumocystis jiroveci' where assessment_id = '0^136.3^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Polyalgia', long_description='Polyalgia' where assessment_id = 'DEMO3824'
update c_Assessment_Definition SET last_updated=getdate(), description ='Portwine Nevus', long_description='Portwine Nevus' where assessment_id = 'PORT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterior (true) transmural (Q wave) infarction (acute)', long_description='Posterior (true) transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1690a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterior corneal dystrophy', long_description='Posterior corneal dystrophy' where assessment_id = 'DEMO6320'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterobasal transmural (Q wave) infarction (acute)', long_description='Posterobasal transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1691'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posterolateral transmural (Q wave) infarction (acute)', long_description='Posterolateral transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1699'
update c_Assessment_Definition SET last_updated=getdate(), description ='Posteroseptal transmural (Q wave) infarction (acute)', long_description='Posteroseptal transmural (Q wave) infarction (acute)' where assessment_id = 'DEMO1700'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postherpetic radiculopathy', long_description='Postherpetic radiculopathy' where assessment_id = 'DEMO8930'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postirradiation hypothyroidism', long_description='Postirradiation hypothyroidism' where assessment_id = 'DEMO4613'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postmenopausal endometrium suppurative', long_description='Postmenopausal endometrium suppurative' where assessment_id = 'DEMO767'
update c_Assessment_Definition SET last_updated=getdate(), description ='Postmenopausal urethritis', long_description='Postmenopausal urethritis' where assessment_id = 'DEMO7038'
update c_Assessment_Definition SET last_updated=getdate(), description ='Precordial friction', long_description='Precordial friction' where assessment_id = 'DEMO2120'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pregnancy over 40 completed weeks to 42 completed weeks gestation', long_description='Pregnancy over 40 completed weeks to 42 completed weeks gestation' where assessment_id = 'DEMO10712'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pregnancy which has advanced beyond 42 completed weeks gestation', long_description='Pregnancy which has advanced beyond 42 completed weeks gestation' where assessment_id = 'DEMO10713'
update c_Assessment_Definition SET last_updated=getdate(), description ='Presence of pseudophakia', long_description='Presence of pseudophakia' where assessment_id = 'DEMO9085'
update c_Assessment_Definition SET last_updated=getdate(), description ='Preseptal cellulitis', long_description='Preseptal cellulitis' where assessment_id = 'DEMO5050'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary agalactia', long_description='Primary agalactia' where assessment_id = 'DEMO11316'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm corpus callosum', long_description='Primary malignant neoplasm corpus callosum' where assessment_id = 'DEMO8338'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm craniobuccal pouch', long_description='Primary malignant neoplasm craniobuccal pouch' where assessment_id = 'DEMO8388'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm of craniopharyngeal duct', long_description='Primary malignant neoplasm of craniopharyngeal duct' where assessment_id = 'DEMO8385'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm of para-aortic body', long_description='Primary malignant neoplasm of para-aortic body' where assessment_id = 'DEMO8394'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Primary malignant neoplasm of two or more contiguous sites of male genital organs whose point of origin cannot be determined' where assessment_id = 'DEMO8300'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm tapetum', long_description='Primary malignant neoplasm tapetum' where assessment_id = 'DEMO8339'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary malignant neoplasm thyroglossal duct', long_description='Primary malignant neoplasm thyroglossal duct' where assessment_id = 'DEMO8382'
update c_Assessment_Definition SET last_updated=getdate(), description ='Primary retinal cyst', long_description='Primary retinal cyst' where assessment_id = 'DEMO5338'
update c_Assessment_Definition SET last_updated=getdate(), description ='Progeria', long_description='Progeria' where assessment_id = 'DEMO4715'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prolapsed hemorrhoids, degree not specified', long_description='Prolapsed hemorrhoids, degree not specified' where assessment_id = 'DEMO1949'
update c_Assessment_Definition SET last_updated=getdate(), description ='Prosopagnosia', long_description='Prosopagnosia' where assessment_id = 'DEMO5581'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pseudocyst of retina', long_description='Pseudocyst of retina' where assessment_id = 'DEMO5340'
update c_Assessment_Definition SET last_updated=getdate(), description ='Psychogenic dysmenorrhea', long_description='Psychogenic dysmenorrhea' where assessment_id = 'DEMO9741'
update c_Assessment_Definition SET last_updated=getdate(), description ='Psychogenic dysphagia, including "globus hystericus"', long_description='Psychogenic dysphagia, including "globus hystericus"' where assessment_id = 'DEMO9742'
update c_Assessment_Definition SET last_updated=getdate(), description ='Psychogenic pruritus', long_description='Psychogenic pruritus' where assessment_id = 'DEMO9743'
update c_Assessment_Definition SET last_updated=getdate(), description ='Psychogenic torticollis', long_description='Psychogenic torticollis' where assessment_id = 'DEMO9744'
update c_Assessment_Definition SET last_updated=getdate(), description ='Psychosomatic disorder NOS', long_description='Psychosomatic disorder NOS' where assessment_id = 'DEMO9753'
update c_Assessment_Definition SET last_updated=getdate(), description ='Puerperal abscess of nipple', long_description='Puerperal abscess of nipple' where assessment_id = 'DEMO11281'
update c_Assessment_Definition SET last_updated=getdate(), description ='Puerperal galactocele', long_description='Puerperal galactocele' where assessment_id = 'DEMO11328'
update c_Assessment_Definition SET last_updated=getdate(), description ='Puerperal purulent mastitis', long_description='Puerperal purulent mastitis' where assessment_id = 'DEMO11285'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pulmonary edema following obstetric surgery or procedures', long_description='Pulmonary edema following obstetric surgery or procedures' where assessment_id = 'DEMO11185'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pulmonary embolism following (induced) termination of pregnancy', long_description='Pulmonary embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877w7r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Purpura fulminans', long_description='Purpura fulminans' where assessment_id = 'DEMO7493'
update c_Assessment_Definition SET last_updated=getdate(), description ='Purpura simplex', long_description='Purpura simplex' where assessment_id = 'DEMO295'
update c_Assessment_Definition SET last_updated=getdate(), description ='Purulent endophthalmitis', long_description='Purulent endophthalmitis' where assessment_id = 'DEMO5281'
update c_Assessment_Definition SET last_updated=getdate(), description ='Purulent rhinitis (chronic)', long_description='Purulent rhinitis (chronic)' where assessment_id = 'DEMO10471'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyemic embolism following (induced) termination of pregnancy', long_description='Pyemic embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877z7b'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pygopagus', long_description='Pygopagus' where assessment_id = 'DEMO6094'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pylephlebitis', long_description='Pylephlebitis' where assessment_id = 'DEMO7993'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyloritis', long_description='Pyloritis ' where assessment_id = 'DEMO7802a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Pyocystitis with hematuria', long_description='Pyocystitis with hematuria' where assessment_id = 'DEMO7010'
update c_Assessment_Definition SET last_updated=getdate(), description ='Radioulnar synostosis', long_description='Radioulnar synostosis' where assessment_id = 'DEMO6215'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rales', long_description='Rales' where assessment_id = 'DEMO2128'
update c_Assessment_Definition SET last_updated=getdate(), description ='Recurrent appendicitis', long_description='Recurrent appendicitis' where assessment_id = 'DEMO7733'
update c_Assessment_Definition SET last_updated=getdate(), description ='Recurrent periodic urticaria', long_description='Recurrent periodic urticaria' where assessment_id = 'DEMO5152'
update c_Assessment_Definition SET last_updated=getdate(), description ='Reflex hyperactive gag', long_description='Reflex hyperactive gag' where assessment_id = 'DEMO4933'
update c_Assessment_Definition SET last_updated=getdate(), description ='Regional enteritis NOS', long_description='Regional enteritis NOS' where assessment_id = 'RENT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal cortical necrosis', long_description='Renal cortical necrosis' where assessment_id = 'DEMO6955'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal medullary [papillary] necrosis', long_description='Renal medullary [papillary] necrosis' where assessment_id = 'DEMO6956'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal stone', long_description='Renal stone' where assessment_id = 'DEMO8959'
update c_Assessment_Definition SET last_updated=getdate(), description ='Renal tubular necrosis following complete or unspecified spontaneous abortion', long_description='Renal tubular necrosis following complete or unspecified spontaneous abortion' where assessment_id = 'DEMO877w2'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to aminoglycosides', long_description='Resistance to aminoglycosides' where assessment_id = 'DEMO1473'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to cephalosporins', long_description='Resistance to cephalosporins' where assessment_id = 'DEMO9414'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to macrolides', long_description='Resistance to macrolides' where assessment_id = 'DEMO1474'
update c_Assessment_Definition SET last_updated=getdate(), description ='Resistance to sulfonamides', long_description='Resistance to sulfonamides' where assessment_id = 'DEMO9415'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retained products of conception following delivery, without hemorrhage', long_description='Retained products of conception following delivery, without hemorrhage' where assessment_id = 'DEMO11148'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retained products of conception NOS, following delivery', long_description='Retained products of conception NOS, following delivery' where assessment_id = 'DEMO11142'
update c_Assessment_Definition SET last_updated=getdate(), description ='Retention ovary syndrome', long_description='Retention ovary syndrome' where assessment_id = 'DEMO808'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rigors', long_description='Rigors ' where assessment_id = 'DEMO10598'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ring like corneal dystrophy', long_description='Ring like corneal dystrophy' where assessment_id = 'DEMO6315'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rocky Mountain spotted fever', long_description='Rocky Mountain spotted fever' where assessment_id = 'DEMO4293'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rudimentary eye', long_description='Rudimentary eye' where assessment_id = 'DEMO5723'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rupture of esophagus', long_description='Rupture of esophagus' where assessment_id = 'DEMO7757'
update c_Assessment_Definition SET last_updated=getdate(), description ='Rupture of uterus not stated as occurring before onset of labor', long_description='Rupture of uterus not stated as occurring before onset of labor' where assessment_id = 'DEMO11106'
update c_Assessment_Definition SET last_updated=getdate(), description ='Salpingitis following (induced) termination of pregnancy', long_description='Salpingitis following (induced) termination of pregnancy' where assessment_id = 'DEMO875r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Schmidt''s syndrome', long_description='Schmidt''s syndrome' where assessment_id = 'DEMO4707'
update c_Assessment_Definition SET last_updated=getdate(), description ='Scimitar syndrome', long_description='Scimitar syndrome' where assessment_id = 'DEMO2074'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary agalactia', long_description='Secondary agalactia' where assessment_id = 'DEMO11322'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary retinal cyst', long_description='Secondary retinal cyst' where assessment_id = 'DEMO5339'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary syphilitic chorioretinitis', long_description='Secondary syphilitic chorioretinitis' where assessment_id = 'DEMO4350'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary syphilitic iridocyclitis, iritis', long_description='Secondary syphilitic iridocyclitis, iritis' where assessment_id = 'DEMO4348'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary syphilitic lymphadenopathy', long_description='Secondary syphilitic lymphadenopathy' where assessment_id = 'DEMO4356'
update c_Assessment_Definition SET last_updated=getdate(), description ='Secondary syphilitic myositis', long_description='Secondary syphilitic myositis' where assessment_id = 'DEMO4347'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sensorineural deafness NOS', long_description='Sensorineural deafness NOS' where assessment_id = '0^389.16^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sepsis during labor', long_description='Sepsis during labor' where assessment_id = 'DEMO10998'
update c_Assessment_Definition SET last_updated=getdate(), description ='Septal transmural (Q wave) infarction (acute) NOS', long_description='Septal transmural (Q wave) infarction (acute) NOS' where assessment_id = 'DEMO1701'
update c_Assessment_Definition SET last_updated=getdate(), description ='Septic or septicopyemic embolism following (induced) termination of pregnancy', long_description='Septic or septicopyemic embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877z7q'
update c_Assessment_Definition SET last_updated=getdate(), description ='Septicemia NOS', long_description='Septicemia NOS' where assessment_id = 'SEPT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sequestrum of jaw bone', long_description='Sequestrum of jaw bone' where assessment_id = 'DEMO7663'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sequoiosis', long_description='Sequoiosis' where assessment_id = 'DEMO4986'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sexual maturation disorder', long_description='Sexual maturation disorder' where assessment_id = 'DEMO9720'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sialidosis [mucolipidosis I]', long_description='Sialidosis [mucolipidosis I]' where assessment_id = 'DEMO4776'
update c_Assessment_Definition SET last_updated=getdate(), description ='Simple acroparesthesia [Schultze''s type]', long_description='Simple acroparesthesia [Schultze''s type]' where assessment_id = 'DEMO1894'
update c_Assessment_Definition SET last_updated=getdate(), description ='Simultanagnosia (asimultagnosia)', long_description='Simultanagnosia (asimultagnosia)' where assessment_id = 'DEMO5582'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sinoatrial block', long_description='Sinoatrial block' where assessment_id = 'DEMO1776'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sinoatrial bradycardia', long_description='Sinoatrial bradycardia' where assessment_id = 'DEMO10608'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sinoauricular block', long_description='Sinoauricular block' where assessment_id = 'DEMO1777'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sinus bradycardia', long_description='Sinus bradycardia' where assessment_id = 'DEMO10608a'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sleep wake schedule disorder NOS', long_description='Sleep wake schedule disorder NOS' where assessment_id = 'DEMO2096'
update c_Assessment_Definition SET last_updated=getdate(), description ='Slow heart beat', long_description='Slow heart beat' where assessment_id = 'DEMO1789'
update c_Assessment_Definition SET last_updated=getdate(), description ='Soap embolism following (induced) termination of pregnancy', long_description='Soap embolism following (induced) termination of pregnancy' where assessment_id = 'DEMO877z7r'
update c_Assessment_Definition SET last_updated=getdate(), description ='Socialized conduct disorder', long_description='Socialized conduct disorder' where assessment_id = 'DEMO9802'
update c_Assessment_Definition SET last_updated=getdate(), description ='Somatoform autonomic dysfunction', long_description='Somatoform autonomic dysfunction' where assessment_id = 'DEMO9745'
update c_Assessment_Definition SET last_updated=getdate(), description ='Spastic cerebral palsy NOS', long_description='Spastic cerebral palsy NOS' where assessment_id = 'DEMO7278'
update c_Assessment_Definition SET last_updated=getdate(), description ='Splenitis NOS', long_description='Splenitis NOS' where assessment_id = 'DEMO7553'
update c_Assessment_Definition SET last_updated=getdate(), description ='Squashed or bent nose, congenital', long_description='Squashed or bent nose, congenital' where assessment_id = 'DEMO6123'
update c_Assessment_Definition SET last_updated=getdate(), description ='Staghorn calculus', long_description='Staghorn calculus' where assessment_id = 'RENCAL'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stargardt''s disease', long_description='Stargardt''s disease' where assessment_id = 'DEMO5390'
update c_Assessment_Definition SET last_updated=getdate(), description ='Starvation edema', long_description='Starvation edema' where assessment_id = 'DEMO4719'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stenosis heart valve congenital', long_description='Stenosis heart valve congenital' where assessment_id = 'DEMO2042'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stenosis of cystic duct or gallbladder without cholelithiasis', long_description='Stenosis of cystic duct or gallbladder without cholelithiasis' where assessment_id = 'DEMO8041'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stenosis of duodenum', long_description='Stenosis of duodenum' where assessment_id = 'DEMO7813'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stenosis of salivary duct', long_description='Stenosis of salivary duct' where assessment_id = 'DEMO7675'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sternomastoid tumor (congenital)', long_description='Sternomastoid tumor (congenital)' where assessment_id = 'DEMO6128'
update c_Assessment_Definition SET last_updated=getdate(), description ='Strawberry Nevus', long_description='Strawberry Nevus' where assessment_id = 'STRAW'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stricture of cystic duct or gallbladder without cholelithiasis', long_description='Stricture of cystic duct or gallbladder without cholelithiasis' where assessment_id = 'DEMO8042'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stricture of duodenum', long_description='Stricture of duodenum' where assessment_id = 'DEMO7815'
update c_Assessment_Definition SET last_updated=getdate(), description ='Stricture of spermatic cord, tunica vaginalis, and vas deferens', long_description='Stricture of spermatic cord, tunica vaginalis, and vas deferens' where assessment_id = 'DEMO7142'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sturge-Weber(-Dimitri) syndrome', long_description='Sturge-Weber(-Dimitri) syndrome' where assessment_id = 'DEMO6099'
update c_Assessment_Definition SET last_updated=getdate(), description ='subclavian (artery) (ruptured)', long_description='subclavian (artery) (ruptured)' where assessment_id = 'DEMO1881'
update c_Assessment_Definition SET last_updated=getdate(), description ='Superior limbic keratoconjunctivitis', long_description='Superior limbic keratoconjunctivitis' where assessment_id = 'DEMO5665'
update c_Assessment_Definition SET last_updated=getdate(), description ='Sycosis barbae', long_description='Sycosis barbae' where assessment_id = 'DEMO5131'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Symptoms such as flushing, sleeplessness, headache, lack of concentration, associated with postprocedural menopause' where assessment_id = 'DEMO10230'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilitic coronary artery disease', long_description='Syphilitic coronary artery disease' where assessment_id = 'DEMO4364'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilitic endocarditis aortic', long_description='Syphilitic endocarditis aortic' where assessment_id = 'DEMO4362'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilitic mitral valve stenosis', long_description='Syphilitic mitral valve stenosis' where assessment_id = 'DEMO4361'
update c_Assessment_Definition SET last_updated=getdate(), description ='Syphilitic pulmonary valve regurgitation', long_description='Syphilitic pulmonary valve regurgitation' where assessment_id = 'DEMO4363'
update c_Assessment_Definition SET last_updated=getdate(), description ='Teeth grinding', long_description='Teeth grinding' where assessment_id = 'DEMO9747'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tendinitis NOS', long_description='Tendinitis NOS' where assessment_id = 'TEN'
update c_Assessment_Definition SET last_updated=getdate(), description ='Therapeutic agalactia', long_description='Therapeutic agalactia' where assessment_id = 'DEMO11323'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Third degree perineal laceration during delivery with both external anal sphincter (EAS) and internal anal sphincter (IAS) torn' where assessment_id = 'DEMO11091'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thoracopagus', long_description='Thoracopagus' where assessment_id = 'DEMO6095'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thromboasthenia (hemorrhagic) (hereditary)', long_description='Thromboasthenia (hemorrhagic) (hereditary)' where assessment_id = 'DEMO7502'
update c_Assessment_Definition SET last_updated=getdate(), description ='Thrombosis of male genital organs', long_description='Thrombosis of male genital organs' where assessment_id = 'DEMO7134'
update c_Assessment_Definition SET last_updated=getdate(), description ='Total anomalous pulmonary venous return [TAPVR], subdiaphragmatic', long_description='Total anomalous pulmonary venous return [TAPVR], subdiaphragmatic' where assessment_id = 'DEMO2070'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxemia fatigue', long_description='Toxemia fatigue' where assessment_id = 'DEMO2101'
update c_Assessment_Definition SET last_updated=getdate(), description ='Toxemia stasis', long_description='Toxemia stasis' where assessment_id = 'DEMO1222'
update c_Assessment_Definition SET last_updated=getdate(), description ='Transmural (Q wave) infarction (acute) (of) anterior (wall) NOS', long_description='Transmural (Q wave) infarction (acute) (of) anterior (wall) NOS' where assessment_id = 'DEMO1683'
update c_Assessment_Definition SET last_updated=getdate(), description ='Transmural (Q wave) infarction (acute) (of) diaphragmatic wall', long_description='Transmural (Q wave) infarction (acute) (of) diaphragmatic wall' where assessment_id = 'DEMO1695'
update c_Assessment_Definition SET last_updated=getdate(), description ='Transmural (Q wave) infarction (acute) (of) inferior (wall) NOS', long_description='Transmural (Q wave) infarction (acute) (of) inferior (wall) NOS' where assessment_id = 'DEMO1696'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis bronchi fistula primary', long_description='Tuberculosis bronchi fistula primary' where assessment_id = 'DEMO4015'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of bronchus', long_description='Tuberculosis of bronchus' where assessment_id = 'DEMO4043'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis of hip (joint)', long_description='Tuberculosis of hip (joint)' where assessment_id = 'DEMO4055'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculosis, pulmonary', long_description='Tuberculosis, pulmonary' where assessment_id = 'DEMO4027'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous abscess of brain and spinal cord', long_description='Tuberculous abscess of brain and spinal cord' where assessment_id = 'DEMO4047'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous adenitis', long_description='Tuberculous adenitis' where assessment_id = 'DEMO4067'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous bronchiectasis', long_description='Tuberculous bronchiectasis' where assessment_id = 'DEMO4005'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous conjunctivitis', long_description='Tuberculous conjunctivitis' where assessment_id = 'DEMO5682'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous fibrosis of lung', long_description='Tuberculous fibrosis of lung' where assessment_id = 'DEMO4014'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous mastoiditis', long_description='Tuberculous mastoiditis' where assessment_id = 'DEMO4057'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous osteomyelitis', long_description='Tuberculous osteomyelitis' where assessment_id = 'DEMO4058'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous pneumonia', long_description='Tuberculous pneumonia' where assessment_id = 'DEMO4021'
update c_Assessment_Definition SET last_updated=getdate(), description ='Tuberculous pneumothorax', long_description='Tuberculous pneumothorax' where assessment_id = 'DEMO4023'
update c_Assessment_Definition SET last_updated=getdate(), description ='Uhl''s disease', long_description='Uhl''s disease' where assessment_id = 'DEMO2035'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ulcer of biliary tract', long_description='Ulcer of biliary tract' where assessment_id = 'DEMO8068'
update c_Assessment_Definition SET last_updated=getdate(), long_description='Ulcer of scrotum, seminal vesicle, spermatic cord, testis, tunica vaginalis and vas deferens' where assessment_id = 'DEMO8982'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ulcer of urethra (meatus)', long_description='Ulcer of urethra (meatus)' where assessment_id = 'DEMO7039'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unacceptable contours of existing restoration of tooth', long_description='Unacceptable contours of existing restoration of tooth' where assessment_id = '0^525.65^0'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unilateral condylar hyperplasia', long_description='Unilateral condylar hyperplasia' where assessment_id = 'DEMO7667'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unilateral condylar hypoplasia', long_description='Unilateral condylar hypoplasia' where assessment_id = 'DEMO7668'
update c_Assessment_Definition SET last_updated=getdate(), description ='Unspecified sleep-wake disorder', long_description='Unspecified sleep-wake disorder' where assessment_id = 'SLEEPPROB'
update c_Assessment_Definition SET last_updated=getdate(), description ='Urethritis NOS', long_description='Urethritis NOS' where assessment_id = 'DEMO7040'
update c_Assessment_Definition SET last_updated=getdate(), description ='Urethroscrotal fistula', long_description='Urethroscrotal fistula' where assessment_id = 'DEMO8983'
update c_Assessment_Definition SET last_updated=getdate(), description ='Uterine atony with hemorrhage', long_description='Uterine atony with hemorrhage' where assessment_id = 'DEMO11139'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vagal bradycardia', long_description='Vagal bradycardia' where assessment_id = 'PAT'
update c_Assessment_Definition SET last_updated=getdate(), description ='Variola (major) (minor)', long_description='Variola (major) (minor)' where assessment_id = 'DEMO4174'
update c_Assessment_Definition SET last_updated=getdate(), description ='Varioloid', long_description='Varioloid' where assessment_id = 'DEMO4176'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vascular pseudohemophilia', long_description='Vascular pseudohemophilia' where assessment_id = 'DEMO7506'
update c_Assessment_Definition SET last_updated=getdate(), description ='Vasomotor acroparesthesia [Nothnagel''s type]', long_description='Vasomotor acroparesthesia [Nothnagel''s type]' where assessment_id = 'DEMO1895'
update c_Assessment_Definition SET last_updated=getdate(), description ='Ventricular aneurysm', long_description='Ventricular aneurysm' where assessment_id = 'DEMO10024'
update c_Assessment_Definition SET last_updated=getdate(), description ='Visual halos', long_description='Visual halos' where assessment_id = 'DEMO5579'
update c_Assessment_Definition SET last_updated=getdate(), description ='Waardenburg''s syndrome', long_description='Waardenburg''s syndrome' where assessment_id = 'DEMO4751'
update c_Assessment_Definition SET last_updated=getdate(), description ='Wandering spleen', long_description='Wandering spleen ' where assessment_id = 'DEMO7554'
update c_Assessment_Definition SET last_updated=getdate(), description ='Wenckebach''s block', long_description='Wenckebach''s block' where assessment_id = 'DEMO10616'
update c_Assessment_Definition SET last_updated=getdate(), description ='Zoster blepharitis', long_description='Zoster blepharitis' where assessment_id = 'DEMO4190'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Asthma, chronic, with acute exacerbation' where assessment_id = 'DEMO10485'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Asthma, chronic, with acute exacerbation' where assessment_id = 'DEMO10485'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Cyst, mediastinum, congenital' where assessment_id = 'DEMO5811'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Cyst, mouth, dermoid' where assessment_id = 'DEMO7687'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Cyst, mouth, epidermoid' where assessment_id = 'DEMO7688'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Cyst, mouth, Epstein''s pearl' where assessment_id = 'DEMO7689'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Death, instantaneous' where assessment_id = 'DEMO1320'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Depression, neurotic' where assessment_id = 'DEMO9672'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Frontal lobe syndrome' where assessment_id = 'DEMO352'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Heberden''s nodes' where assessment_id = 'DEMO7997'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Herpes simplex' where assessment_id = 'HERPO'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Herpes zoster otitis externa' where assessment_id = 'DEMO4210'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Herpetic whitlow' where assessment_id = 'DEMO4205'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Hydroxykynureninuria' where assessment_id = 'DEMO4763'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Infestation, skin NOS' where assessment_id = 'DEMO4559'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Majocchi''s granuloma' where assessment_id = 'DEMO4453'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Nephrocalcinosis' where assessment_id = 'DEMO4795'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Neurasthenia' where assessment_id = 'DEMO9673'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, filariasis' where assessment_id = 'DEMO9327'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, helminthiasis' where assessment_id = 'DEMO9328'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, leishmaniasis' where assessment_id = 'DEMO9324'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, malaria' where assessment_id = 'DEMO9323'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, schistosomiasis' where assessment_id = 'DEMO9326'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Screening, trypanosomiasis' where assessment_id = 'DEMO9325'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Adolescent (13 Yrs)' where assessment_id = 'WELL13Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Adolescent (14 Yrs)' where assessment_id = 'WELL14Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Adolescent (15 Yrs)' where assessment_id = 'WELL15Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Adolescent (16 Yrs)' where assessment_id = 'WELL16Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Adolescent (17 Yrs)' where assessment_id = 'WELL17Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (< 8 days old)' where assessment_id = 'WELLNEWBORN'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (10 Yrs)' where assessment_id = 'WELL10Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (11 Yrs)' where assessment_id = 'WELL11Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (12 Months)' where assessment_id = 'WELL12M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (12 Yrs)' where assessment_id = 'WELL12Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (15 Months)' where assessment_id = 'WELL15M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (18 Months)' where assessment_id = 'WELL18M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (2 1/2 Yrs)' where assessment_id = '0^11614'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (2 Months)' where assessment_id = 'WELL2M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (2 Yrs)' where assessment_id = 'WELL2Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (29 days to 2 months)' where assessment_id = 'WELL1M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (3 Yrs)' where assessment_id = 'WELL3Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (4 Months)' where assessment_id = 'WELL4M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (4 Yrs)' where assessment_id = 'WELL4Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (5 Yrs)' where assessment_id = 'WELL5Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (6 Months)' where assessment_id = 'WELL6M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (6 Yrs)' where assessment_id = 'WELL6Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (7 Yrs)' where assessment_id = 'WELL7Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (8 - 28 days old)' where assessment_id = 'WELL2W'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (8 Yrs)' where assessment_id = 'WELL8Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (9 Months)' where assessment_id = 'WELL9M'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child (9 Yrs)' where assessment_id = 'WELL9Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well child services during sick visit' where assessment_id = 'DEMO11433'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Child/Adolescent Exam' where assessment_id = 'DEMO1215'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Visit (18 Yrs)' where assessment_id = 'WELL18Y'
update c_Assessment_Definition SET last_updated=getdate(), long_description ='Well Visit (19 Yrs)' where assessment_id = 'WELL19Y'

-- Descriptions which were too long in the spread sheet and needed to be truncated to 80 chars.
UPDATE c_Assessment_Definition 
SET description = left(long_description,77) + '...' 
WHERE assessment_id IN (
'DEMO10839',
'0^12050',
'000167x',
'DEMO10595',
'DEMO10501',
'DEMO2870',
'DEMO5542',
'DEMO2598',
'0^995.27^0',
'DEMO10371',
'DEMO10291',
'DEMO2780',
'0^11890',
'0^11891',
'0^11892',
'DEMO2982',
'DEMO443',
'DEMO3544',
'DEMO2562',
'DEMO2563',
'DEMO2611',
'DEMO2558',
'DEMO10990',
'DEMO10396',
'DEMO517',
'0^12308',
'0^12073',
'DEMO10792',
'DEMO1122',
'0^12291',
'DEMO1123',
'DEMO2159',
'DEMO2177',
'DEMO2195',
'DEMO10684',
'DEMO10683',
'DEMO1619',
'DEMO1596',
'DEMO10418',
'DEMO1603',
'DEMO1598',
'DEMO1616',
'DEMO3362',
'DEMO3081',
'DEMO1043',
'DEMO11084',
'DEMO1048',
'DEMO11078',
'DEMO1042',
'DEMO1047',
'AVULSB',
'DEMO2837B',
'DEMO2848B',
'DEMO2846B',
'DEMO2859B',
'DEMO2827A',
'AVULSA',
'DEMO2601',
'DEMO7312',
'DEMO7313',
'DEMO5420',
'DEMO10930',
'DEMO10932',
'DEMO10940',
'DEMO10942',
'DEMO10938',
'DEMO10936',
'DEMO10948',
'DEMO10934',
'DEMO10881',
'DEMO10875',
'DEMO10879',
'DEMO10877',
'DEMO10962',
'DEMO997',
'DEMO10856',
'DEMO10969',
'DEMO10860',
'DEMO10946',
'DEMO10954',
'DEMO10960',
'DEMO996',
'DEMO9836',
'DEMO156',
'DEMO2297',
'DEMO1181',
'DEMO2638',
'DEMO811',
'DEMO1187',
'DEMO1081',
'DEMO11023',
'DEMO1021',
'DEMO2792',
'DEMO2791',
'DEMO10841',
'0^649.32^0',
'DEMO2385',
'DEMO10757',
'DEMO9140',
'DEMO2351',
'DEMO2355',
'0^12217',
'0^11618',
'DEMO10985',
'DEMO1007',
'DEMO11428',
'0^11765A',
'0^11766A',
'DEMO8999A',
'DEMO1920',
'DEMO3242',
'DEMO2599',
'DEMO5315',
'0^238.79^0',
'DEMO1239',
'DEMO2595',
'DEMO2868',
'DEMO2867',
'DEMO2865',
'DEMO2866',
'DEMO2869',
'DEMO2856',
'DEMO2854',
'DEMO2853',
'DEMO2852',
'DEMO3926',
'DEMO3923',
'DEMO2788',
'DEMO9017A',
'DEMO1412',
'DEMO1412A',
'DEMO2713',
'DEMO1684',
'DEMO1697',
'DEMO2750',
'DEMO2719',
'DEMO2746',
'DEMO2742',
'DEMO1130',
'981^995.94^0',
'DEMO3272',
'DEMO3275',
'DEMO3301',
'DEMO3286',
'DEMO3293',
'DEMO3299',
'DEMO10292',
'DEMO10828',
'DEMO10826',
'0^12005',
'DEMO9752',
'DEMO3367',
'DEMO3370',
'DEMO2547',
'DEMO2453',
'DEMO2538',
'DEMO2399',
'DEMO2404',
'DEMO2496',
'DEMO2501',
'DEMO2391',
'DEMO2395',
'DEMO2394',
'DEMO159',
'DEMO2451',
'DEMO2930',
'DEMO2902',
'DEMO2913',
'DEMO2946',
'DEMO2895',
'DEMO2993',
'DEMO931',
'DEMO10783',
'DEMO2962',
'DEMO10052',
'DEMO2811',
'AVULS',
'DEMO10345',
'DEMO7430',
'DEMO1029',
'DEMO1145',
'DEMO7140',
'DEMO11141',
'DEMO10697',
'DEMO908',
'DEMO10699',
'DEMO7141',
'DEMO584',
'DEMO877w3',
'DEMO9576',
'DEMO4081',
'DEMO8300',
'DEMO10230',
'DEMO11091',
'DEMO8982',
'0^525.65^1')

-- Changes from Conference Call document

UPDATE c_assessment_definition
SET icd10_code = 'P590', assessment_id = 'DX-P590-4'
WHERE assessment_id = 'DX-P031-1'
AND icd10_code = 'P031'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P590-4' )
UPDATE c_assessment_definition
SET icd10_code = 'P598', assessment_id = 'DX-P598-3'
WHERE assessment_id = 'DX-P031-2'
AND icd10_code = 'P031'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P598-3' )
UPDATE c_assessment_definition
SET icd10_code = 'P598', assessment_id = 'DX-P598-4'
WHERE assessment_id = 'DX-P031-3'
AND icd10_code = 'P031'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P598-4' )
UPDATE c_assessment_definition
SET icd10_code = 'P588', assessment_id = 'DX-P588-2'
WHERE assessment_id = 'DX-P031-4'
AND icd10_code = 'P031'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P588-2' )
UPDATE c_assessment_definition
SET icd10_code = 'P589', assessment_id = 'DX-P589-1'
WHERE assessment_id = 'DX-P031-5'
AND icd10_code = 'P031'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P589-1' )


UPDATE c_assessment_definition
SET icd10_code = 'P031', assessment_id = 'DX-P031-1'
WHERE assessment_id = 'DX-P040-1'
AND icd10_code = 'P040'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P031-1' )
UPDATE c_assessment_definition
SET icd10_code = 'P021', assessment_id = 'DX-P021-7'
WHERE assessment_id = 'DX-P040-2'
AND icd10_code = 'P040'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P021-7' )
UPDATE c_assessment_definition
SET icd10_code = 'P017', assessment_id = 'DX-P017-6'
WHERE assessment_id = 'DX-P040-3'
AND icd10_code = 'P040'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P017-6' )
UPDATE c_assessment_definition
SET icd10_code = 'P017', assessment_id = 'DX-P017-7'
WHERE assessment_id = 'DX-P040-4'
AND icd10_code = 'P040'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P017-7' )
UPDATE c_assessment_definition
SET icd10_code = 'P036', assessment_id = 'DX-P036-4'
WHERE assessment_id = 'DX-P040-5'
AND icd10_code = 'P040'
AND NOT EXISTS ( SELECT 1 FROM c_assessment_definition WHERE assessment_id = 'DX-P036-4' )

