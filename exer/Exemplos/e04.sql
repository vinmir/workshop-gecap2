-- Resgate particionado: um exemplo

-- Evite usar left joins entre colunas com funções determinadas. 
-- Exemplo: se a tabela de janelas for construída apenas como TIMEs ao invés de DATETIMEs, o left join
-- poderia ser encarado como ... janelas LEFT JOIN contagem_evento on janelas.dt = time(contagem_evento.ts_evento_agrupado),
-- o algoritmo de left join falhará e os nulls não serão entregues.
-- Ademais, o LEFT JOIN falhará sempre que houver uma condição sobre um campo no qual uma das colunas pode ser nula. Isso 
-- impede os registros NULLs de aparecerem. Exemplo: insira o filtro de data em `contagem_evento`, não no select final.
-- Se o filtro for inserido no select final, eliminará todos os NULLs e o LEFT JOIN se comporatrá como INNER JOIN.

@set dia = '2025-03-04'
@set t0 = '09:00:00'
@set t1 = '13:00:00'
@set t_janela = 30

WITH
janelas(t) as (
	select time(${t0})
	union all
	select time(t,'+'||${t_janela}||' minutes') from janelas where time(t,'+'||${t_janela}||' minutes') < ${t1}
)
, dados_jogador_evento AS (
	SELECT
		sj.id_sessao
		, sj.ts_criacao
		, strftime('%Y-%m-%d %H:', sj.ts_criacao)||printf('%02d:00', strftime('%M', sj.ts_criacao)/${t_janela}*${t_janela}) as ts_criacao_agrupado
		, sj.so_sessao
		, sj.trilha
		, sj.versao_jogo
		, es.ts_evento
		, strftime('%Y-%m-%d %H:', es.ts_evento)||printf('%02d:00', strftime('%M', es.ts_evento)/${t_janela}*${t_janela}) as ts_evento_agrupado
		, es.nivel
		, es.indicador_conclusao
	FROM
		sessao_jogador sj 
		inner join eventos_sessao es on es.id_sessao = sj.id_sessao
)
, contagem_evento as (
	SELECT 
		 date(ts_evento_agrupado) as dia
		, time(ts_evento_agrupado) as t
		, so_sessao
		, trilha
		, versao_jogo
		, nivel
		, indicador_conclusao	
		, count(*) ctg
	from
		dados_jogador_evento
	WHERE 1=1
		and date(ts_evento_agrupado) = ${dia}
		and time(ts_evento_agrupado) between ${t0} and ${t1}
	group by
		ts_evento_agrupado
		, so_sessao
		, trilha
		, versao_jogo
		, nivel
		, indicador_conclusao	
)
select 
	 ${dia} as dia
	, janelas.t
	, so_sessao
	, trilha
	, versao_jogo
	, nivel
	, indicador_conclusao
	, ctg
from janelas left join contagem_evento ce on janelas.t=ce.t

