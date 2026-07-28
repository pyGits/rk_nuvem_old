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

    function cargaClientes(alterados:boolean):Boolean;
    function cargaProdutos(alterados:boolean):boolean;
    function cargaTributacoes(alterados:boolean):Boolean;
    function cargaFinalizadoras(alterados:boolean):Boolean;
    function cargaFuncionarios(alterados:Boolean):boolean;
  public
    caixaList:TStringList;
    primeiraInicializacao:Boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.LogFalha(const contexto, mensagem: string);
begin
  memLog.Lines.Add('[ERRO] ' + contexto + ': ' + mensagem);
  uLogErro.LogErro(contexto, mensagem);
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
  clienteList := TStringList.Create;
  clienteList := uAPIRequest.getClientes(alterados);

  for I := 0 to clienteList.Count -1 do
  begin
    try
      uDmCliente := TDMCliente.Create(nil);
      cliente := TCliente.Create;
      cliente := cliente.JsonToCliente(clienteList[I]);
      uDmCliente.InsertCliente(cliente);


      memLog.Lines.Add('Atualizando Cliente: '+cliente.codigo + ' - '+ cliente.nome);
    except
    on E:Exception do
    begin
      LogFalha('CARGA_CLIENTE',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(clienteList[I], 1, 300)]));
    end;

    end;
  end;
  memLog.Lines.Add('Clientes sincronizados...');

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
  finalizadoraList := TStringList.Create;
  finalizadoraList := uAPIRequest.getFinalizadoras(alterados);

  for I := 0 to finalizadoraList.Count -1 do
  begin
    try
      uDmFinalizadora := TdmFinalizadora.Create(nil);
      finalizadora := TFinalizadora.Create;
      finalizadora := finalizadora.JsonToFinalizadora(finalizadoraList[I]);
      uDmFinalizadora.InsertFinalizadora(finalizadora);
      memLog.Lines.Add('Atualizando Finalizadora: '+finalizadora.codigo + ' - '+ finalizadora.nome);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV := TuDmConexaoPDV.Create(nil);
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
  memLog.Lines.Add('Finalizadoras sincronizadas...');

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
  funcionarioList := TStringList.Create;
  funcionarioList := uAPIRequest.getFuncionarios(alterados);

  for I := 0 to funcionarioList.Count -1 do
  begin
    try
      uDmFuncionario := TDmFuncionario.Create(nil);
      funcionario := TFuncionario.Create;
      funcionario := funcionario.JsonToFuncionario(funcionarioList[I]);
      uDmFuncionario.InsertFuncionario(funcionario);
      memLog.Lines.Add('Atualizando Funcionario: '+funcionario.codigo + ' - '+ funcionario.nome);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV := TuDmConexaoPDV.Create(nil);
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
  memLog.Lines.Add('Funcionarios sincronizados...');

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

  listProd:TObjectList<TProduto>;

  dmProduto : TdmProduto;
  dmProdutoPDV:TdmProdutoPDV;

  dmConexaoPDV:TuDmConexaoPDV;
  i,x:integer;
begin
try
  produtoList := TStringList.Create;
  produtoList := uAPIRequest.getProdutos(alterados);

  listProd := TObjectList<TProduto>.create;

  for I := 0 to produtoList.Count -1 do
  begin
  try
    if produtoList[i] <> '' then
    begin
      novoProduto := TProduto.Create;
      listProd.Add(novoProduto.JsonToProduto(produtoList[i]));
    end;
    except
    on E:Exception do
    begin
      LogFalha('CARGA_PRODUTO',
        Format('Registro %d | %s | json: %s',
          [I, E.Message, Copy(produtoList[I], 1, 300)]));
      raise Exception.Create('error'+e.message);
    end;

    end;

  end;

  dmProduto := TdmProduto.Create(nil);
  dmProduto.InsertProdutoBulk(listProd);


      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV := TuDmConexaoPDV.Create(nil);
          dmProdutoPDV := TdmProdutoPDV.Create(nil);
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

  memLog.Lines.Add('Produtos sincronizados com o Retaguarda... Sincronizando com PDV');
  memLog.Lines.Add('Produtos sincronizados com o Retaguarda...');




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
  tributacaoList := TStringList.Create;
  tributacaoList := uAPIRequest.getTributacoes(alterados);

  for I := 0 to tributacaoList.Count -1 do
  begin
    try
      uDmTributacao := TdmTributacao.Create(nil);
      tributacao := TTributacao.Create;
      tributacao := tributacao.JsonToTributacao(tributacaoList[I]);
      uDmTributacao.InsertTributacao(tributacao);
      memLog.Lines.Add('Atualizando Tributação: '+tributacao.codigo + ' - '+ tributacao.nome);



      // CARGA PDV
      for X := 0 to caixaList.Count -1 do
      begin
        try
          dmConexaoPDV := TuDmConexaoPDV.Create(nil);
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

//  produto.Free;
//  produtoList.free;
  memLog.Lines.Add('Tributações sincronizadas...');

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
try
  solicitacao := uAPIRequest.verificaCargaPendente;

  if solicitacao = 'CARGA_COMPLETA' then
  begin
    try
      CargaPDVUseCase.EnviarCargaPDV;
    except
    on E:Exception do
      LogFalha('CARGA_PDV', E);
    end;

    memLog.Lines.Clear;
    memLog.Lines.Add('CARGA COMPLETA SOLICITADA !');
    cargaProdutos(false);
//    cargaPrecos(false);
    cargaTributacoes(false);
    cargaFinalizadoras(false);
    cargaClientes(false);
    cargaFuncionarios(false);

    if not finalizaCargaPendente then
      LogFalha('CARGA_COMPLETA', 'Nao foi possivel avisar a nuvem que a carga terminou');




  end;

  if solicitacao = 'CARGA_ALTERADOS' then
  begin
    try
      CargaPDVUseCase.EnviarCargaPDV;
    except
    on E:Exception do
      LogFalha('CARGA_PDV', E);
    end;

      memLog.Lines.Clear;
    memLog.Lines.Add('CARGA ALTERADOS SOLICITADA !');
    cargaProdutos(true);
//    cargaPrecos(true);
    cargaTributacoes(true);
    cargaClientes(true);
    cargaFuncionarios(true);
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


  memLog.Lines.Add('Inicializado, Loja: '+ codLoja + ' - ' + nomeLoja);
  memLog.Lines.Add('Aguardando Solicitação de carga');
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
//tmSubidaVenda.Enabled := false;
try
  if not uDmVenda.dmVenda.sincronizaVenda then
    memLog.Lines.Add('[ERRO] Subida de vendas com falhas - ver ' + uLogErro.ArquivoLogErro);
except
on E:Exception do
begin
  LogFalha('TIMER_SUBIDA_VENDA', E);
end;

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
