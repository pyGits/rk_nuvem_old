unit uStorageController;

interface
uses
  uDmStorage;

type TStorageController = class
  private
  public
  constructor create;
  procedure WriteLog(const msg:string);
end;

implementation

{ TStorageController }

constructor TStorageController.create;
begin
dmStorage := TdmStorage.Create(nil);
end;

procedure TStorageController.WriteLog(const msg: string);
begin
dmStorage.WriteLog(msg);
end;

end.
