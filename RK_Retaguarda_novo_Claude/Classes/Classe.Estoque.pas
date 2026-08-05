unit Classe.Estoque;

interface
type
  TEstoque = class
    private
    Fhora: TTime;
    Fqtde: Real;
    Fitem: integer;
    Fcod_cupom: string;
    Fcodproduto: string;
    Fdata: TDate;
    procedure Setcod_cupom(const Value: string);
    procedure Setcodproduto(const Value: string);
    procedure Setdata(const Value: TDate);
    procedure Sethora(const Value: TTime);
    procedure Setitem(const Value: integer);
    procedure Setqtde(const Value: Real);


    public
    property qtde :Real read Fqtde write Setqtde;
    property data:TDate read Fdata write Setdata;
    property hora:TTime read Fhora write Sethora;
    property codproduto:string read Fcodproduto write Setcodproduto;
    property cod_cupom:string read Fcod_cupom write Setcod_cupom;
    property item:integer read Fitem write Setitem;



  end;
implementation

{ TEstoque }

procedure TEstoque.Setcodproduto(const Value: string);
begin
  Fcodproduto := Value;
end;

procedure TEstoque.Setcod_cupom(const Value: string);
begin
  Fcod_cupom := Value;
end;

procedure TEstoque.Setdata(const Value: TDate);
begin
  Fdata := Value;
end;

procedure TEstoque.Sethora(const Value: TTime);
begin
  Fhora := Value;
end;

procedure TEstoque.Setitem(const Value: integer);
begin
  Fitem := Value;
end;

procedure TEstoque.Setqtde(const Value: Real);
begin
  Fqtde := Value;
end;

end.
