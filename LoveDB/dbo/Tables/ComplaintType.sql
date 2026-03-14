CREATE TABLE [dbo].[ComplaintType]
(
	ComplaintTypeId		INT IDENTITY(1, 1)	NOT NULL
	, ComplaintType		NVARCHAR(255)		NOT NULL
	, CreatedUtc		DATETIME			NOT NULL CONSTRAINT [DF_ComplaintType_CreatedUtc] DEFAULT (GETUTCDATE())
	, CreatedBy			NVARCHAR(255)		NOT NULL CONSTRAINT [DF_ComplaintType_CreatedBy] DEFAULT (SUSER_SNAME())
	, ModifiedUtc		DATETIME				NULL
	, ModifiedBy		NVARCHAR(255)			NULL
);
GO
