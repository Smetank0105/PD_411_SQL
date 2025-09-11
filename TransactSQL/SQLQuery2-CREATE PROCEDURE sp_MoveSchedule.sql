--SQLQuery2-CREATE PROCEDURE sp_MoveSchedule.sql
SET DATEFIRST 1;
USE PD_321;
GO

ALTER PROCEDURE sp_MoveSchedule
(
	@group_name							AS	NCHAR(10),
	@teacher_last_name					AS	NVARCHAR(50),
	@first_date							AS	DATE,														--дата первого занятия, которое необходимо перенести
	@last_date							AS	DATE,														--дата последнего занятия, которое необходимо перенести
	@date_to_missed_classes				AS	DATE,														--первая дата отработки занятий
	@time_to_missed_classes				AS	TIME(0)														--время начала отработки занятий
)																										--от даты зависит, как будут распределятся дни,
																										--по свободным "рабочим" дням или же по "праздничным".
AS
BEGIN
	DECLARE	@group						AS	INT		=	(SELECT	group_id	FROM	Groups		WHERE	group_name	=	@group_name);
	DECLARE	@teacher					AS	INT		=	(SELECT	teacher_id	FROM	Teachers	WHERE	last_name	=	@teacher_last_name);
	DECLARE @weekday_to_missed_classes	AS	TINYINT	=	DATEPART(weekday, @date_to_missed_classes);		--порядковый номер дня недели для отработки
	DECLARE	@date						AS	DATE	=	@first_date;									--дата конкретного занятия, которое переносим
	DECLARE @next_date					AS	DATE	=	@date_to_missed_classes;						--дата отработки конкретного занятия
	DECLARE	@learning_days				AS	TINYINT;													--переменная для графика учебы по дням
	DECLARE	@group_name_info			AS	NCHAR(10);													--переменная для вывода названия группы в инфо-сообщениях
	-----------------------------------------------------------------------------------------------------------------------------
	--Объявление курсора для построчной обработки виртуального столбца learning_days из таблицы Groups
	DECLARE	cur	CURSOR	LOCAL	FOR	SELECT	learning_days
								FROM	Groups, Schedule
								WHERE	[group]=group_id
								AND		teacher=@teacher
								AND		start_time=@time_to_missed_classes;
	-----------------------------------------------------------------------------------------------------------------------------
	--Проверка ввода @first_date для указанной группы
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [group]=@group AND teacher=@teacher AND [date]=@first_date)
	BEGIN
		PRINT(FORMATMESSAGE(N'В дату %s у группы %s для преподавателя %s занятие не значится. Проверьте расписание.',
							CAST(@first_date AS NCHAR(10)),
							@group_name,
							@teacher_last_name));
		RETURN;
	END
	-----------------------------------------------------------------------------------------------------------------------------
	--При условии, что предложенная дата @date_to_missed_classes не на каникулах или праздниках
	--Проверка доступности @weekday_to_missed_classes и @time_to_missed_classes в расписании
	IF dbo.IsHoliday(@date_to_missed_classes) = 0														--функция возвращает 1, если дата приходится на праздничный день или каникулы
	BEGIN
		OPEN	cur;
		FETCH NEXT FROM cur INTO @learning_days;														--возвращает первую строку в курсоре и присваивает ее в @learning_days
		WHILE @@FETCH_STATUS = 0																		--возвращает состояние последней инструкции FETCH (0 - успешно)
		BEGIN
			IF (@learning_days & POWER(2, @weekday_to_missed_classes - 1)) != 0
			BEGIN
				SET	@group_name_info	=	(SELECT TOP 1 group_name 
											FROM	Groups, Schedule
											WHERE	[group]=group_id
											AND		teacher=@teacher
											AND		learning_days=@learning_days
											ORDER BY group_name DESC);
				PRINT(FORMATMESSAGE(N'%sй день недели в %s занят в группе %s. Попробуйте выбрать другие дату и время',
									CAST(@weekday_to_missed_classes AS NCHAR(1)),	CAST(@time_to_missed_classes AS NCHAR(8)),	@group_name_info));
				RETURN;
			END
			FETCH NEXT FROM cur INTO @learning_days;													--возвращает следующую строку в курсоре
		END
	-----------------------------------------------------------------------------------------------------------------------------
	--Закрытие курсора и удаление ссылки
		CLOSE cur;
		DEALLOCATE cur;
	-----------------------------------------------------------------------------------------------------------------------------
	--Проверка конкретного "рабочего" дня
		WHILE @date <= @last_date
		BEGIN
			IF EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@next_date AND [time]=@time_to_missed_classes AND teacher=@teacher)
			OR	dbo.IsHoliday(@next_date) = 1
			BEGIN
				SET	@group_name_info	=	(SELECT	group_name
											FROM	Groups, Schedule
											WHERE	[group]=group_id
											AND		teacher=@teacher
											AND		[date]=@next_date
											AND		[time]=@time_to_missed_classes)
				PRINT (FORMATMESSAGE(N'На дату %s и время %s уже назначенно занятие у группы %s. Или это праздник или каникулы',
									CAST(@next_date AS NCHAR(10)),
									CAST(@time_to_missed_classes AS NCHAR(8)),
									@group_name_info
									));
				SET	@next_date	=	DATEADD(DAY, 7, @next_date);
			END
			ELSE
	-----------------------------------------------------------------------------------------------------------------------------
	--Перенос занятия
			BEGIN
				UPDATE	Schedule
				SET		[date]	=	@next_date,	[time]	=	@time_to_missed_classes
				WHERE	[group]	=	@group	AND	teacher	=	@teacher	AND	[date]	=	@date	AND	[time]	=	(SELECT	start_time
																												FROM	Groups
																												WHERE	group_id	=	@group);
				UPDATE	Schedule
				SET		[date]	=	@next_date,	[time]	=	DATEADD(MINUTE, 95, @time_to_missed_classes)
				WHERE	[group]	=	@group	AND	teacher	=	@teacher	AND	[date]	=	@date	AND	[time]	=	DATEADD(MINUTE,
																												95,
																												(SELECT	start_time
																												FROM	Groups
																												WHERE	group_id	=	@group));
				PRINT(FORMATMESSAGE(N'Занятие группы %s перенесено с %s на %s', @group_name, CAST(@date AS NCHAR(10)), CAST(@next_date AS NCHAR(10))));
				SET	@next_date	=	DATEADD(DAY, 7, @next_date);
				SET	@date		=	dbo.GetNextLearningDay(@group_name, @date);
			END
		END
	END
	ELSE
	-----------------------------------------------------------------------------------------------------------------------------
	--Если предложенная дата @date_to_missed_classes на каникулах или праздниках
	--Проверка конкретного "праздничного" дня
	BEGIN
		WHILE @date <= @last_date
		BEGIN
			IF dbo.IsHoliday(@next_date) = 0
			BEGIN
				PRINT (FORMATMESSAGE(N'На время %s все дни выбранного праздника(каникул) уже заняты.
									Выберите другие даты и время для оставшихся занятий с %s по %s',
									CAST(@time_to_missed_classes AS NCHAR(8)),
									CAST(@date AS NCHAR(10)),
									CAST(@last_date AS NCHAR(10))
									));
				RETURN;
			END
			IF EXISTS (SELECT lesson_id FROM Schedule WHERE [date]=@next_date AND [time]=@time_to_missed_classes AND teacher=@teacher)
			BEGIN
				SET	@group_name_info	=	(SELECT	group_name
											FROM	Groups, Schedule
											WHERE	[group]=group_id
											AND		teacher=@teacher
											AND		[date]=@next_date
											AND		[time]=@time_to_missed_classes);
				PRINT (FORMATMESSAGE(N'На дату %s и время %s уже назначенно занятие у группы %s',
									CAST(@next_date AS NCHAR(10)),
									CAST(@time_to_missed_classes AS NCHAR(8)),
									@group_name_info
									));
				SET	@next_date	=	DATEADD(DAY, 1, @next_date);
			END
			ELSE
	-----------------------------------------------------------------------------------------------------------------------------
	--Перенос занятия
			BEGIN
				UPDATE	Schedule
				SET		[date]	=	@next_date,	[time]	=	@time_to_missed_classes
				WHERE	[group]	=	@group	AND	teacher	=	@teacher	AND	[date]	=	@date	AND	[time]	=	(SELECT	start_time
																												FROM	Groups
																												WHERE	group_id	=	@group);
				UPDATE	Schedule
				SET		[date]	=	@next_date,	[time]	=	DATEADD(MINUTE, 95, @time_to_missed_classes)
				WHERE	[group]	=	@group	AND	teacher	=	@teacher	AND	[date]	=	@date	AND	[time]	=	DATEADD(MINUTE,
																												95,
																												(SELECT	start_time
																												FROM	Groups
																												WHERE	group_id	=	@group));
				PRINT(FORMATMESSAGE(N'Занятие группы %s перенесено с %s на %s', @group_name, CAST(@date AS NCHAR(10)), CAST(@next_date AS NCHAR(10))));
				SET	@next_date	=	DATEADD(DAY, 1, @next_date);
				SET	@date		=	dbo.GetNextLearningDay(@group_name, @date);
			END
		END
	END
END