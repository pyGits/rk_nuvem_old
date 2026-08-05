unit ProdutoModel;

interface
uses Vcl.Dialogs,CodigoAuxiliarModel;
type
  TProdutoModel = class
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
    FCodigoAuxiliar: TCodigoAuxiliarModel;
    Fpreco2: real;
    Fpreco2_qtd: real;


    procedure SetDataAlterado(const Value: TDate);
    procedure SetestoqueAnterior(const Value: Real);
    procedure SetCodigoAuxiliar(const Value: TCodigoAuxiliarModel);
    procedure Setpreco2(const Value: real);
    procedure Setpreco2_qtd(const Value: real);



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
    property preco2:real read Fpreco2 write Setpreco2;
    property preco2_qtd:real read Fpreco2_qtd write Setpreco2_qtd;

    property CodigoAuxiliar:TCodigoAuxiliarModel read FCodigoAuxiliar write SetCodigoAuxiliar;




    procedure calcularCodigoBalanca(qtdDigitos:integer);
    function removeQtdCodigo(codigo:string):string;
    function calcularQtdEtiqueta(codigo:string):currency;

  end;

implementation

uses
  System.SysUtils;

{ TProdutoModel }

procedure TProdutoModel.calcularCodigoBalanca(qtdDigitos: integer);
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

function TProdutoModel.calcularQtdEtiqueta(codigo: string): currency;
var
  vlrTotal:currency;
begin
  result := 1;
    if FPreco <= 0 then
    begin
    raise Exception.Create('Valor unitário não pode ser igual a 0');
    end;
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

constructor TProdutoModel.create;
begin
  Unidade := 'UN';
  Tributacao := 'F00';
  CodigoAuxiliar := TCodigoAuxiliarModel.Create;

  DataCadastro := Date();
  DataAlterado := Date();
end;

destructor TProdutoModel.destroy;
begin
  inherited;
end;

function TProdutoModel.getBalanca: Integer;
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

function TProdutoModel.getBoolBalanca(valor: integer): boolean;
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

function TProdutoModel.getBoolDiversos(valor: integer): boolean;
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

function TProdutoModel.getBoolFracionado(valor: integer): boolean;
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

function TProdutoModel.getBoolInativo(valor: integer): boolean;
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

function TProdutoModel.getCodigo: string;
begin
  Result := FCodigo;
end;

function TProdutoModel.getDescricao: string;
begin
  Result := FDescricao;
end;

function TProdutoModel.getDiversos: integer;
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

function TProdutoModel.getFracionado: integer;
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

function TProdutoModel.getInativo: integer;
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

function TProdutoModel.removeQtdCodigo(codigo: string): string;
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

procedure TProdutoModel.SetBalanca(const Value: Boolean);
var
  balanca : boolean;
begin
  FBalanca :=Value;
end;

procedure TProdutoModel.SetCEST(const Value: string);
begin
  FCEST := Value;
end;

procedure TProdutoModel.SetCodigo(const Value: string);
begin
  FCodigo := value;
end;

procedure TProdutoModel.SetCodigoAuxiliar(const Value: TCodigoAuxiliarModel);
begin
  FCodigoAuxiliar := Value;
end;

procedure TProdutoModel.SetCodigoBarras(const Value: string);
begin

  FCodigoBarras := Value;
end;




procedure TProdutoModel.SetCusto(const Value: Real);
var
  Custo : Real;
begin
  Custo := Value;
  if Custo < 0 then
  begin
    raise Exception.Create('Custo não pode ser negativo!');
  end;

  FCusto := Custo;
end;

procedure TProdutoModel.SetDataAlterado(const Value: TDate);
begin
  FDataAlterado := Value;
end;

procedure TProdutoModel.SetDataCadastro(const Value: TDate);
begin
  FDataCadastro := Value;
end;

procedure TProdutoModel.setDescricao(const Value: string);
var
  desc:string;
begin
  desc := value;

  if (desc = '') then
  begin
    raise Exception.Create('Descrição não pode ficar em branco!');
  end;
  if Length(desc)>100 then
  begin
    raise Exception.Create('Limite de 100 caracteres!');
  end;
//  desc := RemoveAcento(desc);

  FDescricao := desc;
end;



procedure TProdutoModel.SetDiversos(const Value: Boolean);
begin
  FDiversos := Value;
end;

procedure TProdutoModel.SetEstoque(const Value: Real);
begin
  FEstoque := Value;
end;

procedure TProdutoModel.SetestoqueAnterior(const Value: Real);
begin
  FestoqueAnterior := Value;
end;

procedure TProdutoModel.SetestoqueMaximo(const Value: Real);
begin
  if Value < FestoqueMinimo then
  begin
    raise Exception.Create('Estoque máximo não pode ser menor que estoque mínimo');
  end;
  FestoqueMaximo := Value;
end;

procedure TProdutoModel.SetestoqueMinimo(const Value: real);
begin
  if FEstoqueMaximo < value then
  begin
    raise Exception.Create('Estoque mínimo não pode ser maior que estoque máximo');
  end;
  FestoqueMinimo := Value;
end;

procedure TProdutoModel.SetFabricante(const Value: string);
begin
FFabricante := value;
end;

procedure TProdutoModel.SetFornecedor(const Value: string);
begin
FFornecedor := value;
end;

procedure TProdutoModel.SetFracionado(const Value: Boolean);
begin
  FFracionado := Value;
end;

procedure TProdutoModel.SetGrupo(const Value: string);
begin

  FGrupo := Value;
end;

procedure TProdutoModel.SetInativo(const Value: Boolean);
begin
  FInativo := Value;
end;

procedure TProdutoModel.SetMargem(const Value: Real);
var
  Margem : Real;
begin
  Margem := Value;
  if Margem < 0 then
  begin
    raise Exception.Create('Margem não pode ser negativo!');
  end;

  FMargem := Margem;
end;

procedure TProdutoModel.SetNCM(const Value: string);
begin
FNCM := value;
end;

procedure TProdutoModel.SetObservacao(const Value: string);
begin
  if Length(value)> 100 then
  begin
    raise Exception.Create('Limite de 100 caracteres!');
  end;
  FObservacao := Value;
end;

procedure TProdutoModel.SetPreco(const Value: Real);
var
  Preco : Real;
begin
  Preco := Value;
  if Preco <= 0 then
  begin
//    raise Exception.Create('Preço não pode ser zerado ou negativo!');
  end;

  FPreco := Preco;
end;

procedure TProdutoModel.Setpreco2(const Value: real);
begin
  Fpreco2 := Value;
end;

procedure TProdutoModel.Setpreco2_qtd(const Value: real);
begin
  Fpreco2_qtd := Value;
end;

procedure TProdutoModel.SetSubgrupo(const Value: string);
begin
  FSubgrupo := Value;
end;


procedure TProdutoModel.SetTributacao(const Value: String);
begin
  if Value = '' then
  begin
    raise Exception.Create('Tributação não pode ser vazia');
  end;
  if Length(value) > 3 then
  begin
    raise Exception.Create('Tributação não pode ter mais que 3 letras');
  end;

  FTributacao := Value;
end;

procedure TProdutoModel.SetUnidade(const Value: string);
begin
  if Value = '' then
  begin
    raise Exception.Create('Unidade não pode ser vazia');
  end;
  if Length(value) > 3 then
  begin
    raise Exception.Create('Unidade não pode ter mais que 3 letras');
  end;

  FUnidade := Value;
end;

procedure TProdutoModel.SetValidade(const Value: string);
begin
  FValidade := value
end;


end.

