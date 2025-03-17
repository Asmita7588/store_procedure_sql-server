--1. Banking: Withdrawal with Balance Check (No Logging)
--Problem:
--Implement a stored procedure to handle bank account withdrawals. Ensure:
--The withdrawal amount does not exceed the account balance.
--Raise errors for insufficient funds or non-existent accounts.
--Solution:
use storeProceduresDb;

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,       
    AccountHolder NVARCHAR(100) NOT NULL,  
    Balance DECIMAL(10, 2) CHECK (Balance >= 0), 
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    TransactionType NVARCHAR(20) CHECK (TransactionType IN ('Deposit', 'Withdrawal')),
    Amount DECIMAL(10, 2),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

INSERT INTO Accounts (AccountID, AccountHolder, Balance)
VALUES 
    (1, 'Asmita', 5000.00),
    (2, 'Ankita', 10000.00),
    (3, 'Chetan', 7500.50),
    (4, 'Aniket', 2000.75),
    (5, 'Pranay', 12000.25);

use storeProceduresDb

CREATE PROCEDURE WithdrawAmount
    @AccountID INT,
    @Amount DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        -- Check if the withdrawal amount is valid
        IF @Amount <= 0
        BEGIN
            THROW 50006, 'Invalid withdrawal amount. Amount must be greater than zero.', 1;
        END

        -- Check if account exists
        IF NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountID = @AccountID)
        BEGIN
            THROW 50004, 'Account not found.', 1;
        END

        -- Get current balance
        DECLARE @Balance DECIMAL(10,2);
        SELECT @Balance = Balance FROM Accounts WHERE AccountID = @AccountID;

        -- Check if balance is sufficient
        IF @Balance < @Amount
        BEGIN
            THROW 50005, 'Insufficient funds.', 1;
        END

        -- Deduct the amount
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        -- Insert transaction record
        INSERT INTO Transactions (AccountID, TransactionType, Amount)
        VALUES (@AccountID, 'Withdrawal', @Amount);

        PRINT 'Withdrawal successful. Remaining Balance: ' + CAST(@Balance - @Amount AS NVARCHAR(50));
    END TRY
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END;


EXEC WithdrawAmount @AccountID = 2, @Amount = 3000.00;

EXEC WithdrawAmount @AccountID = 4, @Amount = 5000.00;

EXEC WithdrawAmount @AccountID = 10, @Amount = 1000.00;

SELECT * FROM Accounts;
SELECT * FROM Transactions;


