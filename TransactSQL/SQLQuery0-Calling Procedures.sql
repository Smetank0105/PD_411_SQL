SET DATEFIRST 1;
USE PD_321;
GO

--DELETE	FROM	Schedule;
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%MS SQL Server%', N'������', '2025-04-18', '13:30';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%ADO.NET%', N'������';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%��������� ����������������%', N'������';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%������� ����������������%', N'������', '2025-04-18', '13:30';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%HTML/CSS%', N'������', '2025-08-18', '13:30';
EXEC	dbo.sp_SelectSchedule;
--PRINT(dbo.GetNextLearningDay(N'PD_411', NULL));
--PRINT(dbo.IsLearningDay(N'PV_211','2025-09-15'));
--PRINT(dbo.GetNextLearningDay(N'PD_411', '2025-09-05'));
--PRINT(dbo.GetListOfLearningDays(25));
--EXEC	dbo.sp_SelectGroups;
