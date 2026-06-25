USE camisa7_db;

-- CONSULTA ANALISADA
-- Busca mensalidades atrasadas por data de vencimento

-- 1. ANTES DA OTIMIZAÇÃO
-- Execute este EXPLAIN antes de criar o índice

EXPLAIN
SELECT
    id_mensalidade,
    id_assinatura,
    data_vencimento,
    valor_total,
    status_mensalidade
FROM mensalidade
WHERE status_mensalidade = 'ATRASADA'
  AND data_vencimento <= '2026-06-30'
ORDER BY data_vencimento;


-- Consulta normal

SELECT
    id_mensalidade,
    id_assinatura,
    data_vencimento,
    valor_total,
    status_mensalidade
FROM mensalidade
WHERE status_mensalidade = 'ATRASADA'
  AND data_vencimento <= '2026-06-30'
ORDER BY data_vencimento;


-- 2. CRIAÇÃO DO ÍNDICE


CREATE INDEX idx_mensalidade_status_vencimento
ON mensalidade (
    status_mensalidade,
    data_vencimento
);

ANALYZE TABLE mensalidade;

-- 3. DEPOIS DA OTIMIZAÇÃO
-- Execute este EXPLAIN após criar o índice

EXPLAIN
SELECT
    id_mensalidade,
    id_assinatura,
    data_vencimento,
    valor_total,
    status_mensalidade
FROM mensalidade
WHERE status_mensalidade = 'ATRASADA'
  AND data_vencimento <= '2026-06-30'
ORDER BY data_vencimento;


-- Verificação do índice criado

SHOW INDEX
FROM mensalidade;

