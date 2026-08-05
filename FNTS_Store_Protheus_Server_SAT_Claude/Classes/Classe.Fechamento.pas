unit Classe.Fechamento;

interface
type

     TFechamento = class;
     TFechamentoFin = class;


TFechamento = class(TObject)
  private
    Ftotais: real;
    FdataFechamento: TDate;
    FqtdCuponsCancelados: integer;
    FcancelamentoItem: real;
    FvendaBruta: real;
    FhoraFechamento: TDateTime;
    FfundoCaixa: real;
    FacrescimoCupom: real;
    FdescontoCupom: real;
    FdataAbertura: TDate;
    Fsangria: real;
    Foperador: string;
    FqtdCuponsEfetivados: integer;
    FdescontoItem: real;
    FhoraAbertura: TDateTime;
    FvendaLiquida: real;
    FcancelamentoCupom: real;
    Fid: string;

    FListaFechamentoFin:array[1..99] of TFechamentoFin;
    FcodOperador: integer;
    Fcodigo: string;
    FcodCaixa: integer;

    procedure SetacrescimoCupom(const Value: real);
    procedure SetcancelamentoCupom(const Value: real);
    procedure SetcancelamentoItem(const Value: real);
    procedure SetdataAbertura(const Value: TDate);
    procedure SetdataFechamento(const Value: TDate);
    procedure SetdescontoCupom(const Value: real);
    procedure SetdescontoItem(const Value: real);
    procedure SetfundoCaixa(const Value: real);
    procedure SethoraAbertura(const Value: TDateTime);
    procedure SethoraFechamento(const Value: TDateTime);
    procedure Setoperador(const Value: string);
    procedure SetqtdCuponsCancelados(const Value: integer);
    procedure SetqtdCuponsEfetivados(const Value: integer);
    procedure Setsangria(const Value: real);
    procedure Settotais(const Value: real);
    procedure SetvendaBruta(const Value: real);
    procedure SetvendaLiquida(const Value: real);
    procedure Setid(const Value: string);
    function GetListaFechamentoFin(AIndex: Integer): TFechamentoFin;
    procedure SetListaFechamentoFin(AIndex: Integer;
      const Value: TFechamentoFin);
    procedure SetcodOperador(const Value: integer);
    procedure Setcodigo(const Value: string);
    procedure SetcodCaixa(const Value: integer);
  public
  property id:string read Fid write Setid;
  property codigo:string read Fcodigo write Setcodigo;
  property operador:string read Foperador write Setoperador;
  property dataAbertura:TDate read FdataAbertura write SetdataAbertura;
  property dataFechamento:TDate read FdataFechamento write SetdataFechamento;
  property horaAbertura:TDateTime read FhoraAbertura write SethoraAbertura;
  property horaFechamento:TDateTime read FhoraFechamento write SethoraFechamento;
  property codOperador:integer read FcodOperador write SetcodOperador;
  property codCaixa:integer read FcodCaixa write SetcodCaixa;

  property vendaBruta:real read FvendaBruta write SetvendaBruta;
  property cancelamentoCupom:real read FcancelamentoCupom write SetcancelamentoCupom;
  property cancelamentoItem:real read FcancelamentoItem write SetcancelamentoItem;
  property descontoItem:real read FdescontoItem write SetdescontoItem;
  property descontoCupom:real read FdescontoCupom write SetdescontoCupom;
  property acrescimoCupom:real read FacrescimoCupom write SetacrescimoCupom;
  property vendaLiquida:real read FvendaLiquida write SetvendaLiquida;
  property fundoCaixa:real read FfundoCaixa write SetfundoCaixa;
  property sangria:real read Fsangria write Setsangria;
  property totais:real read Ftotais write Settotais;

  property qtdCuponsEfetivados:integer read FqtdCuponsEfetivados write SetqtdCuponsEfetivados;
  property qtdCuponsCancelados:integer read FqtdCuponsCancelados write SetqtdCuponsCancelados;

  property ListaFechamentoFin[AIndex:Integer]:TFechamentoFin read GetListaFechamentoFin write SetListaFechamentoFin;
  function CountListaFinalizadora:integer;

  constructor create;
  destructor destroy;override;


end;

TFechamentoFin = class(TObject)
  private
    Fid: string;
    FvalorReforco: Real;
    FvalorTroco: Real;
    FvalorEntrada: real;
    FFinalizadora: string;
    FvalorLiquido: Real;
    FvalorSangria: Real;
    FvalorConferencia: real;
    FvalorTotal: real;
    FcodCaixa: integer;
    procedure Setid(const Value: string);
    procedure SetFinalizadora(const Value: string);
    procedure SetvalorEntrada(const Value: real);
    procedure SetvalorLiquido(const Value: Real);
    procedure SetvalorReforco(const Value: Real);
    procedure SetvalorSangria(const Value: Real);
    procedure SetvalorTroco(const Value: Real);
    procedure SetvalorConferencia(const Value: real);
    procedure SetvalorTotal(const Value: real);
    procedure SetcodCaixa(const Value: integer);
    public
    property id:string read Fid write Setid;
    property Finalizadora:string read FFinalizadora write SetFinalizadora;
    property valorLiquido:Real read FvalorLiquido write SetvalorLiquido;
    property valorEntrada:real read FvalorEntrada write SetvalorEntrada;
    property valorTroco:Real read FvalorTroco write SetvalorTroco;
    property valorReforco:Real read FvalorReforco write SetvalorReforco;
    property valorSangria:Real read FvalorSangria write SetvalorSangria;
    property valorConferencia:real read FvalorConferencia write SetvalorConferencia;
    property valorTotal:real read FvalorTotal write SetvalorTotal;
    property codCaixa:integer read FcodCaixa write SetcodCaixa;

    constructor create;
    destructor destroy;override;

end;

implementation

{ TFechamento }

function TFechamento.CountListaFinalizadora: integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FListaFechamentoFin) to High(FListaFechamentoFin) do
    if FListaFechamentoFin[I] <> nil then
      Inc(Result);
end;

constructor TFechamento.create;
begin
end;

destructor TFechamento.destroy;
begin

  inherited;
end;

function TFechamento.GetListaFechamentoFin(AIndex: Integer): TFechamentoFin;
begin
Result := FListaFechamentoFin[AIndex];
end;

procedure TFechamento.SetacrescimoCupom(const Value: real);
begin
  FacrescimoCupom := Value;
end;

procedure TFechamento.SetcancelamentoCupom(const Value: real);
begin
  FcancelamentoCupom := Value;
end;

procedure TFechamento.SetcancelamentoItem(const Value: real);
begin
  FcancelamentoItem := Value;
end;

procedure TFechamento.SetcodCaixa(const Value: integer);
begin
  FcodCaixa := Value;
end;

procedure TFechamento.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TFechamento.SetcodOperador(const Value: integer);
begin
  FcodOperador := Value;
end;

procedure TFechamento.SetdataAbertura(const Value: TDate);
begin
  FdataAbertura := Value;
end;

procedure TFechamento.SetdataFechamento(const Value: TDate);
begin
  FdataFechamento := Value;
end;

procedure TFechamento.SetdescontoCupom(const Value: real);
begin
  FdescontoCupom := Value;
end;

procedure TFechamento.SetdescontoItem(const Value: real);
begin
  FdescontoItem := Value;
end;

procedure TFechamento.SetfundoCaixa(const Value: real);
begin
  FfundoCaixa := Value;
end;

procedure TFechamento.SethoraAbertura(const Value: TDateTime);
begin
  FhoraAbertura := Value;
end;

procedure TFechamento.SethoraFechamento(const Value: TDateTime);
begin
  FhoraFechamento := Value;
end;

procedure TFechamento.Setid(const Value: string);
begin
  Fid := Value;
end;

procedure TFechamento.SetListaFechamentoFin(AIndex: Integer;
  const Value: TFechamentoFin);
begin
FListaFechamentoFin[AIndex] := Value;
end;

procedure TFechamento.Setoperador(const Value: string);
begin
  Foperador := Value;
end;

procedure TFechamento.SetqtdCuponsCancelados(const Value: integer);
begin
  FqtdCuponsCancelados := Value;
end;

procedure TFechamento.SetqtdCuponsEfetivados(const Value: integer);
begin
  FqtdCuponsEfetivados := Value;
end;

procedure TFechamento.Setsangria(const Value: real);
begin
  Fsangria := Value;
end;

procedure TFechamento.Settotais(const Value: real);
begin
  Ftotais := Value;
end;

procedure TFechamento.SetvendaBruta(const Value: real);
begin
  FvendaBruta := Value;
end;

procedure TFechamento.SetvendaLiquida(const Value: real);
begin
  FvendaLiquida := Value;
end;

{ TFechamentoFin }

constructor TFechamentoFin.create;
begin

end;

destructor TFechamentoFin.destroy;
begin

end;

procedure TFechamentoFin.SetcodCaixa(const Value: integer);
begin
  FcodCaixa := Value;
end;

procedure TFechamentoFin.SetFinalizadora(const Value: string);
begin
  FFinalizadora := Value;
end;

procedure TFechamentoFin.Setid(const Value: string);
begin
  Fid := Value;
end;

procedure TFechamentoFin.SetvalorConferencia(const Value: real);
begin
  FvalorConferencia := Value;
end;

procedure TFechamentoFin.SetvalorEntrada(const Value: real);
begin
  FvalorEntrada := Value;
end;

procedure TFechamentoFin.SetvalorLiquido(const Value: Real);
begin
  FvalorLiquido := Value;
end;

procedure TFechamentoFin.SetvalorReforco(const Value: Real);
begin
  FvalorReforco := Value;
end;

procedure TFechamentoFin.SetvalorSangria(const Value: Real);
begin
  FvalorSangria := Value;
end;

procedure TFechamentoFin.SetvalorTotal(const Value: real);
begin
  FvalorTotal := Value;
end;

procedure TFechamentoFin.SetvalorTroco(const Value: Real);
begin
  FvalorTroco := Value;
end;

end.
