object frmTarefa: TfrmTarefa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nova Tarefa'
  ClientHeight = 446
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 529
    Height = 446
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 30
    Padding.Top = 30
    Padding.Right = 30
    Padding.Bottom = 30
    TabOrder = 0
    ExplicitWidth = 580
    ExplicitHeight = 480
    object lblTitulo: TLabel
      Left = 6
      Top = 10
      Width = 119
      Height = 21
      Caption = 'T'#237'tulo da Tarefa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDescricao: TLabel
      Left = 6
      Top = 85
      Width = 74
      Height = 21
      Caption = 'Descri'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPrioridade: TLabel
      Left = 6
      Top = 270
      Width = 176
      Height = 15
      Caption = 'Prioridade (1 = Baixa | 5 = Cr'#237'tica)'
    end
    object lblStatus: TLabel
      Left = 276
      Top = 270
      Width = 32
      Height = 15
      Caption = 'Status'
    end
    object edtTitulo: TEdit
      Left = 6
      Top = 40
      Width = 520
      Height = 23
      TabOrder = 0
    end
    object memoDescricao: TMemo
      Left = 6
      Top = 115
      Width = 520
      Height = 140
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object cbPrioridade: TComboBox
      Left = 6
      Top = 290
      Width = 250
      Height = 23
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 2
      Text = '3 - M'#233'dia'
      Items.Strings = (
        '1 - Muito Baixa'
        '2 - Baixa'
        '3 - M'#233'dia'
        '4 - Alta'
        '5 - Cr'#237'tica')
    end
    object cbStatus: TComboBox
      Left = 276
      Top = 290
      Width = 250
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'Pendente'
        'EmAndamento'
        'Concluida')
    end
    object btnSalvar: TButton
      Left = 6
      Top = 380
      Width = 250
      Height = 45
      Caption = 'Salvar Tarefa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 276
      Top = 380
      Width = 250
      Height = 45
      Caption = 'Cancelar'
      TabOrder = 5
      OnClick = btnCancelarClick
    end
  end
end
