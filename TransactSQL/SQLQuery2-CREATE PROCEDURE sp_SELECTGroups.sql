--SQLQuery2-CREATE PROCEDURE sp_SELECTGroups.sql
USE PD_321;
GO

CREATE PROCEDURE	sp_SelectGroups
AS
BEGIN
	SELECT
		[ID]			=	group_id,
		[Группа]		=	group_name,
		[Направление]	=	direction_name,
		[Учебные дни]	=	dbo.GetListOfLearningDays(learning_days)
	FROM	Groups, Directions
	WHERE	direction	=	direction_id;
END