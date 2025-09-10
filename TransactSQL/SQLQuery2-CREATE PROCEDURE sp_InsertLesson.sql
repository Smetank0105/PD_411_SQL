--SQLQuery2-CREATE PROCEDURE sp_InsertLesson.sql
USE PD_321;
GO

ALTER PROCEDURE sp_InsertLesson
(
	@group					AS	INT,
	@discipline				AS	SMALLINT,
	@teacher				AS	INT,
	@date					AS	DATE,
	@start_time				AS	TIME,
	@lesson_number			TINYINT	OUTPUT
)
AS
SET NOCOUNT ON;
BEGIN
	DECLARE @group_name		AS	NCHAR(10)	=	(SELECT group_name FROM Groups WHERE group_id = @group);

	IF	NOT	EXISTS	(SELECT	lesson_id FROM Schedule WHERE [group] = @group AND [date] = @date AND [time] = @start_time)
	BEGIN
		INSERT	Schedule
				([group]	,discipline,	teacher,	[date],	[time],	spent)
		VALUES
				(@group,	@discipline,	@teacher,	@date,	@start_time,					IIF(@date<GETDATE(),1,0));
		IF @@ROWCOUNT > 0
		BEGIN
			SET	@lesson_number	=	@lesson_number	+	1;
		END
		ELSE
		BEGIN
			PRINT(FORMATMESSAGE(N'Ошибка. Запись в рассписание группы "%s" на %s %s не добавлена', @group_name, CAST(@date AS NCHAR(10)), CAST(@start_time AS NCHAR(8))));
		END
		INSERT	Schedule
				([group]	,discipline,	teacher,	[date],	[time],	spent)
		VALUES
				(@group,	@discipline,	@teacher,	@date,	DATEADD(MINUTE,95,@start_time),	IIF(@date<GETDATE(),1,0));
		IF @@ROWCOUNT > 0
		BEGIN
			SET	@lesson_number	=	@lesson_number	+	1;
		END
		ELSE
		BEGIN
			PRINT(FORMATMESSAGE(N'Ошибка. Запись в рассписание группы "%s" на %s %s не добавлена', @group_name, CAST(@date AS NCHAR(10)), CAST(DATEADD(MINUTE,95,@start_time) AS NCHAR(8))));
		END
	END
	ELSE
	BEGIN
		PRINT(FORMATMESSAGE(N'%s %s у группы "%s" уже занято', CAST(@date AS NCHAR(10)), CAST(@start_time AS NCHAR(8)), @group_name));
	END
END