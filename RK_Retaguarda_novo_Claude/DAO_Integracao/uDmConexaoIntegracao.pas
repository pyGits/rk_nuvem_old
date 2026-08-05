unit uDmConexaoIntegracao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, UniProvider,Classe.funcoes,
  InterBaseUniProvider, Vcl.StdCtrls,uDmConexao, MemDS,Classe.Produto,Classe.variaveis,VCL.Forms;

type
  TdmConexaoIntegracao = class(TDataModule)
    ConexaoIntegracao: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    qrZerar: TUniQuery;
    qrIntegracaoPesq: TUniQuery;
    qrAtualizaCodigo: TUniQuery;
    qrInserirMapeamento: TUniQuery;
    qrInserirAuxiliar: TUniQuery;
    qrGetCodigoAuxiliar: TUniQuery;
    qrGetCodigoMax: TUniQuery;
    qrGetMapeamento: TUniQuery;
    qrDeleteAuxiliar: TUniQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    function zerarBDRK:Boolean;
    function importarProdutosSyspdv(log:TMemo;alterados:boolean):boolean;
    function InserirCodigoAuxiliar(Codigo,CodigoBarras:string):Boolean;

  public
    function ImportarSyspdvCompleto(log:TMemo;zerarBD:boolean):boolean;
    function ImportarSyspdvAlterado(log:TMemo):boolean;
    function ImportarSyspdvFracionado(log:TMemo):Boolean;

    function InserirMapeamento(codigo,codigo_externo:string):boolean;
    function ObterMapeamento(codigo_externo:string):string;
  end;

var
  dmConexaoIntegracao: TdmConexaoIntegracao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConexaoIntegracao }


function TdmConexaoIntegracao.InserirCodigoAuxiliar(Codigo,CodigoBarras:string): Boolean;
begin
with qrGetCodigoAuxiliar do
begin
  close;
  sql.Clear;
  sql.Add('SELECT * FROM PRODUTOAUX WHERE PROCOD = :PROCOD ORDER BY PROCOD ASC');
  ParamByName('PROCOD').AsString := CodigoBarras;
  open;

with  qrDeleteAuxiliar do
begin
  Close;
  sql.Clear;
  sql.Add('delete from codigo_auxiliar where codigo_barras = :CODIGO_BARRAS and CODIGO_AUXILIAR = :CODIGO_AUXILIAR');
    ParamByName('CODIGO_BARRAS').AsString:= CodigoBarras;
    ParamByName('CODIGO_AUXILIAR').AsString:=qrGetCodigoAuxiliar.FieldByName('PROCODAUX').AsString;
    ExecSQL;
end;



  while not qrGetCodigoAuxiliar.Eof do
  begin
    qrInserirAuxiliar.Close;
    qrInserirAuxiliar.SQL.Clear;
    qrInserirAuxiliar.SQL.Add('UPDATE OR INSERT INTO CODIGO_AUXILIAR(CODIGO,CODIGO_BARRAS,CODIGO_AUXILIAR)');
    qrInserirAuxiliar.SQL.Add('VALUES (:CODIGO,:CODIGO_BARRAS,:CODIGO_AUXILIAR)');
    qrInserirAuxiliar.ParamByName('CODIGO').AsString := Codigo;
    qrInserirAuxiliar.ParamByName('CODIGO_BARRAS').AsString := CodigoBarras;
    qrInserirAuxiliar.ParamByName('CODIGO_AUXILIAR').AsString := qrGetCodigoAuxiliar.FieldByName('PROCODAUX').AsString;
    qrInserirAuxiliar.ExecSQL;

    qrGetCodigoAuxiliar.Next;
  end;




end;
end;

procedure TdmConexaoIntegracao.DataModuleCreate(Sender: TObject);
begin
//ConexaoIntegracao.Server := LerIni('./Retaguarda.ini','cfg','Syspdv','127.0.0.1');
//ConexaoIntegracao.Connect;
end;

function TdmConexaoIntegracao.importarProdutosSyspdv(log:TMemo;alterados:boolean): boolean;
var
  oProduto :TProduto;
  bFracionado:boolean;
  bBalanca:Boolean;
  codigomapeado:string;
  seqMax:integer;
begin

with qrGetCodigoMax do
begin
  Close;
  SQL.Clear;
  sql.Add('SELECT CASE WHEN COUNT(*) = 0 THEN 0 ELSE MAX(CODIGO) END AS MAX_CODIGO FROM PRODUTO');
  Open;
  if qrGetCodigoMax.RecordCount > 0 then
  begin
  seqMax :=qrGetCodigoMax.FieldByName('MAX_CODIGO').AsInteger+1;
  end;

end;


with qrIntegracaoPesq do
begin
  Close;
  SQL.Clear;
  if alterados then
  begin
  SQL.Add('SELECT * FROM produto WHERE prodatcadalt >= (SELECT MAX(CAST(prodatcadalt AS DATE)) - 10 FROM produto)');

  end
  else
  begin
  SQL.Add('SELECT * FROM PRODUTO ORDER BY PROCOD ASC');
  end;
  Open;


  while not qrIntegracaoPesq.Eof do
  begin
    oProduto := TProduto.create;
    with oProduto,qrIntegracaoPesq do
    begin
          try
      bFracionado := false;
      bBalanca := false;
      if FieldByName('PROPESVAR').AsString = 'S' then
      begin
        bFracionado := true;
      end;

      if FieldByName('PROENVBAL').AsString = 'S' then
      begin
        bBalanca := True;
      end;

      CodigoMapeado := ObterMapeamento(FieldByName('PROCOD').AsString);
      if CodigoMapeado <> '' then
      begin
      Codigo := CodigoMapeado;
      end
      else
      begin
      Codigo := IntToStr(seqMax);
      end;
      CodigoBarras := FieldByName('PROCOD').AsString;
      Descricao := FieldByName('PRODES').AsString;
      Tributacao := FieldByName('TRBID').AsString;
      Unidade := FieldByName('PROUNID').AsString;
      oProduto.Inativo := false;
      oProduto.Grupo :=FieldByName('SECCOD').AsString;
      Subgrupo :=FieldByName('GRPCOD').AsString;

      if FieldByName('PROPRCOFEVAR').asfloat > 0 then
      begin
      Preco := FieldByName('PROPRCOFEVAR').AsFloat;
      end
      else
      begin
      Preco := FieldByName('PROPRCVDAVAR').AsFloat;
      end;
      Custo := FieldByName('PROPRCCST').AsFloat;
      Validade := FieldByName('PROVLD').AsString;
      NCM := FieldByName('PRONCM').AsString;
      cest := FieldByName('PROCEST').AsString;
      Fracionado := bFracionado;
      Balanca := bBalanca;


      log.Lines.Add('INSERINDO PRODUTO: '+ oProduto.CodigoBarras);

      VariaveisSrv.oProdutoController.InserirProduto(oProduto);

      InserirCodigoAuxiliar(Codigo,FieldByName('PROCOD').AsString);
      InserirMapeamento(codigo,FieldByName('PROCOD').AsString);

      Application.ProcessMessages;
      seqMax := seqMax +1;
      except
      on E:Exception do
      begin
        log.Lines.Add(e.Message);
        seqMax := seqMax +1;
      end;


      end;






    end;


    qrIntegracaoPesq.Next;
  end;
end;
end;


function TdmConexaoIntegracao.ImportarSyspdvAlterado(log: TMemo): boolean;
begin
  log.Lines.Clear;
//  importarProdutosSyspdvAlterados(log);
  importarProdutosSyspdv(log,true);
end;

function TdmConexaoIntegracao.ImportarSyspdvCompleto(log: TMemo;
  zerarBD: boolean): boolean;
begin
  log.Lines.Clear;
  zerarBDRK;
  log.Lines.Add('Banco de dados Zerado ...');
  importarProdutosSyspdv(log,false);
end;

function TdmConexaoIntegracao.ImportarSyspdvFracionado(log: TMemo): Boolean;
var
  oProduto :TProduto;
  bFracionado:boolean;
  bBalanca:Boolean;
  codigoMapeado:string;
begin
zerarBDRK;


with qrIntegracaoPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM produto WHERE propesvar = '+Chr(39)+'S'+Chr(39));
  Open;

  while not qrIntegracaoPesq.Eof do
  begin
    oProduto := TProduto.create;
    with oProduto,qrIntegracaoPesq do
    begin
      bFracionado := false;
      bBalanca := false;
      if FieldByName('PROPESVAR').AsString = 'S' then
      begin
        bFracionado := true;
      end;

      if FieldByName('PROENVBAL').AsString = 'S' then
      begin
        bBalanca := True;
      end;

      CodigoMapeado := ObterMapeamento(FieldByName('PROCOD').AsString);
      if CodigoMapeado <> '' then
      begin
      Codigo := CodigoMapeado;
      end
      else
      begin
      Codigo := IntToStr(RecNo);
      end;
      CodigoBarras := FieldByName('PROCOD').AsString;
      Descricao := FieldByName('PRODES').AsString;
      Tributacao := FieldByName('TRBID').AsString;
      Unidade := FieldByName('PROUNID').AsString;
      oProduto.Inativo := false;
      oProduto.Grupo :=FieldByName('SECCOD').AsString;
      Subgrupo :=FieldByName('GRPCOD').AsString;
      Preco := FieldByName('PROPRCVDAVAR').AsFloat;
      Custo := FieldByName('PROPRCCST').AsFloat;
      Validade := FieldByName('PROVLD').AsString;
      NCM := FieldByName('PRONCM').AsString;
      cest := FieldByName('PROCEST').AsString;
      Fracionado := bFracionado;
      Balanca := bBalanca;


      log.Lines.Add('INSERINDO PRODUTO: '+ oProduto.CodigoBarras);

      VariaveisSrv.oProdutoController.InserirProduto(oProduto);
      InserirMapeamento(codigo,FieldByName('PROCOD').AsString);

      Application.ProcessMessages;






    end;


    qrIntegracaoPesq.Next;
  end;
end;
end;

function TdmConexaoIntegracao.InserirMapeamento(codigo,
  codigo_externo: string): boolean;
begin
with qrInserirMapeamento do
begin
  close;
  sql.Clear;
  SQL.Add('UPDATE OR INSERT INTO MAPEAMENTO_PRODUTO(CODIGO,CODIGO_EXTERNO) VALUES(:CODIGO,:CODIGO_EXTERNO)');
  ParamByName('CODIGO').AsString := codigo;
  ParamByName('CODIGO_EXTERNO').AsString := codigo_externo;
  ExecSQL;
end;
end;



function TdmConexaoIntegracao.ObterMapeamento(codigo_externo: string): string;
begin
with qrGetMapeamento do
begin
  close;
  sql.Clear;
  sql.Add('SELECT * FROM MAPEAMENTO_PRODUTO WHERE CODIGO_EXTERNO = :CODIGO_EXTERNO');
  ParamByName('CODIGO_EXTERNO').AsString := codigo_externo;
  Open;
  if qrGetMapeamento.RecordCount > 0 then
  begin
    result := qrGetMapeamento.FieldByName('CODIGO').AsString;
  end
  else
  begin
    result := '';
  end;

end;
end;

function TdmConexaoIntegracao.zerarBDRK: Boolean;
begin
with qrZerar do
begin
  Close;
  SQL.Clear;
  SQL.Add('DELETE FROM PRODUTO');
  ExecSQL;
end;
end;

end.
