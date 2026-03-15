CREATE TABLE [dbo].[UserLogin]
(
	UserLoginId			INT IDENTITY(1, 1)	NOT NULL
	, Username			NVARCHAR(255)		NOT NULL
	, LoginPwd			BINARY(32)			NOT NULL
	, LoginCount		INT					NOT NULL CONSTRAINT [DF_UserLogin_LoginCount] DEFAULT ((0))
	, LastLoginDate		DATETIME				NULL
	, CreatedUtc		DATETIME			NOT NULL CONSTRAINT [DF_UserLogin_CreatedUtc] DEFAULT (GETUTCDATE())
	, CreatedBy			NVARCHAR(255)		NOT NULL CONSTRAINT [DF_UserLogin_CreatedBy] DEFAULT (SUSER_SNAME())
	, ModifiedUtc		DATETIME				NULL
	, ModifiedBy		NVARCHAR(255)			NULL
	, CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED (UserLoginId ASC)
);
GO

-- *************************
-- INDEXES
-- *************************

CREATE UNIQUE NONCLUSTERED INDEX [UX_UserLogin_Username]
ON [dbo].[UserLogin] (Username)
INCLUDE (LoginPwd);
GO

-- *************************
-- TRIGGERS
-- *************************

CREATE TRIGGER [dbo].[TR_UserLogin_Modification]
ON [dbo].[UserLogin]
FOR INSERT, UPDATE
AS
BEGIN

UPDATE 
	ul
SET 
	ul.ModifiedUtc = GETUTCDATE()
	, ul.ModifiedBy = SUSER_SNAME()
FROM
	dbo.UserLogin AS ul
	JOIN INSERTED AS i
		ON ul.UserLoginId = i.UserLoginId
;

END;

GO

DISABLE TRIGGER [dbo].[TR_UserLogin_Modification]
ON [dbo].[UserLogin];

GO