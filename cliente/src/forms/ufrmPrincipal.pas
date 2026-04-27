unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.Buttons, Data.DB;

type
  TfrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    btnSair: TButton;
    pnlEstatisticas: TPanel;
    pnlTotal: TPanel;
    lblTotal: TLabel;
    lblValorTotal: TLabel;
    pnlMedia: TPanel;
    lblMedia: TLabel;
    lblValorMedia: TLabel;
    pnlConcluidas: TPanel;
    lblConcluidas: TLabel;
    lblValorConcluidas: TLabel;
    pnlGrid: TPanel;
    grdTarefas: TStringGrid;
    pnlBotoes: TPanel;
    btnAtualizar: TButton;
    btnNova: TButton;
    btnEditarStatus: TButton;
    btnExcluir: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnNovaClick(Sender: TObject);
    procedure btnEditarStatusClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure grdTarefasDblClick(Sender: TObject);
  private
    procedure ConfigurarGrid;
    procedure CarregarTarefas;
    procedure CarregarEstatisticas;
    function GetIdSelecionado: Integer;
    procedure ExecutarLogin;
  public
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.JSON, uDadosLogin, ufrmLogin, uFrmTarefa, uTarefaService,
  uExceptionsCliente;

{$R *.dfm}

procedure TfrmPrincipal.ExecutarLogin;
begin
  if not TDadosLogin.EstaLogado then
  begin
    if not TfrmLogin.Execute then
    begin
      Application.Terminate;
      Abort;
    end;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ExecutarLogin;
  ConfigurarGrid;
  CarregarEstatisticas;
  CarregarTarefas;
end;

procedure TfrmPrincipal.ConfigurarGrid;
begin
  with grdTarefas do
  begin
    ColCount := 7;
    RowCount := 2;
    FixedCols := 0;
    FixedRows := 1;

    Cells[0, 0] := 'ID';
    Cells[1, 0] := 'Título';
    Cells[2, 0] := 'Descrição';
    Cells[3, 0] := 'Status';
    Cells[4, 0] := 'Prioridade';
    Cells[5, 0] := 'Criação';
    Cells[6, 0] := 'Conclusão';

    ColWidths[0] := 60;
    ColWidths[1] := 220;
    ColWidths[2] := 320;
    ColWidths[3] := 100;
    ColWidths[4] := 80;
    ColWidths[5] := 110;
    ColWidths[6] := 110;
  end;
end;

procedure TfrmPrincipal.CarregarTarefas;
var
 Service: TTarefaService;
 JsonArray: TJSONArray;
 i: Integer;
begin
 grdTarefas.RowCount := 2; // limpa grid

 Service := TTarefaService.Create;
 try
   JsonArray := Service.ListarTarefas;

   if Assigned(JsonArray) then
   begin
     grdTarefas.RowCount := JsonArray.Count + 1;

     for i := 0 to JsonArray.Count - 1 do
     begin
       grdTarefas.Cells[0, i+1] := JsonArray.Items[i].GetValue<Integer>('id').ToString;
       grdTarefas.Cells[1, i+1] := JsonArray.Items[i].GetValue<string>('titulo');
       grdTarefas.Cells[2, i+1] := JsonArray.Items[i].GetValue<string>('descricao');
       grdTarefas.Cells[3, i+1] := JsonArray.Items[i].GetValue<string>('status');
       grdTarefas.Cells[4, i+1] := JsonArray.Items[i].GetValue<Integer>('prioridade').ToString;
       grdTarefas.Cells[5, i+1] := JsonArray.Items[i].GetValue<string>('dataCriacao');
       grdTarefas.Cells[6, i+1] := JsonArray.Items[i].GetValue<string>('dataConclusao', '');
     end;
   end;
 finally
   FreeAndNil(JsonArray);
   FreeAndNil(Service);
 end;
end;

procedure TfrmPrincipal.CarregarEstatisticas;
var
 Service: TTarefaService;
 Json: TJSONObject;
begin
 Json := nil;
 Service := TTarefaService.Create;
 try
   try
     Json := Service.ObterEstatisticas;
   except
      on E: ENaoAutenticadoException do
      begin
        MessageDlg(E.Message, TMsgDlgType.mtError, [mbOK], 0);
        TDadosLogin.Limpar;
        ExecutarLogin;
        Exit;
      end;
      else
      begin
        raise;
      end;
   end;

   if Assigned(Json) then
   begin
     lblValorTotal.Caption       := Json.GetValue<Integer>('total_tarefas').ToString;
     lblValorMedia.Caption       := FormatFloat('0.00', Json.GetValue<Double>('media_prioridade_pendentes'));
     lblValorConcluidas.Caption  := Json.GetValue<Integer>('tarefas_concluidas_ultimos_7_dias').ToString;
   end;
 finally
   FreeAndNil(Json);
   FreeAndNil(Service);
 end;
end;

function TfrmPrincipal.GetIdSelecionado: Integer;
begin
  Result := 0;
  if grdTarefas.Row > 0 then
    Result := StrToIntDef(grdTarefas.Cells[0, grdTarefas.Row], 0);
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  CarregarEstatisticas;
  CarregarTarefas;
end;

procedure TfrmPrincipal.btnNovaClick(Sender: TObject);
begin
  if TfrmTarefa.Execute then
  begin
    CarregarEstatisticas;
    CarregarTarefas;
  end;
end;

procedure TfrmPrincipal.btnEditarStatusClick(Sender: TObject);
var
  Id: Integer;
begin
  Id := GetIdSelecionado;
  if Id = 0 then
  begin
    MessageDlg('Selecione uma tarefa na lista!', mtInformation, [mbOK], 0);
    Exit;
  end;

 if TfrmTarefa.EditarStatus(Id) then
 begin
   CarregarEstatisticas;
   CarregarTarefas;
 end;
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
  Id: Integer;
  Service: TTarefaService;
begin
  Id := GetIdSelecionado;

  if Id = 0 then
  begin
    MessageDlg('Selecione uma tarefa para excluir!', mtInformation, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir esta tarefa?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Service := TTarefaService.Create;
    try
      if Service.ExcluirTarefa(Id) then
      begin
        ShowMessage('Tarefa excluída com sucesso!');
        CarregarEstatisticas;
        CarregarTarefas;
      end;
    finally
      FreeAndNil(Service)
    end;
  end;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  if MessageDlg('Deseja realmente sair do sistema?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    TDadosLogin.Limpar;
    Close;
  end;
end;

procedure TfrmPrincipal.grdTarefasDblClick(Sender: TObject);
begin
  btnEditarStatusClick(nil);
end;

end.