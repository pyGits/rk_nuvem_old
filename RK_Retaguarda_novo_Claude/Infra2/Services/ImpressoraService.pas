unit ImpressoraService;

interface
uses ACBrPosPrinter;
type TFonte = set of (fNegrito, fItalico, t10cpi, t12cpi, t17cpi, tExp, Justif, Esquerda, Centraliza, Direita);
type IImpressoraService = interface
  ['{013ABEB2-56C9-43BF-980B-57EC3B911432}']
    procedure ImprimirBuffer(sTexto: string; Fonte: TFonte);
    procedure Imprimir;
    procedure Configurar(porta:string);
    procedure Limpar;
end;

type TImpressoraService = class(TInterfacedObject,IImpressoraService)
  private
    impressora:TACbrPosPrinter;
  public
    constructor create;
    procedure Configurar(porta:string);
    procedure ImprimirBuffer(sTexto: string; Fonte: TFonte);
    procedure Imprimir;
    procedure Limpar;

end;

implementation

{ TImpressoraService }

procedure TImpressoraService.Configurar(porta: string);
begin
impressora.Desativar;
impressora.Porta := porta;
end;

constructor TImpressoraService.create;
begin
impressora := TACBrPosPrinter.Create(nil);
impressora.Desativar;
impressora.Modelo := TACBrPosPrinterModelo(ppEscPosEpson);
end;

procedure TImpressoraService.Imprimir;
begin
impressora.Ativar;
impressora.Buffer.Add('');
impressora.Buffer.Add('');
impressora.Buffer.Add('</corte_total>');
impressora.Imprimir();
end;

procedure TImpressoraService.ImprimirBuffer(sTexto: string; Fonte: TFonte);
var
  sFonteInicia:string;
  sFonteFecha:string;
begin
    sFonteInicia := '';
    sFonteInicia := '';
  if fNegrito in Fonte then
  begin
    sFonteInicia :=  '<n>';
    sFonteFecha :=  '</n>';
  end;
  if Centraliza in Fonte then
  begin
      sFonteInicia :=  '<ce>';
      sFonteFecha :=  '</ce>';
  end;
  if Direita in Fonte then
  begin
      sFonteInicia :=  '<ad>';
      sFonteFecha :=  '</ad>';
  end;
  if Esquerda in Fonte then
  begin
    sFonteInicia :=  '<ae>';
    sFonteFecha := '</ae>';
  end;
  impressora.Buffer.Add(sFonteInicia + sTexto + sFonteFecha);
end;

procedure TImpressoraService.Limpar;
begin
impressora.Buffer.Clear;
end;

end.
