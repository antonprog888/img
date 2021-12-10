unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, StdCtrls, msxmldom, XMLDoc, Grids, DBGrids, DB,
  DBClient, Provider, Xmlxform;

type
  TForm1 = class(TForm)
    Button1: TButton;
    XMLDocument1: TXMLDocument;
    Memo1: TMemo;
    XMLTransformProvider1: TXMLTransformProvider;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ProcXmlNode(aXmlNode : IXMLNode);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  ProcXmlNode(XMLDocument1.Node);
//  XMLDocument1.SaveToFile('f:\1.xml');
  ClientDataSet1.Open

end;

procedure TForm1.ProcXmlNode(aXmlNode : IXMLNode);
var i,j:Integer;
begin
  for i := 0 to aXmlNode.ChildNodes.Count - 1 do
    begin
      if aXmlNode.ChildNodes[i].NodeType<>ntText then
        begin
          Memo1.Lines.Add(aXmlNode.ChildNodes[i].NodeName);

          for j :=0 to aXmlNode.ChildNodes[i].AttributeNodes.Count - 1 do
            begin
               if j>=aXmlNode.ChildNodes[i].AttributeNodes.Count then
                 Break;
               if aXmlNode.ChildNodes[i].AttributeNodes[j].NodeValue ='post_tag' then
                 begin
                    aXmlNode.ChildNodes[i].AttributeNodes.Remove(aXmlNode.ChildNodes[i].AttributeNodes[j]);
                 end;
            end;
          ProcXmlNode(aXmlNode.ChildNodes[i]);
        end;
    end;
end;


end.
