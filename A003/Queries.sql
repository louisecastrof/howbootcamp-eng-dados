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



WITH cte_billboard
AS (
	SELECT DISTINCT t1.artist
		,t1.song
		,row_number() OVER (
			ORDER BY artist
				,song
			) AS "row_number"
		,row_number() OVER (
			PARTITION BY artist ORDER BY artist
				,song
			) AS "row_number_artist" --cada vez que muda de artista, começa nova contagem
	FROM PUBLIC."Billboard" AS t1
	ORDER BY t1.artist
		,t1.song
	)
SELECT *
FROM cte_billboard
WHERE "row_number_artist" = 1 --filtrando por primeira vez que o artista aparece
WITH cte_billboard AS (
		SELECT DISTINCT t1.artist
			,t1.song
		FROM PUBLIC."Billboard" AS t1
		ORDER BY t1.artist
			,t1.song
		)

SELECT *
	,row_number() OVER (
		ORDER BY artist
			,song
		) AS "row_number"
	,row_number() OVER (
		PARTITION BY artist ORDER BY artist
			,song
		) AS "row_number_artist"
	,rank() OVER (
		PARTITION BY artist ORDER BY artist
			,song
		) AS "rank" -- dentro do artista a música aparece no rank mostrado (resultado igual row_number_artist)
	,lag(song, 1) OVER (
		PARTITION BY artist ORDER BY artist
			,song
		) AS lag_song --puxar a linha anterior daquele artista
	,lead(song, 1) OVER (
		PARTITION BY artist ORDER BY artist
			,song
		) AS lead_song --puxar a próxima linha daquele artista
	,first_value(song) OVER (
		PARTITION BY artist ORDER BY artist
			,song
		) AS "first_song" --primeira música do artista
	,last_value(song) OVER (
		PARTITION BY artist ORDER BY artist
			,song range BETWEEN unbounded preceding
				AND unbounded following
		) AS "last_song" --útlima música do artista, entre o artista anterior e o próximo, ele dá o valor
FROM cte_billboard WITH t(StyleID, ID, None) AS (
		SELECT 1
			,1
			,'Rhuan'
		
		UNION ALL
		
		SELECT 1
			,1
			,'Andre'
		
		UNION ALL
		
		SELECT 1
			,2
			,'Ana'
		
		UNION ALL
		
		SELECT 1
			,2
			,'Maria'
		
		UNION ALL
		
		SELECT 1
			,3
			,'Leticia'
		
		UNION ALL
		
		SELECT 1
			,3
			,'Lari'
		
		UNION ALL
		
		SELECT 1
			,4
			,'Edson'
		
		UNION ALL
		
		SELECT 1
			,4
			,'Marcos'
		
		UNION ALL
		
		SELECT 1
			,5
			,'Rhuan'
		
		UNION ALL
		
		SELECT 1
			,5
			,'Lari'
		
		UNION ALL
		
		SELECT 1
			,6
			,'Daisy'
		
		UNION ALL
		
		SELECT 1
			,6
			,'João'
		)

SELECT *
	,row_number() OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS row_number
	,rank() OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "rank"
	,dense_rank() OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "dense_rank"
	,percent_rank() OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "percent_rank"
	,cume_dist() OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "cume_dist"
	,--quão distante do início da tabela está
	cume_dist() OVER (
		PARTITION BY StyleID ORDER BY ID DESC
		) AS "cume_dist_desc"
	,--quão distante do final da tabela está
	first_value(None) OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "first_value"
	,nth_value(none, 5) OVER (
		PARTITION BY StyleID ORDER BY ID
		) AS "nth_value"
	,--qual é o quinto valor daquele artista
	ntile(5) OVER (
		ORDER BY ID
		) AS "lag_nome"
	,-- trazer uma linha específica
	lead(none, 1) OVER (
		ORDER BY ID
		) AS "lead_nome"
FROM t;

SELECT t1."date"
	,t1."rank"
	,t1.artist
FROM PUBLIC."Billboard" AS t1
ORDER BY t1.artist
	,t1."date" --trouxe várias vezes o mesmo resultado, próxima query irá trazer apenas uma vez o resultado

CREATE TABLE tb_web_site AS (
	WITH cte_dedup_artist AS (
		SELECT t1."date"
			,t1."rank"
			,t1.artist
			,row_number() OVER (
				PARTITION BY artist ORDER BY artist
					,"date"
				) AS dedup
		FROM PUBLIC."Billboard" AS t1
		ORDER BY t1.artist
			,t1."date"
		) SELECT t1."date"
	,t1."rank"
	,t1.artist FROM cte_dedup_artist AS t1 WHERE t1.dedup = 1
	);

SELECT *
FROM tb_web_site -- cria uma tabela sem acesso com outras informações, mas não atualiza dados se a tabela original for atualizada

CREATE TABLE tb_artist AS (
	SELECT t1."date"
	,t1."rank"
	,t1.artist
	,t1.song FROM PUBLIC."Billboard" AS t1 WHERE t1.artist = 'AC/DC' ORDER BY t1.artist
	,t1.song
	,t1."date"
	);

DROP TABLE tb_artist;

SELECT *
FROM tb_artist;

CREATE VIEW vw_artist
AS
(
		WITH cte_dedup_artist AS (
				SELECT t1."date"
					,t1."rank"
					,t1.artist
					,row_number() OVER (
						PARTITION BY artist ORDER BY artist
							,"date"
						) AS dedup
				FROM tb_artist AS t1
				ORDER BY t1.artist
					,t1."date"
				)
		SELECT t1."date"
			,t1."rank"
			,t1.artist
		FROM cte_dedup_artist AS t1
		WHERE t1.dedup = 1
		);

-- na tabela a informação fica cravada, na view é uma consulta já salva mas é recalculada toda vez que rodada, porém, tem custa toda vez que visualizada, é mais pesada
SELECT *
FROM vw_artist;

--drop view vw_artist;
INSERT INTO tb_artist (
	SELECT t1."date"
	,t1."rank"
	,t1.artist
	,t1.song FROM PUBLIC."Billboard" AS t1 WHERE t1.artist LIKE 'Elvis%' --todos que começam com Elvis
	ORDER BY t1.artist
	,t1.song
	,t1."date"
	);

CREATE VIEW vw_song
AS
(
		WITH cte_dedup_artist AS (
				SELECT t1."date"
					,t1."rank"
					,t1.artist
					,t1.song
					,row_number() OVER (
						PARTITION BY artist
						,song ORDER BY artist
							,song
							,"date"
						) AS dedup
				FROM tb_artist AS t1
				ORDER BY t1.artist
					,t1.song
					,t1."date"
				)
		SELECT t1."date"
			,t1."rank"
			,t1.artist
			,t1.song
		FROM cte_dedup_artist AS t1
		WHERE t1.dedup = 1
		);

SELECT *
FROM vw_song;

INSERT INTO tb_artist (
	SELECT t1."date"
	,t1."rank"
	,t1.artist
	,t1.song FROM PUBLIC."Billboard" AS t1 WHERE t1.artist LIKE 'Adele%' ORDER BY t1.artist
	,t1.song
	,t1."date"
	);

CREATE
	OR replace VIEW vw_song AS (
	--sem precisar dropar a tabela, não pode ter alteração de colunas
	WITH cte_dedup_artist AS (
		SELECT t1."date"
			,t1."rank"
			,t1.artist
			,t1.song
			,row_number() OVER (
				PARTITION BY artist
				,song ORDER BY artist
					,song
					,"date"
				) AS dedup
		FROM tb_artist AS t1
		ORDER BY t1.artist
			,t1.song
			,t1."date"
		) SELECT t1."date"
	,t1."rank"
	,t1.artist
	,t1.song FROM cte_dedup_artist AS t1 WHERE t1.dedup = 1
	);

