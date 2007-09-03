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
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 260
    Hint = 
      'CTRL+F12 - Call this form'#13#10'ESC      - Hide this form'#13#10'ALT+  F4 -' +
      ' Exit'#13#10'Left Arrow - toggle between directory and windows'#13#10'RightA' +
      'rrow - toggle between directory and windows'#13#10'Up Arrow   - Up vie' +
      'w'#13#10'Down Arrow   - Down view'#13#10'PageUp       - Page up'#13#10'PageDown   ' +
      '  - Page down'#13#10'Enter        - Run folder or show windows'
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
      Width = 483
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
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
    object lbl1: TLabel
      Left = 464
      Top = 5
      Width = 28
      Height = 17
      Hint = 
        'Left  Arrow   -- toggle target'#13#10'Right Arrow   -- toggle target'#13#10 +
        'Up    Arrow   -- Line up the result'#13#10'Down  Arrow   -- Line down ' +
        'the result'#13#10'Page     up   -- Page up the result'#13#10'Page    down  -' +
        '- Page down the result'
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Help'
      Color = clYellow
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = lbl1MouseEnter
      OnMouseLeave = lbl1MouseLeave
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
      Options = [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
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
      Hint = 
        'Left  Arrow   -- toggle target'#13#10'Right Arrow   -- toggle target'#13#10 +
        'Up    Arrow   -- Line up the result'#13#10'Down  Arrow   -- Line down ' +
        'the result'#13#10'Page     up   -- Page up the result'#13#10'Page    down  -' +
        '- Page down the result'
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
      Top = 24
      Width = 41
      Height = 16
      Caption = 'Indexed'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = []
      ParentColor = False
      ParentFont = False
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
    object mmo1: TMemo
      Left = 200
      Top = 104
      Width = 289
      Height = 151
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clInfoBk
      Enabled = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Terminal'
      Font.Style = []
      Lines.Strings = (
        'Left  Arrow   -- toggle target'
        'Right Arrow   -- toggle target'
        'Up    Arrow   -- Line up the result'
        'Down  Arrow   -- Line down the result'
        'Page     up   -- Page up the result'
        'Page    down  -- Page down the result'
        'Enter         -- Action(show the folder or the '
        'windows)'
        'ESC           -- hide this form'
        'Alt + F4      -- Exit'
        'Ctrl + F12    -- Show this form')
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Visible = False
    end
  end
  object ds1: TDataSource
    Left = 232
    Top = 120
  end
end
