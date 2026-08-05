unit PdvConnectionList;

interface
uses system.Generics.collections,PDV_Connection;
type
  TPdvConnectionList = class
  private
    Fimport_connection: TPDV_Connection;
    procedure Setimport_connection(const Value: TPDV_Connection);

  public
  property import_connection:TPDV_Connection read Fimport_connection write Setimport_connection;
  constructor create;
end;

var
  PdvConnection_List: TPdvConnectionList;

implementation

{ TPdvConnectionList }

constructor TPdvConnectionList.create;
begin
Fimport_connection := TPDV_Connection.Create('c:\system_rk\pdv\bd\sat_datpdv.fdb');
end;

procedure TPdvConnectionList.Setimport_connection(const Value: TPDV_Connection);
begin
  Fimport_connection := Value;
end;

initialization
  PdvConnection_List := TPdvConnectionList.Create;

end.
