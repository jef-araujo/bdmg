unit uFrmTarefa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, uTarefaModel;

type
  TfrmTarefa = class(TForm)
    pnlFundo: TPanel;
    lblTitulo: TLabel;
    edtTitulo: TEdit;
    lblDescricao: TLabel;
    memoDescricao: TMemo;
    lblPrioridade: TLabel;
    cbPrioridade: TComboBox;
    lblStatus: TLabel;
    cbStatus: TComboBox;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FIdTarefa: Integer;        // 0 = nova tarefa | >0 = edição
    FTarefa: TTarefaModel;
    function ValidarCampos: Boolean;
  public
    /// <summary>
    /// Cria uma nova tarefa
    /// </summary>
    class function Execute: Boolean;

    /// <summary>
    /// Altera apenas o status de uma tarefa existente
    /// </summary>
    class function EditarStatus(AId: Integer): Boolean;
  end;

var
  frmTarefa: TfrmTarefa;

implementation

{$R *.dfm}

uses uDadosLogin, uTarefaService;

class function TfrmTarefa.Execute: Boolean;
begin
  Result := False;
  with TfrmTarefa.Create(nil) do
  try
    FIdTarefa := 0;
    Caption := 'Nova Tarefa';
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

class function TfrmTarefa.EditarStatus(AId: Integer): Boolean;
begin
  Result := False;
  with TfrmTarefa.Create(nil) do
  try
    FIdTarefa := AId;
    Caption := 'Alterar Status da Tarefa';
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TfrmTarefa.FormShow(Sender: TObject);
begin
  if FIdTarefa > 0 then
  begin
    // Modo edição de status
    edtTitulo.Enabled := False;
    memoDescricao.Enabled := False;
    cbPrioridade.Enabled := False;
    cbStatus.ItemIndex := cbStatus.Items.IndexOf('EmAndamento'); // default
  end
  else
  begin
    // Modo nova tarefa
    edtTitulo.SetFocus;
  end;
end;

function TfrmTarefa.ValidarCampos: Boolean;
begin
  Result := False;

  if FIdTarefa = 0 then // só valida título e descrição se for nova tarefa
  begin
    if Trim(edtTitulo.Text) = '' then
    begin
      MessageDlg('O título da tarefa é obrigatório!', mtWarning, [mbOK], 0);
      edtTitulo.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmTarefa.btnSalvarClick(Sender: TObject);
var
  Service: TTarefaService;
  Tarefa: TTarefaModel;
begin
  if not ValidarCampos then
    Exit;

  Service := TTarefaService.Create;
  try
    if FIdTarefa = 0 then
    begin
      // Nova tarefa
      Tarefa := TTarefaModel.Create;
      try
        Tarefa.Titulo     := Trim(edtTitulo.Text);
        Tarefa.Descricao  := Trim(memoDescricao.Text);
        Tarefa.Prioridade := cbPrioridade.ItemIndex + 1;
        Tarefa.StatusAsString := cbStatus.Text;

        if Service.IncluirTarefa(Tarefa) then
        begin
          ShowMessage('Tarefa incluída com sucesso!');
          ModalResult := mrOk;
        end;
      finally
        Tarefa.Free;
      end;
    end
    else
    begin
      // Apenas alterar status
      if Service.AtualizarStatus(FIdTarefa, cbStatus.Text) then
      begin
        ShowMessage('Status atualizado com sucesso!');
        ModalResult := mrOk;
      end;
    end;
  finally
    FreeAndNil(Service);
  end;
end;

procedure TfrmTarefa.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.