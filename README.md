# Projeto de Banco de Dados — Camisa 7

Projeto acadêmico desenvolvido para a disciplina de Banco de Dados II.

O projeto apresenta um sistema de gerenciamento de sócios-torcedores inspirado no programa Camisa 7, do Botafogo de Futebol e Regatas.

Todos os dados utilizados são fictícios e o sistema foi desenvolvido exclusivamente para fins acadêmicos.

## Objetivo

O banco de dados permite gerenciar:

* sócios-torcedores;
* planos e benefícios;
* assinaturas;
* mensalidades e pagamentos;
* partidas e ingressos;
* pontos;
* experiências e resgates.

## Tecnologia utilizada

* MySQL;
* MySQL Workbench;
* GitHub;
* linguagem SQL.

## Estrutura do repositório

```text
projeto-banco-dados-camisa7/
│
├── 01_minimundo/
│   └── minimundo.md
│
├── 02_scripts_sql/
│   ├── 01_criacao_banco_tabelas.sql
│   ├── 02_insercao_dados.sql
│   ├── 03_views.sql
│   ├── 04_functions.sql
│   ├── 05_triggers.sql
│   └── 06_otimizacao.sql
│
├── 03_otimizacao/
│   ├── relatorio_otimizacao.md
│   └── evidencias/
│       ├── explain_antes.png
│       └── explain_depois.png
│
├── 04_backup_seguranca/
│   └── estrategia_backup_seguranca.md
│
├── 05_data_warehouse/
│   └── modelagem_dw.md
│
└── README.md
```

## Ordem de execução dos scripts

Os scripts devem ser executados no MySQL Workbench na seguinte ordem:

1. `01_criacao_banco_tabelas.sql`;
2. `02_insercao_dados.sql`;
3. `03_views.sql`;
4. `04_functions.sql`;
5. `05_triggers.sql`;
6. `06_otimizacao.sql`.

O primeiro script utiliza o comando:

```sql
DROP DATABASE IF EXISTS camisa7_db;
```

Por isso, sua execução apaga uma versão anterior do banco e cria novamente todas as tabelas.

O script de inserção deve ser executado somente uma vez após a criação do banco, evitando duplicidade de chaves primárias, CPF, e-mail e outros campos únicos.

## Banco de dados

O banco utilizado no projeto é:

```sql
camisa7_db
```

A estrutura operacional possui 16 tabelas relacionadas por meio de chaves primárias e estrangeiras.

## Recursos implementados

O projeto contém:

* criação do banco de dados e das tabelas;
* inserção de dados fictícios;
* cinco views;
* cinco functions;
* cinco triggers;
* exemplos de utilização;
* estratégia de otimização com índice e `EXPLAIN`;
* relatório com evidências antes e depois;
* estratégia de backup e segurança;
* sugestão de modelagem Data Warehouse;
* cinco tipos de consultas analíticas.

## Otimização

A estratégia de otimização analisa uma consulta de mensalidades atrasadas.

Foi utilizado o comando `EXPLAIN` antes e depois da criação do índice:

```sql
CREATE INDEX idx_mensalidade_status_vencimento
ON mensalidade (
    status_mensalidade,
    data_vencimento
);
```

As evidências estão disponíveis na pasta `03_otimizacao/evidencias`.

## Backup e segurança

A estratégia proposta utiliza:

* backup lógico com `mysqldump`;
* armazenamento seguindo a regra 3-2-1;
* testes periódicos de restauração;
* usuários com diferentes níveis de permissão;
* princípio do menor privilégio;
* transações com `COMMIT` e `ROLLBACK`.

## Data Warehouse

Foi proposto um modelo estrela voltado para análises financeiras dos pagamentos.

A modelagem contém:

* uma tabela fato de pagamentos;
* dimensão tempo;
* dimensão sócio;
* dimensão plano;
* dimensão tipo de pagamento.

## Autor

Denzel Rodrigues
