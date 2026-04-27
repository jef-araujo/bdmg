unit uTarefaFactory;

interface

uses
  System.JSON,
  uTarefaModel;

type
  TTarefaFactory = class
  public
    /// <summary>
    /// Cria uma TTarefa a partir do JSON recebido no POST /tarefas
    /// </summary>
    class function FromJson(AJson: TJSONObject): TTarefaModel;

    /// <summary>
    /// Cria uma tarefa com valores padrão (útil para testes)
    /// </summary>
    class function CriarTarefaPadrao: TTarefaModel;

    /// <summary>
    /// Factory Method - Cria uma nova tarefa informando os campos principais
    /// </summary>
    class function CriarNovaTarefa(
      const ATitulo, ADescricao: string;
      APrioridade: Integer = 3;
      AStatus: TStatusTarefa = stPendente): TTarefaModel;
  end;

implementation

uses
  System.SysUtils;

class function TTarefaFactory.FromJson(AJson: TJSONObject): TTarefaModel;
begin
  if not Assigned(AJson) then
    raise Exception.Create('JSON inválido para criar tarefa');

  Result := TTarefaModel.Create;
  try
    Result.Titulo      := AJson.GetValue<string>('titulo', '');
    Result.Descricao   := AJson.GetValue<string>('descricao', '');
    Result.Prioridade  := AJson.GetValue<Integer>('prioridade', 1);
    Result.StatusAsString := AJson.GetValue<string>('status', 'Pendente');

    if AJson.Get('id') <> nil then
      Result.Id := AJson.GetValue<Integer>('id', 0);
  except
    Result.Free;
    raise;
  end;
end;

class function TTarefaFactory.CriarTarefaPadrao: TTarefaModel;
begin
  Result := CriarNovaTarefa(
    'Tarefa de Teste',
    'Tarefa criada automaticamente para testes',
    3,
    stPendente
  );
end;

class function TTarefaFactory.CriarNovaTarefa(
  const ATitulo, ADescricao: string;
  APrioridade: Integer = 3;
  AStatus: TStatusTarefa = stPendente): TTarefaModel;
begin
  Result := TTarefaModel.Create;
  Result.Titulo     := ATitulo;
  Result.Descricao  := ADescricao;
  Result.Prioridade := APrioridade;
  Result.Status     := AStatus;
end;

end.