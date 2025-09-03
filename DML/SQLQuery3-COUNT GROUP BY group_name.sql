USE PD_321;
GO

SELECT		group_name	AS	N'������',	COUNT([group])	AS	N'���-�� ���������'
FROM		Groups,	Students
WHERE		group_id	=	[group]
GROUP BY	group_name;

SELECT		direction_name	AS	N'�����������',	COUNT(direction)	AS	N'���-�� ���������'
FROM		Students,	Groups,	Directions
WHERE		group_id	=	[group]
AND			direction	=	direction_id
GROUP BY	direction_name;