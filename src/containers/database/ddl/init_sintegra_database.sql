-- Criando a tabela cliente com melhorias
CREATE TABLE sintegra_module.cliente (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    razaosocial VARCHAR(255) NOT NULL,
    nomefantasia VARCHAR(255) NOT NULL,
    cpfcnpj VARCHAR(15) NOT NULL,
    ieprincipal VARCHAR(20) NOT NULL,
    ies JSONB NULL DEFAULT '[]',
    cep VARCHAR(10) NULL,
    endereco VARCHAR(200) NULL,
    numero VARCHAR(10) NULL,
    complemento VARCHAR(50) NULL,
    bairro VARCHAR(50) NULL,
    cidade VARCHAR(150) NULL,
    codcidade INTEGER NULL,
    uf VARCHAR(2) NULL,
    coduf VARCHAR(10) NULL,
    pais VARCHAR(100) NULL,
    telefone JSONB NULL DEFAULT '[]',
    iderp VARCHAR(50) NOT NULL,
    jsonerp jsonb null default '{}',
    criadoem timestamp default now(),
    editadoem timestamp default now(),
    
    CONSTRAINT cliente_pk PRIMARY KEY (id),
    CONSTRAINT cliente_cpfcnpj_uniq UNIQUE (cpfcnpj)
);

-- Criando índices para otimizar buscas frequentes
CREATE INDEX idx_cliente_cpfcnpj ON sintegra_module.cliente (cpfcnpj);
CREATE INDEX idx_cliente_codcidade ON sintegra_module.cliente (codcidade);
CREATE INDEX idx_cliente_iderp ON sintegra_module.cliente (iderp);

-- Criando tabela separada para módulos do cliente (Normalização)
CREATE TABLE sintegra_module.cliente_modulo (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    cliente_id UUID NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    dataativacao DATE default now(),
    valormodulo NUMERIC(10,2) NOT NULL DEFAULT 19.90,

    CONSTRAINT cliente_modulo_pk PRIMARY KEY (id),
    CONSTRAINT cliente_modulo_cliente_fk FOREIGN KEY (cliente_id) REFERENCES sintegra_module.cliente (id) ON DELETE CASCADE
);

-- Inserindo o módulo padrão para novos clientes
CREATE FUNCTION inserir_modulo_padrao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO sintegra_module.cliente_modulo (cliente_id, ativo, valormodulo)
    VALUES (NEW.id, TRUE, 19.90);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criando trigger para inserir o módulo padrão automaticamente
CREATE TRIGGER trg_cliente_insert
AFTER INSERT ON sintegra_module.cliente
FOR EACH ROW EXECUTE FUNCTION inserir_modulo_padrao();

create table sintegra_module.pessoa (
	id uuid default gen_random_uuid() not null,
	cliente_id uuid,
	iderp varchar(50) not null,
	nomefantasia varchar(255) null,
	razaosocial varchar(255) not null,
	ieprincipal varchar(20) null,
	ies JSONB NULL DEFAULT '[]',
	cpfcnpj varchar(20) not null,
	cep varchar(10) null,
	endereco varchar(200) null,
	numero varchar(10) null,
	complemento varchar(50) null,
	bairro varchar(50) null,
	cidade varchar(150) null,
	codcidade integer null,
	uf  varchar(2) null,
	coduf varchar(10) null,
	pais varchar(100) null,
	telefone jsonb null default '[]',
	jsonerp jsonb null default '{}',
	criadoem timestamp default now(),
	editadoem timestamp default now(),
	
	constraint pessoa_pk primary key (id),
	constraint pessoa_cpfcnpj_uniq unique (cpfcnpj)	
);

CREATE INDEX idx_pessoa_cpfcnpj ON sintegra_module.pessoa (cpfcnpj);
CREATE INDEX idx_pessoa_codcidade ON sintegra_module.pessoa (codcidade);
CREATE INDEX idx_pessoa_iderp ON sintegra_module.pessoa (iderp);

-- Criando a tabela notafiscal com melhorias
CREATE TABLE sintegra_module.notafiscal (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    tiponota VARCHAR(1) NOT NULL CHECK (tiponota IN ('T', 'P')), -- Apenas Entrada ('T') ou Saída ('P')
    cliente_id UUID NULL,
    pessoa_id UUID NULL,
    cpfcnpj_emissor VARCHAR(14) NOT NULL,
    cpfcnpj_destinatario VARCHAR(14) NOT NULL,
    ie_emissor VARCHAR(20) NULL,
    ie_destinatario VARCHAR(20) NULL,
    dataemissao DATE NOT NULL,
    uf_emissor VARCHAR(2) NULL,
    uf_destinatario VARCHAR(2) NULL,
    modelonota VARCHAR(2) NULL CHECK (modelonota IN ('55', '65')), -- Apenas NFe (55) ou NFCe (65)
    numeronfe VARCHAR(10) NULL,
    serienfe VARCHAR(10) NULL,
    chavenfe VARCHAR(44) UNIQUE NOT NULL,
    cfopprincipal VARCHAR(6) NULL,
    nfce BOOLEAN DEFAULT FALSE,
    jsonerp JSONB NULL DEFAULT '{}',
    criadoem TIMESTAMP DEFAULT NOW(),
    editadoem TIMESTAMP DEFAULT NOW(),

    CONSTRAINT notafiscal_pk PRIMARY KEY (id),
    CONSTRAINT notafiscal_cliente_fk FOREIGN KEY (cliente_id) REFERENCES sintegra_module.cliente (id) ON DELETE SET NULL,
    CONSTRAINT notafiscal_pessoa_fk FOREIGN KEY (pessoa_id) REFERENCES sintegra_module.pessoa (id) ON DELETE SET NULL
);

-- Criando índices para melhorar a performance nas buscas
CREATE INDEX idx_notafiscal_cpfcnpj_emissor ON sintegra_module.notafiscal (cpfcnpj_emissor);
CREATE INDEX idx_notafiscal_cpfcnpj_destinatario ON sintegra_module.notafiscal (cpfcnpj_destinatario);
CREATE INDEX idx_notafiscal_chavenfe ON sintegra_module.notafiscal (chavenfe);

-- Criando trigger para atualizar "editadoem" automaticamente
CREATE FUNCTION atualizar_editadoem()
RETURNS TRIGGER AS $$
BEGIN
    NEW.editadoem = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notafiscal_update
BEFORE UPDATE ON sintegra_module.notafiscal
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();

CREATE TRIGGER trg_pessoa_update
BEFORE UPDATE ON sintegra_module.pessoa
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();

CREATE TRIGGER trg_cliente_update
BEFORE UPDATE ON sintegra_module.cliente
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();

create table sintegra_module.produto(
	id UUID DEFAULT gen_random_uuid() NOT NULL,
	cliente_id uuid,
	iderp varchar(50) not null,
	codigointerno integer null,
	cfoppadrao varchar(4) null,
	ncm varchar(10) null,
	cest varchar(10) null,
	nome varchar(255) not null,
	apres varchar(15) null,
	jsonerp JSONB NULL DEFAULT '{}',
    criadoem TIMESTAMP DEFAULT NOW(),
    editadoem TIMESTAMP DEFAULT NOW(),

    CONSTRAINT produto_pk PRIMARY KEY (id),
    CONSTRAINT produto_cliente_fk FOREIGN KEY (cliente_id) REFERENCES sintegra_module.cliente (id) ON DELETE SET NULL
);
CREATE INDEX idx_produto_codigointerno ON sintegra_module.produto (codigointerno);
CREATE INDEX idx_produto_nome ON sintegra_module.produto (nome);
CREATE INDEX idx_produto_iderp ON sintegra_module.produto (iderp);
CREATE TRIGGER trg_produto_update
BEFORE UPDATE ON sintegra_module.produto
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();


CREATE TABLE sintegra_module.notafiscalitem (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    notafiscal_id uuid,
    produto_id uuid,
    idproderp varchar(50) not null,
    cfop varchar(4) null,
    ncm varchar(10) null, 
    cest varchar(10) null,
    nome varchar(255) null,
    aliqipi numeric(15,4) null default 0.0000,
    aliqicms numeric(15,4) null default 0.0000,
    icmsdesonerado numeric(15,4) null default 0.0000,
    icmsstbasecalc numeric(15,4) null default 0.0000,
    icmsbasecalc numeric(15,4) null default 0.0000,
    icmsvalor numeric(15,4) null default 0.0000,
    ipivalor numeric(15,4) null default 0.0000,
    icmssituacaotributaria varchar(10) null,
    qtde numeric(15,4) null default 0.0000,
    qtdeporpacote numeric(15,4) null default 0.0000,
    valortotal numeric(15,4) null default 0.0000,
    desctontototal numeric(15,4) null default 0.0000,  
    
    
    jsonerp JSONB NULL DEFAULT '{}',
    criadoem TIMESTAMP DEFAULT NOW(),
    editadoem TIMESTAMP DEFAULT NOW(),
    CONSTRAINT notafiscalitem_pk PRIMARY KEY (id),
    CONSTRAINT notafiscalitem_notafiscal_fk FOREIGN KEY (notafiscal_id) REFERENCES sintegra_module.notafiscal (id) ON DELETE SET null,
    CONSTRAINT notafiscalitem_produto_fk FOREIGN KEY (produto_id) REFERENCES sintegra_module.produto (id) ON DELETE SET null
);
CREATE INDEX idx_notafiscalitem_cfop ON sintegra_module.notafiscalitem (cfop);
CREATE INDEX idx_notafiscalitem_nome ON sintegra_module.notafiscalitem (nome);
CREATE INDEX idx_notafiscalitem_ncm ON sintegra_module.notafiscalitem (ncm);
CREATE TRIGGER trg_notafiscalitem_update
BEFORE UPDATE ON sintegra_module.notafiscalitem
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();

create table sintegra_module.venda(
	id UUID DEFAULT gen_random_uuid() NOT NULL,
	cliente_id uuid,
	notafiscal_id uuid null,
	iderp varchar(50) not null,
	codigointerno integer null,
	cfoppadrao varchar(4) null,
	valortotal numeric(15,4) default 0,
	desctontototal numeric(15,4) default 0,
	
	jsonerp JSONB NULL DEFAULT '{}',
    criadoem TIMESTAMP DEFAULT NOW(),
    editadoem TIMESTAMP DEFAULT NOW(),

    CONSTRAINT venda_pk PRIMARY KEY (id),
    CONSTRAINT venda_cliente_fk FOREIGN KEY (cliente_id) REFERENCES sintegra_module.cliente (id) ON DELETE SET NULL
);
CREATE INDEX idx_venda_codigointerno ON sintegra_module.venda (codigointerno);
CREATE INDEX idx_venda_cfoppadrao ON sintegra_module.venda (cfoppadrao);
CREATE INDEX idx_venda_iderp ON sintegra_module.venda (iderp);
CREATE TRIGGER trg_venda_update
BEFORE UPDATE ON sintegra_module.venda
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();


CREATE TABLE sintegra_module.vendaproduto (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    venda_id uuid,
    produto_id uuid,
    idproderp varchar(50) not null,
    cfop varchar(4) null,
    ncm varchar(10) null, 
    cest varchar(10) null,
    nome varchar(255) null,
    aliqipi numeric(15,4) null default 0.0000,
    aliqicms numeric(15,4) null default 0.0000,
    icmsdesonerado numeric(15,4) null default 0.0000,
    icmsstbasecalc numeric(15,4) null default 0.0000,
    icmsbasecalc numeric(15,4) null default 0.0000,
    icmsvalor numeric(15,4) null default 0.0000,
    ipivalor numeric(15,4) null default 0.0000,
    icmssituacaotributaria varchar(10) null,
    qtde numeric(15,4) null default 0.0000,
    qtdeporpacote numeric(15,4) null default 0.0000,
    valortotal numeric(15,4) null default 0.0000,
    desctontototal numeric(15,4) null default 0.0000,  
    
    
    jsonerp JSONB NULL DEFAULT '{}',
    criadoem TIMESTAMP DEFAULT NOW(),
    editadoem TIMESTAMP DEFAULT NOW(),
    CONSTRAINT vendaproduto_pk PRIMARY KEY (id),
    CONSTRAINT vendaproduto_notafiscal_fk FOREIGN KEY (venda_id) REFERENCES sintegra_module.venda (id) ON DELETE SET null,
    CONSTRAINT vendaproduto_produto_fk FOREIGN KEY (produto_id) REFERENCES sintegra_module.produto (id) ON DELETE SET null
);
CREATE INDEX idx_vendaproduto_cfop ON sintegra_module.vendaproduto (cfop);
CREATE INDEX idx_vendaproduto_nome ON sintegra_module.vendaproduto (nome);
CREATE INDEX idx_vendaproduto_ncm ON sintegra_module.vendaproduto (ncm);
CREATE TRIGGER trg_vendaproduto_update
BEFORE UPDATE ON sintegra_module.vendaproduto
FOR EACH ROW EXECUTE FUNCTION atualizar_editadoem();