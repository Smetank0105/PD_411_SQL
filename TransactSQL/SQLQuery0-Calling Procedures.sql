USE PD_321;
GO

--DELETE	FROM	Schedule;
EXEC	dbo.sp_AddSchedule N'PD_411', N'%MS SQL Server%', N'Ковтун', '2025-08-18', '13:30';
EXEC	dbo.sp_SelectSchedule;