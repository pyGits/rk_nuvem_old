unit Classe.NaoFiscal;

interface
type TNaoFiscal = class
  private
    FValor: real;
    FHora: TTime;
    FDescricao: string;
    Findice: string;
    FFinalizadora: string;
    FVendedor: integer;
    Fdata: TDate;
    Fcodigo: string;
    Fcaixa: integer;


    procedure Setdata(const Value: TDate);

    procedure SetDescricao(const Value: string);
    procedure SetFinalizadora(const Value: string);
    procedure SetHora(const Value: TTime);
    procedure Setindice(const Value: string);
    procedure SetValor(const Value: real);
    procedure SetVendedor(const Value: integer);
    procedure Setcodigo(const Value: string);
    procedure Setcaixa(const Value: integer);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property data:TDate read Fdata write Setdata;
  property indice :string read Findice write Setindice;
  property Descricao:string read FDescricao write SetDescricao;
  property Valor:real read FValor write SetValor;
  property Hora:TTime read FHora write SetHora;
  property Vendedor:integer read FVendedor write SetVendedor;
  property Finalizadora:string read FFinalizadora write SetFinalizadora;
  property caixa:integer read Fcaixa write Setcaixa;
end;

implementation

{ TNaoFiscal }


procedure TNaoFiscal.Setcaixa(const Value: integer);
begin
  Fcaixa := Value;
end;

procedure TNaoFiscal.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TNaoFiscal.Setdata(const Value: TDate);
begin
  Fdata := Value;
end;


procedure TNaoFiscal.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TNaoFiscal.SetFinalizadora(const Value: string);
begin
  FFinalizadora := Value;
end;


procedure TNaoFiscal.SetHora(const Value: TTime);
begin
  FHora := Value;
end;

procedure TNaoFiscal.Setindice(const Value: string);
begin
  Findice := Value;
end;

procedure TNaoFiscal.SetValor(const Value: real);
begin
  FValor := Value;
end;

procedure TNaoFiscal.SetVendedor(const Value: integer);
begin
  FVendedor := Value;
end;

end.
