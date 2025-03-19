-- Calcule quantos clientes por domínio de email iniciam sessão por dia (entre 10/02/2025 e 12/02/2025, inclusos)

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
		, substr(email, instr(email, '@'), length(email)) as dominio_email -- Faça testes com as funções descritas
	FROM
		sessao_jogador sj 
		inner join eventos_sessao es on es.id_sessao = sj.id_sessao
		inner join jogadores jg on jg.id_jogador = sj.id_jogador
)
select 
	date(ts_criacao) as dia
	, dominio_email
	, count(distinct email) ctg
from 
	dados_jogador_evento
where 
	date(ts_criacao) between '2025-02-10' and '2025-02-12'
group by
	dia, dominio_email
;


-- Exemplos para testar as funções relevantes:
@set email='abcd@gmail.com'

select substr(:email, instr(:email, '@'), length(:email));
	



