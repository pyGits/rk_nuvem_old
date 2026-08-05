unit Produto;

interface
uses Vcl.Dialogs,Classe.Tributacao,Classe.CodigoAuxiliar;
type
  TProduto = class
    private
    FDescricao : string;
    FCodigo: string;
    FCodigoBarras: string;
    FGrupo: string;
    FSubgrupo: string;
    FFornecedor: string;
    FFabricante: string;

    FNCM: string;
    FCEST: string;
    FObservacao: string;
    FValidade: string;
    FBalanca: Boolean;
    FFracionado: Boolean;
    FCusto: Real;
    FPreco: Real;
    FMargem: Real;
    FUnidade: String;
    FInativo: Boolean;
    FDiversos: Boolean;
    FEstoque: Real;
    FDataCadastro: TDate;
    FDataAlterado: TDate;
    FTributacao: String;
    FestoqueMinimo: real;
    FestoqueMaximo: Real;
    FestoqueAnterior: Real;
    FCodigoAuxiliar: TCodigoAuxiliar;
    FPreco2: real;
    FQtdMinPreco2: real;
    FPreco3: real;
    FQtdMinPreco3: real;


    procedure SetDataAlterado(const Value: TDate);
    procedure SetestoqueAnterior(const Value: Real);
    procedure SetCodigoAuxiliar(const Value: TCodigoAuxiliar);
    procedure SetPreco2(const Value: real);
    procedure SetQtdMinPreco2(const Value: real);
    procedure SetPreco3(const Value: real);
    procedure SetQtdMinPreco3(const Value: real);



    public
    constructor create;
    destructor destroy;override;
    function getDescricao: string;
    function getCodigo: string;
    function getBalanca : Integer;
    function getFracionado : integer;
    function getInativo : integer;
    function getDiversos : integer;

    procedure SetDataCadastro(const Value: TDate);
    procedure SetValidade(const Value: string);
    procedure setDescricao(const Value: string);
    procedure SetCodigo(const Value: string);
    procedure SetCodigoBarras(const Value: string);
    procedure SetGrupo(const Value: string);
    procedure SetSubgrupo(const Value: string);
    procedure SetFornecedor(const Value: string);
    procedure SetFabricante(const Value: string);

    procedure SetTributacao(const Value: String);
    procedure SetNCM(const Value: string);
    procedure SetCEST(const Value: string);
    procedure SetObservacao(const Value: string);
    procedure SetEstoque(const Value: Real);

    procedure SetBalanca(const Value: Boolean);
    procedure SetFracionado(const Value: Boolean);
    procedure SetInativo(const Value: Boolean);
    procedure SetDiversos(const Value: Boolean);

    procedure SetCusto(const Value: Real);
    procedure SetPreco(const Value: Real);
    procedure SetMargem(const Value: Real);
    procedure SetUnidade(const Value: string);

    procedure SetestoqueMaximo(const Value: Real);
    procedure SetestoqueMinimo(const Value: real);


    function getBoolBalanca(valor : integer):boolean;
    function getBoolFracionado(valor : integer):boolean;
    function getBoolInativo(valor : integer):boolean;
    function getBoolDiversos(valor : integer):boolean;

    property Descricao      : string read FDescricao write setDescricao;
    property Codigo         : string read FCodigo write SetCodigo;
    property CodigoBarras   : string read FCodigoBarras write SetCodigoBarras;
    property Grupo          : string read FGrupo write SetGrupo;
    property Subgrupo       : string read FSubgrupo write SetSubgrupo;
    property Fornecedor     : string read FFornecedor write SetFornecedor;
    property Fabricante     : string read FFabricante write SetFabricante;
    property Tributacao     : string read FTributacao write SetTributacao;
    property NCM            : string read FNCM write SetNCM;
    property CEST           : string read FCEST write SetCEST;
    property Observacao     : string read FObservacao write SetObservacao;
    property Validade       : string read FValidade write SetValidade;
    property Balanca    :Boolean read FBalanca write SetBalanca;
    property Fracionado :Boolean read FFracionado write SetFracionado;
    property Custo      :Real read FCusto write SetCusto;
    property Preco      :Real read FPreco write SetPreco;
    property Margem     :Real read FMargem write SetMargem;
    property Estoque    :Real read FEstoque write SetEstoque;
    property Unidade    :string read FUnidade write SetUnidade;
    property Inativo    :Boolean read FInativo write SetInativo;
    property Diversos   :Boolean read FDiversos write SetDiversos;
    property DataCadastro :TDate read FDataCadastro write SetDataCadastro;
    property DataAlterado :TDate read FDataAlterado write SetDataAlterado;
    property estoqueMinimo :real read FestoqueMinimo write SetestoqueMinimo;
    property estoqueMaximo:Real read FestoqueMaximo write SetestoqueMaximo;
    property estoqueAnterior:Real read FestoqueAnterior write SetestoqueAnterior;
    property Preco2:real read FPreco2 write SetPreco2;
    property QtdMinPreco2:real read FQtdMinPreco2 write SetQtdMinPreco2;
    property Preco3:real read FPreco3 write SetPreco3;
    property QtdMinPreco3:real read FQtdMinPreco3 write SetQtdMinPreco3;


    property CodigoAuxiliar:TCodigoAuxiliar read FCodigoAuxiliar write SetCodigoAuxiliar;


    procedure SetBalancaBoolean(value:integer);
    procedure SetDiversosBoolean(value:integer);




    procedure calcularCodigoBalanca(qtdDigitos:integer);
    function removeQtdCodigo(codigo:string):string;
    function calcularQtdEtiqueta(codigo:string):currency;

  end;

implementation

uses
  System.SysUtils, Classe.Funcoes;

{ TProduto }

procedure TProduto.calcularCodigoBalanca(qtdDigitos: integer);
var
  codigoNovo:string;
begin
  codigoNovo := FCodigoBarras;
  codigoNovo := removeQtdCodigo(FCodigoBarras);
  if (copy(codigoNovo, 2, 1) = '2') then
  begin
  SetCodigoBarras(copy(codigoNovo, 3, qtdDigitos));
  end;
end;

function TProduto.calcularQtdEtiqueta(codigo: string): currency;
var
  vlrTotal:currency;
begin
  result := 1;
    // calcular total e quantidade
    if (copy(codigo, 1, 1) = '2') and (length(codigo) = 13) then
    begin
      if ( pos('*',codigo) <= 0 ) and ( pos('X',codigo) <= 0 ) then
      begin
         vlrTotal := strtofloat(copy(codigo, 8, 5)) / 100;
         result := vlrTotal / FPreco;
      end;
    end;

end;

constructor TProduto.create;
begin
  Unidade := 'UN';
  Tributacao := 'F00';
end;

destructor TProduto.destroy;
begin

  inherited;
end;

function TProduto.getBalanca: Integer;
var
  balanca :integer;
begin
  if FBalanca = true then
  begin
    balanca := 1;
  end
  else
  begin
    balanca := 2;
  end;

  Result := balanca;
end;

function TProduto.getBoolBalanca(valor: integer): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 1 then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolDiversos(valor: integer): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 1 then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolFracionado(valor: integer): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 1 then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolInativo(valor: integer): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 1 then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getCodigo: string;
begin
  Result := FCodigo;
end;

function TProduto.getDescricao: string;
begin
  Result := FDescricao;
end;

function TProduto.getDiversos: integer;
var
  diversos :integer;
begin
  if FDiversos = true then
  begin
    diversos := 1;
  end
  else
  begin
    diversos := 2;
  end;

  Result := diversos;
end;

function TProduto.getFracionado: integer;
var
  fracionado :integer;
begin
  if FFracionado = true then
  begin
    fracionado := 1;
  end
  else
  begin
    fracionado := 2;
  end;

  Result := fracionado;
end;

function TProduto.getInativo: integer;
var
  inativo :integer;
begin
  if FInativo = true then
  begin
    inativo := 1;
  end
  else
  begin
    inativo := 0;
  end;

  Result := inativo;
end;

function TProduto.removeQtdCodigo(codigo: string): string;
var
  iPosicao:integer;
begin
   if (pos('X', ansiuppercase(codigo)) > 0) or(pos('*', ansiuppercase(codigo)) > 0) then
   begin
        iPosicao := pos('X', ansiuppercase(codigo));
        if iPosicao = 0 then
          iPosicao := pos('*', ansiuppercase(codigo));
        try          // copia apenas a parte que contem a informacao da busca do produto
          result := copy(codigo, iPosicao + 1, 99);
        except
        end;

   end
   else
   begin
     result := codigo;
     codigoBarras := codigo;
   end;
end;

procedure TProduto.SetBalanca(const Value: Boolean);
var
  balanca : boolean;
begin
  FBalanca :=Value;
end;

procedure TProduto.SetBalancaBoolean(value: integer);
begin
  if value = 1 then
  begin
    FBalanca := true;
  end
  else
  begin
    FBalanca := false;
  end;
end;

procedure TProduto.SetCEST(const Value: string);
var
  CEST :string;
begin
  CEST := Value;
  CEST := removeLetras(CEST);
  if CEST <> '' then
  begin
  CEST := zeroEsquerda(CEST,7);
  end;


//  free;

  FCEST := CEST;
end;

procedure TProduto.SetCodigo(const Value: string);
var

  Codigo :string;
begin
  Codigo := Value;
  Codigo := removeLetras(Codigo);
  Codigo := zeroEsquerda(Codigo,6);

//  free;
  FCodigo := Codigo;
end;

procedure TProduto.SetCodigoAuxiliar(const Value: TCodigoAuxiliar);
begin
  FCodigoAuxiliar := Value;

  FCodigo := Value.codigo;
  FCodigo := removeLetras(FCodigo);
  FCodigo := zeroEsquerda(FCodigo,6);

  FCodigoBarras := '';

//  FCodigoBarras := Value.codigo_barras;
//  FCodigoBarras := removeLetras(FCodigoBarras);
//  FCodigoBarras := zeroEsquerda(FCodigoBarras,14);
end;

procedure TProduto.SetCodigoBarras(const Value: string);
var

  CodigoBarras : string;
begin
  CodigoBarras := Value;
  CodigoBarras := removeLetras(CodigoBarras);
  CodigoBarras := zeroEsquerda(CodigoBarras,14);

//  free;
  FCodigoBarras := CodigoBarras;
end;




procedure TProduto.SetCusto(const Value: Real);
var
  Custo : Real;
begin
  Custo := Value;
  FCusto := Custo;
end;

procedure TProduto.SetDataAlterado(const Value: TDate);
begin
  FDataAlterado := Value;
end;

procedure TProduto.SetDataCadastro(const Value: TDate);
begin
  FDataCadastro := Value;
end;

procedure TProduto.setDescricao(const Value: string);
var
  desc:string;
begin
  desc := value;

  FDescricao := desc;
end;



procedure TProduto.SetDiversos(const Value: Boolean);
begin
  FDiversos := Value;
end;

procedure TProduto.SetDiversosBoolean(value: integer);
begin
if value = 1 then
begin
  FDiversos := true;
end
else
begin
  FDiversos := false;
end;
end;

procedure TProduto.SetEstoque(const Value: Real);
begin
  FEstoque := Value;
end;

procedure TProduto.SetestoqueAnterior(const Value: Real);
begin
  FestoqueAnterior := Value;
end;

procedure TProduto.SetestoqueMaximo(const Value: Real);
begin

  FestoqueMaximo := Value;
end;

procedure TProduto.SetestoqueMinimo(const Value: real);
begin

  FestoqueMinimo := Value;
end;

procedure TProduto.SetFabricante(const Value: string);
var

  Fabricante :string;
begin

  Fabricante := Value;

  if (Fabricante = '')then
  begin
    Fabricante := '000000';
  end;


  Fabricante := removeLetras(Fabricante);
  Fabricante := zeroEsquerda(Fabricante,6);

//  free;

  FFabricante := Fabricante;
end;

procedure TProduto.SetFornecedor(const Value: string);
var

  Fornecedor :string;
begin

  Fornecedor := Value;

  if (Fornecedor = '')then
  begin
    Fornecedor := '000000';
  end;

  Fornecedor := removeLetras(Fornecedor);
  Fornecedor := zeroEsquerda(Fornecedor,6);

//  free;
  FFornecedor := Fornecedor;
end;

procedure TProduto.SetFracionado(const Value: Boolean);
begin
  FFracionado := Value;
end;

procedure TProduto.SetGrupo(const Value: string);
var
  Grupo :string;
begin

  Grupo := Value;

  if (Grupo = '')then
  begin
    Grupo := '000000';
  end;


  Grupo := removeLetras(Grupo);
  Grupo := zeroEsquerda(Grupo,6);

//  free;
  FGrupo := Grupo;
end;

procedure TProduto.SetInativo(const Value: Boolean);
begin
  FInativo := Value;
end;

procedure TProduto.SetMargem(const Value: Real);
var
  Margem : Real;
begin
  Margem := Value;

  FMargem := Margem;
end;

procedure TProduto.SetNCM(const Value: string);
var

  NCM :string;
begin



  NCM := Value;
  NCM := removeLetras(NCM);
  NCM := zeroEsquerda(NCM,8);

//  free;

  FNCM := NCM;

end;

procedure TProduto.SetObservacao(const Value: string);
begin

  FObservacao := Value;
end;

procedure TProduto.SetPreco(const Value: Real);
var
  Preco : Real;
begin
  Preco := Value;


  FPreco := Preco;
end;

procedure TProduto.SetPreco2(const Value: real);
begin
  FPreco2 := Value;
end;

procedure TProduto.SetPreco3(const Value: real);
begin
  FPreco3 := Value;
end;

procedure TProduto.SetQtdMinPreco2(const Value: real);
begin
  FQtdMinPreco2 := Value;
end;

procedure TProduto.SetQtdMinPreco3(const Value: real);
begin
  FQtdMinPreco3 := Value;
end;

procedure TProduto.SetSubgrupo(const Value: string);
var

  Subgrupo :string;
begin

  Subgrupo := Value;

  if (Subgrupo = '')then
  begin
    Subgrupo := '000000';
  end;


  Subgrupo := removeLetras(Subgrupo);
  Subgrupo := zeroEsquerda(Subgrupo,6);

//  free;
  FSubgrupo := Subgrupo;
end;


procedure TProduto.SetTributacao(const Value: String);
begin

  FTributacao := Value;
end;

procedure TProduto.SetUnidade(const Value: string);
begin

  FUnidade := Value;
end;

procedure TProduto.SetValidade(const Value: string);
var

  Validade :string;
begin

  Validade := Value;
  Validade := removeLetras(Validade);

//  Free;
  FValidade := Validade;
end;


end.

