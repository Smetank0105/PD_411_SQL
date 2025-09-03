USE PD_321;
GO

SELECT		group_name	AS	N'Группа',	COUNT([group])	AS	N'Кол-во студентов'
FROM		Groups,	Students
WHERE		group_id	=	[group]
GROUP BY	group_name;

SELECT		direction_name	AS	N'Направление',	COUNT(direction)	AS	N'Кол-во студентов'
FROM		Students,	Groups,	Directions
WHERE		group_id	=	[group]
AND			direction	=	direction_id
GROUP BY	direction_name;