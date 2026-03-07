DROP SCHEMA IF EXISTS Imobiliaria CASCADE;
CREATE SCHEMA Imobiliaria;
SET search_path TO Imobiliaria;

CREATE TABLE Corretor(
    id_corretor INT PRIMARY KEY,
    cpf VARCHAR(18) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    creci VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(50),
    telefone VARCHAR(15) NOT NULL,
    percentual_comissao DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Cliente (
	id_cliente INT PRIMARY KEY,
    cpf VARCHAR(18) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    telefone VARCHAR(15) NOT NULL
);

CREATE TABLE Proprietario(
    id_proprietario INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(18) UNIQUE,
    cnpj VARCHAR(18) UNIQUE,
    email VARCHAR(100) UNIQUE,  
	endereco VARCHAR(100) NOT NULL,
	telefone VARCHAR(15)
);

CREATE TABLE Tipo_Imovel(
    id_tipo INT PRIMARY KEY,
    nome_tipo VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200)
);

CREATE TABLE Imovel (
    codigo INT PRIMARY KEY,
    valor DECIMAL(15, 2),
    metragem DECIMAL(10, 2),
    banheiros INT,
    endereco VARCHAR(100),
    finalidade VARCHAR(150),
    num_quarto INT,
    vaga_garagem INT,
    status VARCHAR(20) DEFAULT 'Disponivel',
	imovel_proprietario INT NOT NULL,
	tipo_imovel INT NOT NULL,
	CONSTRAINT fk_imovel_proprietario FOREIGN KEY (imovel_proprietario) REFERENCES Proprietario (id_proprietario), 
	CONSTRAINT fk_tipo_imovel FOREIGN KEY (tipo_imovel) REFERENCES Tipo_Imovel (id_tipo),
	CONSTRAINT status_imovel CHECK (status IN ('Disponivel', 'Reservado', 'Vendido'))
);

CREATE TABLE Contrato (
    id_contrato INT PRIMARY KEY,
    tipo_contrato VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    valor_fechado DECIMAL(15, 2),
    contrato_proprietario INT,
    contrato_cliente INT NOT NULL,
    contrato_imovel INT NOT NULL,
    CONSTRAINT fk_contrato_proprietario FOREIGN KEY (contrato_proprietario) REFERENCES Proprietario(id_proprietario),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (contrato_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_contrato_imovel FOREIGN KEY (contrato_imovel) REFERENCES Imovel(codigo)
);

CREATE TABLE Contrato_Corretor (
    contrato_id INT NOT NULL,
    corretor_id INT NOT NULL,
    PRIMARY KEY (contrato_id, corretor_id),
    CONSTRAINT fk_cc_contrato FOREIGN KEY (contrato_id) REFERENCES Contrato(id_contrato),
    CONSTRAINT fk_cc_corretor FOREIGN KEY (corretor_id) REFERENCES Corretor(id_corretor)
);

CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY,
    valor_pago DECIMAL(15, 2),
    data_pagamento DATE,
    forma VARCHAR(50),
    situacao VARCHAR(50) DEFAULT 'Pendente',
	pagamento_contrato INT NOT NULL,
	CONSTRAINT fk_pagamento_contrato FOREIGN KEY (pagamento_contrato) REFERENCES Contrato (id_contrato),
	CONSTRAINT situacao_pagamento CHECK (situacao IN ('Pendente', 'Pago', 'Cancelado'))
);

CREATE TABLE Proposta(
    id_proposta INT PRIMARY KEY,
    valor_ofertado DECIMAL(15, 2) NOT NULL,
    data_proposta DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Em Analise',
	proposta_cliente INT NOT NULL,
	proposta_imovel INT NOT NULL,
	CONSTRAINT fk_proposta_cliente FOREIGN KEY (proposta_cliente) REFERENCES Cliente (id_cliente),
	CONSTRAINT fk_proposta_imovel FOREIGN KEY (proposta_imovel) REFERENCES Imovel (codigo),
	CONSTRAINT status_proposta CHECK (status IN ('Em Analise', 'Aprovada', 'Cancelada', 'Recusada'))
);

-- POVOAMENTO DO BANCO

-- 1) Tipo_Imovel
INSERT INTO Tipo_Imovel (id_tipo, nome_tipo, descricao) VALUES
(1, 'Apartamento', 'Apartamento residencial'),
(2, 'Casa', 'Casa residencial'),
(3, 'Terreno', 'Terreno urbano'),
(4, 'Sala Comercial', 'Imóvel para comércio/serviços'),
(5, 'Galpão', 'Galpão industrial/armazenagem'),
(6, 'Chácara', 'Imóvel rural de lazer'),
(7, 'Cobertura', 'Cobertura residencial'),
(8, 'Kitnet', 'Unidade compacta para moradia'),
(9, 'Loja', 'Loja térrea para comércio');

-- 2) Proprietario
INSERT INTO Proprietario (id_proprietario, nome, cpf, cnpj, email, endereco, telefone) VALUES
(1, 'Ana Souza', '111.111.111-11', NULL, 'ana@ex.com', 'Rua A, 10 - Centro', '34 99901-0001'),
(2, 'Bruno Lima', '222.222.222-22', NULL, 'bruno@ex.com', 'Rua B, 20 - Centro', '34 99901-0002'),
(3, 'Carla Rocha', '333.333.333-33', NULL, 'carla@ex.com', 'Rua C, 30 - Santa Mônica', '34 99901-0003'),
(4, 'Diego Alves', '444.444.444-44', NULL, 'diego@ex.com', 'Rua D, 40 - Santa Mônica', '34 99901-0004'),
(5, 'Imob Invest Ltda', NULL, '11.111.111/0001-11', 'invest@ex.com', 'Av. Rondon, 1000', '34 3230-0005'),
(6, 'Holding Patrimônio S/A', NULL, '22.222.222/0001-22', 'holding@ex.com', 'Av. Segismundo, 2000', '34 3230-0006'),
(7, 'Eduardo Martins', '777.111.222-33', NULL, 'eduardo@ex.com', 'Rua E, 50 - Centro', '34 99901-0007'),
(8, 'Flávia Ribeiro', '888.111.222-44', NULL, 'flavia@ex.com', 'Rua F, 60 - Brasil', '34 99901-0008'),
(9, 'Gomes Participações LTDA', NULL, '33.333.333/0001-33', 'gomes@ex.com', 'Av. João Naves, 3000', '34 3230-0009'),
(10, 'Helena Araújo', '999.111.222-55', NULL, 'helena@ex.com', 'Rua G, 70 - Martins', '34 99901-0010'),
(11, 'Inova Imóveis S/A', NULL, '44.444.444/0001-44', 'inova@ex.com', 'Av. Floriano, 1500', '34 3230-0011'),
(12, 'Igor Almeida', '123.456.789-10', NULL, 'igor@ex.com', 'Rua H, 80 - Santa Mônica', '34 99901-0012');

-- 3) Corretor
INSERT INTO Corretor (id_corretor, cpf, nome, creci, email, telefone, percentual_comissao) VALUES
(1, '555.555.555-55', 'Rafael Santos', 'MG12345', 'rafael@ex.com', '34 99910-0101', 6.00),
(2, '666.666.666-66', 'Marina Costa', 'MG23456', 'marina@ex.com', '34 99910-0102', 5.50),
(3, '777.777.777-77', 'João Pedro', 'MG34567', 'joao@ex.com', '34 99910-0103', 6.50),
(4, '888.888.888-88', 'Paula Nunes', 'MG45678', 'paula@ex.com', '34 99910-0104', 5.00),
(5, '999.999.999-99', 'Lucas Freitas', 'MG56789', 'lucas@ex.com', '34 99910-0105', 6.00),
(6, '000.000.000-00', 'Fernanda Melo', 'MG67890', 'fer@ex.com', '34 99910-0106', 5.75),
(7,  '121.212.212-12', 'Bruna Pires',    'MG78901', 'bruna@ex.com',  '34 99910-0107', 5.25),
(8,  '131.313.313-13', 'Thiago Reis',    'MG89012', 'thiago@ex.com', '34 99910-0108', 6.00),
(9,  '141.414.414-14', 'Camila Prado',   'MG90123', 'camila@ex.com', '34 99910-0109', 5.75),
(10, '151.515.515-15', 'Diego Moraes',   'MG01234', 'dm@ex.com',     '34 99910-0110', 6.50),
(11, '161.616.616-16', 'Larissa Campos', 'MG11223', 'lari@ex.com',   '34 99910-0111', 5.00),
(12, '171.717.717-17', 'Felipe Souza',   'MG22334', 'felipe@ex.com', '34 99910-0112', 6.25);

-- 4) Cliente
INSERT INTO Cliente (id_cliente, cpf, nome, email, telefone) VALUES
(1, '101.101.101-10', 'Guilherme Antonio', 'gui@ex.com', '34 99911-1101'),
(2, '202.202.202-20', 'Lais Oliveira', 'lais@ex.com', '34 99911-1102'),
(3, '303.303.303-30', 'Pedro Carvalho', 'pedro@ex.com', '34 99911-1103'),
(4, '404.404.404-40', 'Julia Duarte', 'julia@ex.com', '34 99911-1104'),
(5, '505.505.505-50', 'Renato Evaristo', 'renato@ex.com', '34 99911-1105'),
(6, '606.606.606-60', 'Bianca Ferreira', 'bianca@ex.com', '34 99911-1106'),
(7,  '707.707.707-70', 'Rafaela Mendes',   'rafaela@ex.com', '34 99911-1107'),
(8,  '808.808.808-80', 'Caio Fernandes',   'caio@ex.com',    '34 99911-1108'),
(9,  '909.909.909-90', 'Larissa Tavares',  'lt@ex.com',      '34 99911-1109'),
(10, '111.222.333-44', 'Samuel Rocha',     'samuel@ex.com',  '34 99911-1110'),
(11, '222.333.444-55', 'Débora Cunha',     'debora@ex.com',  '34 99911-1111'),
(12, '333.444.555-66', 'Matheus Nogueira', 'matheus@ex.com', '34 99911-1112'),
(13, '444.555.666-77', 'Luana Ribeiro',    'luana@ex.com',   '34 99911-1113'),
(14, '555.666.777-88', 'Victor Lima',      'victor@ex.com',  '34 99911-1114');

-- 5) Imovel
INSERT INTO Imovel
(codigo, valor, metragem, banheiros, endereco, finalidade, num_quarto, vaga_garagem, status, imovel_proprietario, tipo_imovel)
VALUES
(10, 350000.00, 70.00, 2, 'Rua 1, 100 - Centro', 'Residencial', 2, 1, 'Disponivel', 1, 1),
(11, 520000.00, 120.00, 3, 'Rua 2, 200 - Centro', 'Residencial', 3, 2, 'Disponivel', 2, 2),
(12, 180000.00, 0.00, 0, 'Rua 3, 300 - Centro', 'Investimento', 0, 0, 'Disponivel', 3, 3),
(13, 250000.00, 45.00, 1, 'Av 4, 400 - Santa Mônica', 'Comercial', 1, 0, 'Reservado', 5, 4),
(14, 900000.00, 400.00, 4, 'Rodovia 5, Km 10', 'Industrial', 0, 10, 'Disponivel', 6, 5),
(15, 600000.00, 200.00, 3, 'Estrada 6, s/n', 'Residencial', 4, 3, 'Vendido', 4, 6),
(16, 420000.00,  85.00, 2, 'Rua 7, 700 - Brasil',         'Residencial', 2, 1,  'Disponivel', 7, 1),
(17, 780000.00, 160.00, 3, 'Rua 8, 800 - Martins',        'Residencial', 3, 2,  'Disponivel', 10, 2),
(18, 210000.00,   0.00, 0, 'Rua 9, 900 - Centro',         'Investimento',0, 0,  'Disponivel', 8, 3),
(19, 310000.00,  55.00, 1, 'Av. 10, 1000 - Santa Mônica', 'Comercial',   1, 0,  'Reservado',  9, 4),
(20, 950000.00, 380.00, 4, 'Rodovia 11, Km 12',           'Industrial',  0,10,  'Disponivel', 11, 5),
(21, 650000.00, 210.00, 3, 'Estrada 12, s/n',             'Residencial', 4, 3,  'Disponivel', 12, 6),
(22, 590000.00, 110.00, 2, 'Rua 13, 130 - Centro',        'Residencial', 3, 1,  'Disponivel', 1, 7),
(23, 160000.00,  30.00, 1, 'Rua 14, 140 - Centro',        'Residencial', 1, 0,  'Disponivel', 2, 8),
(24, 400000.00,  60.00, 1, 'Av. 15, 1500 - Centro',       'Comercial',   0, 0,  'Disponivel', 5, 9);

-- 6) Proposta
INSERT INTO Proposta
(id_proposta, valor_ofertado, data_proposta, status, proposta_cliente, proposta_imovel)
VALUES
(100, 340000.00, '2026-01-10', 'Em Analise', 1, 10),
(101, 510000.00, '2026-01-11', 'Aprovada',   2, 11),
(102, 175000.00, '2026-01-12', 'Recusada',   3, 12),
(103, 240000.00, '2026-01-13', 'Em Analise', 4, 13),
(104, 880000.00, '2026-01-14', 'Cancelada',  5, 14),
(105, 590000.00, '2026-01-15', 'Aprovada',   6, 15),
(106, 410000.00, '2026-01-16', 'Em Analise', 7, 16),
(107, 770000.00, '2026-01-16', 'Em Analise', 8, 17),
(108, 205000.00, '2026-01-17', 'Aprovada',   9, 18),
(109, 300000.00, '2026-01-18', 'Recusada',   10, 19),
(110, 930000.00, '2026-01-19', 'Em Analise', 11, 20),
(111, 640000.00, '2026-01-20', 'Cancelada',  12, 21),
(112, 580000.00, '2026-01-21', 'Aprovada',   13, 22),
(113, 155000.00, '2026-01-22', 'Em Analise', 14, 23);

-- 7) Contrato
INSERT INTO Contrato
(id_contrato, tipo_contrato, data_inicio, data_fim, valor_fechado, contrato_proprietario, contrato_cliente, contrato_imovel)
VALUES
(200, 'Compra e Venda', '2026-01-20', NULL, 340000.00, 1, 1, 10),
(201, 'Compra e Venda', '2026-01-21', NULL, 510000.00, 2, 2, 11),
(202, 'Compra e Venda', '2026-01-22', NULL, 175000.00, 3, 3, 12),
(203, 'Locação',        '2026-01-23', '2027-01-23', 30000.00, 5, 4, 13),
(204, 'Compra e Venda', '2026-01-24', NULL, 880000.00, 6, 5, 14),
(205, 'Compra e Venda', '2026-01-25', NULL, 590000.00, 4, 6, 15),
(206, 'Compra e Venda', '2026-01-28', NULL, 410000.00, 7, 7, 16),
(207, 'Compra e Venda', '2026-01-29', NULL, 205000.00, 8, 9, 18),
(208, 'Locação',        '2026-02-01', '2027-02-01', 36000.00, 9, 10, 19),
(209, 'Compra e Venda', '2026-02-03', NULL, 580000.00, 1, 13, 22),
(210, 'Compra e Venda', '2026-02-05', NULL, 155000.00, 2, 14, 23);

-- 8) Contratos com mais de um corretor
INSERT INTO Contrato_Corretor (contrato_id, corretor_id) VALUES
(200, 1),
(200, 3),
(201, 2),
(202, 3),
(203, 4),
(204, 5),
(204, 6),
(205, 6),
(206, 7),
(207, 9),
(208, 8),
(209, 11),
(210, 12);

-- 8) Pagamento
INSERT INTO Pagamento
(id_pagamento, valor_pago, data_pagamento, forma, situacao, pagamento_contrato)
VALUES
(300, 5000.00,  '2026-01-26', 'PIX',    'Pago',      200),
(301, 10000.00, '2026-01-26', 'Cartão', 'Pago',      201),
(302, 2000.00,  '2026-01-27', 'Boleto', 'Pendente',  202),
(303, 2500.00,  '2026-02-01', 'Boleto', 'Pago',      203),
(304, 15000.00, '2026-02-05', 'TED',    'Cancelado', 204),
(305, 8000.00,  '2026-02-06', 'PIX',    'Pendente',  205),
(306, 15000.00, '2026-02-08', 'PIX',    'Pago',      206),
(307, 20000.00, '2026-02-08', 'TED',    'Pago',      209),
(308, 3000.00,  '2026-02-09', 'Boleto', 'Pendente',  208),
(309, 5000.00,  '2026-02-10', 'PIX',    'Pago',      207),
(310, 2500.00,  '2026-02-12', 'Cartão', 'Cancelado', 210);

-- SEÇÃO PARA VERIFICAR SE O POVOAMENTO FOI EXECUTADO CORRETAMENTE

SELECT * FROM Tipo_Imovel;
SELECT * FROM Proprietario;
SELECT * FROM Corretor;
SELECT * FROM Cliente;
SELECT * FROM Imovel;
SELECT * FROM Proposta;
SELECT * FROM Contrato;
SELECT * FROM Pagamento;
SELECT * FROM Contrato_Corretor;

SELECT COUNT(*) FROM Tipo_Imovel;
SELECT COUNT(*) FROM Proprietario;
SELECT COUNT(*) FROM Corretor;
SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM Imovel;
SELECT COUNT(*) FROM Proposta;
SELECT COUNT(*) FROM Contrato;
SELECT COUNT(*) FROM Pagamento;
SELECT COUNT(*) FROM Contrato_Corretor;

-- FAZ O UPDATE DO E-MAIL DO CLIENTE
UPDATE Cliente
SET email = 'guilherme@ex.com'
WHERE id_cliente = 1;

-- ATUALIZA O PERCENTUAL DE COMISSÃO DE UM CORRETOR
UPDATE Corretor
SET percentual_comissao = 6.75
WHERE id_corretor = 3;

-- ATUALIZA O STATUS DE IMÓVEL
UPDATE Imovel
SET status = 'Vendido'
WHERE codigo = 17;

-- REMOVE 3 PROPOSTAS
DELETE FROM Proposta WHERE id_proposta = 104;  -- Cancelada
DELETE FROM Proposta WHERE id_proposta = 111;  -- Cancelada
DELETE FROM Proposta WHERE id_proposta = 102;  -- Recusada

-- 1) Quantidade de imóveis e valor total por Proprietário.
SELECT Proprietario.nome, COUNT(Imovel.codigo) AS Quantidade_imoveis, SUM(Imovel.valor)
FROM Imovel
JOIN Proprietario ON Imovel.imovel_proprietario = Proprietario.id_proprietario
GROUP BY Proprietario.nome;
 
-- 2) Imovel resumido a tipo, descricao e valor.
SELECT Imovel.codigo, 
Imovel.valor AS Valor, 
tipo_imovel.nome_tipo AS Nome,
tipo_imovel.descricao AS Descricao
FROM Imovel, tipo_imovel
WHERE imovel.tipo_imovel = tipo_imovel.id_tipo;

-- 3) Situacao de pagamento de todos os contratos.
SELECT Contrato.id_contrato, Pagamento.situacao
FROM Contrato
LEFT JOIN Pagamento ON Contrato.id_contrato = Pagamento.pagamento_contrato;


-- 4) Faturamento por tipo de Imóvel.
SELECT tipo_imovel.nome_tipo AS Categoria, SUM(Contrato.valor_fechado) AS Faturamento_Total
FROM tipo_imovel 
JOIN Imovel ON Tipo_imovel.id_tipo = Imovel.tipo_imovel
JOIN Contrato ON Imovel.codigo = Contrato.contrato_imovel
GROUP BY tipo_imovel.nome_tipo
ORDER BY Faturamento_Total DESC;

-- 5) Esta consulta é utilizada para listar todos os clientes que não possuem contratos.
SELECT id_cliente
FROM Cliente
EXCEPT
SELECT contrato_cliente
FROM Contrato;

-- 6) Disponibilidade de imóveis acima da média.
SELECT endereco, finalidade,status, valor
FROM imovel
WHERE valor > (
	SELECT AVG(valor) FROM Imovel
)
ORDER BY valor DESC;

-- 7) Mostra todos os contratos entre cliente, corretor e imóvel.
SELECT
  Contrato.id_contrato,
  Contrato.tipo_contrato,
  Contrato.data_inicio,
  Contrato.data_fim,
  Contrato.valor_fechado,
  Cliente.nome AS cliente,
  Corretor.nome AS corretor,
  Imovel.codigo AS cod_imovel,
  Imovel.endereco
FROM Contrato
JOIN Cliente ON Contrato.contrato_cliente = Cliente.id_cliente
JOIN Imovel ON Contrato.contrato_imovel = Imovel.codigo
JOIN Contrato_Corretor ON Contrato.id_contrato = Contrato_Corretor.contrato_id
JOIN Corretor ON Contrato_Corretor.corretor_id = Corretor.id_corretor
ORDER BY Contrato.data_inicio;


-- 8) Mostra quantos contratos um corretor fechou e a média do valor fechado.
SELECT
  Corretor.id_corretor,
  Corretor.nome,
  COUNT(*) AS qtd_contratos,
  SUM(Contrato.valor_fechado) AS total_fechado,
  AVG(Contrato.valor_fechado) AS media_fechado
FROM Corretor
JOIN Contrato_Corretor ON Contrato_Corretor.corretor_id = Corretor.id_corretor
JOIN Contrato ON Contrato.id_contrato = Contrato_Corretor.contrato_id
GROUP BY Corretor.id_corretor, Corretor.nome
ORDER BY total_fechado DESC;


-- 9) Lista todos os clientes que já fizeram pelo menos uma proposta.
SELECT
  Cliente.id_cliente,
  Cliente.nome,
  Cliente.cpf,
  Cliente.telefone
FROM Cliente
WHERE EXISTS (
  SELECT 1
  FROM Proposta
  WHERE Proposta.proposta_cliente = Cliente.id_cliente
)
ORDER BY Cliente.nome;


-- 10) Lista todos os imóveis com contratos associados (LEFT OUTER JOIN no estilo antigo).
SELECT
  Imovel.codigo,
  Imovel.endereco,
  Imovel.status,
  Contrato.id_contrato,
  Contrato.tipo_contrato,
  Contrato.data_inicio
FROM Imovel
LEFT OUTER JOIN Contrato
  ON Contrato.contrato_imovel = Imovel.codigo
ORDER BY Imovel.codigo;


-- 11) Acha os imóveis que estão disponíveis e têm proposta em análise.
SELECT codigo
FROM Imovel
WHERE status = 'Disponivel'
INTERSECT
SELECT proposta_imovel
FROM Proposta
WHERE status = 'Em Analise'
ORDER BY codigo;


-- 12) Mostra todos os imóveis que não possuem contratos.
SELECT
  Imovel.codigo,
  Imovel.endereco,
  Imovel.status
FROM Imovel
WHERE Imovel.codigo NOT IN (
  SELECT Contrato.contrato_imovel
  FROM Contrato
)
ORDER BY Imovel.codigo;
