unit EhLibPostgresDac;

{$I EhLib.Inc}

interface

uses
  DbUtilsEh, DB, DBGridEh, PSQLDbTables, DACQueryIzm, SysUtils, ToolCtrlsEh;

implementation

uses Classes;


procedure SortDataInADODataSet(Grid: TCustomDBGridEh; DataSet: TDACQueryIzm);
var
  s: String;
  i: Integer;
begin
  s := '';
  for i := 0 to Grid.SortMarkedColumns.Count - 1 do
  begin
    s := s + Grid.SortMarkedColumns[i].FieldName;
    if Grid.SortMarkedColumns[i].Title.SortMarker = smUpEh
      then s := s + ' DESC, '
      else s := s + ', ';
  end;
  DataSet.Filter := '1=1 order by '+Copy(s, 1, Length(s) - 2);
//  DataSet.Sort := Copy(s, 1, Length(s) - 2);
end;

type

  TADOSQLDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
  //  procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    constructor Create; override;
  end;

  TADOCommandTextDatasetFeaturesEh = class(TCommandTextDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    constructor Create; override;
  end;

//implementation
{
function DateValueToSDSQLStringProc(DataSet: TDataSet; Value: Variant): String;
begin
 Result := DateValueToDataBaseSQLString(GetServerTypeName(TPSQLQuery(DataSet).Database.ServerType), Value)
end;

procedure TADOSQLDatasetFeaturesEh.ApplyFilter(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
var
  vDBGridEh   : TCustomDBGridEh;
begin
  if (Sender is TDBGridEh)then
  begin
    if (Sender as TDBGridEh).STFilter.Local then
    begin
      TPSQLQuery(DataSet).Filter :=
        GetExpressionAsFilterString((Sender as TCustomDBGridEh),
        GetOneExpressionAsLocalFilterString, nil, False, True);
      TPSQLQuery(DataSet).Filtered := True;
    end else
    begin
     ApplyFilterSQLBasedDataSet(( Sender as TCustomDBGridEh ), nil(*DateValueToSDSQLStringProc*),
       IsReopen, 'SelectSQL');
    end;
  end;
end;
   }
procedure TADOSQLDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
begin
  if Sender is TCustomDBGridEh then
    if TCustomDBGridEh(Sender).SortLocal then
      SortDataInADODataSet(TCustomDBGridEh(Sender), TDACQueryIzm(DataSet))
    else
      inherited ApplySorting(Sender, DataSet, IsReopen);
end;

constructor TADOSQLDatasetFeaturesEh.Create;
begin
  inherited Create;
  SupportsLocalLike := True;
end;


procedure TADOCommandTextDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
begin
  if Sender is TCustomDBGridEh then
      SortDataInADODataSet(TCustomDBGridEh(Sender), TDACQueryIzm(DataSet))
    else
      inherited ApplySorting(Sender, DataSet, IsReopen);
end;

constructor TADOCommandTextDatasetFeaturesEh.Create;
begin
  inherited Create;
  SupportsLocalLike := True;
end;

initialization
  RegisterDatasetFeaturesEh(TADOSQLDatasetFeaturesEh, TDACQueryIzm);

end.