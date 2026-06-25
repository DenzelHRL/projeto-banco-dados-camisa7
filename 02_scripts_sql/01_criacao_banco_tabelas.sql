-- Script de criação do banco de dados e das tabelas
```sql


DROP DATABASE IF EXISTS camisa7_db;

CREATE DATABASE camisa7_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE camisa7_db;

-- 1. TABELA SOCIO
CREATE TABLE socio (
    id_socio INT AUTO_INCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    cep VARCHAR(9),
    logradouro VARCHAR(150),
    numero VARCHAR(10),
    complemento VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2),
    pais VARCHAR(80) NOT NULL DEFAULT 'Brasil',
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_socio ENUM('ATIVO', 'SUSPENSO', 'CANCELADO')
        NOT NULL DEFAULT 'ATIVO',
    id_responsavel INT,

    CONSTRAINT pk_socio
        PRIMARY KEY (id_socio),

    CONSTRAINT uq_socio_cpf
        UNIQUE (cpf),

    CONSTRAINT uq_socio_email
        UNIQUE (email),

    CONSTRAINT fk_socio_responsavel
    FOREIGN KEY (id_responsavel)
    REFERENCES socio (id_socio)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);


-- 2. TABELA PLANO

CREATE TABLE plano (
    id_plano INT AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255),
    valor_mensal DECIMAL(10,2) NOT NULL,
    prioridade_ingresso TINYINT NOT NULL,
    percentual_desconto DECIMAL(5,2) NOT NULL DEFAULT 0,
    limite_acompanhantes TINYINT UNSIGNED NOT NULL DEFAULT 0,
    idade_minima TINYINT UNSIGNED,
    idade_maxima TINYINT UNSIGNED,
    checkin_gratuito BOOLEAN NOT NULL DEFAULT FALSE,
    status_plano ENUM('ATIVO', 'INATIVO')
        NOT NULL DEFAULT 'ATIVO',

    CONSTRAINT pk_plano
        PRIMARY KEY (id_plano),

    CONSTRAINT uq_plano_nome
        UNIQUE (nome),

    CONSTRAINT chk_plano_valor
        CHECK (valor_mensal >= 0),

    CONSTRAINT chk_plano_prioridade
        CHECK (prioridade_ingresso BETWEEN 1 AND 5),

    CONSTRAINT chk_plano_desconto
        CHECK (percentual_desconto BETWEEN 0 AND 100),

    CONSTRAINT chk_plano_idades
        CHECK (
            idade_maxima IS NULL
            OR idade_minima IS NULL
            OR idade_maxima >= idade_minima
        )
);

-- 3. TABELA BENEFICIO

CREATE TABLE beneficio (
    id_beneficio INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    tipo ENUM(
        'DESCONTO',
        'EXPERIENCIA',
        'PARCEIRO',
        'OUTRO'
    ) NOT NULL,
    percentual_desconto DECIMAL(5,2),
    status_beneficio ENUM('ATIVO', 'INATIVO')
        NOT NULL DEFAULT 'ATIVO',

    CONSTRAINT pk_beneficio
        PRIMARY KEY (id_beneficio),

    CONSTRAINT uq_beneficio_nome
        UNIQUE (nome),

    CONSTRAINT chk_beneficio_desconto
        CHECK (
            percentual_desconto IS NULL
            OR percentual_desconto BETWEEN 0 AND 100
        )
);


-- 4. TABELA PLANO_BENEFICIO

CREATE TABLE plano_beneficio (
    id_plano INT NOT NULL,
    id_beneficio INT NOT NULL,
    detalhes VARCHAR(255),

    CONSTRAINT pk_plano_beneficio
        PRIMARY KEY (id_plano, id_beneficio),

    CONSTRAINT fk_plano_beneficio_plano
        FOREIGN KEY (id_plano)
        REFERENCES plano (id_plano)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_plano_beneficio_beneficio
        FOREIGN KEY (id_beneficio)
        REFERENCES beneficio (id_beneficio)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);



-- 5. TABELA ASSINATURA


CREATE TABLE assinatura (
    id_assinatura INT AUTO_INCREMENT,
    id_socio INT NOT NULL,
    id_plano INT NOT NULL,
    data_inicio DATE NOT NULL,
    proxima_renovacao DATE,
    tipo_cobranca ENUM('MENSAL', 'ANUAL') NOT NULL,
    renovacao_automatica BOOLEAN NOT NULL DEFAULT TRUE,
    status_assinatura ENUM(
        'ATIVA',
        'PENDENTE',
        'SUSPENSA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'PENDENTE',

    CONSTRAINT pk_assinatura
        PRIMARY KEY (id_assinatura),

    CONSTRAINT uq_assinatura_socio
        UNIQUE (id_socio),

    CONSTRAINT fk_assinatura_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_assinatura_plano
        FOREIGN KEY (id_plano)
        REFERENCES plano (id_plano)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 6. TABELA HISTORICO_ASSINATURA

CREATE TABLE historico_assinatura (
    id_historico INT AUTO_INCREMENT,
    id_assinatura INT NOT NULL,
    id_plano_anterior INT,
    id_plano_novo INT,
    status_anterior ENUM(
        'ATIVA',
        'PENDENTE',
        'SUSPENSA',
        'CANCELADA'
    ),
    status_novo ENUM(
        'ATIVA',
        'PENDENTE',
        'SUSPENSA',
        'CANCELADA'
    ),
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(255),

    CONSTRAINT pk_historico_assinatura
        PRIMARY KEY (id_historico),

    CONSTRAINT fk_historico_assinatura
        FOREIGN KEY (id_assinatura)
        REFERENCES assinatura (id_assinatura)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_historico_plano_anterior
        FOREIGN KEY (id_plano_anterior)
        REFERENCES plano (id_plano)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_historico_plano_novo
        FOREIGN KEY (id_plano_novo)
        REFERENCES plano (id_plano)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 7. TABELA MENSALIDADE


CREATE TABLE mensalidade (
    id_mensalidade INT AUTO_INCREMENT,
    id_assinatura INT NOT NULL,
    mes_referencia DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    valor_original DECIMAL(10,2) NOT NULL,
    multa DECIMAL(10,2) NOT NULL DEFAULT 0,
    juros DECIMAL(10,2) NOT NULL DEFAULT 0,
    valor_total DECIMAL(10,2) NOT NULL,
    status_mensalidade ENUM(
        'PENDENTE',
        'PAGA',
        'ATRASADA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'PENDENTE',

    CONSTRAINT pk_mensalidade
        PRIMARY KEY (id_mensalidade),

    CONSTRAINT uq_mensalidade_referencia
        UNIQUE (id_assinatura, mes_referencia),

    CONSTRAINT fk_mensalidade_assinatura
        FOREIGN KEY (id_assinatura)
        REFERENCES assinatura (id_assinatura)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_mensalidade_valores
        CHECK (
            valor_original >= 0
            AND multa >= 0
            AND juros >= 0
            AND valor_total >= 0
        )
);


-- 8. TABELA PAGAMENTO


CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT,
    id_mensalidade INT NOT NULL,
    data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_pago DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM(
        'PIX',
        'CARTAO_CREDITO',
        'CARTAO_DEBITO',
        'BOLETO'
    ) NOT NULL,
    codigo_transacao VARCHAR(100) NOT NULL,
    status_pagamento ENUM(
        'APROVADO',
        'RECUSADO',
        'CANCELADO'
    ) NOT NULL,

    CONSTRAINT pk_pagamento
        PRIMARY KEY (id_pagamento),

    CONSTRAINT uq_pagamento_transacao
        UNIQUE (codigo_transacao),

    CONSTRAINT fk_pagamento_mensalidade
        FOREIGN KEY (id_mensalidade)
        REFERENCES mensalidade (id_mensalidade)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_pagamento_valor
        CHECK (valor_pago > 0)
);



-- 9. TABELA ESTADIO


CREATE TABLE estadio (
    id_estadio INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2),
    capacidade_total INT UNSIGNED NOT NULL,

    CONSTRAINT pk_estadio
        PRIMARY KEY (id_estadio),

    CONSTRAINT uq_estadio_nome
        UNIQUE (nome),

    CONSTRAINT chk_estadio_capacidade
        CHECK (capacidade_total > 0)
);


-- 10. TABELA SETOR


CREATE TABLE setor (
    id_setor INT AUTO_INCREMENT,
    id_estadio INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    capacidade INT UNSIGNED NOT NULL,
    descricao VARCHAR(255),

    CONSTRAINT pk_setor
        PRIMARY KEY (id_setor),

    CONSTRAINT uq_setor_estadio
        UNIQUE (id_estadio, nome),

    CONSTRAINT fk_setor_estadio
        FOREIGN KEY (id_estadio)
        REFERENCES estadio (id_estadio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_setor_capacidade
        CHECK (capacidade > 0)
);


-- 11. TABELA PARTIDA


CREATE TABLE partida (
    id_partida INT AUTO_INCREMENT,
    competicao VARCHAR(100) NOT NULL,
    adversario VARCHAR(100) NOT NULL,
    data_hora DATETIME NOT NULL,
    id_estadio INT NOT NULL,
    mando ENUM('MANDANTE', 'VISITANTE') NOT NULL,
    status_partida ENUM(
        'AGENDADA',
        'INGRESSOS_ABERTOS',
        'ENCERRADA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'AGENDADA',

    CONSTRAINT pk_partida
        PRIMARY KEY (id_partida),

    CONSTRAINT fk_partida_estadio
        FOREIGN KEY (id_estadio)
        REFERENCES estadio (id_estadio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 12. TABELA SETOR_PARTIDA


CREATE TABLE setor_partida (
    id_setor_partida INT AUTO_INCREMENT,
    id_partida INT NOT NULL,
    id_setor INT NOT NULL,
    preco_base DECIMAL(10,2) NOT NULL,
    quantidade_disponivel INT UNSIGNED NOT NULL,
    quantidade_restante INT UNSIGNED NOT NULL,

    CONSTRAINT pk_setor_partida
        PRIMARY KEY (id_setor_partida),

    CONSTRAINT uq_setor_partida
        UNIQUE (id_partida, id_setor),

    CONSTRAINT fk_setor_partida_partida
        FOREIGN KEY (id_partida)
        REFERENCES partida (id_partida)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_setor_partida_setor
        FOREIGN KEY (id_setor)
        REFERENCES setor (id_setor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_setor_partida_preco
        CHECK (preco_base >= 0),

    CONSTRAINT chk_setor_partida_quantidade
        CHECK (
            quantidade_restante <= quantidade_disponivel
        )
);


-- 13. TABELA INGRESSO


CREATE TABLE ingresso (
    id_ingresso INT AUTO_INCREMENT,
    id_socio INT NOT NULL,
    id_setor_partida INT NOT NULL,
    tipo_ingresso ENUM(
        'TITULAR',
        'ACOMPANHANTE',
        'INFANTIL',
        'CORTESIA'
    ) NOT NULL,
    preco_original DECIMAL(10,2) NOT NULL,
    percentual_desconto DECIMAL(5,2) NOT NULL DEFAULT 0,
    valor_final DECIMAL(10,2) NOT NULL,
    status_ingresso ENUM(
        'EMITIDO',
        'UTILIZADO',
        'CANCELADO'
    ) NOT NULL DEFAULT 'EMITIDO',
    data_emissao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_checkin DATETIME,
    data_entrada DATETIME,
    codigo_validacao VARCHAR(100) NOT NULL,

    CONSTRAINT pk_ingresso
        PRIMARY KEY (id_ingresso),

    CONSTRAINT uq_ingresso_codigo
        UNIQUE (codigo_validacao),

    CONSTRAINT fk_ingresso_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_ingresso_setor_partida
        FOREIGN KEY (id_setor_partida)
        REFERENCES setor_partida (id_setor_partida)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_ingresso_valores
        CHECK (
            preco_original >= 0
            AND percentual_desconto BETWEEN 0 AND 100
            AND valor_final >= 0
        )
);



-- 14. TABELA MOVIMENTACAO_PONTOS


CREATE TABLE movimentacao_pontos (
    id_movimentacao INT AUTO_INCREMENT,
    id_socio INT NOT NULL,
    tipo_movimentacao ENUM('CREDITO', 'DEBITO') NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    origem ENUM(
        'PAGAMENTO',
        'PRESENCA_PARTIDA',
        'PROMOCAO',
        'RESGATE',
        'ESTORNO',
        'OUTRO'
    ) NOT NULL,
    data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao VARCHAR(255),

    CONSTRAINT pk_movimentacao_pontos
        PRIMARY KEY (id_movimentacao),

    CONSTRAINT fk_movimentacao_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_movimentacao_quantidade
        CHECK (quantidade > 0)
);



-- 15. TABELA EXPERIENCIA


CREATE TABLE experiencia (
    id_experiencia INT AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    descricao VARCHAR(255),
    pontos_necessarios INT UNSIGNED NOT NULL,
    quantidade_vagas INT UNSIGNED NOT NULL,
    vagas_disponiveis INT UNSIGNED NOT NULL,
    data_experiencia DATETIME,
    status_experiencia ENUM(
        'ATIVA',
        'ENCERRADA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'ATIVA',

    CONSTRAINT pk_experiencia
        PRIMARY KEY (id_experiencia),

    CONSTRAINT chk_experiencia_pontos
        CHECK (pontos_necessarios > 0),

    CONSTRAINT chk_experiencia_vagas
        CHECK (
            vagas_disponiveis <= quantidade_vagas
        )
);


-- 16. TABELA RESGATE

CREATE TABLE resgate (
    id_resgate INT AUTO_INCREMENT,
    id_socio INT NOT NULL,
    id_experiencia INT NOT NULL,
    pontos_utilizados INT UNSIGNED NOT NULL,
    data_resgate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_resgate ENUM(
        'PENDENTE',
        'CONFIRMADO',
        'CANCELADO'
    ) NOT NULL DEFAULT 'PENDENTE',

    CONSTRAINT pk_resgate
        PRIMARY KEY (id_resgate),

    CONSTRAINT fk_resgate_socio
        FOREIGN KEY (id_socio)
        REFERENCES socio (id_socio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_resgate_experiencia
        FOREIGN KEY (id_experiencia)
        REFERENCES experiencia (id_experiencia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_resgate_pontos
        CHECK (pontos_utilizados > 0)
);

