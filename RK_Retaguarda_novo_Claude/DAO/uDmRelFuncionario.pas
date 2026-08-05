unit uDmRelFuncionario;

interface

uses
  System.SysUtils, System.Classes, frxClass, frxDBSet, Data.DB, MemDS, DBAccess,
  Uni,Classe.Relatorio;

type
  TdmRelFuncionario = class(TDataModule)
    qrRelComissaoFunc: TUniQuery;
    fxrelatorio: TfrxReport;
    DBComissaoFunc: TfrxDBDataset;
    qrRelComissaoFuncVENDA_TOTAL: TFloatField;
    qrRelComissaoFuncCANCELADO: TIntegerField;
    qrRelFunFuncionarios: TUniQuery;
    qrRelFunFuncionariosCODIGO: TStringField;
    qrRelFunFuncionariosNOME: TStringField;
    qrRelFunFuncionariosAPELIDO: TStringField;
    qrRelFunFuncionariosEMAIL: TStringField;
    qrRelFunFuncionariosCPF: TStringField;
    qrRelFunFuncionariosCARGO: TIntegerField;
    qrRelFunFuncionariosSENHA: TStringField;
    qrRelFunFuncionariosCOMISSAO: TFloatField;
    qrRelComissaoFuncCODFUNCIONARIO: TStringField;
    qrRelComissaoFuncCOMISSAO: TFloatField;
    qrRelComissaoFuncNOME: TStringField;
  private
    { Private declarations }
  public
      function RelatorioComissaoFuncionario(oRelatorio:TRelatorio):Boolean;
  end;

var
  dmRelFuncionario: TdmRelFuncionario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRelFuncionario }

function TdmRelFuncionario.RelatorioComissaoFuncionario(
  oRelatorio: TRelatorio): Boolean;
begin


with qrRelComissaoFunc do
begin
  Close;
  SQL.Clear;
  SQL.Add('select sum(valor_total) as venda_total, lpad(cod_vendedor,6,'+Chr(39)+'0'+Chr(39)+') as codfuncionario , cancelado ');
  SQL.Add('from cupom ');
  SQL.Add('where cancelado = 0 ');
  sql.Add('and data >= :dtInicio and data <= :dtFim');

  if oRelatorio.listaString1[0] <> '000000' then
  begin
    sql.Add('and cod_vendedor = :COD_VENDEDOR');
    ParamByName('COD_VENDEDOR').AsString := oRelatorio.listaString1[0];
  end;


  SQL.Add('group by cod_vendedor,cancelado ');

  ParamByName('dtInicio').AsDate := oRelatorio.periodoInicial;
  ParamByName('dtFim').AsDate := oRelatorio.periodoFinal;
  Open;

end;

with qrRelFunFuncionarios do
begin
  Close;
  SQL.Clear;
  SQL.Add('select * from funcionario');
  Open;
end;



        fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relComissaoFunc.fr3');
        fxrelatorio.ShowReport;

end;

end.
