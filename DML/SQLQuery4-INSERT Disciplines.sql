USE PD_321;
GO

--INSERT	Disciplines
--		(discipline_name,number_of_lessons)
--VALUES
--		(N'Основы разработки приложений с использованием Windows Forms и WPF',32),
--		(N'Конфигурирование Windows 10',32),
--		(N'Основы Информационных технологий',24)
--		;

--UPDATE	Disciplines
--SET		number_of_lessons	=	68
--WHERE	discipline_name	=	N'Процедурное программирование на языке C++'
--;

SELECT	discipline_id,discipline_name,number_of_lessons
FROM	Disciplines;