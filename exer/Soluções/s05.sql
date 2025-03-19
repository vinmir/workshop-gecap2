-- Refaça o exemplo 04 mas com referência ao ts_criacao de cada sessão (ao invés de ts_evento)

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
	FROM
		sessao_jogador sj 
)
, contagem_evento as (
	SELECT 
		 date(ts_criacao_agrupado) as dia
		, time(ts_criacao_agrupado) as t
		, so_sessao
		, trilha
		, versao_jogo
		, count(*) ctg
	from
		dados_jogador_evento
	WHERE 1=1
		and date(ts_criacao_agrupado) = ${dia}
		and time(ts_criacao_agrupado) between ${t0} and ${t1}
	group by
		ts_criacao_agrupado
		, so_sessao
		, trilha
		, versao_jogo
)
select 
	 ${dia} as dia
	, janelas.t
	, so_sessao
	, trilha
	, versao_jogo
	, ctg
from janelas left join contagem_evento ce on janelas.t=ce.t

