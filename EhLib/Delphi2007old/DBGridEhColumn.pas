unit DBGridEhColumn;

interface

uses
  SysUtils, Forms, Classes, ExtCtrls,Buttons, Controls,
  dialogs,windows,IniFiles, Graphics,StdCtrls , CheckLst,
//  Grids, DBGridEh;
  GridsEh, DBCtrls, Db,  DBCtrlsEh, DBGridEh;



type
  TEvantClickPanel = procedure(Sender: TObject; FieldName : String; Data: String) of object;
  TEvantDblClickPanel = procedure(Sender: TObject; FieldName : String; Data: String) of object;
  TEvantColorPanelScript = procedure(Sender: TObject; ColorScript : String) of object;

                                   
  TDBGridEhColumn = class(TDBGridEh{TCustomDBGridEh} {TDBGridEh})
  private
    fOnClickPanel : TEvantClickPanel;
    fOnDblClickPanel : TEvantDblClickPanel;
    fOnColorPanelScript : TEvantColorPanelScript;

    words : TStringList;
    Bglob: Boolean;
    SGlobHint : String;
    BGlobShow : Boolean;
    CBcol: TCheckListBox;
    LBForm: TListBox;
    Pan: TPanel;
    Mem, MemError: TMemo;
    ButOK, ButExit: TSpeedButton;

    procedure LBFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DB_DATAKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LB1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLBox1DblClick(Sender: TObject);
    procedure CBcol1ClickCheck(Sender: TObject);
    function ReadIni(ASection, AString: String): String;
    procedure WriteIni(ASection, AString, AValue: String);
    function GetColorPanelScript: TStrings;
    procedure SetColorPanelScript(const Value: TStrings);
    procedure MemChange(Sender: TObject);
    procedure ButOKClick(Sender: TObject);
    function ProvUslovie(Pole, Value, Znak: String): Boolean;
    procedure ButExitClick(Sender: TObject);
    procedure SplitTextIntoWords(const S: string; words: TstringList);

    { Private declarations }
  protected
    fPath      : String;
    fName      : String;
    fFile      : Boolean;
    FView      : Boolean;
    Fcolor     : TColor;
    FColorPanelScript: TStrings;
    FColorPanelIniFiles: String;
    a_pole, a_value, a_znak, a_pole2, a_value2, a_znak2 : array of String[100];
    a_color: array of Tcolor;
    a_tip: array of SmallInt;


    function GetNAME: String;
    procedure SetNAME(const Value: String);

    function GetColor : TColor;
    procedure SetColor( Value: TColor);

    function GetPath : String;
    procedure SetPath( Value: String);
    function GetFile : Boolean;
    procedure SetFile( Value: Boolean);

    function GetView : Boolean;
    procedure SetView( Value: Boolean);



    { Protected declarations }
  public
    SFilter: String;
    SFilterName: String;
    Function ApplyColorScript(Sender: TObject): Boolean;
    { Public declarations }
  published

    property INI_FILE: Boolean read GetFile write SetFile;
    property INI_Path: String read GetPath write SetPath;
    property INI_NAME: String read GetNAME write SetNAME;
    property ColumnView: Boolean read GetView write SetView;
    property ColumnColorView: TColor read GetColor write SetColor;

    property Color_PanelScript: TStrings read GetColorPanelScript write SetColorPanelScript;
    property Color_PanelIniFiles: String read fColorPanelIniFiles write fColorPanelIniFiles;


    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);  override;

    procedure DrawColumnCell(const Rect: TRect;
    DataCol: Integer; Column: TColumnEh; State: TGridDrawState); override;

    procedure Loaded; override;
    procedure paint; override;
    procedure ApplyColumnFromIni;
   // procedure LB1DblClick(Sender: TObject);
    Property OnClickPanel : TEvantClickPanel read fOnClickPanel write fOnClickPanel;
    Property OnDblClickPanel : TEvantDblClickPanel read fOnDblClickPanel write fOnDblClickPanel;
    Property OnColorPanelScript : TEvantColorPanelScript read fOnColorPanelScript write fOnColorPanelScript;

    { Published declarations }
  end;



procedure Register;

implementation



function TDBGridEhColumn.ReadIni(ASection, AString : String) : String;
var
  sIniFile: TIniFile;
  sPath: String[60];
  S: String;
begin
 // GetDir(0,sPath);
  try
    sIniFile := TIniFile.Create(fPath);
    Result := sIniFile.ReadString(ASection, AString, S); sIniFile.Free;
  except
  end;
end;

procedure TDBGridEhColumn.WriteIni(ASection, AString, AValue : String);
var
  sIniFile: TIniFile;
  sPath: String[60];
begin
  //GetDir(0,sPath);
  try
    if AString<>'' then
      begin
        sIniFile := TIniFile.Create(fPath);
        sIniFile.WriteString(ASection, AString, AValue);
        sIniFile.Free;
      end;
  except
  end;
end;


function TDBGridEhColumn.GetPath : String;
begin
  Result := fPath;
end;

procedure TDBGridEhColumn.SetFile(Value: Boolean);
begin
  fFile := Value;
end;

function TDBGridEhColumn.GetFile : Boolean;
begin
  Result := fFile;
end;


procedure TDBGridEhColumn.SetPath(Value: String);
begin
  fPath := Value;
end;

function TDBGridEhColumn.GetColor: TColor;
begin
  Result := fColor;
  CBcol.Color := FColor;
end;



function TDBGridEhColumn.GetColorPanelScript: TStrings;
begin
  if FColorPanelScript = nil then
    FColorPanelScript := TStringList.Create;
  Result := FColorPanelScript;
end;

procedure TDBGridEhColumn.SetColor(Value: TColor);
begin
  fColor := Value;
  CBcol.Color := FColor;
end;




procedure TDBGridEhColumn.SetColorPanelScript(const Value: TStrings);
begin
  if Value = nil then
  begin
    FreeAndNil(FColorPanelScript);
//    FKeyList := nil;
    Exit;
  end;
  FColorPanelScript.Assign(Value);

  ApplyColorScript(self);
  Pan.Visible := false;
  self.Repaint;
end;

function TDBGridEhColumn.GetView: Boolean;
begin
  Result := fView;
 // paint;
end;

procedure TDBGridEhColumn.SetView(Value: Boolean);
begin
  fView := Value;
 // paint;
end;

procedure TDBGridEhColumn.CBcol1ClickCheck(Sender: TObject);
var
 I, J: Integer;
begin
  J := Integer(CBcol.Items.Objects[CBcol.ItemIndex]);
    begin
      if CBcol.Checked[CBcol.ItemIndex] then
        begin
          if Assigned(fOnClickPanel) then fOnClickPanel(Sender, self.Columns[J].FieldName, '1');
          if fFile then
            begin
              if self.DataSource<>nil then
                WriteIni(fName+self.Name+self.DataSource.DataSet.Name, self.Columns[J].FieldName, '1')
              else
                WriteIni(fName+self.Name, self.Columns[J].FieldName, '1');
            end;
          self.Columns[J].Visible := True
        end
      else
        begin
          if Assigned(fOnClickPanel) then fOnClickPanel(Sender, self.Columns[J].FieldName, '0');
          if fFile then
            begin
              if self.DataSource<>nil then
                WriteIni(fName+self.Name+self.DataSource.DataSet.Name, self.Columns[J].FieldName, '0')
              else
                WriteIni(fName+self.Name, self.Columns[J].FieldName, '0');
            end;
          self.Columns[J].Visible := False;
        end;
    end;


  {for I := 0 to CBcol.ItemIndex do
    begin
      for J := 0 to self.Columns.Count-1 do
        begin
          if CBcol.Items.Strings[I]=self.Columns[J].Title.Caption then
            begin
              if CBcol.Checked[I] then
                begin
                  if Assigned(fOnClickPanel) then fOnClickPanel(Sender, self.Columns[J].FieldName, '1');
                  if fFile then
                    begin
                      if self.DataSource<>nil then
                        WriteIni(fName+self.Name+self.DataSource.DataSet.Name, self.Columns[J].FieldName, '1')
                      else
                        WriteIni(fName+self.Name, self.Columns[J].FieldName, '1');
                    end;
                  self.Columns[J].Visible := True
                end
              else
                begin
                  if Assigned(fOnClickPanel) then fOnClickPanel(Sender, self.Columns[J].FieldName, '0');
                  if fFile then
                    begin
                      if self.DataSource<>nil then
                        WriteIni(fName+self.Name+self.DataSource.DataSet.Name, self.Columns[J].FieldName, '0')
                      else
                        WriteIni(fName+self.Name, self.Columns[J].FieldName, '0');
                    end;
                  self.Columns[J].Visible := False;
                end;
            end;
        end;
    end;  }
end;



procedure TDBGridEhColumn.CLBox1DblClick(Sender: TObject);
var
 I, J: Integer;
begin
 // J := Integer(CBcol.Items.Objects[CBcol.ItemIndex]);
 // if Assigned(fOnDblClickPanel) then fOnDblClickPanel(Sender, self.Columns[J].FieldName, IntToStr(J));
end;

var
 YKoord: Integer;

procedure TDBGridEhColumn.CheckListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 I, J: Integer;
begin
 Ykoord := Y;
  {LBForm.Visible := False;
  if Button=mbRight then
    begin
      J := Integer(CBcol.Items.Objects[CBcol.ItemIndex]);
      if Assigned(fOnDblClickPanel) then fOnDblClickPanel(Sender, self.Columns[J].FieldName, IntToStr(J));

      LBForm.Visible := True;
      LBForm.Left := CBcol.Left+CBcol.Width+5;
      LBForm.Top := CBcol.Top + Y;
      //LBForm.Left := (self.Width div 2)-(LBForm.Width div 2);
    //  LBForm.Top := (self.Height div 2)-(LBForm.Height div 2);
      LBForm.Clear;

      if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TDateTimeField' then
        begin
          LBForm.Items.Add('');        
          LBForm.Items.Add('dd.mm.yy');
          LBForm.Items.Add('dd.mm.yy hh:MM:ss');
          LBForm.Items.Add('dd.mm.yyyy');
          LBForm.Items.Add('dd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dddd.mm.yyyy');
          LBForm.Items.Add('dddd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dddd dd.mm.yyyy');
          LBForm.Items.Add('dddd dd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dd.mmmm.yyyy');
          LBForm.Items.Add('dd.mmmm.yyyy hh:MM:ss');
          LBForm.Items.Add('dd dddd mmmm yyyy');
          LBForm.Items.Add('dd dddd mmmm yyyy hh:MM:ss');
          LBForm.Items.Add('dddd dd mmmm yyyy');
          LBForm.Items.Add('dddd dd mmmm yyyy hh:MM:ss');
          LBForm.Items.Add('dddd mm');
          LBForm.Items.Add('dddd mm hh:MM:ss');
          LBForm.Items.Add('dddd mmmm');
          LBForm.Items.Add('dddd mmmm hh:MM:ss');
          LBForm.Items.Add('mm yyyy');
          LBForm.Items.Add('mm yyyy hh:MM:ss');
          LBForm.Items.Add('mm yy');
          LBForm.Items.Add('mm yy hh:MM:ss');
        end;

      if (self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TFloatField')
      or (self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TMoneyField')  then
        begin
          LBForm.Items.Add('');
          LBForm.Items.Add('0.0');
          LBForm.Items.Add('##.0');
          LBForm.Items.Add('#.#');
          LBForm.Items.Add('0.00');
          LBForm.Items.Add('0.#');
          LBForm.Items.Add('0.0000');
          LBForm.Items.Add('#.#########');
          LBForm.Items.Add('0');
          LBForm.Items.Add('#');
        end;


    end;  }
end;

procedure TDBGridEhColumn.LB1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 I, J: Integer;
begin
  if Button=mbRight then
    begin
     // if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TDateTimeField' then
        begin
          self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat := LBForm.Items.Strings[LBForm.ItemIndex];
        end;
    end;
   inherited;
end;
       {
procedure TDBGridEhColumn.LB1DblClick(Sender: TObject);
begin
  if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TDateTimeField' then
    begin
      self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat := LBForm.Items.Strings[LBForm.ItemIndex];
    end;
end; }


procedure TDBGridEhColumn.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TDBGridEhColumn.Loaded; // вызывается когда прочитаны все свойства из файлв dfm.
begin
  inherited;
  self.ApplyColorScript(self);
end;

procedure TDBGridEhColumn.DB_DATAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 I, J: Integer;
begin

  if key=vk_Right then
    begin
      key := 0;
      
      J := Integer(CBcol.Items.Objects[CBcol.ItemIndex]);
      if Assigned(fOnDblClickPanel) then fOnDblClickPanel(Sender, self.Columns[J].FieldName, IntToStr(J));

      LBForm.Visible := True;
      LBForm.Left := CBcol.Left+CBcol.Width+5;
      LBForm.Top := CBcol.Top + YKoord;

      LBForm.SetFocus;
      //LBForm.Left := (self.Width div 2)-(LBForm.Width div 2);
    //  LBForm.Top := (self.Height div 2)-(LBForm.Height div 2);
      LBForm.Clear;

      if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TDateTimeField' then
        begin
          LBForm.Items.Add('');
          LBForm.Items.Add('dd.mm.yy');
          LBForm.Items.Add('dd.mm.yy hh:MM:ss');
          LBForm.Items.Add('dd.mm.yyyy');
          LBForm.Items.Add('dd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dddd.mm.yyyy');
          LBForm.Items.Add('dddd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dddd dd.mm.yyyy');
          LBForm.Items.Add('dddd dd.mm.yyyy hh:MM:ss');
          LBForm.Items.Add('dd.mmmm.yyyy');
          LBForm.Items.Add('dd.mmmm.yyyy hh:MM:ss');
          LBForm.Items.Add('dd dddd mmmm yyyy');
          LBForm.Items.Add('dd dddd mmmm yyyy hh:MM:ss');
          LBForm.Items.Add('dddd dd mmmm yyyy');
          LBForm.Items.Add('dddd dd mmmm yyyy hh:MM:ss');
          LBForm.Items.Add('dddd mm');
          LBForm.Items.Add('dddd mm hh:MM:ss');
          LBForm.Items.Add('dddd mmmm');
          LBForm.Items.Add('dddd mmmm hh:MM:ss');
          LBForm.Items.Add('mm yyyy');
          LBForm.Items.Add('mm yyyy hh:MM:ss');
          LBForm.Items.Add('mm yy');
          LBForm.Items.Add('mm yy hh:MM:ss');

          for I := 0 to LBForm.Items.Count - 1 do
            begin
              if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat=LBForm.Items.Strings[I] then
                LBForm.ItemIndex := i;
            end;


//          self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat
        end;

      if (self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TFloatField')
      or (self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].Field.ClassName='TMoneyField')  then
        begin
          LBForm.Items.Add('');
          LBForm.Items.Add('0.0');
          LBForm.Items.Add('##.0');
          LBForm.Items.Add('#.#');
          LBForm.Items.Add('0.00');
          LBForm.Items.Add('0.#');
          LBForm.Items.Add('0.0000');
          LBForm.Items.Add('#.#########');
          LBForm.Items.Add('0');
          LBForm.Items.Add('#');

          for I := 0 to LBForm.Items.Count - 1 do
            begin
              if self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat=LBForm.Items.Strings[I] then
                LBForm.ItemIndex := i;
            end;   
        end;

  end;

end;

procedure TDBGridEhColumn.LBFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 I, J: Integer;
begin
  if key=vk_return then
    begin
      self.Columns[Integer(CBcol.Items.Objects[CBcol.ItemIndex])].DisplayFormat := LBForm.Items.Strings[LBForm.ItemIndex];
    end;
    
  if key=vk_Left then
    begin
      LBForm.Visible := False;
      CBcol.SetFocus;
    end;

end;

constructor TDBGridEhColumn.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  words := TstringList.Create;
  fView := True;
  fpath := 'file.ini';
  fFile := False;
  fColor := $00E2EFF1;
 // SetColorPanelScript('');

  CBcol := TCheckListBox.Create(self);
  CBcol.Left := -150;
  CBcol.Top := -200;
  CBcol.Visible := False;
  CBcol.Parent := self;
  CBcol.OnClickCheck := CBcol1ClickCheck;
//  CBcol.OnDblClick :=  CLBox1DblClick;
  CBcol.OnMouseUp := CheckListBox1MouseUp;
  CBcol.OnKeyDown := DB_DATAKeyDown;;
  CBcol.BorderStyle := bsNone;
  CBcol.Flat := True;
  CBcol.Ctl3D := False;
  CBcol.BevelKind := bkSoft;
  CBcol.Color := FColor;


  LBForm := TListBox.Create(self);
  LBForm.Parent := self;
  LBForm.Visible := false;
  LBForm.Left := -500;
  LBForm.Height := 200;
  LBForm.Width := 180;
  LBForm.Ctl3D := False;
  LBForm.BorderStyle := bsNone;
  LBForm.BevelKind := bkSoft;
  LBForm.Color := FColor;
 // LBForm.OnDblClick := LB1DblClick;
  LBForm.OnKeyDown := LBFormKeyDown;
  LBForm.OnMouseDown := ListBox1MouseDown;

///////////////////////////
  Pan := TPanel.Create(self);
  Pan.Left := -1050;
  Pan.Top := -2000;
  Pan.Height := 230;
  Pan.Width := 360;
  Pan.Visible := False;
  Pan.Parent := self;
//  Pan.BorderStyle := bsSingle;
  Pan.Ctl3D := False;
  Pan.BevelInner := bvNone;
  Pan.BevelKind := bkSoft;
  Pan.BevelOuter := bvNone;
 // Pan.Color := FColor;

  Mem := TMemo.Create(Pan);
 // Mem.Visible := False;
  Mem.Parent := Pan;
  Mem.Left := 14;
  Mem.Top := 44;
  Mem.Height := 90;
  Mem.Width := 330;
  mem.ScrollBars := ssVertical;
  Mem.BorderStyle := bsSingle;
  Mem.ParentCtl3D := false;
  Mem.Ctl3D := False;
  Mem.BevelInner := bvRaised;
  Mem.BevelKind := bkNone;
  Mem.BevelOuter := bvLowered;

//  Mem.Color := FColor;

  MemError := TMemo.Create(Pan);
 // MemError.Visible := False;
  MemError.Parent := Pan;
  MemError.Left := 14;
  MemError.Top := 135;
  MemError.Height := 59;
  MemError.Width := 330;
  MemError.ScrollBars := ssBoth;
  MemError.BorderStyle := bsSingle;
  MemError.ParentCtl3D := false;
  MemError.Ctl3D := False;
  MemError.BevelInner := bvRaised;
  MemError.BevelKind := bkNone;
  MemError.BevelOuter := bvLowered;
  
  Mem.OnChange := MemChange;


  ButOK :=  TSpeedButton.Create(Pan);
 // ButOK.Visible := False;
  ButOK.Parent := Pan;
  ButOK.Left := 189;
  ButOK.Top := 200;
  ButOK.Height := 25;
  ButOK.Width := 75;
  ButOK.Caption := 'Применить';
  ButOK.Flat := true;
  ButOK.OnClick := ButOKClick;

  ButExit :=  TSpeedButton.Create(Pan);
 // ButExit.Visible := False;
  ButExit.Parent := Pan;
  ButExit.Left := 270;
  ButExit.Top := 200;
  ButExit.Height := 25;
  ButExit.Width := 75;
  ButExit.Caption := 'Отмена';
  ButExit.Flat := true;
  ButExit.OnClick := ButExitClick;

//  ShowMessage(FColorPanelIniFiles);
//  ApplyColorScript(self);
//  a_pole, a_value, a_znak, a_color
end;

function ReplaceSub(str, sub1, sub2: string): string;
var
  aPos: Integer;
  rslt: string;
begin
  aPos := Pos(sub1, str);
  rslt := '';
  while (aPos <> 0) do
  begin
    rslt := rslt + Copy(str, 1, aPos - 1) + sub2;
    Delete(str, 1, aPos + Length(sub1) - 1);
    aPos := Pos(sub1, str);
  end;
  Result := rslt + str;
end;

procedure TDBGridEhColumn.ButExitClick(Sender: TObject);
begin
 Pan.Visible := false;
end;

procedure TDBGridEhColumn.ButOKClick(Sender: TObject);
begin
 SetColorPanelScript(mem.Lines);

end;


Function  TDBGridEhColumn.ApplyColorScript(Sender: TObject): Boolean;
var
  s_color, Stmp, SData, s_pole, s_value, s_znak  : String;
  b_res1, b_res2: Boolean;
  Tip : SmallInt;
  c_color: TColor;
  Label 1, 2;
begin
  result := true;
  SetLength(a_pole,1);
  SetLength(a_value,1);
  SetLength(a_znak,1);
  SetLength(a_color,1);
  SetLength(a_pole2,1);
  SetLength(a_value2,1);
  SetLength(a_znak2,1);
  SetLength(a_tip,1);  

  try
   if GetColorPanelScript.Text<>'' then
     begin
       STMP := GetColorPanelScript.Text;
       if Assigned(fOnColorPanelScript) then fOnColorPanelScript(Sender, STMP);
1:
       if Pos(';', STMP)<>0 then
         begin

           Sdata := Copy(stmp, 1, Pos(';', stmp));
           if Sdata='' then
             goto 2;
           delete(stmp, 1,Pos(';', stmp));
           sdata := ReplaceSub(sdata, #13, '');
           sdata := ReplaceSub(sdata, #10, '');


           ///
           delete(sdata, 1, Pos('[', sdata));
           s_pole := Copy(sdata, 1, Pos(']', sdata)-1);

           delete(sdata, 1, Pos(']', sdata));
           s_znak := Copy(sdata, 1, Pos(#39, sdata)-1);

           delete(sdata, 1, Pos(#39, sdata));
           s_value := Copy(sdata, 1, Pos(#39, sdata)-1);


           SetLength(a_pole,High(a_pole)+2);
           SetLength(a_value,High(a_value)+2);
           SetLength(a_znak,High(a_znak)+2);

           a_pole[High(a_pole)-1] := s_pole;
           a_value[High(a_value)-1] := s_value;
           a_znak[High(a_znak)-1] :=  s_znak;    

         //  ShowMessage(IntToStr(High(a_pole)) +' - '+s_pole);                  
           
           {    a_pole, a_value, a_znak, a_pole2, a_value2, a_znak2 : array of String[100];
                a_color: array of color;
                c_tip: array of SmallInt;}

         //  b_res1 := ProvUslovie(s_pole, s_value, s_znak);

           tip := 0;
           if (Pos(AnsiUpperCase('and'), AnsiUpperCase(sdata))<>0)or(Pos(AnsiUpperCase('or'), AnsiUpperCase(sdata))<>0) then
             begin
               if Pos(AnsiUpperCase('and'), AnsiUpperCase(sdata))<>0 then
                 Tip := 1;
               if Pos(AnsiUpperCase('or'), AnsiUpperCase(sdata))<>0 then
                 Tip := 2;
               ///
               delete(sdata, 1, Pos('[', sdata));
               s_pole := Copy(sdata, 1, Pos(']', sdata)-1);

               delete(sdata, 1, Pos(']', sdata));
               s_znak := Copy(sdata, 1, Pos(#39, sdata)-1);

               delete(sdata, 1, Pos(#39, sdata));
               s_value := Copy(sdata, 1, Pos(#39, sdata)-1);

             //  b_res2 := ProvUslovie(s_pole, s_value, s_znak);

               delete(sdata, 1, Pos('->', sdata)+1);
               delete(sdata, Pos(';', sdata), Pos(';', sdata)+1);
               s_color := ReplaceSub(sdata,' ', '');
               c_color :=  StringToColor(s_color);

                         
//               if (Tip=1)and(b_res1 and b_res2) then
//                 DB_DATA.Canvas.Font.Color := c_color;
//
//               if (Tip=2)and(b_res1 or b_res2) then
//                 DB_DATA.Canvas.Font.Color := c_color;
             end
           else
             begin
               delete(sdata, 1, Pos('->', sdata)+1);
               delete(sdata, Pos(';', sdata), Pos(';', sdata)+1);
               s_color := ReplaceSub(sdata,' ', '');
               c_color :=  StringToColor(s_color);

             {  SetLength(a_color,High(a_color)+2);
               a_color[High(a_color)-1] :=  c_color;  }

//               if b_res1 then
//                 DB_DATA.Canvas.Font.Color := c_color;
             end;

           SetLength(a_tip,High(a_tip)+2);
           a_tip[High(a_tip)-1] := tip;
               
           SetLength(a_pole2,High(a_pole2)+2);
           SetLength(a_value2,High(a_value2)+2);
           SetLength(a_znak2,High(a_znak2)+2);

           a_pole2[High(a_pole2)-1] := s_pole;
           a_value2[High(a_value2)-1] := s_value;
           a_znak2[High(a_znak2)-1] :=  s_znak;    

           SetLength(a_color,High(a_color)+2);
           a_color[High(a_color)-1] :=  c_color;               

2:             
           goto 1;


         end;


     end;
   // MemError.Lines.Text := 'Все в порядке.';
  except
    result := false;
    {on E: Exception do
      begin
        MemError.Lines.Text := e.Message;
      end; }

  end;
{    SetLength(a_pole,1);
  SetLength(a_value,1);
  SetLength(a_znak,1);
  SetLength(a_color,1);}
  
//  ShowMessage(IntToStr(High(a_pole)));
 // ShowMessage(IntToStr(High(a_pole2)));  
end;

procedure TDBGridEhColumn.MemChange(Sender: TObject);
var
  s_color, Stmp, SData, s_pole, s_value, s_znak  : String;
  b_res1, b_res2: Boolean;
  Tip : SmallInt;
  c_color: TColor;
  Label 1, 2;
begin
  try
   if mem.Text<>'' then
     begin
       STMP := mem.Text;     
1:
       if Pos(';', STMP)<>0 then
         begin

           Sdata := Copy(stmp, 1, Pos(';', stmp));
           if Sdata='' then
             goto 2;
           delete(stmp, 1,Pos(';', stmp));
           sdata := ReplaceSub(sdata, #13, '');
           sdata := ReplaceSub(sdata, #10, '');


           ///
           delete(sdata, 1, Pos('[', sdata));
           s_pole := Copy(sdata, 1, Pos(']', sdata)-1);

           delete(sdata, 1, Pos(']', sdata));
           s_znak := Copy(sdata, 1, Pos(#39, sdata)-1);

           delete(sdata, 1, Pos(#39, sdata));
           s_value := Copy(sdata, 1, Pos(#39, sdata)-1);


         //  b_res1 := ProvUslovie(s_pole, s_value, s_znak);

           if (Pos(AnsiUpperCase('and'), AnsiUpperCase(sdata))<>0)or(Pos(AnsiUpperCase('or'), AnsiUpperCase(sdata))<>0) then
             begin
               if Pos(AnsiUpperCase('and'), AnsiUpperCase(sdata))<>0 then
                 Tip := 1;
               if Pos(AnsiUpperCase('or'), AnsiUpperCase(sdata))<>0 then
                 Tip := 2;
               ///
               delete(sdata, 1, Pos('[', sdata));
               s_pole := Copy(sdata, 1, Pos(']', sdata)-1);

               delete(sdata, 1, Pos(']', sdata));
               s_znak := Copy(sdata, 1, Pos(#39, sdata)-1);

               delete(sdata, 1, Pos(#39, sdata));
               s_value := Copy(sdata, 1, Pos(#39, sdata)-1);

             //  b_res2 := ProvUslovie(s_pole, s_value, s_znak);

               delete(sdata, 1, Pos('->', sdata)+1);
               delete(sdata, Pos(';', sdata), Pos(';', sdata)+1);
               s_color := ReplaceSub(sdata,' ', '');
               c_color :=  StringToColor(s_color);

//               if (Tip=1)and(b_res1 and b_res2) then
//                 DB_DATA.Canvas.Font.Color := c_color;
//
//               if (Tip=2)and(b_res1 or b_res2) then
//                 DB_DATA.Canvas.Font.Color := c_color;
             end
           else
             begin
               delete(sdata, 1, Pos('->', sdata)+1);
               delete(sdata, Pos(';', sdata), Pos(';', sdata)+1);
               s_color := ReplaceSub(sdata,' ', '');
               c_color :=  StringToColor(s_color);

//               if b_res1 then
//                 DB_DATA.Canvas.Font.Color := c_color;
             end;

2:             
           goto 1;


         end;


     end;
    MemError.Lines.Text := 'Все в порядке.';
  except
    on E: Exception do
      begin
        MemError.Lines.Text := e.Message;
      end;

  end;
end;




procedure TDBGridEhColumn.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 I, Ikon: Integer;
 max: Integer;
 Label 1, 2;
begin
  if LBForm.Visible then
    LBForm.Visible := False;

  if Button=mbLeft then
    begin
      if ((X<=14)and(Y<=17))and(fView) then
        begin
          if CBcol.Visible = True then
            begin
              CBcol.Visible := False;
              goto 1;
            end;

          {SGlobHint := Self.Hint;
          BGlobShow := Self.ShowHint; }
          max := 0;
          Ikon := 0;
          CBcol.Items.Clear;
          for I := 0 to self.Columns.Count-1 do
            begin
              if self.Columns[I].Tag=0 then
                begin
                  if max<self.Canvas.TextWidth(self.Columns[I].Title.Caption) then
                     max := self.Canvas.TextWidth(self.Columns[I].Title.Caption);

                 // CBcol.Items.Add(self.Columns[I].Title.Caption);
                  CBcol.Items.AddObject(self.Columns[I].Title.Caption, TObject(I));

                  if self.Columns[I].Visible then
                    CBcol.Checked[IKon] := True
                  else
                    CBcol.Checked[IKon] := False;
                  Inc(IKon);
                end;
            end;

          CBcol.Left := 15;
          CBcol.Width := 200;
          CBcol.Top := 20;

          CBcol.Width := max+30;
         // if self.Height-44<145 then
            CBcol.Height := self.Height-44;
         { else
            CBcol.Height := 145;    }

          Bglob := True;
          Self.Hint := SGlobHint;
          Self.ShowHint := BGlobShow;

          CBcol.Visible := True;
        end
      else
        CBcol.Visible := False;
    end;


1:
  if Button=mbRight then
    begin
      if ((X<=14)and(Y<=17)) then
        begin
          if Pan.Visible = True then
            begin
              Pan.Visible := False;
              goto 2;
            end;
          Pan.Left := (self.Width div 2)-(Pan.Width div 2);
          Pan.Top := (self.Height div 2)-(Pan.Height div 2);
          Pan.Visible := true;
          Mem.Lines.Text := GetColorPanelScript.Text;
          Pan.SetFocus;
          Pan.BringToFront;
          self.SendToBack;
        end
      else
        Pan.Visible := false;
    end;

{  if (Button<>mbLeft) then
    begin
      CBcol.Visible := False;
    end;
  if (Button<>mbRight) then
    begin
      Pan.Visible := false;
    end;}

2:
  inherited;
//
end;

procedure TDBGridEhColumn.paint;
var
OldBkMode: Integer;
begin
  try
   inherited;
  except

  end;

  if fView then
    begin
      CBcol.Height := self.Height-44;
      OldBkMode := SetBkMode(self.Canvas.Handle, TRANSPARENT);
      self.Canvas.Font.Color := 0;
      self.Canvas.Font.Style := [];
      self.Canvas.TextOut(1,-2,'...');
      SetBkMode(self.Canvas.Handle, OldBkMode);
    end;


//
end;


procedure Register;
begin
  RegisterComponents('EhLib', [TDBGridEhColumn]);
end;


procedure TDBGridEhColumn.Show;
begin

end;

{ TCBcol }



procedure TDBGridEhColumn.ApplyColumnFromIni;
var
 S: String;
 I : Integer;
begin
   for I := 0 to self.Columns.Count-1 do
    begin
      if self.DataSource<>nil then
        S := ReadIni(fName+self.Name+self.DataSource.DataSet.Name, self.Columns[I].FieldName)
      else
        S := ReadIni(fName+self.Name, self.Columns[I].FieldName);

      if S<>'' then
        begin
          try
            if S='1' then
              self.Columns[I].Visible := True;
            if S='0' then
              self.Columns[I].Visible := False;
          except
          end;
        end;
    end;


  For I:=0 to self.Columns.Count-1 do
    begin 
      if self.DataSource<>nil then
        S := ReadIni(self.INI_NAME+self.Name+self.DataSource.DataSet.Name+'SIZE', self.Columns[I].FieldName)
      else
        S := ReadIni(self.INI_NAME+self.Name+'SIZE', self.Columns[I].FieldName);
      if S<>'' then
        self.Columns[I].Width := StrToInt(S);
    end;
end;






procedure TDBGridEhColumn.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  SHint : String;
  BShow : Boolean;

begin

  if CBcol.Visible = False then
    begin
      if ((X<=14)and(Y<=17))and(fView) then
        begin
          if Bglob then
            begin
             SGlobHint := Self.Hint;
             BGlobShow := Self.ShowHint;
             Bglob := False;
            end;

          Self.Hint := 'Левой кнопкой мыши: Нажмите сюда для выбора видимых колонок.'+#13+
                       'Правой кнопкой мыши: Нажмите сюда для создания скрипта выделения цветом ячеек.';
          Self.ShowHint := True;
        end ;

      if (X>14)and(Y>17) then
        begin
          Bglob := True;
          Self.Hint := SGlobHint;
          Self.ShowHint := BGlobShow;
        end;
    end;

  inherited;
end;

function TDBGridEhColumn.GetNAME: String;
begin
  result := fName;
end;

procedure TDBGridEhColumn.SetNAME(const Value: String);
begin
  fName := Value;
end;



destructor TDBGridEhColumn.Destroy;
var
 I: Integer;
 S: String;
begin
  if fFile then
    begin
      For I:=0 to self.Columns.Count-1 do
        begin
          if self.Columns[I].Visible then
            begin
              S := IntToStr(self.Columns[I].Width);

              if self.DataSource<>nil then
                WriteIni(fNAME+self.Name+self.DataSource.DataSet.Name+'SIZE', self.Columns[I].FieldName, S)
              else
                WriteIni(fNAME+self.Name+'SIZE', self.Columns[I].FieldName, S);

            end;
        end;
    end;

  words.Free;

  inherited;
end;

Function TDBGridEhColumn.ProvUslovie(Pole, Value, Znak: String): Boolean;
var
  I: Integer;
  i_value : Real;
  i_Num: Integer;
  s_FieldName : String;
  b_value: Boolean;
begin
  i_Num := -1;
  result := false;

  for I := 0 to self.Columns.Count-1 do
    begin
      if Pole=self.Columns[I].Title.Caption then
        begin
          i_num := I;
        end;
    end;



  if I_num<>-1 then
    begin
      s_FieldName := self.Columns[i_num].FieldName;    

      if (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TCurrencyField') or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TIntegerField') or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TFloatField')  or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TSmallintField')or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TDoubleField')   then
         begin
            b_value := True;
            try
              i_value := StrToFloat(Value);
            except
              b_value := false;
            end;
         end;



      if (b_value) and
        ((self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TCurrencyField') or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TIntegerField') or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TFloatField')  or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TSmallintField')or
         (self.DataSource.DataSet.FieldByName(s_FieldName).ClassName = 'TDoubleField'))   then
         begin
//          memo2.Lines.Add('I '+self.DataSource.DataSet.FieldByName(s_FieldName).Value+'-'+znak+'-'+value);
          if (znak='=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value=i_value) then result:=True;
          if (znak='<')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<i_value) then result:=True;
          if (znak='>')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value>i_value) then result:=True;
          if (znak='<>')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<>i_value) then result:=True;
          if (znak='<=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<=i_value) then result:=True;
          if (znak='>=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value>=i_value) then result:=True;
         end
      else
        begin
//          memo2.Lines.Add(self.DataSource.DataSet.FieldByName(s_FieldName).Value+'-'+znak+'-'+value);
          if (znak='=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value=value) then result:=True;
          if (znak='<')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<value) then result:=True;
          if (znak='>')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value>value) then result:=True;
          if (znak='<>')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<>value) then result:=True;
          if (znak='<=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value<=value) then result:=True;
          if (znak='>=')and(self.DataSource.DataSet.FieldByName(s_FieldName).Value>=value) then result:=True;
        end;
//        if self.DataSource.DataSet.FieldByName(s_FieldName).Value=value then
//          memo2.Lines.Add('все верно');
    end;



//
end;

procedure TDBGridEhColumn.SplitTextIntoWords(const S: string; words: TstringList);
var
   startpos, endpos: Integer;
begin
   Assert(Assigned(words));
   words.Clear;
   startpos := 1;
   while startpos <= Length(S) do
   begin
     // skip non-letters
    while (startpos <= Length(S)) and not {IsCharAlpha}(S[startpos]<>' ') do
       Inc(startpos);
     if startpos <= Length(S) then
     begin
       // find next non-letter
      endpos := startpos + 1;
       while (endpos <= Length(S)) and {IsCharAlpha}(S[endpos]<>' ') do
         Inc(endpos);
       words.Add(Copy(S, startpos, endpos - startpos));
       startpos := endpos + 1;
     end; { If }
   end; { While }
end;

procedure TDBGridEhColumn.DrawColumnCell( const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  b_res1, b_res2: Boolean;
  Tip : SmallInt;
  I: Integer;
/////////

 X, X0, kol, J, Ps: Integer;
 S: String;
 CM: array [1..255] of Boolean;
var
  holdColor, oldPen: TColor;
  fontColor, OldBkMode: TColor;

begin


 try
   self.DataSource.DataSet.FieldByName(column.FieldName)
 except
   exit;
 end;


 if self.DataSource.DataSet.FieldByName(column.FieldName).ClassName='TBlobField' then
   exit;   



// ShowMessage('sdfsdf');
  for I := 0 to High(a_pole)-1 do
     begin
       b_res1 := ProvUslovie(a_pole[I], a_value[I], a_znak[I]);
       tip := a_tip[I];
       if Tip<>0 then
         begin
           b_res2 := ProvUslovie(a_pole2[I], a_value2[I], a_znak2[I]);

           if (Tip=1)and(b_res1 and b_res2) then
             Canvas.Font.Color := a_color[I];

           if (Tip=2)and(b_res1 or b_res2) then
             Canvas.Font.Color := a_color[I];

         end
       else
         begin
           if b_res1 then
             begin
               Canvas.Font.Color := a_color[I];
             //  ShowMessage('sdfsdf');
             end;

         end;
     end;


  inherited;

  DefaultDrawColumnCell(Rect, DataCol, Column, State);   


  if SFilter<>'' then
    begin
      holdColor := self.Canvas.Brush.Color; {сохраняем оригинальный цвет}
      fontColor := self.Canvas.Font.Color; {сохраняем оригинальный цвет}
      oldPen := self.Canvas.Pen.Color;

      For I:= 1 to 255 do
        CM[I] := False;

        if (SFilterName='')and(not Column.Checkboxes)and(not Assigned(column.ImageList)) then
          begin
            S := copy(Column.Field.AsString,1,255);

  ///////////////

            SplitTextIntoWords(SFilter, words);
            Kol := 0;
            For I := 0 to words.Count-1 do
              begin
                ps := Pos(AnsiUpperCase(words.Strings[I]), AnsiUpperCase(S));
                if ps<>0 then
                  begin
                    For J := 1 to Length(words.Strings[I]) do
                      begin
                        CM[ps+j-1] := True;
                      end;

                  end;
              end;


  /////////////////
            self.Canvas.FillRect(Rect);
            X := Rect.Left+2;

            For I := 1 to Length(S) do
              begin
                if CM[I]=True then
                  begin
                    self.Canvas.Brush.Color := clYellow;
                    self.Canvas.Font.Color := clBlue;
                    self.Canvas.Pen.Color := clYellow;
                    self.Canvas.Rectangle(X,Rect.Top+1,X+self.Canvas.TextWidth(S[I]),Rect.Bottom-1);
                  end
                else
                  begin
                    self.Canvas.Brush.Color := holdColor;
                    self.Canvas.Font.Color := fontColor;
                    self.Canvas.Pen.Color := oldPen;
                  end;

                OldBkMode := SetBkMode(self.Canvas.Handle, TRANSPARENT);
                self.Canvas.TextOut(X, Rect.Top+1, S[I]);
                SetBkMode(self.Canvas.Handle, OldBkMode);



                X := X+ self.Canvas.TextWidth(S[I]);


              end;



            { OldBkMode := SetBkMode(self.Canvas.Handle, TRANSPARENT);
             self.Canvas.TextOut(Rect.Left+2, Rect.Top+1, S);
             SetBkMode(self.Canvas.Handle, OldBkMode);       }


          end
       else
         begin
           if Column.FieldName = SFilterName then
              begin
                S := Column.Field.AsString;
      ///////////////
                SplitTextIntoWords(SFilter, words);
                Kol := 0;
                For I := 0 to words.Count-1 do
                  begin
                    ps := Pos(AnsiUpperCase(words.Strings[I]), AnsiUpperCase(S));
                    if ps<>0 then
                      begin
                        For J := 1 to Length(words.Strings[I]) do
                          begin
                            CM[ps+j-1] := True;
                          end;

                      end;
                  end;

      /////////////////
                self.Canvas.FillRect(Rect);
                X := Rect.Left+2;
                For I := 1 to Length(S) do
                  begin
                    if CM[I]=True then
                      begin
                        self.Canvas.Brush.Color := clYellow;
                        self.Canvas.Font.Color := clBlue;
                        self.Canvas.Pen.Color := clYellow;
                        self.Canvas.Rectangle(X,Rect.Top+1,X+self.Canvas.TextWidth(S[I]),Rect.Bottom-1);
                      end
                    else
                      begin
                        self.Canvas.Brush.Color := holdColor;
                        self.Canvas.Font.Color := fontColor;
                        self.Canvas.Pen.Color := oldPen;
                      end;

                    OldBkMode := SetBkMode(self.Canvas.Handle, TRANSPARENT);
                    self.Canvas.TextOut(X, Rect.Top+1, S[I]);
                    SetBkMode(self.Canvas.Handle, OldBkMode);



                    X := X+ self.Canvas.TextWidth(S[I]);

                  end;
                  //self.Canvas.Brush.Color := clRed;
                 // self.Canvas.Font.Style := [fsItalic];
                  //self.Canvas.Font.Color := clAqua;


              end;
         end;
       //self.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;

/////////////////




// self.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;



end.

