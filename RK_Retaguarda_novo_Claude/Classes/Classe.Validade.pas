unit Classe.Validade;

interface

uses Classe.Produto, system.SysUtils;
type TValidade = class(TObject)
  private
    FCodigo: string;
    FLocalizacao: string;
    FSituacao: Integer;
    FQuantidade: real;

    FDiasVencimento: integer;
    FDataVencimento: TDate;
    Fid: integer;
    FDataEntrada: TDate;
    Flote: string;
    procedure SetCodigo(const Value: string);
    procedure SetLocalizacao(const Value: string);
    procedure SetQuantidade(const Value: real);
    procedure SetSituacao(const Value: Integer);
    procedure SetDiasVencimento(const Value: integer);
    procedure SetDataVencimento(const Value: TDate);
    procedure Setid(const Value: integer);
    procedure SetDataEntrada(const Value: TDate);
    procedure Setlote(const Value: string);

    public
    property id:integer read Fid write Setid;
  property Codigo:string read FCodigo write SetCodigo;
  property Localizacao:string read FLocalizacao write SetLocalizacao;
  property Quantidade:real read FQuantidade write SetQuantidade;
  property Situacao:Integer read FSituacao write SetSituacao;
  property DiasVencimento:integer read FDiasVencimento write SetDiasVencimento;
  property DataVencimento:TDate read FDataVencimento write SetDataVencimento;
  property DataEntrada:TDate read FDataEntrada write SetDataEntrada;
  property lote:string read Flote write Setlote;



end;

implementation

{ TValidade }

procedure TValidade.SetCodigo(const Value: string);
var
  vlr:string;
begin
  vlr := Value;

  if TrimLeft(vlr) = '' then
  begin
    raise Exception.Create('Código não pode estar em branco');
  end;
  if TrimRight(vlr) = '' then
  begin
    raise Exception.Create('Código não pode estar em branco');
  end;


  FCodigo := Value;
end;

procedure TValidade.SetDataEntrada(const Value: TDate);
begin
  FDataEntrada := Value;
end;

procedure TValidade.SetDataVencimento(const Value: TDate);
begin
  if value = 0 then
  begin
    raise Exception.Create('Data vencimento não pode ser nula !');
  end;
  FDataVencimento := Value;
end;

procedure TValidade.SetDiasVencimento(const Value: integer);
begin
  FDiasVencimento := Value;
end;

procedure TValidade.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TValidade.SetLocalizacao(const Value: string);
begin
  FLocalizacao := Value;
end;

procedure TValidade.Setlote(const Value: string);
begin
  Flote := Value;
end;

procedure TValidade.SetQuantidade(const Value: real);
begin
  if value <= 0 then
  begin
    raise Exception.Create('Quantidade não pode ser 0 ou negativa');
  end;
  FQuantidade := Value;
end;

procedure TValidade.SetSituacao(const Value: Integer);
begin
  FSituacao := Value;
end;


end.
