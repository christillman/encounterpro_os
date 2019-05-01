
UPDATE c_Assessment_Definition SET long_description = NULL
WHERE long_description = description
AND long_description IS NOT NULL

UPDATE c_Assessment_Definition SET icd10_code = RTRIM(icd10_code)
WHERE icd10_code LIKE '% '

UPDATE c_Assessment_Definition SET description = RTRIM(description)
WHERE description LIKE '% '

UPDATE c_Assessment_Definition SET long_description = RTRIM(long_description)
WHERE long_description LIKE '% '

UPDATE c_Assessment_Definition
SET icd10_code = RTRIM(REPLACE(icd10_code, char(160), ' '))
WHERE icd10_code LIKE '%' + char(160) + '%'

UPDATE c_Assessment_Definition
SET description = RTRIM(REPLACE(description, char(160), ' '))
WHERE description LIKE '%' + char(160) + '%'

UPDATE c_Assessment_Definition
SET long_description = RTRIM(REPLACE(long_description, char(160), ' '))
WHERE long_description LIKE '%' + char(160) + '%'

-- misspelling
UPDATE c_Assessment_Definition
SET description = 'Diarrhea dysenteric'
WHERE assessment_id = 'DEMO3890'

-- correct ICD2019 mismatch

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C43111', 'MainT', assessment_type, 'C43111', assessment_category_id, 'Malignant melanoma of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4311'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C43112', 'MainT', assessment_type, 'C43112', assessment_category_id, 'Malignant melanoma of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4311'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C43121', 'MainT', assessment_type, 'C43121', assessment_category_id, 'Malignant melanoma of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4312'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C43122', 'MainT', assessment_type, 'C43122', assessment_category_id, 'Malignant melanoma of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4312'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441021', 'MainT', assessment_type, 'C441021', assessment_category_id, 'Unspecified malignant neoplasm of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44102'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441022', 'MainT', assessment_type, 'C441022', assessment_category_id, 'Unspecified malignant neoplasm of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44102'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441091', 'MainT', assessment_type, 'C441091', assessment_category_id, 'Unspecified malignant neoplasm of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44109'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441092', 'MainT', assessment_type, 'C441092', assessment_category_id, 'Unspecified malignant neoplasm of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44109'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441121', 'MainT', assessment_type, 'C441121', assessment_category_id, 'Basal cell carcinoma of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44112'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441122', 'MainT', assessment_type, 'C441122', assessment_category_id, 'Basal cell carcinoma of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44112'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441191', 'MainT', assessment_type, 'C441191', assessment_category_id, 'Basal cell carcinoma of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44119'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441192', 'MainT', assessment_type, 'C441192', assessment_category_id, 'Basal cell carcinoma of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44119'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441221', 'MainT', assessment_type, 'C441221', assessment_category_id, 'Squamous cell carcinoma of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44122'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441222', 'MainT', assessment_type, 'C441222', assessment_category_id, 'Squamous cell carcinoma of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44122'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441291', 'MainT', assessment_type, 'C441291', assessment_category_id, 'Squamous cell carcinoma of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44129'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C441292', 'MainT', assessment_type, 'C441292', assessment_category_id, 'Squamous cell carcinoma of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44129'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, long_description, risk_level, owner_id, status ) SELECT 'ICD-C441921', 'MainT', assessment_type, 'C441921', assessment_category_id, 'Other specified malignant neoplasm of skin of right upper eyelid, including c...', 'Other specified malignant neoplasm of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44192'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, long_description, risk_level, owner_id, status ) SELECT 'ICD-C441922', 'MainT', assessment_type, 'C441922', assessment_category_id, 'Other specified malignant neoplasm of skin of right lower eyelid, including c...', 'Other specified malignant neoplasm of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44192'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, long_description, risk_level, owner_id, status ) SELECT 'ICD-C441991', 'MainT', assessment_type, 'C441991', assessment_category_id, 'Other specified malignant neoplasm of skin of left upper eyelid, including ca...', 'Other specified malignant neoplasm of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44199'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, long_description, risk_level, owner_id, status ) SELECT 'ICD-C441992', 'MainT', assessment_type, 'C441992', assessment_category_id, 'Other specified malignant neoplasm of skin of left lower eyelid, including ca...', 'Other specified malignant neoplasm of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C44199'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C4A111', 'MainT', assessment_type, 'C4A111', assessment_category_id, 'Merkel cell carcinoma of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4A11'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C4A112', 'MainT', assessment_type, 'C4A112', assessment_category_id, 'Merkel cell carcinoma of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4A11'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C4A121', 'MainT', assessment_type, 'C4A121', assessment_category_id, 'Merkel cell carcinoma of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4A12'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-C4A122', 'MainT', assessment_type, 'C4A122', assessment_category_id, 'Merkel cell carcinoma of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-C4A12'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D03111', 'MainT', assessment_type, 'D03111', assessment_category_id, 'Melanoma in situ of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0311'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D03112', 'MainT', assessment_type, 'D03112', assessment_category_id, 'Melanoma in situ of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0311'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D03121', 'MainT', assessment_type, 'D03121', assessment_category_id, 'Melanoma in situ of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5202'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D03122', 'MainT', assessment_type, 'D03122', assessment_category_id, 'Melanoma in situ of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5202'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D04111', 'MainT', assessment_type, 'D04111', assessment_category_id, 'Carcinoma in situ of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0411'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D04112', 'MainT', assessment_type, 'D04112', assessment_category_id, 'Carcinoma in situ of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0411'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D04121', 'MainT', assessment_type, 'D04121', assessment_category_id, 'Carcinoma in situ of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0412'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D04122', 'MainT', assessment_type, 'D04122', assessment_category_id, 'Carcinoma in situ of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D0412'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D22111', 'MainT', assessment_type, 'D22111', assessment_category_id, 'Melanocytic nevi of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2211'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D22112', 'MainT', assessment_type, 'D22112', assessment_category_id, 'Melanocytic nevi of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2211'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D22121', 'MainT', assessment_type, 'D22121', assessment_category_id, 'Melanocytic nevi of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2212'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D22122', 'MainT', assessment_type, 'D22122', assessment_category_id, 'Melanocytic nevi of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2212'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D23111', 'MainT', assessment_type, 'D23111', assessment_category_id, 'Other benign neoplasm of skin of right upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2311'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D23112', 'MainT', assessment_type, 'D23112', assessment_category_id, 'Other benign neoplasm of skin of right lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2311'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D23121', 'MainT', assessment_type, 'D23121', assessment_category_id, 'Other benign neoplasm of skin of left upper eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2312'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-D23122', 'MainT', assessment_type, 'D23122', assessment_category_id, 'Other benign neoplasm of skin of left lower eyelid, including canthus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-D2312'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-F530', 'MainT', assessment_type, 'F530', assessment_category_id, 'Postpartum depression', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO9606'
AND NOT EXISTS (SELECT 1 FROM c_Assessment_Definition WHERE assessment_id = 'ICD-F530')
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-E7841', 'MainT', assessment_type, 'E7841', assessment_category_id, 'Elevated Lipoprotein(a)', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-E7849'
AND NOT EXISTS (SELECT 1 FROM c_Assessment_Definition WHERE assessment_id = 'ICD-E7841')

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G5131', 'MainT', assessment_type, 'G5131', assessment_category_id, 'Clonic hemifacial spasm, right', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-G513'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G5132', 'MainT', assessment_type, 'G5132', assessment_category_id, 'Clonic hemifacial spasm, left', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-G513'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G5133', 'MainT', assessment_type, 'G5133', assessment_category_id, 'Clonic hemifacial spasm, bilateral', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-G513'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G5139', 'MainT', assessment_type, 'G5139', assessment_category_id, 'Clonic hemifacial spasm, unspecified', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-G513'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G7100', 'MainT', assessment_type, 'G7100', assessment_category_id, 'Muscular dystrophy, unspecified', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7407'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G7101', 'MainT', assessment_type, 'G7101', assessment_category_id, 'Duchenne or Becker muscular dystrophy', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7407'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G7102', 'MainT', assessment_type, 'G7102', assessment_category_id, 'Facioscapulohumeral muscular dystrophy', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7407'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-G7109', 'MainT', assessment_type, 'G7109', assessment_category_id, 'Other specified muscular dystrophies', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7407'


INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3520', 'MainT', assessment_type, 'K3520', assessment_category_id, 'Acute appendicitis with generalized peritonitis, without abscess', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7729'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3521', 'MainT', assessment_type, 'K3521', assessment_category_id, 'Acute appendicitis with generalized peritonitis, with abscess', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7729'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3530', 'MainT', assessment_type, 'K3530', assessment_category_id, 'Acute appendicitis with localized peritonitis, without perforation or gangrene', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7730'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3531', 'MainT', assessment_type, 'K3531', assessment_category_id, 'Acute appendicitis with localized peritonitis and gangrene, without perforation', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7730'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3532', 'MainT', assessment_type, 'K3532', assessment_category_id, 'Acute appendicitis with perforation and localized peritonitis, without abscess', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7730'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K3533', 'MainT', assessment_type, 'K3533', assessment_category_id, 'Acute appendicitis with perforation and localized peritonitis, with abscess', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO7730'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K35890', 'MainT', assessment_type, 'K35890', assessment_category_id, 'Other acute appendicitis without perforation or gangrene', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'APP'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K35891', 'MainT', assessment_type, 'K35891', assessment_category_id, 'Other acute appendicitis without perforation, with gangrene', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'APP'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K8301', 'MainT', assessment_type, 'K8301', assessment_category_id, 'Primary sclerosing cholangitis', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO8057'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-K8309', 'MainT', assessment_type, 'K8309', assessment_category_id, 'Other cholangitis', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO8057'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-M7910', 'MainT', assessment_type, 'M7910', assessment_category_id, 'Myalgia, unspecified site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-M791'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-M7911', 'MainT', assessment_type, 'M7911', assessment_category_id, 'Myalgia of mastication muscle', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-M791'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-M7912', 'MainT', assessment_type, 'M7912', assessment_category_id, 'Myalgia of auxiliary muscles, head and neck', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-M791'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-M7918', 'MainT', assessment_type, 'M7918', assessment_category_id, 'Myalgia, other site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-M791'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8600', 'MainT', assessment_type, 'O8600', assessment_category_id, 'Infection of obstetric surgical wound, unspecified', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8601', 'MainT', assessment_type, 'O8601', assessment_category_id, 'Infection of obstetric surgical wound, superficial incisional site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8602', 'MainT', assessment_type, 'O8602', assessment_category_id, 'Infection of obstetric surgical wound, deep incisional site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8603', 'MainT', assessment_type, 'O8603', assessment_category_id, 'Infection of obstetric surgical wound, organ and space site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8604', 'MainT', assessment_type, 'O8604', assessment_category_id, 'Sepsis following an obstetrical procedure', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-O8609', 'MainT', assessment_type, 'O8609', assessment_category_id, 'Infection of obstetric surgical wound, other surgical site', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-O860'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P0270', 'MainT', assessment_type, 'P0270', assessment_category_id, 'Newborn affected by fetal inflammatory response syndrome', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'MATF'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P0278', 'MainT', assessment_type, 'P0278', assessment_category_id, 'Newborn affected by other conditions from chorioamnionitis', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'MATF'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P0413', 'MainT', assessment_type, 'P0413', assessment_category_id, 'Newborn affected by maternal use of anticonvulsants', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'MATF'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P7421', 'MainT', assessment_type, 'P7421', assessment_category_id, 'Hypernatremia of newborn', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-P742'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P7422', 'MainT', assessment_type, 'P7422', assessment_category_id, 'Hyponatremia of newborn', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-P742'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P7431', 'MainT', assessment_type, 'P7431', assessment_category_id, 'Hyperkalemia of newborn', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-P743'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-P7432', 'MainT', assessment_type, 'P7432', assessment_category_id, 'Hypokalemia of newborn', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-P743'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-Q5120', 'MainT', assessment_type, 'Q5120', assessment_category_id, 'Other doubling of uterus, unspecified', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5910'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-Q5121', 'MainT', assessment_type, 'Q5121', assessment_category_id, 'Other complete doubling of uterus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5910'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-Q5122', 'MainT', assessment_type, 'Q5122', assessment_category_id, 'Other partial doubling of uterus', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5910'
INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-Q5128', 'MainT', assessment_type, 'Q5128', assessment_category_id, 'Other doubling of uterus, other specified', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'DEMO5910'

INSERT INTO c_Assessment_Definition (assessment_id, source, assessment_type, icd10_code, assessment_category_id, description, risk_level, owner_id, status ) SELECT 'ICD-Q9351', 'MainT', assessment_type, 'Q5128', assessment_category_id, 'Angelman syndrome', risk_level, owner_id, status FROM c_Assessment_Definition WHERE assessment_id = 'ICD-Q9359'
AND NOT EXISTS (SELECT 1 FROM c_Assessment_Definition WHERE assessment_id = 'ICD-Q9351')

INSERT INTO u_assessment_treat_definition (
	[assessment_id]
      ,[treatment_type]
      ,[treatment_description]
      ,[workplan_id]
      ,[followup_workplan_id]
      ,[user_id]
      ,[sort_sequence]
      ,[instructions]
      ,[parent_definition_id]
      ,[child_flag]
      ,[care_plan_id]
      ,[treatment_key]
      ,[treatment_mode]
	  )
SELECT 'K35891'
      ,[treatment_type]
      ,[treatment_description]
      ,[workplan_id]
      ,[followup_workplan_id]
      ,[user_id]
      ,[sort_sequence]
      ,[instructions]
      ,[parent_definition_id]
      ,[child_flag]
      ,[care_plan_id]
      ,[treatment_key]
      ,[treatment_mode]
  FROM [u_assessment_treat_definition]
WHERE  assessment_id IN ('APP')

UPDATE u_assessment_treat_definition
SET assessment_id = 'K35890'
WHERE assessment_id IN ('APP')

DELETE FROM c_Common_Assessment
WHERE  assessment_id IN (
'DEMO5202',
'DEMO7407',
'APP',
'DEMO8057',
'MATF')

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN (
'APP',
'DEMO5202',
'DEMO5910',
'DEMO7407',
'DEMO7729',
'DEMO7730',
'DEMO8057',
'ICD-C4311',
'ICD-C4312',
'ICD-C44102',
'ICD-C44109',
'ICD-C44112',
'ICD-C44119',
'ICD-C44122',
'ICD-C44129',
'ICD-C44192',
'ICD-C44199',
'ICD-C4A11',
'ICD-C4A12',
'ICD-D0311',
'ICD-D0411',
'ICD-D0412',
'ICD-D2211',
'ICD-D2212',
'ICD-D2311',
'ICD-D2312',
'ICD-G513',
'ICD-M791',
'ICD-O860',
'ICD-P742',
'ICD-P743',
'ICD-T814XXD',
'ICD-T814XXS',
'MATF'
)


-- 2019-04-27 New assessments Revisions.ods
	-- deletions

update u_top_20
set item_id = 'DEMO1213'
where item_id = '981^V72.62^0'

update ca
set assessment_id = 'DEMO1213'
from c_Common_Assessment ca
where assessment_id = '981^V72.62^0'
and not exists (select 1 from c_Common_Assessment ca2
	where ca2.assessment_id = 'DEMO1213'
	and ca2.specialty_id = ca.specialty_id )

delete
from c_Common_Assessment
where assessment_id in (
'981^V72.62^0',
'DEMO10023',
'DEMO10217',
'DEMO6503Q',
'DEMO7526',
'ERB')

delete 
from u_assessment_treat_definition
where assessment_id in (
'000134x',
'000199x',
'981^V72.62^0',
'DEMO7088',
'DEMO7526',
'DEMO7584',
'DEMO7585',
'DEMO9449')

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN (
'000134x',
'DEMO7526',
'DEMO7584',
'DEMO7585',
'DEMO7088',
'000199x',
'DEMO11290',
'DEMO6503Q',
'Dx-P014-1',
'Dx-P0441-1',
'Dx-P049-1',
'Dx-P049-2',
'DEMO10217',
'ERB',
'Dx-P5929-1',
'Dx-P5929-2',
'Dx-P5929-3',
'Dx-P599-1',
'Dx-P599-2',
'Dx-P599-3',
'Dx-P599-4',
'Dx-P599-5',
'Dx-P834-1',
'981^V72.62^0',
'DEMO9449',
'DEMO10023',
'DEMO4785',
'DEMO10696',
'DEMO11136',
'DEMO1068',
'DEMO1116',
'DEMO1117',
'Dx-P002-2',
'Dx-P002-3',
'DEMO6503',
'Dx-P0089-1',
'Dx-P0089-2',
'DEMO6657Q',
'DEMO6656',
'DEMOCAP2',
'Dx-P143-2',
'Dx-P389-2',
'DX-P588-2',
'DEMO5814',
'DEMO6096',
'Dx-R9389-1',
'Dx-R9389-10',
'Dx-R9389-11',
'Dx-R9389-12',
'Dx-R9389-2',
'Dx-R9389-3',
'Dx-R9389-4',
'Dx-R9389-5',
'Dx-R9389-6',
'Dx-R9389-8',
'Dx-R9389-9',
'DEMO9454',
'0^V18.59^1',
'DEMO9056',
'DEMO9129',
'DEMO9185')

	-- updates
update c_Assessment_Definition set assessment_category_id ='YWELL', assessment_type ='WELL' where assessment_id = '0^793.99^1'
update c_Assessment_Definition set source ='IncT' where assessment_id IN ( 
'DEMO8352', 'DEMO10376', 'DEMO7527', 'DEMO9640', 'DEMO9641', 
'DEMO9644', 'DEMO9645', 'DEMO10109', 'DEMO444q', 'DEMO10697', 
'DEMO11321', 'DEMO11322', 'DEMO11323', 'Dx-P036-1', 'Dx-P036-2', 
'Dx-P036-3', 'DX-P036-4', 'Dx-P049-3', 'DEMOCAP1', 'Dx-P143-1', 
'Dx-P148-1', 'Dx-P159-1', 'Dx-P159-2', 'Dx-P389-1', 'Dx-P588-1', 
'Dx-Q240-1', 'DEMO2063', 'DEMO6092', 'DEMO6093', 'DEMO6094', 'DEMO6095', 
'0^793.99^1', 'DEMO2135', 'Dx-R9389-7', 'DEMO9320', 'DEMO9321', 'DEMO9322')
update c_Assessment_Definition set icd10_code ='P389' where assessment_id = 'Dx-P002-1'
update c_Assessment_Definition set icd10_code ='P5929' where assessment_id = 'Dx-P036-1'
update c_Assessment_Definition set icd10_code ='P5929' where assessment_id = 'Dx-P036-2'
update c_Assessment_Definition set icd10_code ='P599' where assessment_id = 'Dx-P036-3'
update c_Assessment_Definition set icd10_code ='P036' where assessment_id = 'DX-P036-4'
update c_Assessment_Definition set icd10_code ='P021' where assessment_id = 'Dx-P049-3'
update c_Assessment_Definition set icd10_code ='P031' where assessment_id = 'Dx-P143-1'
update c_Assessment_Definition set icd10_code ='P0229' where assessment_id = 'Dx-P148-1'
update c_Assessment_Definition set icd10_code ='P0229' where assessment_id = 'Dx-P159-1'
update c_Assessment_Definition set icd10_code ='P0229' where assessment_id = 'Dx-P159-2'
update c_Assessment_Definition set icd10_code ='P021' where assessment_id = 'Dx-P389-1'
update c_Assessment_Definition set icd10_code ='P031' where assessment_id = 'Dx-P588-1'
update c_Assessment_Definition set icd10_code ='Q203' where assessment_id = 'Dx-Q240-1'
update c_Assessment_Definition set icd10_code ='Z118' where assessment_id = '0^793.99^1'
update c_Assessment_Definition set description ='Hereditary eosinophilia', long_description=NULL where assessment_id = 'DEMO7527'
update c_Assessment_Definition set description ='Paranoid psychosis', long_description=NULL where assessment_id = 'DEMO9640'
update c_Assessment_Definition set description ='Paranoid state', long_description=NULL where assessment_id = 'DEMO9641'
update c_Assessment_Definition set description ='Paraphrenia (late)', long_description=NULL where assessment_id = 'DEMO9644'
update c_Assessment_Definition set description ='Sensitiver Beziehungswahn', long_description=NULL where assessment_id = 'DEMO9645'
update c_Assessment_Definition set description ='Fibromyositis', long_description=NULL where assessment_id = 'DEMO10109'
update c_Assessment_Definition set description ='Transposition of great vessels (complete)', long_description=NULL where assessment_id = 'Dx-Q240-1'
update c_Assessment_Definition set description ='Congenital anomaly of heart', long_description=NULL where assessment_id = 'DEMO2063'
update c_Assessment_Definition set description ='Encounter for screening for mycoses', long_description=NULL where assessment_id = '0^793.99^1'
update c_Assessment_Definition set description ='Encounter for screening for chlamydia', long_description=NULL where assessment_id = 'DEMO9320'
update c_Assessment_Definition set description ='Encounter for screening for rickettsial', long_description=NULL where assessment_id = 'DEMO9321'
update c_Assessment_Definition set description ='Encounter for screening for spirochetal', long_description=NULL where assessment_id = 'DEMO9322'

update c_Assessment_Definition set assessment_id = replace(assessment_id,'DX','Dx') 
where assessment_id like 'DX%'
