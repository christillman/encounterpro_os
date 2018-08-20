
update c_Assessment_Definition 
set description = long_description
where assessment_id in (
'DEMO6674',
'DEMO6674Q',
'DEMO1409',
'DEMO1409A',
'DEMO4831',
'DEMO4831A',
'DEMO6525Q',
'DEMO6528Q',
'DEMO6637Q',
'DEMO6638Q',
'DEMO6639Q',
'DEMO6641Q',
'DEMO6636Q',
'DEMO11416aQ',
'DEMO11416bQ',
'DEMO11416cQ',
'DEMO11416dQ',
'DEMO11416eQ',
'DEMO11416fQ',
'DEMO11416gQ',
'DEMO11416hQ',
'DEMO9444',
'DEMO9445',
'DEMO9434',
'DEMO6523',
'DEMO4063',
'0^238.76^0',
'DEMO6517',
'DEMO9615',
'DEMO309',
'DEMO9632',
'DEMO4281',
'DEMO4778'
)


DELETE FROM c_Assessment_Definition
WHERE assessment_id in (
'DEMO9067',
'DEMO6724',
'DEMO6503Q'
)


update c_Assessment_Definition set acuteness='Chronic' where assessment_id = 'DEMO7325'
update c_Assessment_Definition set description ='Cenesthopathic schizophrenia' where assessment_id = 'DEMO9625'
update c_Assessment_Definition set assessment_category_id ='NOEAR' where assessment_id = '0^V72.19^0'
update c_Assessment_Definition set assessment_category_id ='YMMM' where assessment_id = '981^V58.32^0'


