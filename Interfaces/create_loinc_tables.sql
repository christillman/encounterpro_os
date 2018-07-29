USE interfaces
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'LoincSourceOrganization')
	BEGIN DROP TABLE LoincSourceOrganization END
IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'Loinc')
	BEGIN DROP TABLE Loinc END
IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'LoincMapTo')
	BEGIN DROP TABLE LoincMapTo END
GO

CREATE TABLE LoincSourceOrganization (
  copyright_id varchar(255) NOT NULL,
  name varchar(255),
  copyright text,
  terms_of_use text,
  url text,
  primary key (copyright_id)
  );

CREATE TABLE Loinc (
  loinc_num varchar(10) NOT NULL,
  component varchar(255),
  property varchar(255),
  time_aspct varchar(255),
  system varchar(255),
  scale_typ varchar(255),
  method_typ varchar(255),
  class varchar(255),
  VersionLastChanged varchar(255),
  chng_type varchar(255),
  DefinitionDescription text,
  status varchar(255),
  consumer_name varchar(255),
  classtype bigint,
  formula text,
  species varchar(20),
  exmpl_answers text,
  survey_quest_text text,
  survey_quest_src varchar(50),
  unitsrequired varchar(1),
  submitted_units varchar(30),
  relatednames2 text,
  shortname varchar(255),
  order_obs varchar(15),
  cdisc_common_tests varchar(1),
  hl7_field_subfield_id varchar(50),
  external_copyright_notice text,
  example_units varchar(255),
  long_common_name varchar(255),
  UnitsAndRange text,
  document_section varchar(255),
  example_ucum_units varchar(255),
  example_si_ucum_units varchar(255),
  status_reason varchar(9),
  status_text text,
  change_reason_public text,
  common_test_rank integer,
  common_order_rank integer,
  common_si_test_rank integer,
  hl7_attachment_structure varchar(15),
  ExternalCopyrightLink varchar(255),
  PanelType varchar(50),
  AskAtOrderEntry varchar(255),
  AssociatedObservations varchar(255),
  VersionFirstReleased varchar(255),
  ValidHL7AttachmentRequest varchar(50),

  CONSTRAINT PK_LOINC primary key (loinc_num)

);

CREATE TABLE LoincMapTo (
  loinc varchar(10) NOT NULL,
  map_to varchar(10) NOT NULL,
  comment text,
  primary key (loinc, map_to)

);
GO

