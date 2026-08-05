unit NFCeModel;

interface
type TNFceModel = class
  private
    Fchave: string;
    Fstatus: string;
    Fxml: string;
    procedure Setchave(const Value: string);
    procedure Setstatus(const Value: string);
    procedure Setxml(const Value: string);
  published
  property chave:string read Fchave write Setchave;
  property status:string read Fstatus write Setstatus;
  property xml:string read Fxml write Setxml;
end;

implementation

{ TNFceModel }

procedure TNFceModel.Setchave(const Value: string);
begin
  Fchave := Value;
end;

procedure TNFceModel.Setstatus(const Value: string);
begin
  Fstatus := Value;
end;

procedure TNFceModel.Setxml(const Value: string);
begin
  Fxml := Value;
end;

end.
