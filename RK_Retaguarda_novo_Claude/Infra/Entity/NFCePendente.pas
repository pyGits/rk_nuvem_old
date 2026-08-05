unit NFCePendente;

interface
type TNFCePendente = class
  private
    Fhora: TDateTime;
    Fcodigo_cupom: string;
    Ftotal: real;
    Fstatus: string;
    Fchave: string;
    Fxml: string;
    Fcod_caixa: integer;
    Fdata: TDate;
    Fretorno: string;
    Fchave_nova: string;
    procedure Setchave(const Value: string);
    procedure Setcod_caixa(const Value: integer);
    procedure Setcodigo_cupom(const Value: string);
    procedure Setdata(const Value: TDate);
    procedure Sethora(const Value: TDateTime);
    procedure Setstatus(const Value: string);
    procedure Settotal(const Value: real);
    procedure Setxml(const Value: string);
    procedure Setretorno(const Value: string);
    procedure Setchave_nova(const Value: string);
  public
  property codigo_cupom:string read Fcodigo_cupom write Setcodigo_cupom;
  property cod_caixa:integer read Fcod_caixa write Setcod_caixa;
  property data:TDate read Fdata write Setdata;
  property hora:TDateTime read Fhora write Sethora;
  property xml:string read Fxml write Setxml;
  property status:string read Fstatus write Setstatus;
  property chave:string read Fchave write Setchave;
  property total:real read Ftotal write Settotal;
  property retorno:string read Fretorno write Setretorno;
//  property chave_nova:string read Fchave_nova write Setchave_nova;

end;

implementation

{ TNFCePendente }

procedure TNFCePendente.Setchave(const Value: string);
begin
  Fchave := Value;
end;

procedure TNFCePendente.Setchave_nova(const Value: string);
begin
  Fchave_nova := Value;
end;

procedure TNFCePendente.Setcodigo_cupom(const Value: string);
begin
  Fcodigo_cupom := Value;
end;

procedure TNFCePendente.Setcod_caixa(const Value: integer);
begin
  Fcod_caixa := Value;
end;

procedure TNFCePendente.Setdata(const Value: TDate);
begin
  Fdata := Value;
end;

procedure TNFCePendente.Sethora(const Value: TDateTime);
begin
  Fhora := Value;
end;

procedure TNFCePendente.Setretorno(const Value: string);
begin
  Fretorno := Value;
end;


procedure TNFCePendente.Setstatus(const Value: string);
begin
  Fstatus := Value;
end;

procedure TNFCePendente.Settotal(const Value: real);
begin
  Ftotal := Value;
end;

procedure TNFCePendente.Setxml(const Value: string);
begin
  Fxml := Value;
end;

end.
