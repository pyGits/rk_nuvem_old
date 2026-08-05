unit Classe.AcessoPDV;

interface

uses
  System.SysUtils;
  type
  TAcessoPDV = class
    private
    Fcodigo: string;
    FDescricao: string;
    FfuncaoSolicitaSenha: string;
    FCodigoFuncao: string;
    FCategoria: string;
    FFuncaoNivel: string;
    procedure Setcodigo(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetCategoria(const Value: string);
    procedure SetCodigoFuncao(const Value: string);
    procedure SetFuncaoNivel(const Value: string);
    procedure SetfuncaoSolicitaSenha(const Value: string);



    public
    property Codigo: string read Fcodigo write Setcodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property CodigoFuncao:string read FCodigoFuncao write SetCodigoFuncao;
    property Categoria:string read FCategoria write SetCategoria;
    property FuncaoNivel:string read FFuncaoNivel write SetFuncaoNivel;
    property funcaoSolicitaSenha:string read FfuncaoSolicitaSenha write SetfuncaoSolicitaSenha;


  end;

implementation
uses
Classe.funcoes;

{ TNCM }


{ TAcessoPDV }

procedure TAcessoPDV.SetCategoria(const Value: string);
begin
  FCategoria := Value;
end;

procedure TAcessoPDV.Setcodigo(const Value: string);
var
  codigo : string;
begin
  if (Value = '') or (Value = '000000') then
  begin
    CODIGO := '000000';
  end;

  codigo := zeroEsquerda(Value,6);

  Fcodigo := Codigo;
end;

procedure TAcessoPDV.SetCodigoFuncao(const Value: string);
begin
  FCodigoFuncao := Value;
end;

procedure TAcessoPDV.SetDescricao(const Value: string);
begin
  if Length(Value)>30 then
  begin
    raise Exception.Create('Limite de 30 letras');
  end;

  FDescricao := Value;
end;

procedure TAcessoPDV.SetFuncaoNivel(const Value: string);
begin
  FFuncaoNivel := Value;
end;

procedure TAcessoPDV.SetfuncaoSolicitaSenha(const Value: string);
var
solic:string;
begin
  solic := value;
  if solic = '' then
  begin
    solic := '0';
  end;

  FfuncaoSolicitaSenha := solic;
end;

end.
