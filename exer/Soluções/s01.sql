--Crie uma CTE que retorne os n primeiros elementos da sequência a(n+1) = a(n)*2, onde a(1) = 1

WITH elements(i, a) AS(
	SELECT 1, 1
	UNION ALL
	SELECT i+1, a*2 FROM elements WHERE i+1<=10
) SELECT i, a FROM elements


