unit uDmSubgrupo;

interface

uses
  System.SysUtils, System.Classes,uDmConexao,Classe.Subgrupo,Conversao,NxGrid,
  Data.DB, MemDS, DBAccess, Uni,Classe.Funcoes,Classe.Grupo;

type
  TdmSubgrupo = class(TDataModule)
    qrSubGrupoPesquisar: TUniQuery;
    qrSubGrupoAlterar: TUniQuery;
    qrSubGrupoInserir: TUniQuery;
    qrSubGrupoExcluir: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarSubGrupo(oSubGrupo : TSubgrupo): Boolean;
    function AlterarSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function InserirSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function ExcluirSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function PreencherGrid(sSubGrupo:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
    function RetornaSequencial(oSubGrupo:TSubGrupo):string;
  end;

var
  dmSubgrupo: TdmSubgrupo;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmSubgrupo }

function TdmSubgrupo.AlterarSubGrupo(oSubGrupo: TSubgrupo): Boolean;
begin
with qrSubGrupoAlterar do
begin
  ParamByName('SUBGRUPO').AsString := oSubGrupo.Descricao;
  ParamByName('CODIGO').AsString := oSubGrupo.Codigo;
  ParamByName('CODIGO_GRUPO').AsString := oSubGrupo.codigoGrupo;
  ExecSQL;
end;
end;

function TdmSubgrupo.CarregarSubGrupo(oSubGrupo: TSubgrupo): Boolean;
begin
with qrSubGrupoPesquisar,oSubGrupo do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM SUBGRUPO left join grupo on subgrupo.codigo_grupo = grupo.codigo WHERE subgrupo.CODIGO = :CODIGO and subgrupo.codigo_grupo = :CODIGO_GRUPO');
  ParamByName('CODIGO').asstring := oSubGrupo.Codigo;
  ParamByName('CODIGO_GRUPO').AsString := oSubGrupo.codigoGrupo;
    try
      Open;
      if qrSubGrupoPesquisar.RecordCount > 0 then
      begin
      Codigo := FieldByName('CODIGO').AsString;
      codigoGrupo := FieldByName('CODIGO_GRUPO').AsString;
      Descricao := FieldByName('SUBGRUPO').AsString;

      TGrupo(oSubGrupo).Codigo := FieldByName('CODIGO_GRUPO').AsString;
      TGrupo(oSubGrupo).Descricao := FieldByName('GRUPO').AsString;
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
          raise Exception.Create('Erro ao carregar Subgrupo');
          Result := False;
      end;

    end;
end;
end;

function TdmSubgrupo.ExcluirSubGrupo(oSubGrupo: TSubgrupo): Boolean;
begin
 with qrSubGrupoExcluir do
begin
  ParamByName('CODIGO').AsString := oSubGrupo.Codigo;
  ParamByName('CODIGO_GRUPO').AsString := oSubGrupo.codigoGrupo;
  ExecSQL;
end;
end;

function TdmSubgrupo.InserirSubGrupo(oSubGrupo: TSubgrupo): Boolean;
begin
 with qrSubGrupoInserir do
begin
  ParamByName('SUBGRUPO').AsString := oSubGrupo.Descricao;
  ParamByName('CODIGO_GRUPO').AsString := oSubGrupo.codigoGrupo;
  ParamByName('CODIGO').AsString := oSubGrupo.Codigo;
  ExecSQL;
end;
end;

function TdmSubgrupo.PreencherGrid(sSubGrupo: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
var
  i:integer;
begin
with qrSubGrupoPesquisar do
begin
  sSubGrupo := StringReplace(sSubGrupo,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM SUBGRUPO LEFT JOIN GRUPO');
  SQL.Add('ON SUBGRUPO.CODIGO_GRUPO = GRUPO.CODIGO');

   if sSubGrupo = EmptyStr then
   begin
      SQL.Add('WHERE SUBGRUPO.SUBGRUPO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 2,1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE SUBGRUPO.SUBGRUPO LIKE '+Chr(39)+'%'+sSubGrupo+'%'+Chr(39));
      SQL.Add('ORDER BY SUBGRUPO.SUBGRUPO');

    end
    else
    if tipo = Codigo then
    begin
      sSubGrupo := zeroEsquerda(sSubGrupo,6);
      SQL.Add('WHERE SUBGRUPO.CODIGO_GRUPO = :CODIGO_GRUPO');
      ParamByName('CODIGO_GRUPO').AsString := sSubGrupo;
      SQL.Add('ORDER BY SUBGRUPO.CODIGO');
    end;

   end;

Open;



grid.ClearRows;

while not qrSubGrupoPesquisar.Eof do
begin
Grid.AddRow(1);
Grid.Cell[0,Grid.LastAddedRow].AsString := FieldByName('CODIGO').AsString;
Grid.Cell[1,Grid.LastAddedRow].AsString := FieldByName('CODIGO_GRUPO').AsString +' - '+ FieldByName('GRUPO').AsString;
Grid.Cell[2,Grid.LastAddedRow].AsString := FieldByName('SUBGRUPO').AsString;
qrSubGrupoPesquisar.Next;
end;
Grid.SelectFirstRow();
end;
end;

function TdmSubgrupo.RetornaSequencial(oSubGrupo:TSubgrupo): string;
begin
with qrSubGrupoPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.Add('select max(cast(CODIGO as float) + 1) from subgrupo where codigo_grupo = '+Chr(39)+TGrupo(oSubGrupo).codigo+Chr(39));

  Open;
  First;
  if FieldByName('max').asstring <> '' then
  begin
  Result := FieldByName('max').asstring;
  end
  else
  begin
    result := '000001';
  end;

end;
end;

end.

