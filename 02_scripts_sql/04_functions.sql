
DELIMITER $$

-- FUNCTION 1: CALCULAR IDADE DO SÓCIO

CREATE FUNCTION fn_calcular_idade(
    p_data_nascimento DATE
)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    RETURN TIMESTAMPDIFF(
        YEAR,
        p_data_nascimento,
        CURDATE()
    );
END $$


-- FUNCTION 2: CALCULAR VALOR FINAL DO INGRESSO

CREATE FUNCTION fn_calcular_valor_ingresso(
    p_preco_base DECIMAL(10,2),
    p_percentual_desconto DECIMAL(5,2),
    p_checkin_gratuito BOOLEAN
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    IF p_checkin_gratuito = TRUE THEN
        RETURN 0.00;
    END IF;

    RETURN ROUND(
        p_preco_base -
        (p_preco_base * p_percentual_desconto / 100),
        2
    );
END $$


-- FUNCTION 3: CALCULAR TOTAL COM MULTA E JUROS
-- Regra utilizada:
-- multa de 2% e juros de 0,033% por dia de atraso


CREATE FUNCTION fn_calcular_total_atraso(
    p_valor_original DECIMAL(10,2),
    p_data_vencimento DATE,
    p_data_pagamento DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_dias_atraso INT DEFAULT 0;
    DECLARE v_multa DECIMAL(10,2) DEFAULT 0;
    DECLARE v_juros DECIMAL(10,2) DEFAULT 0;

    IF p_data_pagamento <= p_data_vencimento THEN
        RETURN p_valor_original;
    END IF;

    SET v_dias_atraso =
        DATEDIFF(p_data_pagamento, p_data_vencimento);

    SET v_multa =
        p_valor_original * 0.02;

    SET v_juros =
        p_valor_original * 0.00033 * v_dias_atraso;

    RETURN ROUND(
        p_valor_original + v_multa + v_juros,
        2
    );
END $$


-- FUNCTION 4: CONSULTAR SALDO DE PONTOS


CREATE FUNCTION fn_saldo_pontos(
    p_id_socio INT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_saldo INT DEFAULT 0;

    SELECT COALESCE(
        SUM(
            CASE
                WHEN tipo_movimentacao = 'CREDITO'
                    THEN quantidade
                WHEN tipo_movimentacao = 'DEBITO'
                    THEN -quantidade
            END
        ),
        0
    )
    INTO v_saldo
    FROM movimentacao_pontos
    WHERE id_socio = p_id_socio;

    RETURN v_saldo;
END $$


-- FUNCTION 5: CALCULAR VALOR ANUAL DO PLANO
-- Pagamento anual via PIX recebe desconto de 5%


CREATE FUNCTION fn_valor_plano_anual(
    p_valor_mensal DECIMAL(10,2),
    p_forma_pagamento VARCHAR(20)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_valor_anual DECIMAL(10,2);

    SET v_valor_anual = p_valor_mensal * 12;

    IF UPPER(p_forma_pagamento) = 'PIX' THEN
        SET v_valor_anual = v_valor_anual * 0.95;
    END IF;

    RETURN ROUND(v_valor_anual, 2);
END $$


DELIMITER ;


-- EXEMPLOS DE UTILIZAÇÃO

-- Exemplo 1: idade dos sócios

SELECT
    nome_completo,
    data_nascimento,
    fn_calcular_idade(data_nascimento) AS idade
FROM socio;


-- Exemplo 2: ingresso de R$ 100 com 70% de desconto

SELECT fn_calcular_valor_ingresso(
    100.00,
    70.00,
    FALSE
) AS valor_ingresso;


-- Exemplo 2.1: ingresso com check-in gratuito

SELECT fn_calcular_valor_ingresso(
    120.00,
    0.00,
    TRUE
) AS valor_ingresso_gratuito;


-- Exemplo 3: mensalidade paga com atraso

SELECT fn_calcular_total_atraso(
    79.90,
    '2026-05-20',
    '2026-06-18'
) AS total_com_atraso;


-- Exemplo 4: saldo de pontos de todos os sócios

SELECT
    s.id_socio,
    s.nome_completo,
    fn_saldo_pontos(s.id_socio) AS saldo_pontos
FROM socio s;


-- Exemplo 5: plano anual pago via PIX

SELECT
    nome,
    valor_mensal,
    fn_valor_plano_anual(
        valor_mensal,
        'PIX'
    ) AS valor_anual_pix
FROM plano;

