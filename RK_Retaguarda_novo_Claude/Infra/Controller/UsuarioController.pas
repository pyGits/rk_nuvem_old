unit UsuarioController;

interface
uses UsuarioRepository,Usuario;
type TUsuarioController = class
  public
  function AutenticarUsuario(codigo,senha:string):Boolean;
end;
var
  Usuario_Controller: TUsuarioController;
implementation



{ TUsuarioController }

function TUsuarioController.AutenticarUsuario(codigo, senha: string): Boolean;
begin
  UsuarioLogado := Usuario_Repository.CarregarUsuario(codigo);
  result := UsuarioLogado.Autenticar(senha);
end;

initialization
  Usuario_Controller:= TUsuarioController.Create;
end.
