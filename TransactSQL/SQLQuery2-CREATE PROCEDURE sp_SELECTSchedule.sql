--SQLQuery2-CREATE PROCEDURE sp_SelectSchedule.sql
USE PD_321;
GO	--	Финализирует statement batch

ALTER	PROCEDURE	sp_SelectSchedule
AS
BEGIN
	SELECT
			[ID]			=	lesson_id,
			[Группа]		=	group_name,
			[Дисциплина]	=	discipline_name,
			[Преподаватель]	=	FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
			[День недели]	=	DATENAME(WEEKDAY, [date]),
			[Дата]			=	[date],
			[Время]			=	[time],
			[Статус]		=	IIF(spent = 1, N'Проведено', N'Запланированно')
	FROM	Schedule,Teachers,Groups,Disciplines
	WHERE	[group]			=	group_id
	AND		discipline		=	discipline_id
	AND		teacher			=	teacher_id
	;
END