program servico;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  IdException,
  Horse,
  Horse.CORS,
  Horse.BasicAuthentication,
  Horse.Jhonson,
  uTarefaController in 'src\controller\uTarefaController.pas',
  uConexaoBanco in 'src\infra\uConexaoBanco.pas',
  uConfig in 'src\config\uConfig.pas',
  uTarefaModel in '..\shared\models\uTarefaModel.pas',
  uTarefaRepository in 'src\repository\uTarefaRepository.pas',
  uTarefaFactory in 'src\factory\uTarefaFactory.pas',
  uLogger in 'src\log\uLogger.pas';

procedure ConfigurarCORS;
begin
  HorseCORS
    .AllowedOrigin('*')
    .AllowedCredentials(true)
    .AllowedHeaders('*')
    .AllowedMethods('GET, POST, PUT, DELETE, OPTIONS')
    .ExposedHeaders('*');
end;

procedure teste(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  raise Exception.Create('Error Message');
  Res.Send('Listar todas as tarefas - EM IMPLEMENTAÇÃO').Status(200);
end;

procedure GlobalExceptionMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  try
    Next;
  except
    on E: Exception do
    begin
      TLogger.LogarEmTela(Format('Erro na rota %s %s: %s', [Req.RawWebRequest.Method, Req.PathInfo, E.Message]));
      raise;
    end;
  end;
end;

procedure ConfigurarRotas;
const
  USER_TESTE = 'teste';
  PASS_TESTE = 'teste2026';
begin
  ConfigurarCORS;

  THorse.Use(
    HorseBasicAuthentication(
      function(const AUsername, APassword: string): Boolean
      begin
        Result := (AUsername = USER_TESTE) and (APassword = PASS_TESTE);
      end));

  THorse.Use(CORS);
  THorse.Use(Jhonson);
  THorse.Use(GlobalExceptionMiddleware);

  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('{"message":"Serviço rodando com autenticação","status":"online"}')
         .Status(200);
    end);

  THorse.Get('/teste', teste);

  THorse.Get('/tarefas', TarefaController.Listar);
  THorse.Post('/tarefas', TarefaController.Incluir);
  THorse.Put('/tarefas/:id/status', TarefaController.AtualizarStatus);
  THorse.Delete('/tarefas/:id', TarefaController.Excluir);
  THorse.Get('/estatisticas', TarefaController.Estatisticas);

  TLogger.LogarEmTela('Rotas configuradas com sucesso!')
end;

procedure IniciarServidor;
var
  Port: Integer;
begin
  Port := TConfig.GetInstance.AppPort;

  TLogger.LogarEmTela('Iniciando Serviço...');
  TLogger.LogarEmTela('Carregando configurações do arquivo config.ini');

  TLogger.LogarEmTela('Tentando iniciar servidor na porta: ' + Port.ToString);
  try
    THorse.Listen(Port,
      procedure
      begin
        TLogger.LogarEmTela('Serviço iniciado com sucesso!');
        TLogger.LogarEmTela('URL: http://localhost:' + Port.ToString);
        TLogger.LogarEmTela('Pressione Ctrl+C para parar o servidor.');
      end);

  except
    on E: EIdCouldNotBindSocket do
    begin
      TLogger.LogarEmTela('ERRO: Porta ' + Port.ToString + ' já está em uso!');
      TLogger.LogarEmTela('Feche todas as outras instâncias do serviço e tente novamente.');
      raise;
    end;
    on E: Exception do
    begin
      TLogger.LogarEmTela('ERRO: Erro ao iniciar servidor:');
      TLogger.LogarEmTela('   ' + E.ClassName + ' - ' + E.Message);
      raise;
    end;
  end;
end;

procedure ConfigurarServidor;
begin
  THorse.MaxConnections := 200;
  THorse.KeepConnectionAlive := true;
end;

begin
  ReportMemoryLeaksOnShutdown := true;

  ConfigurarServidor;
  ConfigurarRotas;
  IniciarServidor;
  Readln;
end.
