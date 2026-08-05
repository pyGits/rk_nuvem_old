unit Importar;


interface
uses
  System.Generics.collections,System.SysUtils;

type TLinha = class
  private
    Ftabela: string;
    Findice_grid: integer;
    Fcoluna: string;
    procedure Setcoluna(const Value: string);
    procedure Setindice_grid(const Value: integer);
    procedure Settabela(const Value: string);
public
  property coluna:string read Fcoluna write Setcoluna;
  property tabela:string read Ftabela write Settabela;
  property indice_grid:integer read Findice_grid write Setindice_grid;
end;

type TImportar = class
  private
    Flinhas: TObjectList<TLinha>;
    procedure Setlinhas(const Value: TObjectList<TLinha>);
    property linhas :TObjectList<TLinha> read Flinhas write Setlinhas;
  public
    constructor create;
    procedure adicionar(linha:TLinha);

end;

implementation

{ Linha }

procedure TLinha.Setcoluna(const Value: string);
begin
  Fcoluna := Value;
end;

procedure TLinha.Setindice_grid(const Value: integer);
begin
  Findice_grid := Value;
end;

procedure TLinha.Settabela(const Value: string);
begin
  Ftabela := Value;
end;






{ TImportar }

procedure TImportar.adicionar(linha: TLinha);
var
  i: Integer;
  linhaExistente: TLinha;
  encontrou: Boolean;
begin

  if linha.tabela = '' then
  begin
    raise Exception.Create('Tabela não selecionada');
  end;
  if linha.coluna = '' then
  begin
    raise Exception.Create('Coluna não selecionada');
  end;


  encontrou := False;

  // Verifica se a linha já existe
  for i := 0 to Flinhas.Count - 1 do
  begin
    linhaExistente := TLinha(Flinhas[i]);
    if (linhaExistente.coluna = linha.coluna) and (linhaExistente.tabela = linha.tabela) then
    begin
      // Se a linha já existir, atualiza o valor da coluna
      linhaExistente.indice_grid := linha.indice_grid;
      encontrou := True;
      Break;
    end;
  end;

  // Se a linha não for encontrada, adiciona uma nova
  if not encontrou then
  begin
    Flinhas.Add(linha);
  end;
end;

constructor TImportar.create;
begin
FLinhas := TObjectList<TLinha>.create;
end;

procedure TImportar.Setlinhas(const Value: TObjectList<TLinha>);
begin
  Flinhas := Value;
end;

end.
