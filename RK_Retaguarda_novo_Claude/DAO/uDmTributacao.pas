unit uDmTributacao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Uni,Classe.Tributacao,NxGrid,Conversao,uDmConexao,Classe.Funcoes,Vcl.StdCtrls;

type
  TdmTributacao = class(TDataModule)
    qrTrbPesquisar: TUniQuery;
    qrTrbAlterar: TUniQuery;
    qrTrbInserir: TUniQuery;
    qrTrbExcluir: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarTributacao(oTributacao : TTributacao): Boolean;
    function AlterarTributacao(oTributacao:TTributacao):Boolean;
    function InserirTributacao(oTributacao:TTributacao):Boolean;
    function ExcluirTributacao(oTributacao:TTributacao):Boolean;
    function PreencherGrid(sTributacao:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
    function PreencherComboBox(cb:TComboBox):Boolean;
  end;

var
  dmTributacao: TdmTributacao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmTributacao }

function TdmTributacao.AlterarTributacao(oTributacao: TTributacao): Boolean;
begin
with qrTrbAlterar do
begin
  ParamByName('CODIGO').AsString := oTributacao.codigo;
  ParamByName('DESCRICAO').AsString := oTributacao.Tributacao;
  ParamByName('CST').AsString := oTributacao.cst;
  ParamByName('CFOP').AsString := oTributacao.CFOP;
  ParamByName('CSOSN').AsString := oTributacao.CSOSN;
  ParamByName('ST').AsString := oTributacao.ST;
  ParamByName('ICMS').AsFloat := oTributacao.ICMS;
  ExecSQL;
end;
end;

function TdmTributacao.CarregarTributacao(oTributacao: TTributacao): Boolean;
begin
with qrTrbPesquisar,oTributacao do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM tributacao WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oTributacao.Codigo;
    try
      qrTrbPesquisar.Open;
      if qrTrbPesquisar.RecordCount > 0 then
      begin
      Codigo := qrTrbPesquisar.FieldByName('CODIGO').AsString;
      Tributacao := qrTrbPesquisar.FieldByName('DESCRICAO').AsString;
      CST := qrTrbPesquisar.FieldByName('CST').AsString;
      CFOP := qrTrbPesquisar.FieldByName('CFOP').AsString;
      CSOSN := qrTrbPesquisar.FieldByName('CSOSN').AsString;
      ST := qrTrbPesquisar.FieldByName('ST').AsString;
      ICMS := qrTrbPesquisar.FieldByName('ICMS').AsFloat;
      result := True;
      end
      else
      begin
        Codigo := '000000';
        Tributacao := '';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar Tributacao');
          Result := False;
      end;

    end;
end;
end;

function TdmTributacao.ExcluirTributacao(oTributacao: TTributacao): Boolean;
begin

with qrTrbExcluir do
begin
  ParamByName('CODIGO').asstring := oTributacao.Codigo;
  ExecSQL;
end;
end;

function TdmTributacao.InserirTributacao(oTributacao: TTributacao): Boolean;
begin
 with qrTrbInserir do
begin
  ParamByName('CODIGO').AsString := oTributacao.codigo;
  ParamByName('DESCRICAO').AsString := oTributacao.Tributacao;
  ParamByName('CST').AsString := oTributacao.cst;
  ParamByName('CFOP').AsString := oTributacao.CFOP;
  ParamByName('CSOSN').AsString := oTributacao.CSOSN;
  ParamByName('ST').AsString := oTributacao.ST;
  ParamByName('ICMS').AsFloat := oTributacao.ICMS;
  ExecSQL;
end;
end;

function TdmTributacao.PreencherComboBox(cb: TComboBox): Boolean;
begin
with qrTrbPesquisar do
begin
Close;
SQL.Clear;
SQL.add('select * from tributacao');
Open;
  cb.items.Clear;
  while not qrTrbPesquisar.eof do
  begin
  cb.Items.Add(FieldByName('CODIGO').AsString);
  Next;
  end;
end;
end;

function TdmTributacao.PreencherGrid(sTributacao: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
var
  i:integer;
begin
with qrTrbPesquisar do
begin
sTributacao := StringReplace(sTributacao,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM TRIBUTACAO');

   if sTributacao = EmptyStr then
   begin
      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%'+sTributacao+'%'+Chr(39));
      SQL.Add('ORDER BY DESCRICAO');

    end
    else
    if tipo = Codigo then
    begin
      sTributacao := zeroEsquerda(sTributacao,3);
      SQL.Add('WHERE CODIGO = :CODIGO');
      ParamByName('CODIGO').AsString := sTributacao;
      SQL.Add('ORDER BY CODIGO');
    end;

   end;

Open;



grid.ClearRows;

while not qrTrbPesquisar.Eof do
begin
Grid.AddRow(1);
Grid.Cell[0,Grid.LastAddedRow].AsString := FieldByName('CODIGO').AsString;
Grid.Cell[1,Grid.LastAddedRow].AsString := FieldByName('DESCRICAO').AsString;
Grid.Cell[2,Grid.LastAddedRow].AsString := FieldByName('CST').AsString;
Grid.Cell[3,Grid.LastAddedRow].AsString := FieldByName('CFOP').AsString;
Grid.Cell[4,Grid.LastAddedRow].AsString := FieldByName('CSOSN').AsString;
Grid.Cell[5,Grid.LastAddedRow].AsString := FieldByName('ST').AsString;
Grid.Cell[6,Grid.LastAddedRow].AsFloat := FieldByName('ICMS').AsFloat;
qrTrbPesquisar.Next;
end;
grid.SelectFirstRow();
end;

end;

end.
