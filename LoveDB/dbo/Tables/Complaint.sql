CREATE TABLE [dbo].[Complaint]
(
	ComplaintId				INT IDENTITY(1, 1)	NOT NULL
	, ComplaintTypeId		INT					NOT NULL
	, ComplaintDescription	NVARCHAR(1000)		NOT NULL
	, SeverityLevel			INT					NOT NULL
	, CreatedUtc			DATETIME			NOT NULL CONSTRAINT [DF_Complaint_CreatedUtc] DEFAULT(GETUTCDATE())
	, CreatedBy				NVARCHAR(255)		NOT NULL CONSTRAINT [DF_Complaint_CreatedBy] DEFAULT (SUSER_SNAME())
	, ModifiedUtc			DATETIME				NULL
	, ModifiedBy			NVARCHAR(255)			NULL
	, CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED (ComplaintId ASC)
);
GO

-- *************************
-- INDEXES
-- *************************
CREATE NONCLUSTERED INDEX [IX_Complaint_ComplaintTypeId]
ON [dbo].[Complaint] (ComplaintTypeId)
INCLUDE (ComplaintDescription, SeverityLevel, CreatedUtc);
GO

-- *************************
-- CONSTRAINTS
-- *************************

ALTER TABLE [dbo].[Complaint]
ADD CONSTRAINT [CK_Complaint_SeverityLevel]
CHECK (SeverityLevel >= 1 AND SeverityLevel <= 5);
GO

ALTER TABLE [dbo].[Complaint]
ADD CONSTRAINT [FK_Complaint_ComplaintTypeId]
FOREIGN KEY (ComplaintTypeId)
REFERENCES [dbo].[Complaint] (ComplaintTypeId);
GO