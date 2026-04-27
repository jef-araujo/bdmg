unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, uDadosLogin;

type
  TfrmLogin = class(TForm)
    pnlFundo: TPanel;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    btnEntrar: TButton;
    btnCancelar: TButton;           // opcional
    procedure btnEntrarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    function ValidarCampos: Boolean;
  public
    class function Execute: Boolean;   // método estático para chamar facilmente
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

class function TfrmLogin.Execute: Boolean;
begin
  with TfrmLogin.Create(nil) do
  try
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then   // Enter
  begin
    if ActiveControl = edtUsuario then
      edtSenha.SetFocus
    else if ActiveControl = edtSenha then
      btnEntrar.Click;
  end;
end;

function TfrmLogin.ValidarCampos: Boolean;
begin
  Result := False;

  if Trim(edtUsuario.Text) = '' then
  begin
    MessageDlg('Informe o usuário!', mtWarning, [mbOK], 0);
    edtUsuario.SetFocus;
    Exit;
  end;

  if Trim(edtSenha.Text) = '' then
  begin
    MessageDlg('Informe a senha!', mtWarning, [mbOK], 0);
    edtSenha.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  if not ValidarCampos then
    Exit;

  TDadosLogin.Username := Trim(edtUsuario.Text);
  TDadosLogin.Password := Trim(edtSenha.Text);

  ModalResult := mrOk;
end;

procedure TfrmLogin.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.