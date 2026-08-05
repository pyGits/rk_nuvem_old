unit uDmValidade;

interface

uses
  System.SysUtils, System.Classes,Data.db, MemDS, DBAccess, Uni,uDmConexao,Classe.Validade,Classe.Relatorio,Vcl.DBGrids;

type
  TdmValidade = class(TDataModule)
    qrValidadeInserir: TUniQuery;
    qrProdutoValidade: TUniQuery;
    qrProdutoValidadeESTOQUE: TFloatField;
    qrProdutoValidadeCODIGO: TStringField;
    qrValidadeAtualizar: TUniQuery;
    qrProdutoValidadeCODIGO_BARRAS: TStringField;
    qrProdutoValidadeDESCRICAO: TStringField;
    qrGridValidade: TUniQuery;
    qrGridValidadeID: TIntegerField;
    qrGridValidadeCODIGO_PRODUTO: TStringField;
    qrGridValidadeLOCALIZACAO: TStringField;
    qrGridValidadeQUANTIDADE: TFloatField;
    qrGridValidadeVALIDADE: TDateField;
    qrGridValidadeSITUACAO: TIntegerField;
    qrGridValidadeDIAS_VENCER: TIntegerField;
    qrGridValidadeDATA_ENTRADA: TDateField;
    qrGridValidadeSELECIONADO: TIntegerField;
    qrGridValidadePROXIMO_VENCIMENTO: TIntegerField;
    qrGridValidadePRODUTO: TStringField;
    qrGridValidadeCODIGO_BARRAS: TStringField;
    qrGridValidadeESTOQUE: TFloatField;
    qrGeral: TUniQuery;
    qrGridValidadeLOTE: TStringField;
    procedure qrGridValidadeDIAS_VENCERGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qrGridValidadePROXIMO_VENCIMENTOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);

  private

    function zerarSelecionado(sProduto:string):Boolean;overload;
    function zerarSelecionado:Boolean;overload;

  public
    function carregarGridValidade(ds:TDataSource):Boolean;overload;
    function carregarGridValidade(ds:TDataSource;codigoProduto:string):Boolean;overload;
    function carregarGridValidade(ds:TDataSource;codigoProduto:string;oRelatorio:TRelatorio):Boolean;overload;
    function ordenarGrid(coluna:TColumn):Boolean;

    function inserirValidade(oValidade:TValidade):boolean;
    function conferirValidade(oValidade: TValidade):Boolean;
    function atualizarValidade(oValidade:TValidade):Boolean;
    function deletarValidade(id:integer):boolean;

    function carregarValidade(idValidade:integer):TValidade;
  end;

var
  dmValidade: TdmValidade;

implementation

uses System.DateUtils,Classe.Funcoes,Classe.variaveis;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmValidade }

function TdmValidade.carregarGridValidade(ds: TDataSource): Boolean;
begin
with qrGridValidade do
begin
  try
  zerarSelecionado;
  ds.DataSet := qrGridValidade;

  qrProdutoValidade.Close;
  qrProdutoValidade.SQL.Clear;
  qrProdutoValidade.SQL.Add('SELECT * FROM PRODUTO');
  qrProdutoValidade.Open;

  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM VALIDADE ORDER BY VALIDADE DESC');

  Open;


  except
  on E:Exception do
  begin
    raise Exception.Create('Erro ao carregar Grid de validade ! '+ E.Message);
  end;

  end;
end;
end;

function TdmValidade.atualizarValidade(oValidade: TValidade): Boolean;
begin
Result := false;
with qrGeral do
begin
  Close;
  SQL.Clear;
  SQL.Add('UPDATE VALIDADE SET QUANTIDADE = :QUANTIDADE, VALIDADE = :DATA_VENCIMENTO , LOTE = :LOTE,DIAS_VENCER=:DIAS_VENCER, DATA_ENTRADA = :DATA_ENTRADA WHERE ID =:ID');
  ParamByName('QUANTIDADE').AsFloat := oValidade.Quantidade;
  ParamByName('DATA_VENCIMENTO').AsDate := oValidade.DataVencimento;
  ParamByName('DATA_ENTRADA').AsDate := oValidade.DataEntrada;
  ParamByName('LOTE').AsString := oValidade.lote;
  ParamByName('DIAS_VENCER').AsInteger := diferencaDias(oValidade.DataEntrada,oValidade.DataVencimento)-1;
  ParamByName('ID').AsInteger := oValidade.id;
  ExecSQL;
  result := true;

end;
end;

function TdmValidade.carregarGridValidade(ds: TDataSource;
  codigoProduto: string;oRelatorio:TRelatorio): Boolean;
begin
  // SITUACAO 0 = NÃO CONFERIDO
  // SITUACAO 1 = CONFERIDO
  // resetar selecionados do produto

  zerarSelecionado;


  with qrGridValidade do
  begin
  try
  ds.DataSet := qrGridValidade;

  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM VALIDADE WHERE 1=1');

  if (codigoProduto <> '') and (codigoProduto <> '000000') then
  begin
  sql.Add('AND CODIGO_PRODUTO = :CODIGO');
  ParamByName('CODIGO').AsString := codigoProduto;
  end;

  // data
  SQL.Add('AND VALIDADE >= :DTINICIO AND VALIDADE <= :DTFIM');
  ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
  ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

  // SITUACAO
  if oRelatorio.itemIndex = 0 then
  begin
    // A conferir
  sql.Add('AND SITUACAO = 0');
  end;
  if oRelatorio.itemIndex = 1 then
  begin
    // Conferido
  sql.Add('AND SITUACAO = 1');
  end;

  // a vencer
  if oRelatorio.itemIndex1 = 1 then
  begin
    sql.Add('and validade >= CURRENT_DATE');
  end;
  // alerta
  if oRelatorio.itemIndex1 = 2 then
  begin
    sql.Add('and validade >= CURRENT_DATE and validade <= :alertaDias');
    ParamByName('alertaDias').AsDate := Now() + VariaveisSrv.oConfiguracoes.Validade.alertaDias;
  end;
  // vencido ou vencec hoje
  if oRelatorio.itemIndex1 = 3 then
  begin
    sql.Add('and validade <= CURRENT_DATE ');
  end;
  // conferido
  if oRelatorio.itemIndex1 = 4 then
  begin
    sql.Add('and situacao = 1 ');
  end;

  Open;


  except
  on E:Exception do
  begin
    raise Exception.Create('Erro ao carregar Grid de validade ! '+ E.Message);
  end;

  end;
  end;
end;



function TdmValidade.carregarValidade(idValidade: integer): TValidade;
begin
result := TValidade.Create;
with qrGeral do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM VALIDADE WHERE ID =:ID');
  ParamByName('ID').AsInteger := idValidade;
  Open;
  if qrGeral.RecordCount = 1 then
  begin
  result.id := FieldByName('ID').AsInteger;
  Result.Codigo := FieldByName('CODIGO_PRODUTO').AsString;
  Result.Localizacao := FieldByName('LOCALIZACAO').asstring;
  Result.Quantidade := FieldByName('QUANTIDADE').AsFloat;
  Result.DataVencimento :=  FieldByName('VALIDADE').AsDatetime;
  Result.DiasVencimento :=  FieldByName('DIAS_VENCER').AsInteger;
  result.DataEntrada := FieldByName('DATA_ENTRADA').AsDateTime;
  result.lote := FieldByName('LOTE').AsString;
  end;
end;

end;

function TdmValidade.carregarGridValidade(ds:TDataSource;codigoProduto: string): Boolean;
begin
  zerarSelecionado(codigoProduto);
  with qrGridValidade do
  begin
  try
  ds.DataSet := qrGridValidade;

  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM VALIDADE WHERE CODIGO_PRODUTO = :CODIGO ORDER BY VALIDADE DESC');
  ParamByName('CODIGO').AsString := codigoProduto;
  Open;


  except
  on E:Exception do
  begin
    raise Exception.Create('Erro ao carregar Grid de validade ! '+ E.Message);
  end;

  end;
  end;
end;

function TdmValidade.conferirValidade(oValidade: TValidade): Boolean;
begin
with qrValidadeAtualizar do
begin
try
  Close;
  SQL.Clear;
  SQL.Add('UPDATE VALIDADE SET SITUACAO = 1 WHERE ID = :ID');
  ParamByName('ID').AsString := oValidade.Codigo;
  ExecSQL;
    result := true;
except
  on E:Exception do
  begin
    result := false;
    raise Exception.Create('Erro ao atualizar validade : '+ E.Message);
  end;

end;
end;
end;

function TdmValidade.deletarValidade(id: integer): boolean;
begin
result := false;
with qrGeral do
begin
  close;
  sql.Clear;
  sql.Add('delete from validade where id = :id');
  ParamByName('ID').AsInteger := id;
  ExecSQL;
  result := true;
end;
end;

function TdmValidade.inserirValidade(oValidade: TValidade): boolean;
begin
try
  with qrValidadeInserir do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO VALIDADE(CODIGO_PRODUTO,LOCALIZACAO,QUANTIDADE,VALIDADE,SITUACAO,DIAS_VENCER,DATA_ENTRADA,SELECIONADO,LOTE) VALUES');
    SQL.Add('(:CODIGO_PRODUTO,:LOCALIZACAO,:QUANTIDADE,:VALIDADE,:SITUACAO,:DIAS_VENCER,:DATA_ENTRADA,:SELECIONADO,:LOTE)');
    ParamByName('CODIGO_PRODUTO').AsString := oValidade.Codigo;
    ParamByName('LOCALIZACAO').AsString := oValidade.Localizacao;
    ParamByName('QUANTIDADE').AsFloat := oValidade.Quantidade;
    ParamByName('VALIDADE').AsDate := oValidade.DataVencimento;
    ParamByName('SITUACAO').AsInteger := 0;
    ParamByName('DIAS_VENCER').AsInteger := oValidade.DiasVencimento;
    ParamByName('DATA_ENTRADA').AsDate := Now;
    ParamByName('SELECIONADO').AsInteger := 0;
    ParamByName('LOTE').AsString := oValidade.lote;
    ExecSQL;

    result := true;
  end;
except
on E:Exception do
begin
  Result := false;
  raise Exception.Create('Erro ao incluir validade ! '+E.Message );
end;

end;

end;

function TdmValidade.ordenarGrid(coluna: TColumn): Boolean;
begin
if (Pos('ASC',qrGridValidade.IndexFieldNames)>0) then
begin
qrGridValidade.IndexFieldNames := coluna.FieldName + ' DESC';
end
else
begin
qrGridValidade.IndexFieldNames := coluna.FieldName + ' ASC';
end;
qrGridValidade.First;
end;



procedure TdmValidade.qrGridValidadeDIAS_VENCERGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
  var
  diferenca:integer ;

begin
try
 diferenca := diferencaDias(now , qrGridValidade.FieldByName('VALIDADE').AsDateTime) ;

  text := inttostr(diferenca-1);
except
on E:Exception do
begin
  raise Exception.Create('Erro ao converter data no campo validade: '+E.message);
end;

end;





end;

procedure TdmValidade.qrGridValidadePROXIMO_VENCIMENTOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  diferenca:integer;
begin
 diferenca := diferencaDias(now , qrGridValidade.FieldByName('VALIDADE').AsDateTime);
 if diferenca <= 0 then
 begin
  text := 'NEGATIVO';
 end
 else
 if (diferenca > 0) and ( diferenca<=VariaveisSrv.oConfiguracoes.Validade.alertaDias ) then
 begin
  text := 'ALERTA';
 end
 else
 begin
  text := 'A_CONFERIR';
 end;

 // CONFERIDO
 if qrGridValidade.FieldByName('situacao').AsInteger = 1 then
 begin

   text := 'OK';
 end;


end;

function TdmValidade.zerarSelecionado: Boolean;
begin
  try
    with qrValidadeAtualizar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE VALIDADE SET SELECIONADO = 0');
      ExecSQL;

      Result := True;
    end;

  except
  on E:Exception do
  begin
    Result := false;
    raise Exception.Create('Erro ao zerar selecionados: '+ E.message);
  end;

  end;
end;

function TdmValidade.zerarSelecionado(sProduto:string): Boolean;
begin
  try
    with qrValidadeAtualizar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE VALIDADE SET SELECIONADO = 0 WHERE CODIGO_PRODUTO = :CODIGO_PRODUTO');
      ParamByName('CODIGO_PRODUTO').AsString := sProduto;

      ExecSQL;

      Result := True;
    end;

  except
  on E:Exception do
  begin
    Result := false;
    raise Exception.Create('Erro ao zerar selecionados: '+ E.message);
  end;

  end;
end;

end.
