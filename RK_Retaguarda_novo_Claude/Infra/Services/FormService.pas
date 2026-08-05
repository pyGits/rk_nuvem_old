unit FormService;

interface
uses uFrmProduto,VCL.Forms,uFrmValidade;
type TFormService = class
  public
    procedure AbrirFormulario(formulario,ACodigo:string);
end;
var
  Form_Service :TFormService;

implementation

{ TFormService }

procedure TFormService.AbrirFormulario(formulario,ACodigo: string);
begin
if(formulario = 'Produto') then
begin
TfrmProduto.AbrirForm(ACodigo);
end;

if (formulario = 'Validade') then
begin
     Application.CreateForm(TfrmValidade, frmValidade);
     frmValidade.Position := poMainFormCenter;
     frmValidade.BorderStyle := bsSingle;
     frmValidade.Show
end;
end;

initialization
  Form_Service := TFormService.create;
end.
