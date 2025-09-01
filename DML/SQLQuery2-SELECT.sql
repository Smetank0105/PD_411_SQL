USE PD_321;
GO

--	SELECT columns FROM tables	--
--	*	-	выбрать все поля из указанных таблиц

--SELECT 
--		direction_id	AS	N'Номер направления',
--		direction_name	AS	N'Название'
--FROM Directions;

--INSERT Groups
--		(group_id,group_name,direction,learning_form)
--VALUES	(7,N'SU_411',2,1);

--SELECT
--		group_name		AS	N'Название группы',
--		direction_name	AS	N'Направление обучения'
--FROM	Groups, Directions
--WHERE	direction	=	direction_id
--AND		direction_name	LIKE(N'Сетевые технологии%')
--;
--	%	-	все возможные символы

--SELECT
--		last_name + ' ' + first_name + ' ' + middle_name	AS N'Студент',
--		group_name		AS	N'Группа',
--		direction_name	AS	N'Нарпавление'
--FROM	Students,Groups,Directions
--WHERE	[group]		=	group_id
--AND		direction	=	direction_id
--;

SELECT
		COUNT(stud_id)	AS	N'Кол-во студентов'
FROM	Students;
