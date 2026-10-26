CREATE DATABASE Mecanica;
GO
USE Mecanica;
GO

-- Tabela Cliente
CREATE TABLE Cliente (
    ID              INT           NOT NULL,
    Nome            VARCHAR(100)  NOT NULL,
    Logradouro      VARCHAR(200),
    Numero          INT,
    CEP             CHAR(8),
    Complemento     VARCHAR(255),
    CONSTRAINT PK_Cliente PRIMARY KEY (ID),
    CONSTRAINT CK_Cliente_Numero CHECK (Numero >= 0),
    CONSTRAINT CK_Cliente_CEP CHECK (CEP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- Tabela Funcionario
CREATE TABLE Funcionario (
    ID                      INT           IDENTITY(101, 1) NOT NULL,
    Nome                    VARCHAR(100)  NOT NULL,
    Logradouro              VARCHAR(200),
    Numero                  INT,
    Telefone                VARCHAR(11),
    CategoriaHabilitacao    CHAR(1),
    CategoriaID             INT,
    CONSTRAINT PK_Funcionario PRIMARY KEY (ID),
    CONSTRAINT CK_Func_Numero CHECK (Numero >= 0),
    CONSTRAINT CK_Func_CEP CHECK (Logradouro IS NULL OR LEN(Logradouro) > 0),
    CONSTRAINT CK_Func_Telefone CHECK (Telefone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
                                    OR Telefone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_Func_Categoria CHECK (CategoriaHabilitacao IN ('A','B','C','D','E'))
);
GO

-- Tabela Categoria
CREATE TABLE Categoria (
    ID          INT           NOT NULL,
    Valor_Hora  DECIMAL(4,2)  NOT NULL,
    CONSTRAINT PK_Categoria PRIMARY KEY (ID),
    CONSTRAINT CK_Categoria_Valor CHECK (
        (ID = 0 AND Valor_Hora > 15.00) OR
        (ID = 1 AND Valor_Hora > 25.00) OR
        (ID = 2 AND Valor_Hora > 35.00) OR
        (ID = 3 AND Valor_Hora > 50.00)
    )
);
GO

-- Tabela Peca
CREATE TABLE Peca (
    ID          INT           IDENTITY(3411, 7) NOT NULL,
    Nome        VARCHAR(30)   NOT NULL UNIQUE,
    Preco       DECIMAL(4,2)  NOT NULL,
    Estoque     INT           NOT NULL,
    CONSTRAINT PK_Peca PRIMARY KEY (ID),
    CONSTRAINT CK_Peca_Preco CHECK (Preco >= 0),
    CONSTRAINT CK_Peca_Estoque CHECK (Estoque >= 10)
);
GO

-- Tabela Placa
CREATE TABLE Placa (
    Placa             CHAR(7)       NOT NULL,
    Marca             VARCHAR(30),
    Modelo            VARCHAR(30),
    Cor               VARCHAR(15),
    Ano_Fabricacao    INT           NOT NULL,
    Ano_Modelo        INT,
    Data_Aquisicao    DATE,
    ClienteID         INT,
    CONSTRAINT PK_Placa PRIMARY KEY (Placa),
    CONSTRAINT FK_Placa_Cliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ID),
    CONSTRAINT CK_Placa_Fabricacao CHECK (Ano_Fabricacao > 1997),
    CONSTRAINT CK_Placa_Modelo CHECK (Ano_Modelo IS NULL OR Ano_Modelo >= Ano_Fabricacao + 1),
    CONSTRAINT CK_Placa_Formato CHECK (Placa LIKE '[A-Z][A-Z][A-Z][0-9][A-Z/N][0-9][0-9][0-9]')
);
GO

-- Tabela VeiculoPeca (Reparo - M:M entre Placa e Peca)
CREATE TABLE VeiculoPeca (
    Placa           CHAR(7)       NOT NULL,
    FuncionarioID   INT           NOT NULL,
    Data            DATE          NOT NULL DEFAULT GETDATE(),
    Custo_Total     DECIMAL(4,2)  NOT NULL,
    Tempo           INT           NOT NULL,
    PecaID          INT           NOT NULL,
    CONSTRAINT PK_VeiculoPeca PRIMARY KEY (Placa, FuncionarioID, PecaID),
    CONSTRAINT FK_VP_Placa FOREIGN KEY (Placa) REFERENCES Placa(Placa),
    CONSTRAINT FK_VP_Funcionario FOREIGN KEY (FuncionarioID) REFERENCES Funcionario(ID),
    CONSTRAINT FK_VP_Peca FOREIGN KEY (PecaID) REFERENCES Peca(ID),
    CONSTRAINT CK_VP_Data CHECK (Data <= GETDATE()),
    CONSTRAINT CK_VP_Custo CHECK (Custo_Total >= 0),
    CONSTRAINT CK_VP_Tempo CHECK (Tempo >= 0)
);
GO

-- Adicionando FK de Categoria no Funcionario (após criar Categoria)
ALTER TABLE Funcionario
ADD CONSTRAINT FK_Func_Categoria FOREIGN KEY (CategoriaID) REFERENCES Categoria(ID);
GO
