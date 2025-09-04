--USE PD_321;
--GO

--CREATE	PROCEDURE	dbo.usp_makeSchedule
--					(
--					@disc_name		NVARCHAR(150),
--					@teach_lname	NVARCHAR(50),
--					@gr_name		NCHAR(10),
--					@start_date	DATE,
--					@start_time	TIME(0)
--					)
--AS
--BEGIN
--	DECLARE	@date					AS	DATE		=	@start_date;
--	DECLARE	@time					AS	TIME(0)		=	@start_time;
--	DECLARE	@discipline				AS	SMALLINT	=	(SELECT	discipline_id
--														FROM	Disciplines
--														WHERE	discipline_name	LIKE	'%'+@disc_name+'%'
--														);
--	DECLARE	@lessons_count			AS	TINYINT		=	(SELECT	number_of_lessons
--														FROM	Disciplines
--														WHERE	discipline_name	LIKE	'%'+@disc_name+'%'
--														);
--	DECLARE	@group					AS	INT			=	(SELECT	group_id
--														FROM	Groups
--														WHERE	group_name	=	@gr_name
--														);
--	DECLARE	@teacher				AS	INT			=	(SELECT	teacher_id
--												FROM	Teachers
--												WHERE	last_name	=	@teach_lname
--												);

--	DECLARE	@lesson_number			AS	TINYINT		=	1;

--	DECLARE	@last_study_day_of_week	AS	INT	=	IIF(DATEPART(WEEKDAY,	@start_date)%2	=	0,	6,	5);

--	PRINT	('======================================');
--	PRINT	(@start_date);
--	PRINT	(@discipline);
--	PRINT	(@lessons_count);
--	PRINT	(@group);
--	PRINT	(@teacher);
--	PRINT	('======================================');
--	WHILE	@lesson_number	<=	@lessons_count
--	BEGIN
--		-------------------------------------BEGIN-HOLIDAYS-------------------------------------
--		IF		(	@date	>=	'2025-05-01'
--				AND	@date	<=	'2025-05-09'
--				OR	@date	>=	'2025-07-07'
--				AND	@date	<=	'2025-07-13'
--				OR	@date	>=	'2025-08-04'
--				AND	@date	<=	'2025-08-17'
--				)
--		BEGIN
--			SET		@date			=	DATEADD(DAY,	IIF(DATEPART(WEEKDAY,	@date)	=	@last_study_day_of_week,	3,	2),	@date);
--			CONTINUE;
--		END
--		--------------------------------------END-HOLIDAYS--------------------------------------
--		PRINT	(@date);
--		PRINT	(DATENAME(WEEKDAY,	@date));
--		PRINT	(@lesson_number);
--		PRINT	(@time);

--		--------------------------------------BEGIN-INSERT--------------------------------------
--		INSERT	Schedule
--				([group],	discipline,		teacher,	[date],	[time])
--		VALUES
--				(@group,	@discipline,	@teacher,	@date,	@time);
--		---------------------------------------END-INSERT---------------------------------------

--		SET		@lesson_number	=	@lesson_number	+	1;
--		PRINT	(@lesson_number);
--		PRINT	(DATEADD(MINUTE,	95,	@time));

--		--------------------------------------BEGIN-INSERT--------------------------------------
--		INSERT	Schedule
--				([group],	discipline,		teacher,	[date],	[time])
--		VALUES
--				(@group,	@discipline,	@teacher,	@date,	DATEADD(MINUTE,	95,	@time));
--		---------------------------------------END-INSERT---------------------------------------

--		SET		@lesson_number	=	@lesson_number	+	1;
--		SET		@date			=	DATEADD(DAY,	IIF(DATEPART(WEEKDAY,	@date)	=	@last_study_day_of_week,	3,	2),	@date);
--		PRINT	('--------------------------------------');
--	END
--END;
--GO

--SET	DATEFIRST	1;	--	Дни недели считаются с 1 по 7, с Пн. по Вс.

--EXECUTE	dbo.usp_makeSchedule	N'Объектно-ориентированное программирование на языке C++', N'Амелькин', N'PD_411', '2025-01-28', '13:30';
--EXECUTE	dbo.usp_makeSchedule	N'UML и паттерны проектирования', N'Ефимов', N'PD_411', '2025-04-07', '13:30';
--EXECUTE	dbo.usp_makeSchedule	N'Язык программирования C#', N'Ковтун', N'PD_411', '2025-04-28', '13:30';
--EXECUTE	dbo.usp_makeSchedule	N'Windows Forms и WPF', N'Ковтун', N'PD_411', '2025-06-16', '13:30';
--EXECUTE	dbo.usp_makeSchedule	N'MS SQL Server', N'Ковтун', N'PD_411', '2025-07-30', '13:30';
--EXECUTE	dbo.usp_makeSchedule	N'Технология доступа к данным ADO.NET', N'Ковтун', N'PD_411', '2025-09-10', '13:30';
