unit TerminalService;

interface
uses uTxtManager,System.Generics.Collections,produtomodel,uStringUtils;
type ITerminalService = interface
  ['{4C8F6E98-317C-41C6-B170-969BD887162A}']
  procedure GerarTxt(produtos:TObjectList<TProdutoModel>);
end;
type TTerminalService = class(TInterfacedObject,ITerminalService)
  FTxtManager:TTxtManager;
  constructor create(caminhoTxt:string);
  destructor destroy;override;
  public
    procedure GerarTxt(produtos:TObjectList<TProdutoModel>);


end;

implementation

{ TTerminalService }

constructor TTerminalService.create(caminhoTxt: string);
begin
FTxtManager := TTxtManager.create(caminhoTxt);
end;

destructor TTerminalService.destroy;
begin
  FtxtManager.free;
  inherited;
end;

procedure TTerminalService.GerarTxt(produtos:TObjectList<TProdutoModel>);
var
  produto:TProdutoModel;
  sCodigoBarras:string;
  sDescricao:string;
  linha:string;
begin
  FTxtManager.clear;
  for produto in produtos do
  begin
    sCodigoBarras := Copy(produto.CodigoBarras, 2, Length(produto.CodigoBarras) - 1);
    sDescricao := TStringUtils.PreencherEspacos(produto.Descricao,18);
    linha := sCodigoBarras + '|' + sDescricao + '|';
    Ftxtmanager.Append(linha);
  end;
end;



end.
