unit FormController;

interface
uses
  Usuario,NivelAcessoRetaguarda,NivelAcessoRetaguardaRepository,FormService,System.SysUtils;
type TFormulario = (FRM_Produto,FRM_Validade);

type TFormController =class
  function FormularioString(AFormulario:TFormulario):string;
public
  procedure AbrirFormulario(AFormulario:TFormulario;codigo:string);

end;

var
  Form_Controller:TFormController;

implementation
{ TFormController }

procedure TFormController.AbrirFormulario(AFormulario: TFormulario;codigo:string);
var
  NivelAcesso:TNivelAcessoRetaguarda;
  Autorizado:Boolean;
begin
  NivelAcesso := NivelAcessoRetaguarda_Repository.CarregarNivelAcesso(FormularioString(AFormulario));
  Autorizado := NivelAcesso.autorizarFormulario(UsuarioLogado);
  if not(Autorizado)then raise Exception.create('Usuário Não Autorizado !');
  Form_Service.AbrirFormulario(FormularioString(AFormulario),codigo);
end;


function TFormController.FormularioString(AFormulario: TFormulario): string;
begin
if AFormulario = FRM_Produto then Result := 'Produto';
if AFormulario = FRM_Validade then Result := 'Validade';
end;

initialization
  Form_Controller:=TFormController.Create;

end.
