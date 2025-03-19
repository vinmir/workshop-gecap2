-- Exemplo de resgate de dados

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
		, jg.nome
		, jg.email
	FROM
		sessao_jogador sj 
		inner join eventos_sessao es on es.id_sessao = sj.id_sessao
		inner join jogadores jg on jg.id_jogador = sj.id_jogador
)
select * from dados_jogador_evento
	where date(sj.ts_criacao) = '2025-02-11'
;

select date('2025-02-20 10:00:00');
