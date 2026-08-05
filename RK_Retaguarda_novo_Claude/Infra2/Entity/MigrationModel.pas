unit MigrationModel;

interface
uses System.Generics.Collections,System.SysUtils,system.classes;
type TMigrationModel = class
  private
    Fversao: integer;
    Fsql: string;
    FsqlList: TStringList;
    procedure Setsql(const Value: string);
    procedure Setversao(const Value: integer);
    procedure SetsqlList(const Value: TStringList);
  public
  property sql:string read Fsql write Setsql;
  property versao:integer read Fversao write Setversao;
  property sqlList:TStringList read FsqlList write SetsqlList;
end;
type TMigrationList = class
  private
  FItems:TObjectList<TMigrationModel>;
  public
  constructor create;
  procedure Add(sql:string;versao:integer);
  function Items:TObjectList<TMigrationModel>;
  function Total:integer;
end;

implementation

{ TMigrationModel }

procedure TMigrationModel.Setsql(const Value: string);
begin
  Fsql := Value;
end;

procedure TMigrationModel.SetsqlList(const Value: TStringList);
begin
  FsqlList := Value;
end;

procedure TMigrationModel.Setversao(const Value: integer);
begin
  Fversao := Value;
end;

{ TMigrationList }

procedure TMigrationList.Add(sql: string; versao: integer);
begin
FItems.Add(TMigrationModel.create);
FItems.Last.sql := sql;
FItems.Last.Fversao := versao;
end;

constructor TMigrationList.create;
begin
FItems := TObjectList<TMigrationModel>.Create(true);
end;

function TMigrationList.Items: TObjectList<TMigrationModel>;
begin
result := FItems;
end;

function TMigrationList.Total: integer;
begin
Result := FItems.Last.Fversao;
end;

end.
