use customerDb;

--practice 

create Procedure userProductList
as 
begin

select product_name, list_price from production.products
order by product_name;

end;

exec userProductList

-- to alter

Alter proc userProductList
as
begin
select product_name,list_price  from production.products
order by list_price
end;

--execute
exec userProductList

--delete procedure 
drop proc userProductList;

--2)
create Procedure userFindProduct
as 
begin

select product_name, list_price from production.products
order by product_name;

end;

exec userFindProduct;
--Creating a stored procedure with one parameter
Alter proc userFindProduct(@min_list_price as DECIMAL)
AS
begin
select product_name, list_price from production.products 
where list_price > = @min_list_price
order by product_name;
end;

exec userFindProduct 1000;

--Creating a stored procedure with multiple parameters Stored procedures
Alter proc userFindProduct(@min_list_price as DECIMAL, @max_list_price as DECIMAL)
AS
begin
select product_name, list_price from production.products 
where list_price > = @min_list_price and
list_price <= @max_list_price
order by product_name;
end;

exec userFindProduct 1000 , 2000;
--using named parameter
EXECUTE userFindProduct 
    @min_list_price = 900, 
    @max_list_price = 1000;

--Creating text parameters

Alter proc userFindProduct(@min_list_price as DECIMAL, @max_list_price as DECIMAL, @name as varchar(max))
AS
begin
select product_name, list_price from production.products 
where list_price > = @min_list_price and
list_price <= @max_list_price and
product_name LIKE '%' + @name + '%'
order by list_price;
end;

exec userFindProduct
@min_list_price = 900,
@max_list_price = 1000,
@name = 'Trek';

--Creating optional parameters

Alter proc userFindProduct(@min_list_price as DECIMAL = 0, @max_list_price as DECIMAL =999999, @name as varchar(max))
AS
begin
select product_name, list_price from production.products 
where list_price > = @min_list_price and
list_price <= @max_list_price and
product_name LIKE '%' + @name + '%'
order by list_price;
end;

exec userFindProduct
    @name = 'Trek';

exec userFindProduct
@min_list_price = 600,
    @name = 'Trek';

Alter proc userFindProduct(@min_list_price as DECIMAL = 0, @max_list_price as DECIMAL =NULL, @name as varchar(max))
AS
begin
select product_name, list_price from production.products 
where list_price > = @min_list_price AND
(@max_list_price IS NULL OR list_price <= @max_list_price) AND
product_name LIKE '%' + @name + '%'
order by list_price;
end;

EXEC userFindProduct
    @min_list_price = 500,
    @name = 'Haro';

	--variable declaration 
	DECLARE @model_year SMALLINT;

	SET @model_year = 2019;

	select product_name, model_year, list_price from production.products where model_year = @model_year
	order by product_name;

	--Storing query result in a variable
	Declare @product_count int;

	Set @product_count = (
	select COUNT(*) from production.products);

	select @product_count

	--Accumulating values into a variable
	create proc uspGetProductList(
	@model_year smallint)
	as
	begin
	declare @product_list varchar(max);

	set @product_list = ' ';
	select 
	@product_list = @product_list + product_name + CHAR(10)
	from production.products
	where model_year = @model_year
	order by
	product_name;

	select @product_list;
	end;

	EXEC uspGetProductList 2018

	--if-else
BEGIN
	DECLARE @sales INT;
	
	Select
	@sales = SUM(list_price * quantity)
	from sales.order_items i 
	INNER JOIN sales.orders o ON o.order_id = i.order_id
	where YEAR(order_date) = 2018;
	
	select @sales;

	 IF @sales > 1000
    BEGIN
        PRINT 'Great! The sales amount in 2017 is greater than 10,000,000';
    END
    ELSE
    BEGIN
        PRINT 'Sales amount in 2017 did not reach 10,000,000';
    END
END;


BEGIN
    DECLARE @x INT = 10,
            @y INT = 20;

    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 and x < y';
        ELSE
            PRINT 'x > 0 and x >= y';
    END			
END