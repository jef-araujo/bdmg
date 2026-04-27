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
    .AllowedOrigin('*')           // Pode mudar para 'http://localhost:8080' depois
    .AllowedCredentials(true)
    .AllowedHeaders('*')
    .AllowedMethods('GET, POST, PUT, DELETE, OPTIONS')
    .ExposedHeaders('*');
end;

procedure teste(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Listar todas as tarefas - EM IMPLEMENTAÇÃO').Status(200);
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

  THorse.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('{"message":"Serviço rodando com autenticação,"status":"online"}')
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
  LPort: Integer;
begin
  LPort := TConfig.GetInstance.AppPort;

  TLogger.LogarEmTela('Iniciando Serviço...');
  TLogger.LogarEmTela('Carregando configurações do arquivo config.ini');
  TLogger.LogarEmTela('Tentando iniciar servidor na porta: ' + LPort.ToString);

  try
    THorse.Listen(LPort,
      procedure
      begin
        TLogger.LogarEmTela('Serviço iniciado com sucesso!');
        TLogger.LogarEmTela('URL: http://localhost:' + LPort.ToString);
        TLogger.LogarEmTela('Pressione Ctrl+C para parar o servidor.');
      end,
      nil);   // callback de stop

  except
    on E: EIdCouldNotBindSocket do
    begin
      TLogger.LogarEmTela('ERRO: Porta ' + LPort.ToString + ' já está em uso!');
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

begin
  ReportMemoryLeaksOnShutdown := true;
  ConfigurarRotas;
  IniciarServidor;
  Readln;
end.
