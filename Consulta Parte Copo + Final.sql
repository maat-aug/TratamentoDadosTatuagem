SELECT 
    f.ID,
    f.Genero,
    f.Idade,
    f.PossuiTatuagem,
    f.QuantasTatuagens,
    f.SeArrepende,
    ISNULL(tp.ParteCorpo, 'Não possui') AS ParteCorpo,
    f.PresenciouPreconceitoComTatuagens,
    f.Localidade
FROM dbo.PercepcoesSobreTatuagens_Final f
LEFT JOIN dbo.TatuagemParteCorpo tp 
    ON f.ID = tp.TatuagemID
ORDER BY f.ID;