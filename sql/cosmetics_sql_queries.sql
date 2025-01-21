-- Criação do banco de dados chamado "Cosmetics".
CREATE DATABASE "Cosmetics"
    WITH
    OWNER = postgres  -- Define o proprietário do banco de dados como o usuário "postgres".
    ENCODING = 'UTF8'  -- Define a codificação do banco como UTF-8, compatível com diversos idiomas.
    LOCALE_PROVIDER = 'libc'  -- Define o provedor de localização como 'libc', usado para determinar configurações regionais.
    CONNECTION LIMIT = -1  -- Permite conexões ilimitadas ao banco de dados.
    IS_TEMPLATE = False;  -- Indica que este banco de dados não será usado como modelo para criar outros bancos.

-- Criação da tabela "products" com colunas para armazenar dados dos produtos cosméticos.
CREATE TABLE products (
    Label VARCHAR(255),  -- Categoria ou tipo do produto (até 255 caracteres).
    Brand VARCHAR(255),  -- Marca do produto (até 255 caracteres).
    Name VARCHAR(255),  -- Nome do produto (até 255 caracteres).
    Price DECIMAL(10, 2),  -- Preço do produto, com até 10 dígitos no total e 2 casas decimais.
    Rank FLOAT,  -- Classificação ou pontuação do produto (valor numérico com ponto flutuante).
    Ingredients TEXT,  -- Lista de ingredientes do produto (campo de texto).
    Combination BOOLEAN,  -- Indica se o produto é para pele mista (true ou false).
    Dry BOOLEAN,  -- Indica se o produto é para pele seca (true ou false).
    Normal BOOLEAN,  -- Indica se o produto é para pele normal (true ou false).
    Oily BOOLEAN,  -- Indica se o produto é para pele oleosa (true ou false).
    Sensitive BOOLEAN  -- Indica se o produto é para pele sensível (true ou false).
);

-- Importação dos dados do arquivo CSV para a tabela "products".
COPY products (Label, Brand, Name, Price, Rank, Ingredients, Combination, Dry, Normal, Oily, Sensitive)
FROM 'C:/tmp/cosmetics_cleaned.csv'  -- Caminho completo do arquivo CSV.
DELIMITER ','  -- Define a vírgula como delimitador dos campos no arquivo.
CSV HEADER;  -- Indica que a primeira linha do arquivo contém os nomes das colunas.

-- Seleciona e exibe os primeiros 10 registros da tabela "products" para verificar a importação.
SELECT * FROM products LIMIT 10;

-- Adicionar uma nova coluna chamada 'id' para atuar como chave primária.
ALTER TABLE products
ADD COLUMN id_product SERIAL PRIMARY KEY;


-- *****************************************************
--  Consultas SQL para Análise de Dados de Cosméticos
-- *****************************************************

-- Consulta para selecionar todos os registros da tabela "products"
SELECT * FROM products;

-- Consulta para ordenar os produtos por preço de forma crescente
-- Isso ajuda a identificar quais são os produtos mais baratos.
SELECT * FROM products
ORDER BY Price ASC;

-- Seleção dos 10 produtos com os preços mais altos
-- Usamos LIMIT para restringir os resultados aos 10 primeiros registros após a ordenação.
SELECT * FROM products
ORDER BY Price DESC
LIMIT 10;

-- Consulta para buscar produtos que contêm "Water" nos ingredientes
-- Isso nos permite analisar todos os produtos que possuem um ingrediente específico.
SELECT * FROM products
WHERE Ingredients LIKE '%Water%';

-- Aqui estamos combinando múltiplas condições para filtrar os produtos com base em tipo de pele e preço.
SELECT * FROM products
WHERE Oily = TRUE
AND Price > 40;

SELECT * FROM products
WHERE Normal = TRUE
AND Price < 50;

SELECT * FROM products
WHERE Sensitive = TRUE
AND Price > 100;

-- Consulta para contar quantos produtos existem para cada marca
-- Esse tipo de consulta pode ajudar a entender a distribuição das marcas na base de dados.
SELECT Brand, COUNT(*) AS "Quantidade de Produtos"
FROM products
GROUP BY Brand;

-- Contando o número de produtos para cada tipo de pele (exibe o nome do tipo de pele)
SELECT 
    CASE 
        WHEN Combination = TRUE THEN 'Combination'
        WHEN Dry = TRUE THEN 'Dry'
        WHEN Normal = TRUE THEN 'Normal'
        WHEN Oily = TRUE THEN 'Oily'
        WHEN Sensitive = TRUE THEN 'Sensitive'
        ELSE 'Sem Tipo Específico'
    END AS Tipo_de_Pele,
    COUNT(*) AS "Quantidade de Produtos"
FROM products
GROUP BY 
    CASE 
        WHEN Combination = TRUE THEN 'Combination'
        WHEN Dry = TRUE THEN 'Dry'
        WHEN Normal = TRUE THEN 'Normal'
        WHEN Oily = TRUE THEN 'Oily'
        WHEN Sensitive = TRUE THEN 'Sensitive'
        ELSE 'Sem Tipo Específico'
    END;

-- Média de Rank por marca
SELECT Brand, AVG(Rank) AS "Média de Rank"
FROM products
GROUP BY Brand
ORDER BY "Média de Rank" DESC;

-- Produtos mais populares (maior Rank)
SELECT Name, Brand, Rank
FROM products
ORDER BY Rank DESC
LIMIT 10;

-- Produto com maior número de ingredientes
SELECT Name, Brand, LENGTH(Ingredients) - LENGTH(REPLACE(Ingredients, ',', '')) + 1 AS "Número de Ingredientes"
FROM products
ORDER BY "Número de Ingredientes" DESC
LIMIT 10;