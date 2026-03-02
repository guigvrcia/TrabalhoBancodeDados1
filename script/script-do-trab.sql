DROP SCHEMA Imobiliaria CASCADE;
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
	contrato_corretor INT NOT NULL,
    CONSTRAINT fk_contrato_proprietario FOREIGN KEY (contrato_proprietario) REFERENCES Proprietario(id_proprietario),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (contrato_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_contrato_imovel FOREIGN KEY (contrato_imovel) REFERENCES Imovel (codigo),
	CONSTRAINT fk_contrato_corretor FOREIGN KEY (contrato_corretor) REFERENCES Corretor(id_corretor)
	
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

-- =========================
-- POVOAMENTO (INSERTs)
-- =========================

-- 1) Tipo_Imovel
INSERT INTO Tipo_Imovel (id_tipo, nome_tipo, descricao) VALUES
(1, 'Apartamento', 'Apartamento residencial'),
(2, 'Casa', 'Casa residencial'),
(3, 'Terreno', 'Terreno urbano'),
(4, 'Sala Comercial', 'Imóvel para comércio/serviços'),
(5, 'Galpão', 'Galpão industrial/armazenagem'),
(6, 'Chácara', 'Imóvel rural de lazer');

-- 2) Proprietario
INSERT INTO Proprietario (id_proprietario, nome, cpf, cnpj, email, endereco, telefone) VALUES
(1, 'Ana Souza', '111.111.111-11', NULL, 'ana@ex.com', 'Rua A, 10 - Centro', '34 99901-0001'),
(2, 'Bruno Lima', '222.222.222-22', NULL, 'bruno@ex.com', 'Rua B, 20 - Centro', '34 99901-0002'),
(3, 'Carla Rocha', '333.333.333-33', NULL, 'carla@ex.com', 'Rua C, 30 - Santa Mônica', '34 99901-0003'),
(4, 'Diego Alves', '444.444.444-44', NULL, 'diego@ex.com', 'Rua D, 40 - Santa Mônica', '34 99901-0004'),
(5, 'Imob Invest Ltda', NULL, '11.111.111/0001-11', 'invest@ex.com', 'Av. Rondon, 1000', '34 3230-0005'),
(6, 'Holding Patrimônio S/A', NULL, '22.222.222/0001-22', 'holding@ex.com', 'Av. Segismundo, 2000', '34 3230-0006');

-- 3) Corretor
INSERT INTO Corretor (id_corretor, cpf, nome, creci, email, telefone, percentual_comissao) VALUES
(1, '555.555.555-55', 'Rafael Santos', 'MG12345', 'rafael@ex.com', '34 99910-0101', 6.00),
(2, '666.666.666-66', 'Marina Costa', 'MG23456', 'marina@ex.com', '34 99910-0102', 5.50),
(3, '777.777.777-77', 'João Pedro', 'MG34567', 'joao@ex.com', '34 99910-0103', 6.50),
(4, '888.888.888-88', 'Paula Nunes', 'MG45678', 'paula@ex.com', '34 99910-0104', 5.00),
(5, '999.999.999-99', 'Lucas Freitas', 'MG56789', 'lucas@ex.com', '34 99910-0105', 6.00),
(6, '000.000.000-00', 'Fernanda Melo', 'MG67890', 'fer@ex.com', '34 99910-0106', 5.75);

-- 4) Cliente
INSERT INTO Cliente (id_cliente, cpf, nome, email, telefone) VALUES
(1, '101.101.101-10', 'Guilherme Antonio', 'gui@ex.com', '34 99911-1101'),
(2, '202.202.202-20', 'Maria Beatriz', 'maria@ex.com', '34 99911-1102'),
(3, '303.303.303-30', 'Pedro Carvalho', 'pedro@ex.com', '34 99911-1103'),
(4, '404.404.404-40', 'Julia Duarte', 'julia@ex.com', '34 99911-1104'),
(5, '505.505.505-50', 'Renato Evaristo', 'renato@ex.com', '34 99911-1105'),
(6, '606.606.606-60', 'Bianca Ferreira', 'bianca@ex.com', '34 99911-1106');

-- 5) Imovel
INSERT INTO Imovel
(codigo, valor, metragem, banheiros, endereco, finalidade, num_quarto, vaga_garagem, status, imovel_proprietario, tipo_imovel)
VALUES
(10, 350000.00, 70.00, 2, 'Rua 1, 100 - Centro', 'Residencial', 2, 1, 'Disponivel', 1, 1),
(11, 520000.00, 120.00, 3, 'Rua 2, 200 - Centro', 'Residencial', 3, 2, 'Disponivel', 2, 2),
(12, 180000.00, 0.00, 0, 'Rua 3, 300 - Centro', 'Investimento', 0, 0, 'Disponivel', 3, 3),
(13, 250000.00, 45.00, 1, 'Av 4, 400 - Santa Mônica', 'Comercial', 1, 0, 'Reservado', 5, 4),
(14, 900000.00, 400.00, 4, 'Rodovia 5, Km 10', 'Industrial', 0, 10, 'Disponivel', 6, 5),
(15, 600000.00, 200.00, 3, 'Estrada 6, s/n', 'Residencial', 4, 3, 'Vendido', 4, 6);

-- 6) Proposta 
INSERT INTO Proposta
(id_proposta, valor_ofertado, data_proposta, status, proposta_cliente, proposta_imovel)
VALUES
(100, 340000.00, '2026-01-10', 'Em Analise', 1, 10),
(101, 510000.00, '2026-01-11', 'Aprovada', 2, 11),
(102, 175000.00, '2026-01-12', 'Recusada', 3, 12),
(103, 240000.00, '2026-01-13', 'Em Analise', 4, 13),
(104, 880000.00, '2026-01-14', 'Cancelada', 5, 14),
(105, 590000.00, '2026-01-15', 'Aprovada', 6, 15);

-- 7) Contrato 
INSERT INTO Contrato
(id_contrato, tipo_contrato, data_inicio, data_fim, valor_fechado, contrato_proprietario, contrato_cliente, contrato_imovel, contrato_corretor)
VALUES
(200, 'Compra e Venda', '2026-01-20', NULL, 340000.00, 1, 1, 10, 1),
(201, 'Compra e Venda', '2026-01-21', NULL, 510000.00, 2, 2, 11, 2),
(202, 'Compra e Venda', '2026-01-22', NULL, 175000.00, 3, 3, 12, 3),
(203, 'Locação',        '2026-01-23', '2027-01-23', 30000.00, 5, 4, 13, 4),
(204, 'Compra e Venda', '2026-01-24', NULL, 880000.00, 6, 5, 14, 5),
(205, 'Compra e Venda', '2026-01-25', NULL, 590000.00, 4, 6, 15, 6);

-- 8) Pagamento
INSERT INTO Pagamento
(id_pagamento, valor_pago, data_pagamento, forma, situacao, pagamento_contrato)
VALUES
(300, 5000.00,  '2026-01-26', 'PIX',    'Pago',     200),
(301, 10000.00, '2026-01-26', 'Cartão', 'Pago',     201),
(302, 2000.00,  '2026-01-27', 'Boleto', 'Pendente', 202),
(303, 2500.00,  '2026-02-01', 'Boleto', 'Pago',     203),
(304, 15000.00, '2026-02-05', 'TED',    'Cancelado',204),
(305, 8000.00,  '2026-02-06', 'PIX',    'Pendente', 205);

SELECT 'Corretor' tabela, COUNT(*) FROM Corretor
UNION ALL SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL SELECT 'Proprietario', COUNT(*) FROM Proprietario
UNION ALL SELECT 'Tipo_Imovel', COUNT(*) FROM Tipo_Imovel
UNION ALL SELECT 'Imovel', COUNT(*) FROM Imovel
UNION ALL SELECT 'Proposta', COUNT(*) FROM Proposta
UNION ALL SELECT 'Contrato', COUNT(*) FROM Contrato
UNION ALL SELECT 'Pagamento', COUNT(*) FROM Pagamento;
