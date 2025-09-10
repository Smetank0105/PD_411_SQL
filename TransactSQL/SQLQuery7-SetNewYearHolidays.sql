--SQLQuery7-SetHolidays.sql
SET DATEFIRST 1;
USE PD_321;
GO

ALTER PROCEDURE sp_SetNewYearHolidays	@year	AS	INT,	@holiday_name	NVARCHAR(150)
AS
BEGIN
	DECLARE	@holiday	AS	TINYINT	=	(SELECT	holiday_id	FROM	Holidays	WHERE	holiday_name	LIKE	@holiday_name);
	DECLARE	@duration	AS	TINYINT	=	(SELECT	duration	FROM	Holidays	WHERE	holiday_id		LIKE	@holiday);
	--DECLARE	@day		AS	TINYINT	=	(SELECT	start_day	FROM	Holidays	WHERE	holiday_id		LIKE	@holiday);
	--DECLARE	@month		AS	TINYINT	=	(SELECT	start_month	FROM	Holidays	WHERE	holiday_id		LIKE	@holiday);
	DECLARE	@start_date	AS	DATE	=	DATEFROMPARTS(@year, 1, 1);
	SET		@start_date				=	DATEADD(DAY, 1-DATEPART(WEEKDAY,@start_date), @start_date);

	DECLARE	@date		AS	DATE	=	@start_date;
	WHILE	@date	<	DATEADD(DAY,@duration,@start_date)
	BEGIN
		INSERT	DaysOFF	
		VALUES	(@date,	@holiday)
		SET	@date	=	DATEADD(DAY,1,@date);
	END
END