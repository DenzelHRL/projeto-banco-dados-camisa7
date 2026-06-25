# Modelagem Data Warehouse

## 1. Objetivo

O Data Warehouse proposto terá como objetivo apoiar análises gerenciais sobre os pagamentos realizados pelos participantes do programa de sócio-torcedor.

O banco operacional continuará sendo responsável pelos cadastros e pelas operações diárias. O Data Warehouse será utilizado principalmente para consultas históricas, agrupamentos e identificação de tendências.

Para manter a proposta simples e adequada ao escopo do projeto, o Data Warehouse terá como foco principal a análise financeira dos pagamentos.

## 2. Modelo adotado

Será utilizado o modelo estrela, formado por uma tabela fato central relacionada diretamente às tabelas de dimensão.

A tabela fato armazenará os eventos de pagamento e suas métricas. As dimensões armazenarão os dados descritivos utilizados nos filtros e agrupamentos.

A estrutura será composta por:

* uma tabela fato;
* quatro tabelas dimensão.

## 3. Estrutura proposta

### Tabela fato: `fato_pagamento`

Cada registro representará um pagamento realizado no programa.

Campos sugeridos:

```text
id_fato_pagamento
id_tempo
id_socio
id_plano
id_tipo_pagamento
valor_pago
quantidade_pagamento
```

Métricas:

* `valor_pago`: valor financeiro do pagamento;
* `quantidade_pagamento`: valor fixo igual a 1, utilizado para contagens.

### Dimensão: `dim_tempo`

Permitirá análises por períodos.

Campos sugeridos:

```text
id_tempo
data_completa
dia
mes
nome_mes
trimestre
ano
```

### Dimensão: `dim_socio`

Armazenará as informações descritivas do associado.

Campos sugeridos:

```text
id_socio_dw
id_socio_origem
nome_socio
cidade
estado
pais
status_socio
```

Os dados de localização permanecerão na mesma dimensão para simplificar as consultas.

### Dimensão: `dim_plano`

Armazenará as informações do plano existente no momento do pagamento.

Campos sugeridos:

```text
id_plano_dw
id_plano_origem
nome_plano
valor_mensal
prioridade_ingresso
checkin_gratuito
status_plano
```

### Dimensão: `dim_tipo_pagamento`

Armazenará as características relacionadas ao pagamento.

Campos sugeridos:

```text
id_tipo_pagamento
forma_pagamento
status_pagamento
```

Exemplos de formas de pagamento:

* PIX;
* cartão de crédito;
* cartão de débito;
* boleto.

Exemplos de situações:

* aprovado;
* recusado;
* cancelado.

## 4. Representação do modelo estrela

```text
                         DIM_TEMPO
                             |
                             |
DIM_SOCIO -------- FATO_PAGAMENTO -------- DIM_PLANO
                             |
                             |
                 DIM_TIPO_PAGAMENTO
```

A tabela `fato_pagamento` ficará no centro do modelo e possuirá chaves estrangeiras para as quatro dimensões.

## 5. Origem dos dados

Os dados serão extraídos das tabelas do banco operacional:

```text
pagamento
    ↓
mensalidade
    ↓
assinatura
    ↓
socio e plano
```

A tabela `pagamento` fornecerá:

* valor pago;
* data do pagamento;
* forma de pagamento;
* situação do pagamento.

A tabela `mensalidade` permitirá identificar a assinatura relacionada ao pagamento.

A tabela `assinatura` permitirá encontrar o sócio e o plano correspondentes.

As tabelas `socio` e `plano` fornecerão os dados descritivos das dimensões.

## 6. Cinco tipos de consultas suportadas

### Consulta 1 — Receita total por mês

Objetivo: acompanhar a evolução da arrecadação durante o ano.

```sql
SELECT
    t.ano,
    t.mes,
    t.nome_mes,
    SUM(f.valor_pago) AS receita_total
FROM fato_pagamento f
INNER JOIN dim_tempo t
    ON f.id_tempo = t.id_tempo
INNER JOIN dim_tipo_pagamento tp
    ON f.id_tipo_pagamento = tp.id_tipo_pagamento
WHERE tp.status_pagamento = 'APROVADO'
GROUP BY
    t.ano,
    t.mes,
    t.nome_mes
ORDER BY
    t.ano,
    t.mes;
```

### Consulta 2 — Receita total por plano

Objetivo: identificar quais planos geram maior arrecadação.

```sql
SELECT
    p.nome_plano,
    SUM(f.valor_pago) AS receita_total
FROM fato_pagamento f
INNER JOIN dim_plano p
    ON f.id_plano = p.id_plano_dw
INNER JOIN dim_tipo_pagamento tp
    ON f.id_tipo_pagamento = tp.id_tipo_pagamento
WHERE tp.status_pagamento = 'APROVADO'
GROUP BY
    p.nome_plano
ORDER BY
    receita_total DESC;
```

### Consulta 3 — Quantidade de pagamentos por forma de pagamento

Objetivo: identificar as formas de pagamento mais utilizadas.

```sql
SELECT
    tp.forma_pagamento,
    SUM(f.quantidade_pagamento) AS quantidade_pagamentos
FROM fato_pagamento f
INNER JOIN dim_tipo_pagamento tp
    ON f.id_tipo_pagamento = tp.id_tipo_pagamento
GROUP BY
    tp.forma_pagamento
ORDER BY
    quantidade_pagamentos DESC;
```

### Consulta 4 — Receita por estado dos associados

Objetivo: verificar a origem geográfica da arrecadação.

```sql
SELECT
    s.estado,
    SUM(f.valor_pago) AS receita_total
FROM fato_pagamento f
INNER JOIN dim_socio s
    ON f.id_socio = s.id_socio_dw
INNER JOIN dim_tipo_pagamento tp
    ON f.id_tipo_pagamento = tp.id_tipo_pagamento
WHERE tp.status_pagamento = 'APROVADO'
GROUP BY
    s.estado
ORDER BY
    receita_total DESC;
```

### Consulta 5 — Pagamentos aprovados e recusados por período

Objetivo: analisar a quantidade de pagamentos conforme a situação.

```sql
SELECT
    t.ano,
    t.mes,
    tp.status_pagamento,
    SUM(f.quantidade_pagamento) AS quantidade_pagamentos
FROM fato_pagamento f
INNER JOIN dim_tempo t
    ON f.id_tempo = t.id_tempo
INNER JOIN dim_tipo_pagamento tp
    ON f.id_tipo_pagamento = tp.id_tipo_pagamento
GROUP BY
    t.ano,
    t.mes,
    tp.status_pagamento
ORDER BY
    t.ano,
    t.mes,
    tp.status_pagamento;
```

## 7. Benefícios da modelagem

A modelagem proposta reduz a quantidade de relacionamentos necessários nas consultas analíticas.

No banco operacional, uma consulta de receita precisa relacionar pagamentos, mensalidades, assinaturas, sócios e planos.

No Data Warehouse, as informações estarão organizadas em uma tabela fato e quatro dimensões, facilitando consultas com `SUM`, `COUNT`, `GROUP BY` e filtros por período, plano, associado ou forma de pagamento.

O modelo também separa as consultas analíticas das operações realizadas diariamente no banco de dados principal.

##
