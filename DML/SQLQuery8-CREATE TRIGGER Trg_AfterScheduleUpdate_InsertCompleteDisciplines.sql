--SQLQuery8-CREATE TRIGGER Trg_AfterScheduleUpdate_InsertCompleteDisciplines.sql
USE PD_321;
GO

ALTER	TRIGGER	Trg_AfterScheduleUpdate_InsertCompleteDisciplines
ON	Schedule
AFTER	UPDATE
AS
BEGIN
	IF	UPDATE(spent)
	BEGIN
		BEGIN
			INSERT	INTO		CompleteDisciplines
			SELECT	DISTINCT	i.[group],	i.discipline
			FROM	inserted	AS	i
			WHERE	NOT	EXISTS	(SELECT	1
								FROM	Schedule	AS	s
								WHERE	s.discipline	=	i.discipline
								AND		s.[group]		=	i.[group]
								AND		s.spent			=	0
								)
			AND		NOT	EXISTS	(SELECT	1
								FROM	CompleteDisciplines	AS	cd
								WHERE	cd.[group]			=	i.[group]
								AND		cd.discipline		=	i.discipline
								);
		END
	END
END