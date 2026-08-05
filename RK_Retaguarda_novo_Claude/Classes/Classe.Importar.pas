unit Classe.Importar;

interface
uses System.Generics.Collections;



type
 TImportarItem = class;
TImportar = class;

TImportarItem = class(TObject)
  private
    FcolunaPlanilha: integer;
    FcolunaImportar: integer;
    procedure SetcolunaPlanilha(const Value: integer);
    procedure SetcolunaImportar(const Value: integer);

  public
    property colunaPlanilha:integer read FcolunaPlanilha write SetcolunaPlanilha;
    property colunaImportar:integer read FcolunaImportar write SetcolunaImportar;

end;


TImportar = class(TObject)
  private

  public
    FItems:TObjectList<TImportarItem>;
  constructor create;
  function selecionarColunaImportar(coluna:integer):integer;
  procedure zerarItens(qtdColunasImportar:integer);

end;



implementation

{ TImportar }



{ TImportar }



{ TImportar }



constructor TImportar.create;
begin
FItems := TObjectList<TImportarItem>.create;
end;

function TImportar.selecionarColunaImportar(coluna: integer): integer;
var
  item:TImportarItem;
  itemAdicionar:TImportarItem;
  encontrouColunaImportar:Boolean;
begin
// retornar somente coluna planilha
  result := 0;
  for item in FItems do
  begin
    if item.FcolunaImportar = coluna then
    begin
      result := item.colunaPlanilha;
    end;
  end;


end;

procedure TImportar.zerarItens(qtdColunasImportar:integer);
var
  item:TImportarItem;
  i:integer;
begin
  FItems.Clear;
  item :=TImportarItem.Create;
  for I := 0 to qtdColunasImportar-1 do
  begin
  item.colunaImportar := I;
  FItems.Add(item)
  end;
end;

{ TImportarItem }

procedure TImportarItem.SetcolunaImportar(const Value: integer);
begin
  FcolunaImportar := Value;
end;

procedure TImportarItem.SetcolunaPlanilha(const Value: integer);
begin
  FcolunaPlanilha := Value;
end;

end.
