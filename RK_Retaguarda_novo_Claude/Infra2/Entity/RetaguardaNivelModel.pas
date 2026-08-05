unit RetaguardaNivelModel;

interface
type TRetaguardaNivelModel = class
  private
    Fdescricao: string;
    Fcodigo: string;
    Fcategoria: string;
    Fnivel: string;
    Fsolicita_senha: Boolean;
    procedure Setcategoria(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure Setdescricao(const Value: string);
    procedure Setnivel(const Value: string);
    procedure Setsolicita_senha(const Value: Boolean);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property descricao:string read Fdescricao write Setdescricao;
  property categoria:string read Fcategoria write Setcategoria;
  property nivel:string read Fnivel write Setnivel;
  property solicita_senha:Boolean read Fsolicita_senha write Setsolicita_senha;
end;

implementation

{ TRetaguardaNivelModel }

procedure TRetaguardaNivelModel.Setcategoria(const Value: string);
begin
  Fcategoria := Value;
end;

procedure TRetaguardaNivelModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TRetaguardaNivelModel.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

procedure TRetaguardaNivelModel.Setnivel(const Value: string);
begin
  Fnivel := Value;
end;

procedure TRetaguardaNivelModel.Setsolicita_senha(const Value: Boolean);
begin
  Fsolicita_senha := Value;
end;

end.
