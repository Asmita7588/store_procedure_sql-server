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