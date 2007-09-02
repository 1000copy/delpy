object Form1: TForm1
  Left = 395
  Top = 258
  Width = 506
  Height = 292
  Caption = 'WinExpress By 1000copy@gmail.com'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 260
    Align = alClient
    BorderWidth = 1
    Caption = 'pnl1'
    Color = clMoneyGreen
    TabOrder = 0
    DesignSize = (
      498
      260)
    object lblWindows: TLabel
      Left = 80
      Top = 22
      Width = 56
      Height = 17
      Caption = 'Windows'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = []
      ParentFont = False
    end
    object lblProgram: TLabel
      Left = 160
      Top = 22
      Width = 53
      Height = 17
      Caption = 'Program'
      Visible = False
    end
    object lblDirectory: TLabel
      Left = 5
      Top = 22
      Width = 63
      Height = 17
      Caption = 'Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl4: TLabel
      Left = 6
      Top = 5
      Width = 202
      Height = 17
      Caption = 'Finder For:                                  '
      Color = clFuchsia
      ParentColor = False
    end
    object btn1: TSpeedButton
      Left = 336
      Top = 27
      Width = 8
      Height = 8
      Transparent = False
      OnClick = btn1Click
    end
    object dbgrd1: TDBGrid
      Left = 4
      Top = 96
      Width = 490
      Height = 161
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      DataSource = ds1
      FixedColor = clBackground
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -14
      TitleFont.Name = 'MS Shell Dlg 2'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'key'
          Width = 255
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'value'
          Width = 100
          Visible = True
        end>
    end
    object edt1: TEdit
      Left = 4
      Top = 44
      Width = 490
      Height = 48
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -33
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edt1'
      OnChange = edt1Change
      OnKeyUp = edt1KeyUp
    end
    object txt1: TStaticText
      Left = 348
      Top = 21
      Width = 54
      Height = 18
      Caption = 'Indexed'
      Color = clAqua
      ParentColor = False
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 247
      Top = 26
      Width = 84
      Height = 10
      Caption = 'Match exactly'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object ds1: TDataSource
    Left = 232
    Top = 120
  end
end
