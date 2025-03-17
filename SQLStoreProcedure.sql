use customerDb;
-- store procedure
create dataBase storeProceduresDb;

use storeProceduresDb;

CREATE TABLE userDemo (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Email NVARCHAR(255) UNIQUE,
    Gender NVARCHAR(50)
);

-- store procedure for insert for above table
create procedure uspInsertIntoUserDemo(
@ID int,
@Name NVARCHAR(50),
@Email NVARCHAR(255),
@Gender NVARCHAR(50)
)
AS
BEGIN
INSERT INTO userDemo(ID, Name, Email, Gender)values(@ID, @Name, @Email, @Gender);
END;


exec uspInsertIntoUserDemo 3, 'chetan','chetan@gmail.com','male'

-- store procedure for select
Create Proc uspFetchUserData
as
begin
select * from userDemo;
end;

EXEC uspFetchUserData;

-- store procedure for for update

create proc uspUpdateUserData(
@ID INT,
@Name NVARCHAR(50),
@Email NVARCHAR(255),
@Gender Nvarchar(50)
)
as
begin
update userDemo set Name = @Name,Email = @Email, Gender= @Gender where ID = @ID;
end

EXEC uspUpdateUserData 1, 'ankita', 'ankita@gmail.com', 'female'

-- store procedure for for update
create proc uspDeleteUserData(
@ID int
)
as 
begin
Delete from userDemo where ID = @ID
end;

exec uspDeleteUserData 2
