SET DATEFIRST 1;
USE PD_321;
GO

--DELETE	FROM	Schedule;
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%MS SQL Server%', N'������', '2025-08-18', '13:30';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%ADO.NET%', N'������';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%��������� ����������������%', N'������';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%������� ����������������%', N'������', '2025-04-18', '13:30';
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%HTML/CSS%', N'������', '2025-08-18', '13:30';
--PRINT(dbo.GetNextLearningDay(N'PD_411', NULL));
--PRINT(dbo.IsLearningDay(N'PV_211','2025-09-15'));
--PRINT(dbo.GetNextLearningDay(N'PD_411', '2025-09-05'));
--PRINT(dbo.GetListOfLearningDays(25));
--EXEC	dbo.sp_SelectGroups;
-----------------------------------------------------------------------------------------------------------------------------------------
--EXEC	dbo.sp_AddSchedule N'PD_411', N'%���� ���������������� C#%', N'������', '2025-04-28', '13:30';
--EXEC	dbo.sp_AddSchedule N'PD_321', N'%���� ���������������� C#%', N'������', '2025-04-29', '13:30';
--EXEC	dbo.sp_AddSchedule N'Java_326', N'%������ ���������������� �� ����� Java%', N'������', '2025-04-29', '18:30';
--EXEC	dbo.sp_MoveSchedule	N'PD_411',	N'������', '2025-04-28', '2025-04-30', '2025-05-05', '13:30';
--EXEC	dbo.sp_MoveSchedule	N'PD_321',	N'������', '2025-05-13', '2025-05-17', '2025-05-23', '13:30';
--EXEC	dbo.sp_MoveSchedule	N'PD_321',	N'������', '2025-05-13', '2025-05-17', '2025-05-23', '18:30';
--EXEC	dbo.sp_MoveSchedule	N'Java_326',	N'������', '2025-04-29', '2025-04-29', '2025-05-23', '18:30';
--EXEC	dbo.sp_MoveSchedule	N'PD_321',	N'������', '2025-05-20', '2025-06-14', '2025-05-01', '13:30';
EXEC	dbo.sp_SelectSchedule;