object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login - Tarefas'
  ClientHeight = 380
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 380
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 40
    Padding.Top = 40
    Padding.Right = 40
    Padding.Bottom = 40
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 41
      Top = 27
      Width = 340
      Height = 32
      Alignment = taCenter
      AutoSize = False
      Caption = 'Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Left = 41
      Top = 67
      Width = 340
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Sistema de Gerenciamento de Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblUsuario: TLabel
      Left = 41
      Top = 117
      Width = 45
      Height = 17
      Caption = 'Usu'#225'rio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblSenha: TLabel
      Left = 41
      Top = 182
      Width = 35
      Height = 17
      Caption = 'Senha'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtUsuario: TEdit
      Left = 41
      Top = 137
      Width = 340
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 0
      Text = 'teste'
      TextHint = 'Digite seu usu'#225'rio'
    end
    object edtSenha: TEdit
      Left = 41
      Top = 202
      Width = 340
      Height = 23
      Enabled = False
      PasswordChar = '*'
      ReadOnly = True
      TabOrder = 1
      Text = 'teste2026'
      TextHint = 'Digite sua senha'
    end
    object btnEntrar: TButton
      Left = 41
      Top = 262
      Width = 340
      Height = 42
      Caption = 'Entrar'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnEntrarClick
    end
    object btnCancelar: TButton
      Left = 41
      Top = 312
      Width = 340
      Height = 35
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
  end
end
