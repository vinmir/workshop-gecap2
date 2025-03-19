-- Calcule quantos jogadores diferentes iniciam sessão por dia

WITH
dados_jogador_evento AS (
	SELECT
		sj.id_sessao
		, sj.ts_criacao
		, sj.so_sessao
		, sj.trilha
		, sj.versao_jogo
		, es.ts_evento
		, es.nivel
		, es.indicador_conclusao
		, jg.id_jogador
		, jg.nome
		, jg.email
	FROM
		sessao_jogador sj 
		inner join eventos_sessao es on es.id_sessao = sj.id_sessao
		inner join jogadores jg on jg.id_jogador = sj.id_jogador
)
select 
	date(ts_criacao) as dia
	, count(distinct id_jogador) ctg
from 
	dados_jogador_evento
where 
	date(ts_criacao) between '2025-02-10' and '2025-02-12'
group by
	dia
;
	




