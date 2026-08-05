unit uDmRelEstoque;

interface

uses
  System.SysUtils, System.Classes,uDmConexao,Classe.Relatorio,Conversao,
  Data.DB, MemDS, DBAccess, Uni, frxClass, frxDBSet, vcl.gtxXport, vcl.gtFRXport,Vcl.Dialogs;

type
  TdmRelEstoque = class(TDataModule)
    qrRelEstoque: TUniQuery;
    fxrelatorio: TfrxReport;
    DBSaldoEstoque: TfrxDBDataset;
    qrRelEstoqueCODIGO_BARRAS: TStringField;
    qrRelEstoqueUNIDADE: TStringField;
    qrRelEstoqueDESCRICAO: TStringField;
    qrRelEstoqueESTOQUE: TFloatField;
    qrRelEstoqueCUSTO: TFloatField;
    qrRelEstoquePRECO: TFloatField;
    qrRelEstoqueESTOQUE_MINIMO: TFloatField;
    qrRelEstoqueESTOQUE_MAXIMO: TFloatField;
    qrFornecedor: TUniQuery;
    DBFornecedor: TfrxDBDataset;
    qrFornecedorCODIGO: TStringField;
    qrFornecedorNOME: TStringField;
    qrFornecedorNOME_FANTASIA: TStringField;
    qrFornecedorENDERECO: TStringField;
    qrFornecedorNUMERO: TStringField;
    qrFornecedorBAIRRO: TStringField;
    qrFornecedorCIDADE: TStringField;
    qrFornecedorUF: TStringField;
    qrFornecedorCEP: TStringField;
    qrFornecedorCOMPLEMENTO: TStringField;
    qrFornecedorTELEFONE1: TStringField;
    qrFornecedorTELEFONE2: TStringField;
    qrFornecedorCELULAR: TStringField;
    qrFornecedorEMAIL: TStringField;
    qrFornecedorCNPJCPF: TStringField;
    qrFornecedorIE: TStringField;
    qrFornecedorIM: TStringField;
    qrFornecedorOBSERVACAO: TMemoField;
    qrFornecedorCONTATO1: TStringField;
    qrFornecedorCONTATO2: TStringField;
    FornecedorDetalhe: TUniDataSource;
    qrGrupo: TUniQuery;
    DBGrupo: TfrxDBDataset;
    GrupoDetalhe: TUniDataSource;
    qrGrupoCODIGO: TStringField;
    qrGrupoGRUPO: TStringField;
    qrSubGrupo: TUniQuery;
    DBSubGrupo: TfrxDBDataset;
    SubGrupoDetalhe: TUniDataSource;
    qrSubGrupoCODIGO: TStringField;
    qrSubGrupoCODIGO_GRUPO: TStringField;
    qrSubGrupoSUBGRUPO: TStringField;
    qrSubGrupoGRUPO_DESCRICAO: TStringField;
    DBExtratoEstoque: TfrxDBDataset;
    qrRelExtratoEstoque: TUniQuery;
    qrRelExtratoEstoqueID: TIntegerField;
    qrRelExtratoEstoqueTIPO: TIntegerField;
    qrRelExtratoEstoqueQTDE: TFloatField;
    qrRelExtratoEstoqueDATA: TDateField;
    qrRelExtratoEstoqueHORA: TTimeField;
    qrRelExtratoEstoqueCODPRODUTO: TStringField;
    qrRelExtratoEstoqueCOD_CUPOM: TStringField;
    qrRelExtratoEstoqueITEM: TIntegerField;
    qrRelExtratoEstoqueCOD_FUNCIONARIO: TStringField;
    qrRelExtratoEstoqueORIGEM: TStringField;
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
    qrProdutoESTOQUE_MINIMO: TFloatField;
    qrProdutoESTOQUE_MAXIMO: TFloatField;
    qrFuncionario: TUniQuery;
    qrRelExtratoEstoquePRODUTODESC: TStringField;
    qrFuncionarioCODIGO: TStringField;
    qrFuncionarioNOME: TStringField;
    qrFuncionarioAPELIDO: TStringField;
    qrFuncionarioEMAIL: TStringField;
    qrFuncionarioCPF: TStringField;
    qrFuncionarioCARGO: TIntegerField;
    qrFuncionarioSENHA: TStringField;
    qrFuncionarioCOMISSAO: TFloatField;
    qrRelExtratoEstoqueFUNCIONARIO: TStringField;
    qrRelExtratoEstoquePRODUTOCOD: TStringField;
  private
    { Private declarations }
  public
    function RelatorioSaldoEstoque(oRelatorio:TRelatorio):boolean;
    function RelatorioExtratoEstoque(oRelatorio:TRelatorio):boolean;
  end;

var
  dmRelEstoque: TdmRelEstoque;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRelEstoque }

function TdmRelEstoque.RelatorioExtratoEstoque(oRelatorio: TRelatorio): boolean;
begin
  with qrFuncionario do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM FUNCIONARIO');
    Open;
  end;
  with qrProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PRODUTO');
    Open;
  end;
  with qrRelExtratoEstoque do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from estoque_movimentacao where 1=1');

    sql.Add('and data >= :DTINICIO and data <= :DTFIM');


    if oRelatorio.caixa <> '0' then
    begin
      sql.Add('and cod_caixa = :cod_caixa');
      ParamByName('COD_CAIXA').AsString := oRelatorio.caixa;
    end;

    ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
    ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;


    if oRelatorio.listaString1[0] <> '000000' then
    begin
      sql.Add('AND COD_FUNCIONARIO = :FUNCIONARIO');
      ParamByName('FUNCIONARIO').AsString := oRelatorio.listaString1[0];
    end;

    if oRelatorio.listaString1[1] <> '000000' then
    begin                  // mudar coluna codigo
      sql.Add('AND CODPRODUTO = :CODPRODUTO');
      ParamByName('CODPRODUTO').AsString := oRelatorio.listaString1[1];
    end;

    Open;
  end;
  fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relExtratoEstoque.fr3');
  fxrelatorio.ShowReport;
end;

function TdmRelEstoque.RelatorioSaldoEstoque(oRelatorio:TRelatorio): boolean;
begin
if oRelatorio.itemIndex = 0 then
begin
  with qrFornecedor do
  begin
    CLose;
    SQL.Clear;
    sql.Add('select * from fornecedor order by codigo');
    Open;
  end;
  qrRelEstoque.DetailFields := 'FORNECEDOR';
  qrRelEstoque.MasterSource := FornecedorDetalhe;
end
else
if oRelatorio.itemIndex = 1 then
begin
  with qrGrupo do
  begin
    CLose;
    SQL.Clear;
    sql.Add('select * from grupo order by codigo');
    Open;
  end;
  qrRelEstoque.DetailFields := 'GRUPO';
  qrRelEstoque.MasterSource := GrupoDetalhe;
end;
if oRelatorio.itemIndex = 2 then
begin
  with qrSubGrupo do
  begin
    CLose;
    SQL.Clear;
    sql.Add('select * from subgrupo order by codigo');
    Open;
  end;
  qrRelEstoque.DetailFields := 'SUBGRUPO';
  qrRelEstoque.MasterSource := SubGrupoDetalhe;
end;

with qrRelEstoque do
begin
  Close;
  SQL.Clear;
  SQL.add('select codigo_barras,unidade,estoque_minimo,estoque_maximo,descricao,estoque,custo,preco,fornecedor,grupo,subgrupo from produto where 1=1');

  if oRelatorio.filtro1 <> 'Todos' then
  begin
    sql.Add('and unidade = :unidade');
    ParamByName('unidade').AsString := oRelatorio.filtro1;
  end;

  // tipos
  //somente positivo
  if (oRelatorio.listaCheckBox1[0]) and (oRelatorio.listaCheckBox1[1] = false) and (oRelatorio.listaCheckBox1[3] = false) then
  begin
    SQL.Add('and estoque > 0');
  end;
  //positivo e negativo
  if (oRelatorio.listaCheckBox1[0]) and (oRelatorio.listaCheckBox1[1]) and (oRelatorio.listaCheckBox1[3] = false) then
  begin
    SQL.Add('and estoque <> 0');
  end;
  //positivo , negativo e zerado
  if (oRelatorio.listaCheckBox1[0]) and (oRelatorio.listaCheckBox1[1]) and (oRelatorio.listaCheckBox1[3]) then
  begin
    // tudo
  end;

  // somente negativo
  if (oRelatorio.listaCheckBox1[0]= false) and (oRelatorio.listaCheckBox1[1]) and (oRelatorio.listaCheckBox1[3] = false) then
  begin
    SQL.Add('and estoque < 0');
  end;

  // negativo e zerado
  if (oRelatorio.listaCheckBox1[0]= false) and (oRelatorio.listaCheckBox1[1]) and (oRelatorio.listaCheckBox1[3]) then
  begin
    SQL.Add('and estoque <= 0');
  end;

  // somente zerado
  if (oRelatorio.listaCheckBox1[0]= false) and (oRelatorio.listaCheckBox1[1] = false) and (oRelatorio.listaCheckBox1[3]) then
  begin
    SQL.Add('and estoque = 0');
  end;

    // reposição
  if (oRelatorio.listaCheckBox1[2] = True) then
  begin
    sql.Add('and estoque_minimo > estoque');
  end;


  // ========================
  // Filtros

  if (oRelatorio.listaString1[0] <> '000000') then
  begin
    sql.Add('and fornecedor = :FORNECEDOR');
    ParamByName('FORNECEDOR').AsString := oRelatorio.listaString1[0];
  end;

  if (oRelatorio.listaString1[1] <> '000000') then
  begin
    sql.Add('and grupo = :GRUPO1');
    ParamByName('GRUPO1').AsString := oRelatorio.listaString1[1];
  end;

  if (oRelatorio.listaString1[2] <> '000000') then
  begin
    sql.Add('and grupo = :GRUPO1');
    sql.Add('and subgrupo = :SUBGRUPO1');
    ParamByName('GRUPO1').AsString := oRelatorio.listaString1[1];
    ParamByName('SUBGRUPO1').AsString := oRelatorio.listaString1[2];
  end;


  case oRelatorio.ordenar of
    ordNome:begin
      sql.add('order by descricao');
    end;
      ordCodigo:begin
      sql.add('order by codigo_barras');
    end;
    ordQuantidade:begin
      sql.add('order by estoque desc');
    end;

  end;

  Open;
  // fornecedor
  if oRelatorio.itemIndex = 0 then
  begin
  fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relSaldoEstoqueFornecedor.fr3');
  end
  else
  if oRelatorio.itemIndex = 1 then
  begin
  // grupo
  fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relSaldoEstoqueGrupo.fr3');
  end;
  if oRelatorio.itemIndex = 2 then
  begin
  // grupo
  fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relSaldoEstoqueSubGrupo.fr3');
  end;

  fxrelatorio.ShowReport;

end;
end;

end.
