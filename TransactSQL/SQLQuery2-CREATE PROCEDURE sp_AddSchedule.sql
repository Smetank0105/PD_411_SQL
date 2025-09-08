--SQLQuery2-CREATE PROCEDURE sp_AddSchedule.sql
USE	PD_321;
GO

ALTER PROCEDURE sp_AddSchedule
	@group_name				AS	NCHAR(10),
	@discipline_name		AS	NVARCHAR(150),
	@teacher_last_name		AS	NVARCHAR(50),
	@start_date				AS	DATE	=	'1900-01-01',
	@start_time				AS	TIME	=	'00:00'
AS
BEGIN
	DECLARE	@group			AS	INT			=	(SELECT	group_id			FROM	Groups			WHERE	group_name			=		@group_name);
	DECLARE	@learning_days	AS	TINYINT		=	(SELECT	learning_days		FROM	Groups			WHERE	group_id	=	@group);
	DECLARE	@discipline		AS	SMALLINT	=	(SELECT	discipline_id		FROM	Disciplines		WHERE	discipline_name		LIKE	@discipline_name);
	DECLARE	@lessons_count	AS	TINYINT		=	(SELECT	number_of_lessons	FROM	Disciplines		WHERE	discipline_id		=		@discipline);
	DECLARE	@lesson_number	AS	TINYINT		=	1;
	DECLARE	@teacher		AS	INT			=	(SELECT	teacher_id			FROM	Teachers		WHERE	last_name			LIKE	@teacher_last_name);
	DECLARE	@date			AS	DATE		=	IIF(@start_date !='1900-01-01', @start_date,	dbo.GetNextLearningDay(@group_name, DEFAULT));

	SET		@start_time						=	IIF(@start_time !='00:00',		@start_time,	(SELECT start_time FROM Groups WHERE group_id = @group));

	IF EXISTS (SELECT lesson_id FROM Schedule WHERE [group] = @group AND discipline = @discipline)
	BEGIN
		PRINT(FORMATMESSAGE(N'Дисциплина "%s" уже выставлена для группы "%s"', @discipline_name, @group_name));
		RETURN
	END

	WHILE	@lesson_number	<=	@lessons_count
	BEGIN
		IF	NOT	EXISTS	(SELECT	lesson_id FROM Schedule WHERE [group] = @group AND [date] = @date AND [time] = @start_time)
		BEGIN
			INSERT	Schedule
					([group]	,discipline,	teacher,	[date],	[time],	spent)
			VALUES
					(@group,	@discipline,	@teacher,	@date,	@start_time,					IIF(@date<GETDATE(),1,0)),
					(@group,	@discipline,	@teacher,	@date,	DATEADD(MINUTE,95,@start_time),	IIF(@date<GETDATE(),1,0));
					SET	@lesson_number	=	@lesson_number	+	2;
		END
		ELSE
		BEGIN
			PRINT(FORMATMESSAGE(N'%s %s у группы "%s" уже занято', CAST(@date AS NCHAR(10)), CAST(@start_time AS NCHAR(8)), @group_name));
		END
		SET	@date =	dbo.GetNextLearningDay(@group_name, DEFAULT);
	END
END