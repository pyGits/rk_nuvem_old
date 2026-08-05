unit Classe.Produto;

interface
uses pcnConversao, System.sysutils,Classe.Funcoes;
type TProduto = class;
     TProdutoTributacaoACBR = class;

TProduto = class(TObject)
  private
    FprecoVariavel: Boolean;
    FUN: string;
    FprecoCusto: real;
    FCEST: string;
    Fcodigo: string;
    FcodigoBarras: string;
    FEstoque: Real;
    FPrecoVenda: Real;
    FNCM: string;
    FusaBalanca: integer;
    FSituacao: integer;
    FNome: string;
    FCFOP: string;
    FAliquota: Real;
    FST: string;
    FCST: string;
    FCSOSN: string;
    FTributacaoACBR: TProdutoTributacaoACBR;
    Fqtde: Real;
    Ffracionado: Boolean;

    procedure SetCEST(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure SetcodigoBarras(const Value: string);
    procedure SetEstoque(const Value: Real);
    procedure SetNCM(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetprecoCusto(const Value: real);
    procedure SetprecoVariavel(const Value: boolean);
    procedure SetPrecoVenda(const Value: Real);
    procedure SetSituacao(const Value: integer);
    procedure SetUN(const Value: string);
    procedure SetusaBalanca(const Value: integer);
    procedure SetAliquota(const Value: Real);
    procedure SetCFOP(const Value: string);
    procedure SetCSOSN(const Value: string);
    procedure SetCST(const Value: string);
    procedure SetST(const Value: string);
    procedure SetTributacaoACBR(const Value: TProdutoTributacaoACBR);
    procedure Setqtde(const Value: Real);
    procedure Setfracionado(const Value: Boolean);
  public
  constructor create;
  destructor destroy;override;

  property codigo :string read Fcodigo write Setcodigo;
  property codigoBarras:string read FcodigoBarras write SetcodigoBarras;
  property Nome:string read FNome write SetNome;
  property UN : string read FUN write SetUN;
  property PrecoVenda:Real read FPrecoVenda write SetPrecoVenda;
  property Estoque :Real read FEstoque write SetEstoque;
  property Situacao : integer read FSituacao write SetSituacao;
  property precoCusto:real read FprecoCusto write SetprecoCusto;
  property NCM:string read FNCM write SetNCM;
  property CEST:string read FCEST write SetCEST;
  property usaBalanca:integer read FusaBalanca write SetusaBalanca;
  property precoVariavel:boolean read FprecoVariavel write SetprecoVariavel;
  property fracionado:Boolean read Ffracionado write Setfracionado;


  property CST:string read FCST write SetCST;
  property Aliquota:Real read FAliquota write SetAliquota;
  property ST:string read FST write SetST;
  property CFOP:string read FCFOP write SetCFOP;
  property CSOSN:string read FCSOSN write SetCSOSN;

  property TributacaoACBR : TProdutoTributacaoACBR read FTributacaoACBR write SetTributacaoACBR;



end;


TProdutoTributacaoACBR = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FCSOSN: TpcnCSOSNIcms;
    FvICMS: real;
    FvNF: Real;
    FvBC: real;
    FvTotTrib: real;
    FvDesc: real;
    FvIPI: real;
    FvProd: real;
    procedure SetCST(const Value: TpcnCSTIcms);
    procedure SetCSOSN(const Value: TpcnCSOSNIcms);
    procedure SetvBC(const Value: real);
    procedure SetvDesc(const Value: real);
    procedure SetvICMS(const Value: real);
    procedure SetvIPI(const Value: real);
    procedure SetvNF(const Value: Real);
    procedure SetvProd(const Value: real);
    procedure SetvTotTrib(const Value: real);
  public
  property CST: TpcnCSTIcms read FCST write SetCST;
  property CSOSN : TpcnCSOSNIcms read FCSOSN write SetCSOSN;
  // ICMS se for lucro real

  property vBC : real read FvBC write SetvBC;      // TOTAL DOS PRODUTOS QUE TENHA ICMS (QTD *PRECO UNI), TAG = qTRIB * vUnTrib
  property vICMS : real read FvICMS write SetvICMS;
  property vProd : real read FvProd write SetvProd;
  property vNF :Real read FvNF write SetvNF;
  property vDesc:real read FvDesc write SetvDesc;
  property vIPI:real read FvIPI write SetvIPI;
  property vTotTrib:real read FvTotTrib write SetvTotTrib;


end;


implementation

{ TProduto }

constructor TProduto.create;
begin
  TributacaoACBR := TProdutoTributacaoACBR.create;
end;

destructor TProduto.destroy;
begin
  Freeandnil(FTributacaoACBR);
  inherited;
end;

procedure TProduto.SetAliquota(const Value: Real);
begin
  FAliquota := Value;
end;

procedure TProduto.SetCEST(const Value: string);
begin
  FCEST := Value;
end;

procedure TProduto.SetCFOP(const Value: string);
begin
  FCFOP := Value;
end;

procedure TProduto.Setcodigo(const Value: string);
var
  codigo:string;
begin
  codigo := Value;
  Codigo := Trim(codigo);
    if codigo <> '' then
  begin
  Codigo := removeLetras(Codigo);
  Codigo := zeroEsquerda(Codigo,6);
  end;
  Fcodigo := codigo;
end;

procedure TProduto.SetcodigoBarras(const Value: string);
var
  Codigo:string;
iPosicao:integer;
begin
  codigo := Value;
  Codigo := Trim(codigo);
  if codigo <> '' then
  begin
  Codigo := removeLetras(Codigo);
  Codigo := zeroEsquerda(Codigo,14);
  end;
  FcodigoBarras := Codigo;
end;

procedure TProduto.SetCSOSN(const Value: string);
begin
  if Value = '101' then
  begin
    TributacaoACBR.CSOSN := csosn101;
  end
  else
  if Value = '102' then
  begin
    TributacaoACBR.CSOSN := csosn102;
  end
  else
  if Value = '300' then
  begin
    TributacaoACBR.CSOSN := csosn300;
  end
  else
  if Value = '400' then
  begin
    TributacaoACBR.CSOSN := csosn400;
  end
  else
  if Value = '500' then
  begin
    TributacaoACBR.CSOSN := csosn500;
  end
  else
  if Value = '900' then
  begin
    TributacaoACBR.CSOSN := csosn900;
  end
  else
  begin
    TributacaoACBR.CSOSN := csosn900;
  end;

  FCSOSN := Value;
end;

procedure TProduto.SetCST(const Value: string);
begin
  // CST
  if Value = '000' then
  begin
  TributacaoACBR.CST := cst00;
  end
  else
  if Value = '060' then
  begin
  TributacaoACBR.CST := cst60;
  end
  else
  if Value = '040' then
  begin
  TributacaoACBR.CST := cst40;
  end
  else
  begin
  // VALOR DEFAULT
  TributacaoACBR.CST := cst00;
  end;


  FCST := Value;
end;

procedure TProduto.SetEstoque(const Value: Real);
begin
  FEstoque := Value;
end;

procedure TProduto.Setfracionado(const Value: Boolean);
begin
  Ffracionado := Value;
end;

procedure TProduto.SetNCM(const Value: string);
begin
  FNCM := Value;
end;

procedure TProduto.SetNome(const Value: string);
var
  nome:string;
begin
  nome := Value;
  Nome := AnsiUpperCase(nome);
  FNome := nome;
end;

procedure TProduto.SetprecoCusto(const Value: real);
begin
  FprecoCusto := Value;
end;

procedure TProduto.SetprecoVariavel(const Value: boolean);
begin
  FprecoVariavel := Value;
end;

procedure TProduto.SetPrecoVenda(const Value: Real);
begin
  if Value <=0 then
  begin
    raise Exception.Create('Valor não pode ser 0 ou negativo');
  end;
  FPrecoVenda := Value;
end;

procedure TProduto.Setqtde(const Value: Real);
begin
  Fqtde := Value;
end;

procedure TProduto.SetSituacao(const Value: integer);
begin
  FSituacao := Value;
end;

procedure TProduto.SetST(const Value: string);
begin
  FST := Value;
end;

procedure TProduto.SetTributacaoACBR(const Value: TProdutoTributacaoACBR);
begin
  FTributacaoACBR := Value;
end;

procedure TProduto.SetUN(const Value: string);
begin
  FUN := Value;
end;

procedure TProduto.SetusaBalanca(const Value: integer);
begin
  FusaBalanca := Value;
end;

{ TProdutoTributacaoACBR }

procedure TProdutoTributacaoACBR.SetCSOSN(const Value: TpcnCSOSNIcms);
begin
  FCSOSN := Value;
end;

procedure TProdutoTributacaoACBR.SetCST(const Value: TpcnCSTIcms);
begin
  FCST := Value;
end;

procedure TProdutoTributacaoACBR.SetvBC(const Value: real);
begin
  FvBC := Value;
end;

procedure TProdutoTributacaoACBR.SetvDesc(const Value: real);
begin
  FvDesc := Value;
end;

procedure TProdutoTributacaoACBR.SetvICMS(const Value: real);
begin
  FvICMS := Value;
end;

procedure TProdutoTributacaoACBR.SetvIPI(const Value: real);
begin
  FvIPI := Value;
end;

procedure TProdutoTributacaoACBR.SetvNF(const Value: Real);
begin
  FvNF := Value;
end;

procedure TProdutoTributacaoACBR.SetvProd(const Value: real);
begin
  FvProd := Value;
end;

procedure TProdutoTributacaoACBR.SetvTotTrib(const Value: real);
begin
  FvTotTrib := Value;
end;

end.
