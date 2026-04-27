program AplicacaoCliente;

uses
  Vcl.Forms,
  ufrmPrincipal in 'src\forms\ufrmPrincipal.pas' {Form1},
  uDadosLogin in 'src\utils\uDadosLogin.pas',
  ufrmLogin in 'src\forms\ufrmLogin.pas' {Form2},
  ufrmTarefa in 'src\forms\ufrmTarefa.pas' {Form3},
  uTarefaService in 'src\services\uTarefaService.pas',
  uTarefaModel in '..\shared\models\uTarefaModel.pas',
  uTratamentoStatusCodeHttp in 'src\utils\uTratamentoStatusCodeHttp.pas',
  uExceptionsCliente in 'src\exceptions\uExceptionsCliente.pas',
  uAppconfig in 'src\config\uAppconfig.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
