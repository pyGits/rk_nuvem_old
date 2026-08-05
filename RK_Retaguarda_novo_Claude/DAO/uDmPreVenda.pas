unit uDmPreVenda;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Prevenda,System.Generics.collections;

type
  TdmPreVenda = class(TDataModule)
    qrPreVendaItemTempInserir: TUniQuery;
    qrPreVendaItemTempGrid: TUniQuery;
    qrPreVendaItemTempGridCODIGO_PREVENDA: TStringField;
    qrPreVendaItemTempGridITEM: TIntegerField;
    qrPreVendaItemTempGridCODIGO_BARRAS: TStringField;
    qrPreVendaItemTempGridVALOR_UNITARIO: TFloatField;
    qrPreVendaItemTempGridVALOR_DESCONTO: TFloatField;
    qrPreVendaItemTempGridVALOR_ACRESCIMO: TFloatField;
    qrPreVendaItemTempGridVALOR_TOTAL: TFloatField;
    qrPreVendaItemTempGridQTDE: TFloatField;
    qrPreVendaItemTempGridUNIDADE: TStringField;
    qrProduto: TUniQuery;
    qrProdutoCODIGO: TStringField;
    qrProdutoCODIGO_BARRAS: TStringField;
    qrProdutoDESCRICAO: TStringField;
    qrProdutoGRUPO: TStringField;
    qrProdutoSUBGRUPO: TStringField;
    qrProdutoFORNECEDOR: TStringField;
    qrProdutoTRIBUTACAO: TStringField;
    qrProdutoNCM: TStringField;
    qrProdutoCEST: TStringField;
    qrProdutoVALIDADE: TStringField;
    qrProdutoBALANCA: TIntegerField;
    qrProdutoFRACIONADO: TIntegerField;
    qrProdutoCUSTO: TFloatField;
    qrProdutoPRECO: TFloatField;
    qrProdutoMARGEM: TFloatField;
    qrProdutoESTOQUE: TFloatField;
    qrProdutoUNIDADE: TStringField;
    qrProdutoINATIVO: TIntegerField;
    qrProdutoDIVERSOS: TIntegerField;
    qrProdutoDATA_CADASTRO: TDateField;
    qrProdutoDATA_ALTERADO: TDateField;
    qrProdutoPENDENTE: TIntegerField;
    qrProdutoOBSERVACAO: TStringField;
    qrPreVendaItemTempGridPRODUTO: TStringField;
    qrPreVendaItemTempDeletar: TUniQuery;
    qrPreVendaInserir: TUniQuery;
    qrPreVendaItemTempPesq: TUniQuery;
    qrPreVendaItemInserir: TUniQuery;
    qrPreVendaPesquisar: TUniQuery;
    qrPreVendaItemPesq: TUniQuery;
    qrPreVendaDeletar: TUniQuery;
    qrPreVendaGrid: TUniQuery;
    qrCliente: TUniQuery;
    qrClienteCODIGO: TStringField;
    qrClienteNOME: TStringField;
    qrClienteNOME_FANTASIA: TStringField;
    qrClienteENDERECO: TStringField;
    qrClienteNUMERO: TStringField;
    qrClienteBAIRRO: TStringField;
    qrClienteCIDADE: TStringField;
    qrClienteUF: TStringField;
    qrClienteCEP: TStringField;
    qrClienteCOMPLEMENTO: TStringField;
    qrClienteTELEFONE1: TStringField;
    qrClienteTELEFONE2: TStringField;
    qrClienteCELULAR: TStringField;
    qrClienteEMAIL: TStringField;
    qrClienteCNPJCPF: TStringField;
    qrClienteOBSERVACAO: TMemoField;
    qrClienteDATA_CADASTRO: TDateField;
    qrClienteTIPO_PESSOA: TIntegerField;
    qrClienteCREDITO_LIMITE: TFloatField;
    qrClienteCREDITO_UTILIZADO: TFloatField;
    qrPreVendaGridCODIGO: TStringField;
    qrPreVendaGridCOD_CUPOM: TStringField;
    qrPreVendaGridFUNCIONARIO: TStringField;
    qrPreVendaGridDATA: TDateTimeField;
    qrPreVendaGridCOD_CLIENTE: TStringField;
    qrPreVendaGridVALOR_DESCONTO: TFloatField;
    qrPreVendaGridVALOR_ACRESCIMO: TFloatField;
    qrPreVendaGridVALOR_TOTAL: TFloatField;
    qrPreVendaGridTERMINAL: TStringField;
    qrPreVendaGridCANCELADO: TIntegerField;
    qrPreVendaGridSTATUS: TStringField;
    qrPreVendaGridCLIENTE: TStringField;
  private
    { Private declarations }
  public
    function CarregarGridPreVenda(dtInicio,dtFim:TDate;ds:TDatasource):boolean;
    function CarregarPreVendaTela(oPreVenda:TPrevenda):Boolean;
  // pre venda raiz
    function CarregarPreVenda(oPrevenda:TPrevenda):boolean;
    function InserirPrevenda(oPrevenda:TPrevenda):Boolean;
    function DeletarPreVenda(oPrevenda:TPrevenda):boolean;
    function InserirPrevendaItem(oPrevendaItem:TPrevendaItem):Boolean;

    // temp
    function InserirPrevendaTemp(oPrevenda:TPrevenda):Boolean;
    function InserirPreVendaItemTemp(oPreVendaItem:TPrevendaItem):boolean;
    function DeletarPreVendaItemTemp:boolean;


    // grid
    function CarregarItensPreVenda(ds:TDataSource):Boolean;

  end;

var
  dmPreVenda: TdmPreVenda;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmPreVenda }

function TdmPreVenda.CarregarGridPreVenda(dtInicio, dtFim: TDate;
  ds: TDatasource): boolean;
begin

ds.DataSet := qrPreVendaGrid;
with qrPreVendaGrid do
begin
  qrCliente.Close;
  qrCliente.Open;
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM PREVENDA WHERE DATA >= :DTINICIO AND DATA <= :DTFIM AND STATUS = :STATUS');
  ParamByName('DTINICIO').AsDate := dtInicio;
  ParamByName('DTFIM').AsDate := dtFim;
  ParamByName('STATUS').AsString := 'A';
  Open;

end;
end;

function TdmPreVenda.CarregarItensPreVenda(ds: TDataSource): Boolean;
begin
ds.DataSet := qrPreVendaItemTempGrid;
qrPreVendaItemTempGrid.Close;
qrPreVendaItemTempGrid.Open;

end;

function TdmPreVenda.CarregarPreVenda(oPrevenda: TPrevenda): boolean;
begin
with qrPreVendaPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM PREVENDA WHERE CODIGO = :CODIGO AND TERMINAL = :TERMINAL AND STATUS = :STATUS');
  ParamByName('CODIGO').AsString := oPrevenda.codigo;
  ParamByName('TERMINAL').AsString := oPrevenda.terminal;
  ParamByName('STATUS').AsString := 'A';
 try
  Open;
  if qrPreVendaPesquisar.RecordCount > 0 then
  begin

  oPrevenda.codigo := FieldByName('CODIGO').AsString;
  oPrevenda.codigoCupom := FieldByName('COD_CUPOM').AsString;
  oPrevenda.funcionario := FieldByName('FUNCIONARIO').AsString;
  oPrevenda.data := FieldByName('DATA').AsDateTime;
  oPrevenda.cliente := FieldByName('COD_CLIENTE').AsString;
  oPrevenda.valorTotal := FieldByName('VALOR_TOTAL').AsFloat;
  oPrevenda.cancelado := FieldByName('CANCELADO').AsInteger;
  oPrevenda.status := FieldByName('STATUS').AsString;
  oPrevenda.terminal := FieldByName('TERMINAL').AsString;

    qrPreVendaItemPesq.Close;
    qrPreVendaItemPesq.SQL.Clear;
    qrPreVendaItemPesq.SQL.Add('SELECT * FROM PREVENDA_ITEM LEFT JOIN PRODUTO ON PREVENDA_ITEM.CODIGO_BARRAS = PRODUTO.CODIGO_BARRAS WHERE CODIGO_PREVENDA = :CODIGO_PREVENDA AND TERMINAL =:TERMINAL');
    qrPreVendaItemPesq.ParamByName('CODIGO_PREVENDA').AsString := oPreVenda.codigo;
    qrPreVendaItemPesq.ParamByName('TERMINAL').AsString := oPreVenda.terminal;
    qrPreVendaItemPesq.Open;
    oPrevenda.items := TObjectList<TPrevendaItem>.create;
    if qrPreVendaItemPesq.RecordCount > 0 then
    begin
      while not qrPreVendaItemPesq.eof do
      begin
        oPrevenda.items.Add(TPrevendaItem.Create);
        oPrevenda.items.Last.codigoPrevenda := qrPreVendaItemPesq.FieldByName('CODIGO_PREVENDA').AsString;
        oPrevenda.items.Last.Item := qrPreVendaItemPesq.FieldByName('ITEM').AsInteger;
        oPrevenda.items.Last.codigo_barras := qrPreVendaItemPesq.FieldByName('CODIGO_BARRAS').AsString;
        oPrevenda.items.Last.valorUnitario := qrPreVendaItemPesq.FieldByName('VALOR_UNITARIO').AsFloat;
        oPrevenda.items.Last.valorDesconto := qrPreVendaItemPesq.FieldByName('VALOR_DESCONTO').AsFloat;
        oPrevenda.items.Last.valorAcrescimo := qrPreVendaItemPesq.FieldByName('VALOR_ACRESCIMO').AsFloat;
        oPrevenda.items.Last.valorTotal := qrPreVendaItemPesq.FieldByName('VALOR_TOTAL').AsFloat;
        oPrevenda.items.Last.qtde := qrPreVendaItemPesq.FieldByName('QTDE').AsFloat;
        oPrevenda.items.Last.unidade := qrPreVendaItemPesq.FieldByName('UNIDADE').AsString;
        oPrevenda.items.Last.terminal := qrPreVendaItemPesq.FieldByName('TERMINAL').AsString;
        oPrevenda.items.Last.produto.Descricao := qrPreVendaItemPesq.FieldByName('DESCRICAO').AsString;
        oPrevenda.items.Last.produto.Unidade := qrPreVendaItemPesq.FieldByName('UNIDADE').AsString;

        qrPreVendaItemPesq.Next;
      end;
    end;

  Result := true;




  end
  else
  begin
    Result := false;
  end;

 except
 on E:Exception do
 begin
 raise Exception.Create(e.message);
  result := false;
 end;

 end;
end;
end;

function TdmPreVenda.CarregarPreVendaTela(oPreVenda: TPrevenda): Boolean;
var
  oPreVendaItem:TPrevendaItem;
begin
 CarregarPreVenda(oPreVenda);
 // carregar itens

 with oPreVenda,qrPreVendaItemPesq do
 begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PREVENDA_ITEM WHERE CODIGO_PREVENDA = :CODIGO_PREVENDA AND TERMINAL =:TERMINAL');
    ParamByName('CODIGO_PREVENDA').AsString := oPreVenda.codigo;
    ParamByName('TERMINAL').AsString := oPreVenda.terminal;
    Open;
    if qrPreVendaItemPesq.RecordCount > 0 then
    begin
      while not qrPreVendaItemPesq.eof do
      begin
        oPreVendaItem := TPrevendaItem.Create;
        oPreVendaItem.codigoPrevenda := FieldByName('CODIGO_PREVENDA').AsString;
        oPreVendaItem.Item := FieldByName('ITEM').AsInteger;
        oPreVendaItem.codigo_barras := FieldByName('CODIGO_BARRAS').AsString;
        oPreVendaItem.valorUnitario := FieldByName('VALOR_UNITARIO').AsFloat;
        oPreVendaItem.valorDesconto := FieldByName('VALOR_DESCONTO').AsFloat;
        oPreVendaItem.valorAcrescimo := FieldByName('VALOR_ACRESCIMO').AsFloat;
        oPreVendaItem.valorTotal := FieldByName('VALOR_TOTAL').AsFloat;
        oPreVendaItem.qtde := FieldByName('QTDE').AsFloat;
        oPreVendaItem.unidade := FieldByName('UNIDADE').AsString;
        oPreVendaItem.terminal := FieldByName('TERMINAL').AsString;


        InserirPreVendaItemTemp(oPreVendaItem);
        qrPreVendaItemPesq.Next;

        oPreVendaItem.Destroy;
      end;


    result := True;
    end
    else
    begin
      result := false;
    end;
 end;

end;

function TdmPreVenda.DeletarPreVenda(oPrevenda: TPrevenda): boolean;
begin
with qrPreVendaDeletar do
begin
  Close;
  SQL.Clear;
  SQL.Add('DELETE FROM PREVENDA WHERE CODIGO = :CODIGO AND TERMINAL = :TERMINAL');
  ParamByName('CODIGO').AsString := oPrevenda.codigo;
  ParamByName('TERMINAL').AsString := oPrevenda.terminal;
  ExecSQL;
  // item
  Close;
  SQL.Clear;
  SQL.Add('DELETE FROM PREVENDA_ITEM WHERE CODIGO_PREVENDA = :CODIGO AND TERMINAL = :TERMINAL');
  ParamByName('CODIGO').AsString := oPrevenda.codigo;
  ParamByName('TERMINAL').AsString := oPrevenda.terminal;
  ExecSQL;
end;
end;

function TdmPreVenda.DeletarPreVendaItemTemp: boolean;
begin
with qrPreVendaItemTempDeletar do
begin
  Close;
  SQL.Clear;
  SQL.ADD('DELETE FROM PREVENDA_ITEM_TEMP');
  ExecSQL;
end;
end;

function TdmPreVenda.InserirPrevenda(oPrevenda: TPrevenda): Boolean;
var
  oPreVendaItem :TPrevendaItem;
begin
DeletarPreVenda(oPrevenda);
with qrPreVendaInserir do
begin
  Close;
  SQL.Clear;
  SQL.add('update or insert into PREVENDA (CODIGO, COD_CUPOM, FUNCIONARIO, DATA, COD_CLIENTE, VALOR_DESCONTO, VALOR_ACRESCIMO, VALOR_TOTAL, ');
  SQL.add('TERMINAL, CANCELADO, STATUS) ');
  SQL.add('values (:CODIGO, :COD_CUPOM, :FUNCIONARIO, :DATA, :COD_CLIENTE, :VALOR_DESCONTO, :VALOR_ACRESCIMO, :VALOR_TOTAL, ');
  SQL.add(':TERMINAL, :CANCELADO, :STATUS)  ');

  ParamByName('CODIGO').AsString := oPrevenda.codigo;
  ParamByName('COD_CUPOM').AsString := oPrevenda.codigoCupom;
  ParamByName('FUNCIONARIO').AsString := oPrevenda.funcionario;
  ParamByName('DATA').AsDate := oPrevenda.data;
  ParamByName('COD_CLIENTE').AsString := oPrevenda.cliente;
  ParamByName('VALOR_DESCONTO').AsFloat := oPrevenda.valorDesconto;
  ParamByName('VALOR_ACRESCIMO').AsFloat := oPrevenda.valorAcrescimo;
  ParamByName('VALOR_TOTAL').AsFloat := oPrevenda.valorTotal;
  ParamByName('TERMINAL').AsString := oPrevenda.terminal;
  ParamByName('CANCELADO').AsInteger := oPrevenda.cancelado;
  ParamByName('STATUS').AsString := oPrevenda.status;
  ExecSQL;

  // inserir itens

  with qrPreVendaItemTempPesq do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PREVENDA_ITEM_TEMP WHERE CODIGO_PREVENDA = :CODIGO_PREVENDA AND TERMINAL = :TERMINAL');
    ParamByName('CODIGO_PREVENDA').AsString :=oPrevenda.codigo;
    ParamByName('TERMINAL').AsString :=oPrevenda.terminal;
    Open;
    if qrPreVendaItemTempPesq.RecordCount = 0 then
    begin
      raise Exception.Create('Nenhum item adicionado na pré venda !');
    end;
    

    while not qrPreVendaItemTempPesq.Eof do
    begin
    oPreVendaItem := TPrevendaItem.Create;
    oPreVendaItem.codigoPrevenda := FieldByName('CODIGO_PREVENDA').AsString;
    oPreVendaItem.item :=       FieldByName('ITEM').AsInteger;
    oPreVendaItem.codigo_barras :=    FieldByName('CODIGO_BARRAS').AsString;
    oPreVendaItem.valorUnitario:=    FieldByName('VALOR_UNITARIO').AsFloat;
    oPreVendaItem.valorDesconto:=   FieldByName('VALOR_DESCONTO').AsFloat;
    oPreVendaItem.valorAcrescimo:=   FieldByName('VALOR_ACRESCIMO').AsFloat;
    oPreVendaItem.valorTotal:=   FieldByName('VALOR_TOTAL').AsFloat;
    oPreVendaItem.qtde:=   FieldByName('QTDE').AsFloat;
    oPreVendaItem.unidade:=      FieldByName('UNIDADE').AsString;
    oPreVendaItem.terminal:=    FieldByName('TERMINAL').AsString;
    InserirPrevendaItem(oPreVendaItem);

    oPreVendaItem.Destroy;

    qrPreVendaItemTempPesq.Next;
    end;
  end;
end;
end;

function TdmPreVenda.InserirPrevendaItem(oPrevendaItem: TPrevendaItem): Boolean;
begin
with qrPreVendaItemInserir do
begin
  ParamByName('CODIGO_PREVENDA').AsString := oPreVendaItem.codigoPrevenda;
  ParamByName('ITEM').AsInteger := oPreVendaItem.item;
  ParamByName('CODIGO_BARRAS').AsString := oPreVendaItem.codigo_barras;
  ParamByName('VALOR_UNITARIO').AsFloat := oPreVendaItem.valorUnitario;
  ParamByName('VALOR_DESCONTO').AsFloat := oPreVendaItem.valorDesconto;
  ParamByName('VALOR_ACRESCIMO').AsFloat := oPreVendaItem.valorAcrescimo;
  ParamByName('VALOR_TOTAL').AsFloat := oPreVendaItem.valorTotal;
  ParamByName('QTDE').AsFloat := oPreVendaItem.qtde;
  ParamByName('UNIDADE').AsString := oPreVendaItem.unidade;
  ParamByName('TERMINAL').AsString := oPreVendaItem.terminal;

  ExecSQL;
end;
end;

function TdmPreVenda.InserirPreVendaItemTemp(
  oPreVendaItem: TPrevendaItem): boolean;
begin
with qrPreVendaItemTempInserir do
begin
  Close;
  SQL.Clear;
  SQL.add('insert into PREVENDA_ITEM_TEMP (CODIGO_PREVENDA,  ITEM, CODIGO_BARRAS, VALOR_UNITARIO, VALOR_DESCONTO, ');
  SQL.add('VALOR_ACRESCIMO, VALOR_TOTAL, QTDE, UNIDADE, TERMINAL) ');
  SQL.add('values (:CODIGO_PREVENDA,  :ITEM, :CODIGO_BARRAS, :VALOR_UNITARIO, :VALOR_DESCONTO, :VALOR_ACRESCIMO, ');
  SQL.add(':VALOR_TOTAL, :QTDE, :UNIDADE, :TERMINAL)  ');

  ParamByName('CODIGO_PREVENDA').AsString := oPreVendaItem.codigoPrevenda;
  ParamByName('ITEM').AsInteger := oPreVendaItem.item;
  ParamByName('CODIGO_BARRAS').AsString := oPreVendaItem.codigo_barras;
  ParamByName('VALOR_UNITARIO').AsFloat := oPreVendaItem.valorUnitario;
  ParamByName('VALOR_DESCONTO').AsFloat := oPreVendaItem.valorDesconto;
  ParamByName('VALOR_ACRESCIMO').AsFloat := oPreVendaItem.valorAcrescimo;
  ParamByName('VALOR_TOTAL').AsFloat := oPreVendaItem.valorTotal;
  ParamByName('QTDE').AsFloat := oPreVendaItem.qtde;
  ParamByName('UNIDADE').AsString := oPreVendaItem.unidade;
  ParamByName('TERMINAL').AsString := oPreVendaItem.terminal;

  ExecSQL;
end;

end;

function TdmPreVenda.InserirPrevendaTemp(oPrevenda: TPrevenda): Boolean;
begin
//with qrPreVendaTempInserir do
//begin
//  Close;
//  SQL.Clear;
//  SQL.Add('INSERT INTO PREVENDA_TEMP (CODIGO,FUNCIONARIO,DATA,COD_CLIENTE,TERMINAL)');
//  SQL.Add('VALUES (:CODIGO,:FUNCIONARIO,:DATA,:COD_CLIENTE,:TERMINAL)');
//
//  ExecSQL;
//end;
end;

end.

