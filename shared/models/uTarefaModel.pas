unit uTarefaModel;

interface

uses
  System.JSON,
  System.SysUtils,
  System.DateUtils,
  Data.DB;

type
  TStatusTarefa = (stPendente, stEmAndamento, stConcluida);

  TTarefaModel = class
  private
    FId: Integer;
    FTitulo: string;
    FDescricao: string;
    FStatus: TStatusTarefa;
    FPrioridade: Integer;
    FDataCriacao: TDateTime;
    FDataConclusao: TDateTime;

    function GetStatusAsString: string;
    procedure SetStatusAsString(const Value: string);
  public
    constructor Create;

    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property Status: TStatusTarefa read FStatus write FStatus;
    property Prioridade: Integer read FPrioridade write FPrioridade;
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;

    property StatusAsString: string read GetStatusAsString write SetStatusAsString;

    function ToJson: TJSONObject;
    class function FromJson(AJson: TJSONObject): TTarefaModel;
    
    /// <summary>
    /// Agora aceita TDataSet (funciona com TADOQuery)
    /// </summary>
    class function FromDataSet(ADataset: TDataSet): TTarefaModel;
  end;

implementation

constructor TTarefaModel.Create;
begin
  inherited;
  FDataCriacao := Now;
  FStatus := stPendente;
  FPrioridade := 3;
end;

function TTarefaModel.GetStatusAsString: string;
begin
  case FStatus of
    stPendente:     Result := 'Pendente';
    stEmAndamento:  Result := 'EmAndamento';
    stConcluida:    Result := 'Concluida';
  else
    Result := 'Pendente';
  end;
end;

procedure TTarefaModel.SetStatusAsString(const Value: string);
begin
  if SameText(Value, 'EmAndamento') or SameText(Value, 'Em Andamento') then
    FStatus := stEmAndamento
  else if SameText(Value, 'Concluida') or SameText(Value, 'Concluída') then
    FStatus := stConcluida
  else
    FStatus := stPendente;
end;

function TTarefaModel.ToJson: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('id', TJSONNumber.Create(FId));
  Result.AddPair('titulo', TJSONString.Create(FTitulo));
  Result.AddPair('descricao', TJSONString.Create(FDescricao));
  Result.AddPair('status', TJSONString.Create(StatusAsString));
  Result.AddPair('prioridade', TJSONNumber.Create(FPrioridade));
  Result.AddPair('dataCriacao', TJSONString.Create(FormatDateTime('dd/mm/yyyy hh:nn:ss', FDataCriacao)));

  if FDataConclusao > 0 then
    Result.AddPair('dataConclusao', TJSONString.Create(FormatDateTime('dd/mm/yyyy hh:nn:ss', FDataConclusao)))
  else
    Result.AddPair('dataConclusao', TJSONNull.Create);
end;

class function TTarefaModel.FromJson(AJson: TJSONObject): TTarefaModel;
begin
  Result := TTarefaModel.Create;
  try
    // Forma moderna e segura (recomendada)
    Result.Id          := AJson.GetValue<Integer>('id', 0);
    Result.Titulo      := AJson.GetValue<string>('titulo', '');
    Result.Descricao   := AJson.GetValue<string>('descricao', '');
    Result.StatusAsString := AJson.GetValue<string>('status', 'Pendente');
    Result.Prioridade  := AJson.GetValue<Integer>('prioridade', 1);

    // DataCriacao normalmente não vem no JSON de inclusão, mas se vier:
//    if AJson.ContainsKey('dataCriacao') then
//      Result.DataCriacao := ISO8601ToDate(AJson.GetValue<string>('dataCriacao'));

  except
    Result.Free;
    raise;
  end;
end;

class function TTarefaModel.FromDataSet(ADataset: TDataSet): TTarefaModel;
begin
  Result := TTarefaModel.Create;
  try
    Result.Id            := ADataset.FieldByName('Id').AsInteger;
    Result.Titulo        := ADataset.FieldByName('Titulo').AsString;
    Result.Descricao     := ADataset.FieldByName('Descricao').AsString;
    Result.StatusAsString:= ADataset.FieldByName('Status').AsString;
    Result.Prioridade    := ADataset.FieldByName('Prioridade').AsInteger;
    Result.DataCriacao   := ADataset.FieldByName('DataCriacao').AsDateTime;

    if not ADataset.FieldByName('DataConclusao').IsNull then
      Result.DataConclusao := ADataset.FieldByName('DataConclusao').AsDateTime;
  except
    Result.Free;
    raise;
  end;
end;

end.