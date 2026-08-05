unit ContaReceberItemModel;

interface
uses ProdutoModel;
type TContaReceberItemModel = class
  private
    Fseq: Integer;
    Fqtd: real;
    Fvlr_desconto: real;
    Fvlr_unitario: real;
    Funidade: string;
    Fvlr_total: real;
    Fproduto: TProdutoModel;
    procedure Setqtd(const Value: real);
    procedure Setseq(const Value: Integer);
    procedure Setunidade(const Value: string);
    procedure Setvlr_desconto(const Value: real);
    procedure Setvlr_total(const Value: real);
    procedure Setvlr_unitario(const Value: real);
    procedure Setproduto(const Value: TProdutoModel);
  public
  constructor create;
  property seq:Integer read Fseq write Setseq;
  property unidade:string read Funidade write Setunidade;
  property qtd:real read Fqtd write Setqtd;
  property vlr_unitario:real read Fvlr_unitario write Setvlr_unitario;
  property vlr_desconto:real read Fvlr_desconto write Setvlr_desconto;
  property vlr_total:real read Fvlr_total write Setvlr_total;
  property produto:TProdutoModel read Fproduto write Setproduto;
end;

implementation

{ TContaReceberItemModel }

constructor TContaReceberItemModel.create;
begin
FProduto := TProdutoModel.create;
end;

procedure TContaReceberItemModel.Setproduto(const Value: TProdutoModel);
begin
  Fproduto := Value;
end;

procedure TContaReceberItemModel.Setqtd(const Value: real);
begin
  Fqtd := Value;
end;

procedure TContaReceberItemModel.Setseq(const Value: Integer);
begin
  Fseq := Value;
end;

procedure TContaReceberItemModel.Setunidade(const Value: string);
begin
  Funidade := Value;
end;

procedure TContaReceberItemModel.Setvlr_desconto(const Value: real);
begin
  Fvlr_desconto := Value;
end;

procedure TContaReceberItemModel.Setvlr_total(const Value: real);
begin
  Fvlr_total := Value;
end;

procedure TContaReceberItemModel.Setvlr_unitario(const Value: real);
begin
  Fvlr_unitario := Value;
end;

end.
