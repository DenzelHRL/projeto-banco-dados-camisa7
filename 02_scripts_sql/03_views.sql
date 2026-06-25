
USE camisa7_db;

-- VIEW 1: SÓCIOS ATIVOS E SEUS PLANOS

CREATE OR REPLACE VIEW vw_socios_ativos_planos AS
SELECT
    s.id_socio,
    s.nome_completo,
    s.email,
    p.nome AS plano,
    p.valor_mensal,
    a.tipo_cobranca,
    a.data_inicio,
    a.proxima_renovacao
FROM socio s
INNER JOIN assinatura a
    ON s.id_socio = a.id_socio
INNER JOIN plano p
    ON a.id_plano = p.id_plano
WHERE s.status_socio = 'ATIVO'
  AND a.status_assinatura = 'ATIVA';


-- Exemplo de utilização
SELECT *
FROM vw_socios_ativos_planos;


-- VIEW 2: SÓCIOS COM MENSALIDADES ATRASADAS


CREATE OR REPLACE VIEW vw_socios_inadimplentes AS
SELECT
    s.id_socio,
    s.nome_completo,
    s.email,
    p.nome AS plano,
    m.id_mensalidade,
    m.mes_referencia,
    m.data_vencimento,
    m.valor_total,
    DATEDIFF(CURRENT_DATE, m.data_vencimento) AS dias_atraso
FROM socio s
INNER JOIN assinatura a
    ON s.id_socio = a.id_socio
INNER JOIN plano p
    ON a.id_plano = p.id_plano
INNER JOIN mensalidade m
    ON a.id_assinatura = m.id_assinatura
WHERE m.status_mensalidade = 'ATRASADA';


-- Exemplo de utilização
SELECT *
FROM vw_socios_inadimplentes;


-- VIEW 3: RECEITA POR PLANO


CREATE OR REPLACE VIEW vw_receita_por_plano AS
SELECT
    p.id_plano,
    p.nome AS plano,
    COUNT(pg.id_pagamento) AS quantidade_pagamentos,
    SUM(pg.valor_pago) AS receita_total
FROM plano p
INNER JOIN assinatura a
    ON p.id_plano = a.id_plano
INNER JOIN mensalidade m
    ON a.id_assinatura = m.id_assinatura
INNER JOIN pagamento pg
    ON m.id_mensalidade = pg.id_mensalidade
WHERE pg.status_pagamento = 'APROVADO'
GROUP BY
    p.id_plano,
    p.nome;


-- Exemplo de utilização
SELECT *
FROM vw_receita_por_plano;


-- VIEW 4: OCUPAÇÃO DAS PARTIDAS

CREATE OR REPLACE VIEW vw_ocupacao_partidas AS
SELECT
    p.id_partida,
    p.competicao,
    p.adversario,
    p.data_hora,
    e.nome AS estadio,
    SUM(sp.quantidade_disponivel) AS ingressos_disponibilizados,
    SUM(sp.quantidade_disponivel - sp.quantidade_restante)
        AS ingressos_emitidos,
    SUM(sp.quantidade_restante) AS ingressos_restantes,
    ROUND(
        (
            SUM(sp.quantidade_disponivel - sp.quantidade_restante)
            / SUM(sp.quantidade_disponivel)
        ) * 100,
        2
    ) AS percentual_ocupacao
FROM partida p
INNER JOIN estadio e
    ON p.id_estadio = e.id_estadio
INNER JOIN setor_partida sp
    ON p.id_partida = sp.id_partida
GROUP BY
    p.id_partida,
    p.competicao,
    p.adversario,
    p.data_hora,
    e.nome;


-- Exemplo de utilização
SELECT *
FROM vw_ocupacao_partidas;


-- VIEW 5: RESGATES DE EXPERIÊNCIAS

CREATE OR REPLACE VIEW vw_resgates_experiencias AS
SELECT
    r.id_resgate,
    s.nome_completo AS socio,
    e.nome AS experiencia,
    r.pontos_utilizados,
    r.data_resgate,
    r.status_resgate,
    e.data_experiencia
FROM resgate r
INNER JOIN socio s
    ON r.id_socio = s.id_socio
INNER JOIN experiencia e
    ON r.id_experiencia = e.id_experiencia;



