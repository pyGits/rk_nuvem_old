unit uDmFinalizadora;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Finalizadora,NxGrid,Conversao,Classe.Funcoes;

type
  TdmFinalizadora = class(TDataModule)
    qrFinalizadoraPesquisar: TUniQuery;
    qrFinalizadoraAlterar: TUniQuery;
    qrFinalizadoraInserir: TUniQuery;
    qrFinalizadoraExcluir: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarFinalizadora(oFinalizadora : TFinalizadora): Boolean;
    function AlterarFinalizadora(oFinalizadora:TFinalizadora):Boolean;
    function InserirFinalizadora(oFinalizadora:TFinalizadora):Boolean;
    function ExcluirFinalizadora(oFinalizadora:TFinalizadora):Boolean;
    function PreencherGrid(sFinalizadora:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
  end;

var
  dmFinalizadora: TdmFinalizadora;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmFinalizadora }

function TdmFinalizadora.AlterarFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
with qrFinalizadoraAlterar do
begin
  ParamByName('CODIGO').AsString := oFinalizadora.Codigo;
  ParamByName('DESCRICAO').AsString := oFinalizadora.Descricao;
  ParamByName('ESPECIE').AsInteger := oFinalizadora.especie;
  ParamByName('TIPO').AsString := oFinalizadora.Tipo;
  ParamByName('CODIGO99').AsInteger := oFinalizadora.cod99;
  ExecSQL;
end;
end;

function TdmFinalizadora.CarregarFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
with qrFinalizadoraPesquisar,oFinalizadora do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM Finalizadora WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oFinalizadora.Codigo;
    try
      qrFinalizadoraPesquisar.Open;
      if qrFinalizadoraPesquisar.RecordCount > 0 then
      begin
      Codigo := qrFinalizadoraPesquisar.FieldByName('CODIGO').AsString;
      Descricao := qrFinalizadoraPesquisar.FieldByName('DESCRICAO').AsString;
      Especie := qrFinalizadoraPesquisar.FieldByName('ESPECIE').AsInteger;
      Tipo := qrFinalizadoraPesquisar.FieldByName('TIPO').AsString;
      cod99 := qrFinalizadoraPesquisar.FieldByName('CODIGO99').AsInteger;
      result := True;
      end
      else
      begin
        Codigo := '000';
        Descricao := '';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar Finalizadora');
          Result := False;
      end;

    end;
end;
end;

function TdmFinalizadora.ExcluirFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
 with qrFinalizadoraExcluir do
begin
  ParamByName('CODIGO').AsString := oFinalizadora.Codigo;
  ExecSQL;
end;
end;

function TdmFinalizadora.InserirFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
 with qrFinalizadoraInserir do
begin
  ParamByName('CODIGO').AsString := oFinalizadora.Codigo;
  ParamByName('DESCRICAO').AsString := oFinalizadora.Descricao;
  ParamByName('ESPECIE').AsInteger := oFinalizadora.especie;
  ParamByName('TIPO').AsString := oFinalizadora.Tipo;
  ParamByName('CODIGO99').AsInteger := oFinalizadora.cod99;
  ExecSQL;
end;
end;

function TdmFinalizadora.PreencherGrid(sFinalizadora: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
var
  i:integer;
begin
with qrFinalizadoraPesquisar do
begin
sFinalizadora := StringReplace(sFinalizadora,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM Finalizadora');

   if sFinalizadora = EmptyStr then
   begin
      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%'+sFinalizadora+'%'+Chr(39));
      SQL.Add('ORDER BY DESCRICAO');

    end;
   end;

Open;



grid.ClearRows;

while not qrFinalizadoraPesquisar.Eof do
begin
Grid.AddRow(1);
Grid.Cell[0,Grid.LastAddedRow].AsString := FieldByName('CODIGO').AsString;
Grid.Cell[1,Grid.LastAddedRow].AsString := FieldByName('DESCRICAO').AsString;
qrFinalizadoraPesquisar.Next;
end;
grid.SelectFirstRow();
end;
end;

end.
