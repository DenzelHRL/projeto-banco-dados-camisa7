-- Script de criação do banco de dados e das tabelas
```sql


DROP DATABASE IF EXISTS camisa7_db;

CREATE DATABASE camisa7_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE camisa7_db;

-- =====================================================
-- 1. TABELA SOCIO
-- =====================================================

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
        ON DELETE SET NULL,

    CONSTRAINT chk_socio_responsavel
        CHECK (
            id_responsavel IS NULL
            OR id_responsavel <> id_socio
        )
);

-- =====================================================
-- 2. TABELA PLANO
-- =====================================================

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

-- =====================================================
-- 3. TABELA BENEFICIO
-- =====================================================

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

-- =====================================================
-- 4. TABELA PLANO_BENEFICIO
-- =====================================================

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
```
