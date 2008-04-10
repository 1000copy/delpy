object fmLiusp: TfmLiusp
  Left = 307
  Top = 211
  Caption = 'Liusp'
  ClientHeight = 532
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 353
    Top = 0
    Height = 491
    ExplicitHeight = 498
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 353
    Height = 491
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#37073#30721
    Lines.Strings = (
      '(print "Hello Liusp")')
    ParentFont = False
    TabOrder = 0
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 356
    Top = 0
    Width = 369
    Height = 491
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#37073#30721
    ParentFont = False
    TabOrder = 1
    WordWrap = False
    ExplicitHeight = 498
  end
  object Panel1: TPanel
    Left = 0
    Top = 491
    Width = 725
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 498
    object Button3: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = 'returnlist'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 176
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = Button2Click
    end
    object btnRun: TButton
      Left = 64
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Run'
      TabOrder = 2
      OnClick = btnRunClick
    end
    object btnTestPackage: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Caption = 'TestPackage'
      TabOrder = 3
      OnClick = btnTestPackageClick
    end
  end
end
