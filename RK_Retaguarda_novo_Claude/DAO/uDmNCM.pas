unit uDmNCM;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,NxGrid,Conversao,Classe.Funcoes,VCL.Forms,Vcl.DBGrids,Classe.NCM;

type
  TdmNCM = class(TDataModule)
    qrGridNCM: TUniQuery;
    ds: TDataSource;
    qrNCMPesquisar: TUniQuery;
  private
    { Private declarations }
  public
    function PreencherGrid(sNCM:string;Grid:TDbGrid;tipo:TPesquisar):Boolean;
    function ValidarNCM(oNCM:TNcm):boolean;
  end;

var
  dmNCM: TdmNCM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmNCM }

function TdmNCM.PreencherGrid(sNCM: string; Grid: TDbGrid;
  tipo: TPesquisar): Boolean;
begin
with qrGridNCM do
begin
  Grid.DataSource := ds;
  sNCM := StringReplace(sNCM,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
  Close;
  SQL.Clear;
  SQL.Add('SELECT  * FROM NCM');

   if sNCM = EmptyStr then
   begin
      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%'+sNCM+'%'+Chr(39));
      SQL.Add('ORDER BY DESCRICAO');

    end
    else
    if tipo = Codigo then
    begin
//      sNCM := zeroEsquerda(sNCM,8);
      SQL.Add('WHERE NCM LIKE '+Chr(39)+sNCM+'%'+Chr(39));
      SQL.Add('ORDER BY NCM');
    end;

   end;

Open;


end;
end;

function TdmNCM.ValidarNCM(oNCM: TNcm): boolean;
begin
with qrNCMPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM NCM WHERE NCM = :NCM');
  ParamByName('NCM').AsString := oNCM.NCM;
  Open;
  if RecordCount > 0  then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
  end;
end;
end;

end.
