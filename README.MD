# Sistema de Gerenciamento de Tarefas (Prova Técnica Delphi Senior)

## Sobre o Projeto

Solução completa para a prova técnica da BDMG composta por:
- **Serviço REST** (Horse + ADO)
- **Aplicação VCL Cliente**

## Tecnologias Utilizadas

- **Delphi 12 Community Edition**
- **Horse** (framework web)
- **RESTRequest4Delphi** (cliente REST)
- **ADO** (acesso ao SQL Server)
- **Basic Authentication**
- **Jhonson** (serialização JSON)
- **RESTRequest4D** + **TStringGrid** (cliente)

## Como Executar o Ambiente

### 1. Banco de Dados (SQL Server)

Execute os scripts na ordem abaixo:

```CREATE DATABASE BDMG_Tarefas;```

```USE BDMG_Tarefas;```

```
CREATE TABLE Tarefas (
    Id              INT IDENTITY(1,1) PRIMARY KEY,
    Titulo          VARCHAR(150) NOT NULL,
    Descricao       VARCHAR(2000) NULL,
    Status          VARCHAR(20)  NOT NULL DEFAULT 'Pendente', -- Pendente, EmAndamento, Concluida
    Prioridade      INT          NOT NULL CHECK (Prioridade BETWEEN 1 AND 5),
    DataCriacao     DATETIME     DEFAULT GETDATE(),
    DataConclusao   DATETIME     NULL
);
```

### 2. Editar os arquivos .ini se necessário
> bdmg\servico\bin\config.ini

  Obs.: se `ConectarPeloWindows` estiver com o valor 1, a conexão ao SQLServer será feita via Windows Authentication, caso contrário sera utilizado os valores informados em `UserName` e `Password`;

> bdmg\cliente\bin\appconfig.ini


## TO-DO
- Faltou implementar:
  - a paginação da consulta na grid
  - melhorar a exibição de dados na funcionalidade "Alterar Status"
  - utilizar uma grid melhor que pudesser ser feito ordenação e pesquisa nos registros.
