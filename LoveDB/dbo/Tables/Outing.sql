CREATE TABLE [dbo].[Outing]
(
	OutingId				INT IDENTITY(1, 1)	NOT NULL
	, OutingTypeId			INT					NOT NULL
	, OutingDescription		NVARCHAR(4000)		NOT NULL
	, OutingLocation		GEOGRAPHY			NOT NULL
	, OutingDate			DATE				NOT NULL
	, CreatedUtc			DATETIME			NOT NULL CONSTRAINT [DF_Outing_CreatedUtc] DEFAULT (GETUTCDATE())
	, CreatedBy				NVARCHAR(255)		NOT NULL CONSTRAINT [DF_Outing_CreatedBy] DEFAULT (SUSER_SNAME())
	, ModifiedUtc			DATETIME				NULL
	, ModifiedBy			NVARCHAR(255)			NULL
	, CONSTRAINT [PK_Outing] PRIMARY KEY CLUSTERED (OutingId ASC)
);
GO

-- *************************
-- INDEXES
-- *************************
CREATE NONCLUSTERED INDEX [IX_Outing_OutingTypeId]
ON [dbo].[Outing] (OutingTypeId)
INCLUDE 
(
	OutingDescription
	, OutingLocation
	, OutingDate
);
GO

-- *************************
-- CONSTRAINTS
-- *************************
ALTER TABLE [dbo].[Outing]
ADD CONSTRAINT [FK_Outing_OutingTypeId]
FOREIGN KEY (OutingTypeId)
REFERENCES [dbo].[OutingType] (OutingTypeId);
GO

-- *************************
-- EXTENDED PROPERTIES
-- *************************
EXEC sys.sp_addextendedproperty
	@name = N'Description'
	, @value = N'Information regarding dates and romantic outings'
	, @level0type = N'SCHEMA'
	, @level0name = N'dbo'
	, @level1type = N'TABLE'
	, @level1name = N'Outing';
GO