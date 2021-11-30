unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  XPMan,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons;

type
  TfAbout = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel3: TBevel;
    lVer: TLabel;
    Shape1: TShape;
    lSupportRef: TLabel;
    lForumRef: TLabel;
    lHomePage: TLabel;
    Shape2: TShape;
    Image2: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTESt;
  public
    { Public declarations }
  end;

var
  fAbout: TfAbout;

procedure ShowAboutForm;

implementation

{$R *.dfm}

procedure ShowAboutForm;
begin
  fAbout := TfAbout.Create(Application);
  fAbout.ShowModal;
  FreeAndNil(fAbout);
end;

procedure TfAbout.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

type
  TControlCrack = class(TControl);

procedure TfAbout.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ControlCount-1 do
  begin
    TControlCrack(Controls[i]).Font.Name := Font.Name;
  end;
  lSupportRef.Font.Style := [fsBold, fsUnderline];
  lSupportRef.Font.Color := clNavy;
  lForumRef.Font := lSupportRef.Font;
  lHomePage.Font := lSupportRef.Font;
end;

procedure TfAbout.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCAPTION;
end;

end.

