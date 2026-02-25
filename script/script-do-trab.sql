CREATE SCHEMA Imobiliaria;
SET search_path TO Imobiliaria;

CREATE TABLE Corretor(
    id_corretor INT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    creci VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(50),
    telefone VARCHAR(15) NOT NULL,
    percentual_comissao DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Cliente (
	id_cliente INT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    telefone VARCHAR(15) NOT NULL
);

CREATE TABLE Proprietario(
    id_proprietario INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    cnpj VARCHAR(14) UNIQUE,
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
