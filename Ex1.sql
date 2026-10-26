CREATE DATABASE Clinica;
GO
USE Clinica;
GO

-- Tabela Paciente
CREATE TABLE Paciente (
    Num_Beneficiario  INT           NOT NULL,
    Nome              VARCHAR(100)  NOT NULL,
    Logradouro        VARCHAR(200),
    Numero            INT,
    CEP               CHAR(8),
    Complemento       VARCHAR(255),
    Telefone          VARCHAR(11),
    CONSTRAINT PK_Paciente PRIMARY KEY (Num_Beneficiario)
);
GO

-- Tabela Especialidade
CREATE TABLE Especialidade (
    ID              INT           NOT NULL,
    Especialidade   VARCHAR(10)   NOT NULL,
    CONSTRAINT PK_Especialidade PRIMARY KEY (ID)
);
GO

ALTER TABLE Especialidade ALTER COLUMN Especialidade VARCHAR(30) NOT NULL;
GO

-- Tabela Medico
CREATE TABLE Medico (
    Codigo             INT           NOT NULL,
    Nome               VARCHAR(100)  NOT NULL,
    Logradouro         VARCHAR(200),
    Numero             INT,
    CEP                CHAR(8),
    Complemento        VARCHAR(255),
    Contato            VARCHAR(11),
    EspecialidadeId    INT,
    CONSTRAINT PK_Medico PRIMARY KEY (Codigo),
    CONSTRAINT FK_Medico_Especialidade
        FOREIGN KEY (EspecialidadeId) REFERENCES Especialidade(ID)
);
GO


ALTER TABLE Medico ADD dia_atendimento VARCHAR(10);
GO

UPDATE Medico SET dia_atendimento = '2ª feira' WHERE Codigo = 100001;
UPDATE Medico SET dia_atendimento = '4ª feira' WHERE Codigo = 100002;
UPDATE Medico SET dia_atendimento = '2ª feira' WHERE Codigo = 100003;
UPDATE Medico SET dia_atendimento = '5ª feira' WHERE Codigo = 100004;

-- Ou tudo em um único UPDATE condicional:
UPDATE Medico
SET dia_atendimento = CASE Codigo
        WHEN 100001 THEN '2ª feira'
        WHEN 100002 THEN '4ª feira'
        WHEN 100003 THEN '2ª feira'
        WHEN 100004 THEN '5ª feira'
    END;
GO

-- b) Excluir a especialidade Pediatra (não está disponível)
DELETE FROM Especialidade WHERE Especialidade = 'Pediatra';
-- equivalente: DELETE FROM Especialidade WHERE ID = 4;

-- c) Renomear a coluna dia_atendimento para dia_semana_atendimento
EXEC sp_rename 'Medico.dia_atendimento', 'dia_semana_atendimento', 'COLUMN';
GO

-- d) Atualizar endereço do médico Lucas Borges
UPDATE Medico
SET Logradouro  = 'Av. Bras Leme',
    Numero      = 876,
    Complemento = 'Apto 504',
    CEP         = '02122000'
WHERE Nome = 'Lucas Borges';
GO

-- e) Mudar o tipo da coluna Observacao da consulta para VARCHAR(200)
ALTER TABLE Consulta ALTER COLUMN Observacao VARCHAR(200);
GO

-- Tabela Consulta
CREATE TABLE Consulta (
    PacienteNum_Beneficiario  INT            NOT NULL,
    MedicoCodigo              INT            NOT NULL,
    Data_hora                 TIMESTAMP      NOT NULL,
    Observacao                VARCHAR(255),
    CONSTRAINT PK_Consulta PRIMARY KEY (PacienteNum_Beneficiario, MedicoCodigo, Data_hora),
    CONSTRAINT FK_Consulta_Paciente
        FOREIGN KEY (PacienteNum_Beneficiario) REFERENCES Paciente(Num_Beneficiario),
    CONSTRAINT FK_Consulta_Medico
        FOREIGN KEY (MedicoCodigo) REFERENCES Medico(Codigo)
);
GO

-- Especialidade
INSERT INTO Especialidade (ID, Especialidade) VALUES
(1, 'Otorrinolaringologista'), 
(2, 'Urologista'),
(3, 'Geriatria'),
(4, 'Pediatra');

-- Paciente
INSERT INTO Paciente (Num_Beneficiario, Nome, Logradouro, Numero, CEP, Complemento, Telefone)
VALUES (99901, 'Washington Silva', 'R. Anhaia', NULL, '02345000', 'Casa', '922229999'),
       (99902, 'Luis Ricardo', 'R. Voluntários da Pátria', 2251, '03254010', 'Bloco B. Apto 25', '923450987'),
       (99903, 'Maria Elisa', 'Av. Agulha de Haia', 1188, '06987020', 'Apto 1208', '912348765'),
       (99904, 'José Araujo', 'R. XV de Novembro', 18, '03678000', 'Casa', '945674312'),
       (99905, 'Joana Paula', 'R. 7 de Abril', 97, '01214000', 'Conjunto 3 - Apto 801', '912095674');
-- Medico
INSERT INTO Medico (Codigo, Nome, Logradouro, Numero, CEP, Complemento, Contato, EspecialidadeId) VALUES
(100001, 'Ana Paula',      'R. 7 de Setembro',     256, '03698000', 'Casa',        '915689456', 1),
(100002, 'Maria Aparecida','Av. Brasil',            32, '02145070', 'Casa',        '923235454', 1),
(100003, 'Lucas Borges',   'Av. do Estado',       3210, '05241000', 'Apto 205',    '963698585', 2),
(100004, 'Gabriel Oliveira','Av. Dom Helder Camara', 350, '01450000', 'Apto 602',  '932458743', 3);

-- Consulta
INSERT INTO Consulta (PacienteNum_Beneficiario, MedicoCodigo, Data_hora, Observacao) VALUES
(99901, 100002, '2021-09-04 13:20:00', 'Infecção Urina'),
(99902, 100003, '2021-09-04 13:15:00', 'Gripe'),
(99901, 100001, '2021-09-04 12:30:00', 'Infecção Garganta');

DROP TABLE Consulta;
GO
CREATE TABLE Consulta (
    PacienteNum_Beneficiario  INT            NOT NULL,
    MedicoCodigo              INT            NOT NULL,
    Data_hora                 DATETIME2      NOT NULL,
    Observacao                VARCHAR(255),
    CONSTRAINT PK_Consulta PRIMARY KEY (PacienteNum_Beneficiario, MedicoCodigo, Data_hora),
    CONSTRAINT FK_Consulta_Paciente FOREIGN KEY (PacienteNum_Beneficiario) REFERENCES Paciente(Num_Beneficiario),
    CONSTRAINT FK_Consulta_Medico   FOREIGN KEY (MedicoCodigo) REFERENCES Medico(Codigo)
);
GO

