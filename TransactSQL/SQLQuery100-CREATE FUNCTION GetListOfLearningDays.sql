--SQLQuery100-CREATE FUNCTION GetListOfLearningDays.sql
USE PD_321;
GO

ALTER FUNCTION	GetListOfLearningDays
(
	@learning_days	AS	TINYINT
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE	@list_of_days	AS	NVARCHAR(100)	=	N'';
	DECLARE	@count			AS	TINYINT			=	0;
	DECLARE	@temp			AS	TINYINT			=	@learning_days;
	
	WHILE	@count	<	7
	BEGIN
		IF	@temp%2	=1
		BEGIN
			SET @list_of_days	=	@list_of_days	+	' '	+	DATENAME(WEEKDAY,DATEADD(DAY,@count,'2001-01-01'));
		END
		SET	@temp	=	@temp	/	2;
		SET	@count	=	@count	+	1;
	END
	RETURN	@list_of_days;
END