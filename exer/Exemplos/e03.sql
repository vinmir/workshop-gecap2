-- Exemplo de manipulação com horários

@set t0 = '09:00:00'
@set t1 = '13:00:00'
@set t_janela = 30

WITH
dados_jogador_evento AS (
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
select * from dados_jogador_evento where id_sessao=115



-- Área de testes:
@set timestamp= '2025-02-03 06:51:18'

select strftime('%Y-%m-%d %H:', ${timestamp})||printf('%02d:00', strftime('%M', ${timestamp})/${t_janela}*${t_janela});
