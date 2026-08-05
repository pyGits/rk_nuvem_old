unit uFrmImpressao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ACBrBase, ACBrPosPrinter,
  ACBrGIF, Classe.Variaveis, frxClass,Classe.Prevenda, frxDBSet, Data.DB,Classe.Funcionario,Classe.Cliente,
  Datasnap.DBClient;

type
  TfrmImpressao = class(TForm)
    ACBrGIF1: TACBrGIF;
    impressora: TACBrPosPrinter;
    timer_fechar: TTimer;
    frxReport1: TfrxReport;
    dbPrevenda: TClientDataSet;
    dbPrevendaCODIGO: TStringField;
    frxDBDataset1: TfrxDBDataset;
    dbPrevendaCLIENTE_CODIGO: TStringField;
    dbPrevendaCLIENTE_NOME: TStringField;
    dbPrevendaCLIENTE_CNPJCPF: TStringField;
    dbPrevendaCLIENTE_CEP: TStringField;
    dbPrevendaCLIENTE_ENDERECO: TStringField;
    dbPrevendaCLIENTE_NUMERO: TStringField;
    dbPrevendaCLIENTE_COMPLEMENTO: TStringField;
    ClientDataSet1: TClientDataSet;
    frxDBDataset2: TfrxDBDataset;
    ClientDataSet1SEQ: TIntegerField;
    ClientDataSet1NOME: TStringField;
    ClientDataSet1QTDE: TFloatField;
    ClientDataSet1TOTAL: TFloatField;
    dbPrevendaPREVENDA_TOTAL: TFloatField;
    dbPrevendaFUNCIONARIO_CODIGO: TStringField;
    dbPrevendaFUNCIONARIO_NOME: TStringField;
    procedure timer_fecharTimer(Sender: TObject);
  private
    procedure inicializarConfiguracao;
  public
    class procedure imprimir_prevenda_completo(nPrevenda:string;nTerminal:string);
  end;

var
  frmImpressao: TfrmImpressao;

implementation

{$R *.dfm}

{ TfrmImpressao }

class procedure TfrmImpressao.imprimir_prevenda_completo(nPrevenda: string;nTerminal:string);
var
  cupom_impressao:TStringList;
  frm:TfrmImpressao;
  prevenda:TPrevenda;
  prevendaitem:TPrevendaItem;
  funcionario:TFuncionario;
  cliente:TCliente;

begin
frm := TfrmImpressao.Create(nil);
frm.ShowModal;
Application.ProcessMessages;
frm.inicializarConfiguracao;




if frm.impressora.Porta = 'PDF' then
begin
prevenda := VariaveisSrv.oPreVendaController.Carregar(nPrevenda,nTerminal);

funcionario := TFuncionario.create;
funcionario.Codigo := prevenda.funcionario;
VariaveisSrv.oFuncionarioController.CarregarFuncionario(funcionario);

cliente := TCliente.create;
cliente.codigo := prevenda.cliente;
VariaveisSrv.oClienteController.CarregarCliente(cliente);






frm.dbPrevenda.CreateDataSet;
frm.dbPrevenda.Append;
frm.dbPrevenda.Fieldbyname('CODIGO').asstring := prevenda.codigo;
frm.dbPrevenda.Fieldbyname('CLIENTE_CODIGO').asstring := cliente.codigo;
frm.dbPrevenda.Fieldbyname('CLIENTE_NOME').asstring := cliente.Pessoa.nome;
frm.dbPrevenda.Fieldbyname('CLIENTE_CNPJCPF').asstring := cliente.Pessoa.CPFCNPJ;
frm.dbPrevenda.Fieldbyname('CLIENTE_CEP').asstring := cliente.Endereco.CEP;
frm.dbPrevenda.Fieldbyname('CLIENTE_ENDERECO').asstring := cliente.Endereco.Endereco;
frm.dbPrevenda.Fieldbyname('CLIENTE_NUMERO').asstring := cliente.Endereco.Numero;
frm.dbPrevenda.Fieldbyname('CLIENTE_COMPLEMENTO').asstring := cliente.Endereco.Complemento;

frm.dbPrevenda.Fieldbyname('FUNCIONARIO_CODIGO').asstring := funcionario.codigo;
frm.dbPrevenda.Fieldbyname('FUNCIONARIO_NOME').asstring := funcionario.Pessoa.nome;

frm.dbPrevenda.Fieldbyname('PREVENDA_TOTAL').AsFloat := prevenda.valorTotal;

frm.dbPrevenda.Post;

frm.ClientDataSet1.CreateDataSet;
for prevendaitem in prevenda.items do
  begin
  frm.ClientDataSet1.Append;
  frm.ClientDataSet1.FieldByName('SEQ').asinteger := prevendaitem.item;
  frm.ClientDataSet1.FieldByName('NOME').AsString := prevendaitem.produto.Descricao;
  frm.ClientDataSet1.FieldByName('QTDE').ASFLOAT := prevendaitem.qtde;
  frm.ClientDataSet1.FieldByName('TOTAL').ASFLOAT := prevendaitem.valorTotal;
  end;


frm.frxreport1.LoadFromFile('\System_RK\server\relatorios\cpPreVenda.fr3');
frm.frxReport1.ShowReport;
end
else
begin
  cupom_impressao := VariaveisSrv.oPreVendaController.Imprimir_Cupom_Completo(nPrevenda,nTerminal);
  try
  frm.impressora.Ativar;
  frm.impressora.buffer.clear;
  frm.impressora.buffer.AddStrings(cupom_impressao);
  frm.impressora.PularLinhas(5);
  frm.impressora.buffer.add('</corte_total>');
  frm.impressora.imprimir();
  finally
  frm.impressora.Desativar;
  end;

end;

end;

procedure TfrmImpressao.inicializarConfiguracao;
begin
impressora.Porta := VariaveisSrv.oConfiguracoes.impressora_porta;
end;

procedure TfrmImpressao.timer_fecharTimer(Sender: TObject);
begin
Close;
end;

end.
