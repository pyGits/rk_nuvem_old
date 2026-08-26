unit ContaReceber;

interface

// Titulo de convenio (crediario) lido de CUPOM_CREDIARIO no PDV e enviado para
// a nuvem. Uma instancia por parcela, que e como o PDV grava.
//
// Duas regras do serializador (uJsonUtils.DelphiObjectToJson) mandam nos tipos
// daqui e nao podem ser trocadas:
//   - data e TDate, nunca string: o RTTI emite dd/mm/yyyy, que e o formato que
//     o backend converte com moment(data,'DD/MM/YYYY');
//   - dinheiro e Real, literalmente: so esse tipo tem a troca de virgula por
//     ponto. Double ou Currency subiriam "12,50".
type TContaReceber = class
  private
    Floja: string;
    Fcaixa: string;
    Fcodigo: string;
    Fcodigo_cupom: string;
    Fnumero: string;
    Fprestacao: integer;
    Fdata_emissao: TDate;
    Fdata_vencimento: TDate;
    Fvalor: Real;
    Fcodigo_cliente: string;
    Fcpf_cliente: string;
    Fdescricao: string;
    Fvendedor: string;
    Fcancelado: integer;
    procedure Setloja(const Value: string);
    procedure Setcaixa(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure Setcodigo_cupom(const Value: string);
    procedure Setnumero(const Value: string);
    procedure Setprestacao(const Value: integer);
    procedure Setdata_emissao(const Value: TDate);
    procedure Setdata_vencimento(const Value: TDate);
    procedure Setvalor(const Value: Real);
    procedure Setcodigo_cliente(const Value: string);
    procedure Setcpf_cliente(const Value: string);
    procedure Setdescricao(const Value: string);
    procedure Setvendedor(const Value: string);
    procedure Setcancelado(const Value: integer);
  public
  property loja:string read Floja write Setloja;
  property caixa:string read Fcaixa write Setcaixa;
  property codigo:string read Fcodigo write Setcodigo;
  property codigo_cupom:string read Fcodigo_cupom write Setcodigo_cupom;
  property numero:string read Fnumero write Setnumero;
  property prestacao:integer read Fprestacao write Setprestacao;
  property data_emissao:TDate read Fdata_emissao write Setdata_emissao;
  property data_vencimento:TDate read Fdata_vencimento write Setdata_vencimento;
  property valor:Real read Fvalor write Setvalor;
  property codigo_cliente:string read Fcodigo_cliente write Setcodigo_cliente;
  property cpf_cliente:string read Fcpf_cliente write Setcpf_cliente;
  property descricao:string read Fdescricao write Setdescricao;
  property vendedor:string read Fvendedor write Setvendedor;
  property cancelado:integer read Fcancelado write Setcancelado;
end;

implementation

{ TContaReceber }

procedure TContaReceber.Setloja(const Value: string);
begin
  Floja := Value;
end;

procedure TContaReceber.Setcaixa(const Value: string);
begin
  Fcaixa := Value;
end;

procedure TContaReceber.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TContaReceber.Setcodigo_cupom(const Value: string);
begin
  Fcodigo_cupom := Value;
end;

procedure TContaReceber.Setnumero(const Value: string);
begin
  Fnumero := Value;
end;

procedure TContaReceber.Setprestacao(const Value: integer);
begin
  Fprestacao := Value;
end;

procedure TContaReceber.Setdata_emissao(const Value: TDate);
begin
  Fdata_emissao := Value;
end;

procedure TContaReceber.Setdata_vencimento(const Value: TDate);
begin
  Fdata_vencimento := Value;
end;

procedure TContaReceber.Setvalor(const Value: Real);
begin
  Fvalor := Value;
end;

procedure TContaReceber.Setcodigo_cliente(const Value: string);
begin
  Fcodigo_cliente := Value;
end;

procedure TContaReceber.Setcpf_cliente(const Value: string);
begin
  Fcpf_cliente := Value;
end;

procedure TContaReceber.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

procedure TContaReceber.Setvendedor(const Value: string);
begin
  Fvendedor := Value;
end;

procedure TContaReceber.Setcancelado(const Value: integer);
begin
  Fcancelado := Value;
end;

end.
