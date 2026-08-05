unit uDmContasReceberPagamento;

interface

uses
  System.SysUtils, System.Classes,System.Generics.collections,ContasReceber,uDmConexao,
  Data.DB, MemDS, DBAccess, Uni,ContasReceberList , classe.funcoes,Conversao;

type
  TdmContasReceberPagamento = class(TDataModule)
    qrInsertContasReceberPagamento: TUniQuery;
  private
    { Private declarations }
  public
    procedure insertContasReceberPagamento(ContasReceberList:TContasReceberList;pagamento:string);
  end;

var
  dmContasReceberPagamento: TdmContasReceberPagamento;

implementation
uses Classe.Variaveis;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmContasReceberPagamento }

procedure TdmContasReceberPagamento.insertContasReceberPagamento(
  ContasReceberList:TContasReceberList;pagamento:string);
  var
    ContasReceber:TContasReceber;
    seq:string;
begin
  for ContasReceber in ContasReceberList.Items do
    begin
      if ContasReceber.valor_parcela > 0 then
      begin
        seq := VariaveisSrv.oUtilsController.RetornaSequencialFin('CONTAS_RECEBER_PAGAMENTO','PRESTACAO',ContasReceber.cod_cupom);
        with qrInsertContasReceberPagamento do
        begin
          Close;
          SQL.Clear;
          SQL.add('INSERT INTO CONTAS_RECEBER_PAGAMENTO (CODIGO,COD_CUPOM,DATA_PAGAMENTO,FINALIZADORA,VALOR,VALOR_DESCONTO,VALOR_ACRESCIMO,PRESTACAO)');
          SQL.add('VALUES (:CODIGO,:COD_CUPOM,:DATA_PAGAMENTO,:FINALIZADORA,:VALOR,:VALOR_DESCONTO,:VALOR_ACRESCIMO,:PRESTACAO)');
          ParamByName('CODIGO').AsString := codifica_crediario_pagamento(StrToInt(seq),ContasReceber.cod_cupom);
          ParamByName('COD_CUPOM').AsString := ContasReceber.cod_cupom;
          ParamByName('DATA_PAGAMENTO').AsDate := date();
          ParamByName('FINALIZADORA').AsString := Pagamento;
          ParamByName('VALOR').AsFloat := ContasReceber.valor_parcela;
          ParamByName('VALOR_DESCONTO').AsFloat := 0;
          ParamByName('VALOR_ACRESCIMO').AsFloat := 0;
          ParamByName('PRESTACAO').AsInteger := StrToInt(seq);

          ExecSQL;
          VariaveisSrv.oAuditoriaController.InserirAuditoria('CONTAS_RECEBER_PAGAMENTO','LANCOU PAGAMENTO CONTA Nº'+codifica_crediario_pagamento(StrToInt(seq),ContasReceber.cod_cupom),tpInclusao);
        end;
      end;
    end;


end;

end.
