USE PD_321;
GO

--INSERT	Disciplines
--		(discipline_name,number_of_lessons)
--VALUES
--		(N'������ ���������� ���������� � �������������� Windows Forms � WPF',32),
--		(N'���������������� Windows 10',32),
--		(N'������ �������������� ����������',24)
--		;

--UPDATE	Disciplines
--SET		number_of_lessons	=	68
--WHERE	discipline_name	=	N'����������� ���������������� �� ����� C++'
--;

SELECT	discipline_id,discipline_name,number_of_lessons
FROM	Disciplines;