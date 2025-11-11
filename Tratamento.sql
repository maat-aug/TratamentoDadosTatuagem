CREATE TABLE dbo.PercepcoesSobreTatuagens_Final (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data DATE,
    Idade INT,
    Genero NVARCHAR(5),
    Escolaridade NVARCHAR(150),
    Cargo NVARCHAR(200),
    ClasseSocial NVARCHAR(100),
    PossuiTatuagem BIT,
    QuantasTatuagens NVARCHAR(20),
    SeArrepende BIT,
    InfluenciaImagemProfissional INT,
    SentiriaConfortavelSendoAtendidoPorAlguemComTatuagens INT,
    TatuagensAssociadasComComportamentosNegativos FLOAT,
    ContratariaComTatuagensVisiveis INT,
    TatuagensSofremPreconceito INT,
    PresenciouPreconceitoComTatuagens INT,
    Localidade NVARCHAR(100),
    ParteCorpo NVARCHAR(300)
);
GO


/* =====================================================
   INSERE DADOS TRATADOS
   ===================================================== */
INSERT INTO dbo.PercepcoesSobreTatuagens_Final (
    Data, 
	Idade, 
	Genero, 
	Escolaridade, 
	Cargo, 
	ClasseSocial,
    PossuiTatuagem,
	QuantasTatuagens, 
	SeArrepende,
    InfluenciaImagemProfissional, 
	SentiriaConfortavelSendoAtendidoPorAlguemComTatuagens,
    TatuagensAssociadasComComportamentosNegativos,
    ContratariaComTatuagensVisiveis, 
	TatuagensSofremPreconceito,
    PresenciouPreconceitoComTatuagens, 
	Localidade, 
	ParteCorpo
)
SELECT
    TRY_CONVERT(DATE, LEFT([Data], 10)) AS Data,

    -- IDADE
    TRY_CAST(
        CASE
            WHEN Idade LIKE '%[0-9]%' THEN
                TRY_CAST(SUBSTRING(Idade, PATINDEX('%[0-9]%', Idade), 2) AS INT)
            ELSE NULL
        END AS INT
    ) AS Idade,

    -- GÊNERO (M, F, O, N/A)
    CASE
        WHEN LOWER(LTRIM(RTRIM(Genero))) LIKE 'f%' THEN 'F'
        WHEN LOWER(LTRIM(RTRIM(Genero))) LIKE 'm%' THEN 'M'
        WHEN LOWER(LTRIM(RTRIM(Genero))) LIKE 'o%' THEN 'O'
        WHEN Genero IS NULL OR LTRIM(RTRIM(Genero)) = '' THEN 'N/A'
        ELSE 'N/A'
    END AS Genero,

	-- ESCOLARIDADE
    CASE
        WHEN Escolaridade LIKE '%fundamental%' THEN 'Ensino Fundamental'
        WHEN Escolaridade LIKE '%médio%' THEN 'Ensino Médio'
        WHEN Escolaridade LIKE '%superior incompleto%' THEN 'Ensino Superior Incompleto'
        WHEN Escolaridade LIKE '%superior completo%' THEN 'Ensino Superior Completo'
        WHEN Escolaridade LIKE '%pós%' THEN 'Pós-graduação'
        WHEN Escolaridade LIKE '%mestrado%' THEN 'Mestrado'
        WHEN Escolaridade LIKE '%doutorado%' THEN 'Doutorado'
        ELSE 'Não informado'
    END AS Escolaridade,

    LTRIM(RTRIM(Cargo)) AS Cargo, -- CARGO

	-- CLASSE SOCIAL
    CASE
        WHEN ClasseSocial LIKE '%Classe A%' THEN 'Classe A (Acima de R$ 25.000)'
        WHEN ClasseSocial LIKE '%Classe B%' THEN 'Classe B (De R$ 8.000 a R$ 25.000)'
        WHEN ClasseSocial LIKE '%Classe C%' THEN 'Classe C (De R$ 3.000 a R$ 8.000)'
        WHEN ClasseSocial LIKE '%Classe D%' THEN 'Classe D (De R$ 1.000 a R$ 3.000)'
        WHEN ClasseSocial LIKE '%Classe E%' THEN 'Classe E (Até R$ 1.000)'
        ELSE 'Não informado'
    END AS ClasseSocial,

    -- POSSUI TATUAGEM
    CASE 
        WHEN LOWER(PossuiTatuagem) LIKE 's%' THEN 1
        WHEN LOWER(PossuiTatuagem) LIKE 'n%' THEN 0
        WHEN PossuiTatuagem IS NULL THEN 0
        ELSE 0
    END AS PossuiTatuagem,

    -- QUANTAS TATUAGENS
    CASE
        WHEN LOWER(PossuiTatuagem) LIKE 's%' THEN
            CASE
                WHEN LOWER(QuantasTatuagens) LIKE '%1%' THEN '1'
                WHEN LOWER(QuantasTatuagens) LIKE '%2 a 5%' THEN '2-5'
                WHEN LOWER(QuantasTatuagens) LIKE '%6 a 10%' THEN '6-10'
                WHEN LOWER(QuantasTatuagens) LIKE '%mais%' OR LOWER(QuantasTatuagens) LIKE '%acima%' THEN '10+'
                ELSE '1'
            END
        ELSE '0'
    END AS QuantasTatuagens,

    -- SE ARREPENDE
    CASE 
        WHEN LOWER(PossuiTatuagem) LIKE 's%' THEN 
            CASE 
                WHEN LOWER(SeArrepende) LIKE 's%' THEN 1
                WHEN LOWER(SeArrepende) LIKE 'n%' THEN 0
                ELSE NULL
            END
        ELSE NULL
    END AS SeArrepende,

    TRY_CAST(InfluenciaImagemProfissional AS INT),
    TRY_CAST(SentiriaConfortavelSendoAtendidoPorAlguemComTatuagens AS INT),
    TRY_CAST(TatuagensAssociadasComComportamentosNegativos AS FLOAT),
    TRY_CAST(ContratariaComTatuagensVisiveis AS INT),
    TRY_CAST(TatuagensSofremPreconceito AS INT),

    --  PRESENCIOU PRECONCEITO
    CASE
        WHEN TRY_CAST(PresenciouPreconceitoComTatuagens AS INT) BETWEEN 1 AND 5 
            THEN TRY_CAST(PresenciouPreconceitoComTatuagens AS INT)
        WHEN LOWER(PresenciouPreconceitoComTatuagens) LIKE 's%' THEN 5
        WHEN LOWER(PresenciouPreconceitoComTatuagens) LIKE 'n%' THEN 1
        ELSE NULL
    END AS PresenciouPreconceitoComTatuagens,

    ISNULL(Localidade, 'Não informado'),

    -- PARTE DO CORPO
    CASE
        WHEN LOWER(PossuiTatuagem) LIKE 'n%' OR PossuiTatuagem IS NULL THEN 'Não possui'
        WHEN ParteCorpo IS NULL OR LTRIM(RTRIM(ParteCorpo)) = '' THEN 'Não informado'
        ELSE ParteCorpo
    END AS ParteCorpo
FROM dbo.PercepcoesSobreTatuagens;
GO


/* =====================================================
   TABELA AUXILIAR DE PARTES DO CORPO
   ===================================================== */
IF OBJECT_ID('dbo.TatuagemParteCorpo', 'U') IS NOT NULL
    DROP TABLE dbo.TatuagemParteCorpo;
GO

CREATE TABLE dbo.TatuagemParteCorpo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TatuagemID INT NOT NULL,
    ParteCorpo NVARCHAR(100) NOT NULL,
    FOREIGN KEY (TatuagemID) REFERENCES dbo.PercepcoesSobreTatuagens_Final(ID)
);
GO

-- Popula partes multivaloradas
INSERT INTO dbo.TatuagemParteCorpo (TatuagemID, ParteCorpo)
SELECT 
    f.ID,
    LTRIM(RTRIM(value)) AS ParteCorpo
FROM dbo.PercepcoesSobreTatuagens_Final f
CROSS APPLY STRING_SPLIT(f.ParteCorpo, ';')
WHERE f.PossuiTatuagem = 1
  AND LTRIM(RTRIM(value)) <> ''
  AND LTRIM(RTRIM(value)) NOT IN ('Não possui', 'Não informado');
GO
