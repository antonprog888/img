program Project15;

uses
  Forms,
  Unit15 in 'C:\Users\Компьютер\Documents\RAD Studio\Projects\Unit15.pas' {Form15};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
