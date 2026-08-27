unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uAPIRequest, Vcl.ExtCtrls,SelecionarLoja,Utils,Login,Produto,uDmProduto,Preco,uDmPreco,uDmTributacao,
  tributacao,uDmCaixa,ConexaoPDV,uDmProdutoPDV,uDmPrecoPDV,uDmTributacaoPDV,uDmVenda,Finalizadora,uDmFinalizadora,uDmFinalizadoraPDV,Funcionario,uDmFuncionario,uDmFuncionarioPDV,system.Generics.collections,
  Vcl.Menus,Cliente,uDmCliente,Global,uLogErro;

type
  TfrmPrincipal = class(TForm)
    memLog: TMemo;
    edtToken: TEdit;
    tmInicializa: TTimer;
    tmCarga: TTimer;
    tmSubidaVenda: TTimer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure tmInicializaTimer(Sender: TObject);
    procedure tmCargaTimer(Sender: TObject);
    procedure tmSubidaVendaTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
  private
    // Registra a falha no memo da tela e no arquivo Logs\sync_erros_<data>.txt
    procedure LogFalha(const contexto, mensagem: string); overload;
    procedure LogFalha(const contexto: string; E: Exception); overload;

    // Recebem o que as camadas de baixo estao fazendo (uLogErro.Progresso e
    // uLogErro.Atividade) e devolvem o processamento para a janela.
    procedure MostrarProgresso(const mensagem: string);
    procedure MostrarAtividade(const mensagem: string);
    procedure RespirarJanela;
    procedure ProgressoItem(const etapa: string; indice, total: integer);

    function cargaClientes(alterados:boolean):Boolean;
    function cargaProdutos(alterados:boolean):boolean;
    function cargaTributacoes(alterados:boolean):Boolean;
    function cargaFinalizadoras(alterados:boolean):Boolean;
    function cargaFuncionarios(alterados:Boolean):boolean;
  public
    caixaList:TStringList;
    primeiraInicializacao:Boolean;
    // A subida dos titulos abre conexao com cada PDV e a conexao e um
    // singleton: dois ciclos ao mesmo tempo brigariam pelo IP.
    subindoContaReceber:Boolean;
    // Um ciclo de subida de venda que passe do intervalo do timer nao pode
    // empilhar o proximo em cima das mesmas queries e da mesma conexao.
    subindoVenda:Boolean;
    // Idem para a carga, que e a operacao mais longa do agente.
    carregando:Boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

const
  // PDV, produtos, tributacoes, finalizadoras, clientes e funcionarios: as
  // etapas reportadas para a nuvem montar a barra de progresso.
  TOTAL_ETAPAS_CARGA = 6;

  // O agente fica dias no ar. Sem teto, o memo cresce ate consumir memoria a
  // toa; as linhas antigas ja estao no arquivo de log quando importam.
  MAX_LINHAS_MEMO = 500;
  LINHAS_MANTIDAS = 200;

  TITULO = 'Sincronizar RK Nuvem';

  // De quantos em quantos registros a carga avisa. Uma linha por registro,
  // como era antes, deixava o memo com dezenas de milhares de linhas numa
  // carga completa; e devolver o processamento para a janela a cada registro
  // custaria mais que a propria gravacao.
  PASSO_MEMO_CARGA = 250;
  PASSO_ATIVIDADE_CARGA = 25;

procedure TfrmPrincipal.LogFalha(const contexto, mensagem: string);
begin
  memLog.Lines.Add('[ERRO] ' + contexto + ': ' + mensagem);
  uLogErro.LogErro(contexto, mensagem);
end;

// Tudo roda na thread principal. Sem devolver o processamento para a fila de
// mensagens, a janela nao repinta, nao responde ao clique e o Windows a marca
// como "nao respondendo" - foi o que apareceu como travamento.
//
// Reentrancia: quem chama isto ja esta dentro de um ciclo com a flag ligada
// (subindoVenda ou carregando), e os dois handlers de timer conferem as duas
// flags antes de comecar. O ProcessMessages ate deixa o tique chegar, mas ele
// sai na primeira linha sem entrar no ciclo.
procedure TfrmPrincipal.RespirarJanela;
begin
  Application.ProcessMessages;
end;

procedure TfrmPrincipal.MostrarProgresso(const mensagem: string);
var
  i: integer;
begin
  if memLog.Lines.Count > MAX_LINHAS_MEMO then
  begin
    memLog.Lines.BeginUpdate;
    try
      for i := 1 to memLog.Lines.Count - LINHAS_MANTIDAS do
        memLog.Lines.Delete(0);
    finally
      memLog.Lines.EndUpdate;
    end;
  end;

  memLog.Lines.Add('[' + FormatDateTime('hh:nn:ss', Now) + '] ' + mensagem);
  RespirarJanela;
end;

// Estado corrente, no titulo da janela e no balao da bandeja: sobrescreve em
// vez de acumular, entao serve para as esperas em que nada acontece (um SELECT
// demorado, um CREATE INDEX) sem encher o memo.
procedure TfrmPrincipal.MostrarAtividade(const mensagem: string);
begin
  if mensagem = '' then
    Caption := TITULO
  else
    Caption := TITULO + ' - ' + mensagem;

  TrayIcon1.Hint := Caption;
  RespirarJanela;
end;

// Andamento de um laco de carga. O registro corrente vai para o titulo e, de
// tempos em tempos, uma linha resumida vai para o memo.
procedure TfrmPrincipal.ProgressoItem(const etapa: string; indice, total: integer);
begin
  if (indice = total - 1) or ((((indice + 1) mod PASSO_MEMO_CARGA) = 0)) then
    MostrarProgresso(Format('   %s: %d de %d', [etapa, indice + 1, total]))
  else if (((indice + 1) mod PASSO_ATIVIDADE_CARGA) = 0) then
    MostrarAtividade(Format('%s: %d de %d...', [etapa, indice + 1, total]));
end;

procedure TfrmPrincipal.LogFalha(const contexto: string; E: Exception);
begin
  if Assigned(E) then
    LogFalha(contexto, E.ClassName + ': ' + E.Message)
  else
    LogFalha(contexto, 'Erro desconhecido');
end;

function TfrmPrincipal.cargaClientes(alterados: boolean): Boolean;
var
  clienteList :TStringList;
  cliente:TCliente;
  dmConexaoPDV:TuDmConexaoPDV;

  uDmCliente : TDMCliente;
  i,x:integer;
begin
try
  clienteList := uAPIRequest.getClientes(alterados);

  // Criados uma vez, fora dos lacos: um datamodule por registro deixava
  // milhares de conexoes de banco abertas ate a carga terminar, e era isso
  // que derrubava a carga completa em base grande.
  uDmCliente := TDMCliente.Create(nil);
  try
  for I := 0 to clienteList.Count -1 do
  begin
    try
      cliente := TCliente.Create;
      cliente := cliente.JsonToCliente(clienteList[I]);
      uDmCliente.InsertCliente(cliente);


      ProgressoItem('CLIENTES', I, clienteList.Count);
    except
    on E:Exception do
    begin
      LogFalha('CARGA_CLIENTE',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(clienteList[I], 1, 300)]));
    end;

    end;
  end;
  finally
    uDmCliente.Free;
    clienteList.Free;
  end;
  MostrarProgresso('Clientes sincronizados...');

  except
  on E:Exception do
  begin
  LogFalha('CARGA_CLIENTES', E);
  end;



end;
end;

function TfrmPrincipal.cargaFinalizadoras(alterados: boolean): Boolean;
var
  finalizadoraList :TStringList;
  finalizadora:TFinalizadora;
  dmConexaoPDV:TuDmConexaoPDV;

  uDmFinalizadora : TdmFinalizadora;
  i,x:integer;
begin
try
  finalizadoraList := uAPIRequest.getFinalizadoras(alterados);

  // Criados uma vez, fora dos lacos: um datamodule por registro deixava
  // milhares de conexoes de banco abertas ate a carga terminar, e era isso
  // que derrubava a carga completa em base grande.
  uDmFinalizadora := TdmFinalizadora.Create(nil);
  dmConexaoPDV := TuDmConexaoPDV.Create(nil);
  try
  for I := 0 to finalizadoraList.Count -1 do
  begin
    try
      finalizadora := TFinalizadora.Create;
      finalizadora := finalizadora.JsonToFinalizadora(finalizadoraList[I]);
      uDmFinalizadora.InsertFinalizadora(finalizadora);
      ProgressoItem('FINALIZADORAS', I, finalizadoraList.Count);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV.configurarIP(caixaList[X]);

          dmFinalizadoraPDV.insertFinalizadoraPDV(finalizadora);
        except
        on E:Exception do
        begin
         LogFalha('CARGA_FINALIZADORA_PDV',
           Format('Finalizadora %s no caixa %s | %s',
             [finalizadora.codigo, caixaList[X], E.Message]));
        end;

        end;


      end;

    except
    on E:Exception do
    begin
      LogFalha('CARGA_FINALIZADORA',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(finalizadoraList[I], 1, 300)]));
    end;

    end;
  end;
  finally
    dmConexaoPDV.Free;
    uDmFinalizadora.Free;
    finalizadoraList.Free;
  end;
  MostrarProgresso('Finalizadoras sincronizadas...');

  except
  on E:Exception do
  begin
  LogFalha('CARGA_FINALIZADORAS', E);
  end;



end;
end;

function TfrmPrincipal.cargaFuncionarios(alterados: Boolean): boolean;
var
  funcionarioList :TStringList;
  funcionario:TFuncionario;
  dmConexaoPDV:TuDmConexaoPDV;

  uDmFuncionario : TdmFuncionario;
  i,x:integer;
begin
try
  funcionarioList := uAPIRequest.getFuncionarios(alterados);

  // Criados uma vez, fora dos lacos: um datamodule por registro deixava
  // milhares de conexoes de banco abertas ate a carga terminar, e era isso
  // que derrubava a carga completa em base grande.
  uDmFuncionario := TDmFuncionario.Create(nil);
  dmConexaoPDV := TuDmConexaoPDV.Create(nil);
  try
  for I := 0 to funcionarioList.Count -1 do
  begin
    try
      funcionario := TFuncionario.Create;
      funcionario := funcionario.JsonToFuncionario(funcionarioList[I]);
      uDmFuncionario.InsertFuncionario(funcionario);
      ProgressoItem('FUNCIONARIOS', I, funcionarioList.Count);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV.configurarIP(caixaList[X]);

          dmFuncionarioPDV.insertFuncionarioPDV(funcionario);
        except
        on E:Exception do
        begin
         LogFalha('CARGA_FUNCIONARIO_PDV',
           Format('Funcionario %s no caixa %s | %s',
             [funcionario.codigo, caixaList[X], E.Message]));
        end;

        end;


      end;

    except
    on E:Exception do
    begin
      LogFalha('CARGA_FUNCIONARIO',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(funcionarioList[I], 1, 300)]));
    end;

    end;
  end;
  finally
    dmConexaoPDV.Free;
    uDmFuncionario.Free;
    funcionarioList.Free;
  end;
  MostrarProgresso('Funcionarios sincronizados...');

  except
  on E:Exception do
  begin
  LogFalha('CARGA_FUNCIONARIOS', E);
  end;



end;
end;



function TfrmPrincipal.cargaProdutos(alterados:boolean): boolean;
var
  produtoList :TStringList;
  novoProduto:TProduto;
  produtoConvertido:TProduto;

  listProd:TObjectList<TProduto>;

  dmProduto : TdmProduto;
  dmProdutoPDV:TdmProdutoPDV;

  dmConexaoPDV:TuDmConexaoPDV;
  i,x:integer;
begin
try
  produtoList := uAPIRequest.getProdutos(alterados);

  listProd := TObjectList<TProduto>.create;

  for I := 0 to produtoList.Count -1 do
  begin
  try
    if produtoList[i] <> '' then
    begin
      // JsonToProduto devolve um objeto novo; o criado aqui serve so para a
      // chamada e precisa ser liberado, senao cada carga vaza um TProduto.
      novoProduto := TProduto.Create;
      try
        produtoConvertido := novoProduto.JsonToProduto(produtoList[i]);
      finally
        novoProduto.Free;
      end;

      if Assigned(produtoConvertido) then
      begin
        listProd.Add(produtoConvertido);
        ProgressoItem('PRODUTOS lidos', I, produtoList.Count);
      end
      else
        LogFalha('CARGA_PRODUTO',
          Format('Registro %d ignorado: json invalido | json: %s',
            [I, Copy(produtoList[I], 1, 300)]));
    end;
    except
    on E:Exception do
    begin
      // um produto com problema nao pode mais abortar a carga inteira:
      // registra o que falhou e segue com os demais
      LogFalha('CARGA_PRODUTO',
        Format('Registro %d ignorado | %s | json: %s',
          [I, E.Message, Copy(produtoList[I], 1, 300)]));
    end;

    end;

  end;

  MostrarProgresso(Format('PRODUTOS: gravando %d no retaguarda...', [listProd.Count]));
  dmProduto := TdmProduto.Create(nil);
  dmProduto.InsertProdutoBulk(listProd);


      dmConexaoPDV := TuDmConexaoPDV.Create(nil);
      dmProdutoPDV := TdmProdutoPDV.Create(nil);
      try
      for X := 0 to caixaList.Count -1 do
      begin
        try
          MostrarProgresso(Format('PRODUTOS: enviando para o caixa %s (%d de %d)...',
            [caixaList[X], X + 1, caixaList.Count]));
          dmConexaoPDV.configurarIP(caixaList[X]);
          dmProdutoPDV.insertProdutoPDV(listProd);
        except
        on E:Exception do
        begin
          LogFalha('CARGA_PRODUTO_PDV',
            Format('Caixa %s | %s', [caixaList[X], E.Message]));
        end;

        end;
      end;
      finally
        dmProdutoPDV.Free;
        dmConexaoPDV.Free;
        dmProduto.Free;
        produtoList.Free;
        listProd.Free;
      end;

  MostrarProgresso('PRODUTOS: concluido');




  except
  on E:Exception do
  begin
  LogFalha('CARGA_PRODUTOS', E);
  end;



end;
end;

function TfrmPrincipal.cargaTributacoes(alterados: boolean): Boolean;
var
  tributacaoList :TStringList;
  tributacao:TTributacao;
  dmConexaoPDV:TuDmConexaoPDV;

  uDmTributacao : TdmTributacao;
  i,x:integer;
begin
try
  tributacaoList := uAPIRequest.getTributacoes(alterados);

  // Criados uma vez, fora dos lacos: um datamodule por registro deixava
  // milhares de conexoes de banco abertas ate a carga terminar, e era isso
  // que derrubava a carga completa em base grande.
  uDmTributacao := TdmTributacao.Create(nil);
  dmConexaoPDV := TuDmConexaoPDV.Create(nil);
  try
  for I := 0 to tributacaoList.Count -1 do
  begin
    try
      tributacao := TTributacao.Create;
      tributacao := tributacao.JsonToTributacao(tributacaoList[I]);
      uDmTributacao.InsertTributacao(tributacao);
      ProgressoItem('TRIBUTACOES', I, tributacaoList.Count);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV.configurarIP(caixaList[X]);

          dmTributacaoPDV.insertTributacaoPDV(tributacao);
        except
        on E:Exception do
        begin
         LogFalha('CARGA_TRIBUTACAO_PDV',
           Format('Tributacao %s no caixa %s | %s',
             [tributacao.codigo, caixaList[X], E.Message]));
        end;

        end;


      end;

    except
    on E:Exception do
    begin
      LogFalha('CARGA_TRIBUTACAO',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(tributacaoList[I], 1, 300)]));
    end;

    end;
  end;
  finally
    dmConexaoPDV.Free;
    uDmTributacao.Free;
    tributacaoList.Free;
  end;
  MostrarProgresso('TRIBUTACOES: concluido');

  except
  on E:Exception do
  begin
  LogFalha('CARGA_TRIBUTACOES', E);
  end;



end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := CaNone;
  Self.Hide;
  Self.WindowState := wsMinimized;
  TrayIcon1.visible :=True;
  TrayIcon1.Animate :=True;

end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
// Liga a tela nas camadas de baixo antes de qualquer trabalho comecar, senao
// a primeira coisa que demora (a criacao dos indices) roda sem dar sinal.
uLogErro.OnProgresso :=
  procedure(mensagem: string)
  begin
    MostrarProgresso(mensagem);
  end;

uLogErro.OnAtividade :=
  procedure(mensagem: string)
  begin
    MostrarAtividade(mensagem);
  end;

tmInicializa.Enabled := true;
end;

procedure TfrmPrincipal.S1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfrmPrincipal.tmCargaTimer(Sender: TObject);
var
  solicitacao:string;
begin
// A carga e a operacao mais longa do agente e passa de longe do intervalo do
// timer. Sem o guarda, e agora que ela devolve o processamento para a janela,
// um segundo tique entraria por cima do primeiro usando as mesmas conexoes.
//
// O guarda tem que ser por flag. Desligar o timer do outro ciclo parece mais
// seguro mas mata a carga: religar um TTimer chama KillTimer + SetTimer, o que
// reinicia a contagem do zero e descarta o WM_TIMER que ja estava na fila.
// Como os dois timers sao de 5 s e a subida roda a cada 5 s gastando alguns
// segundos, ela zerava o relogio da carga a cada ciclo e a carga nunca
// chegava a disparar - a nuvem ficava em "aguardando sync" para sempre.
if carregando or subindoVenda then Exit;

carregando := true;
try
try
  solicitacao := uAPIRequest.verificaCargaPendente;

  if solicitacao = 'CARGA_COMPLETA' then
  begin
    memLog.Lines.Clear;
    memLog.Lines.Add('CARGA COMPLETA SOLICITADA !');

    informaProgressoCarga('PDV', 1, TOTAL_ETAPAS_CARGA);
    try
      CargaPDVUseCase.EnviarCargaPDV;
    except
    on E:Exception do
      LogFalha('CARGA_PDV', E);
    end;

    informaProgressoCarga('PRODUTOS', 2, TOTAL_ETAPAS_CARGA);
    cargaProdutos(false);
//    cargaPrecos(false);

    informaProgressoCarga('TRIBUTACOES', 3, TOTAL_ETAPAS_CARGA);
    cargaTributacoes(false);

    informaProgressoCarga('FINALIZADORAS', 4, TOTAL_ETAPAS_CARGA);
    cargaFinalizadoras(false);

    informaProgressoCarga('CLIENTES', 5, TOTAL_ETAPAS_CARGA);
    cargaClientes(false);

    informaProgressoCarga('FUNCIONARIOS', 6, TOTAL_ETAPAS_CARGA);
    cargaFuncionarios(false);

    if not finalizaCargaPendente then
      LogFalha('CARGA_COMPLETA', 'Nao foi possivel avisar a nuvem que a carga terminou');




  end;

  if solicitacao = 'CARGA_ALTERADOS' then
  begin
    memLog.Lines.Clear;
    memLog.Lines.Add('CARGA ALTERADOS SOLICITADA !');

    informaProgressoCarga('PDV', 1, TOTAL_ETAPAS_CARGA);
    try
      CargaPDVUseCase.EnviarCargaPDV;
    except
    on E:Exception do
      LogFalha('CARGA_PDV', E);
    end;

    informaProgressoCarga('PRODUTOS', 2, TOTAL_ETAPAS_CARGA);
    cargaProdutos(true);
//    cargaPrecos(true);

    informaProgressoCarga('TRIBUTACOES', 3, TOTAL_ETAPAS_CARGA);
    cargaTributacoes(true);

    informaProgressoCarga('CLIENTES', 4, TOTAL_ETAPAS_CARGA);
    cargaClientes(true);

    informaProgressoCarga('FUNCIONARIOS', 5, TOTAL_ETAPAS_CARGA);
    cargaFuncionarios(true);

    informaProgressoCarga('FINALIZADORAS', 6, TOTAL_ETAPAS_CARGA);
    cargaFinalizadoras(true);

    if not finalizaCargaPendente then
      LogFalha('CARGA_ALTERADOS', 'Nao foi possivel avisar a nuvem que a carga terminou');
  end;

  except
  on E:Exception do
  begin
    LogFalha('TIMER_CARGA', E);
  end;

end;
finally
  carregando := false;
  MostrarAtividade('');
end;
end;

procedure TfrmPrincipal.tmInicializaTimer(Sender: TObject);
var
  uFrmSelecionarLoja:TfrmLoja;
  ufrmLogin : TFrmLogin;

  diretorioConfig:string;
  dmCaixa :TdmCaixa;



  produtoList:TStringList;
  i:integer;
begin
  tmInicializa.Enabled := false;
  memLog.Lines.Add('Inicializando...');

  TOKEN := ReadIniString('TOKEN','TOKEN','');
  USER := ReadIniString('LOGIN','USER','');
  PASS := ReadIniString('LOGIN','PASS','');

  edtToken.Text := TOKEN;


  while (token = '') or (USER = '') or (PASS = '') do
  begin

    ufrmLogin := TfrmLogin.Create(nil);
    ufrmLogin.ShowModal;
        uAPIRequest.Login(USER,PASS);
  end;
  codLoja := ReadIniString('LOJA','Codigo','');
  nomeLoja := ReadIniString('LOJA','Nome','');

  while (codLoja = '') or (nomeLoja = '') do
  begin
    uFrmSelecionarLoja:=TfrmLoja.Create(nil);
    uFrmSelecionarLoja.ShowModal;
    codLoja := ReadIniString('LOJA','Codigo','');
    nomeLoja := ReadIniString('LOJA','Nome','');
  end;


  MostrarAtividade('Inicializando...');

  memLog.Lines.Add('Inicializado, Loja: '+ codLoja + ' - ' + nomeLoja);
  memLog.Lines.Add('Aguardando Solicita��o de carga');
  memLog.Lines.Add('Carregando lista de caixas ...');

  try
    dmCaixa := TdmCaixa.Create(nil);
    caixaList := dmCaixa.retornaIPCaixas();
  except
  on E:Exception do
  begin
    LogFalha('CARREGA_CAIXAS', E);
  end;

  end;

  // sem a lista os lacos de carga do PDV dariam violacao de acesso
  if not Assigned(caixaList) then
    caixaList := TStringList.Create;

  // Sem indice em NUVEM cada ciclo da subida varre as tabelas de venda
  // inteiras. Idempotente: so cria o que ainda nao existe.
  try
    Global.IndicesNuvem.garantirIndices;
  except
  on E:Exception do
    LogFalha('INDICES_NUVEM', E);
  end;

  MostrarAtividade('');


if primeiraInicializacao = false then
  begin
    primeiraInicializacao := true;
    close;
  end;

  tmCarga.Enabled := true;
  tmSubidaVenda.Enabled:= True;


end;

procedure TfrmPrincipal.tmSubidaVendaTimer(Sender: TObject);
begin
// Um backlog grande faz o ciclo passar do intervalo do timer. Sem esse guarda
// o proximo tick entraria em cima das mesmas queries e da mesma conexao.
//
// Confere tambem "carregando" porque durante a carga este ciclo nao pode
// entrar - e por flag, nunca desligando tmCarga, que era o que impedia a
// carga de disparar (ver o comentario em tmCargaTimer).
if subindoVenda or carregando then Exit;

subindoVenda := true;
try
  try
    if not uDmVenda.dmVenda.sincronizaVenda then
      memLog.Lines.Add('[ERRO] Subida de vendas com falhas - ver ' + uLogErro.ArquivoLogErro);

    // Titulo de convenio nao passa pela retaguarda: e lido direto do banco de
    // cada PDV, entao fica fora do sincronizaVenda, que so conhece o banco.fdb.
    if not subindoContaReceber then
    begin
      subindoContaReceber := true;
      try
        try
          Global.SubidaContaReceberUseCase.Executar;
        except
        on E:Exception do
          LogFalha('SUBIDA_CONTA_RECEBER', E);
        end;
      finally
        subindoContaReceber := false;
      end;
    end;
  except
  on E:Exception do
  begin
    LogFalha('TIMER_SUBIDA_VENDA', E);
  end;

  end;
finally
  subindoVenda := false;
  uLogErro.Atividade('');
end;
end;

procedure TfrmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

end.
