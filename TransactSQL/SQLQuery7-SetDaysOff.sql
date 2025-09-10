--SQLQuery7-SetDaysOff.sql
USE PD_321;
GO

ALTER PROCEDURE sp_SetDaysOff
(
	@year	AS	INT
)
AS
BEGIN
	EXEC	sp_SetNewYearHolidays	@year, N'Новогодние%';
END