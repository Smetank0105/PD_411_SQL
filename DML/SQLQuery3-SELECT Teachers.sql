USE PD_321;
GO

SELECT
			[Ф.И.О.]				=	FORMATMESSAGE(N'%s	%s	%s',	last_name,	first_name,	middle_name),
			[Возраст]			=	CAST(DATEDIFF(DAY, birth_date, GETDATE())/365.25	AS	INT),
			[Опыт преподавания]	=	CAST(DATEDIFF(DAY, work_since, GETDATE())/365.25	AS	INT),
			[Кол-во дисциплин]	=	COUNT(discipline_id)
FROM		Teachers,	Disciplines,	TeachersDisciplinesRelation
WHERE		teacher		=	teacher_id
AND			discipline	=	discipline_id
--AND			CAST(DATEDIFF(DAY, birth_date, GETDATE())/365.25	AS	INT)	>	40
GROUP BY	last_name,	first_name,	middle_name,	birth_date,	work_since
--HAVING		COUNT(discipline)	BETWEEN	5	AND	10
ORDER BY	[Кол-во дисциплин]
;

PRINT(GETDATE());