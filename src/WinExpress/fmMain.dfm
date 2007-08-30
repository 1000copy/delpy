object Form1: TForm1
  Left = 455
  Top = 152
  BorderStyle = bsNone
  Caption = 'SpyHideBy Sanrex@163.com'
  ClientHeight = 260
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 260
    Align = alClient
    BorderWidth = 1
    Caption = 'pnl1'
    Color = clMoneyGreen
    TabOrder = 0
    object lbl1: TLabel
      Left = 16
      Top = 8
      Width = 45
      Height = 17
      Caption = #25214#31383#21475
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 88
      Top = 8
      Width = 42
      Height = 17
      Caption = #25214#31243#24207
    end
    object lbl3: TLabel
      Left = 149
      Top = 8
      Width = 42
      Height = 17
      Caption = #25214#30446#24405
    end
    object dbgrd1: TDBGrid
      Left = 4
      Top = 80
      Width = 377
      Height = 177
      BorderStyle = bsNone
      DataSource = ds1
      Enabled = False
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
          FieldName = 'caption'
          Visible = True
        end>
    end
    object edt1: TEdit
      Left = 4
      Top = 28
      Width = 377
      Height = 48
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
      Left = 220
      Top = 6
      Width = 144
      Height = 21
      Caption = #36825#37324#24819#35201#25918#32622#19968#20010#22270#29255
      TabOrder = 2
    end
  end
  object ds1: TDataSource
    Left = 232
    Top = 120
  end
end
