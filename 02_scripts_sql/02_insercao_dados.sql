USE camisa7_db;

INSERT INTO plano (
    id_plano,
    nome,
    descricao,
    valor_mensal,
    prioridade_ingresso,
    percentual_desconto,
    limite_acompanhantes,
    idade_minima,
    idade_maxima,
    checkin_gratuito,
    status_plano
)
VALUES
(1, 'Glorioso', 'Plano com prioridade máxima e check-in gratuito.',
 259.90, 1, 100.00, 2, 18, NULL, TRUE, 'ATIVO'),

(2, 'Alvinegro', 'Plano com prioridade elevada e check-in gratuito.',
 154.90, 2, 100.00, 1, 18, NULL, TRUE, 'ATIVO'),

(3, 'Preto', 'Plano com desconto de 70% nos ingressos.',
 79.90, 3, 70.00, 1, 18, NULL, FALSE, 'ATIVO'),

(4, 'Branco', 'Plano com desconto de 50% nos ingressos.',
 37.90, 4, 50.00, 0, 18, NULL, FALSE, 'ATIVO'),

(5, 'Nossa Gente', 'Plano de entrada do programa.',
 7.90, 5, 50.00, 0, 18, NULL, FALSE, 'ATIVO'),

(6, 'Joias do Bairro', 'Plano destinado a associados de 12 a 17 anos.',
 24.90, 2, 60.00, 0, 12, 17, FALSE, 'ATIVO'),

(7, 'Cria+', 'Plano destinado ao público infantil.',
 12.90, 2, 100.00, 0, 0, 11, TRUE, 'ATIVO');



INSERT INTO beneficio (
    id_beneficio,
    nome,
    descricao,
    tipo,
    percentual_desconto,
    status_beneficio
)
VALUES
(1, 'Desconto na loja oficial',
 'Desconto na compra de produtos oficiais.',
 'DESCONTO', 10.00, 'ATIVO'),

(2, 'Check-in gratuito',
 'Permite a emissão gratuita do ingresso titular.',
 'DESCONTO', 100.00, 'ATIVO'),

(3, 'Desconto no estacionamento',
 'Desconto no estacionamento em dias de partida.',
 'PARCEIRO', 20.00, 'ATIVO'),

(4, 'Experiências exclusivas',
 'Acesso a experiências oferecidas pelo programa.',
 'EXPERIENCIA', NULL, 'ATIVO'),

(5, 'Participação em sorteios',
 'Permite participar de sorteios promocionais.',
 'OUTRO', NULL, 'ATIVO');



INSERT INTO plano_beneficio (
    id_plano,
    id_beneficio,
    detalhes
)
VALUES
(1, 1, 'Desconto de 10% na loja oficial'),
(1, 2, 'Check-in gratuito para o titular'),
(1, 3, 'Desconto no estacionamento'),
(1, 4, 'Acesso a experiências exclusivas'),
(1, 5, 'Participação em sorteios'),

(2, 1, 'Desconto de 10% na loja oficial'),
(2, 2, 'Check-in gratuito para o titular'),
(2, 4, 'Acesso a experiências exclusivas'),

(3, 1, 'Desconto na loja oficial'),
(3, 5, 'Participação em sorteios'),

(4, 5, 'Participação em sorteios'),

(6, 4, 'Experiências para o público jovem'),

(7, 2, 'Ingresso infantil gratuito'),
(7, 4, 'Experiências para o público infantil');


INSERT INTO socio (
    id_socio,
    nome_completo,
    cpf,
    data_nascimento,
    email,
    telefone,
    cep,
    logradouro,
    numero,
    complemento,
    cidade,
    estado,
    pais,
    status_socio,
    id_responsavel
)
VALUES
(1, 'Denzel Rodrigues', '11111111111', '1988-05-15',
 'denzelhrl@email.com', '21999990001', '22250040',
 'Rua das Palmeiras', '120', NULL,
 'Rio de Janeiro', 'RJ', 'Brasil', 'ATIVO', NULL),

(2, 'Mariana Alves Souza', '22222222222', '1992-10-20',
 'mariana@email.com', '21999990002', '22041080',
 'Rua Barata Ribeiro', '450', 'Apto 301',
 'Rio de Janeiro', 'RJ', 'Brasil', 'ATIVO', NULL),

(3, 'Joao Victor Pereira', '33333333333', '1985-03-08',
 'joao@email.com', '21999990003', '24020085',
 'Rua da Conceicao', '75', NULL,
 'Niteroi', 'RJ', 'Brasil', 'ATIVO', NULL),

(4, 'Ana Beatriz Lima', '44444444444', '1998-07-12',
 'ana@email.com', '11999990004', '01310100',
 'Avenida Paulista', '1000', 'Apto 82',
 'Sao Paulo', 'SP', 'Brasil', 'ATIVO', NULL),

(7, 'Fernanda Rocha Gomes', '77777777777', '1990-01-27',
 'fernanda@email.com', '21999990007', '20550013',
 'Rua Conde de Bonfim', '300', NULL,
 'Rio de Janeiro', 'RJ', 'Brasil', 'SUSPENSO', NULL),

(8, 'Rafael Martins Costa', '88888888888', '1983-11-02',
 'rafael@email.com', '21999990008', '22775020',
 'Estrada dos Bandeirantes', '900', NULL,
 'Rio de Janeiro', 'RJ', 'Brasil', 'CANCELADO', NULL);



INSERT INTO socio (
    id_socio,
    nome_completo,
    cpf,
    data_nascimento,
    email,
    telefone,
    cep,
    logradouro,
    numero,
    cidade,
    estado,
    pais,
    status_socio,
    id_responsavel
)
VALUES
(5, 'Pedro Henrique Silva', '55555555555', '2011-04-10',
 'pedro@email.com', '21999990005', '22250040',
 'Rua das Palmeiras', '120',
 'Rio de Janeiro', 'RJ', 'Brasil', 'ATIVO', 1),

(6, 'Lucas Souza Alves', '66666666666', '2017-09-18',
 'lucas@email.com', '21999990006', '22041080',
 'Rua Barata Ribeiro', '450',
 'Rio de Janeiro', 'RJ', 'Brasil', 'ATIVO', 2);



INSERT INTO assinatura (
    id_assinatura,
    id_socio,
    id_plano,
    data_inicio,
    proxima_renovacao,
    tipo_cobranca,
    renovacao_automatica,
    status_assinatura
)
VALUES
(1, 1, 1, '2026-01-10', '2026-07-10',
 'MENSAL', TRUE, 'ATIVA'),

(2, 2, 2, '2026-01-15', '2027-01-15',
 'ANUAL', TRUE, 'ATIVA'),

(3, 3, 3, '2026-02-01', '2026-07-01',
 'MENSAL', TRUE, 'ATIVA'),

(4, 4, 4, '2026-03-05', '2026-07-05',
 'MENSAL', TRUE, 'ATIVA'),

(5, 5, 6, '2026-02-10', '2026-07-10',
 'MENSAL', TRUE, 'ATIVA'),

(6, 6, 7, '2026-04-12', '2026-07-12',
 'MENSAL', TRUE, 'ATIVA'),

(7, 7, 3, '2026-01-20', NULL,
 'MENSAL', FALSE, 'SUSPENSA'),

(8, 8, 5, '2025-10-10', NULL,
 'MENSAL', FALSE, 'CANCELADA');


INSERT INTO historico_assinatura (
    id_historico,
    id_assinatura,
    id_plano_anterior,
    id_plano_novo,
    status_anterior,
    status_novo,
    data_alteracao,
    motivo
)
VALUES
(1, 3, 4, 3, 'ATIVA', 'ATIVA',
 '2026-02-01 10:00:00',
 'Upgrade do plano Branco para o plano Preto'),

(2, 7, 3, 3, 'ATIVA', 'SUSPENSA',
 '2026-06-15 09:30:00',
 'Suspensao causada por mensalidade em atraso'),

(3, 8, 5, 5, 'ATIVA', 'CANCELADA',
 '2026-05-01 14:00:00',
 'Cancelamento solicitado pelo associado');


INSERT INTO mensalidade (
    id_mensalidade,
    id_assinatura,
    mes_referencia,
    data_vencimento,
    valor_original,
    multa,
    juros,
    valor_total,
    status_mensalidade
)
VALUES
(1, 1, '2026-06-01', '2026-06-10',
 259.90, 0.00, 0.00, 259.90, 'PAGA'),

(2, 1, '2026-07-01', '2026-07-10',
 259.90, 0.00, 0.00, 259.90, 'PENDENTE'),

(3, 2, '2026-01-01', '2026-01-15',
 1765.86, 0.00, 0.00, 1765.86, 'PAGA'),

(4, 3, '2026-06-01', '2026-06-01',
 79.90, 0.00, 0.00, 79.90, 'PAGA'),

(5, 3, '2026-07-01', '2026-07-01',
 79.90, 0.00, 0.00, 79.90, 'PENDENTE'),

(6, 4, '2026-06-01', '2026-06-05',
 37.90, 0.00, 0.00, 37.90, 'PAGA'),

(7, 5, '2026-06-01', '2026-06-10',
 24.90, 0.00, 0.00, 24.90, 'PAGA'),

(8, 6, '2026-06-01', '2026-06-12',
 12.90, 0.00, 0.00, 12.90, 'PENDENTE'),

(9, 7, '2026-05-01', '2026-05-20',
 79.90, 2.00, 1.50, 83.40, 'ATRASADA'),

(10, 8, '2026-05-01', '2026-05-10',
 7.90, 0.00, 0.00, 7.90, 'CANCELADA');


INSERT INTO pagamento (
    id_pagamento,
    id_mensalidade,
    data_pagamento,
    valor_pago,
    forma_pagamento,
    codigo_transacao,
    status_pagamento
)
VALUES
(1, 1, '2026-06-08 10:15:00',
 259.90, 'PIX', 'PIX-C7-0001', 'APROVADO'),

(2, 3, '2026-01-15 08:30:00',
 1765.86, 'PIX', 'PIX-C7-0002', 'APROVADO'),

(3, 4, '2026-06-01 14:20:00',
 79.90, 'CARTAO_CREDITO', 'CC-C7-0003', 'APROVADO'),

(4, 6, '2026-06-04 16:00:00',
 37.90, 'BOLETO', 'BOL-C7-0004', 'APROVADO'),

(5, 7, '2026-06-09 11:10:00',
 24.90, 'PIX', 'PIX-C7-0005', 'APROVADO'),

(6, 8, '2026-06-12 12:00:00',
 12.90, 'CARTAO_CREDITO', 'CC-C7-0006', 'RECUSADO'),

(7, 9, '2026-06-18 18:30:00',
 83.40, 'CARTAO_DEBITO', 'CD-C7-0007', 'RECUSADO');



INSERT INTO estadio (
    id_estadio,
    nome,
    cidade,
    estado,
    capacidade_total
)
VALUES
(1, 'Estadio Nilton Santos',
 'Rio de Janeiro', 'RJ', 46831),

(2, 'Estadio Nacional Mane Garrincha',
 'Brasilia', 'DF', 72788);


INSERT INTO setor (
    id_setor,
    id_estadio,
    nome,
    capacidade,
    descricao
)
VALUES
(1, 1, 'Leste Inferior', 10000,
 'Setor lateral inferior'),

(2, 1, 'Oeste Inferior', 8000,
 'Setor lateral próximo aos bancos de reservas'),

(3, 1, 'Norte', 12000,
 'Setor localizado atrás do gol norte'),

(4, 1, 'Sul', 12000,
 'Setor localizado atrás do gol sul'),

(5, 2, 'Arquibancada Inferior', 20000,
 'Setor inferior do estadio');


INSERT INTO partida (
    id_partida,
    competicao,
    adversario,
    data_hora,
    id_estadio,
    mando,
    status_partida
)
VALUES
(1, 'Campeonato Brasileiro', 'Flamengo',
 '2026-07-15 21:30:00', 1,
 'MANDANTE', 'INGRESSOS_ABERTOS'),

(2, 'Campeonato Brasileiro', 'Palmeiras',
 '2026-08-02 18:30:00', 1,
 'MANDANTE', 'AGENDADA'),

(3, 'Copa do Brasil', 'Vasco da Gama',
 '2026-08-20 20:00:00', 2,
 'VISITANTE', 'INGRESSOS_ABERTOS');


INSERT INTO setor_partida (
    id_setor_partida,
    id_partida,
    id_setor,
    preco_base,
    quantidade_disponivel,
    quantidade_restante
)
VALUES
(1, 1, 1, 120.00, 1000, 997),
(2, 1, 2, 180.00, 800, 799),
(3, 1, 3, 80.00, 1500, 1499),

(4, 2, 1, 100.00, 1000, 1000),
(5, 2, 2, 160.00, 800, 800),

(6, 3, 5, 90.00, 1200, 1199);



INSERT INTO ingresso (
    id_ingresso,
    id_socio,
    id_setor_partida,
    tipo_ingresso,
    preco_original,
    percentual_desconto,
    valor_final,
    status_ingresso,
    data_emissao,
    data_checkin,
    data_entrada,
    codigo_validacao
)
VALUES
(1, 1, 1, 'TITULAR',
 120.00, 100.00, 0.00,
 'EMITIDO', '2026-06-20 10:00:00',
 '2026-06-20 10:01:00', NULL,
 'ING-C7-0001'),

(2, 2, 2, 'TITULAR',
 180.00, 100.00, 0.00,
 'UTILIZADO', '2026-06-20 10:10:00',
 '2026-06-20 10:12:00',
 '2026-07-15 20:15:00',
 'ING-C7-0002'),

(3, 3, 3, 'TITULAR',
 80.00, 70.00, 24.00,
 'EMITIDO', '2026-06-20 10:20:00',
 NULL, NULL,
 'ING-C7-0003'),

(4, 5, 1, 'INFANTIL',
 120.00, 60.00, 48.00,
 'EMITIDO', '2026-06-20 10:30:00',
 NULL, NULL,
 'ING-C7-0004'),

(5, 6, 1, 'INFANTIL',
 120.00, 100.00, 0.00,
 'EMITIDO', '2026-06-20 10:40:00',
 NULL, NULL,
 'ING-C7-0005'),

(6, 4, 6, 'TITULAR',
 90.00, 50.00, 45.00,
 'EMITIDO', '2026-06-21 11:00:00',
 NULL, NULL,
 'ING-C7-0006');


INSERT INTO movimentacao_pontos (
    id_movimentacao,
    id_socio,
    tipo_movimentacao,
    quantidade,
    origem,
    data_movimentacao,
    descricao
)
VALUES
(1, 1, 'CREDITO', 300, 'PAGAMENTO',
 '2026-06-08 10:15:00',
 'Pontos pelo pagamento da mensalidade'),

(2, 1, 'CREDITO', 50, 'PRESENCA_PARTIDA',
 '2026-06-10 22:30:00',
 'Pontos pela presença em partida'),

(3, 1, 'DEBITO', 200, 'RESGATE',
 '2026-06-18 09:00:00',
 'Resgate de tour pelo estadio'),

(4, 2, 'CREDITO', 400, 'PAGAMENTO',
 '2026-01-15 08:30:00',
 'Pontos pelo pagamento do plano anual'),

(5, 2, 'DEBITO', 300, 'RESGATE',
 '2026-06-19 10:00:00',
 'Resgate de encontro com jogadores'),

(6, 3, 'CREDITO', 200, 'PAGAMENTO',
 '2026-06-01 14:20:00',
 'Pontos pelo pagamento da mensalidade'),

(7, 5, 'CREDITO', 250, 'PROMOCAO',
 '2026-06-10 12:00:00',
 'Campanha promocional para associados jovens'),

(8, 5, 'DEBITO', 200, 'RESGATE',
 '2026-06-20 09:30:00',
 'Resgate de tour pelo estadio'),

(9, 6, 'CREDITO', 120, 'PROMOCAO',
 '2026-06-12 13:00:00',
 'Campanha promocional infantil');



INSERT INTO experiencia (
    id_experiencia,
    nome,
    descricao,
    pontos_necessarios,
    quantidade_vagas,
    vagas_disponiveis,
    data_experiencia,
    status_experiencia
)
VALUES
(1, 'Tour pelo Estadio Nilton Santos',
 'Visita guiada às dependências do estadio.',
 200, 20, 18,
 '2026-08-10 10:00:00', 'ATIVA'),

(2, 'Encontro com jogadores',
 'Encontro exclusivo com jogadores do elenco.',
 300, 10, 9,
 '2026-09-05 14:00:00', 'ATIVA'),

(3, 'Camisa autografada',
 'Resgate de camisa oficial autografada.',
 500, 5, 5,
 NULL, 'ATIVA');




INSERT INTO resgate (
    id_resgate,
    id_socio,
    id_experiencia,
    pontos_utilizados,
    data_resgate,
    status_resgate
)
VALUES
(1, 1, 1, 200,
 '2026-06-18 09:00:00', 'CONFIRMADO'),

(2, 2, 2, 300,
 '2026-06-19 10:00:00', 'CONFIRMADO'),

(3, 5, 1, 200,
 '2026-06-20 09:30:00', 'CONFIRMADO');
```
