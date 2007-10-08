object Form1: TForm1
  Left = 404
  Top = 328
  Width = 707
  Height = 394
  Caption = 'E:\codestock\delpy\src\FolderFinder'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object dbgrd1: TDBGrid
    Left = 0
    Top = 49
    Width = 699
    Height = 294
    Align = alClient
    DataSource = ds1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgrd1DblClick
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 699
    Height = 49
    Align = alTop
    TabOrder = 1
    object lbl: TLabel
      Left = 20
      Top = 15
      Width = 29
      Height = 16
      Caption = 'Fin&d:'
      FocusControl = edt1
    end
    object edt1: TEdit
      Left = 67
      Top = 12
      Width = 337
      Height = 24
      TabOrder = 0
      Text = 'edt1'
      OnChange = edt1Change
    end
    object btnReindex: TButton
      Left = 494
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Re&index'
      TabOrder = 1
      OnClick = btnReindexClick
    end
    object btnQuery: TButton
      Left = 414
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Query'
      TabOrder = 2
      OnClick = btnQueryClick
    end
    object btnRun: TButton
      Left = 579
      Top = 12
      Width = 75
      Height = 25
      Caption = '&Go'
      TabOrder = 3
      OnClick = btnRunClick
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 343
    Width = 699
    Height = 19
    Panels = <>
  end
  object ds1: TDataSource
    Left = 208
    Top = 56
  end
end
