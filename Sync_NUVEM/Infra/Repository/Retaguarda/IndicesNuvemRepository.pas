unit IndicesNuvemRepository;

interface
uses System.SysUtils, uConexaoRetaguarda;

// A subida de venda le "WHERE NUVEM = 0" em sete tabelas a cada ciclo do
// timer. Sem indice isso e uma varredura completa de CUPOM, CUPOM_ITEM e
// companhia a cada poucos segundos - e em base de cliente com anos de
// movimento essa varredura sozinha ja custa mais que o envio.
//
// O indice e composto (NUVEM + as colunas do ORDER BY) de proposito: assim o
// Firebird resolve o filtro e a ordenacao pelo mesmo indice e o SELECT FIRST
// para de ler assim que completa o lote, em vez de ordenar o backlog inteiro
// para descartar quase tudo.
//
// O PDV ja faz o mesmo em CUPOM_CREDIARIO (Migrations.inc); aqui a criacao
// fica com o proprio agente porque e ele quem depende dela, e assim nao e
// preciso esperar o cliente atualizar a retaguarda.
type IIndicesNuvemRepository = interface
  ['{2F5B8C41-9A73-4D26-B0E8-7C3D14A9F582}']
  procedure garantirIndices;
end;

type TIndicesNuvemRepository = class(TInterfacedObject,IIndicesNuvemRepository)
  private
    // uma vez por execucao do agente basta
    FVerificado:Boolean;
    procedure criarIndice(const tabela, indice, colunas:string);
  public
    procedure garantirIndices;
end;

implementation

uses uLogErro;

{ TIndicesNuvemRepository }

// Idempotente: nao roda DDL se o indice ja existir, e nao tenta criar nada em
// tabela que ainda nao tenha a coluna NUVEM.
procedure TIndicesNuvemRepository.criarIndice(const tabela, indice,
  colunas: string);
begin
  // Numa base com anos de movimento o CREATE INDEX leva minutos, e roda na
  // thread principal: sem esse aviso a janela fica parada e parece travada.
  // Vai para o memo tambem, e nao so para o titulo, para ficar registrado em
  // qual tabela o agente estava caso o usuario feche no meio.
  uLogErro.Progresso(Format('   indice de %s...', [tabela]));
  uLogErro.Atividade(Format('Verificando indice de %s...', [tabela]));

  try
    TConexao.GetInstance.ExecSQL(
      'EXECUTE BLOCK AS BEGIN ' +
      '  IF (EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
      '             WHERE RDB$RELATION_NAME = ''' + tabela + ''' ' +
      '               AND RDB$FIELD_NAME = ''NUVEM'') ' +
      '      AND NOT EXISTS(SELECT 1 FROM RDB$INDICES ' +
      '                     WHERE RDB$INDEX_NAME = ''' + indice + ''')) THEN ' +
      '    EXECUTE STATEMENT ''CREATE INDEX ' + indice + ' ON ' + tabela +
      ' (' + colunas + ')''; ' +
      'END');
  except
  on E:Exception do
  begin
    // DDL em tabela sob uso pode voltar "object in use" ou conflito de lock.
    // Nao e motivo para impedir a subida: registra e tenta de novo na proxima
    // inicializacao do agente.
    uLogErro.LogErro('INDICE_NUVEM',
      Format('Nao foi possivel criar %s em %s | %s: %s',
        [indice, tabela, E.ClassName, E.Message]));
  end;
  end;
end;

procedure TIndicesNuvemRepository.garantirIndices;
begin
  if FVerificado then Exit;
  FVerificado := true;

  uLogErro.Progresso('Verificando indices de subida (pode demorar na primeira vez)...');

  criarIndice('CUPOM',                   'IDX_CUPOM_NUVEM',       'NUVEM, COD_CAIXA, CODIGO');
  criarIndice('CUPOM_ITEM',              'IDX_CUPOM_ITEM_NUVEM',  'NUVEM, COD_CAIXA, CODIGO');
  criarIndice('CUPOM_FORMA',             'IDX_CUPOM_FORMA_NUVEM', 'NUVEM, COD_CAIXA, CODIGO');
  criarIndice('ESTOQUE_MOVIMENTACAO',    'IDX_ESTOQUE_MOV_NUVEM', 'NUVEM, COD_CUPOM, ITEM');
  criarIndice('NAO_FISCAL',              'IDX_NAO_FISCAL_NUVEM',  'NUVEM, COD_CAIXA, CODIGO');
  criarIndice('FECHAMENTO',              'IDX_FECHAMENTO_NUVEM',  'NUVEM, COD_CAIXA, CODIGO');
  criarIndice('FECHAMENTO_FINALIZADORA', 'IDX_FECH_FIN_NUVEM',    'NUVEM, COD_CAIXA, ID_FECHAMENTO');

  uLogErro.Progresso('Indices de subida verificados.');
  uLogErro.Atividade('');
end;

end.
