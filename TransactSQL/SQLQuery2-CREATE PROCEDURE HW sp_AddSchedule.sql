--SQLQuery2-CREATE PROCEDURE HW sp_AddSchedule.sql
USE	PD_321;
GO

--CREATE TABLE Holidays
--(
--	holiday_id		SMALLINT	IDENTITY(1,1)	PRIMARY KEY,
--	holiday_date	DATE						NOT NULL
--);

--DECLARE @count		AS	SMALLINT	=	0;
--DECLARE	@holiday	AS	DATE		=	'2025-01-01';

--WHILE	@count	<	365
--BEGIN
--	IF	(@holiday		>=	'2025-01-01'	AND	@holiday	<=	'2025-01-08'
--		OR	@holiday	>=	'2025-05-01'	AND	@holiday	<=	'2025-05-11'
--		OR	@holiday	>=	'2025-06-12'	AND	@holiday	<=	'2025-06-15'
--		OR	@holiday	>=	'2025-07-07'	AND	@holiday	<=	'2025-07-13'
--		OR	@holiday	>=	'2025-08-04'	AND	@holiday	<=	'2025-08-17'
--		OR	@holiday	>=	'2025-11-02'	AND	@holiday	<=	'2025-11-04'
--		OR	@holiday	=	'2025-12-31')
--	BEGIN
--		INSERT	Holidays(holiday_date)
--		VALUES			(@holiday);
--	END
--	SET	@holiday	=	DATEADD(DAY, 1, @holiday);
--	SET	@count		=	@count	+	1;
--END

--CREATE TABLE StudyScheme
--(
--	scheme_id	TINYINT			PRIMARY KEY,
--	scheme_name	NVARCHAR(50)	NOT NULL,
--	study_day	NVARCHAR(10)	NOT NULL
--);

--INSERT	StudyScheme
--		(scheme_id, scheme_name, study_day)
--VALUES
--		(1,			'Even',		'Tuesday'),
--		(2,			'Even',		'Thursday'),
--		(3,			'Even',		'Saturday'),
--		(4,			'Odd',		'Monday'),
--		(5,			'Odd',		'Wednesday'),
--		(6,			'Odd',		'Friday');


ALTER PROCEDURE sp_AddSchedule
	@group_name				AS	NCHAR(10),
	@discipline_name		AS	NVARCHAR(150),
	@teacher_last_name		AS	NVARCHAR(50),
	@start_date				AS	DATE,
	@start_time				AS	TIME
AS
BEGIN
	DECLARE	@group			AS	INT			=	(SELECT	group_id			FROM	Groups			WHERE	group_name			=		@group_name);
	DECLARE	@discipline		AS	SMALLINT	=	(SELECT	discipline_id		FROM	Disciplines		WHERE	discipline_name		LIKE	@discipline_name);
	DECLARE	@lessons_count	AS	TINYINT		=	(SELECT	number_of_lessons	FROM	Disciplines		WHERE	discipline_id		=		@discipline);
	DECLARE	@lesson_number	AS	TINYINT		=	1;
	DECLARE	@teacher		AS	INT			=	(SELECT	teacher_id			FROM	Teachers		WHERE	last_name			LIKE	@teacher_last_name);
	DECLARE	@date			AS	DATE		=	@start_date;

	SET DATEFIRST	1;

	DECLARE	@study_scheme	AS	NVARCHAR(10)	=	(SELECT TOP 1 scheme_name FROM StudyScheme WHERE study_day = DATENAME(WEEKDAY, @date) ORDER BY scheme_name);

	IF EXISTS (SELECT discipline FROM Schedule WHERE [group] = @group)
	BEGIN
		SELECT TOP 1 @date = [date] FROM Schedule WHERE [group] = @group ORDER BY [date] DESC;
		SET	@date = DATEADD(DAY, IIF(DATEPART(WEEKDAY, @date)% 2 = 0, 1, 2), @date);
	END

	WHILE	@lesson_number	<=	@lessons_count
	BEGIN
		IF	NOT	EXISTS	(SELECT	lesson_id FROM Schedule WHERE [group] = @group AND discipline = @discipline AND [date] = @date)
		BEGIN
			IF	EXISTS	(SELECT holiday_id FROM Holidays WHERE holiday_date = @date)
			BEGIN
				SET	@date =	DATEADD(DAY, 1, @date);
				CONTINUE
			END
			IF	(DATENAME(WEEKDAY, @date) IN (SELECT study_day FROM StudyScheme WHERE scheme_name = @study_scheme))
			BEGIN
				INSERT	Schedule
						([group]	,discipline,	teacher,	[date],	[time],	spent)
				VALUES
						(@group,	@discipline,	@teacher,	@date,	@start_time,						IIF(@date < GETDATE(), 1, 0)),
						(@group,	@discipline,	@teacher,	@date,	DATEADD(MINUTE, 95, @start_time),	IIF(@date < GETDATE(), 1, 0));
			SET	@lesson_number	=	@lesson_number	+	2;
			END
		END
		SET	@date =	DATEADD(DAY, 1, @date);
	END
END