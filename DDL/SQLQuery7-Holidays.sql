--SQLQuery7-Holidays.sql
USE PD_321;
GO

--DROP	TABLE	DaysOFF;
--DROP	TABLE	Holidays;
--CREATE	TABLE	Holidays
--(
--	holiday_id		TINYINT			PRIMARY KEY,
--	holiday_name	NVARCHAR(150)	NOT NULL,
--	duration		TINYINT			NOT NULL,
--	start_day		TINYINT,
--	start_month		TINYINT
--);

--CREATE TABLE	DaysOFF
--(
--	dayoff_id		SMALLINT		PRIMARY KEY	IDENTITY(1,1),
--	[date]			DATE			NOT NULL,
--	holiday			TINYINT			NOT NULL
--	CONSTRAINT		FK_DaysOFF_to_Holidays	FOREIGN KEY REFERENCES Holidays(holiday_id)
--);