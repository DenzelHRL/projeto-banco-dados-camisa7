# Estratégia de Otimização de Performance

## 1. Objetivo

A estratégia de otimização teve como objetivo melhorar o desempenho de uma consulta utilizada para localizar mensalidades atrasadas até determinada data de vencimento.

A consulta realiza filtros pelas colunas `status_mensalidade` e `data_vencimento`, além de ordenar os resultados pela data de vencimento.

## 2. Consulta analisada

```sql
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
```

Antes da otimização, foi utilizado o comando `EXPLAIN` para analisar a forma como o MySQL executava a consulta.

A evidência da execução antes da criação do índice está disponível no arquivo:

```text
evidencias/explain_antes.png
```

## 3. Índice criado

Como a consulta utiliza frequentemente as colunas `status_mensalidade` e `data_vencimento`, foi criado um índice composto:

```sql
CREATE INDEX idx_mensalidade_status_vencimento
ON mensalidade (
    status_mensalidade,
    data_vencimento
);
```

Após a criação do índice, foi executado o comando:

```sql
ANALYZE TABLE mensalidade;
```

Esse comando atualiza as estatísticas utilizadas pelo otimizador do MySQL na escolha do plano de execução.

## 4. Resultado após a otimização

O comando `EXPLAIN` foi executado novamente após a criação do índice.

A evidência da execução está disponível no arquivo:

```text
evidencias/explain_depois.png
```

O índice criado passou a estar disponível para o MySQL durante a execução da consulta, reduzindo a necessidade de examinar registros que não correspondem ao status e ao período pesquisados.

Como o banco utilizado neste projeto possui poucos registros, a diferença de tempo pode ser pequena. Entretanto, em um cenário com milhares de mensalidades, o índice tende a reduzir a quantidade de linhas analisadas e melhorar o tempo de resposta.

## 5. Conclusão

A criação do índice composto foi escolhida por estar diretamente relacionada às colunas utilizadas no filtro e na ordenação da consulta.

A comparação dos planos de execução antes e depois demonstra a utilização do `EXPLAIN` como ferramenta para identificar oportunidades de otimização.

A estratégia adotada foi mantida simples e adequada ao escopo acadêmico do projeto, sem realizar alterações avançadas na configuração do servidor MySQL.
