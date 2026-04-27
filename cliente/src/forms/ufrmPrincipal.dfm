object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'BDMG Tarefas - Sistema de Gerenciamento'
  ClientHeight = 640
  ClientWidth = 1100
  Color = clBtnFace
  Constraints.MinHeight = 679
  Constraints.MinWidth = 1116
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      1100
      65)
    object lblTitulo: TLabel
      Left = 20
      Top = 18
      Width = 161
      Height = 32
      Caption = 'BDMG Tarefas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnSair: TButton
      Left = 980
      Top = 18
      Width = 100
      Height = 35
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSairClick
    end
  end
  object pnlEstatisticas: TPanel
    Left = 0
    Top = 65
    Width = 1100
    Height = 110
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlTotal: TPanel
      Left = 20
      Top = 15
      Width = 220
      Height = 80
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 0
      object lblTotal: TLabel
        Left = 15
        Top = 15
        Width = 93
        Height = 17
        Caption = 'Total de Tarefas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblValorTotal: TLabel
        Left = 15
        Top = 38
        Width = 190
        Height = 32
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlMedia: TPanel
      Left = 260
      Top = 15
      Width = 220
      Height = 80
      BevelOuter = bvNone
      Color = 4227327
      ParentBackground = False
      TabOrder = 1
      object lblMedia: TLabel
        Left = 15
        Top = 15
        Width = 160
        Height = 17
        Caption = 'M'#233'dia Prioridade Pendente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblValorMedia: TLabel
        Left = 15
        Top = 38
        Width = 190
        Height = 32
        Alignment = taCenter
        AutoSize = False
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlConcluidas: TPanel
      Left = 500
      Top = 15
      Width = 220
      Height = 80
      BevelOuter = bvNone
      Color = 4227072
      ParentBackground = False
      TabOrder = 2
      object lblConcluidas: TLabel
        Left = 15
        Top = 15
        Width = 173
        Height = 17
        Caption = 'Concluidas nos '#250'ltimos 7 dias'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblValorConcluidas: TLabel
        Left = 15
        Top = 38
        Width = 190
        Height = 32
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 230
    Width = 1100
    Height = 410
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 390
    object grdTarefas: TStringGrid
      Left = 15
      Top = 15
      Width = 1070
      Height = 380
      ColCount = 7
      DefaultRowHeight = 28
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 0
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 175
    Width = 1100
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object btnAtualizar: TButton
      Left = 15
      Top = 12
      Width = 110
      Height = 35
      Caption = 'Atualizar Lista'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
    object btnNova: TButton
      Left = 135
      Top = 12
      Width = 110
      Height = 35
      Caption = 'Nova Tarefa'
      TabOrder = 1
      OnClick = btnNovaClick
    end
    object btnEditarStatus: TButton
      Left = 255
      Top = 12
      Width = 140
      Height = 35
      Caption = 'Alterar Status'
      TabOrder = 2
      OnClick = btnEditarStatusClick
    end
    object btnExcluir: TButton
      Left = 405
      Top = 12
      Width = 110
      Height = 35
      Caption = 'Excluir'
      TabOrder = 3
      OnClick = btnExcluirClick
    end
  end
end
