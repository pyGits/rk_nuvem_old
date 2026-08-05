unit uDmCupom;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Cupom,uServidorCupomController,Vcl.StdCtrls,vcl.Dialogs,Classe.NaoFiscal,Classe.Movimentacao,Classe.Fechamento,Classe.NFCePendente;

type
  TdmCupom = class(TDataModule)
    qrCupomAtualizarPDV: TUniQuery;
    qrCupomItemPesquisar: TUniQuery;
    qrCupomPesquisar: TUniQuery;
    qrCupomFormaPesquisar: TUniQuery;
    qrNaoFiscalPesquisar: TUniQuery;
    qrNaoFiscalAtualizar: TUniQuery;
    qrContasReceberPesquisar: TUniQuery;
    qrEstoqueAtualizar: TUniQuery;
    qrFechamentoPesquisar: TUniQuery;
    qrFechamentoAtualizar: TUniQuery;
    qrFechamentoFinPesquisar: TUniQuery;
    qrBulkInsert: TUniQuery;
  private
    { Private declarations }
  public
    function VerificaPendenciaSubir:Boolean;
    function SincronizarVendaServidor(memoLog:TMemo):Boolean;

    function AtualizarStatusVenda(oCupom:TCupom):Boolean;
    function AtualizarStatusVendaItem(oCupom:TCupom):Boolean;
    function AtualizarStatusVendaForma(oCupom:TCupom):Boolean;
    function AtualizarStatusEstoqueMovimentacao(oMovimentacao:TMovimentacao):Boolean;
    function AtualizarStatusFechamento(oFechamento:TFechamento):boolean;
    function AtualizarStatusFechamentoFin(oFechamentoFin:TFechamentoFin):boolean;

    function AtualizarStatusNaoFiscal(oNaoFiscal:TNaoFiscal):boolean;
    function AtualizarStatusPreVenda(cupom, terminal, prevenda: string):boolean;
    function AtualizarStatusNFCePendente(oNFCePendente:TNFcePendente):Boolean;
    function SincronizarVendasAntigas(dtInicio:TDate;dtFim:TDate):Boolean;

    function CarregarCupom(oCupom:TCupom):Boolean;
    function CarregarCupomItem(oCupom:TCupom):Boolean;
    function CarregarCupomForma(oCupom:TCupom):Boolean;
    function CarregarNaoFiscal(oNaoFiscal:TNaoFiscal):Boolean;
    function CarregarFechamento(oFechamento:TFechamento):Boolean;
    function CarregarFechamentoFinalizadora(oFechamentoFin:TFechamentoFin):Boolean;


    function bulkInsert(script:TStringList):Boolean;

  end;

var
  dmCupom: TdmCupom;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCupom }

function TdmCupom.AtualizarStatusEstoqueMovimentacao(
  oMovimentacao: TMovimentacao): Boolean;
begin
  try
    with qrEstoqueAtualizar do
    begin
      Close;
      SQL.Clear;
      SQl.Add('UPDATE ESTOQUE_MOVIMENTACAO SET EX = 1 WHERE ID = :ID');
      ParamByName('ID').AsInteger := oMovimentacao.ID;
      ExecSQL;

      Result := true;
    end;
  except
  result := false;

  end;
end;

function TdmCupom.AtualizarStatusFechamento(oFechamento: TFechamento): boolean;
begin
with qrFechamentoAtualizar do
begin
  try
    Close;
    SQL.Clear;
    SQL.Add('UPDATE FECHAMENTO SET EX = 1 WHERE CODIGO = :CODIGO');
    ParamByName('CODIGO').AsString := oFechamento.codigo;
    ExecSQL;


    result := true;
  except
    result := false;
  end;
end;
end;

function TdmCupom.AtualizarStatusFechamentoFin(
  oFechamentoFin: TFechamentoFin): boolean;
begin
with qrFechamentoAtualizar do
begin
try
    Close;
    SQL.Clear;
    SQL.Add('UPDATE FECHAMENTO_FINALIZADORA SET EX = 1 WHERE ID_FECHAMENTO = :ID AND FZCOD = :FZCOD');
    ParamByName('ID').AsString := oFechamentoFin.id;
    ParamByName('FZCOD').AsString := oFechamentoFin.finalizadora;
    ExecSQL;
    result :=true;
    except
    result :=false;
end;
end;
end;

function TdmCupom.AtualizarStatusNaoFiscal(oNaoFiscal: TNaoFiscal): boolean;
begin
with qrNaoFiscalAtualizar do
begin
try
  Close;
  SQL.clear;
  SQL.add('UPDATE NAO_FISCAL SET EX = 1 WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').AsString := oNaoFiscal.Codigo;
  ExecSQL;
  result := True;

except
  result := false;
end;





end;
end;

function TdmCupom.AtualizarStatusNFCePendente(oNFCePendente:TNFCePendente): Boolean;
begin
with qrCupomAtualizarPDV do
begin
  Close;
  SQL.clear;
  sql.Add('UPDATE NFCE_PENDENTE SET EX = 1 WHERE CODIGO_CUPOM = :CODIGO_CUPOM');
  ParamByName('CODIGO_CUPOM').AsString := oNFCePendente.codigo_cupom;
  ExecSQL;
end;
end;

function TdmCupom.AtualizarStatusPreVenda(cupom, terminal,
  prevenda: string): boolean;
begin
with qrCupomAtualizarPDV do
begin
  Close;
  SQL.clear;
  sql.Add('UPDATE PREVENDA_FINALIZADO SET EX = 1 WHERE CODIGO = :CODIGO AND TERMINAL = :TERMINAL AND COD_CUPOM = :COD_CUPOM');
  ParamByName('CODIGO').AsString := prevenda;
  ParamByName('COD_CUPOM').AsString := cupom;
  ParamByName('TERMINAL').AsString := terminal;
  ExecSQL;
end;
end;

function TdmCupom.AtualizarStatusVenda(oCupom: TCupom): Boolean;
begin
with qrCupomAtualizarPDV do
begin
  // CUPOM
  Close;
  SQL.clear;
  sql.Add('UPDATE CUPOM SET EX = 1 WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').AsString := oCupom.codigo_cupom;
  ExecSQL;


end;
end;

function TdmCupom.AtualizarStatusVendaForma(oCupom: TCupom): Boolean;
begin
with qrCupomAtualizarPDV do
begin
  // CUPOM FORMA
  Close;
  SQL.clear;
  sql.Add('UPDATE CUPOM_FORMA SET EX = 1 WHERE COD_CUPOM = :CODIGO');
  ParamByName('CODIGO').AsString := oCupom.codigo_cupom;
  ExecSQL;
end;
end;

function TdmCupom.AtualizarStatusVendaItem(oCupom: TCupom): Boolean;
begin
with qrCupomAtualizarPDV do
begin
  // CUPOM ITEM
  Close;
  SQL.clear;
  sql.Add('UPDATE CUPOM_ITEM SET EX = 1 WHERE COD_CUPOM = :CODIGO');
  ParamByName('CODIGO').AsString := oCupom.codigo_cupom;
  ExecSQL;
end;
end;

function TdmCupom.bulkInsert(script: TStringList): Boolean;
var
  line:string;
begin
  for line in script do
  begin
    with qrBulkInsert do
    begin
      Close;
      SQL.Clear;
      SQL.Add(line);
      try
        ExecSQL;
      except

      end;

    end;


  end;
end;

function TdmCupom.CarregarNaoFiscal(oNaoFiscal: TNaoFiscal): Boolean;
begin
with qrNaoFiscalPesquisar do
begin
try
  Close;
  SQL.clear;
  SQL.add('select * from nao_fiscal where codigo = :CODIGO');
  ParamByName('CODIGO').AsString := oNaoFiscal.codigo;
  Open;
  oNaoFiscal.data := FieldByName('DATA').AsDateTime;
  oNaoFiscal.indice := FieldByName('INDICE').AsString;
  oNaoFiscal.Descricao := FieldByName('DESCRICAO').AsString;
  oNaoFiscal.Valor := FieldByName('VALOR').AsFloat;
  oNaoFiscal.Hora := FieldByName('HORA').AsDateTime;
  oNaoFiscal.Vendedor := FieldByName('CODVENDEDOR').AsInteger;
  oNaoFiscal.Finalizadora := FieldByName('FZCOD').AsString;
  oNaoFiscal.caixa := FieldByName('COD_CAIXA').AsInteger;


  Result := true;
except
  result := false;
end;



end;
end;

function TdmCupom.CarregarCupom(oCupom: TCupom): Boolean;
var
  I:integer;


begin
try
  with qrCupomPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.Add('select * from cupom ');
  SQL.Add('where  codigo = :CODIGO ');

  ParamByName('CODIGO').asstring := oCupom.codigo_cupom;
  Open;
  with oCupom do
  begin
  codigo_cupom :=FieldByname('codigo').asstring;
  numero_cupom := FieldByname('numero').asstring;
  data_cupom :=  FieldByname('DATA').AsDateTime;
  hora_cupom := FieldByname('hora').AsDateTime;
  qtd_item_cupom := FieldByname('qtde_item').AsInteger;
  valor_desconto_cupom := FieldByname('valor_desconto').AsFloat;
  valor_acrescimo_cupom := FieldByname('valor_acrescimo').AsFloat;
  valor_total_cupom := FieldByname('valor_total').AsFloat;
  cliente_cupom := FieldByname('COD_CLIENTE').AsInteger;
  cancelado_cupom := FieldByname('CANCELADO').AsInteger;
  Consumidor.CNPJCPF := FieldByname('cpf_consumidor').asstring;
  Consumidor.Nome := FieldByname('nome_consumidor').asstring;
  vendedor_cupom := FieldByname('COD_VENDEDOR').AsInteger;
  caixa_cupom := FieldByname('COD_CAIXA').AsInteger;
  xml_chave_cupom := FieldByname('XML_CHAVE').AsString;
  xml_chave_cancelamento_cupom := FieldByname('XML_CHAVE_CANCELAMENTO').AsString;
  valor_custo_total := FieldByname('VALOR_CUSTO').AsFloat;

  ex_cupom := 0;
  nuvem_cupom := 0;
  end;

  end;

  with qrContasReceberPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from cupom_crediario ');
    SQL.Add('where cod_cupom = :COD_CUPOM');
    ParamByName('COD_CUPOM').asstring := oCupom.codigo_cupom;
    Open;
    I:=1;
    while not qrContasReceberPesquisar.eof do
    begin
      oCupom.ListaContasReceber[I] := TCupomCrediario.create;
      with oCupom.ListaContasReceber[I] do
      begin
        codigo := FieldByName('CODIGO').AsString;
        Data := FieldByName('DATA').AsDateTime;
        Vencimento := FieldByName('VENCIMENTO').AsDateTime;
        Valor := FieldByName('VALOR').AsFloat;
        Cliente := FieldByName('COD_CLIENTE').AsString;
      end;

      Inc(I);
      Next;
    end;


  end;

  result := true;
except
on E:Exception do
begin
  ShowMessage('Erro ao carregar venda do PDV'+ E.message);
end;

end;

end;

function TdmCupom.CarregarCupomForma(oCupom: TCupom): Boolean;
var
  I:integer;
begin
  with qrCupomFormaPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from cupom_forma ');
    SQL.Add('where cod_cupom = :COD_CUPOM');
    ParamByName('COD_CUPOM').asstring := oCupom.codigo_cupom;
    Open;
    I:=1;
    while not qrCupomFormaPesquisar.eof do
    begin
      oCupom.ListaFinalizacao[I] := TCupomForma.create;
      with oCupom.ListaFinalizacao[I] do
      begin
        codigo := FieldByName('CODIGO').asstring;
        forma := FieldByName('FORMA').asstring;
        valor := FieldByName('VALOR').asfloat;
        prestacao := FieldByName('PRESTACAO').AsInteger;
        tipo := FieldByName('TIPO').asstring;
        ex := FieldByName('EX').AsInteger;
        valor_troco := FieldByName('VALOR_TROCO').AsFloat;
        caixa_forma := oCupom.caixa_cupom;
        data_forma := oCupom.data_cupom;
        cancelado := FieldByName('CANCELADO').AsInteger;
      end;

      Inc(I);
      Next;
    end;


  end;
end;

function TdmCupom.CarregarCupomItem(oCupom: TCupom): Boolean;
var
  I:Integer;
begin
  // carrega itens
  with qrCupomItemPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from cupom_item ');
    SQL.Add('where cod_cupom = :CODIGO');
    ParamByName('CODIGO').asstring := oCupom.codigo_cupom;
    Open;
    first;
    I:=1;

    while not qrCupomItemPesquisar.eof do
    begin
      // cria array
      oCupom.ListaItem[I] := TCupomItem.create;
      with oCupom.ListaItem[I] do
      begin
        hora_cupom := FieldByName('HORA').AsDateTime;
        data_item := FieldByname('DATA').AsDateTime;
        codigo_item := FieldByname('CODIGO').AsString;
        item_item := FieldByname('ITEM').AsInteger;
        produto.codigo := FieldByname('COD_PRODUTO').AsString;
        unidade_item := FieldByname('UNIDADE').AsString;
        qtde_item := FieldByname('QTDE').AsFloat;
        valor_unitario_item := FieldByname('VALOR_UNITARIO').AsFloat;
        valor_desconto_item := FieldByname('VALOR_DESCONTO').AsFloat;
        valor_acrescimo_item := FieldByname('VALOR_ACRESCIMO').AsFloat;
        valor_total_item := FieldByname('VALOR_TOTAL').AsFloat;
        valor_movimentacao_item := FieldByName('MOVIMENTACAO').asFloat;
        cancelado_item := FieldByname('CANCELADO').AsInteger;
        valor_custo := FieldByName('VALOR_CUSTO').AsFloat;
        valor_custo_total := FieldByName('VALOR_CUSTO_TOTAL').AsFloat;
        ex_item := FieldByname('EX').AsInteger;
        motivo_cancelamento := FieldByName('MOTIVO_CANCELAMENTO').AsString;
      end;
      Inc(I);
      next;
    end;

  end
end;

function TdmCupom.CarregarFechamento(oFechamento: TFechamento): Boolean;
begin
result := false;
with qrFechamentoPesquisar do
begin
  Close;
  SQl.Clear;
  SQL.Add('SELECT * FROM FECHAMENTO WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').AsString := oFechamento.codigo;
  Open;

  if qrFechamentoPesquisar.RecordCount > 0 then
  begin
  with oFechamento do
  begin
    Codigo := FieldByName('CODIGO').AsString;
    operador := FieldByName('OPERADOR').AsString;
    codOperador := FieldByName('COD_OPERADOR').AsInteger;
    dataAbertura := FieldByName('DATA_ABERTURA').AsDateTime;
    horaAbertura := FieldByName('HORA_ABERTURA').AsDateTime;
    dataFechamento := FieldByName('DATA_FECHAMENTO').AsDateTime;
    horaFechamento := FieldByName('HORA_FECHAMENTO').AsDateTime;
    vendaBruta := FieldByName('VENDA_BRUTA').AsFloat;
    cancelamentoCupom := FieldByName('CANCELAMENTO_CUPOM').AsFloat;
    cancelamentoItem := FieldByName('CANCELAMENTO_ITEM').AsFloat;
    descontoItem:= FieldByName('DESCONTO_ITEM').AsFloat;
    descontoCupom:= FieldByName('DESCONTO_CUPOM').AsFloat;
    acrescimoCupom:= FieldByName('ACRESCIMO_CUPOM').AsFloat;
    vendaLiquida:= FieldByName('VENDA_LIQUIDA').AsFloat;
    fundoCaixa:= FieldByName('FUNDO_CAIXA').AsFloat;
    sangria:= FieldByName('SANGRIA').AsFloat;
    totais:= FieldByName('TOTAIS').AsFloat;
    qtdCuponsEfetivados:= FieldByName('QTD_CUPONS_EFETIVADOS').AsInteger;
    qtdCuponsCancelados:= FieldByName('QTD_CUPONS_CANCELADOS').AsInteger;
    codCaixa:= FieldByName('COD_CAIXA').AsInteger;
    result := true;


  end;
  end;

end;
end;

function TdmCupom.CarregarFechamentoFinalizadora(
  oFechamentoFin: TFechamentoFin): Boolean;
begin
  with qrFechamentoFinPesquisar do
  begin
  Close;
  SQl.Clear;
  SQL.Add('SELECT * FROM FECHAMENTO_FINALIZADORA WHERE ID_FECHAMENTO = :ID_FECHAMENTO AND FZCOD=:FZCOD');
  ParamByName('ID_FECHAMENTO').AsString := oFechamentoFin.id;
  ParamByName('FZCOD').AsString := oFechamentoFin.Finalizadora;

  Open;
    if qrFechamentoFinPesquisar.RecordCount > 0 then
    begin

        oFechamentoFin.id :=FieldByName('ID_FECHAMENTO').AsString;
        oFechamentoFin.Finalizadora :=FieldByName('FZCOD').AsString;
        oFechamentoFin.valorLiquido :=FieldByName('VALOR_LIQUIDO').AsFloat;
        oFechamentoFin.valorEntrada :=FieldByName('VALOR_ENTRADA').asfloat;
        oFechamentoFin.valorTroco :=FieldByName('VALOR_TROCO').asfloat;
        oFechamentoFin.valorReforco :=FieldByName('VALOR_REFORCO').asfloat;
        oFechamentoFin.valorSangria :=FieldByName('VALOR_SANGRIA').asfloat;
        oFechamentoFin.valorConferencia :=FieldByName('VALOR_CONFERENCIA').asfloat;
        oFechamentoFin.codCaixa :=FieldByName('COD_CAIXA').AsInteger;

    end;
  end;
end;

function TdmCupom.SincronizarVendasAntigas(dtInicio, dtFim: TDate): Boolean;
begin
with qrCupomAtualizarPDV do
begin
  // CUPOM
  Close;
  SQL.clear;
  sql.Add('UPDATE CUPOM SET EX = 0 WHERE DATA>= :DTINICIO AND DATA <= :DTFIM');
  ParamByName('DTINICIO').AsDate := dtInicio;
  ParamByName('DTFIM').AsDate := dtFim;
  try
  ExecSQL;
  result := true;
  except
  result := false;

  end;

end;
end;

function TdmCupom.SincronizarVendaServidor(memoLog:TMemo): Boolean;
var
  oCupom:TCupom;
  oCupomItem:TCupomItem;
  oCupomForma:TCupomForma;
  oCupomServidorController:TServidorCupomController;
  oNaoFiscal:TNaoFiscal;
  oMovimentacao:TMovimentacao;
  oFechamento:TFechamento;
  oFechamentoFin:TFechamentoFin;
  oNFCePendente:TNFCePendente;
  i:integer;
begin
try
  with qrCupomPesquisar do
  begin
      oCupomServidorController := TServidorCupomController.create;
  // CUPOM
  Close;
  SQl.clear;
  SQL.Add('select * from cupom where ex = 0');
  Open;
    while not qrCupomPesquisar.eof do
    begin
      memoLog.Lines.Add('Sincronizando venda Nº: '+FieldByName('Numero').AsString+' '+TimeToStr(Time()));

      oCupom := TCupom.create;

      oCupom.codigo_cupom := FieldByName('CODIGO').AsString;
      CarregarCupom(oCupom);


      if oCupomServidorController.InserirCupomServidor(oCupom) then
      begin
        if AtualizarStatusVenda(oCupom) then
        begin
        qrCupomPesquisar.Next;
        end;
      end;



      oCupom.Destroy;
    end;


    // item cupom
      Close;
      SQl.clear;
      SQL.Add('select * from cupom_item where ex = 0');
      Open;
    while not qrCupomPesquisar.eof do
    begin
      oCupomItem := TCupomItem.create;
      with oCupomItem, qrCupomPesquisar do
      begin
        codigo_cupom := FieldByName('COD_CUPOM').AsString;
        hora_cupom := FieldByName('HORA').AsDateTime;
        data_item := FieldByname('DATA').AsDateTime;
        codigo_item := FieldByname('CODIGO').AsString;
        item_item := FieldByname('ITEM').AsInteger;
        produto.codigo := FieldByname('COD_PRODUTO').AsString;
        unidade_item := FieldByname('UNIDADE').AsString;
        qtde_item := FieldByname('QTDE').AsFloat;
        valor_unitario_item := FieldByname('VALOR_UNITARIO').AsFloat;
        valor_desconto_item := FieldByname('VALOR_DESCONTO').AsFloat;
        valor_acrescimo_item := FieldByname('VALOR_ACRESCIMO').AsFloat;
        valor_total_item := FieldByname('VALOR_TOTAL').AsFloat;
        valor_movimentacao_item := FieldByName('MOVIMENTACAO').asFloat;
        cancelado_item := FieldByname('CANCELADO').AsInteger;
        valor_custo := FieldByName('VALOR_CUSTO').AsFloat;
        valor_custo_total := FieldByName('VALOR_CUSTO_TOTAL').AsFloat;
        ex_item := FieldByname('EX').AsInteger;
        caixa_cupom := FieldByName('COD_CAIXA').AsInteger;
        motivo_cancelamento := FieldByName('MOTIVO_CANCELAMENTO').AsString;
        oCupomServidorController.InserirCupomItemServidor(oCupomItem);

        qrCupomAtualizarPDV.Close;
        qrCupomAtualizarPDV.SQL.clear;
        qrCupomAtualizarPDV.sql.Add('UPDATE CUPOM_ITEM SET EX = 1 WHERE CODIGO = :CODIGO');
        qrCupomAtualizarPDV.ParamByName('CODIGO').AsString := oCupomItem.codigo_item;
        qrCupomAtualizarPDV.ExecSQL;
        memoLog.Lines.Add('Sincronizando item venda: '+ FieldByName('CODIGO').asstring);

      end;
      qrCupomPesquisar.Next;
    end;

    // forma cupom
      Close;
      SQl.clear;
      SQL.Add('select * from cupom_forma where ex = 0');
      Open;
      while not qrCupomPesquisar.eof do
    begin
      memoLog.Lines.Add('Sincronizando venda Finalização Nº: '+FieldByName('COD_CUPOM').AsString+' '+TimeToStr(Time()));

      oCupomForma := TCupomForma.create;
      oCupomForma.codigo := FieldByName('CODIGO').asstring;
      oCupomForma.codigo_cupom := FieldByName('COD_CUPOM').AsString;
      oCupomForma.forma := FieldByName('FORMA').asstring;
      oCupomForma.valor := FieldByName('VALOR').asfloat;
      oCupomForma.prestacao := FieldByName('PRESTACAO').AsInteger;
      oCupomForma.tipo := FieldByName('TIPO').asstring;
      oCupomForma.ex := FieldByName('EX').AsInteger;
      oCupomForma.valor_troco := FieldByName('VALOR_TROCO').AsFloat;
      oCupomForma.caixa_forma := FieldByName('COD_CAIXA').AsInteger;
      oCupomForma.data_forma := FieldByName('DATA').AsDateTime;
      oCupomForma.cancelado := FieldByName('CANCELADO').AsInteger;
      oCupomServidorController.InserirCupomFormaServidor(oCupomForma);

      qrCupomAtualizarPDV.Close;
      qrCupomAtualizarPDV.SQL.clear;
      qrCupomAtualizarPDV.sql.Add('UPDATE CUPOM_FORMA SET EX = 1 WHERE CODIGO = :CODIGO');
      qrCupomAtualizarPDV.ParamByName('CODIGO').AsString := qrCupomPesquisar.FieldByName('CODIGO').asstring;
      qrCupomAtualizarPDV.ExecSQL;
      qrCupomPesquisar.Next;

    end;

    Close;
    SQl.clear;
    SQL.Add('select * from fechamento where ex = 0');
    Open;
      while not qrCupomPesquisar.eof do
    begin
      memoLog.Lines.Add('Sincronizando venda Fechamento Nº: '+FieldByName('CODIGO').AsString+' '+TimeToStr(Time()));

      oFechamento := TFechamento.create;
      oFechamento.codigo := FieldByName('CODIGO').AsString;

      CarregarFechamento(oFechamento);


      if oCupomServidorController.InserirFechamento(oFechamento) then
      begin
        if AtualizarStatusFechamento(oFechamento) then
        begin
        qrCupomPesquisar.Next;
        end;
      end;



      oFechamento.Destroy;
    end;


    Close;
    SQL.Clear;
    SQl.Add('SELECT * FROM FECHAMENTO_FINALIZADORA WHERE EX = 0');
    Open;
    while not qrCupomPesquisar.Eof do
    begin
      memoLog.Lines.Add('Sincronizando venda Fechamento Finalizadora Nº: '+FieldByName('ID_FECHAMENTO').AsString+' '+TimeToStr(Time()));

      oFechamentoFin := TFechamentoFin.create;
      oFechamentoFin.id := FieldByName('ID_FECHAMENTO').AsString;
      oFechamentoFin.Finalizadora := FieldByName('FZCOD').AsString;

      CarregarFechamentoFinalizadora(oFechamentoFin);


      if oCupomServidorController.InserirFechamentoFin(oFechamentoFin) then
      begin
        if AtualizarStatusFechamentoFin(oFechamentoFin) then
        begin
        qrCupomPesquisar.Next;
        end;
      end;



      oFechamentoFin.Destroy;

    end;


    Close;
    SQL.Clear;
    SQL.Add('select * from estoque_movimentacao where ex = 0');
    Open;
    while not qrCupomPesquisar.eof do
    begin
      try
        oMovimentacao := TMovimentacao.Create;
        oMovimentacao.ID := FieldByName('ID').AsInteger;
        oMovimentacao.qtde := FieldByName('QTDE').AsFloat;
        oMovimentacao.data := FieldByName('data').AsDateTime;
        oMovimentacao.hora := FieldByName('hora').AsDateTime;
        oMovimentacao.codproduto := FieldByName('CODPRODUTO').asstring;
        oMovimentacao.nCupom := FieldByName('COD_CUPOM').AsString;
        oMovimentacao.item := FieldByName('ITEM').AsInteger;
        oMovimentacao.funcionario := FieldByName('COD_FUNCIONARIO').AsString;
        oMovimentacao.origem := FieldByName('ORIGEM').AsString;
        oMovimentacao.caixa := FieldByName('COD_CAIXA').AsInteger;

        if oCupomServidorController.inserirEstoqueMovimentacao(oMovimentacao) then
        begin
          AtualizarStatusEstoqueMovimentacao(oMovimentacao);
        end;
      finally
        oMovimentacao.Destroy;
      end;
      qrCupomPesquisar.Next;
    end;




  // OP NÃO FISCAL
  Close;
  SQL.clear;
  sql.add('SELECT * FROM NAO_FISCAL WHERE EX = 0');
  Open;

    while not qrCupomPesquisar.Eof do
    begin
      memoLog.Lines.Add('Sincronizando operação cód: '+FieldByName('CODIGO').AsString);
      oNaoFiscal := TNaoFiscal.Create;
      oNaoFiscal.codigo := FieldByName('CODIGO').asstring;
      CarregarNaoFiscal(oNaoFiscal);
      if oCupomServidorController.InserirNaoFiscalServidor(oNaoFiscal) then
      begin
        AtualizarStatusNaoFiscal(oNaoFiscal);
        qrCupomPesquisar.Next;
      end;





      oNaoFiscal.Destroy;

    end;


    // PRE VENDA
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PREVENDA_FINALIZADO WHERE EX = 0');
    Open;
    while not qrCupomPesquisar.Eof do
    begin
      oCupomServidorController.AtualizarPreVendaServidor(qrCupomPesquisar.FieldByName('COD_CUPOM').AsString,qrCupomPesquisar.FieldByName('TERMINAL').AsString,qrCupomPesquisar.FieldByName('CODIGO').AsString);
      AtualizarStatusPreVenda(qrCupomPesquisar.FieldByName('COD_CUPOM').AsString,qrCupomPesquisar.FieldByName('TERMINAL').AsString,qrCupomPesquisar.FieldByName('CODIGO').AsString);
      qrCupomPesquisar.Next;
    end;


    close;
    sql.Clear;
    SQL.Add('select * from nfce_pendente where ex =0');
    Open;
    while not qrCupomPesquisar.Eof do
    begin
      oNFCePendente := TNFCePendente.Create;
      oNFCePendente.codigo_cupom := qrCupomPesquisar.FieldByName('CODIGO_CUPOM').AsString;
      oNFCePendente.cod_caixa := qrCupomPesquisar.FieldByName('COD_CAIXA').asinteger;
      oNFCePendente.data := qrCupomPesquisar.FieldByName('DATA').AsDateTime;
      oNFCePendente.hora := qrCupomPesquisar.FieldByName('HORA').AsDateTime;
      oNFCePendente.xml := qrCupomPesquisar.FieldByName('XML').AsString;
      oNFCePendente.status := qrCupomPesquisar.FieldByName('STATUS').AsString;
      oNFCePendente.chave := qrCupomPesquisar.FieldByName('CHAVE').AsString;
      oNFCePendente.total := qrCupomPesquisar.FieldByName('TOTAL').AsFloat;

      if oCupomServidorController.InserirNFCePendente(oNFCePendente) then
      begin
      atualizarStatusNFCePendente(oNFCePendente);
      end;

      oNFCePendente.Free;
      qrCupomPesquisar.Next;




    end;
  end;


      oCupomServidorController.Destroy;

except
On E:Exception do 
begin
  raise Exception.Create('Erro ao carregar venda PDV'+E.message);
end;

end;
end;

function TdmCupom.VerificaPendenciaSubir: Boolean;
begin
try
  with qrCupomPesquisar do
  begin
    Close;
    SQL.clear;
    SQL.add('select * from cupom where ex = 0');
    Open;
    if RecordCount > 0 then
    begin
    result := true;
    end
    else
    begin
    Result := false;
    end;

  end;
  except
  on E:Exception do
  begin
  raise Exception.Create('Erro ao verificar pendencia');
  Result := false;
  end;


end;
end;

end.
