unit uTarefaRepository;

interface

uses
  Data.DB,
  System.JSON,
  System.SysUtils,
  System.DateUtils,
  uTarefaModel;

type
  TTarefaRepository = class
  public
    function ListarPaginado(APage, ALimit: Integer; out ATotal: Integer): TJSONArray;
    procedure Incluir(ATarefa: TTarefaModel);
    procedure AtualizarStatus(AId: Integer; AStatus: string);
    procedure Excluir(AId: Integer);

    // Desafio SQL
    function TotalTarefas: Integer;
    function MediaPrioridadePendentes: Double;
    function QuantidadeConcluidasUltimos7Dias: Integer;
  end;

implementation

uses
  System.Variants, Data.Win.ADODB, uConexaoBanco;

function TTarefaRepository.ListarPaginado(APage, ALimit: Integer; out ATotal: Integer): TJSONArray;
var
  Conn: TADOConnection;
  Qry: TADOQuery;
  Offset: Integer;
begin
  Result := TJSONArray.Create;
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;

    // Total de registros
    Qry.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tarefas';
    Qry.Open;
    ATotal := Qry.FieldByName('Total').AsInteger;

    // Busca paginada
    Offset := (APage - 1) * ALimit;
    Qry.Close;
    Qry.SQL.Text :=
      'SELECT Id, Titulo, Descricao, Status, Prioridade, DataCriacao, DataConclusao ' +
      'FROM Tarefas ' +
      'ORDER BY DataCriacao DESC ' +
      'OFFSET :Offset ROWS FETCH NEXT :Limit ROWS ONLY';

    Qry.Parameters.ParamByName('Offset').Value := Offset;
    Qry.Parameters.ParamByName('Limit').Value  := ALimit;
    Qry.Open;

    while not Qry.Eof do
    begin
      Result.Add(TTarefaModel.FromDataSet(Qry).ToJson);
      Qry.Next;
    end;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

procedure TTarefaRepository.Incluir(ATarefa: TTarefaModel);
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;

    Qry.SQL.Text :=
      'INSERT INTO Tarefas (Titulo, Descricao, Status, Prioridade) ' +
      'VALUES (:Titulo, :Descricao, :Status, :Prioridade)';

    Qry.Parameters.ParamByName('Titulo').Value     := ATarefa.Titulo;
    Qry.Parameters.ParamByName('Descricao').Value  := ATarefa.Descricao;
    Qry.Parameters.ParamByName('Status').Value     := ATarefa.StatusAsString;
    Qry.Parameters.ParamByName('Prioridade').Value := ATarefa.Prioridade;

    Qry.ExecSQL;

    Qry.SQL.Text := 'SELECT @@IDENTITY AS Id';
    Qry.Open;
    ATarefa.Id := Qry.FieldByName('Id').AsInteger;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

procedure TTarefaRepository.AtualizarStatus(AId: Integer; AStatus: string);
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;

    Qry.SQL.Text :=
      'UPDATE Tarefas ' +
      'SET Status = :Status, ' +
      '    DataConclusao = :DataConclusao ' +
      'WHERE Id = :Id';

    Qry.Parameters.ParamByName('Id').Value     := AId;
    Qry.Parameters.ParamByName('Status').Value := AStatus;

    // Define a data apenas quando for Concluída
    if SameText(AStatus, 'Concluida') then
      Qry.Parameters.ParamByName('DataConclusao').Value := Now  // ou VarFromDateTime(Now)
    else
      Qry.Parameters.ParamByName('DataConclusao').Value := Null;

    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

procedure TTarefaRepository.Excluir(AId: Integer);
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;

    Qry.SQL.Text := 'DELETE FROM Tarefas WHERE Id = :Id';
    Qry.Parameters.ParamByName('Id').Value := AId;
    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

// ================================================
// Desafio SQL
// ================================================

function TTarefaRepository.TotalTarefas: Integer;
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;
    Qry.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tarefas';
    Qry.Open;
    Result := Qry.FieldByName('Total').AsInteger;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

function TTarefaRepository.MediaPrioridadePendentes: Double;
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;
    Qry.SQL.Text :=
      'SELECT ISNULL(AVG(CAST(Prioridade AS FLOAT)), 0) AS Media ' +
      'FROM Tarefas WHERE Status = ''Pendente''';
    Qry.Open;
    Result := Qry.FieldByName('Media').AsFloat;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

function TTarefaRepository.QuantidadeConcluidasUltimos7Dias: Integer;
var
  Conn: TADOConnection;
  Qry: TADOQuery;
begin
  Conn := nil;
  Qry  := nil;
  try
    Conn := TConexaoBanco.GetConnection;
    Qry  := TADOQuery.Create(nil);
    Qry.Connection := Conn;
    Qry.SQL.Text :=
      'SELECT COUNT(*) AS Qtde ' +
      'FROM Tarefas ' +
      'WHERE Status = ''Concluida'' ' +
      'AND DataConclusao >= DATEADD(DAY, -7, GETDATE())';
    Qry.Open;
    Result := Qry.FieldByName('Qtde').AsInteger;
  finally
    FreeAndNil(Qry);
    TConexaoBanco.ReleaseConnection(Conn);
  end;
end;

end.