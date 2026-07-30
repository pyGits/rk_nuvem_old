unit uDmProduto;

interface

uses
vcl.dialogs,
  System.SysUtils, System.Classes,Produto,Conexao, Data.DB, MemDS, DBAccess, Uni,System.Generics.collections,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,uConexao,
  FireDAC.Phys.IBDef, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.IB,Funcoes,
  uLogErro;

type
  TdmProduto = class(TDataModule)
    UniQuery1: TUniQuery;
    qrProdutoInsertUpdate: TUniQuery;
    qrProduto: TFDQuery;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
  private

  public
    function InsertProduto(listProduto:TObjectList<TProduto>):Boolean;
    function InsertProdutoBulk(produtos:TObjectList<TProduto>):Boolean;
  end;

var
  dmProduto: TdmProduto;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmProduto }

function TdmProduto.InsertProduto(listProduto:TObjectList<TProduto>): Boolean;
var
  I: Integer;
  oProduto:TProduto;
begin
  i :=0;
  qrProduto.Params.ArraySize := listProduto.Count;

  for oProduto in listProduto do
    begin
      with oProduto do
      begin
         qrProduto.Params.ParamByName('CODIGO').AsString := Codigo;
         qrProduto.ParamByName('CODIGO_BARRAS').AsString := CodigoBarras;
         qrProduto.ParamByName('DESCRICAO').AsString := Descricao;
         qrProduto.ParamByName('GRUPO').AsString := Grupo;
         qrProduto.ParamByName('SUBGRUPO').AsString := Subgrupo;
         qrProduto.ParamByName('FORNECEDOR').AsString := Fornecedor;
         qrProduto.ParamByName('Tributacao').AsString := Tributacao;
         qrProduto.ParamByName('NCM').AsString := NCM;
         qrProduto.ParamByName('CEST').AsString := CEST;
         qrProduto.ParamByName('Validade').AsString := Validade;//
         qrProduto.ParamByName('BALANCA').AsInteger := getBalanca;
         qrProduto.ParamByName('Fracionado').AsInteger := getFracionado;
         qrProduto.ParamByName('INATIVO').AsInteger := getInativo;
         qrProduto.ParamByName('DIVERSOS').AsInteger := getDiversos;
         qrProduto.ParamByName('CUSTO').AsFloat := Custo;
         qrProduto.ParamByName('PRECO').AsFloat := Preco;
         qrProduto.ParamByName('MARGEM').AsFloat := Margem;
         qrProduto.ParamByName('ESTOQUE').AsFloat := Estoque;
         qrProduto.ParamByName('Unidade').AsString := Unidade;
         qrProduto.ParamByName('DATA_ALTERADO').asDate := date;
         qrProduto.ParamByName('DATA_CADASTRO').asDate := date;
         qrProduto.ParamByName('PENDENTE').AsInteger := 1;
         qrProduto.ParamByName('ESTOQUE_MINIMO').AsFloat := estoqueMinimo;
         qrProduto.ParamByName('ESTOQUE_MAXIMO').AsFloat := estoqueMaximo;
         try
          qrProduto.ExecSQL;
         except
          on E:Exception do
          begin
            raise Exception.Create('Erro ao inserir produto: '+ e.Message + ' ' + Codigo);
          end;

         end;

         inc(i);
      end;


    end;
end;

function TdmProduto.InsertProdutoBulk(
  produtos: TObjectList<TProduto>): Boolean;
var
  Query:TFDquery;
  I:integer;
  validos:TList<TProduto>;
begin
  Result := False;

  // Todo item da lista vira uma linha do lote. Se um item vier nil ou sem
  // CODIGO, o slot correspondente do array de parametros fica sem valor e o
  // Firebird recusa o lote INTEIRO com "validation error for column CODIGO,
  // value *** null ***" - ou seja, um unico produto ruim derruba a carga toda.
  // Por isso a lista e filtrada antes de montar o lote e o que sobrou de fora
  // vai para o log, identificado.
  validos := TList<TProduto>.Create;
  try
    for i := 0 to produtos.Count - 1 do
    begin
      if not Assigned(produtos[i]) then
      begin
        uLogErro.LogErro('CARGA_PRODUTO_BULK',
          Format('Registro %d ignorado: produto nao foi montado a partir do json', [i]));
        Continue;
      end;

      if Trim(produtos[i].Codigo) = '' then
      begin
        uLogErro.LogErro('CARGA_PRODUTO_BULK',
          Format('Registro %d ignorado: produto sem codigo | descricao: %s | barras: %s',
            [i, produtos[i].Descricao, produtos[i].CodigoBarras]));
        Continue;
      end;

      validos.Add(produtos[i]);
    end;

    if validos.Count = 0 then
    begin
      if produtos.Count > 0 then
        uLogErro.LogErro('CARGA_PRODUTO_BULK',
          Format('Nenhum dos %d produtos recebidos tinha codigo valido', [produtos.Count]));
      Exit;
    end;

    Query := TConexao.GetInstance.CreateQuery;
    try
      Query.SQL.Text :=
        'UPDATE OR INSERT INTO PRODUTO (' +
        'CODIGO, CODIGO_BARRAS, DESCRICAO, GRUPO, SUBGRUPO, FORNECEDOR, TRIBUTACAO, NCM, CEST, VALIDADE, ' +
        'BALANCA, FRACIONADO, CUSTO, PRECO, MARGEM, ESTOQUE, UNIDADE, INATIVO, DIVERSOS, DATA_CADASTRO, ' +
        'DATA_ALTERADO, PENDENTE, ESTOQUE_MINIMO, ESTOQUE_MAXIMO,PRECO2,PRECO2_QTD) ' +
        'VALUES (' +
        ':CODIGO, :CODIGO_BARRAS, :DESCRICAO, :GRUPO, :SUBGRUPO, :FORNECEDOR, :TRIBUTACAO, :NCM, :CEST, :VALIDADE, ' +
        ':BALANCA, :FRACIONADO, :CUSTO, :PRECO, :MARGEM, :ESTOQUE, :UNIDADE, :INATIVO, :DIVERSOS, :DATA_CADASTRO, ' +
        ':DATA_ALTERADO, :PENDENTE, :ESTOQUE_MINIMO, :ESTOQUE_MAXIMO,:PRECO2,:PRECO2_QTD) MATCHING (CODIGO);';

      Query.Params.ArraySize := validos.Count;

      for i := 0 to validos.Count - 1 do
      begin
        Query.ParamByName('CODIGO').AsStrings[i]        := validos[i].Codigo;
        Query.ParamByName('CODIGO_BARRAS').AsStrings[i] := validos[i].CodigoBarras;
        Query.ParamByName('DESCRICAO').AsStrings[i]     := validos[i].Descricao;
        Query.ParamByName('GRUPO').AsStrings[i]         := validos[i].Grupo;
        Query.ParamByName('SUBGRUPO').AsStrings[i]      := validos[i].Subgrupo;
        Query.ParamByName('FORNECEDOR').AsStrings[i]    := validos[i].Fornecedor;
        Query.ParamByName('TRIBUTACAO').AsStrings[i]    := validos[i].Tributacao;
        Query.ParamByName('NCM').AsStrings[i]           := validos[i].NCM;
        Query.ParamByName('CEST').AsStrings[i]          := validos[i].CEST;
        Query.ParamByName('VALIDADE').AsStrings[i]      := validos[i].Validade;

        Query.ParamByName('BALANCA').AsIntegers[i]      := validos[i].getBalanca;
        Query.ParamByName('FRACIONADO').AsIntegers[i]   := validos[i].getFracionado;
        Query.ParamByName('INATIVO').AsIntegers[i]      := validos[i].getInativo;
        Query.ParamByName('DIVERSOS').AsIntegers[i]     := validos[i].getDiversos;

        Query.ParamByName('CUSTO').AsFloats[i]          := validos[i].Custo;
        Query.ParamByName('PRECO').AsFloats[i]          := validos[i].Preco;
        Query.ParamByName('MARGEM').AsFloats[i]         := validos[i].Margem;
        Query.ParamByName('ESTOQUE').AsFloats[i]        := validos[i].Estoque;

        Query.ParamByName('UNIDADE').AsStrings[i]       := validos[i].Unidade;
        Query.ParamByName('DATA_ALTERADO').AsDates[i]   := validos[i].DataAlterado;
        Query.ParamByName('DATA_CADASTRO').AsDates[i]   := validos[i].DataCadastro;
        Query.ParamByName('PENDENTE').AsIntegers[i]     := 1;
        Query.ParamByName('ESTOQUE_MINIMO').AsFloats[i] := validos[i].EstoqueMinimo;
        Query.ParamByName('ESTOQUE_MAXIMO').AsFloats[i] := validos[i].EstoqueMaximo;

        Query.ParamByName('PRECO2').AsFloats[i]         := validos[i].Preco2;
        Query.ParamByName('PRECO2_QTD').AsFloats[i]     := validos[i].Preco2_Qtd;
      end;

      Query.Execute(Query.Params.ArraySize, 0);
      Result := True;
    finally
      Query.Free;
    end;
  finally
    validos.Free;
  end;
end;

end.
