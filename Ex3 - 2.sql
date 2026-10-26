CREATE DATABASE Maternidade;
GO
USE Maternidade;
GO

-- Tabela Mae
CREATE TABLE Mae (
    ID                INT           IDENTITY(1001, 1) NOT NULL,
    Nome              VARCHAR(60)   NOT NULL,
    Logradouro_Endereco VARCHAR(100),
    Numero_Endereco   INT,
    CEP_Endereco      CHAR(8),
    Complemento_Endereco VARCHAR(200),
    Telefone          CHAR(10),
    Data_Nasc         DATE,
    CONSTRAINT PK_Mae PRIMARY KEY (ID),
    CONSTRAINT CK_Mae_Numero CHECK (Numero_Endereco >= 0),
    CONSTRAINT CK_Mae_CEP CHECK (CEP_Endereco LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_Mae_Telefone CHECK (Telefone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- Tabela Medico
CREATE TABLE Medico (
    CRM_Numero    INT           NOT NULL,
    CRM_UF        CHAR(2)       NOT NULL,
    Nome          VARCHAR(60)   NOT NULL,
    Telefone_Celular CHAR(11)   NOT NULL,
    Especialidade VARCHAR(30),
    CONSTRAINT PK_Medico PRIMARY KEY (CRM_Numero, CRM_UF),
    CONSTRAINT UQ_Medico_Celular UNIQUE (Telefone_Celular),
    CONSTRAINT CK_Medico_Celular CHECK (Telefone_Celular LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- Tabela Bebe
CREATE TABLE Bebe (
    ID_Bebe     INT           IDENTITY(1, 1) NOT NULL,
    Nome        VARCHAR(60)   NOT NULL,
    Data_Nasc   DATE          NOT NULL DEFAULT GETDATE(),
    Altura      DECIMAL(7,2),
    Peso        DECIMAL(4,3),
    MaeID_Mae   INT           NOT NULL,
    CONSTRAINT PK_Bebe PRIMARY KEY (ID_Bebe),
    CONSTRAINT FK_Bebe_Mae FOREIGN KEY (MaeID_Mae) REFERENCES Mae(ID),
    CONSTRAINT CK_Bebe_DataNasc CHECK (Data_Nasc <= GETDATE()),
    CONSTRAINT CK_Bebe_Altura CHECK (Altura >= 0),
    CONSTRAINT CK_Bebe_Peso CHECK (Peso >= 0)
);
GO

-- Tabela Bebe_Medico (Faz Parto - M:M)
CREATE TABLE Bebe_Medico (
    BebeID_Bebe       INT   NOT NULL,
    MedicoCRM_Numero  INT   NOT NULL,
    MedicoCRM_UF      CHAR(2) NOT NULL,
    CONSTRAINT PK_Bebe_Medico PRIMARY KEY (BebeID_Bebe, MedicoCRM_Numero, MedicoCRM_UF),
    CONSTRAINT FK_BM_Bebe FOREIGN KEY (BebeID_Bebe) REFERENCES Bebe(ID_Bebe),
    CONSTRAINT FK_BM_Medico FOREIGN KEY (MedicoCRM_Numero, MedicoCRM_UF) 
        REFERENCES Medico(CRM_Numero, CRM_UF)
);
GO