--Crie uma CTE que gere 1000 números aleatórios distribuidos segundo uma normal de média 0 e std 1.
--Em seguida, calcule média e desvio padrão. Constate que a média é ~0 e o desvio padrão é ~1.
--Realize uma transformação das variáveis normais do item anterior para o tipo Y = aX + b. Constate que as variáveis Y têm média b e std a.

@set n=10000
@set a=7200
@set b=42000

WITH
uniform(i, u1, u2) as (
	select 1, (random()/9223372036854775807.0 + 1)/2, (random()/9223372036854775807.0 + 1)/2
	union all
	select i+1, (random()/9223372036854775807.0 + 1)/2, (random()/9223372036854775807.0 + 1)/2 from uniform where i+1<=${n}
)
, normal(i, x) AS(
	select i, sqrt(-2*ln(u1))*cos(2*3.14159265*u2) from uniform
)
, transformed_normal(i, y) as (
	select 
		i
		, ${a}*x+${b} as y 
	from normal
)
, time_values(i, t) as (
	select i, time('00:00:00', '+'||y||' seconds') from transformed_normal
)
--SELECT * FROM uniform
--SELECT avg(x), sqrt(avg(x*x)-avg(x)*avg(x)) FROM normal
--SELECT avg(y) media, sqrt(avg(y*y)-pow(avg(y), 2)) desv_pad FROM transformed_normal;
select * from time_values;


