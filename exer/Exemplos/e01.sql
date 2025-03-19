-- Exemplo de uso de CTEs: VIEWs não armazenadas no disco

with
tab_a(x,y,z,t) as (
	select 1 as x, 2.121 as y, 'três' as z, time('10:00:00') as t
	union
	select 2, 5.784, 'seis', time('11:01:00')
	union
	select 3, -8.41, 'nove', time('12:20:04')
)
, tab_b as (
	select 1 as x, 2.121 as y, 'três' as z, time('10:00:00') as t
	union
	select 2, 5.784, 'seis', time('11:01:00')
	union
	select 4, -8.41, 'nove', time('12:20:04')
)
--select * from tab_a
select * from tab_b left join tab_a on tab_a.x=tab_b.x
