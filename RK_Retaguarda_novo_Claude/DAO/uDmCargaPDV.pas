unit uDmCargaPDV;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Conversao,Classe.Caixa,uDmConexaoCaixa,uDmCargaCaixa,Classe.Cliente,Vcl.Dialogs,Classe.Funcionario,Classe.Finalizadora,Vcl.StdCtrls,Vcl.ComCtrls,VCL.Forms,Classe.Proprio,classe.configuracoespdv;

type
  TdmCargaPDV = class(TDataModule)
    qrCargaPDVPesquisar: TUniQuery;
    qrCargaPDVAtualizar: TUniQuery;
    qrCargaPDVExcluir: TUniQuery;
    qrCargaExcluirPDVInsert: TUniQuery;
    qrExcluirPDV: TUniQuery;
    qrZerarExclusaoPDV: TUniQuery;
    qrCargaTerminal: TUniQuery;
  private
    function EnviaCargaAlterados(lblProgresso:TLabel;pb:TProgressBar):boolean;
    function EnviaCargaCompleta(lblProgresso:TLabel;pb:TProgressBar):boolean;
    function EnviaParametros:boolean;

  public
  function EnviarCargaPDV(tipo:TCarga;oCaixa:TCaixa;lblProgresso:TLabel;pb:TProgressBar):boolean;
  function GerarCargaTerminalConsulta:boolean;
  function EnviarExclusaoPDV:Boolean;
  function ZerarExclusaoPDV:Boolean;

  function InsertFilaExcluir(tabela:string; codigo:string):Boolean;

  procedure AtualizarRecebimento(concluido:string;oCaixa:TCaixa);
  procedure ZerarCargaAlterados;



  end;

var
  dmCargaPDV: TdmCargaPDV;

implementation
uses Classe.Variaveis,Classe.Produto,Classe.Tributacao,Classe.AcessoPDV;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCargaPDV }

procedure TdmCargaPDV.AtualizarRecebimento(concluido:string;oCaixa: TCaixa);
begin
  with qrCargaPDVAtualizar do
  begin
    if concluido = 'S' then
    begin

        Close;
        SQL.Clear;
        SQL.Add('UPDATE CAIXA SET RECEBIDO = :RECEBIDO, ULTIMA_CARGA= :ULTIMA_CARGA WHERE CODIGO = :CODIGO');
        ParamByName('RECEBIDO').AsString := 'S';
        ParamByName('ULTIMA_CARGA').AsDateTime := Now();
        ParamByName('CODIGO').AsString := oCaixa.Codigo;
        ExecSQL;

    end
    else
    if concluido = 'N' then
    begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE CAIXA SET RECEBIDO = :RECEBIDO WHERE CODIGO = :CODIGO');
        ParamByName('RECEBIDO').AsString := 'N';
        ExecSQL;
    end
    else
    begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE CAIXA SET RECEBIDO = :RECEBIDO');
        ParamByName('RECEBIDO').AsString := '';
        ExecSQL;
    end;
  end;
end;

function TdmCargaPDV.EnviaCargaAlterados(lblProgresso:TLabel;pb:TProgressBar):boolean;
var
  oProduto:TProduto;
  oCliente:TCliente;
  oFuncionario:TFuncionario;
  oFinalizadora:TFinalizadora;
begin
with qrCargaPDVPesquisar do
begin
  // clientes
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM CARGA WHERE TABELA = :TABELA');
  ParamByName('TABELA').AsString := 'CLIENTE';
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oCliente := TCliente.Create;
  oCliente.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oClienteController.CarregarCliente(oCliente);
  dmCargaCaixa.EnviaCliente(oCliente);
  oCliente.Destroy;
  qrCargaPDVPesquisar.Next;
  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Clientes: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;

  // funcionarios
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM CARGA WHERE TABELA = :TABELA');
  ParamByName('TABELA').AsString := 'FUNCIONARIO';
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oFuncionario := TFuncionario.Create;
  oFuncionario.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
  dmCargaCaixa.EnviaFuncionario(oFuncionario);
  oFuncionario.Destroy;
  qrCargaPDVPesquisar.Next;
  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Funcionarios: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;

  // finalizadora
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM CARGA WHERE TABELA = :TABELA');
  ParamByName('TABELA').AsString := 'FINALIZADORA';
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oFinalizadora := TFinalizadora.Create;
  oFinalizadora.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora);
  dmCargaCaixa.EnviaFinalizadora(oFinalizadora);
  oFinalizadora.Destroy;
  qrCargaPDVPesquisar.Next;

  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Finalizadora: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;


  // produtos
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM CARGA WHERE TABELA = :TABELA');
  ParamByName('TABELA').AsString := 'PRODUTO';
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oProduto := TProduto.Create;
  oProduto.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
  dmCargaCaixa.EnviaProduto(oProduto);
  oProduto.Destroy;
  qrCargaPDVPesquisar.Next;
  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Produtos: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;

//





end;
end;

function TdmCargaPDV.EnviaCargaCompleta(lblProgresso: TLabel;
  pb: TProgressBar): boolean;
var
  oProduto:TProduto;
  oCliente:TCliente;
  oFuncionario:TFuncionario;
  oFinalizadora:TFinalizadora;
begin
with qrCargaPDVPesquisar do
begin
  // clientes
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM CLIENTE');
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oCliente := TCliente.Create;
  oCliente.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oClienteController.CarregarCliente(oCliente);
  dmCargaCaixa.EnviaCliente(oCliente);
  oCliente.Destroy;
  qrCargaPDVPesquisar.Next;
  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Clientes: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;

  // funcionarios
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM FUNCIONARIO');
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oFuncionario := TFuncionario.Create;
  oFuncionario.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
  dmCargaCaixa.EnviaFuncionario(oFuncionario);
  oFuncionario.Destroy;
  qrCargaPDVPesquisar.Next;
  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Funcionarios: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;

  // finalizadora
  Close;
  SQL.Clear;
  SQL.Add('SELECT CODIGO FROM FINALIZADORA');
  Open;
  pb.Max := qrCargaPDVPesquisar.RecordCount;
  while not qrCargaPDVPesquisar.eof do
  begin
  oFinalizadora := TFinalizadora.Create;
  oFinalizadora.Codigo := FieldByName('CODIGO').AsString;
  VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora);
  dmCargaCaixa.EnviaFinalizadora(oFinalizadora);
  oFinalizadora.Destroy;
  qrCargaPDVPesquisar.Next;

  // progress bar

  pb.Position :=qrCargaPDVPesquisar.RecNo;
  lblProgresso.caption := 'Finalizadora: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
  Application.Processmessages;
  end;


  // produtos
//  Close;
//  SQL.Clear;
//  SQL.Add('SELECT CODIGO FROM PRODUTO');
//  Open;
//  pb.Max := qrCargaPDVPesquisar.RecordCount;
//  while not qrCargaPDVPesquisar.eof do
//  begin
//  oProduto := TProduto.Create;
//  oProduto.Codigo := FieldByName('CODIGO').AsString;
//  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
//  dmCargaCaixa.EnviaProduto(oProduto);
//  oProduto.Destroy;
//  qrCargaPDVPesquisar.Next;
//  // progress bar
//
//  pb.Position :=qrCargaPDVPesquisar.RecNo;
//  lblProgresso.caption := 'Produtos: ' +IntToStr(qrCargaPDVPesquisar.RecNo) + '/' +IntToStr(qrCargaPDVPesquisar.RecordCount);
//  Application.Processmessages;
//  end;

  // proprio


end;
end;

function TdmCargaPDV.EnviaParametros: boolean;
var
  oTributacao:TTributacao;
  oProprio:TProprio;
  oAcessoPDV:TAcessoPDV;
  oConfigPDV:TConfiguracoesPDV;
begin
  // carregar tributação
  with qrCargaPDVPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.add('SELECT CODIGO FROM TRIBUTACAO');
    Open;
    while not qrCargaPDVPesquisar.eof do
    begin
      oTributacao := TTributacao.Create;
      oTributacao.Codigo := FieldByName('CODIGO').AsString;
      VariaveisSrv.oTributacaoController.CarregarTributacao(oTributacao);
      dmCargaCaixa.EnviaTributacao(oTributacao);
      oTributacao.Destroy;
      Next;
    end;

  end;
  // carregar proprio
  with qrCargaPDVPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.add('SELECT CODIGO FROM proprio');
    Open;
    while not qrCargaPDVPesquisar.eof do
    begin
      oProprio := TProprio.Create;
      oProprio.Codigo := FieldByName('CODIGO').AsString;
      VariaveisSrv.oProprioController.CarregarProprio(oProprio);
      dmCargaCaixa.EnviaProprio(oProprio);
      oProprio.Destroy;
      Next;
    end;

  end;

  // NÍVEL DE ACESSO
  with qrCargaPDVPesquisar do
  begin
    Close;
    SQL.Clear;
    SQL.add('SELECT FUNCDESC FROM CAIXA_FUNCOES');
    Open;
    while not qrCargaPDVPesquisar.eof do
    begin
      oAcessoPDV := TAcessoPDV.Create;
      oAcessoPDV.Descricao := FieldByName('FUNCDESC').AsString;
      VariaveisSrv.oUtilsController.preencherNivelAcesso(oAcessoPDV);
      dmCargaCaixa.EnviaAcessoPDV(oAcessoPDV);
      oAcessoPDV.Destroy;
      Next;
    end;

  end;
  // CONFIGURACOES
  with qrCargaPDVPesquisar do
  begin
    close;
    sql.Clear;
    sql.Add('SELECT PDV_LIMITE_DESCONTO_PERC FROM CONFIGURACOES');
    Open;

    while not qrCargaPDVPesquisar.Eof do
    begin
      oConfigPDV := TConfiguracoesPDV.create;
      oConfigPDV.limite_desconto_perc := qrCargaPDVPesquisar.FieldByName('PDV_LIMITE_DESCONTO_PERC').AsFloat;
      dmCargaCaixa.EnviaConfigPDV(oConfigPDV);
      oConfigPDV.Destroy;
      qrCargaPDVPesquisar.Next;
    end;

  end;


end;

function TdmCargaPDV.EnviarCargaPDV(tipo:TCarga;oCaixa:TCaixa;lblProgresso:TLabel;pb:TProgressBar):boolean;
begin
  if(dmCargaCaixa.HostDisponivel(oCaixa.IP,1) = true) then
  begin
      try
        dmCargaCaixa.ConfigurarConexaoPDV(oCaixa);
        EnviaParametros;
        case tipo of
          cgAlterados:
          begin
          EnviaCargaAlterados(lblProgresso,pb);
          end;
          cgCompleta:
          begin
          EnviaCargaCompleta(lblProgresso,pb);
          end;
        end;
        AtualizarRecebimento('S',oCaixa);
        result := true;

        except
        on E:Exception do
        begin
        AtualizarRecebimento('N',oCaixa);
        result := false;
        MessageDlg('Erro ao enviar carga, mensagem: '+E.message,mtError,[mbOK],0);
        end;

      end;
  end
  else
  begin
    AtualizarRecebimento('N',oCaixa);
    result := false;
  end;
end;

function TdmCargaPDV.EnviarExclusaoPDV: Boolean;
begin
result := false;
try
with qrExcluirPDV do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM CARGA_EXCLUIR WHERE TABELA = :TABELA');
  ParamByName('TABELA').AsString := 'PRODUTO';
  Open;

  while not qrExcluirPDV.Eof do
  begin
    dmCargaCaixa.EnviaExclusao('PRODUTO',FieldByName('CODIGO').AsString);
    qrExcluirPDV.Next;
  end;
  result := true;
end;
except
on E:Exception do
begin
  raise Exception.Create('Erro ao verificar exclusões: '+ E.message);
end;

end;
end;

function TdmCargaPDV.GerarCargaTerminalConsulta: boolean;
begin
with qrCargaTerminal do
begin

end;
end;

function TdmCargaPDV.InsertFilaExcluir(tabela, codigo: string): Boolean;
begin
with qrCargaExcluirPDVInsert do
begin
try
ParamByName('CODIGO').AsString := codigo;
ParamByName('TABELA').AsString := tabela;
ExecSQL;
except
on E:Exception do
begin
  raise Exception.Create('Erro ao criar exclusão para item'+ e.Message);
end;

end;
end;

end;

procedure TdmCargaPDV.ZerarCargaAlterados;
begin
qrCargaPDVExcluir.ExecSQL;
end;

function TdmCargaPDV.ZerarExclusaoPDV: Boolean;
begin
qrZerarExclusaoPDV.ExecSQL;
end;

end.
