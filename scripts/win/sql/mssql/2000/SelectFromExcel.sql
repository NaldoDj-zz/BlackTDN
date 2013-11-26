IF EXISTS( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SelectFromExcel_1') AND OBJECTPROPERTY(id, N'IsTable') = 1)
BEGIN
    DROP TABLE SelectFromExcel_1
END
;
SELECT   coluna_1
	    ,coluna_2
        ,coluna_3
        ,coluna_4
INTO SelectFromExcel_1 FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0','Data Source=D:\svn\totvs-advpl-naldodj\scripts\sql\mssql\SelectFromExcel.xls;Extended Properties=Excel 8.0')...[tabela$]
;
IF EXISTS( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SelectFromExcel_2') AND OBJECTPROPERTY(id, N'IsTable') = 1)
BEGIN
    DROP TABLE SelectFromExcel_2
END
;
SELECT * INTO SelectFromExcel_2 FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=D:\svn\totvs-advpl-naldodj\scripts\sql\mssql\SelectFromExcel.xls', [tabela$])
;
IF EXISTS( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SelectFromExcel_3') AND OBJECTPROPERTY(id, N'IsTable') = 1)
BEGIN
    DROP TABLE SelectFromExcel_2
END
;
SELECT * INTO SelectFromExcel_3 FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=D:\svn\totvs-advpl-naldodj\scripts\sql\mssql\SelectFromExcel.xls', 'SELECT * FROM [tabela$]')
;
select * from SelectFromExcel_1
;

select * from SelectFromExcel_2
;

select * from SelectFromExcel_2