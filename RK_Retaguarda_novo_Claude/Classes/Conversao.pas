unit Conversao;

interface


type
  TPesquisar = (codigo,nome,telefone);
  TOperacao = (opNovo,opAlterar,opNavegar);
  TMenu = (mnProduto,mnExportar,mnImprimir,mnRelatorio,mnFinanceiro,sbClassificacao,sbRelCaixa,sbRelFuncionario,mnConfiguracoes,mnVendas,sbRelEstoque,sbRelVendas);
  TCarga = (cgAlterados,cgCompleta);
  TBalanca = (balToledo,balFilizola,balUPX,balItensMGV);
  TAuditoria = (tpInclusao,tpAlteracao,tpExclusao,tpTodos);
  TContasReceberStatus = (crAbertas,crRecebido,crVencer,crTodas);
  TTipoRelatorio = (relCupom,relProduto,relFinalizadora,relEstoque);
  TOrdenarRelatorio = (ordNome,ordCodigo,ordQuantidade);

implementation

end.
