# Minimundo — Sistema de Gestão de Sócios-Torcedores Camisa 7

## 1. Apresentação do cenário

O Botafogo de Futebol e Regatas possui um programa de relacionamento com seus torcedores denominado Camisa 7. O programa oferece diferentes planos de associação, com valores, prioridades, descontos e benefícios específicos. Entre os benefícios disponibilizados aos associados estão descontos em ingressos, prioridade na abertura das vendas, check-in gratuito para determinados planos, experiências exclusivas, promoções e vantagens oferecidas por empresas parceiras.

Este projeto apresenta uma simulação acadêmica de um sistema de banco de dados inspirado no programa Camisa 7. O sistema não representa integralmente o funcionamento oficial do programa e utilizará dados fictícios para associados, pagamentos, partidas, ingressos, benefícios e experiências. Os nomes de alguns planos e características gerais do programa serão utilizados apenas como referência para a construção do cenário.

O sistema terá como finalidade centralizar e organizar as informações relacionadas aos sócios-torcedores. Ele deverá permitir o cadastro dos associados, o controle dos planos disponíveis, a contratação e o acompanhamento das assinaturas, a geração de cobranças, o registro de pagamentos e a identificação de possíveis situações de inadimplência.

Também será responsabilidade do sistema controlar as partidas disponibilizadas aos associados, os estádios e seus setores, os preços dos ingressos, os percentuais de desconto e a quantidade de ingressos disponíveis para cada jogo. As condições para emissão de ingressos poderão variar de acordo com o plano contratado pelo sócio.

Além das operações relacionadas às assinaturas e aos ingressos, o sistema possuirá um programa de fidelidade. Os associados poderão acumular pontos por meio de pagamentos, presença em partidas ou campanhas promocionais. Os pontos acumulados poderão ser utilizados no resgate de experiências, produtos, sorteios e atividades especiais relacionadas ao clube.

O sistema deverá manter o histórico das principais movimentações realizadas pelo associado. Dessa forma, será possível consultar mudanças de plano, pagamentos efetuados, ingressos emitidos, pontos recebidos, pontos utilizados e experiências resgatadas.

O banco de dados será desenvolvido no MySQL e deverá garantir a integridade das informações armazenadas. Para isso, serão utilizadas chaves primárias, chaves estrangeiras, restrições de unicidade, validações de valores e relacionamentos entre as tabelas.

O projeto terá como foco o relacionamento entre o clube e os participantes do programa de sócio-torcedor. Não farão parte do escopo informações relacionadas aos salários dos jogadores, contratos profissionais, transferências de atletas, escalações, treinamentos, administração interna do clube ou gestão completa das competições esportivas.

## 2. Objetivo do sistema

O objetivo do sistema é oferecer uma base de dados organizada para administrar as operações de um programa de sócio-torcedor inspirado no Camisa 7. A solução deverá facilitar o cadastro dos associados, o gerenciamento dos planos, o controle financeiro das assinaturas e o acesso aos benefícios oferecidos pelo programa.

Por meio do sistema, será possível identificar quais sócios estão ativos, quais planos possuem mais assinantes, quais mensalidades estão em atraso, quanto foi arrecadado em determinado período e quais partidas apresentaram maior utilização de ingressos pelos associados.

O sistema também permitirá acompanhar a disponibilidade dos setores para cada partida, calcular o valor final dos ingressos conforme o desconto do plano e registrar a entrada do associado no estádio.

Em relação ao programa de fidelidade, será possível acompanhar o saldo de pontos de cada sócio, registrar a origem de cada movimentação e controlar a quantidade de vagas disponível nas experiências oferecidas.

As informações armazenadas também poderão ser utilizadas posteriormente para a criação de relatórios gerenciais e de uma proposta de Data Warehouse, permitindo análises sobre assinaturas, pagamentos, ingressos, presença em partidas e resgates de benefícios.

## 3. Cadastro dos sócios-torcedores

O sistema deverá permitir o cadastro dos participantes do programa de sócio-torcedor. Cada associado será identificado por um código único gerado pelo banco de dados.

Para cada sócio, serão armazenados dados como nome completo, CPF, data de nascimento, e-mail, telefone, data de cadastro e situação cadastral.

O CPF e o endereço de e-mail deverão ser únicos. Dessa forma, uma mesma pessoa não poderá possuir dois cadastros utilizando o mesmo CPF ou o mesmo e-mail.

A situação cadastral do sócio poderá ser classificada como ativa, suspensa ou cancelada. Somente associados com situação ativa poderão contratar planos, emitir ingressos e realizar resgates de experiências.

Também serão armazenadas informações referentes ao endereço do associado, incluindo CEP, logradouro, número, complemento, cidade, estado e país.

Os dados de localização poderão ser utilizados para verificar a elegibilidade do sócio para determinados planos. Por exemplo, alguns planos poderão ser destinados a torcedores que residem fora do estado do Rio de Janeiro ou fora do Brasil.

A data de nascimento será utilizada para calcular a idade do associado e verificar se ele atende à faixa etária exigida pelo plano escolhido.

Sócios menores de 18 anos deverão estar vinculados a um responsável legal. Esse responsável também deverá possuir um cadastro no sistema.

O vínculo entre o menor e o responsável será realizado por meio do próprio cadastro de sócios, permitindo que um associado adulto seja indicado como responsável por um ou mais menores.

O sistema não permitirá que um menor seja indicado como responsável legal de outro associado.

O saldo de pontos do associado não será armazenado diretamente em seu cadastro. Ele será calculado a partir dos créditos e débitos registrados no histórico de movimentações de pontos.

Os dados dos associados serão utilizados nas operações de assinatura, pagamento, emissão de ingressos, controle de presença, movimentação de pontos e resgate de experiências.

## 4. Planos, benefícios e assinaturas

O sistema possuirá diferentes planos de associação inspirados no programa Camisa 7, como Glorioso, Alvinegro, Preto, Branco, Nossa Gente, Joias do Bairro e Cria+.

Cada plano armazenará nome, valor mensal, prioridade para ingressos, percentual de desconto, limite de acompanhantes, faixa etária permitida e indicação de check-in gratuito.

O sistema também permitirá cadastrar benefícios, como descontos em produtos, estacionamento, experiências e vantagens oferecidas por parceiros.

Como um plano pode possuir vários benefícios e um benefício pode pertencer a diferentes planos, será utilizado um relacionamento entre as tabelas de planos e benefícios.

A contratação de um plano será registrada por meio de uma assinatura vinculada ao sócio. A assinatura armazenará a data de início, a próxima renovação, o tipo de cobrança, a renovação automática e sua situação.

O tipo de cobrança poderá ser mensal ou anual. Para assinaturas anuais pagas por PIX, poderá ser aplicado um desconto de 5%.

A situação da assinatura poderá ser ativa, pendente, suspensa ou cancelada. Cada sócio poderá possuir somente uma assinatura atual. As mudanças de plano e as situações anteriores serão preservadas na tabela de histórico da assinatura.

O sistema verificará se o plano está ativo e se a idade do associado é compatível com a faixa etária definida antes da contratação.

Alterações de plano ou de situação serão registradas em um histórico contendo os dados anteriores, os novos dados, a data e o motivo da mudança.

## 5. Mensalidades e pagamentos

As cobranças das assinaturas serão registradas na tabela de mensalidades. Cada mensalidade estará vinculada a uma assinatura e armazenará o mês de referência, a data de vencimento, o valor original, a multa, os juros, o valor total e a situação da cobrança.

A situação da mensalidade poderá ser pendente, paga, atrasada ou cancelada.

Quando a data de vencimento for ultrapassada sem pagamento, a cobrança poderá ser considerada atrasada. O sistema permitirá calcular multa e juros com base na quantidade de dias de atraso.

Os pagamentos serão armazenados separadamente das mensalidades, permitindo registrar tentativas de pagamento aprovadas, recusadas ou canceladas.

Cada pagamento armazenará a data, o valor pago, a forma de pagamento, o código da transação e sua situação.

As formas de pagamento disponíveis serão PIX, cartão de crédito, cartão de débito e boleto.

Quando um pagamento for aprovado, o sistema deverá atualizar automaticamente a mensalidade para paga e registrar os pontos concedidos ao sócio.

Sócios com mensalidades atrasadas por mais de dez dias poderão ter sua assinatura suspensa até a regularização da dívida.

Essas informações permitirão gerar consultas sobre inadimplência, pagamentos realizados e receita arrecadada por plano ou período.

## 6. Partidas, setores e ingressos

O sistema armazenará as partidas disponibilizadas aos sócios, informando competição, adversário, data, estádio e situação do evento.

Cada estádio será dividido em setores com capacidade definida. Para cada partida, serão cadastrados o preço-base e a quantidade de ingressos disponíveis em cada setor.

A emissão de ingresso será permitida apenas para sócios ativos, com assinatura ativa, e enquanto houver disponibilidade no setor escolhido.

O valor final do ingresso será calculado com base no preço do setor e no desconto oferecido pelo plano. Nos planos com check-in gratuito, o ingresso do titular poderá ter valor igual a zero.

Cada ingresso estará vinculado a um sócio, uma partida e um setor. Também serão registrados seu tipo, valor original, desconto aplicado, valor final e situação.

Quando um ingresso for emitido, a quantidade disponível no setor da partida será reduzida automaticamente.

O sistema também registrará a data do check-in e da entrada no estádio, impedindo que o mesmo ingresso seja utilizado mais de uma vez.

## 7. Pontos, experiências e resgates

O sistema possuirá um programa de pontos vinculado aos sócios-torcedores.

Os associados poderão receber pontos por pagamentos aprovados, presença em partidas e campanhas promocionais.

Toda entrada ou saída de pontos será registrada em uma movimentação, contendo o sócio, a quantidade, o tipo da movimentação, a origem, a data e uma descrição.

As movimentações poderão ser classificadas como crédito ou débito. O saldo de pontos do associado será obtido pela soma dessas movimentações.

Os pontos poderão ser utilizados no resgate de experiências, como visitas ao estádio, encontros com jogadores, produtos oficiais e participação em sorteios.

Cada experiência armazenará nome, descrição, quantidade de pontos exigida, quantidade de vagas, data e situação.

Um resgate somente poderá ser realizado quando o sócio estiver ativo, possuir pontos suficientes e houver vagas disponíveis.

Quando um resgate for confirmado, os pontos utilizados serão descontados e a quantidade de vagas disponíveis será reduzida.

As informações registradas permitirão consultar o saldo de pontos, as experiências mais procuradas e o histórico de resgates dos associados.

## 8. Principais regras de negócio

Cada sócio deverá possuir CPF e e-mail únicos.

Sócios menores de 18 anos deverão estar vinculados a um responsável legal cadastrado no sistema.

Somente sócios ativos poderão contratar planos, emitir ingressos e resgatar experiências.

Cada sócio poderá possuir somente uma assinatura ativa por vez.

A idade do associado deverá ser compatível com a faixa etária definida no plano escolhido.

Somente planos ativos poderão ser contratados.

Toda alteração de plano ou de situação da assinatura deverá ser registrada no histórico.

Cada mensalidade estará vinculada a uma assinatura.

Um pagamento aprovado deverá atualizar a mensalidade para paga.

Pagamentos aprovados poderão gerar pontos para o associado.

Mensalidades atrasadas por mais de dez dias poderão causar a suspensão da assinatura.

O valor do ingresso será calculado de acordo com o preço do setor e o desconto do plano.

Planos com check-in gratuito poderão emitir ingresso titular com valor igual a zero.

Não será possível emitir ingressos quando não houver disponibilidade no setor da partida.

A emissão de um ingresso deverá reduzir a quantidade disponível no setor.

Cada ingresso poderá ser utilizado somente uma vez.

O resgate de uma experiência dependerá da existência de pontos e vagas suficientes.

Toda movimentação de pontos deverá possuir uma origem registrada.

## 9. Consultas e relatórios previstos

O banco de dados permitirá gerar consultas relacionadas às principais operações do programa.

Será possível consultar os sócios ativos e seus respectivos planos.

Também será possível identificar associados com mensalidades em atraso.

O sistema permitirá calcular a receita obtida por plano ou por período.

As informações das partidas poderão ser utilizadas para consultar a quantidade de ingressos emitidos e a ocupação dos setores.

Os registros de fidelidade permitirão consultar os pontos acumulados, os resgates realizados e as experiências mais procuradas.

Essas consultas serão utilizadas na criação de views e também servirão como base para uma proposta de Data Warehouse.

O Data Warehouse poderá analisar informações de assinaturas, pagamentos, ingressos e resgates ao longo do tempo.

## 10. Recursos de banco de dados utilizados

O projeto será desenvolvido no MySQL.

As tabelas utilizarão chaves primárias para identificar seus registros e chaves estrangeiras para representar os relacionamentos.

Serão utilizadas restrições de unicidade para evitar a repetição de CPF, e-mail e outros dados que devam ser exclusivos.

Também serão utilizadas validações para impedir valores negativos, situações inválidas e relacionamentos inconsistentes.

O projeto possuirá cinco views para facilitar consultas frequentes.

Serão desenvolvidas cinco functions para cálculos como idade, valor do ingresso, multa, saldo de pontos e valor anual do plano.

Também serão criadas cinco triggers para automatizar operações importantes, como histórico de assinatura, atualização de pagamento, concessão de pontos, controle de ingressos e resgate de experiências.

Serão aplicados índices em campos utilizados com frequência em filtros, relacionamentos e pesquisas.

A estratégia de otimização será demonstrada por meio da comparação de uma consulta antes e depois da criação de índices.

Também será apresentada uma estratégia de backup e segurança para proteger os dados armazenados.

## 11. Limites do sistema

O projeto será uma simulação acadêmica inspirada no programa Camisa 7 e utilizará dados fictícios.

O sistema não terá como objetivo reproduzir todas as regras do programa oficial.

Não serão controlados contratos, salários, transferências ou dados profissionais dos jogadores.

Também não farão parte do escopo as escalações, os treinamentos, a classificação dos campeonatos ou a administração financeira completa do clube.

A venda de ingressos para pessoas que não sejam sócias também não será considerada.

O foco do sistema será o gerenciamento dos sócios-torcedores, seus planos, pagamentos, ingressos, pontos e experiências.


Essas informações permitirão consultar a ocupação dos setores, os ingressos emitidos e a presença dos sócios nas partidas.




