object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 498
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 336
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 24
    Width = 185
    Height = 193
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 378
    Width = 635
    Height = 120
    Align = alBottom
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object XMLDocument1: TXMLDocument
    Active = True
    FileName = 'F:\admin_fotojo_pg-proba.xml'
    Left = 216
    Top = 176
    DOMVendorDesc = 'MSXML'
  end
  object XMLTransformProvider1: TXMLTransformProvider
    XMLDataFile = 'F:\admin_fotojo_pg-proba.xml'
    Left = 512
    Top = 192
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'XMLTransformProvider1'
    Left = 384
    Top = 216
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 464
    Top = 304
  end
end
