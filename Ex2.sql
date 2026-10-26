CREATE DATABASE Livraria;
GO
USE Livraria;
GO
DROP DATABASE Livraria;
GO

-- Tabela Autor
CREATE TABLE Autor (
    ID_Autor    INT           IDENTITY(2351, 1) NOT NULL,
    Nome        VARCHAR(100)  NOT NULL,
    Data_Nasc   DATE          NOT NULL,
    Pais_Nasc   VARCHAR(25)   NOT NULL,
    Biografia   VARCHAR(255),
    CONSTRAINT PK_Autor PRIMARY KEY (ID_Autor),
    CONSTRAINT UQ_Autor_Nome UNIQUE (Nome),
    CONSTRAINT CK_Autor_Pais CHECK (Pais_Nasc IN ('Brasil', 'Estados Unidos', 'Inglaterra', 'Alemanha'))
);
GO

-- Tabela Editora
CREATE TABLE Editora (
    ID_Editora    INT           IDENTITY(491, 16) NOT NULL,
    Nome          VARCHAR(70)   NOT NULL,
    Telefone      CHAR(11)      NOT NULL,
    Logradouro    VARCHAR(200),
    Numero_Endereco INT         NOT NULL,
    CEP_Endereco  CHAR(8)       NOT NULL,
    Complemento   VARCHAR(255),
    CONSTRAINT PK_Editora PRIMARY KEY (ID_Editora),
    CONSTRAINT UQ_Editora_Nome UNIQUE (Nome),
    CONSTRAINT CK_Editora_Telefone CHECK (Telefone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_Editora_Numero CHECK (Numero_Endereco > 0),
    CONSTRAINT CK_Editora_CEP CHECK (CEP_Endereco LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- Tabela Livro
CREATE TABLE Livro (
    Codigo    INT           IDENTITY(100001, 100) NOT NULL,
    Nome      VARCHAR(200)  NOT NULL,
    Lingua    VARCHAR(10)   DEFAULT 'PT-BR' NOT NULL,
    Ano       INT           NOT NULL,
    CONSTRAINT PK_Livro PRIMARY KEY (Codigo),
    CONSTRAINT UQ_Livro_Nome UNIQUE (Nome),
    CONSTRAINT CK_Livro_Lingua CHECK (Lingua = 'PT-BR'),
    CONSTRAINT CK_Livro_Ano CHECK (Ano >= 1990)
);
GO

-- Tabela Edicao
CREATE TABLE Edicao (
    ISBN        CHAR(13)      NOT NULL,
    Preco       DECIMAL(4, 2) NOT NULL,
    Ano         INT           NOT NULL,
    Numero_Paginas INT         NOT NULL,
    Qtd_Esqque  INT           NULL,
    CONSTRAINT PK_Edicao PRIMARY KEY (ISBN),
    CONSTRAINT FK_Edicao_Livro FOREIGN KEY (ISBN) REFERENCES Livro(Codigo),
    CONSTRAINT CK_Edicao_Preco CHECK (Preco >= 0),
    CONSTRAINT CK_Edicao_Anio CHECK (Ano >= 1993),
    CONSTRAINT CK_Edicao_Paginas CHECK (Numero_Paginas >= 15)
);
GO

-- Tabela Livro_Autor 
CREATE TABLE Livro_Autor (
    LivroCodigo   INT NOT NULL,
    AutorID_Autor INT NOT NULL,
    CONSTRAINT PK_Livro_Autor PRIMARY KEY (LivroCodigo, AutorID_Autor),
    CONSTRAINT FK_LA_Livro FOREIGN KEY (LivroCodigo) REFERENCES Livro(Codigo),
    CONSTRAINT FK_LA_Autor FOREIGN KEY (AutorID_Autor) REFERENCES Autor(ID_Autor)
);
GO

-- Tabela Editora_Edicao 
CREATE TABLE Editora_Edicao (
    EditoraID_Editora INT NOT NULL,
    ISBN              CHAR(13) NOT NULL,
    CONSTRAINT PK_Editora_Edicao PRIMARY KEY (EditoraID_Editora, ISBN),
    CONSTRAINT FK_EE_Editora FOREIGN KEY (EditoraID_Editora) REFERENCES Editora(ID_Editora),
    CONSTRAINT FK_EE_Edicao FOREIGN KEY (ISBN) REFERENCES Edicao(ISBN)
);
GO