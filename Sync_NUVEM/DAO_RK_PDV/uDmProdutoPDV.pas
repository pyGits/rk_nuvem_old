unit uDmProdutoPDV;

interface

uses
  System.SysUtils, System.Classes,Produto,ConexaoPDV, Data.DB, MemDS, DBAccess,System.Generics.collections,
  Uni, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uLogErro;

type
  TdmProdutoPDV = class(TDataModule)
    qrProdutoPDV: TFDQuery;
  private
    procedure limparParaRegravar(listProduto:TObjectList<TProduto>;
      cargaCompleta:Boolean);
    { Private declarations }
    function tabelaAuxiliarExiste: Boolean;
    procedure gravarCodigosAuxiliares(listProduto:TObjectList<TProduto>);
  public
    function insertProdutoPDV(listProduto:TObjectList<TProduto>; cargaCompleta:Boolean):boolean;
  end;

var
  dmProdutoPDV: TdmProdutoPDV;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmProdutoPDV }

// PDV que ainda nao recebeu a ESTOQUE_COD_AUXILIAR nao pode virar um erro por
// produto na carga - a checagem custa uma consulta por caixa e evita o ruido.
function TdmProdutoPDV.tabelaAuxiliarExiste: Boolean;
var
  qrTabela: TFDQuery;
begin
  qrTabela := TFDQuery.Create(nil);
  try
    qrTabela.Connection := qrProdutoPDV.Connection;
    qrTabela.SQL.Text :=
      'SELECT COUNT(*) FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ''ESTOQUE_COD_AUXILIAR''';
    qrTabela.Open;
    Result := qrTabela.Fields[0].AsInteger > 0;
  finally
    qrTabela.Free;
  end;
end;

// Espelha no PDV a lista de codigos de barras auxiliares que veio da nuvem.
// A regra e de substituicao: os auxiliares dos produtos desta carga sao
// apagados e regravados, entao um codigo removido no cadastro tambem some do
// PDV. Vai em lote (Array DML) porque a carga completa passa por milhares de
// produtos e um round-trip por linha deixaria a sincronizacao lenta demais.
procedure TdmProdutoPDV.gravarCodigosAuxiliares(listProduto:TObjectList<TProduto>);
var
  oProduto: TProduto;
  produtos: TList<string>;
  auxProduto, auxBarra: TList<string>;
  auxiliares: TArray<string>;
  qrAux: TFDQuery;
  i: Integer;
begin
  produtos := TList<string>.Create;
  auxProduto := TList<string>.Create;
  auxBarra := TList<string>.Create;
  try
    for oProduto in listProduto do
    begin
      if not Assigned(oProduto) then
        Continue;
      if Trim(oProduto.Codigo) = '' then
        Continue;

      produtos.Add(oProduto.Codigo);

      auxiliares := oProduto.CodigosAuxiliares;
      for i := 0 to High(auxiliares) do
      begin
        auxProduto.Add(oProduto.Codigo);
        auxBarra.Add(auxiliares[i]);
      end;
    end;

    if produtos.Count = 0 then
      Exit;

    qrAux := TFDQuery.Create(nil);
    try
      qrAux.Connection := qrProdutoPDV.Connection;

      // 1) limpa os auxiliares dos produtos que vieram nesta carga
      qrAux.SQL.Text := 'DELETE FROM ESTOQUE_COD_AUXILIAR WHERE CODIGO = :CODIGO';
      qrAux.Params.ArraySize := produtos.Count;
      for i := 0 to produtos.Count - 1 do
        qrAux.ParamByName('CODIGO').AsStrings[i] := produtos[i];
      qrAux.Execute(qrAux.Params.ArraySize, 0);

      if auxBarra.Count = 0 then
        Exit;

      // 2) auxiliar que na nuvem passou para outro produto continuaria
      // apontando para o produto antigo aqui, porque a carga incremental so
      // traz o produto que mudou. Apaga a sobra antes de inserir.
      qrAux.SQL.Text :=
        'DELETE FROM ESTOQUE_COD_AUXILIAR WHERE COD_BARRA = :COD_BARRA AND CODIGO <> :CODIGO';
      qrAux.Params.ArraySize := auxBarra.Count;
      for i := 0 to auxBarra.Count - 1 do
      begin
        qrAux.ParamByName('COD_BARRA').AsStrings[i] := auxBarra[i];
        qrAux.ParamByName('CODIGO').AsStrings[i] := auxProduto[i];
      end;
      qrAux.Execute(qrAux.Params.ArraySize, 0);

      // 3) grava a lista atual
      qrAux.SQL.Text :=
        'INSERT INTO ESTOQUE_COD_AUXILIAR (CODIGO, COD_BARRA) VALUES (:CODIGO, :COD_BARRA)';
      qrAux.Params.ArraySize := auxBarra.Count;
      for i := 0 to auxBarra.Count - 1 do
      begin
        qrAux.ParamByName('CODIGO').AsStrings[i] := auxProduto[i];
        qrAux.ParamByName('COD_BARRA').AsStrings[i] := auxBarra[i];
      end;
      qrAux.Execute(qrAux.Params.ArraySize, 0);
    finally
      qrAux.Free;
    end;
  finally
    produtos.Free;
    auxProduto.Free;
    auxBarra.Free;
  end;
end;

// Mesmo problema que PRODUTO tem na retaguarda: ESTOQUE tem UNQ2_ESTOQUE,
// unique de COD_BARRA, e o UPDATE OR INSERT casa por CODIGO. Um codigo de
// barras que mudou de dono na nuvem chega no produto novo enquanto o antigo
// ainda o segura aqui, e a gravacao do caixa morre no meio da carga.
//
// Na carga completa a tabela e esvaziada e regravada; na de alterados saem so
// as linhas que o lote traz de volta, por codigo ou pelo barras que reivindica.
procedure TdmProdutoPDV.limparParaRegravar(listProduto: TObjectList<TProduto>;
  cargaCompleta: Boolean);
var
  qrDelete: TFDQuery;
  i: Integer;
begin
  qrDelete := TFDQuery.Create(nil);
  try
    qrDelete.Connection := qrProdutoPDV.Connection;

    if cargaCompleta then
    begin
      qrDelete.SQL.Text := 'DELETE FROM ESTOQUE';
      qrDelete.ExecSQL;
      Exit;
    end;

    qrDelete.SQL.Text :=
      'DELETE FROM ESTOQUE WHERE CODIGO = :CODIGO OR COD_BARRA = :COD_BARRA';
    qrDelete.Params.ArraySize := listProduto.Count;

    for i := 0 to listProduto.Count - 1 do
    begin
      qrDelete.ParamByName('CODIGO').AsStrings[i]    := listProduto[i].Codigo;
      qrDelete.ParamByName('COD_BARRA').AsStrings[i] := listProduto[i].CodigoBarras;
    end;

    qrDelete.Execute(qrDelete.Params.ArraySize, 0);
  finally
    qrDelete.Free;
  end;
end;

function TdmProdutoPDV.insertProdutoPDV(listProduto:TObjectList<TProduto>;
  cargaCompleta: Boolean): boolean;
var
  oProduto:TProduto;
  conexao:TFDCustomConnection;
begin
  // O delete e os inserts vao juntos: se a gravacao falhar no meio, o rollback
  // devolve o cadastro anterior e o caixa segue com a carga velha, em vez de
  // ficar sem produto nenhum.
  conexao := qrProdutoPDV.Connection;
  if not conexao.InTransaction then
    conexao.StartTransaction;
  try
    limparParaRegravar(listProduto, cargaCompleta);
  for oProduto in listProduto do
  begin
  with qrProdutoPDV, oProduto do
  begin
    ParamByName('CODIGO').AsString := oProduto.Codigo;
    ParamByName('COD_BARRA').AsString := oProduto.CodigoBarras;
    ParamByName('NOME').AsString := oProduto.Descricao;
    ParamByName('UNIDADE').AsString := oProduto.Unidade;
    ParamByName('SITUACAO').AsString :=    IntToStr(oProduto.getInativo);
    ParamByName('PRECO_VARIAVEL').AsInteger :=  oProduto.getDiversos;
    ParamByName('USA_BALANCA').AsInteger := oProduto.getFracionado;
    ParamByName('NCM').AsString := oProduto.NCM;

    ParamByName('PRECO_VENDA').AsFloat := oProduto.Preco;


    ParamByName('CEST').AsString := oProduto.CEST;
    ParamByName('TRIBUTACAO').AsString := oProduto.Tributacao;
    ParamByName('PRECO2').AsFloat := oProduto.Preco2;
    ParamByName('PRECO2_QTD').AsFloat := oProduto.Preco2_Qtd;
    try
    ExecSQL;
    except
    on E:Exception do
    begin
      raise Exception.Create('Erro ao inserir produto no PDV: '+E.Message);
    end;

    end;
  end;
  end;

    conexao.Commit;
  except
    if conexao.InTransaction then
      conexao.Rollback;
    raise;
  end;

  // Os auxiliares so entram depois que todos os produtos ja foram gravados:
  // se esta etapa falhar (tabela ausente, EAN invalido), a carga de produtos
  // deste caixa ja esta feita e o erro sobe identificando a etapa.
  if tabelaAuxiliarExiste then
  begin
    try
      gravarCodigosAuxiliares(listProduto);
    except
      on E:Exception do
      begin
        raise Exception.Create('Erro ao gravar codigos auxiliares no PDV: '+E.Message);
      end;
    end;
  end
  else
  begin
    uLogErro.LogErro('CARGA_PRODUTO_AUX_PDV',
      'Tabela ESTOQUE_COD_AUXILIAR nao encontrada no PDV - codigos auxiliares nao sincronizados');
  end;

  Result := True;
end;

end.
