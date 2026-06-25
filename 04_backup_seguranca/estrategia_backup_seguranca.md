# Estratégia de Backup e Segurança

## 1. Objetivo

A estratégia de backup e segurança tem como objetivo proteger os dados do sistema de sócios-torcedores contra exclusões acidentais, falhas de hardware, erros durante operações e acessos não autorizados.

Como o banco de dados deste projeto possui tamanho pequeno e foi desenvolvido no MySQL, será utilizada uma estratégia simples, compatível com o escopo acadêmico da aplicação.

## 2. Tipo de backup adotado

Será utilizado o backup lógico completo por meio da ferramenta `mysqldump`

O backup lógico gera um arquivo contendo os comandos SQL necessários para recriar as tabelas e restaurar os dados do banco.

Essa opção foi escolhida porque:

* o banco possui volume pequeno;
* o arquivo pode ser restaurado em outra instalação do MySQL;
* permite recuperar a estrutura e os dados;
* sua execução e validação são simples;
* não exige ferramentas adicionais.

O comando sugerido para gerar o backup é:

```bash
mysqldump -u root -p --single-transaction --routines --triggers camisa7_db > backup_camisa7.sql
```

A opção `--single-transaction` permite gerar uma cópia consistente das tabelas InnoDB sem aplicar bloqueio global durante todo o processo.

As opções `--routines` e `--triggers` garantem que as functions e triggers também sejam incluídas no arquivo.

## 3. Frequência e retenção

Em um cenário real, será realizado um backup completo diariamente, preferencialmente fora do horário de maior utilização do sistema.

Também deverá ser gerado um backup antes de alterações importantes, como:

* criação ou exclusão de tabelas;
* implantação de novas triggers;
* alteração das regras do sistema;
* atualização de grande quantidade de registros.

Serão mantidos:

* os sete backups diários mais recentes;
* um backup semanal durante quatro semanas;
* um backup adicional antes de mudanças importantes.

Arquivos mais antigos poderão ser removidos de acordo com o período de retenção definido.

## 4. Armazenamento das cópias

Será aplicada a regra 3-2-1:

* manter três cópias dos dados, considerando o banco original e dois backups;
* utilizar pelo menos dois meios de armazenamento diferentes;
* manter uma cópia em local diferente do equipamento principal.

Uma cópia poderá ser armazenada em disco local e outra em um serviço de armazenamento em nuvem.

Os backups não deverão permanecer apenas no mesmo computador em que o banco de dados está instalado, pois uma falha no equipamento poderia comprometer o banco e as cópias simultaneamente.

## 5. Restauração do banco

Para restaurar o banco a partir do arquivo de backup, poderá ser utilizado:

```bash
mysql -u root -p camisa7_db < backup_camisa7.sql
```

Antes da restauração, deverá ser verificado se o banco de destino existe e se o arquivo utilizado corresponde à versão correta.

A restauração também poderá ser executada pelo MySQL Workbench por meio da opção de importação de dados.

Os backups deverão ser testados periodicamente em um banco separado. A existência do arquivo não garante que sua restauração funcionará corretamente.

## 6. Segurança de acesso

A segurança será baseada no princípio do menor privilégio. Cada usuário deverá possuir somente as permissões necessárias para executar sua função.

Serão considerados três níveis de acesso:

### Administrador

Responsável pela criação das tabelas, usuários, backups, functions, triggers e alterações estruturais.

Esse usuário terá acesso completo, mas não deverá ser utilizado nas operações comuns do sistema.

### Operador

Poderá consultar, inserir e atualizar informações utilizadas no funcionamento do programa.

Exemplo de criação:

```sql
CREATE USER 'operador_camisa7'@'localhost'
IDENTIFIED BY 'SenhaForte@2026';

GRANT SELECT, INSERT, UPDATE
ON camisa7_db.*
TO 'operador_camisa7'@'localhost';
```

### Consulta

Poderá apenas visualizar os dados e relatórios, sem realizar alterações.

```sql
CREATE USER 'consulta_camisa7'@'localhost'
IDENTIFIED BY 'SenhaConsulta@2026';

GRANT SELECT
ON camisa7_db.*
TO 'consulta_camisa7'@'localhost';
```

As senhas mostradas são apenas exemplos acadêmicos e deverão ser substituídas em uma aplicação real.

## 7. Medidas adicionais de segurança

As seguintes medidas também deverão ser adotadas:

* utilização de senhas fortes;
* proibição do compartilhamento de usuários;
* restrição do acesso ao banco apenas aos dispositivos autorizados;
* utilização do usuário administrador somente quando necessário;
* revisão periódica das permissões;
* remoção de usuários que não precisem mais acessar o sistema;
* proteção dos arquivos de backup contra acesso não autorizado;
* não armazenamento de senhas diretamente no código da aplicação.

Quando necessário, as permissões de um usuário poderão ser removidas com o comando `REVOKE`.

Exemplo:

```sql
REVOKE INSERT, UPDATE
ON camisa7_db.*
FROM 'operador_camisa7'@'localhost';
```

## 8. Recuperação em caso de falha

Em caso de erro durante uma operação, deverão ser utilizadas transações com `COMMIT` e `ROLLBACK` para impedir que alterações incompletas permaneçam no banco.

Exemplo:

```sql
START TRANSACTION;

UPDATE mensalidade
SET status_mensalidade = 'PAGA'
WHERE id_mensalidade = 1;

UPDATE assinatura
SET status_assinatura = 'ATIVA'
WHERE id_assinatura = 1;

COMMIT;
```

Caso algum erro seja identificado antes da confirmação:

```sql
ROLLBACK;
```

Para falhas maiores, como perda do banco ou problema no equipamento, deverá ser utilizado o backup válido mais recente.

## 9. Conclusão

A estratégia adotada utiliza backup lógico completo, armazenamento em mais de um local, testes de restauração e controle de permissões por usuário.

Essas medidas são suficientes para o escopo acadêmico do projeto e ajudam a garantir disponibilidade, integridade e proteção dos dados do sistema.
