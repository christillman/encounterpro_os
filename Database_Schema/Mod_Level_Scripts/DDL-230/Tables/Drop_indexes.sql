
IF (EXISTS(SELECT * FROM sys.indexes WHERE name = N'ix_c_Drug_Brand_drug_id'))
DROP INDEX c_Drug_Brand.ix_c_Drug_Brand_drug_id
GO


IF (EXISTS(SELECT * FROM sys.indexes WHERE name = N'ix_c_Drug_Generic_drug_id'))
DROP INDEX c_Drug_Generic.ix_c_Drug_Generic_drug_id
GO

