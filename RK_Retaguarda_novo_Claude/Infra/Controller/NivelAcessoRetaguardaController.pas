unit NivelAcessoRetaguardaController;

interface

uses NivelAcessoRetaguardaRepository,NivelAcessoRetaguarda;
type TNivelAcessoRetaguardaController = class
  private
  public
  function AutorizarForm(formulario_nome:string; cargo_funcionario:integer):boolean;
end;

var
  NivelAcessoRetaguarda_Controller:TNivelAcessoRetaguardaController;

implementation

{ TNivelAcessoRetaguardaController }

function TNivelAcessoRetaguardaController.AutorizarForm(
  formulario_nome: string;cargo_funcionario:integer): boolean;
  var
    NivelAcesso:TNivelAcessoRetaguarda;
begin
//  result := false;
//  NivelAcesso := NivelAcessoRetaguarda_Repository.CarregarNivelAcesso(formulario_nome);
//  result := NivelAcesso.autorizarFormulario(cargo_funcionario);
end;

initialization
  NivelAcessoRetaguarda_controller := TNivelAcessoRetaguardaController.create;

end.
