unit uDmTributacao;

interface

uses
  System.SysUtils, System.Classes,Conexao, Data.DB, MemDS, DBAccess, Uni,Tributacao;

type
  TdmTributacao = class(TDataModule)
    qrTributacaoInsertUpdate: TUniQuery;
  private
    { Private declarations }
  public
    function InsertTributacao(oTributacao:TTributacao):Boolean;
  end;

var
  dmTributacao: TdmTributacao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmTributacao }

function TdmTributacao.InsertTributacao(oTributacao: TTributacao): Boolean;
begin
with qrTributacaoInsertUpdate,oTributacao do
begin
  Params.ParamByName('CODIGO').AsString := codigo;
  Params.ParamByName('DESCRICAO').AsString := nome;
  Params.ParamByName('CST').AsString := cst;
  Params.ParamByName('CFOP').AsString := cfop;
  Params.ParamByName('ICMS').AsFloat := icms;
  Params.ParamByName('CSOSN').AsString := csosn;

  if CSOSN = '500' then
  begin
    Params.ParamByName('ST').AsString := 'F';
  end;

  if CSOSN = '102' then
  begin
    Params.ParamByName('ST').AsString := 'T';
  end;

  if CSOSN = '300' then
  begin
    Params.ParamByName('ST').AsString := 'I';
  end;
  try
    ExecSQL;
  except
  on E:Exception do
  begin
    raise Exception.Create('Erro ao inserir tributação: '+ E.Message );
  end;

  end;


end;
end;

end.
