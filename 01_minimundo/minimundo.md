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

O cadastro do sócio também armazenará sua quantidade atual de pontos no programa de fidelidade. Entretanto, qualquer alteração nessa pontuação deverá possuir uma movimentação correspondente, permitindo identificar a origem dos pontos recebidos ou utilizados.

Os dados dos associados serão utilizados nas operações de assinatura, pagamento, emissão de ingressos, controle de presença, movimentação de pontos e resgate de experiências.

