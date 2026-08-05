unit uDmRelFinalizadora;

interface

uses
  System.SysUtils, System.Classes,Classe.Relatorio, frxClass, frxDBSet, Data.DB,
  MemDS, DBAccess, Uni,uDmConexao, vcl.gtxXport, vcl.gtFRXport;

type
  TdmRelFinalizadora = class(TDataModule)
    qrCupomFormaRel: TUniQuery;
    qrCupomFormaTotRel: TUniQuery;
    DBCupomForma: TfrxDBDataset;
    DBCupomFormaRes: TfrxDBDataset;
    fxrelatorio: TfrxReport;
    qrCupomFormaRelCODIGO: TStringField;
    qrCupomFormaRelCOD_CUPOM: TStringField;
    qrCupomFormaRelFORMA: TStringField;
    qrCupomFormaRelVALOR: TFloatField;
    qrCupomFormaRelPRESTACAO: TIntegerField;
    qrCupomFormaRelTIPO: TStringField;
    qrCupomFormaRelEX: TIntegerField;
    qrCupomFormaRelCOD: TIntegerField;
    qrCupomFormaRelVALOR_TROCO: TFloatField;
    qrCupomFormaRelDATA: TDateField;
    qrCupomFormaRelCANCELADO: TIntegerField;
    qrCupomFormaRelCOD_CAIXA: TIntegerField;
    qrCupomFormaRelCODIGO_1: TStringField;
    qrCupomFormaRelDESCRICAO: TStringField;
    qrCupomFormaRelESPECIE: TIntegerField;
    qrCupomFormaRelTIPO_1: TStringField;
    qrCupomFormaRelCODIGO99: TIntegerField;
    qrCupomFormaTotRelCODIGO: TStringField;
    qrCupomFormaTotRelDESCRICAO: TStringField;
    qrCupomFormaTotRelVALOR: TFloatField;
    qrCupomFormaTotRelVALOR_TROCO: TFloatField;
  private
    { Private declarations }
  public
    function RelatorioFinalizadora(oRelatorio:TRelatorio):Boolean;
  end;

var
  dmRelFinalizadora: TdmRelFinalizadora;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRelFinalizadora }

function TdmRelFinalizadora.RelatorioFinalizadora(
  oRelatorio: TRelatorio): Boolean;
begin

  // ==============================================================
  // Relatório agrupado por finalizadora
    if oRelatorio.detalhado then
    begin

    // ==============================================================
    // Relatório finalizadora detalhado
    with qrCupomFormaRel do
      begin

          Close;
          SQL.clear;
          SQL.add('select * from cupom_forma ');
          SQL.add('left join finalizadora ');
          SQL.add('on cupom_forma.forma = finalizadora.codigo');
          sql.add('LEFT JOIN CUPOM on cupom.codigo = cupom_forma.cod_cupom');
          sql.add('AND CUPOM.COD_CAIXA = CUPOM_FORMA.COD_CAIXA');
          SQL.add('where cupom_forma.data >= :DTINICIO and cupom_forma.data <=:DTFIM');

          if oRelatorio.cancelado = true then
          begin
            SQL.Add('AND cupom.cancelado  = 1');
          end
          else
          begin
            SQL.Add('AND cupom.cancelado  = 0');
          end;


          if oRelatorio.Fiscal = 1 then
          begin
          // fiscal
            SQL.Add('AND cupom.XML_CHAVE  <> '+Chr(39)+Chr(39));
          end
          ELSE
          if oRelatorio.Fiscal = 2 then
          begin
          //03
            SQL.Add('AND cupom.XML_CHAVE  = '+Chr(39)+Chr(39));
          end;


          ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
          ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;
          // caixa
          if oRelatorio.caixa <> '000' then
          begin
            SQL.Add('AND cupom_forma.COD_CAIXA = :COD_CAIXA');
            ParamByName('COD_CAIXA').AsInteger := StrToInt(oRelatorio.caixa);
          end;

          SQL.Add('order by cupom_forma.cod_caixa,cupom_forma.forma');
          Open;

        fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relFinalizadoraAgrupadoDet.fr3');
        fxrelatorio.ShowReport;
      end;



    end
    else
    begin
      // RESUMIDO
      with qrCupomFormaTotRel do
      begin
      Close;
      SQL.clear;
      SQL.Add('select finalizadora.CODIGO,finalizadora.DESCRICAO, ');
      SQL.Add('sum(valor) as "VALOR", ');
      SQL.Add('sum(valor_troco) as "VALOR_TROCO" ');

      SQL.Add('from cupom_forma ');
      SQL.Add('left join finalizadora ');
      SQL.Add('on cupom_forma.forma = finalizadora.codigo ');
      sql.add('LEFT JOIN CUPOM on cupom.codigo = cupom_forma.cod_cupom');
      sql.add('AND CUPOM.COD_CAIXA = CUPOM_FORMA.COD_CAIXA');
      SQL.add('where cupom_forma.data >= :DTINICIO and cupom_forma.data <=:DTFIM');

          if oRelatorio.cancelado = true then
          begin
            SQL.Add('AND cupom.cancelado  = 1');
          end
          else
          begin
            SQL.Add('AND cupom.cancelado  = 0');
          end;

          if oRelatorio.Fiscal = 1 then
          begin
          // fiscal
            SQL.Add('AND cupom.XML_CHAVE  <> '+Chr(39)+Chr(39));
          end
          ELSE
          if oRelatorio.Fiscal = 2 then
          begin
          //03
            SQL.Add('AND cupom.XML_CHAVE  = '+Chr(39)+Chr(39));
          end;
        // caixa
          if oRelatorio.caixa <> '000' then
          begin
          SQL.Add('AND cupom_forma.COD_CAIXA = :COD_CAIXA');
           ParamByName('COD_CAIXA').AsInteger := StrToInt(oRelatorio.caixa);
          end;


      SQL.Add('group by cupom_forma.cod_caixa,finalizadora.CODIGO,finalizadora.DESCRICAO ');


      ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
      ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

      fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relFinalizadoraAgrupadoSin.fr3');
      fxrelatorio.ShowReport;

      end;
    end;


end;

end.
