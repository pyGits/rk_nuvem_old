unit NivelAcessoRetaguarda;

interface
uses System.Generics.Collections,Helper,System.SysUtils,usuario;
type TNivelAcessoRetaguarda = class
  private
    FfuncaoSolicitaSenha: string;
    FDescricao: string;
    Fcodigo: string;
    FCodigoFuncao: string;
    FCategoria: string;
    FFuncaoNivel: string;
    procedure SetCategoria(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure SetCodigoFuncao(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetFuncaoNivel(const Value: string);
    procedure SetfuncaoSolicitaSenha(const Value: string);
  published
    property Codigo: string read Fcodigo write Setcodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property CodigoFuncao:string read FCodigoFuncao write SetCodigoFuncao;
    property Categoria:string read FCategoria write SetCategoria;
    property FuncaoNivel:string read FFuncaoNivel write SetFuncaoNivel;
    property funcaoSolicitaSenha:string read FfuncaoSolicitaSenha write SetfuncaoSolicitaSenha;


    function autorizarFormulario(usuario: TUsuario):boolean;
end;

type TNivelAcessoRetaguardaList = class
  private
    FLista:TList<TNivelAcessoRetaguarda>;
  public
    constructor create;
    procedure adicionar(ANivelAcessoRetaguarda:TNivelAcessoRetaguarda);
    procedure adicionarLista(ANivelAcessoRetaguardaLista:TList<TNivelAcessoRetaguarda>);

    function lista:TList<TNivelAcessoRetaguarda>;
end;

implementation

{ TNivelAcessoRetaguarda }

function TNivelAcessoRetaguarda.autorizarFormulario(
  usuario: TUsuario): boolean;
  var
      arrayNiv:TArray<string>;
      I:integer;
begin
  result := false;
  arrayNiv := Helper_Utils.Split(FFuncaoNivel,';');
  for I := 0 to Length(arrayNiv)-1 do
  begin
    if arrayNiv[I] = IntToStr(usuario.cargo) then
    begin
      result := true;
    end;

  end;
end;

procedure TNivelAcessoRetaguarda.SetCategoria(const Value: string);
begin
  FCategoria := Value;
end;

procedure TNivelAcessoRetaguarda.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TNivelAcessoRetaguarda.SetCodigoFuncao(const Value: string);
begin
  FCodigoFuncao := Value;
end;

procedure TNivelAcessoRetaguarda.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TNivelAcessoRetaguarda.SetFuncaoNivel(const Value: string);
begin
  FFuncaoNivel := Value;
end;

procedure TNivelAcessoRetaguarda.SetfuncaoSolicitaSenha(const Value: string);
begin
  FfuncaoSolicitaSenha := Value;
end;

{ TNivelAcessoRetaguardaList }

procedure TNivelAcessoRetaguardaList.adicionar(
  ANivelAcessoRetaguarda: TNivelAcessoRetaguarda);
begin
FLista.Add(ANivelAcessoRetaguarda);
end;

procedure TNivelAcessoRetaguardaList.adicionarLista(
  ANivelAcessoRetaguardaLista: TList<TNivelAcessoRetaguarda>);
begin
FLista.AddRange(ANivelAcessoRetaguardaLista);
end;

constructor TNivelAcessoRetaguardaList.create;
begin
FLista := TList<TNivelAcessoRetaguarda>.create;
end;

function TNivelAcessoRetaguardaList.lista: TList<TNivelAcessoRetaguarda>;
begin
result := FLista;
end;

end.
