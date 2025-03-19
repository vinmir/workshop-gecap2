@set dia = '2025-03-04'
@set t0 = '06:00:00'
@set t1 = '16:00:00'
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
, contabilizacao as (
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
		and date(ts_criacao_agrupado)in (${dia}, date(${dia}, '-7 days'), date(${dia}, '-14 days'), date(${dia}, '-21 days'), date(${dia}, '-28 days'))
		and time(ts_criacao_agrupado) between ${t0} and ${t1}
	group by
		ts_criacao_agrupado
		, so_sessao
		, trilha
		, versao_jogo
)
, contagem_atual as (
	SELECT 
		 t
		, so_sessao
		, trilha
		, versao_jogo
		, ctg
	from
		contabilizacao
	WHERE 1=1
		and dia = ${dia}
)
, estatistica_hist as (
	SELECT 
		 t
		, so_sessao
		, trilha
		, versao_jogo
		, avg(ctg) as media
		, sqrt(avg(ctg*ctg) - avg(ctg)*avg(ctg)) as desv_pad
	from
		contabilizacao
	WHERE 1=1
		and dia <> ${dia}
	group by
		 t
		, so_sessao
		, trilha
		, versao_jogo
)
, resultado AS (
	select
		janelas.t
		, est.so_sessao
		, est.trilha
		, est.versao_jogo
		, ca.ctg
		, est.media
		, est.desv_pad
		, (case 
				when coalesce(ca.ctg, 0) < est.media - 3*est.desv_pad then 'Crítico'
				when coalesce(ca.ctg, 0) < est.media - 2*est.desv_pad then 'Alerta'
				when coalesce(ca.ctg, 0) < est.media - est.desv_pad then 'Instável'
				else 'OK' end) estado
	from 
		janelas 
		left join estatistica_hist est on est.t=janelas.t 
		-- Left join com os resultados estatísticos é necessário; do contrário, haverá duplicatas
		left join contagem_atual ca on 
			est.t=ca.t 
			and est.versao_jogo=ca.versao_jogo 
			and est.so_sessao = ca.so_sessao
			and est.trilha = ca.trilha
)
SELECT * FROM resultado WHERE estado = 'Crítico' and media > 40 -- Exemplos de filtros para detectar anormalidades
;
