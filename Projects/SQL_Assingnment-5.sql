

create function FactorialCalculate(@number int)
returns bigint
as
begin
declare @i int = 1

 while @number>1
 begin
  set @i = @number *  @i
  set @number =@number-1
  end

return @i
end

select dbo.FactorialCalculate(8)