/*
    Exemplo de Consulta Hierarquica (Tree) usando MSSQL
    Autor: Marinaldo de Jesus (http://www.blacktdn.com.br)
    Adaptado dos Exemplos obtidos a partir das referências abaixo
    Referencias:
    --Ref.:https://technet.microsoft.com/pt-br/library/ms186243(v=sql.105).aspx
    --Ref.:https://msdn.microsoft.com/pt-br/library/ms186755.aspx?f=3000&MSPPError=-2147217396
    --Ref.:http://www.codeproject.com/Articles/328858/Implementing-multi-level-trees-in-MS-SQL-Server
    --Ref.:https://msdn.microsoft.com/pt-br/library/bb677173.aspx?f=255&MSPPError=-2147217396
    --Ref.:https://msdn.microsoft.com/en-us/library/ms190328.aspx
    --Ref.:https://msdn.microsoft.com/en-us/library/ms190324.aspx
   
*/
--------------------------------------------------------------------
IF OBJECT_ID('[dbo].[MyEmployees]','U') IS NOT NULL
DROP TABLE [dbo].[MyEmployees];
GO
-- Create an Employee table.
CREATE TABLE [dbo].[MyEmployees]
(
    EmployeeID int NOT NULL,
    FirstName nvarchar(30)  NOT NULL,
    LastName  nvarchar(40) NOT NULL,
    Title nvarchar(50) NOT NULL,
    DeptID smallint NOT NULL,
    ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);
-- Populate the table with values.
INSERT INTO [dbo].[MyEmployees] VALUES 
 (1,N'Ken',N'Sánchez',N'Chief Executive Officer',16,NULL)
,(273,N'Brian',N'Welcker',N'Vice President of Sales',3,1)
,(274,N'Stephen',N'Jiang',N'North American Sales Manager',3,273)
,(275,N'Michael',N'Blythe',N'Sales Representative',3,274)
,(276,N'Linda',N'Mitchell',N'Sales Representative',3,274)
,(285,N'Syed',N'Abbas',N'Pacific Sales Manager',3,273)
,(286,N'Lynn',N'Tsoflias',N'Sales Representative',3,285)
,(16, N'David',N'Bradley',N'Marketing Manager',4,273)
,(23, N'Mary',N'Gibson',N'Marketing Specialist',4,16)
,(24, N'Mary 24',N'Gibson 24',N'Marketing Assistant SR',4,23)
,(25, N'Mary 25',N'Gibson 25',N'Marketing Specialist',4,16)
,(26, N'Mary 26',N'Gibson 26',N'Marketing Assistant SR',4,23)
,(27, N'Mary 27',N'Gibson 27',N'Marketing Assistant PL',4,24)
,(28, N'Mary 28',N'Gibson 28',N'Marketing Assistant JR',4,27)
,(29, N'Mary 29',N'Gibson 29',N'Marketing Assistant Trainee SR',4,28)
,(30, N'Mary 30',N'Gibson 30',N'Marketing Assistant SR',4,23)
,(31, N'Mary 31',N'Gibson 31',N'Marketing Assistant PL',4,24)
,(32, N'Mary 32',N'Gibson 32',N'Marketing Assistant JR',4,27)
,(33, N'Mary 33',N'Gibson 33',N'Marketing Assistant Trainee SR',4,28)
,(34, N'Mary 34',N'Gibson 34',N'Marketing Specialist',4,16)
,(35, N'Mary 35',N'Gibson 35',N'Marketing Specialist SR',4,34)
,(36, N'Mary 36',N'Gibson 36',N'Marketing Specialist PL',4,35)
,(37, N'Mary 37',N'Gibson 37',N'Marketing Specialist JR',4,36)
,(38, N'Mary 38',N'Gibson 38',N'Marketing Specialist Trainee SR',4,37)
,(39, N'Mary 39',N'Gibson 39',N'Marketing Specialist Trainee PL',4,38);
--------------------------------------------------------------------
IF OBJECT_ID (N'[dbo].[ufn_FindReports]',N'TF') IS NOT NULL
    DROP FUNCTION [dbo].[ufn_FindReports];
GO
CREATE FUNCTION [dbo].[ufn_FindReports]()
RETURNS @retFindReports TABLE 
(
    ID int IDENTITY(1,1) PRIMARY KEY,
    MasterID int NOT NULL,
    SuperID int NOT NULL,
    ManagerID int  NOT NULL,
    Level int NOT NULL,
    EmployeeID int  NOT NULL,
    NodeID nvarchar(3000) NOT NULL
)
AS
    BEGIN
    WITH DirectReports(
                        MasterID
                       ,SuperID
                       ,ManagerID
                       ,Level
                       ,EmployeeID
                       ,NodeID
    ) 
    AS
    (
    
        (
            SELECT m.EmployeeID AS MasterID
                 ,0 AS SuperID 
                 ,IsNull(m.ManagerID,0)
                 ,0 AS Level
                 ,m.EmployeeID
                 ,convert(varChar(3000),+cast(m.EmployeeID AS varchar)) AS NodeID
            FROM dbo.MyEmployees AS m
                WHERE m.ManagerID IS NULL
        ) 
        UNION ALL
        (
            SELECT d.MasterID 
                  ,(
                        CASE d.ManagerID 
                        WHEN 0 
                        THEN d.EmployeeID 
                        ELSE d.ManagerID 
                        END
                    ) AS SuperID
                  ,e.ManagerID
                  ,d.Level+1
                  ,e.EmployeeID
                  ,convert(varChar(3000),d.NodeID+'.'+cast(e.EmployeeID AS varchar)) AS NodeID
            FROM dbo.MyEmployees AS e
                INNER JOIN DirectReports AS d
                ON d.EmployeeID=e.ManagerID 
        ) 
    )
   INSERT @retFindReports
   SELECT *
   FROM DirectReports
   RETURN
END;
GO
SELECT REPLICATE(' ',4*(t.Level))+'+-->'+LTrim(Str(t.ManagerID,3)) AS ManagerID
      ,e.EmployeeID
      ,e.LastName
      ,REPLICATE(' ',4*(t.Level))+'+--> '+e.Title AS Title
      ,e.DeptID
      ,t.ID
      ,t.MasterID
      ,t.SuperID      
      ,t.Level
      ,t.NodeID
FROM dbo.ufn_FindReports() t
LEFT JOIN dbo.MyEmployees e
       ON e.EmployeeID=t.EmployeeID  
ORDER BY t.MasterID
        ,t.NodeID
GO
--------------------------------------------------------------------
