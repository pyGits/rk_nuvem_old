unit DatabaseRepositoryImpl;

interface
uses System.Generics.Collections,uConexao,FireDAC.Comp.Client,System.SysUtils,system.Classes,MigrationModel,Helpers;

type IDatabaseRepository = interface
  ['{B6680101-86E7-4F1E-9CBA-9D3FF19DACDF}']
  function getVersion:integer;

   procedure executeMigration(migration: TMigrationModel);
  function getMigrations:TMigrationList;
end;


type TDatabaseRepositoryFirebird = class(TInterfacedObject,IDatabaseRepository)
  private
    function TableExists(tableName:string):boolean;
    function CreateColumn(tableName:string;columnName:string;columnType:string;isNull:string):string;
    function AlterColumnLength(tableName:string;columnName:string;newLength:integer):string;
    function CreateTable(tableName:string;colunaDefault:string):string;

    function CreateProcedure(const ProcName:string): string;
    function DropProcedure(const ProcName:string):string;

    function DropTrigger(const TriggerName:string):string;
    function CreateTrigger(const TriggerName:string):string;

    function CreatePrimaryKey(tableName:string;primaryKeys:string;constraintName:string):string;
    function CreateUniqueKey(tableName:string;uniqueKeys:string;constraintName:string):string;

    function CreateGenerator(const GeneratorName:string):string;

    function CreateIndex(tableName, indexName, columns: string; unique: Boolean = False): string;
    function SetNotNull(tableName, columnName: string): string;

    procedure FixDuplicateCodes(tableName:string;columnName:string;uniqueColumn:string);
    function RemoveDuplicateCodes(tableName:string;columnName:string;idColumn:string):string;


  public
    function getVersion: Integer;
    function getMigrations:TMigrationList;
    procedure executeMigration(migration: TMigrationModel);






end;


implementation

{ TDatabaseRepositoryFirebird }

function TDatabaseRepositoryFirebird.getMigrations: TMigrationList;
begin
result := TMigrationList.create;


// CARGA_EXCLUIR table
result.Add(CreateTable('CARGA_EXCLUIR','TABELA VARCHAR(50) NOT NULL'),1);
result.Add(CreateColumn('CARGA_EXCLUIR','CODIGO', 'VARCHAR(6)', 'NOT NULL'),2);
result.Add(SetNotNull('CARGA_EXCLUIR', 'TABELA'),3);
result.Add(SetNotNull('CARGA_EXCLUIR', 'CODIGO'),4);

// AUDITORIA table
result.Add(CreateTable('AUDITORIA','DATA_REGISTRO TIMESTAMP NOT NULL'),3);
result.Add(CreateColumn('AUDITORIA','USUARIO','VARCHAR(50)',''),4);
result.Add(CreateColumn('AUDITORIA','TABELA','VARCHAR(100)',''),5);
result.Add(CreateColumn('AUDITORIA','ALTERADO','BLOB SUB_TYPE 1 SEGMENT SIZE 16384',''),6);
result.Add(CreateColumn('AUDITORIA','TIPO','INTEGER',''),7);
result.Add(SetNotNull('AUDITORIA', 'DATA_REGISTRO'),8);

// CAIXA table
result.Add(CreateTable('CAIXA','CODIGO VARCHAR(6) NOT NULL'),8);
result.Add(CreateColumn('CAIXA','NOME','VARCHAR(30)',''),9);
result.Add(CreateColumn('CAIXA','IP','VARCHAR(20)',''),10);
result.Add(CreateColumn('CAIXA','ULTIMA_CARGA','TIMESTAMP',''),11);
result.Add(CreateColumn('CAIXA','RECEBIDO','CHAR(1)',''),12);
result.Add(SetNotNull('CAIXA', 'CODIGO'),13);

// CAIXA_FUNCOES table
result.Add(CreateTable('CAIXA_FUNCOES','CODIGO VARCHAR(6) CHARACTER SET ISO8859_1 NOT NULL'),13);
result.Add(CreateColumn('CAIXA_FUNCOES','ACFUNC','VARCHAR(3) CHARACTER SET ISO8859_1',''),14);
result.Add(CreateColumn('CAIXA_FUNCOES','FUNCDESC','VARCHAR(50) CHARACTER SET ISO8859_1',''),15);
result.Add(CreateColumn('CAIXA_FUNCOES','FUNCCAT','VARCHAR(20) CHARACTER SET ISO8859_1',''),16);
result.Add(CreateColumn('CAIXA_FUNCOES','FUNCNIV','VARCHAR(10) CHARACTER SET ISO8859_1',''),17);
result.Add(CreateColumn('CAIXA_FUNCOES','FUNCSOLIC','VARCHAR(5) CHARACTER SET ISO8859_1',''),18);
result.Add(SetNotNull('CAIXA_FUNCOES', 'CODIGO'),19);

// CARGA table
result.Add(CreateTable('CARGA','TABELA VARCHAR(50) NOT NULL'),19);
result.Add(CreateColumn('CARGA','CODIGO','VARCHAR(6)','NOT NULL'),20);
result.Add(SetNotNull('CARGA', 'TABELA'),21);
result.Add(SetNotNull('CARGA', 'CODIGO'),22);

// CEST table
result.Add(CreateTable('CEST','CEST VARCHAR(7) NOT NULL'),21);
result.Add(CreateColumn('CEST','NCM','CHAR(8)','NOT NULL'),22);
result.Add(CreateColumn('CEST','DESCRICAO','BLOB SUB_TYPE 1 SEGMENT SIZE 16384',''),23);
result.Add(SetNotNull('CEST', 'CEST'),24);
result.Add(SetNotNull('CEST', 'NCM'),25);

// CLIENTE table
result.Add(CreateTable('CLIENTE','CODIGO VARCHAR(6) NOT NULL'),24);
result.Add(CreateColumn('CLIENTE','NOME','VARCHAR(100)',''),25);
result.Add(CreateColumn('CLIENTE','NOME_FANTASIA','VARCHAR(80)',''),26);
result.Add(CreateColumn('CLIENTE','ENDERECO','VARCHAR(45)',''),27);
result.Add(CreateColumn('CLIENTE','NUMERO','VARCHAR(15)',''),28);
result.Add(CreateColumn('CLIENTE','BAIRRO','VARCHAR(50)',''),29);
result.Add(CreateColumn('CLIENTE','CIDADE','VARCHAR(40)',''),30);
result.Add(CreateColumn('CLIENTE','UF','CHAR(2)',''),31);
result.Add(CreateColumn('CLIENTE','CEP','VARCHAR(10)',''),32);
result.Add(CreateColumn('CLIENTE','COMPLEMENTO','VARCHAR(20)',''),33);
result.Add(CreateColumn('CLIENTE','TELEFONE1','VARCHAR(15)',''),34);
result.Add(CreateColumn('CLIENTE','TELEFONE2','VARCHAR(15)',''),35);
result.Add(CreateColumn('CLIENTE','CELULAR','CHAR(15)',''),36);
result.Add(CreateColumn('CLIENTE','EMAIL','VARCHAR(100)',''),37);
result.Add(CreateColumn('CLIENTE','CNPJCPF','VARCHAR(14)','NOT NULL'),38);
result.Add(CreateColumn('CLIENTE','OBSERVACAO','BLOB SUB_TYPE 1 SEGMENT SIZE 16384',''),39);
result.Add(CreateColumn('CLIENTE','DATA_CADASTRO','DATE',''),40);
result.Add(CreateColumn('CLIENTE','TIPO_PESSOA','INTEGER',''),41);
result.Add(CreateColumn('CLIENTE','CREDITO_LIMITE','NUMERIC(15,3)',''),42);
result.Add(CreateColumn('CLIENTE','CREDITO_UTILIZADO','NUMERIC(15,3)',''),43);
result.Add(CreateColumn('CLIENTE','DATA_NASCIMENTO','DATE',''),44);
result.Add(CreateColumn('CLIENTE','PERC_DESCONTO','NUMERIC(15,2) DEFAULT 0',''),45);
result.Add(SetNotNull('CLIENTE', 'CODIGO'),46);
result.Add(SetNotNull('CLIENTE', 'CNPJCPF'),47);

// CODIGO_AUXILIAR table
result.Add(CreateTable('CODIGO_AUXILIAR','CODIGO VARCHAR(6) NOT NULL'),46);
result.Add(CreateColumn('CODIGO_AUXILIAR','CODIGO_BARRAS','VARCHAR(14)','NOT NULL'),47);
result.Add(CreateColumn('CODIGO_AUXILIAR','CODIGO_AUXILIAR','VARCHAR(14)','NOT NULL'),48);
result.Add(SetNotNull('CODIGO_AUXILIAR', 'CODIGO'),49);
result.Add(SetNotNull('CODIGO_AUXILIAR', 'CODIGO_BARRAS'),50);
result.Add(SetNotNull('CODIGO_AUXILIAR', 'CODIGO_AUXILIAR'),51);

// CONFIGURACOES table
result.Add(CreateTable('CONFIGURACOES','ID VARCHAR(6) NOT NULL'),49);
result.Add(CreateColumn('CONFIGURACOES','PROD_CARGA_AUTO','INTEGER',''),50);
result.Add(CreateColumn('CONFIGURACOES','ETQ_VISUALIZAR','INTEGER',''),51);
result.Add(CreateColumn('CONFIGURACOES','ETQ_IMPRESSORA','VARCHAR(40)',''),52);
result.Add(CreateColumn('CONFIGURACOES','BAL_DIRETORIO','VARCHAR(200)',''),53);
result.Add(CreateColumn('CONFIGURACOES','PREVENDA_TERMINAL','VARCHAR(3)',''),54);
result.Add(CreateColumn('CONFIGURACOES','VALIDADE_DIAS_ALERTA','INTEGER',''),55);
result.Add(CreateColumn('CONFIGURACOES','BAL_DIGITOS','INTEGER',''),56);
result.Add(CreateColumn('CONFIGURACOES','IMPRESSORA_PORTA','VARCHAR(100)',''),57);
result.Add(CreateColumn('CONFIGURACOES','PDV_LIMITE_DESCONTO_PERC','FLOAT DEFAULT 0',''),58);
result.Add(CreateColumn('CONFIGURACOES','NFCE_IDTOKEN','VARCHAR(50)',''),59);
result.Add(CreateColumn('CONFIGURACOES','NFCE_TOKEN','VARCHAR(200)',''),60);
result.Add(CreateColumn('CONFIGURACOES','NFCE_DIRETORIO','VARCHAR(255)',''),61);
result.Add(CreateColumn('CONFIGURACOES','NFCE_SENHA','VARCHAR(50)',''),62);
result.Add(SetNotNull('CONFIGURACOES', 'ID'),63);

// CONTAS_RECEBER table
result.Add(CreateTable('CONTAS_RECEBER','CODIGO VARCHAR(50) NOT NULL'),63);
result.Add(CreateColumn('CONTAS_RECEBER','COD_CUPOM','VARCHAR(50)','NOT NULL'),64);
result.Add(CreateColumn('CONTAS_RECEBER','COD_VENDEDOR','INTEGER',''),65);
result.Add(CreateColumn('CONTAS_RECEBER','COD_CAIXA','INTEGER',''),66);
result.Add(CreateColumn('CONTAS_RECEBER','COD_CLIENTE','VARCHAR(6)',''),67);
result.Add(CreateColumn('CONTAS_RECEBER','DATA_EMISSAO','DATE',''),68);
result.Add(CreateColumn('CONTAS_RECEBER','DATA_VENCIMENTO','DATE',''),69);
result.Add(CreateColumn('CONTAS_RECEBER','DATA_PAGAMENTO','DATE',''),70);
result.Add(CreateColumn('CONTAS_RECEBER','VALOR','NUMERIC(15,3)',''),71);
result.Add(CreateColumn('CONTAS_RECEBER','VALOR_PAGO','NUMERIC(15,3)',''),72);
result.Add(CreateColumn('CONTAS_RECEBER','VALOR_DESCONTO','NUMERIC(15,3)',''),73);
result.Add(CreateColumn('CONTAS_RECEBER','VALOR_ACRESCIMO','NUMERIC(15,3)',''),74);
result.Add(CreateColumn('CONTAS_RECEBER','VALOR_RESTANTE','NUMERIC(15,3)',''),75);
result.Add(CreateColumn('CONTAS_RECEBER','SELECAO','INTEGER',''),76);
result.Add(CreateColumn('CONTAS_RECEBER','CANCELADO','INTEGER',''),77);
result.Add(CreateColumn('CONTAS_RECEBER','STATUS','INTEGER',''),78);
result.Add(SetNotNull('CONTAS_RECEBER', 'CODIGO'),79);
result.Add(SetNotNull('CONTAS_RECEBER', 'COD_CUPOM'),80);

// CONTAS_RECEBER_PAGAMENTO table
result.Add(CreateTable('CONTAS_RECEBER_PAGAMENTO','CODIGO VARCHAR(50) NOT NULL'),79);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','COD_CUPOM','VARCHAR(50)',''),80);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','DATA_PAGAMENTO','TIMESTAMP',''),81);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','FINALIZADORA','VARCHAR(3)',''),82);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','VALOR','NUMERIC(15,3)',''),83);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','VALOR_DESCONTO','NUMERIC(15,3)',''),84);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','VALOR_ACRESCIMO','NUMERIC(15,3)',''),85);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','PRESTACAO','INTEGER',''),86);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','COD_CAIXA','INTEGER',''),87);
result.Add(CreateColumn('CONTAS_RECEBER_PAGAMENTO','FUNCIONARIO','VARCHAR(6)',''),88);
result.Add(SetNotNull('CONTAS_RECEBER_PAGAMENTO', 'CODIGO'),89);

// CUPOM table
result.Add(CreateTable('CUPOM','CODIGO VARCHAR(50) NOT NULL'),89);
result.Add(CreateColumn('CUPOM','NUMERO','VARCHAR(12)','NOT NULL'),90);
result.Add(CreateColumn('CUPOM','DATA','DATE','NOT NULL'),91);
result.Add(CreateColumn('CUPOM','HORA','TIME','NOT NULL'),92);
result.Add(CreateColumn('CUPOM','QTDE_ITEM','INTEGER','NOT NULL'),93);
result.Add(CreateColumn('CUPOM','VALOR_DESCONTO','NUMERIC(15,2)','NOT NULL'),94);
result.Add(CreateColumn('CUPOM','VALOR_ACRESCIMO','NUMERIC(15,2)','NOT NULL'),95);
result.Add(CreateColumn('CUPOM','VALOR_TOTAL','NUMERIC(15,2)','NOT NULL'),96);
result.Add(CreateColumn('CUPOM','COD_CLIENTE','INTEGER',''),97);
result.Add(CreateColumn('CUPOM','CANCELADO','INTEGER','NOT NULL'),98);
result.Add(CreateColumn('CUPOM','CPF_CONSUMIDOR','VARCHAR(18)',''),99);
result.Add(CreateColumn('CUPOM','NOME_CONSUMIDOR','VARCHAR(40) CHARACTER SET ISO8859_1',''),100);
result.Add(CreateColumn('CUPOM','COD_VENDEDOR','INTEGER',''),101);
result.Add(CreateColumn('CUPOM','EX','INTEGER','NOT NULL'),102);
result.Add(CreateColumn('CUPOM','COD_CAIXA','INTEGER','NOT NULL'),103);
result.Add(CreateColumn('CUPOM','NUVEM','INTEGER',''),104);
result.Add(CreateColumn('CUPOM','XML_CHAVE','VARCHAR(45) CHARACTER SET ISO8859_1',''),105);
result.Add(CreateColumn('CUPOM','XML_CHAVE_CANCELAMENTO','VARCHAR(50) CHARACTER SET ISO8859_1',''),106);
result.Add(CreateColumn('CUPOM','VALOR_CUSTO','NUMERIC(15,2)',''),107);
result.Add(SetNotNull('CUPOM', 'CODIGO'),108);
result.Add(SetNotNull('CUPOM', 'NUMERO'),109);
result.Add(SetNotNull('CUPOM', 'DATA'),110);
result.Add(SetNotNull('CUPOM', 'HORA'),111);
result.Add(SetNotNull('CUPOM', 'QTDE_ITEM'),112);
result.Add(SetNotNull('CUPOM', 'VALOR_DESCONTO'),113);
result.Add(SetNotNull('CUPOM', 'VALOR_ACRESCIMO'),114);
result.Add(SetNotNull('CUPOM', 'VALOR_TOTAL'),115);
result.Add(SetNotNull('CUPOM', 'CANCELADO'),116);
result.Add(SetNotNull('CUPOM', 'EX'),117);
result.Add(SetNotNull('CUPOM', 'COD_CAIXA'),118);

// CUPOM_FORMA table
result.Add(CreateTable('CUPOM_FORMA','CODIGO VARCHAR(50) NOT NULL'),108);
result.Add(CreateColumn('CUPOM_FORMA','COD_CUPOM','VARCHAR(50)','NOT NULL'),109);
result.Add(CreateColumn('CUPOM_FORMA','FORMA','VARCHAR(30) CHARACTER SET ISO8859_1','NOT NULL'),110);
result.Add(CreateColumn('CUPOM_FORMA','VALOR','NUMERIC(15,2)','NOT NULL'),111);
result.Add(CreateColumn('CUPOM_FORMA','PRESTACAO','INTEGER','NOT NULL'),112);
result.Add(CreateColumn('CUPOM_FORMA','TIPO','VARCHAR(30) CHARACTER SET ISO8859_1','NOT NULL'),113);
result.Add(CreateColumn('CUPOM_FORMA','EX','INTEGER','NOT NULL'),114);
result.Add(CreateColumn('CUPOM_FORMA','COD','INTEGER',''),115);
result.Add(CreateColumn('CUPOM_FORMA','VALOR_TROCO','NUMERIC(15,2)',''),116);
result.Add(CreateColumn('CUPOM_FORMA','DATA','DATE',''),117);
result.Add(CreateColumn('CUPOM_FORMA','CANCELADO','INTEGER',''),118);
result.Add(CreateColumn('CUPOM_FORMA','COD_CAIXA','INTEGER',''),119);
result.Add(CreateColumn('CUPOM_FORMA','NUVEM','INTEGER',''),120);
result.Add(SetNotNull('CUPOM_FORMA', 'CODIGO'),121);
result.Add(SetNotNull('CUPOM_FORMA', 'COD_CUPOM'),122);
result.Add(SetNotNull('CUPOM_FORMA', 'FORMA'),123);
result.Add(SetNotNull('CUPOM_FORMA', 'VALOR'),124);
result.Add(SetNotNull('CUPOM_FORMA', 'PRESTACAO'),125);
result.Add(SetNotNull('CUPOM_FORMA', 'TIPO'),126);
result.Add(SetNotNull('CUPOM_FORMA', 'EX'),127);

// CUPOM_ITEM table
result.Add(CreateTable('CUPOM_ITEM','CODIGO VARCHAR(50) NOT NULL'),121);
result.Add(CreateColumn('CUPOM_ITEM','COD_CUPOM','VARCHAR(50)','NOT NULL'),122);
result.Add(CreateColumn('CUPOM_ITEM','ITEM','INTEGER','NOT NULL'),123);
result.Add(CreateColumn('CUPOM_ITEM','UNIDADE','VARCHAR(5)','NOT NULL'),124);
result.Add(CreateColumn('CUPOM_ITEM','QTDE','NUMERIC(15,4)','NOT NULL'),125);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_UNITARIO','NUMERIC(15,3)','NOT NULL'),126);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_DESCONTO','NUMERIC(15,2)','NOT NULL'),127);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_ACRESCIMO','NUMERIC(15,2)','NOT NULL'),128);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_TOTAL','NUMERIC(15,2)','NOT NULL'),129);
result.Add(CreateColumn('CUPOM_ITEM','CANCELADO','INTEGER','NOT NULL'),130);
result.Add(CreateColumn('CUPOM_ITEM','EX','INTEGER','NOT NULL'),131);
result.Add(CreateColumn('CUPOM_ITEM','DATA','DATE','NOT NULL'),132);
result.Add(CreateColumn('CUPOM_ITEM','COD_CAIXA','INTEGER','NOT NULL'),133);
result.Add(CreateColumn('CUPOM_ITEM','COD_PRODUTO','VARCHAR(6)',''),134);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_CUSTO','NUMERIC(15,2)',''),135);
result.Add(CreateColumn('CUPOM_ITEM','VALOR_CUSTO_TOTAL','NUMERIC(15,2)',''),136);
result.Add(CreateColumn('CUPOM_ITEM','NUVEM','INTEGER',''),137);
result.Add(CreateColumn('CUPOM_ITEM','MOTIVO_CANCELAMENTO','VARCHAR(3)',''),138);
result.Add(SetNotNull('CUPOM_ITEM', 'CODIGO'),139);
result.Add(SetNotNull('CUPOM_ITEM', 'COD_CUPOM'),140);
result.Add(SetNotNull('CUPOM_ITEM', 'ITEM'),141);
result.Add(SetNotNull('CUPOM_ITEM', 'UNIDADE'),142);
result.Add(SetNotNull('CUPOM_ITEM', 'QTDE'),143);
result.Add(SetNotNull('CUPOM_ITEM', 'VALOR_UNITARIO'),144);
result.Add(SetNotNull('CUPOM_ITEM', 'VALOR_DESCONTO'),145);
result.Add(SetNotNull('CUPOM_ITEM', 'VALOR_ACRESCIMO'),146);
result.Add(SetNotNull('CUPOM_ITEM', 'VALOR_TOTAL'),147);
result.Add(SetNotNull('CUPOM_ITEM', 'CANCELADO'),148);
result.Add(SetNotNull('CUPOM_ITEM', 'EX'),149);
result.Add(SetNotNull('CUPOM_ITEM', 'DATA'),150);
result.Add(SetNotNull('CUPOM_ITEM', 'COD_CAIXA'),151);

// ESTOQUE_MOVIMENTACAO table
result.Add(CreateTable('ESTOQUE_MOVIMENTACAO','ID INTEGER NOT NULL'),139);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','TIPO','INTEGER',''),140);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','QTDE','NUMERIC(15,3)',''),141);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','DATA','DATE',''),142);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','HORA','TIME',''),143);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','CODPRODUTO','VARCHAR(6) CHARACTER SET ISO8859_1',''),144);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','COD_CUPOM','VARCHAR(50)',''),145);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','ITEM','INTEGER',''),146);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','COD_FUNCIONARIO','VARCHAR(6)',''),147);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','ORIGEM','VARCHAR(30)',''),148);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','NUVEM','INTEGER',''),149);
result.Add(CreateColumn('ESTOQUE_MOVIMENTACAO','COD_CAIXA','INTEGER',''),150);
result.Add(SetNotNull('ESTOQUE_MOVIMENTACAO', 'ID'),151);

// ETIQUETA table
result.Add(CreateTable('ETIQUETA','ID INTEGER NOT NULL'),151);
result.Add(CreateColumn('ETIQUETA','CODIGO','VARCHAR(6)',''),152);
result.Add(CreateColumn('ETIQUETA','CODIGO_BARRAS','VARCHAR(14)',''),153);
result.Add(CreateColumn('ETIQUETA','PRODUTO','VARCHAR(80)',''),154);
result.Add(CreateColumn('ETIQUETA','UNIDADE','VARCHAR(3)',''),155);
result.Add(CreateColumn('ETIQUETA','PRECO','NUMERIC(15,3)',''),156);
result.Add(CreateColumn('ETIQUETA','VALIDADE','INTEGER',''),157);
result.Add(SetNotNull('ETIQUETA', 'ID'),158);

// ETIQUETA_LAYOUT table
result.Add(CreateTable('ETIQUETA_LAYOUT','CODIGO INTEGER NOT NULL'),158);
result.Add(CreateColumn('ETIQUETA_LAYOUT','NOME','VARCHAR(30)',''),159);
result.Add(CreateColumn('ETIQUETA_LAYOUT','ARQUIVO','VARCHAR(30)',''),160);
result.Add(SetNotNull('ETIQUETA_LAYOUT', 'CODIGO'),161);

// FECHAMENTO table
result.Add(CreateTable('FECHAMENTO','CODIGO VARCHAR(50) NOT NULL'),161);
result.Add(CreateColumn('FECHAMENTO','OPERADOR','VARCHAR(70)',''),162);
result.Add(CreateColumn('FECHAMENTO','DATA_ABERTURA','DATE',''),163);
result.Add(CreateColumn('FECHAMENTO','HORA_ABERTURA','TIME',''),164);
result.Add(CreateColumn('FECHAMENTO','DATA_FECHAMENTO','DATE',''),165);
result.Add(CreateColumn('FECHAMENTO','HORA_FECHAMENTO','TIME',''),166);
result.Add(CreateColumn('FECHAMENTO','VENDA_BRUTA','NUMERIC(15,3)',''),167);
result.Add(CreateColumn('FECHAMENTO','CANCELAMENTO_CUPOM','NUMERIC(15,3)',''),168);
result.Add(CreateColumn('FECHAMENTO','CANCELAMENTO_ITEM','NUMERIC(15,3)',''),169);
result.Add(CreateColumn('FECHAMENTO','DESCONTO_ITEM','NUMERIC(15,3)',''),170);
result.Add(CreateColumn('FECHAMENTO','DESCONTO_CUPOM','NUMERIC(15,3)',''),171);
result.Add(CreateColumn('FECHAMENTO','ACRESCIMO_CUPOM','NUMERIC(15,3)',''),172);
result.Add(CreateColumn('FECHAMENTO','VENDA_LIQUIDA','NUMERIC(15,3)',''),173);
result.Add(CreateColumn('FECHAMENTO','FUNDO_CAIXA','NUMERIC(15,3)',''),174);
result.Add(CreateColumn('FECHAMENTO','SANGRIA','NUMERIC(15,3)',''),175);
result.Add(CreateColumn('FECHAMENTO','TOTAIS','NUMERIC(15,3)',''),176);
result.Add(CreateColumn('FECHAMENTO','QTD_CUPONS_EFETIVADOS','INTEGER',''),177);
result.Add(CreateColumn('FECHAMENTO','QTD_CUPONS_CANCELADOS','INTEGER',''),178);
result.Add(CreateColumn('FECHAMENTO','EX','INTEGER',''),179);
result.Add(CreateColumn('FECHAMENTO','COD_OPERADOR','INTEGER',''),180);
result.Add(CreateColumn('FECHAMENTO','COD_CAIXA','INTEGER','NOT NULL'),181);
result.Add(CreateColumn('FECHAMENTO','NUVEM','INTEGER',''),182);
result.Add(SetNotNull('FECHAMENTO', 'CODIGO'),183);
result.Add(SetNotNull('FECHAMENTO', 'COD_CAIXA'),184);

// FECHAMENTO_FINALIZADORA table
result.Add(CreateTable('FECHAMENTO_FINALIZADORA','ID_FECHAMENTO VARCHAR(50) NOT NULL'),183);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','FZCOD','VARCHAR(3)','NOT NULL'),184);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_LIQUIDO','NUMERIC(15,2)',''),185);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_ENTRADA','NUMERIC(15,2)',''),186);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_TROCO','NUMERIC(15,2)',''),187);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_REFORCO','NUMERIC(15,2)',''),188);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_SANGRIA','NUMERIC(15,2)',''),189);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','EX','INTEGER',''),190);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','COD_CAIXA','INTEGER','NOT NULL'),191);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','NUVEM','INTEGER',''),192);
result.Add(CreateColumn('FECHAMENTO_FINALIZADORA','VALOR_CONFERENCIA','NUMERIC(15,2)',''),193);
result.Add(SetNotNull('FECHAMENTO_FINALIZADORA', 'ID_FECHAMENTO'),194);
result.Add(SetNotNull('FECHAMENTO_FINALIZADORA', 'FZCOD'),195);
result.Add(SetNotNull('FECHAMENTO_FINALIZADORA', 'COD_CAIXA'),196);

// FINALIZADORA table
result.Add(CreateTable('FINALIZADORA','CODIGO VARCHAR(3) NOT NULL'),194);
result.Add(CreateColumn('FINALIZADORA','DESCRICAO','VARCHAR(20)',''),195);
result.Add(CreateColumn('FINALIZADORA','ESPECIE','INTEGER',''),196);
result.Add(CreateColumn('FINALIZADORA','TIPO','CHAR(1)',''),197);
result.Add(CreateColumn('FINALIZADORA','CODIGO99','INTEGER',''),198);
result.Add(SetNotNull('FINALIZADORA', 'CODIGO'),199);

// FORNECEDOR table
result.Add(CreateTable('FORNECEDOR','CODIGO VARCHAR(6) NOT NULL'),199);
result.Add(CreateColumn('FORNECEDOR','NOME','VARCHAR(100)',''),200);
result.Add(CreateColumn('FORNECEDOR','NOME_FANTASIA','VARCHAR(80)',''),201);
result.Add(CreateColumn('FORNECEDOR','ENDERECO','VARCHAR(45)',''),202);
result.Add(CreateColumn('FORNECEDOR','NUMERO','VARCHAR(15)',''),203);
result.Add(CreateColumn('FORNECEDOR','BAIRRO','VARCHAR(50)',''),204);
result.Add(CreateColumn('FORNECEDOR','CIDADE','VARCHAR(40)',''),205);
result.Add(CreateColumn('FORNECEDOR','UF','CHAR(2)',''),206);
result.Add(CreateColumn('FORNECEDOR','CEP','VARCHAR(10)',''),207);
result.Add(CreateColumn('FORNECEDOR','COMPLEMENTO','VARCHAR(20)',''),208);
result.Add(CreateColumn('FORNECEDOR','TELEFONE1','VARCHAR(15)',''),209);
result.Add(CreateColumn('FORNECEDOR','TELEFONE2','VARCHAR(15)',''),210);
result.Add(CreateColumn('FORNECEDOR','CELULAR','CHAR(15)',''),211);
result.Add(CreateColumn('FORNECEDOR','EMAIL','VARCHAR(100)',''),212);
result.Add(CreateColumn('FORNECEDOR','CNPJCPF','VARCHAR(14)','NOT NULL'),213);
result.Add(CreateColumn('FORNECEDOR','IE','VARCHAR(20)',''),214);
result.Add(CreateColumn('FORNECEDOR','IM','VARCHAR(25)',''),215);
result.Add(CreateColumn('FORNECEDOR','OBSERVACAO','BLOB SUB_TYPE 1 SEGMENT SIZE 16384',''),216);
result.Add(CreateColumn('FORNECEDOR','CONTATO1','VARCHAR(50)',''),217);
result.Add(CreateColumn('FORNECEDOR','CONTATO2','VARCHAR(50)',''),218);
result.Add(SetNotNull('FORNECEDOR', 'CODIGO'),219);
result.Add(SetNotNull('FORNECEDOR', 'CNPJCPF'),220);

// FUNCIONARIO table
result.Add(CreateTable('FUNCIONARIO','CODIGO VARCHAR(6) NOT NULL'),219);
result.Add(CreateColumn('FUNCIONARIO','NOME','VARCHAR(100)',''),220);
result.Add(CreateColumn('FUNCIONARIO','APELIDO','VARCHAR(100)',''),221);
result.Add(CreateColumn('FUNCIONARIO','EMAIL','VARCHAR(100)',''),222);
result.Add(CreateColumn('FUNCIONARIO','CPF','VARCHAR(14)','NOT NULL'),223);
result.Add(CreateColumn('FUNCIONARIO','CARGO','INTEGER',''),224);
result.Add(CreateColumn('FUNCIONARIO','SENHA','VARCHAR(255)',''),225);
result.Add(CreateColumn('FUNCIONARIO','COMISSAO','NUMERIC(15,2)',''),226);
result.Add(SetNotNull('FUNCIONARIO', 'CODIGO'),227);
result.Add(SetNotNull('FUNCIONARIO', 'CPF'),228);

// GRUPO table
result.Add(CreateTable('GRUPO','CODIGO VARCHAR(6) NOT NULL'),227);
result.Add(CreateColumn('GRUPO','GRUPO','VARCHAR(40)',''),228);
result.Add(SetNotNull('GRUPO', 'CODIGO'),229);

// IBGE table
result.Add(CreateTable('IBGE','CODIBGE CHAR(5) CHARACTER SET ISO8859_1 NOT NULL'),229);
result.Add(CreateColumn('IBGE','CODIBGEUF','CHAR(2) CHARACTER SET ISO8859_1','NOT NULL'),230);
result.Add(CreateColumn('IBGE','CODIBGECID','VARCHAR(40) CHARACTER SET ISO8859_1',''),231);
result.Add(SetNotNull('IBGE', 'CODIBGE'),232);
result.Add(SetNotNull('IBGE', 'CODIBGEUF'),233);

// MAPEAMENTO_PRODUTO table
result.Add(CreateTable('MAPEAMENTO_PRODUTO','CODIGO VARCHAR(6) NOT NULL'),232);
result.Add(CreateColumn('MAPEAMENTO_PRODUTO','CODIGO_EXTERNO','VARCHAR(14)',''),233);
result.Add(SetNotNull('MAPEAMENTO_PRODUTO', 'CODIGO'),234);

// NAO_FISCAL table
result.Add(CreateTable('NAO_FISCAL','CODIGO VARCHAR(50) NOT NULL'),234);
result.Add(CreateColumn('NAO_FISCAL','DATA','DATE','NOT NULL'),235);
result.Add(CreateColumn('NAO_FISCAL','INDICE','VARCHAR(2)','NOT NULL'),236);
result.Add(CreateColumn('NAO_FISCAL','DESCRICAO','VARCHAR(30)','NOT NULL'),237);
result.Add(CreateColumn('NAO_FISCAL','VALOR','NUMERIC(15,2)','NOT NULL'),238);
result.Add(CreateColumn('NAO_FISCAL','HORA','TIME','NOT NULL'),239);
result.Add(CreateColumn('NAO_FISCAL','CODVENDEDOR','INTEGER',''),240);
result.Add(CreateColumn('NAO_FISCAL','FZCOD','VARCHAR(3)',''),241);
result.Add(CreateColumn('NAO_FISCAL','EX','INTEGER',''),242);
result.Add(CreateColumn('NAO_FISCAL','COD_CAIXA','INTEGER','NOT NULL'),243);
result.Add(CreateColumn('NAO_FISCAL','NUVEM','INTEGER',''),244);
result.Add(SetNotNull('NAO_FISCAL', 'CODIGO'),245);
result.Add(SetNotNull('NAO_FISCAL', 'DATA'),246);
result.Add(SetNotNull('NAO_FISCAL', 'INDICE'),247);
result.Add(SetNotNull('NAO_FISCAL', 'DESCRICAO'),248);
result.Add(SetNotNull('NAO_FISCAL', 'VALOR'),249);
result.Add(SetNotNull('NAO_FISCAL', 'HORA'),250);
result.Add(SetNotNull('NAO_FISCAL', 'COD_CAIXA'),251);

// NCM table
result.Add(CreateTable('NCM','NCM VARCHAR(8) NOT NULL'),245);
result.Add(CreateColumn('NCM','DESCRICAO','VARCHAR(100)',''),246);
result.Add(CreateColumn('NCM','NACIONAL','NUMERIC(15,2)',''),247);
result.Add(CreateColumn('NCM','ESTADUAL','NUMERIC(15,2)',''),248);
result.Add(SetNotNull('NCM', 'NCM'),249);

// NFCE_PENDENTE table
result.Add(CreateTable('NFCE_PENDENTE','CODIGO_CUPOM VARCHAR(50) NOT NULL'),249);
result.Add(CreateColumn('NFCE_PENDENTE','COD_CAIXA','INTEGER','NOT NULL'),250);
result.Add(CreateColumn('NFCE_PENDENTE','DATA','DATE','NOT NULL'),251);
result.Add(CreateColumn('NFCE_PENDENTE','HORA','TIME','NOT NULL'),252);
result.Add(CreateColumn('NFCE_PENDENTE','XML','BLOB SUB_TYPE 1 SEGMENT SIZE 80',''),253);
result.Add(CreateColumn('NFCE_PENDENTE','STATUS','VARCHAR(10)',''),254);
result.Add(CreateColumn('NFCE_PENDENTE','CHAVE','VARCHAR(50)','NOT NULL'),255);
result.Add(CreateColumn('NFCE_PENDENTE','TOTAL','NUMERIC(15,2)',''),256);
result.Add(CreateColumn('NFCE_PENDENTE','RETORNO','BLOB SUB_TYPE 1 SEGMENT SIZE 80',''),257);
result.Add(SetNotNull('NFCE_PENDENTE', 'CODIGO_CUPOM'),258);
result.Add(SetNotNull('NFCE_PENDENTE', 'COD_CAIXA'),259);
result.Add(SetNotNull('NFCE_PENDENTE', 'DATA'),260);
result.Add(SetNotNull('NFCE_PENDENTE', 'HORA'),261);
result.Add(SetNotNull('NFCE_PENDENTE', 'CHAVE'),262);

// PREVENDA table
result.Add(CreateTable('PREVENDA','CODIGO VARCHAR(12) NOT NULL'),258);
result.Add(CreateColumn('PREVENDA','COD_CUPOM','VARCHAR(50)',''),259);
result.Add(CreateColumn('PREVENDA','FUNCIONARIO','VARCHAR(6)',''),260);
result.Add(CreateColumn('PREVENDA','DATA','TIMESTAMP',''),261);
result.Add(CreateColumn('PREVENDA','COD_CLIENTE','VARCHAR(6)',''),262);
result.Add(CreateColumn('PREVENDA','VALOR_DESCONTO','NUMERIC(15,3)',''),263);
result.Add(CreateColumn('PREVENDA','VALOR_ACRESCIMO','NUMERIC(15,3)',''),264);
result.Add(CreateColumn('PREVENDA','VALOR_TOTAL','NUMERIC(15,3)',''),265);
result.Add(CreateColumn('PREVENDA','TERMINAL','VARCHAR(3)','NOT NULL'),266);
result.Add(CreateColumn('PREVENDA','CANCELADO','INTEGER',''),267);
result.Add(CreateColumn('PREVENDA','STATUS','VARCHAR(1)',''),268);
result.Add(SetNotNull('PREVENDA', 'CODIGO'),269);
result.Add(SetNotNull('PREVENDA', 'TERMINAL'),270);

// PREVENDA_ITEM table
result.Add(CreateTable('PREVENDA_ITEM','CODIGO_PREVENDA VARCHAR(12) NOT NULL'),269);
result.Add(CreateColumn('PREVENDA_ITEM','ITEM','INTEGER','NOT NULL'),270);
result.Add(CreateColumn('PREVENDA_ITEM','CODIGO_BARRAS','VARCHAR(14)',''),271);
result.Add(CreateColumn('PREVENDA_ITEM','VALOR_UNITARIO','NUMERIC(15,3)',''),272);
result.Add(CreateColumn('PREVENDA_ITEM','VALOR_DESCONTO','NUMERIC(15,3)',''),273);
result.Add(CreateColumn('PREVENDA_ITEM','VALOR_ACRESCIMO','NUMERIC(15,3)',''),274);
result.Add(CreateColumn('PREVENDA_ITEM','VALOR_TOTAL','NUMERIC(15,3)',''),275);
result.Add(CreateColumn('PREVENDA_ITEM','QTDE','NUMERIC(15,3)',''),276);
result.Add(CreateColumn('PREVENDA_ITEM','UNIDADE','VARCHAR(3)',''),277);
result.Add(CreateColumn('PREVENDA_ITEM','TERMINAL','VARCHAR(3)','NOT NULL'),278);
result.Add(SetNotNull('PREVENDA_ITEM', 'CODIGO_PREVENDA'),279);
result.Add(SetNotNull('PREVENDA_ITEM', 'ITEM'),280);
result.Add(SetNotNull('PREVENDA_ITEM', 'TERMINAL'),281);

// PREVENDA_ITEM_TEMP table
result.Add(CreateTable('PREVENDA_ITEM_TEMP','CODIGO_PREVENDA VARCHAR(12) NOT NULL'),279);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','ITEM','INTEGER','NOT NULL'),280);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','CODIGO_BARRAS','VARCHAR(14)',''),281);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','VALOR_UNITARIO','NUMERIC(15,3)',''),282);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','VALOR_DESCONTO','NUMERIC(15,3)',''),283);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','VALOR_ACRESCIMO','NUMERIC(15,3)',''),284);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','VALOR_TOTAL','NUMERIC(15,3)',''),285);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','QTDE','NUMERIC(15,3)',''),286);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','UNIDADE','VARCHAR(3)',''),287);
result.Add(CreateColumn('PREVENDA_ITEM_TEMP','TERMINAL','VARCHAR(3)','NOT NULL'),288);
result.Add(SetNotNull('PREVENDA_ITEM_TEMP', 'CODIGO_PREVENDA'),289);
result.Add(SetNotNull('PREVENDA_ITEM_TEMP', 'ITEM'),290);
result.Add(SetNotNull('PREVENDA_ITEM_TEMP', 'TERMINAL'),291);

// PRODUTO table
result.Add(CreateTable('PRODUTO','CODIGO VARCHAR(6) NOT NULL'),289);
result.Add(CreateColumn('PRODUTO','CODIGO_BARRAS','VARCHAR(14)','NOT NULL'),290);
result.Add(CreateColumn('PRODUTO','DESCRICAO','VARCHAR(80)',''),291);
result.Add(CreateColumn('PRODUTO','GRUPO','VARCHAR(6)',''),292);
result.Add(CreateColumn('PRODUTO','SUBGRUPO','VARCHAR(6)',''),293);
result.Add(CreateColumn('PRODUTO','FORNECEDOR','VARCHAR(6)',''),294);
result.Add(CreateColumn('PRODUTO','TRIBUTACAO','VARCHAR(3)',''),295);
result.Add(CreateColumn('PRODUTO','NCM','VARCHAR(8)',''),296);
result.Add(CreateColumn('PRODUTO','CEST','VARCHAR(7)',''),297);
result.Add(CreateColumn('PRODUTO','VALIDADE','VARCHAR(3)',''),298);
result.Add(CreateColumn('PRODUTO','BALANCA','INTEGER',''),299);
result.Add(CreateColumn('PRODUTO','FRACIONADO','INTEGER',''),300);
result.Add(CreateColumn('PRODUTO','CUSTO','NUMERIC(15,3)',''),301);
result.Add(CreateColumn('PRODUTO','PRECO','NUMERIC(15,3)',''),302);
result.Add(CreateColumn('PRODUTO','MARGEM','NUMERIC(15,3)',''),303);
result.Add(CreateColumn('PRODUTO','ESTOQUE','NUMERIC(15,3)',''),304);
result.Add(CreateColumn('PRODUTO','UNIDADE','VARCHAR(3)',''),305);
result.Add(CreateColumn('PRODUTO','INATIVO','INTEGER',''),306);
result.Add(CreateColumn('PRODUTO','DIVERSOS','INTEGER',''),307);
result.Add(CreateColumn('PRODUTO','DATA_CADASTRO','DATE',''),308);
result.Add(CreateColumn('PRODUTO','DATA_ALTERADO','DATE',''),309);
result.Add(CreateColumn('PRODUTO','PENDENTE','INTEGER',''),310);
result.Add(CreateColumn('PRODUTO','OBSERVACAO','VARCHAR(255)',''),311);
result.Add(CreateColumn('PRODUTO','ESTOQUE_MINIMO','NUMERIC(15,3)',''),312);
result.Add(CreateColumn('PRODUTO','ESTOQUE_MAXIMO','NUMERIC(15,3)',''),313);
result.Add(CreateColumn('PRODUTO','PRECO2','NUMERIC(15,2)',''),314);
result.Add(CreateColumn('PRODUTO','PRECO2_QTD','NUMERIC(15,0)',''),315);
result.Add(CreateColumn('PRODUTO','PRECO3','NUMERIC(15,2)',''),316);
result.Add(CreateColumn('PRODUTO','PRECO3_QTD','NUMERIC(15,2)',''),317);
result.Add(SetNotNull('PRODUTO', 'CODIGO'),318);
result.Add(SetNotNull('PRODUTO', 'CODIGO_BARRAS'),319);

// PROPRIO table
result.Add(CreateTable('PROPRIO','CODIGO VARCHAR(6) CHARACTER SET ISO8859_1 NOT NULL'),320);
result.Add(CreateColumn('PROPRIO','NOME','VARCHAR(80) CHARACTER SET ISO8859_1',''),321);
result.Add(CreateColumn('PROPRIO','FANTASIA','VARCHAR(80) CHARACTER SET ISO8859_1',''),322);
result.Add(CreateColumn('PROPRIO','ENDERECO','VARCHAR(80) CHARACTER SET ISO8859_1',''),323);
result.Add(CreateColumn('PROPRIO','BAIRRO','VARCHAR(50) CHARACTER SET ISO8859_1',''),324);
result.Add(CreateColumn('PROPRIO','CIDADE','VARCHAR(40) CHARACTER SET ISO8859_1',''),325);
result.Add(CreateColumn('PROPRIO','UF','VARCHAR(2) CHARACTER SET ISO8859_1',''),326);
result.Add(CreateColumn('PROPRIO','CEP','VARCHAR(10) CHARACTER SET ISO8859_1',''),327);
result.Add(CreateColumn('PROPRIO','TELEFONE','VARCHAR(30) CHARACTER SET ISO8859_1',''),328);
result.Add(CreateColumn('PROPRIO','CNPJCPF','VARCHAR(25) CHARACTER SET ISO8859_1',''),329);
result.Add(CreateColumn('PROPRIO','IE','VARCHAR(20) CHARACTER SET ISO8859_1',''),330);
result.Add(CreateColumn('PROPRIO','EMAIL','VARCHAR(80) CHARACTER SET ISO8859_1',''),331);
result.Add(CreateColumn('PROPRIO','RESPONSAVEL','VARCHAR(50) CHARACTER SET ISO8859_1',''),332);
result.Add(CreateColumn('PROPRIO','CELULAR','VARCHAR(20) CHARACTER SET ISO8859_1',''),333);
result.Add(CreateColumn('PROPRIO','LOGO','BLOB SUB_TYPE 0 SEGMENT SIZE 80',''),334);
result.Add(CreateColumn('PROPRIO','NUMERO','VARCHAR(10) CHARACTER SET ISO8859_1',''),335);
result.Add(CreateColumn('PROPRIO','COMPLEMENTO','VARCHAR(30) CHARACTER SET ISO8859_1',''),336);
result.Add(CreateColumn('PROPRIO','RG','VARCHAR(20) CHARACTER SET ISO8859_1',''),337);
result.Add(CreateColumn('PROPRIO','INSC_MUNICIPAL','VARCHAR(20) CHARACTER SET ISO8859_1',''),338);
result.Add(CreateColumn('PROPRIO','COD_MUNICIPIO_IBGE','VARCHAR(10) CHARACTER SET ISO8859_1',''),339);
result.Add(CreateColumn('PROPRIO','IBGE','VARCHAR(10) CHARACTER SET ISO8859_1',''),340);
result.Add(SetNotNull('PROPRIO', 'CODIGO'),341);

// RETAGUARDA_NIVEL table
result.Add(CreateTable('RETAGUARDA_NIVEL','CODIGO VARCHAR(6) NOT NULL'),342);
result.Add(CreateColumn('RETAGUARDA_NIVEL','ACFUNC','VARCHAR(3)',''),343);
result.Add(CreateColumn('RETAGUARDA_NIVEL','FUNCDESC','VARCHAR(50)',''),344);
result.Add(CreateColumn('RETAGUARDA_NIVEL','FUNCCAT','VARCHAR(20)',''),345);
result.Add(CreateColumn('RETAGUARDA_NIVEL','FUNCNIV','VARCHAR(10)',''),346);
result.Add(CreateColumn('RETAGUARDA_NIVEL','FUNCSOLIC','VARCHAR(5)',''),347);
result.Add(SetNotNull('RETAGUARDA_NIVEL', 'CODIGO'),348);

// SUBGRUPO table
result.Add(CreateTable('SUBGRUPO','CODIGO VARCHAR(6) NOT NULL'),349);
result.Add(CreateColumn('SUBGRUPO','CODIGO_GRUPO','VARCHAR(6)','NOT NULL'),350);
result.Add(CreateColumn('SUBGRUPO','SUBGRUPO','VARCHAR(40)',''),351);
result.Add(SetNotNull('SUBGRUPO', 'CODIGO'),352);
result.Add(SetNotNull('SUBGRUPO', 'CODIGO_GRUPO'),353);

// TRIBUTACAO table
result.Add(CreateTable('TRIBUTACAO','CODIGO VARCHAR(3) NOT NULL'),354);
result.Add(CreateColumn('TRIBUTACAO','DESCRICAO','VARCHAR(20)',''),355);
result.Add(CreateColumn('TRIBUTACAO','CST','VARCHAR(3)',''),356);
result.Add(CreateColumn('TRIBUTACAO','CFOP','VARCHAR(4)',''),357);
result.Add(CreateColumn('TRIBUTACAO','CSOSN','VARCHAR(3)',''),358);
result.Add(CreateColumn('TRIBUTACAO','ST','VARCHAR(1)',''),359);
result.Add(CreateColumn('TRIBUTACAO','ICMS','NUMERIC(15,0)',''),360);
result.Add(SetNotNull('TRIBUTACAO', 'CODIGO'),361);

// VALIDADE table
result.Add(CreateTable('VALIDADE','ID INTEGER NOT NULL'),362);
result.Add(CreateColumn('VALIDADE','CODIGO_PRODUTO','VARCHAR(6)','NOT NULL'),363);
result.Add(CreateColumn('VALIDADE','LOCALIZACAO','VARCHAR(40)',''),364);
result.Add(CreateColumn('VALIDADE','QUANTIDADE','NUMERIC(15,3)',''),365);
result.Add(CreateColumn('VALIDADE','VALIDADE','DATE',''),366);
result.Add(CreateColumn('VALIDADE','SITUACAO','INTEGER',''),367);
result.Add(CreateColumn('VALIDADE','DIAS_VENCER','INTEGER',''),368);
result.Add(CreateColumn('VALIDADE','DATA_ENTRADA','DATE',''),369);
result.Add(CreateColumn('VALIDADE','SELECIONADO','INTEGER',''),370);
result.Add(CreateColumn('VALIDADE','PROXIMO_VENCIMENTO','INTEGER',''),371);
result.Add(CreateColumn('VALIDADE','LOTE','VARCHAR(200)',''),372);
result.Add(SetNotNull('VALIDADE', 'ID'),373);
result.Add(SetNotNull('VALIDADE', 'CODIGO_PRODUTO'),374);


// registros duplicados em produto
RESULT.Add(CreateIndex('PRODUTO','IDX_CODIGO_BARRAS','CODIGO_BARRAS'),375);
RESULT.Add(CreateIndex('PRODUTO','IDX_CODIGO','CODIGO'),375);

Result.add(RemoveDuplicateCodes('PRODUTO','CODIGO_BARRAS','CODIGO'),375);
Result.add(RemoveDuplicateCodes('PRODUTO','CODIGO','CODIGO_BARRAS'),375);




// Primary key constraints
result.Add(CreatePrimaryKey('CAIXA', 'CODIGO','PK_CAIXA'), 375);
result.Add(CreatePrimaryKey('CAIXA_FUNCOES', 'CODIGO','PK_CAIXA_FUNCOES'), 376);
result.Add(CreatePrimaryKey('CARGA', 'TABELA,CODIGO','PK_CARGA_1'), 377);
result.Add(CreatePrimaryKey('CARGA_EXCLUIR', 'TABELA,CODIGO','PK_CARGA_EXCLUIR_1'), 378);
result.Add(CreatePrimaryKey('CEST', 'CEST,NCM','PK_CEST_1'), 379);
result.Add(CreatePrimaryKey('CLIENTE', 'CODIGO,CNPJCPF','PK_CLIENTE'), 380);
result.Add(CreatePrimaryKey('CODIGO_AUXILIAR', 'CODIGO,CODIGO_BARRAS,CODIGO_AUXILIAR','PK_CODIGO_AUXILIAR'), 381);
result.Add(CreatePrimaryKey('CONFIGURACOES', 'ID','PK_CONFIGURACOES'), 382);
result.Add(CreatePrimaryKey('CONTAS_RECEBER', 'CODIGO,COD_CUPOM','PK_CONTAS_RECEBER'), 383);
result.Add(CreatePrimaryKey('CONTAS_RECEBER_PAGAMENTO', 'CODIGO','PK_CONTAS_RECEBER_PAGAMENTO'), 384);
result.Add(CreatePrimaryKey('CUPOM', 'CODIGO,DATA,COD_CAIXA','PK_CUPOM_1'), 385);
result.Add(CreatePrimaryKey('CUPOM_FORMA', 'COD_CUPOM,PRESTACAO','PK_CUPOM_FORMA_1'), 386);
result.Add(CreatePrimaryKey('CUPOM_ITEM', 'CODIGO,DATA,COD_CAIXA','PK_CUPOM_ITEM_1'), 387);
result.Add(CreatePrimaryKey('ESTOQUE_MOVIMENTACAO', 'ID','PK_ESTOQUE_MOVIMENTACAO_1'), 388);
result.Add(CreatePrimaryKey('ETIQUETA', 'ID','PK_ETIQUETA'), 389);
result.Add(CreatePrimaryKey('ETIQUETA_LAYOUT', 'CODIGO','PK_ETIQUETA_LAYOUT'), 390);
//result.Add(CreatePrimaryKey('FECHAMENTO', 'CODIGO,COD_CAIXA','PK_FECHAMENTO'), 391);
result.Add(CreatePrimaryKey('FECHAMENTO_FINALIZADORA', 'ID_FECHAMENTO,FZCOD,COD_CAIXA','PK_FECHAMENTO_FINALIZADORA_1'), 392);
result.Add(CreatePrimaryKey('FINALIZADORA', 'CODIGO','PK_FINALIZADORA_1'), 393);
result.Add(CreatePrimaryKey('FORNECEDOR', 'CODIGO,CNPJCPF','PK_FORNECEDOR'), 394);
result.Add(CreatePrimaryKey('FUNCIONARIO', 'CODIGO,CPF','PK_FUNCIONARIO_1'), 395);
result.Add(CreatePrimaryKey('GRUPO', 'CODIGO','PK_GRUPO_1'), 396);
//result.Add(CreatePrimaryKey('IBGE', 'CODIBGE,CODIBGEUF','INTEG_5'), 397);
result.Add(CreatePrimaryKey('MAPEAMENTO_PRODUTO', 'CODIGO','PK_MAPEAMENTO_PRODUTO'), 398);
result.Add(CreatePrimaryKey('NAO_FISCAL', 'CODIGO,COD_CAIXA','PK_NAO_FISCAL'), 399);
result.Add(CreatePrimaryKey('NCM', 'NCM','PK_NCM_1'), 400);
result.Add(CreatePrimaryKey('NFCE_PENDENTE', 'CODIGO_CUPOM,COD_CAIXA,DATA,CHAVE','PK_NFCE_PENDENTE_1'), 401);
result.Add(CreatePrimaryKey('PREVENDA', 'CODIGO','PK_PREVENDA_1'), 402);
result.Add(CreatePrimaryKey('PREVENDA_ITEM', 'CODIGO_PREVENDA,ITEM,TERMINAL','PK_PREVENDA_ITEM_1'), 403);
result.Add(CreatePrimaryKey('PREVENDA_ITEM_TEMP', 'CODIGO_PREVENDA,ITEM,TERMINAL','PK_PREVENDA_ITEM_TEMP_1'), 404);
result.Add(CreatePrimaryKey('PRODUTO', 'CODIGO,CODIGO_BARRAS','PK_PRODUTO_1'), 405);
result.Add(CreatePrimaryKey('PROPRIO', 'CODIGO','PK_PROPRIO'), 406);
result.Add(CreatePrimaryKey('RETAGUARDA_NIVEL', 'CODIGO','PK_RETAGUARDA_NIVEL'), 407);
result.Add(CreatePrimaryKey('SUBGRUPO', 'CODIGO,CODIGO_GRUPO','PK_SUBGRUPO_1'), 408);
result.Add(CreatePrimaryKey('TRIBUTACAO', 'CODIGO','PK_TRIBUTACAO_1'), 409);
result.Add(CreatePrimaryKey('VALIDADE', 'ID','PK_VALIDADE'), 410);

// Unique keys
result.Add(CreateUniqueKey('CLIENTE', 'CODIGO','UNQ1_CLIENTE'), 411);
result.Add(CreateUniqueKey('PRODUTO','CODIGO_BARRAS', 'UNQ1_PRODUTO'), 412);
result.Add(CreateUniqueKey('PRODUTO', 'CODIGO','UNQ2_PRODUTO'), 413);

// procedures
result.Add(DropProcedure('ST_CONTAS_RECEBER'),414);
result.Add(CreateProcedure('ST_CONTAS_RECEBER'),415);

result.Add(DropProcedure('ST_CUPOM_FORMA_INSERT'),416);
result.Add(CreateProcedure('ST_CUPOM_FORMA_INSERT'),417);

result.Add(DropProcedure('ST_CUPOM_INSERT'),418);
result.Add(CreateProcedure('ST_CUPOM_INSERT'),419);

result.Add(DropProcedure('ST_CUPOM_ITEM_INSERT'),420);
result.Add(CreateProcedure('ST_CUPOM_ITEM_INSERT'),421);

result.Add(DropProcedure('ST_ESTOQUE_MOVIMENTACAO'),422);
result.Add(CreateProcedure('ST_ESTOQUE_MOVIMENTACAO'),423);

result.Add(DropProcedure('ST_NAO_FISCAL'),424);
result.Add(CreateProcedure('ST_NAO_FISCAL'),425);

result.Add(CreateGenerator('GEN_ETIQUETA_CONFIGURACAO'),426);

result.Add(CreateGenerator('GEN_VALIDADE'),427);

result.Add(CreateGenerator('GEN_ESTOQUE_MOVIMENTACAO'),428);

result.Add(CreateGenerator('GEN_ETIQUETA'),429);

// Drop and create triggers
result.Add(DropTrigger('TRIG_ETIQUETA_LAYOUT_1'),430);
result.Add(CreateTrigger('TRIG_ETIQUETA_LAYOUT_1'),431);

result.Add(DropTrigger('TRIG_VALIDADE_1'),432);
result.Add(CreateTrigger('TRIG_VALIDADE_1'),433);

result.Add(DropTrigger('CONTAS_RECEBER_AIU0'),434);
result.Add(CreateTrigger('CONTAS_RECEBER_AIU0'),435);

result.Add(DropTrigger('ATUALIZAR_SALDO'),436);
result.Add(CreateTrigger('ATUALIZAR_SALDO'),437);

result.Add(DropTrigger('TRIG_CONTAS_RECEBER_1'),438);
result.Add(CreateTrigger('TRIG_CONTAS_RECEBER_1'),439);

result.Add(DropTrigger('GENERATOR'),440);
result.Add(CreateTrigger('GENERATOR'),441);

result.Add(DropTrigger('TRIG_ETIQUETA_1'),442);
result.Add(CreateTrigger('TRIG_ETIQUETA_1'),443);

result.Add(CreateIndex('CUPOM_ITEM', 'IDX_CUPOM_ITEM_1', 'COD_PRODUTO'),444);
result.Add(CreateIndex('CUPOM_ITEM', 'IDX_CUPOM_ITEM_2', 'VALOR_TOTAL'),445);
result.Add(CreateIndex('CUPOM_ITEM', 'IDX_CUPOM_ITEM_3', 'DATA'),446);
result.Add(CreateIndex('CUPOM_ITEM', 'IDX_CUPOM_ITEM_4', 'CANCELADO'),447);
result.Add(CreateIndex('CUPOM_FORMA', 'IDX_CUPOM_FORMA_1', 'CODIGO, COD_CAIXA, DATA'),448);

result.Add(CreateColumn('CONFIGURACOES','ETIQUETA_MODO_IMPORTACAO','INTEGER',''),449);
result.Add(CreateColumn('CONFIGURACOES','SYSPDV_IP','VARCHAR(80)',''),450);


result.Add(CreateColumn('CLIENTE','UTILIZA_PRECO2','INTEGER',''),451);

result.Add(CreateIndex('CONTAS_RECEBER', 'IDX_CONTAS_RECEBER_CANCELADO', 'CANCELADO'),452);

// GARANTIR COLUNA OPERADOR DA TABELA FECHAMENTO VARCHAR60 -> VARCHAR70 (cliente ultrapassou 60 caracteres)
result.Add(AlterColumnLength('FECHAMENTO','OPERADOR',70),453);
end;


procedure TDatabaseRepositoryFirebird.executeMigration(migration: TMigrationModel);
  var
    query:TFDQuery;
begin
query := TConexao.GetInstance.CreateQuery('');
if migration.sql <> '' then
begin
query.SQL.Clear;
query.SQL.Text := migration.sql;
query.ExecSQL;
end;


query.SQL.Clear;
query.SQL.Add('UPDATE VERSAO SET VALOR = :VALOR');
query.Params.ParamByName('VALOR').AsInteger := migration.versao;
query.ExecSQL;

end;


procedure TDatabaseRepositoryFirebird.FixDuplicateCodes(tableName,
  columnName: string;uniqueColumn:string);
var
  query:TFDQuery;
  queryUpdate:TFDQuery;
  queryMaximo:TFDQuery;
  codigosDuplicados:TStringList;
  codigoMaximo:integer;
  codigo:string;
begin
  query := TConexao.GetInstance.CreateQuery('');
  queryUpdate := TConexao.GetInstance.CreateQuery('');
  queryMaximo :=TConexao.GetInstance.CreateQuery('');

  query.SQL.Clear;
  query.sql.Add('SELECT '+columnName+' as duplicados from '+tableName+ ' group by '+columnName+' having count(*) > 1');
  query.Open;

  if query.RecordCount = 0 then exit;


  queryMaximo.SQL.Clear;
  querymaximo.SQL.Add('select max('+columnName+') from '+ tableName);
  queryMaximo.Open;


  codigoMaximo := queryMaximo.FieldByName('MAX').AsInteger +1;


  codigosDuplicados := TStringList.Create;




  while not query.Eof do
  begin
    codigosDuplicados.Add(query.FieldByName('DUPLICADOS').AsString);
    query.Next
  end;
  // atualizar duplicados para um sequencial novo

  for codigo in codigosDuplicados do
  begin
  query.SQL.Clear;
  query.SQL.Add('select * from '+tableName+ ' where '+columnName+' = :CODIGO');
  query.ParamByName('CODIGO').AsString := codigo;

  query.Open;

    while not query.Eof do
    begin
      queryUpdate.SQL.Clear;
      queryUpdate.SQL.Add('update '+tableName+ ' set '+columnName+' = :NOVO_CODIGO where '+columnName+' = :CODIGO and '+uniqueColumn+' = :COLUNA_UNICA');
      queryUpdate.ParamByName('NOVO_CODIGO').AsString := codigoMaximo.ZeroEsquerda(0); // HELPER ZERO A ESQUERDA ?
      queryUpdate.ParamByName('CODIGO').AsString := codigo;
      queryUpdate.ParamByName('COLUNA_UNICA').AsString := query.FieldByName(uniqueColumn).AsString;
      queryUpdate.ExecSQL;

      Inc(codigoMaximo);
      query.next;
    end;


  end;


end;

function TDatabaseRepositoryFirebird.CreateColumn(tableName, columnName,
  columnType, isNull: string): string;
var
  qry: TFDQuery;
  fieldExists: Boolean;
begin
  qry := TConexao.GetInstance.CreateQuery('');
  try
    qry.SQL.Text :=
      'SELECT 1 FROM RDB$RELATION_FIELDS ' +
      'WHERE RDB$RELATION_NAME = :TABELA ' +
      '  AND RDB$FIELD_NAME = :CAMPO';
    qry.ParamByName('TABELA').AsString := UpperCase(tableName);
    qry.ParamByName('CAMPO').AsString := UpperCase(columnName);
    qry.Open;

    fieldExists := not qry.IsEmpty;

    if not fieldExists then
      Result := Format('ALTER TABLE %s ADD %s %s %s;', [tableName, columnName, columnType, isNull])
    else
      Result := ''; // já existe → não faz nada

  finally
    qry.Free;
  end;
end;


function TDatabaseRepositoryFirebird.AlterColumnLength(tableName, columnName: string; newLength: integer): string;
var
  qry: TFDQuery;
  currentLength: integer;
  fieldType: integer;
begin
  Result := '';
  qry := TConexao.GetInstance.CreateQuery('');
  try
    qry.SQL.Text :=
      'SELECT F.RDB$CHARACTER_LENGTH, F.RDB$FIELD_LENGTH, F.RDB$FIELD_TYPE ' +
      'FROM RDB$RELATION_FIELDS RF ' +
      'JOIN RDB$FIELDS F ON RF.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ' +
      'WHERE RF.RDB$RELATION_NAME = :TABELA ' +
      '  AND RF.RDB$FIELD_NAME = :CAMPO';
    qry.ParamByName('TABELA').AsString := UpperCase(tableName);
    qry.ParamByName('CAMPO').AsString := UpperCase(columnName);
    qry.Open;

    if qry.IsEmpty then Exit; // coluna nao existe ainda, quem cria e o CreateColumn

    fieldType := qry.FieldByName('RDB$FIELD_TYPE').AsInteger;

    // RDB$FIELD_LENGTH e em bytes (varia com o charset); RDB$CHARACTER_LENGTH e a
    // contagem de caracteres declarada no VARCHAR(n)/CHAR(n) e e o que precisa ser
    // comparado com newLength. Se vier NULL (charset NONE em bancos antigos), cai
    // para RDB$FIELD_LENGTH, que nesse caso equivale a 1 byte por caractere.
    if not qry.FieldByName('RDB$CHARACTER_LENGTH').IsNull then
      currentLength := qry.FieldByName('RDB$CHARACTER_LENGTH').AsInteger
    else
      currentLength := qry.FieldByName('RDB$FIELD_LENGTH').AsInteger;

    if (fieldType <> 14) and (fieldType <> 37) then Exit; // nao e CHAR/VARCHAR

    if currentLength >= newLength then Exit; // ja esta no tamanho igual ou maior

    Result := Format('ALTER TABLE %s ALTER COLUMN %s TYPE VARCHAR(%d);', [tableName, columnName, newLength]);
  finally
    qry.Free;
  end;
end;

function TDatabaseRepositoryFirebird.CreateProcedure(const ProcName: string): string;
var
  dropSQL, createSQL: string;
begin
  if ProcName = 'ST_CONTAS_RECEBER' then
  begin
  createSQL :=
    'CREATE PROCEDURE ST_CONTAS_RECEBER(' +
    'CODIGO VARCHAR(50), ' +
    'COD_CUPOM VARCHAR(50), ' +
    'COD_VENDEDOR INTEGER, ' +
    'COD_CAIXA INTEGER, ' +
    'COD_CLIENTE VARCHAR(6), ' +
    'DATA_EMISSAO DATE, ' +
    'DATA_VENCIMENTO DATE, ' +
    'DATA_PAGAMENTO DATE, ' +
    'VALOR NUMERIC(15,2), ' +
    'VALOR_PAGO NUMERIC(15,2), ' +
    'VALOR_DESCONTO NUMERIC(15,2), ' +
    'VALOR_ACRESCIMO NUMERIC(15,2), ' +
    'VALOR_RESTANTE NUMERIC(15,2), ' +
    'CANCELADO INTEGER, ' +
    'STATUS INTEGER)' +
    ' AS ' +
    'BEGIN ' +
    '  UPDATE OR INSERT INTO CONTAS_RECEBER (CODIGO, COD_CUPOM, COD_VENDEDOR, COD_CAIXA, COD_CLIENTE, ' +
    'DATA_EMISSAO, DATA_VENCIMENTO, DATA_PAGAMENTO, VALOR, VALOR_PAGO, VALOR_DESCONTO, VALOR_ACRESCIMO, ' +
    'VALOR_RESTANTE, CANCELADO, STATUS) ' +
    'VALUES (:CODIGO, :COD_CUPOM, :COD_VENDEDOR, :COD_CAIXA, :COD_CLIENTE, :DATA_EMISSAO, :DATA_VENCIMENTO, ' +
    ':DATA_PAGAMENTO, :VALOR, :VALOR_PAGO, :VALOR_DESCONTO, :VALOR_ACRESCIMO, :VALOR_RESTANTE, :CANCELADO, 0); ' +
    'END;';
  end;
  //// ================== PROCEDURES
//
  if ProcName = 'ST_CUPOM_FORMA_INSERT' then
  begin
  createSQL :=
  'CREATE PROCEDURE ST_CUPOM_FORMA_INSERT(' +
  'CODIGO VARCHAR(50), ' +
  'COD_CUPOM VARCHAR(50), ' +
  'FORMA VARCHAR(30), ' +
  'VALOR NUMERIC(15,2), ' +
  'PRESTACAO INTEGER, ' +
  'TIPO VARCHAR(30), ' +
  'VALOR_TROCO NUMERIC(15,2), ' +
  'DATA DATE, ' +
  'CANCELADO INTEGER, ' +
  'EX INTEGER, ' +
  'COD_CAIXA INTEGER, ' +
  'NUVEM INTEGER)' +
  ' AS ' +
  'BEGIN ' +
  'UPDATE OR INSERT INTO CUPOM_FORMA (CODIGO, COD_CUPOM, FORMA, VALOR, PRESTACAO, TIPO, VALOR_TROCO, DATA, CANCELADO, EX, COD_CAIXA, NUVEM) ' +
  'VALUES (:CODIGO, :COD_CUPOM, :FORMA, :VALOR, :PRESTACAO, :TIPO, :VALOR_TROCO, :DATA, :CANCELADO, :EX, :COD_CAIXA, 0); ' +
  'SUSPEND; ' +
  'END;';
  end;


    if ProcName = 'ST_CUPOM_INSERT' then
  begin

  createSQL:=
  'CREATE PROCEDURE ST_CUPOM_INSERT(' +
  'CODIGO VARCHAR(50), ' +
  'NUMERO VARCHAR(12), ' +
  'DATA DATE, ' +
  'HORA TIME, ' +
  'QTDE_ITEM INTEGER, ' +
  'VALOR_DESCONTO NUMERIC(15,2), ' +
  'VALOR_ACRESCIMO NUMERIC(15,2), ' +
  'VALOR_TOTAL NUMERIC(15,2), ' +
  'COD_CLIENTE INTEGER, ' +
  'CANCELADO INTEGER, ' +
  'CPF_CONSUMIDOR VARCHAR(20), ' +
  'NOME_CONSUMIDOR VARCHAR(40), ' +
  'COD_VENDEDOR INTEGER, ' +
  'EX INTEGER, ' +
  'COD_CAIXA INTEGER, ' +
  'NUVEM INTEGER, ' +
  'XML_CHAVE VARCHAR(45), ' +
  'XML_CHAVE_CANCELAMENTO VARCHAR(50), ' +
  'VALOR_CUSTO NUMERIC(15,2)) ' +
  'AS ' +
  'BEGIN ' +
  'UPDATE OR INSERT INTO CUPOM (CODIGO, NUMERO, DATA, HORA, QTDE_ITEM, VALOR_DESCONTO, VALOR_ACRESCIMO, VALOR_TOTAL, COD_CLIENTE, ' +
  ' CANCELADO, CPF_CONSUMIDOR, NOME_CONSUMIDOR, COD_VENDEDOR, EX, COD_CAIXA, NUVEM, XML_CHAVE, XML_CHAVE_CANCELAMENTO, VALOR_CUSTO) ' +
  'VALUES (:CODIGO, :NUMERO, :DATA, :HORA, :QTDE_ITEM, :VALOR_DESCONTO, :VALOR_ACRESCIMO, :VALOR_TOTAL, :COD_CLIENTE, ' +
  ':CANCELADO, :CPF_CONSUMIDOR, :NOME_CONSUMIDOR, :COD_VENDEDOR, :EX, :COD_CAIXA, :NUVEM, :XML_CHAVE, :XML_CHAVE_CANCELAMENTO, :VALOR_CUSTO); ' +
  'SUSPEND; ' +
  'END;';
  end;


  if ProcName = 'ST_CUPOM_ITEM_INSERT' then
  begin
createSQL :=
  'CREATE PROCEDURE ST_CUPOM_ITEM_INSERT(' +
  'CODIGO VARCHAR(50), ' +
  'COD_CUPOM VARCHAR(50), ' +
  'ITEM INTEGER, ' +
  'COD_PRODUTO VARCHAR(6), ' +
  'UNIDADE VARCHAR(10), ' +
  'QTDE NUMERIC(15,4), ' +
  'VALOR_UNITARIO NUMERIC(15,3), ' +
  'VALOR_DESCONTO NUMERIC(15,2), ' +
  'VALOR_ACRESCIMO NUMERIC(15,2), ' +
  'VALOR_TOTAL NUMERIC(15,2), ' +
  'CANCELADO INTEGER, ' +
  'DATA DATE, ' +
  'EX INTEGER, ' +
  'COD_CAIXA INTEGER, ' +
  'VALOR_CUSTO NUMERIC(15,2), ' +
  'VALOR_CUSTO_TOTAL NUMERIC(15,2), ' +
  'MOTIVO_CANCELAMENTO VARCHAR(3)) ' +
  'AS ' +
  'BEGIN ' +
  'UPDATE OR INSERT INTO CUPOM_ITEM (CODIGO, COD_CUPOM, ITEM, COD_PRODUTO, UNIDADE, QTDE, ' +
  'VALOR_UNITARIO, VALOR_DESCONTO, VALOR_ACRESCIMO, VALOR_TOTAL, CANCELADO, DATA, EX, COD_CAIXA, ' +
  'VALOR_CUSTO, VALOR_CUSTO_TOTAL, NUVEM, MOTIVO_CANCELAMENTO) ' +
  'VALUES (:CODIGO, :COD_CUPOM, :ITEM, :COD_PRODUTO, :UNIDADE, :QTDE, ' +
  ':VALOR_UNITARIO, :VALOR_DESCONTO, :VALOR_ACRESCIMO, :VALOR_TOTAL, :CANCELADO, :DATA, :EX, :COD_CAIXA, ' +
  ':VALOR_CUSTO, :VALOR_CUSTO_TOTAL, 0, :MOTIVO_CANCELAMENTO) ' +
  'MATCHING(COD_CUPOM, ITEM); ' +
  'SUSPEND; ' +
  'END;';
  end;

  if ProcName = 'ST_ESTOQUE_MOVIMENTACAO' then
  begin
createSQL :=
  'CREATE PROCEDURE ST_ESTOQUE_MOVIMENTACAO(' +
  'QTDE NUMERIC(15,3), ' +
  'DATA DATE, ' +
  'HORA TIME, ' +
  'CODPRODUTO VARCHAR(6), ' +
  'COD_CUPOM VARCHAR(50), ' +
  'ITEM INTEGER, ' +
  'COD_FUNCIONARIO VARCHAR(6), ' +
  'ORIGEM VARCHAR(50), ' +
  'COD_CAIXA INTEGER) ' +
  'AS ' +
  'BEGIN ' +
  'INSERT INTO ESTOQUE_MOVIMENTACAO (QTDE, DATA, HORA, CODPRODUTO, COD_CUPOM, ITEM, COD_FUNCIONARIO, ORIGEM, NUVEM, COD_CAIXA) ' +
  'VALUES (:QTDE, :DATA, :HORA, :CODPRODUTO, :COD_CUPOM, :ITEM, :COD_FUNCIONARIO, :ORIGEM, 0, :COD_CAIXA); ' +
  'END;';

  end;

  if ProcName = 'ST_NAO_FISCAL' then
  begin
createSQL :=
  'CREATE PROCEDURE ST_NAO_FISCAL(' +
  'CODIGO VARCHAR(50), ' +
  'DATA DATE, ' +
  'INDICE VARCHAR(2), ' +
  'DESCRICAO VARCHAR(30), ' +
  'VALOR NUMERIC(15,2), ' +
  'HORA TIME, ' +
  'CODVENDEDOR INTEGER, ' +
  'FZCOD VARCHAR(3), ' +
  'COD_CAIXA INTEGER) ' +
  'AS ' +
  'BEGIN ' +
  'UPDATE OR INSERT INTO NAO_FISCAL (CODIGO, DATA, INDICE, DESCRICAO, VALOR, HORA, CODVENDEDOR, FZCOD, EX, COD_CAIXA, NUVEM) ' +
  'VALUES (:CODIGO, :DATA, :INDICE, :DESCRICAO, :VALOR, :HORA, :CODVENDEDOR, :FZCOD, 0, :COD_CAIXA, 0); ' +
  'SUSPEND; ' +
  'END;';


  end;


  result := createSQL;
end;


function TDatabaseRepositoryFirebird.CreateGenerator(
  const GeneratorName: string): string;
begin
  Result :=
    'EXECUTE BLOCK AS' + sLineBreak +
    'DECLARE VARIABLE vExists INTEGER;' + sLineBreak +
    'BEGIN' + sLineBreak +
    '  SELECT COUNT(*) FROM RDB$GENERATORS' + sLineBreak +
    '  WHERE RDB$GENERATOR_NAME = UPPER(''' + GeneratorName + ''')' + sLineBreak +
    '  INTO :vExists;' + sLineBreak +
    '  IF (vExists = 0) THEN' + sLineBreak +
    '  BEGIN' + sLineBreak +
    '    EXECUTE STATEMENT ''CREATE GENERATOR ' + UpperCase(GeneratorName) + ''';' + sLineBreak +
    '  END' + sLineBreak +
    'END;';
end;

function TDatabaseRepositoryFirebird.CreateIndex(tableName, indexName,
  columns: string; unique: Boolean): string;
var
  uniqueStr: string;
  query: TFDQuery;
begin
  Result := '';
  indexName := UpperCase(indexName);

  if unique then
    uniqueStr := 'UNIQUE '
  else
    uniqueStr := '';

  query := TConexao.GetInstance.CreateQuery('');
  try
    query.SQL.Clear;
    query.SQL.Add('SELECT 1 FROM RDB$INDICES WHERE TRIM(UPPER(RDB$INDEX_NAME)) = :idxName');
    query.ParamByName('idxName').AsString := indexName;
    query.Open;

    if query.RecordCount = 0 then // 🔹 só cria se não existir
    begin
      Result := 'CREATE ' + uniqueStr + 'INDEX ' + indexName + ' ON ' + UpperCase(tableName) + ' (' + columns + ')';
    end;
  finally
    query.Free;
  end;
  // 🔹 Garante que o nome do índice esteja em maiúsculas

//  // 🔹 Script para criar índice apenas se não existir
//  Result :=
//    'EXECUTE BLOCK AS ' + sLineBreak +
//    'BEGIN ' + sLineBreak +
//    '  IF (NOT EXISTS(' + sLineBreak +
//    '       SELECT 1 FROM RDB$INDICES ' + sLineBreak +
//    '       WHERE RDB$INDEX_NAME = ''' + indexName + ''')) THEN ' + sLineBreak +
//    '  BEGIN ' + sLineBreak +
//    '    EXECUTE STATEMENT ''CREATE ' + uniqueStr + 'INDEX ' + indexName +
//    ' ON ' + UpperCase(tableName) + ' (' + columns + ')''; ' + sLineBreak +
//    '  END ' + sLineBreak +
//    'END;';
end;

function TDatabaseRepositoryFirebird.CreatePrimaryKey(tableName,
  primaryKeys, constraintName: string): string;
begin
  // 🔹 Garante que o nome da constraint esteja em maiúsculas
  constraintName := UpperCase(constraintName);

  // 🔹 Script para criar PRIMARY KEY apenas se não existir
  Result :=
    'EXECUTE BLOCK AS ' + sLineBreak +
    'BEGIN ' + sLineBreak +
    '  IF (NOT EXISTS(' + sLineBreak +
    '       SELECT 1 FROM RDB$RELATION_CONSTRAINTS ' + sLineBreak +
    '       WHERE RDB$RELATION_NAME = ''' + UpperCase(tableName) + ''' ' + sLineBreak +
    '         AND RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' ' + sLineBreak +
    '         AND RDB$CONSTRAINT_NAME = ''' + constraintName + ''')) THEN ' + sLineBreak +
    '  BEGIN ' + sLineBreak +
    '    EXECUTE STATEMENT ''ALTER TABLE ' + UpperCase(tableName) +
    ' ADD CONSTRAINT ' + constraintName + ' PRIMARY KEY (' + primaryKeys + ')''; ' + sLineBreak +
    '  END ' + sLineBreak +
    'END;';
end;


function TDatabaseRepositoryFirebird.CreateTable(tableName,
  colunaDefault: string):string;
begin
if not TableExists(tableName) then
begin
result := 'CREATE TABLE '+tableName+' ('+colunaDefault+')';
end;

end;

function TDatabaseRepositoryFirebird.CreateTrigger(
  const TriggerName: string): string;
begin
  if UpperCase(TriggerName) = 'TRIG_ETIQUETA_LAYOUT_1' then
  begin
    Result :=
      'CREATE TRIGGER TRIG_ETIQUETA_LAYOUT_1' + sLineBreak +
      'FOR ETIQUETA_LAYOUT' + sLineBreak +
      'ACTIVE BEFORE INSERT POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '  NEW.CODIGO = GEN_ID(GEN_ETIQUETA_CONFIGURACAO, 1);' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'CONTAS_RECEBER_AIU0' then
  begin
    Result :=
      'CREATE OR ALTER TRIGGER CONTAS_RECEBER_AIU0 FOR CONTAS_RECEBER' + sLineBreak +
      'ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '  UPDATE CLIENTE SET CREDITO_UTILIZADO = (' + sLineBreak +
      '    SELECT SUM(VALOR_RESTANTE) FROM CONTAS_RECEBER' + sLineBreak +
      '    WHERE COD_CLIENTE = NEW.COD_CLIENTE AND CANCELADO = 0' + sLineBreak +
      '  ) WHERE CODIGO = NEW.COD_CLIENTE;' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'TRIG_VALIDADE_1' then
  begin
    Result :=
      'CREATE TRIGGER TRIG_VALIDADE_1 FOR VALIDADE' + sLineBreak +
      'ACTIVE BEFORE INSERT POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '  NEW.ID = GEN_ID(GEN_VALIDADE, 1);' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'ATUALIZAR_SALDO' then
  begin
    Result :=
      'CREATE TRIGGER ATUALIZAR_SALDO FOR ESTOQUE_MOVIMENTACAO' + sLineBreak +
      'ACTIVE AFTER INSERT POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '  UPDATE PRODUTO SET ESTOQUE = ESTOQUE + NEW.QTDE WHERE CODIGO = NEW.CODPRODUTO;' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'TRIG_CONTAS_RECEBER_1' then
  begin
    Result :=
      'CREATE TRIGGER TRIG_CONTAS_RECEBER_1 FOR CONTAS_RECEBER' + sLineBreak +
      'ACTIVE BEFORE UPDATE POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '    IF (NEW.VALOR_RESTANTE < 0) THEN' + sLineBreak +
      '    BEGIN' + sLineBreak +
      '        NEW.VALOR_RESTANTE = 0;' + sLineBreak +
      '    END' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'GENERATOR' then
  begin
    Result :=
      'CREATE TRIGGER "GENERATOR" FOR ESTOQUE_MOVIMENTACAO' + sLineBreak +
      'ACTIVE BEFORE INSERT POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '    NEW.ID = GEN_ID("GEN_ESTOQUE_MOVIMENTACAO",1);' + sLineBreak +
      'END;';
  end
  else if UpperCase(TriggerName) = 'TRIG_ETIQUETA_1' then
  begin
    Result :=
      'CREATE TRIGGER TRIG_ETIQUETA_1 FOR ETIQUETA' + sLineBreak +
      'ACTIVE BEFORE INSERT POSITION 0' + sLineBreak +
      'AS' + sLineBreak +
      'BEGIN' + sLineBreak +
      '    NEW.ID = GEN_ID("GEN_ETIQUETA",1);' + sLineBreak +
      'END;';
  end
  else
    Result := ''; // retorna vazio se o nome não existir
end;

function TDatabaseRepositoryFirebird.CreateUniqueKey(tableName,
  uniqueKeys, constraintName: string): string;
begin
  // 🔹 Garante que o nome da constraint esteja em maiúsculas
  constraintName := UpperCase(constraintName);

  // 🔹 Script para criar UNIQUE apenas se não existir
  Result :=
    'EXECUTE BLOCK AS ' + sLineBreak +
    'BEGIN ' + sLineBreak +
    '  IF (NOT EXISTS(' + sLineBreak +
    '       SELECT 1 FROM RDB$RELATION_CONSTRAINTS ' + sLineBreak +
    '       WHERE RDB$RELATION_NAME = ''' + UpperCase(tableName) + ''' ' + sLineBreak +
    '         AND RDB$CONSTRAINT_TYPE = ''UNIQUE'' ' + sLineBreak +
    '         AND RDB$CONSTRAINT_NAME = ''' + constraintName + ''')) THEN ' + sLineBreak +
    '  BEGIN ' + sLineBreak +
    '    EXECUTE STATEMENT ''ALTER TABLE ' + UpperCase(tableName) + ' ADD CONSTRAINT ' +
    constraintName + ' UNIQUE (' + uniqueKeys + ')''; ' + sLineBreak +
    '  END ' + sLineBreak +
    'END;';
end;

// New function to set NOT NULL constraint on a column
function TDatabaseRepositoryFirebird.SetNotNull(tableName, columnName: string): string;
begin
  Result :=
    'EXECUTE BLOCK AS ' + sLineBreak +
    'BEGIN ' + sLineBreak +
    '  IF (EXISTS(' + sLineBreak +
    '       SELECT 1 FROM RDB$RELATION_FIELDS RF ' + sLineBreak +
    '       JOIN RDB$FIELDS F ON RF.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ' + sLineBreak +
    '       WHERE RF.RDB$RELATION_NAME = ''' + UpperCase(tableName) + ''' ' + sLineBreak +
    '         AND RF.RDB$FIELD_NAME = ''' + UpperCase(columnName) + ''' ' + sLineBreak +
    '         AND F.RDB$NULL_FLAG IS NULL)) THEN ' + sLineBreak +
    '  BEGIN ' + sLineBreak +
    '    EXECUTE STATEMENT ''UPDATE RDB$FIELDS SET RDB$NULL_FLAG = 1 ' + sLineBreak +
    '                       WHERE RDB$FIELD_NAME = (SELECT RDB$FIELD_SOURCE ' + sLineBreak +
    '                                               FROM RDB$RELATION_FIELDS ' + sLineBreak +
    '                                               WHERE RDB$RELATION_NAME = ''''' + UpperCase(tableName) + ''''' ' + sLineBreak +
    '                                                 AND RDB$FIELD_NAME = ''''' + UpperCase(columnName) + ''''')''; ' + sLineBreak +
    '  END ' + sLineBreak +
    'END;';
end;

// New function to set NOT NULL constraint on a column


function TDatabaseRepositoryFirebird.DropProcedure(const ProcName: string): string;
begin
  Result :=
    'EXECUTE BLOCK AS ' + sLineBreak +
    'BEGIN ' + sLineBreak +
    '  IF (EXISTS(SELECT 1 FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ''' +
      UpperCase(ProcName) + ''')) THEN ' + sLineBreak +
    '    EXECUTE STATEMENT ''DROP PROCEDURE ' + UpperCase(ProcName) + ''';' + sLineBreak +
    'END;';
end;


function TDatabaseRepositoryFirebird.DropTrigger(const TriggerName: string): string;
begin
  Result :=
    'EXECUTE BLOCK AS ' + sLineBreak +
    'BEGIN ' + sLineBreak +
    '  IF (EXISTS(SELECT 1 FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME = ''' +
      UpperCase(TriggerName) + ''')) THEN ' + sLineBreak +
    '    EXECUTE STATEMENT ''DROP TRIGGER ' + UpperCase(TriggerName) + ''';' + sLineBreak +
    'END;';
end;


function TDatabaseRepositoryFirebird.getVersion: Integer;
var
  qry: TFDQuery;
begin
  // Valor padrão
  Result := 0;

  // Se a tabela VERSAO não existir, cria e inicializa
  if not TableExists('VERSAO') then
  begin
    qry := TConexao.GetInstance.CreateQuery('');
    try
      qry.SQL.Text := 'CREATE TABLE VERSAO (VALOR INTEGER NOT NULL);';
      qry.ExecSQL;

      // Inicializa com versão 1
      qry.SQL.Text := 'INSERT INTO VERSAO (VALOR) VALUES (1);';
      qry.ExecSQL;

      Result := 1;
    finally
      qry.Free;
    end;
    Exit;
  end;

  // Se existir, retorna o valor atual
  qry := TConexao.GetInstance.CreateQuery('');
  try
    qry.SQL.Text := 'SELECT VALOR FROM VERSAO;';
    qry.Open;

    if not qry.Eof then
      Result := qry.FieldByName('VALOR').AsInteger;
  finally
    qry.Free;
  end;
end;

function TDatabaseRepositoryFirebird.RemoveDuplicateCodes(
  tableName, columnName, idColumn: string): string;
begin
  Result :=
    'DELETE FROM ' + tableName + ' p' + sLineBreak +
    'WHERE EXISTS (' + sLineBreak +
    '  SELECT 1' + sLineBreak +
    '  FROM ' + tableName + ' p2' + sLineBreak +
    '  WHERE p2.' + columnName + ' = p.' + columnName + sLineBreak +
    '    AND p2.' + idColumn + ' < p.' + idColumn + sLineBreak +
    ')' + sLineBreak +
    'ROWS 100;';
end;


function TDatabaseRepositoryFirebird.TableExists(tableName: string): boolean;
var
  qry:TFDQuery;
begin
  qry := TConexao.GetInstance.CreateQuery('');
  qry.SQL.Text :=
    'SELECT 1 FROM RDB$RELATIONS ' +
    'WHERE RDB$SYSTEM_FLAG = 0 AND UPPER(RDB$RELATION_NAME) = :TABLE_NAME';

  qry.ParamByName('TABLE_NAME').AsString := UpperCase(tableName);
  qry.Open;

  result := not qry.IsEmpty;
end;

end.
