unit uDmCupomServidor;

interface

uses
  System.SysUtils, System.Classes,uDmConexaoServer, Data.DB, MemDS, DBAccess,
  Uni,Classe.Cupom,VCL.Dialogs,Classe.NaoFiscal,Classe.Movimentacao,Classe.Fechamento,Classe.NFCePendente;

type
  TdmCupomServidor = class(TDataModule)
    qrCupomServidorPesquisar: TUniQuery;
    spCupom: TUniStoredProc;
    spCupom_Item: TUniStoredProc;
    spCupom_Forma: TUniStoredProc;
    spNao_Fiscal: TUniStoredProc;
    spEstoque_Movimentacao: TUniStoredProc;
    spContas_Receber: TUniStoredProc;
    qrPrevendaServidorAtualizar: TUniQuery;
    qrEnviado: TUniQuery;
    qrFechamentoInserir: TUniQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    DateField1: TDateField;
    TimeField1: TTimeField;
    DateField2: TDateField;
    TimeField2: TTimeField;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    FloatField4: TFloatField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    FloatField9: TFloatField;
    FloatField10: TFloatField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    qrFechamentoFinalizadoraInserir: TUniQuery;
    StringField3: TStringField;
    StringField4: TStringField;
    DateField3: TDateField;
    TimeField3: TTimeField;
    DateField4: TDateField;
    TimeField4: TTimeField;
    FloatField11: TFloatField;
    FloatField12: TFloatField;
    FloatField13: TFloatField;
    FloatField14: TFloatField;
    FloatField15: TFloatField;
    FloatField16: TFloatField;
    FloatField17: TFloatField;
    FloatField18: TFloatField;
    FloatField19: TFloatField;
    FloatField20: TFloatField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    qrNFCePendenteInserir: TUniQuery;
  private
  public
    function InserirFechamentoServidor(oFechamento:TFechamento):Boolean;
    function InserirFechamentoFinServidor(oFechamentoFin:TFechamentoFin):boolean;
    function InserirCupomServidor(oCupom:TCupom):Boolean;
    function InserirCupomItemServidor(oCupomItem:TCupomItem):Boolean;
    function InserirCupomFormaServidor(oCupomForma:TCupomForma):Boolean;
    function InserirEstoqueMovimentacao(oMovimentacao:TMovimentacao):Boolean;
    function InserirNFCePendente(oNFCePendente:TNFCePendente):Boolean;

    procedure WriteLog(const Msg: string; const FileName: string);



    function InserirNaoFiscalServidor(oNaoFiscal:TNaoFiscal):boolean;
    function AtualizarPreVendaServidor(cupom,terminal,prevenda:string):boolean;
  end;

var
  dmCupomServidor: TdmCupomServidor;

implementation
uses Classe.funcoes;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCupomServidor }

function TdmCupomServidor.AtualizarPreVendaServidor(cupom, terminal,
  prevenda: string): boolean;
begin
with qrPrevendaServidorAtualizar do
begin
  Close;
  SQL.Clear;
  SQL.ADD('UPDATE PREVENDA SET STATUS = :STATUS, COD_CUPOM=:COD_CUPOM WHERE CODIGO = :CODIGO AND TERMINAL = :TERMINAL');
  ParamByName('STATUS').AsString := 'F';
  ParamByName('COD_CUPOM').AsString := cupom;
  ParamByName('CODIGO').AsString := prevenda;
  ParamByName('TERMINAL').AsString := terminal;
  try
  ExecSQL;
  except
//  ON E:Exception do
//  begin
//    TuFrmMensagem.Mensagem('ERRO AO ATUALIZAR STATUS SERVIDOR, VERIFIQUE A COMUNICAÇÃO :'+E.Message,'ERRO',[mbOk]);
//  end;

  end;
end;
end;


function TdmCupomServidor.InserirCupomFormaServidor(oCupomForma: TCupomForma): Boolean;
var
  i:integer;
begin
try
with oCupomForma do
begin
    spCupom_Forma.close;
    spCupom_Forma.ParamByName('codigo').asstring := codigo;
    spCupom_Forma.ParamByName('cod_cupom').asstring := codigo_cupom; //
    spCupom_Forma.ParamByName('forma').asstring := forma;
    spCupom_Forma.ParamByName('valor').asfloat := valor;
    spCupom_Forma.ParamByName('prestacao').asinteger := prestacao;
    spCupom_Forma.ParamByName('tipo').asstring := tipo;
    spCupom_Forma.ParamByName('valor_troco').asfloat := valor_troco;
    spCupom_Forma.parambyname('data').AsDate := data_forma;
    spCupom_Forma.ParamByName('EX').AsInteger := 0;
    spCupom_Forma.ParamByName('COD_CAIXA').AsInteger := caixa_forma;

    if cancelado = 1 then
    begin
    spCupom_Forma.parambyname('cancelado').asinteger := 1;
    end
    else
    begin
    spCupom_Forma.parambyname('cancelado').asinteger := cancelado;
    end;

    spCupom_Forma.Prepare;
    spCupom_Forma.Execute;
end;

result := true;
except
on E:Exception do
begin
  raise Exception.Create('Erro ao inserir finalizacao: '+E.Message);
end;

end;
end;

function TdmCupomServidor.InserirCupomItemServidor(oCupomItem: TCupomItem): Boolean;
var
  I:Integer;
begin
try
with oCupomItem do
begin
  result := false;
  spCupom_Item.close;
  spCupom_Item.parambyname('codigo').asstring := codigo_item;
  spCupom_Item.parambyname('cod_cupom').asstring := codigo_cupom;
  spCupom_Item.parambyname('item').AsInteger := Item_item;
  spCupom_Item.ParamByName('cod_produto').AsString := Produto.codigo;
  spCupom_Item.parambyname('unidade').asstring := unidade_item;
  spCupom_Item.parambyname('qtde').asfloat := qtde_item;
  spCupom_Item.parambyname('valor_unitario').asfloat := valor_unitario_item;
  spCupom_Item.parambyname('valor_desconto').asfloat := valor_desconto_item;
  spCupom_Item.parambyname('valor_acrescimo').asfloat := valor_acrescimo_item;
  spCupom_Item.parambyname('valor_total').asfloat := valor_total_item;
  spCupom_Item.parambyname('data').AsDate := data_item;
  spCupom_Item.parambyname('cod_caixa').AsInteger := caixa_cupom;
  spCupom_Item.parambyname('VALOR_CUSTO').asfloat := valor_custo;
  spCupom_Item.parambyname('VALOR_CUSTO_TOTAL').asfloat := valor_custo_total;
  spCupom_Item.ParamByName('EX').AsInteger := 0;
  spCupom_Item.ParamByName('MOTIVO_CANCELAMENTO').AsString := motivo_cancelamento;

  if cancelado_cupom = 1 then
  begin
  spCupom_Item.parambyname('cancelado').asinteger := 1;
  end
  else
  begin
  spCupom_Item.parambyname('cancelado').asinteger := cancelado_item;
  end;

end;
  spCupom_Item.Prepare;
  spCupom_Item.Execute;
 
  result := true;
except
on E:Exception do
begin
  WriteLog(e.Message,'log_cupom_item.txt');
  raise Exception.Create('Erro ao inserir cupom item: '+e.Message);
  result := false;
end;

end;
end;

function TdmCupomServidor.InserirCupomServidor(oCupom: TCupom): Boolean;
var
  I : integer;
begin
    Result := False;
    try
        // cabeçalho cupom
        spCupom.close;
        spCupom.ParamByName('codigo').asstring := oCupom.codigo_cupom;
        spCupom.ParamByName('numero').asstring := oCupom.numero_cupom;
        spCupom.ParamByName('data').asdate := oCupom.data_cupom;
        spCupom.ParamByName('hora').AsTime := oCupom.hora_cupom;
        spCupom.ParamByName('qtde_item').asinteger := oCupom.qtd_item_cupom;
        spCupom.ParambyName('Valor_Desconto').asfloat := oCupom.valor_desconto_cupom;
        spCupom.ParambyName('Valor_Acrescimo').asfloat := oCupom.valor_acrescimo_cupom;
        spCupom.ParamByName('valor_total').asfloat :=  oCupom.valor_total_cupom;
        spCupom.ParamByName('cod_cliente').AsInteger := oCupom.cliente_cupom;
        spCupom.ParamByName('cancelado').asinteger := oCupom.cancelado_cupom;
        spcupom.parambyname('cpf_consumidor').asstring := oCupom.Consumidor.CNPJCPF;
        spcupom.ParamByName('nome_consumidor').asstring := copy(oCupom.Consumidor.Nome, 1, 40);
        spcupom.ParamByName('cod_caixa').asinteger := oCupom.caixa_cupom;
        spcupom.ParamByName('cod_vendedor').asinteger := oCupom.vendedor_cupom;
        spcupom.ParamByName('XML_CHAVE').AsString := oCupom.xml_chave_cupom;
        spcupom.ParamByName('XML_CHAVE_CANCELAMENTO').AsString := oCupom.xml_chave_CANCELAMENTO_cupom;
        spcupom.ParamByName('EX').AsInteger := 0;
        spcupom.ParamByName('NUVEM').AsInteger := 0;
        spcupom.ParamByName('VALOR_CUSTO').AsFloat := oCupom.valor_custo_total;

        spCupom.Prepare;
        spCupom.Execute;


//           CONTAS A RECEBER
          for I := 1 to oCupom.countListaContasReceber do
          begin
            with oCupom.ListaContasReceber[I] do
            begin
            spContas_Receber.close;
            spContas_Receber.ParamByName('codigo').asstring := codigo;
            spContas_Receber.ParamByName('cod_cupom').asstring := oCupom.codigo_cupom;
            spContas_Receber.ParamByName('cod_vendedor').AsInteger := oCupom.vendedor_cupom;
            spContas_Receber.ParamByName('cod_caixa').AsInteger := oCupom.caixa_cupom;
            spContas_Receber.ParamByName('cod_cliente').asString := Cliente;
            spContas_Receber.ParamByName('data_emissao').asdate := Data;
            spContas_Receber.ParamByName('data_vencimento').asdate := Vencimento;
            spContas_Receber.parambyname('data_pagamento').AsDate := 0;
            spContas_Receber.ParamByName('valor').AsFloat := Valor;
            spContas_Receber.ParamByName('valor_pago').AsFloat := 0;
            spContas_Receber.ParamByName('valor_desconto').AsFloat := 0;
            spContas_Receber.ParamByName('valor_acrescimo').AsFloat := 0;
            spContas_Receber.ParamByName('valor_restante').AsFloat :=oCupom.valor_total_cupom;
            if oCupom.cancelado_cupom = 1 then
            begin
            spContas_Receber.parambyname('cancelado').asinteger := 1;
            end
            else
            begin
            spContas_Receber.parambyname('cancelado').asinteger := 0;
            end;

            spContas_Receber.Prepare;
            spContas_Receber.Execute;
            end;
          end;


        result := true;
      except
      on E:Exception do
      begin
        result := false;
        WriteLog(e.Message,'log_cupom.txt');
        ShowMessage('ERRO SQL:'+E.Message);

      end;
    end;
end;

function TdmCupomServidor.InserirEstoqueMovimentacao(
  oMovimentacao: TMovimentacao): Boolean;
begin
try
  with oMovimentacao do
  begin
  spEstoque_Movimentacao.close;
  spEstoque_Movimentacao.parambyname('QTDE').AsFloat := qtde;
  spEstoque_Movimentacao.parambyname('DATA').AsDate := data;
  spEstoque_Movimentacao.parambyname('HORA').AsTime := hora;
  spEstoque_Movimentacao.parambyname('CODPRODUTO').AsString := codproduto;
  spEstoque_Movimentacao.parambyname('COD_CUPOM').AsString := nCupom;
  spEstoque_Movimentacao.parambyname('ITEM').AsInteger := item;
  spEstoque_Movimentacao.parambyname('COD_FUNCIONARIO').AsString := ZeroEsquerda(funcionario,6);
  spEstoque_Movimentacao.parambyname('ORIGEM').AsString := origem;
  spEstoque_Movimentacao.parambyname('COD_CAIXA').AsInteger := caixa;
  spEstoque_Movimentacao.Prepare;
  spEstoque_Movimentacao.Execute;
  end;
  result := true;
except
on E:Exception do
begin
  WriteLog(e.Message,'log_estoque_movimentacao.txt');
  result := false;
  raise Exception.Create('Erro ao inserir movimentação no estoque: '+ E.message);
end;

end;
end;


function TdmCupomServidor.InserirFechamentoFinServidor(
  oFechamentoFin: TFechamentoFin): boolean;
begin
try
   with qrFechamentoFinalizadoraInserir do
      begin
        ParamByName('ID_FECHAMENTO').AsString := oFechamentoFin.id;

          with oFechamentoFin do
          begin
            ParamByName('FZCOD').AsString := Finalizadora;
            ParamByName('VALOR_LIQUIDO').AsFloat := valorLiquido;
            ParamByName('VALOR_ENTRADA').AsFloat := valorEntrada;
            ParamByName('VALOR_TROCO').AsFloat := valorTroco;
            ParamByName('VALOR_REFORCO').AsFloat := valorReforco;
            ParamByName('VALOR_SANGRIA').AsFloat := valorSangria;
            ParamByName('VALOR_CONFERENCIA').AsFloat := valorConferencia;
            ParamByName('EX').AsInteger := 0;
            ParamByName('COD_CAIXA').AsInteger := codCaixa;
            ExecSQL;
            result :=true;
          end;


      end;
except
result :=false;

end;
end;

function TdmCupomServidor.InserirFechamentoServidor(
  oFechamento: TFechamento): Boolean;
  var
  i:Integer;
begin
with qrFechamentoInserir do
  begin
      Params.ParamByName('codigo').AsString   := oFechamento.codigo;
      Params.ParamByName('OPERADOR').AsString   := oFechamento.Operador;
      Params.ParamByName('DATA_ABERTURA').AsDate:= oFechamento.dataAbertura;
      Params.ParamByName('HORA_ABERTURA').AsTime:= oFechamento.horaAbertura;
      Params.ParamByName('DATA_FECHAMENTO').AsDate := oFechamento.dataFechamento;
      Params.ParamByName('HORA_FECHAMENTO').AsTime:= oFechamento.horaFechamento;
      Params.ParamByName('VENDA_BRUTA').AsFloat := oFechamento.vendaBruta;
      Params.ParamByName('CANCELAMENTO_CUPOM').AsFloat := oFechamento.cancelamentoCupom;
      Params.ParamByName('CANCELAMENTO_ITEM').AsFloat := oFechamento.cancelamentoItem;
      Params.ParamByName('DESCONTO_ITEM').AsFloat := oFechamento.descontoItem;
      Params.ParamByName('DESCONTO_CUPOM').AsFloat := oFechamento.descontoCupom;
      Params.ParamByName('ACRESCIMO_CUPOM').AsFloat := oFechamento.acrescimoCupom;
      Params.ParamByName('VENDA_LIQUIDA').AsFloat := oFechamento.vendaLiquida;
      Params.ParamByName('FUNDO_CAIXA').AsFloat := oFechamento.fundoCaixa;
      Params.ParamByName('SANGRIA').AsFloat := oFechamento.sangria;
      Params.ParamByName('TOTAIS').AsFloat := oFechamento.totais;
      Params.ParamByName('QTD_CUPONS_EFETIVADOS').AsInteger := oFechamento.qtdCuponsEfetivados;
      Params.ParamByName('QTD_CUPONS_CANCELADOS').AsInteger := oFechamento.qtdCuponsCancelados;
      Params.ParamByName('EX').AsInteger := 0;
      params.ParamByName('COD_OPERADOR').AsInteger := ofechamento.codOperador;
      params.ParamByName('COD_CAIXA').AsInteger := ofechamento.codCaixa;
      try
      ExecSQL();
      Result := true;
      except
        on E:Exception do
        begin
        raise Exception.Create('Erro ao gravar fechamento: '+E.Message);
        Result := false;
        end;


    end;

  end;




end;

function TdmCupomServidor.InserirNaoFiscalServidor(
  oNaoFiscal: TNaoFiscal): boolean;
begin
try
  spNao_Fiscal.Close;
  spNao_Fiscal.parambyname('codigo').asstring := oNaoFiscal.codigo;
  spNao_fiscal.ParamByName('data').asdatetime := oNaoFiscal.data;
  spNao_fiscal.ParamByName('hora').asdatetime := oNaoFiscal.Hora;
  spNao_fiscal.ParamByName('indice').asstring := oNaoFiscal.indice;
  spNao_fiscal.ParamByName('Descricao').asstring := oNaoFiscal.Descricao;
  spNao_fiscal.ParamByName('valor').asfloat := oNaoFiscal.Valor;
  spNao_Fiscal.ParamByName('FZCOD').AsString := oNaoFiscal.Finalizadora;
  spNao_Fiscal.ParamByName('CODVENDEDOR').AsInteger := oNaoFiscal.Vendedor;
  spNao_Fiscal.ParamByName('COD_CAIXA').AsInteger := oNaoFiscal.caixa;
  spNao_Fiscal.Prepare;
  spNao_Fiscal.Execute;
  result := true;
except
   result := false;
end;
end;

function TdmCupomServidor.InserirNFCePendente(
  oNFCePendente: TNFCePendente): Boolean;
  var
  Stream: TStringStream;
begin
result := false;

try
  with qrNFCePendenteInserir do
  begin
  Close;
  sql.Clear;
  sql.add('UPDATE OR INSERT INTO NFCE_PENDENTE(CODIGO_CUPOM,COD_CAIXA,DATA,HORA,XML,STATUS,CHAVE,TOTAL) VALUES (:CODIGO_CUPOM,:COD_CAIXA,:DATA,:HORA,:XML,:STATUS,:CHAVE,:TOTAL)');

  ParamByName('CODIGO_CUPOM').AsString := oNFCePendente.codigo_cupom;
  ParamByName('COD_CAIXA').AsInteger := oNFCePendente.cod_caixa;
  ParamByName('DATA').AsDate := oNFCePendente.data;
  ParamByName('HORA').AsDateTime := oNFCePendente.Hora;

  ParamByName('STATUS').AsString := oNFCePendente.status;
  ParamByName('CHAVE').AsString := oNFCePendente.chave;
  ParamByName('TOTAL').AsFloat := oNFCePendente.total;

Stream := TStringStream.Create(oNFCePendente.xml, TEncoding.UTF8);

ParamByName('XML').LoadFromStream(Stream, ftBlob);
  ExecSQL;
  end;
result := true;
except
on E:Exception do
begin
ShowMessage(e.message);
result := False;
end;


end;

end;

procedure TdmCupomServidor.WriteLog(const Msg, FileName: string);
var
  LogFile: TextFile;
  DateTimeStr: string;
begin
  // Obtém a data e a hora atuais
  DateTimeStr := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);

  // Abre o arquivo para adicionar texto
  AssignFile(LogFile, FileName);
  if FileExists(FileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  try
    // Escreve a mensagem com um carimbo de data/hora
    Writeln(LogFile, Format('%s - %s', [DateTimeStr, Msg]));
  finally
    // Fecha o arquivo
    CloseFile(LogFile);
  end;
end;

end.
