unit Classe.Prevenda;

interface
uses System.SysUtils,System.Generics.collections,Classe.Produto;

type
 TPrevenda = class;
 TPrevendaItem = class;

TPrevenda = class(TObject)
  private
    Ffuncionario: string;
    FvalorAcrescimo: Real;
    FvalorDesconto: real;
    Fcancelado: integer;
    Fcliente: string;
    Fcodigo: string;
    Fstatus: string;
    FvalorTotal: real;
    FcodigoCupom: string;
    Fterminal: string;
    Fdata: TDateTime;
    Fitems: TObjectList<TPrevendaItem>;
    procedure Setcancelado(const Value: integer);
    procedure Setcliente(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure SetcodigoCupom(const Value: string);
    procedure Setdata(const Value: TDateTime);
    procedure Setfuncionario(const Value: string);
    procedure Setstatus(const Value: string);
    procedure Setterminal(const Value: string);
    procedure SetvalorAcrescimo(const Value: Real);
    procedure SetvalorDesconto(const Value: real);
    procedure SetvalorTotal(const Value: real);
    procedure Setitems(const Value: TObjectList<TPrevendaItem>);
  public
  constructor create;
    property codigo:string read Fcodigo write Setcodigo;
    property codigoCupom:string read FcodigoCupom write SetcodigoCupom;
    property funcionario:string read Ffuncionario write Setfuncionario;
    property data:TDateTime read Fdata write Setdata;
    property cliente:string read Fcliente write Setcliente;
    property valorDesconto:real read FvalorDesconto write SetvalorDesconto;
    property valorAcrescimo:Real read FvalorAcrescimo write SetvalorAcrescimo;
    property valorTotal:real read FvalorTotal write SetvalorTotal;
    property terminal:string read Fterminal write Setterminal;
    property cancelado:integer read Fcancelado write Setcancelado;
    property status:string read Fstatus write Setstatus;
    property items:TObjectList<TPrevendaItem> read Fitems write Setitems;

    function getTotal:Currency;

end;

TPrevendaItem = class(TObject)
  private
    Fcodigo_barras: string;
    FvalorAcrescimo: real;
    FvalorDesconto: real;
    Fcodigo: string;
    FvalorUnitario: real;
    FcodigoPrevenda: string;
    Fqtde: Real;
    FvalorTotal: Real;
    Fitem: integer;
    Funidade: string;
    Fterminal: string;
    Fproduto: TProduto;
    procedure Setcodigo(const Value: string);
    procedure Setcodigo_barras(const Value: string);
    procedure SetcodigoPrevenda(const Value: string);
    procedure Setitem(const Value: integer);
    procedure Setqtde(const Value: Real);
    procedure Setunidade(const Value: string);
    procedure SetvalorAcrescimo(const Value: real);
    procedure SetvalorDesconto(const Value: real);
    procedure SetvalorTotal(const Value: Real);
    procedure SetvalorUnitario(const Value: real);
    procedure Setterminal(const Value: string);
    procedure Setproduto(const Value: TProduto);
  public
  constructor create;
  property codigoPrevenda:string read FcodigoPrevenda write SetcodigoPrevenda;
  property codigo:string read Fcodigo write Setcodigo;
  property item:integer read Fitem write Setitem;
  property codigo_barras:string read Fcodigo_barras write Setcodigo_barras;
  property valorUnitario:real read FvalorUnitario write SetvalorUnitario;
  property valorDesconto:real read FvalorDesconto write SetvalorDesconto;
  property valorAcrescimo:real read FvalorAcrescimo write SetvalorAcrescimo;
  property valorTotal:Real read FvalorTotal write SetvalorTotal;
  property qtde:Real read Fqtde write Setqtde;
  property unidade:string read Funidade write Setunidade;
  property terminal:string read Fterminal write Setterminal;

  property produto:TProduto read Fproduto write Setproduto;





end;

implementation
uses
Classe.funcoes;

{ TPrevenda }

constructor TPrevenda.create;
begin
items := TObjectList<TPrevendaItem>.create;
end;

function TPrevenda.getTotal: Currency;
var
  item:TPrevendaItem;
begin
result := 0;
  for item in FItems do
  begin
    result := result + item.valorTotal;
  end;
end;

procedure TPrevenda.Setcancelado(const Value: integer);
begin
  Fcancelado := Value;
end;

procedure TPrevenda.Setcliente(const Value: string);
begin
  Fcliente := Value;
end;

procedure TPrevenda.Setcodigo(const Value: string);
var
  codigoPreVenda:string;
begin
  if (Value = '') then
  begin
    raise Exception.Create('Código de pré venda não pode estar em branco!');
  end;
  if Length(value)> 12 then
  begin
    raise Exception.Create('Limite de 12 caracteres!');
  end;

  codigoPreVenda := Value;
  codigoPreVenda := removeLetras(codigoPreVenda);
  codigoPreVenda := zeroEsquerda(codigoPreVenda,12);

//  free;
  Fcodigo := codigoPreVenda;
end;

procedure TPrevenda.SetcodigoCupom(const Value: string);
begin
  FcodigoCupom := Value;
end;

procedure TPrevenda.Setdata(const Value: TDateTime);
begin
  Fdata := Value;
end;

procedure TPrevenda.Setfuncionario(const Value: string);
begin
  Ffuncionario := Value;
end;

procedure TPrevenda.Setitems(const Value: TObjectList<TPrevendaItem>);
begin
  Fitems := Value;
end;

procedure TPrevenda.Setstatus(const Value: string);
begin
  Fstatus := Value;
end;

procedure TPrevenda.Setterminal(const Value: string);
begin
  Fterminal := Value;
end;

procedure TPrevenda.SetvalorAcrescimo(const Value: Real);
begin
  FvalorAcrescimo := Value;
end;

procedure TPrevenda.SetvalorDesconto(const Value: real);
begin
  FvalorDesconto := Value;
end;

procedure TPrevenda.SetvalorTotal(const Value: real);
begin
  FvalorTotal := Value;
end;





{ TPrevendaItem }

constructor TPrevendaItem.create;
begin
Fproduto := TProduto.create;
end;


procedure TPrevendaItem.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TPrevendaItem.SetcodigoPrevenda(const Value: string);
begin
  FcodigoPrevenda := Value;
end;

procedure TPrevendaItem.Setcodigo_barras(const Value: string);
var

  CodigoBarras : string;
begin


  if (Value = '') then
  begin
    raise Exception.Create('Código de barras não pode ser em branco!');
  end;
  if Length(value)> 14 then
  begin
    raise Exception.Create('Limite de 14 caracteres!');
  end;

  CodigoBarras := Value;
  CodigoBarras := removeLetras(CodigoBarras);
  CodigoBarras := zeroEsquerda(CodigoBarras,14);

//  free;
  Fcodigo_barras := CodigoBarras;
end;

procedure TPrevendaItem.Setitem(const Value: integer);
begin
  Fitem := Value;
end;

procedure TPrevendaItem.Setproduto(const Value: TProduto);
begin
  Fproduto := Value;
end;

procedure TPrevendaItem.Setqtde(const Value: Real);
begin
  if value <= 0 then
  begin
    raise Exception.Create('Quantidade não pode ser negativo ou zerado');
  end;
  Fqtde := Value;
end;

procedure TPrevendaItem.Setterminal(const Value: string);
begin
  Fterminal := Value;
end;

procedure TPrevendaItem.Setunidade(const Value: string);
begin
  Funidade := Value;
end;

procedure TPrevendaItem.SetvalorAcrescimo(const Value: real);
begin
  FvalorAcrescimo := Value;
end;

procedure TPrevendaItem.SetvalorDesconto(const Value: real);
begin
  FvalorDesconto := Value;
end;

procedure TPrevendaItem.SetvalorTotal(const Value: Real);
begin
  if value <= 0 then
  begin
    raise Exception.Create('Valor total não pode ser negativo ou zerado');
  end;
  FvalorTotal := Value;
end;

procedure TPrevendaItem.SetvalorUnitario(const Value: real);
begin
  if value <= 0 then
  begin
    raise Exception.Create('Valor unitário não pode ser negativo ou zerado');
  end;
  FvalorUnitario := Value;
end;

end.
