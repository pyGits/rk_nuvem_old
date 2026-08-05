unit uDmGrupo;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Grupo,NxGrid,Conversao,Classe.Funcoes;

type
  TdmGrupo = class(TDataModule)
    qrGrupoPesquisar: TUniQuery;
    qrGrupoAlterar: TUniQuery;
    qrGrupoInserir: TUniQuery;
    qrGrupoExcluir: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarGrupo(oGrupo : TGrupo): Boolean;
    function AlterarGrupo(oGrupo:TGrupo):Boolean;
    function InserirGrupo(oGrupo:TGrupo):Boolean;
    function ExcluirGrupo(oGrupo:TGrupo):Boolean;
    function PreencherGrid(sGrupo:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
  end;

var
  dmGrupo: TdmGrupo;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmGrupo }

function TdmGrupo.AlterarGrupo(oGrupo: TGrupo): Boolean;
begin
with qrGrupoAlterar do
begin
  ParamByName('GRUPO').AsString := oGrupo.Descricao;
  ParamByName('CODIGO').AsString := oGrupo.Codigo;
  ExecSQL;
end;
end;

function TdmGrupo.CarregarGrupo(oGrupo: TGrupo): Boolean;
begin
with qrGrupoPesquisar,oGrupo do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM GRUPO WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oGrupo.Codigo;
    try
      qrGRUPOPesquisar.Open;
      if qrGRUPOPesquisar.RecordCount > 0 then
      begin
      Codigo := qrGRUPOPesquisar.FieldByName('CODIGO').AsString;
      Descricao := qrGRUPOPesquisar.FieldByName('Grupo').AsString;
      result := True;
      end
      else
      begin
        Codigo := '000000';
        Descricao := '';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar Grupo');
          Result := False;
      end;

    end;
end;
end;

function TdmGrupo.ExcluirGrupo(oGrupo: TGrupo): Boolean;
begin
 with qrGrupoExcluir do
begin
  ParamByName('CODIGO').AsString := oGrupo.Codigo;
  ExecSQL;
end;
end;

function TdmGrupo.InserirGrupo(oGrupo: TGrupo): Boolean;
begin
 with qrGrupoInserir do
begin
  try
  ParamByName('GRUPO').AsString := oGrupo.Descricao;
  ParamByName('CODIGO').AsString := oGrupo.Codigo;

  ExecSQL;

  result := true;
  except
  on E:Exception do
  begin
    result := false;
    raise Exception.Create('Erro ao inserir grupo: '+ E.Message);
  end;

  end;
end;
end;

function TdmGrupo.PreencherGrid(sGrupo: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
var
  i:integer;
begin
with qrGrupoPesquisar do
begin
sGrupo := StringReplace(sGrupo,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM GRUPO');

   if sGrupo = EmptyStr then
   begin
      SQL.Add('WHERE GRUPO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE GRUPO LIKE '+Chr(39)+'%'+sGrupo+'%'+Chr(39));
      SQL.Add('ORDER BY GRUPO');

    end;


   end;

Open;



grid.ClearRows;

while not qrGrupoPesquisar.Eof do
begin
Grid.AddRow(1);
Grid.Cell[0,Grid.LastAddedRow].AsString := FieldByName('CODIGO').AsString;
Grid.Cell[1,Grid.LastAddedRow].AsString := FieldByName('GRUPO').AsString;
qrGrupoPesquisar.Next;
end;
grid.SelectFirstRow();
end;
end;

end.
