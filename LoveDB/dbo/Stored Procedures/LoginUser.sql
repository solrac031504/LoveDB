CREATE PROCEDURE [dbo].[LoginUser]
	@pUsername			NVARCHAR(255)
	, @pPassword		BINARY(32)
	, @poAuthenticated	BIT				OUTPUT
	, @poAuthExpiration DATETIME		OUTPUT
	, @poErrorMessage	NVARCHAR(255)	OUTPUT
AS
BEGIN

BEGIN TRY
SET NOCOUNT ON
SET XACT_ABORT ON

-- Initialize vars
SET @poAuthenticated = 0;
SET @poAuthExpiration = NULL;
SET @poErrorMessage = NULL;

-- Declare var
DECLARE @LoginId INT = NULL;

-- Get the user
SELECT
	@LoginId = ul.UserLoginId
FROM
	dbo.UserLogin AS ul
WHERE
	1=1
	AND ul.Username = @pUsername
	AND ul.LoginPwd = @pPassword
;

/*
-- ======================================================
-- Check if user exists
-- ======================================================
*/
IF @LoginId IS NULL
BEGIN
	SET @poErrorMessage = N'Invalid username or password';
	RETURN;
END

/*
-- ======================================================
-- Set authenticated and auth experiation
-- ======================================================
*/
SELECT
	@poAuthenticated = 1
	, @poAuthExpiration = DATEADD(hour, 2, GETUTCDATE())
;

/*
-- ======================================================
-- Update login info
-- ======================================================
*/
BEGIN TRANSACTION

UPDATE
	ul
SET
	ul.LastLoginDate = GETUTCDATE()
	, ul.LoginCount = ul.LoginCount + 1
	, ul.ModifiedBy = SUSER_SNAME()
	, ul.ModifiedUtc = GETUTCDATE()
FROM
	dbo.UserLogin AS ul
WHERE
	ul.UserLoginId = @LoginId
;

COMMIT TRANSACTION

/*
-- ======================================================
-- Error handling
-- ======================================================
*/

END TRY

BEGIN CATCH

	-- Capture error message
	SELECT
		@poErrorMessage = ERROR_MESSAGE()
		, @poAuthenticated = 0
		, @poAuthExpiration = NULL
	;

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

	;THROW

END CATCH

END

GO