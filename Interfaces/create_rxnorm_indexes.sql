USE interfaces
GO

DROP INDEX RXNCONSO.X_RXNCONSO_STR
DROP INDEX RXNSAT.X_RXNSAT_ATV
DROP INDEX RXNSAT.X_RXNSAT_ATN

-- Warning! The maximum key length is 900 bytes. The index 'X_RXNCONSO_STR' has maximum length of 3000 bytes. For some combination of large values, the insert/update operation will fail.
-- CREATE INDEX X_RXNCONSO_STR ON RXNCONSO([STR]);
CREATE INDEX X_RXNCONSO_RXCUI ON RXNCONSO(RXCUI);
CREATE INDEX X_RXNCONSO_TTY ON RXNCONSO(TTY);
CREATE INDEX X_RXNCONSO_CODE ON RXNCONSO(CODE);

CREATE INDEX X_RXNSAT_RXCUI ON RXNSAT(RXCUI);
-- Warning! The maximum key length is 900 bytes. The index 'X_RXNSAT_ATV' has maximum length of 4000 bytes. For some combination of large values, the insert/update operation will fail.
-- CREATE INDEX X_RXNSAT_ATV ON RXNSAT(ATV);
-- Warning! The maximum key length is 900 bytes. The index 'X_RXNSAT_ATN' has maximum length of 1000 bytes. For some combination of large values, the insert/update operation will fail.
-- CREATE INDEX X_RXNSAT_ATN ON RXNSAT(ATN);

CREATE INDEX X_RXNREL_RXCUI1 ON RXNREL(RXCUI1);
CREATE INDEX X_RXNREL_RXCUI2 ON RXNREL(RXCUI2);
CREATE INDEX X_RXNREL_RELA ON RXNREL(RELA);

/*
CREATE INDEX X_RXNATOMARCHIVE_RXAUI ON RXNATOMARCHIVE(RXAUI);
CREATE INDEX X_RXNATOMARCHIVE_RXCUI ON RXNATOMARCHIVE(RXCUI);
CREATE INDEX X_RXNATOMARCHIVE_MERGED_TO ON RXNATOMARCHIVE(MERGED_TO_RXCUI);
*/
GO