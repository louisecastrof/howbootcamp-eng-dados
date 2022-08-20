-- CREATE TABLE BILLBOARD

create table public."Billboard" (
-- aspas duplas no nome faz com que ele seja case sensitive
"date" date NULL,
"rank" int4 NULL,
-- date e rank são comandos SQL, então, quando forem usados colocar entre aspas
song VARCHAR(300) NULL,
artist VARCHAR(300) NULL,
"last-week" int4 NULL,
"peak-rank" int4 NULL,
"weeks-on-board" int4 NULL
);

-- DATA VALIDATION ORIGIN-TARGET

select count(*) as quantidade 
from public."Billboard"
limit 100
;

SELECT t1."date"
	,t1."rank"
	,t1.song
	,t1.artist
	,t1."last-week"
	,t1."peak-rank"
	,t1."weeks-on-board"
	-- definir os campos mesma que seja todos, custa menos
FROM PUBLIC."Billboard" AS t1
	--referenciar tabela pra usar nas variáveis
	limit 100;
	--formatado pelo poorsql.com


SELECT t1.artist
	,t1.song
	,count(*) AS "#song"
FROM PUBLIC."Billboard" AS t1
--WHERE t1.artist = 'Chuck Berry' or t1.artist = 'Frankie Vaughan'
where t1.artist in ('Chuck Berry', 'Frankie Vaughan')
--aspas simples pra passar valor
-- usando 'in' para não poluir query com vários 'or'
GROUP BY t1.artist
	,t1.song
	-- count requere group by
order by "#song" desc;
	-- selecionando as musicas que mais aparecem por primeiro

-- DESAFIO 1 - AGOSTO - PRINT

SELECT t1.artist
	,t1.song
	,count(*) AS "#song"
FROM PUBLIC."Billboard" AS t1
WHERE t1.artist = 'Chuck Berry'
GROUP BY t1.artist
	,t1.song
ORDER BY "#song" DESC;

SELECT DISTINCT
	--usando distinct para eliminar repetições de músicas
	t1.artist
	,t1.song
FROM PUBLIC."Billboard" AS t1
ORDER BY t1.artist
	,t1.song

SELECT t1.artist
	,count(*) AS qtd_artista
FROM PUBLIC."Billboard" AS t1
GROUP BY t1.artist
ORDER BY t1.artist

SELECT t1.song
	,count(*) AS qtd_song
FROM PUBLIC."Billboard" AS t1
GROUP BY t1.song
ORDER BY t1.song

-- Juntando queries pra unir colunas (CTEs)
SELECT DISTINCT t1.artist
	,t2.qtd_artista
	,t1.song
	,t3.qtd_song
FROM PUBLIC."Billboard" AS t1
LEFT JOIN (
	SELECT t1.artist
		,count(*) AS qtd_artista
	FROM PUBLIC."Billboard" AS t1
	GROUP BY t1.artist
	ORDER BY t1.artist
	) AS t2 ON (t1.artist = t2.artist)
LEFT JOIN (
	SELECT t1.song
		,count(*) AS qtd_song
	FROM PUBLIC."Billboard" AS t1
	GROUP BY t1.song
	ORDER BY t1.song
	) AS t3 ON (t1.song = t3.song)
ORDER BY t1.artist
	,t1.song
-- sem criar CTEs a visualização fica difícil

-- Juntando queries pra unir colunas
-- CRIANDO TABELA ARTIST
WITH cte_artist
AS (
	SELECT t1.artist
		,count(*) AS qtd_artista
	FROM PUBLIC."Billboard" AS t1
	GROUP BY t1.artist
	ORDER BY t1.artist
	)
	,
	-- CRIANDO TABELA SONG
cte_song
AS (
	SELECT t1.song
		,count(*) AS qtd_song
	FROM PUBLIC."Billboard" AS t1
	GROUP BY t1.song
	ORDER BY t1.song
	)
-- FAZENDO O JOIN DE TABELAS
SELECT DISTINCT t1.artist
	,t2.qtd_artista
	,t1.song
	,t3.qtd_song
FROM PUBLIC."Billboard" AS t1
LEFT JOIN cte_artist AS t2 ON (t1.artist = t2.artist)
LEFT JOIN cte_song AS t3 ON (t1.song = t3.song)
ORDER BY t1.artist
	,t1.song;