unit ContaReceberModel;

interface
uses ContaReceberItemModel,System.Generics.Collections;
type TContaReceberModel = class
  private
    Fdata_vencimento: TDate;
    Fdata_pagamento: TDate;
    Fvalor: Real;
    Fdata_emissao: TDate;
    Fcancelado: integer;
    Fvalor_restante: real;
    Fcodigo: string;
    Fvalor_pago: real;
    Fstatus: integer;
    Fcod_cupom: string;
    Fcod_cliente: string;
    Fvalor_acrescimo: real;
    Fvalor_desconto: real;
    Fcod_caixa: integer;
    Fcod_vendedor: integer;
    Fitems: TObjectList<TContaReceberItemModel>;
    procedure Setcancelado(const Value: integer);
    procedure Setcod_caixa(const Value: integer);
    procedure Setcod_cliente(const Value: string);
    procedure Setcod_cupom(const Value: string);
    procedure Setcod_vendedor(const Value: integer);
    procedure Setcodigo(const Value: string);
    procedure Setdata_emissao(const Value: TDate);
    procedure Setdata_pagamento(const Value: TDate);
    procedure Setdata_vencimento(const Value: TDate);
    procedure Setstatus(const Value: integer);
    procedure Setvalor(const Value: Real);
    procedure Setvalor_acrescimo(const Value: real);
    procedure Setvalor_desconto(const Value: real);
    procedure Setvalor_pago(const Value: real);
    procedure Setvalor_restante(const Value: real);
    procedure Setitems(const Value: TObjectList<TContaReceberItemModel>);
  published
  constructor create;
  destructor destroy;override;
  property codigo:string read Fcodigo write Setcodigo;
  property cod_cupom:string read Fcod_cupom write Setcod_cupom;
  property cod_vendedor:integer read Fcod_vendedor write Setcod_vendedor;
  property cod_caixa:integer read Fcod_caixa write Setcod_caixa;
  property cod_cliente:string read Fcod_cliente write Setcod_cliente;
  property data_emissao:TDate read Fdata_emissao write Setdata_emissao;
  property data_vencimento:TDate read Fdata_vencimento write Setdata_vencimento;
  property data_pagamento:TDate read Fdata_pagamento write Setdata_pagamento;
  property valor:Real read Fvalor write Setvalor;
  property valor_pago:real read Fvalor_pago write Setvalor_pago;
  property valor_desconto:real read Fvalor_desconto write Setvalor_desconto;
  property valor_acrescimo:real read Fvalor_acrescimo write Setvalor_acrescimo;
  property valor_restante:real read Fvalor_restante write Setvalor_restante;
  property cancelado:integer read Fcancelado write Setcancelado;
  property status:integer read Fstatus write Setstatus;

  property items:TObjectList<TContaReceberItemModel> read Fitems write Setitems;
end;

implementation

{ TContaReceberModel }

constructor TContaReceberModel.create;
begin
Fitems := TObjectList<TContaReceberItemModel>.Create(true);
end;

destructor TContaReceberModel.destroy;
begin
  Fitems.Free;
  inherited;
end;

procedure TContaReceberModel.Setcancelado(const Value: integer);
begin
  Fcancelado := Value;
end;

procedure TContaReceberModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TContaReceberModel.Setcod_caixa(const Value: integer);
begin
  Fcod_caixa := Value;
end;

procedure TContaReceberModel.Setcod_cliente(const Value: string);
begin
  Fcod_cliente := Value;
end;

procedure TContaReceberModel.Setcod_cupom(const Value: string);
begin
  Fcod_cupom := Value;
end;

procedure TContaReceberModel.Setcod_vendedor(const Value: integer);
begin
  Fcod_vendedor := Value;
end;

procedure TContaReceberModel.Setdata_emissao(const Value: TDate);
begin
  Fdata_emissao := Value;
end;

procedure TContaReceberModel.Setdata_pagamento(const Value: TDate);
begin
  Fdata_pagamento := Value;
end;

procedure TContaReceberModel.Setdata_vencimento(const Value: TDate);
begin
  Fdata_vencimento := Value;
end;

procedure TContaReceberModel.Setitems(
  const Value: TObjectList<TContaReceberItemModel>);
begin
  Fitems := Value;
end;

procedure TContaReceberModel.Setstatus(const Value: integer);
begin
  Fstatus := Value;
end;

procedure TContaReceberModel.Setvalor(const Value: Real);
begin
  Fvalor := Value;
end;

procedure TContaReceberModel.Setvalor_acrescimo(const Value: real);
begin
  Fvalor_acrescimo := Value;
end;

procedure TContaReceberModel.Setvalor_desconto(const Value: real);
begin
  Fvalor_desconto := Value;
end;

procedure TContaReceberModel.Setvalor_pago(const Value: real);
begin
  Fvalor_pago := Value;
end;

procedure TContaReceberModel.Setvalor_restante(const Value: real);
begin
  Fvalor_restante := Value;
end;

end.
