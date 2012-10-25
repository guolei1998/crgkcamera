object Form1: TForm1
  Left = 253
  Top = 254
  BorderStyle = bsSingle
  Caption = #29031#29255#29983#25104#30417#25511#31243#24207
  ClientHeight = 324
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object chk1: TCheckBox
    Left = 16
    Top = 16
    Width = 105
    Height = 33
    Caption = #24320#26426#33258#21160#21551#21160
    TabOrder = 0
    OnClick = chk1Click
  end
  object btn1: TButton
    Left = 328
    Top = 8
    Width = 105
    Height = 49
    Caption = #36864#20986'(&X)'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 224
    Top = 8
    Width = 97
    Height = 49
    Caption = #26368#23567#21270'(&M)'
    TabOrder = 2
    OnClick = btn2Click
  end
  object Button1: TButton
    Left = 128
    Top = 8
    Width = 81
    Height = 49
    Caption = #21551#21160#26381#21153
    TabOrder = 3
    OnClick = Button1Click
  end
  object lstMessages: TListBox
    Left = 8
    Top = 64
    Width = 425
    Height = 249
    ItemHeight = 13
    TabOrder = 4
  end
  object RzTrayIcon1: TRzTrayIcon
    Left = 472
    Top = 16
  end
  object rzrgnfl1: TRzRegIniFile
    PathType = ptRegistry
    RegKey = hkeyLocalMachine
    Left = 416
    Top = 16
  end
end
