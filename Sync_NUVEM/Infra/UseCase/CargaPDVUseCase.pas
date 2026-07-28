unit CargaPDVUseCase;

interface
uses CaixaRepository,CaixaModel,System.Generics.Collections,ClienteAPIRepository,ClienteModel,ClientePDVRepository;
type TCargaPDVUseCase = class
  private
  FCaixaRepository:ICaixaRepository;
  FClienteApiRepository:IClienteApiRepository;
  FClientePDVRepository:IClientePDVRepository;
  public
  procedure EnviarCargaPDV;
  constructor create;
end;

implementation

uses System.SysUtils, uLogErro;

{ TCargaPDVUseCase }

constructor TCargaPDVUseCase.create;
begin
FCaixaRepository := TCaixaRepository.create;
FClienteApiRepository := TClienteApiRepository.create;
FClientePDVRepository := TClientePdvRepository.create;
end;

procedure TCargaPDVUseCase.EnviarCargaPDV;
var
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
  clientes:TObjectList<TClienteModel>;
begin
  caixas := FCaixaRepository.getAll;
  clientes := FClienteApiRepository.getAll;

  // uma caixa fora do ar nao pode impedir a carga das demais
  for caixa in caixas do
  begin
    try
      FClientePDVRepository.InsertBulk(clientes,caixa);
    except
    on E:Exception do
    begin
      uLogErro.LogErro('CARGA_PDV_CLIENTES',
        Format('Caixa %s | %s: %s', [caixa.ip, E.ClassName, E.Message]));
    end;
    end;
  end;
end;

end.
