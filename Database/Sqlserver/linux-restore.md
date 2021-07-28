RESTORE DATABASE win60_pdb FROM DISK = '/winning/data/win60_pdb1_backup_2021_07_02_030049_5743867.bak' 
WITH 
MOVE 'WIN60_PDB' TO '/winning/data/mssql/win60_pdb/win60_pdb_0731_line.mdf',
MOVE 'WIN60_PDB02' TO '/winning/data/mssql/win60_pdb/win60_pdb_0731_line02.mdf',
MOVE 'WIN60_PDB03' TO '/winning/data/mssql/win60_pdb/win60_pdb_0731_line03.mdf',
MOVE 'WIN60_PDB04' TO '/winning/data/mssql/win60_pdb/win60_pdb_0731_line04.mdf',
MOVE 'WIN60_PDB_log' to '/winning/data/mssql/win60_pdb/win60_pdb_0731_line_log.mdf' 
go


RESTORE DATABASE THIS4_LYLT FROM DISK = '/winning/data/THIS4_LYLT_backup_2021_05_17_030006_9618293.bak'
WITH 
MOVE 'SAMPLE_Data' TO '/winning/data/mssql/this4_lylt/this4_lylt.mdf',
MOVE 'SAMPLE_Log' TO '/winning/data/mssql/win60_pdb/this4_lylt_log.mdf'
go


RESTORE DATABASE win60 FROM DISK = '/winning/data/win60_standard_v0_20210708_1043_001.bak' 
WITH 
MOVE 'win60_baseline_v2' TO '/winning/data/mssql/win60/win60_baseline_v2.mdf',
MOVE 'win60_baseline_v2_log' TO '/winning/data/mssql/win60_pdb/win60_baseline_v2_log.mdf'
go
