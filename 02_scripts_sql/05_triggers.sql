DELIMITER $$

-- TRIGGER 1: REGISTRAR ALTERAÇÃO DA ASSINATURA

CREATE TRIGGER trg_historico_assinatura
AFTER UPDATE ON assinatura
FOR EACH ROW
BEGIN

    IF OLD.id_plano <> NEW.id_plano
       OR OLD.status_assinatura <> NEW.status_assinatura THEN

        INSERT INTO historico_assinatura (
            id_assinatura,
            id_plano_anterior,
            id_plano_novo,
            status_anterior,
            status_novo,
            data_alteracao,
            motivo
        )
        VALUES (
            NEW.id_assinatura,
            OLD.id_plano,
            NEW.id_plano,
            OLD.status_assinatura,
            NEW.status_assinatura,
            NOW(),
            'Alteração registrada automaticamente'
        );

    END IF;

END $$

-- TRIGGER 2: ATUALIZAR MENSALIDADE APÓS PAGAMENTO


CREATE TRIGGER trg_atualizar_mensalidade
AFTER INSERT ON pagamento
FOR EACH ROW
BEGIN

    IF NEW.status_pagamento = 'APROVADO' THEN

        UPDATE mensalidade
        SET status_mensalidade = 'PAGA'
        WHERE id_mensalidade = NEW.id_mensalidade;

    END IF;

END $$

-- TRIGGER 3: GERAR PONTOS APÓS PAGAMENTO
-- Regra: 1 ponto para cada real pago

CREATE TRIGGER trg_pontos_pagamento
AFTER INSERT ON pagamento
FOR EACH ROW
BEGIN

    DECLARE v_id_socio INT;

    IF NEW.status_pagamento = 'APROVADO' THEN

        SELECT a.id_socio
        INTO v_id_socio
        FROM mensalidade m
        INNER JOIN assinatura a
            ON m.id_assinatura = a.id_assinatura
        WHERE m.id_mensalidade = NEW.id_mensalidade;

        INSERT INTO movimentacao_pontos (
            id_socio,
            tipo_movimentacao,
            quantidade,
            origem,
            data_movimentacao,
            descricao
        )
        VALUES (
            v_id_socio,
            'CREDITO',
            ROUND(NEW.valor_pago),
            'PAGAMENTO',
            NOW(),
            'Pontos gerados por pagamento aprovado'
        );

    END IF;

END $$


-- TRIGGER 4: VALIDAR E REDUZIR INGRESSOS DISPONÍVEIS


CREATE TRIGGER trg_reservar_ingresso
BEFORE INSERT ON ingresso
FOR EACH ROW
BEGIN

    DECLARE v_quantidade_restante INT;

    SELECT quantidade_restante
    INTO v_quantidade_restante
    FROM setor_partida
    WHERE id_setor_partida = NEW.id_setor_partida;

    IF v_quantidade_restante <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não existem ingressos disponíveis neste setor';

    ELSEIF NEW.status_ingresso <> 'CANCELADO' THEN

        UPDATE setor_partida
        SET quantidade_restante = quantidade_restante - 1
        WHERE id_setor_partida = NEW.id_setor_partida;

    END IF;

END $$


-- TRIGGER 5: CONFIRMAR RESGATE DE EXPERIÊNCIA

CREATE TRIGGER trg_confirmar_resgate
AFTER INSERT ON resgate
FOR EACH ROW
BEGIN

    DECLARE v_saldo_pontos INT;
    DECLARE v_vagas_disponiveis INT;

    IF NEW.status_resgate = 'CONFIRMADO' THEN

        SET v_saldo_pontos =
            fn_saldo_pontos(NEW.id_socio);

        SELECT vagas_disponiveis
        INTO v_vagas_disponiveis
        FROM experiencia
        WHERE id_experiencia = NEW.id_experiencia;

        IF v_saldo_pontos < NEW.pontos_utilizados THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O sócio não possui pontos suficientes';

        ELSEIF v_vagas_disponiveis <= 0 THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A experiência não possui vagas disponíveis';

        ELSE

            INSERT INTO movimentacao_pontos (
                id_socio,
                tipo_movimentacao,
                quantidade,
                origem,
                data_movimentacao,
                descricao
            )
            VALUES (
                NEW.id_socio,
                'DEBITO',
                NEW.pontos_utilizados,
                'RESGATE',
                NOW(),
                'Pontos utilizados em resgate de experiência'
            );

            UPDATE experiencia
            SET vagas_disponiveis = vagas_disponiveis - 1
            WHERE id_experiencia = NEW.id_experiencia;

        END IF;

    END IF;

END $$


DELIMITER ;


-- EXEMPLO 1: TRIGGER DE HISTÓRICO DA ASSINATURA


START TRANSACTION;

UPDATE assinatura
SET id_plano = 3
WHERE id_assinatura = 4;

SELECT *
FROM historico_assinatura
WHERE id_assinatura = 4
ORDER BY id_historico DESC;

ROLLBACK;


-- EXEMPLOS 2 E 3:
-- ATUALIZAÇÃO DA MENSALIDADE E GERAÇÃO DE PONTOS


START TRANSACTION;

INSERT INTO mensalidade (
    id_assinatura,
    mes_referencia,
    data_vencimento,
    valor_original,
    multa,
    juros,
    valor_total,
    status_mensalidade
)
VALUES (
    4,
    '2026-07-01',
    '2026-07-05',
    37.90,
    0.00,
    0.00,
    37.90,
    'PENDENTE'
);

SET @id_mensalidade_teste = LAST_INSERT_ID();

INSERT INTO pagamento (
    id_mensalidade,
    data_pagamento,
    valor_pago,
    forma_pagamento,
    codigo_transacao,
    status_pagamento
)
VALUES (
    @id_mensalidade_teste,
    NOW(),
    37.90,
    'PIX',
    'TESTE-TRIGGER-PAGAMENTO',
    'APROVADO'
);

SELECT
    id_mensalidade,
    status_mensalidade
FROM mensalidade
WHERE id_mensalidade = @id_mensalidade_teste;

SELECT
    id_socio,
    tipo_movimentacao,
    quantidade,
    origem
FROM movimentacao_pontos
WHERE id_socio = 4
ORDER BY id_movimentacao DESC;

ROLLBACK;

-- EXEMPLO 4: REDUÇÃO DA DISPONIBILIDADE DO SETOR

START TRANSACTION;

SELECT
    id_setor_partida,
    quantidade_restante
FROM setor_partida
WHERE id_setor_partida = 4;

INSERT INTO ingresso (
    id_socio,
    id_setor_partida,
    tipo_ingresso,
    preco_original,
    percentual_desconto,
    valor_final,
    status_ingresso,
    codigo_validacao
)
VALUES (
    4,
    4,
    'TITULAR',
    100.00,
    50.00,
    50.00,
    'EMITIDO',
    'TESTE-TRIGGER-INGRESSO'
);

SELECT
    id_setor_partida,
    quantidade_restante
FROM setor_partida
WHERE id_setor_partida = 4;

ROLLBACK;


-- EXEMPLO 5: RESGATE DE EXPERIÊNCIA

START TRANSACTION;

SELECT
    id_socio,
    fn_saldo_pontos(id_socio) AS saldo_antes
FROM socio
WHERE id_socio = 3;

SELECT
    id_experiencia,
    vagas_disponiveis
FROM experiencia
WHERE id_experiencia = 1;

INSERT INTO resgate (
    id_socio,
    id_experiencia,
    pontos_utilizados,
    data_resgate,
    status_resgate
)
VALUES (
    3,
    1,
    200,
    NOW(),
    'CONFIRMADO'
);

SELECT
    id_socio,
    fn_saldo_pontos(id_socio) AS saldo_depois
FROM socio
WHERE id_socio = 3;

SELECT
    id_experiencia,
    vagas_disponiveis
FROM experiencia
WHERE id_experiencia = 1;

ROLLBACK;

