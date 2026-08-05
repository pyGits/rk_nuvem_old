unit Classe.Movimentacao;

interface
type TMovimentacao = class
  private
    Ffuncionario: string;
    Fhora: TDateTime;
    FnCupom: string;
    Fqtde: Currency;
    Fitem: integer;
    Fcodproduto: string;
    Forigem: string;
    Fdata: TDate;
    FID: integer;
    Fcaixa: integer;
    procedure Setcodproduto(const Value: string);
    procedure Setdata(const Value: TDate);
    procedure Setfuncionario(const Value: string);
    procedure Sethora(const Value: TDateTime);
    procedure Setitem(const Value: integer);
    procedure SetnCupom(const Value: string);
    procedure Setorigem(const Value: string);
    procedure Setqtde(const Value: Currency);
    procedure SetID(const Value: integer);
    procedure Setcaixa(const Value: integer);
  public
  property ID:integer read FID write SetID;
  property qtde:Currency read Fqtde write Setqtde;
  property data:TDate read Fdata write Setdata;
  property hora:TDateTime read Fhora write Sethora;
  property codproduto:string read Fcodproduto write Setcodproduto;
  property nCupom:string read FnCupom write SetnCupom;
  property item:integer read Fitem write Setitem;
  property funcionario:string read Ffuncionario write Setfuncionario;
  property origem:string read Forigem write Setorigem;
  property caixa:integer read Fcaixa write Setcaixa;
end;

implementation

{ TMovimentacao }

procedure TMovimentacao.Setcaixa(const Value: integer);
begin
  Fcaixa := Value;
end;

procedure TMovimentacao.Setcodproduto(const Value: string);
begin
  Fcodproduto := Value;
end;

procedure TMovimentacao.Setdata(const Value: TDate);
begin
  Fdata := Value;
end;

procedure TMovimentacao.Setfuncionario(const Value: string);
begin
  Ffuncionario := Value;
end;

procedure TMovimentacao.Sethora(const Value: TDateTime);
begin
  Fhora := Value;
end;

procedure TMovimentacao.SetID(const Value: integer);
begin
  FID := Value;
end;

procedure TMovimentacao.Setitem(const Value: integer);
begin
  Fitem := Value;
end;

procedure TMovimentacao.SetnCupom(const Value: string);
begin
  FnCupom := Value;
end;

procedure TMovimentacao.Setorigem(const Value: string);
begin
  Forigem := Value;
end;

procedure TMovimentacao.Setqtde(const Value: Currency);
begin
  Fqtde := Value;
end;

end.
