unit uDmNotificacao;

interface

uses
  System.SysUtils, System.Classes,uDmConexao,Classe.Notificacao,System.Generics.Collections,
  Data.DB, MemDS, DBAccess, Uni;

type
  TdmNotificacao = class(TDataModule)
    qrNotEstoque: TUniQuery;
    qrNotValidade: TUniQuery;
  private
    { Private declarations }
  public
    function notificacaoEstoque:TObjectList<TNotificacao>;
    function notificacaoValidade(diasNotificar:integer):TObjectList<TNotificacao>;
  end;

var
  dmNotificacao: TdmNotificacao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmNotificacao }

function TdmNotificacao.notificacaoEstoque: TObjectList<TNotificacao>;
var
  notificacao:TNotificacao;
begin
result := TObjectList<TNotificacao>.create;


with qrNotEstoque do
begin
  Close;
  sql.Clear;
  sql.Add('select codigo,codigo_barras,descricao,estoque,estoque_minimo from produto where estoque <= estoque_minimo');
  Open;

  while not qrNotEstoque.Eof do
  begin
    notificacao := TNotificacao.Create;
    notificacao.tipo := 'Estoque';
    notificacao.mensagem := 'Produto com estoque mínimo: '+ FloatToStr(FieldByName('ESTOQUE_MINIMO').asfloat) + ' Estoque atual: '+FloatToStr(FieldByName('ESTOQUE').AsFloat);
    notificacao.codigo := qrNotEstoque.FieldByName('CODIGO').AsString;

    result.Add(notificacao);
    qrNotEstoque.Next;
  end;
end;
end;

function TdmNotificacao.notificacaoValidade(diasNotificar:integer): TObjectList<TNotificacao>;
var
  notificacao:TNotificacao;
begin
result := TObjectList<TNotificacao>.create;


with qrNotValidade do
begin
  Close;
  sql.Clear;
  sql.Add('SELECT * FROM validade WHERE validade <= CURRENT_DATE+'+inttostr(diasNotificar));
  Open;

  while not qrNotValidade.Eof do
  begin
    notificacao := TNotificacao.Create;
    notificacao.tipo := 'Validade';
    notificacao.mensagem := 'Produto próximo ao vencimento, VENCIMENTO: '+ DateToStr(FieldByName('VALIDADE').AsDateTime) + ' ENTRADA: '+DateToStr(FieldByName('DATA_ENTRADA').AsDateTime);
    notificacao.codigo := qrNotValidade.FieldByName('CODIGO_PRODUTO').AsString;

    result.Add(notificacao);
    qrNotValidade.Next;
  end;
end;
end;

end.
