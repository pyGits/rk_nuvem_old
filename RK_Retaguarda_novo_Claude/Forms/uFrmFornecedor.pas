unit uFrmFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Conversao,Classe.Fornecedor,Classe.Variaveis,
  Data.DB, Vcl.Grids, Vcl.DBGrids, ACBrBase, ACBrSocket, ACBrCEP,Classe.Funcoes,
  IPPeerClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, ACBrConsultaCNPJ,System.JSON;

type
  TfrmFornecedor = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    btnAlterar: TAdvGlowButton;
    btnExcluir: TAdvGlowButton;
    btnIncluir: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    pcFornecedor: TPageControl;
    tsLista: TTabSheet;
    tsDetalhe: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    Grid: TDBGrid;
    ds: TDataSource;
    edtApelido: TEdit;
    Label3: TLabel;
    edtEndereco: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtNumero: TEdit;
    Label7: TLabel;
    edtComplemento: TEdit;
    Label8: TLabel;
    edtCEP: TEdit;
    Label9: TLabel;
    edtBairro: TEdit;
    Label10: TLabel;
    cbUF: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    edtCPFCNPJ: TEdit;
    Label13: TLabel;
    edtIE: TEdit;
    edtIM: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    edtEmail: TEdit;
    Label16: TLabel;
    edtTelefone1: TEdit;
    Label17: TLabel;
    edtTelefone2: TEdit;
    Label18: TLabel;
    edtCelular: TEdit;
    Label19: TLabel;
    edtObservacao: TEdit;
    cbCidade: TComboBox;
    ACBRCep1: TACBrCEP;
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure FormShow(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure cbUFChange(Sender: TObject);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure ACBrCEP1BuscaEfetuada(Sender: TObject);
    procedure edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure edtIEKeyPress(Sender: TObject; var Key: Char);
    procedure edtIMKeyPress(Sender: TObject; var Key: Char);
    procedure edtObservacaoKeyPress(Sender: TObject; var Key: Char);
    procedure GridCellClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure pcFornecedorChange(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure edtCPFCNPJExit(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oFornecedor:TFornecedor);
    procedure ConsultarCNPJ(CNPJ:string);
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmFornecedor: TfrmFornecedor;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

{ TfrmFornecedor }

procedure TfrmFornecedor.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmFornecedor.ACBrCEP1BuscaEfetuada(Sender: TObject);
var
   i : integer;
begin
    for I := 0 to ACBrCEP1.Enderecos.Count -1 do
    begiN
    edtEndereco.Text := ACBrCEP1.Enderecos[i].Logradouro;
    edtComplemento.Text := ACBrCEP1.Enderecos[i].Complemento;
    cbUF.ItemIndex := cbUF.Items.IndexOf(ACBrCEP1.Enderecos[i].UF);
    VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
    cbCidade.ItemIndex :=   cbCidade.Items.IndexOf(RemoveAcento(ACBrCEP1.Enderecos[i].Municipio));
    edtBairro.Text := ACBrCEP1.Enderecos[i].Bairro;

    end;
end;

procedure TfrmFornecedor.Alterar;
var
  oFornecedor:TFornecedor;
begin
  oFornecedor := TFornecedor.Create;
  with oFornecedor do
  begin
    Codigo := edtCodigo.text;
    Pessoa.Nome := edtDescricao.text;
    Pessoa.Apelido := edtApelido.Text;
    Pessoa.Telefone1 := edtTelefone1.text;
    Pessoa.Telefone2 := edtTelefone2.text;
    pessoa.Celular1 := edtCelular.text;
    Pessoa.Email := edtEmail.text;
    Pessoa.CPFCNPJ := edtCPFCNPJ.text;

    IE :=edtIE.text;
    IM := edtIM.Text;
    Observacao := edtObservacao.text;

    Endereco.Endereco := edtEndereco.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := cbCidade.Text;
    Endereco.UF := cbUF.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Complemento := edtComplemento.Text;
    VariaveisSrv.oFornecedorController.alterarFornecedor(oFornecedor);
  end;

  oFornecedor.Destroy;

end;

procedure TfrmFornecedor.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmFornecedor.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmFornecedor.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmFornecedor.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmFornecedor.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmFornecedor.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmFornecedor.Cancelar;
begin
 HabilitarControles(opNavegar);
end;

procedure TfrmFornecedor.cbUFChange(Sender: TObject);
begin
VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
end;

procedure TfrmFornecedor.ConsultarCNPJ(CNPJ: string);
var
  retorno:TJsonObject;
  arrayRetorno :TJsonArray;
  label Inicio;
begin

RESTClient1.BaseURL := 'https://www.receitaws.com.br/v1/cnpj/'+CNPJ;
try
Inicio:
RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode = 429 then
  begin
    Sleep(2);
    goto Inicio;
  end
  else
  begin
  retorno := RESTRequest1.Response.JSONValue as TJSONObject;
  edtDescricao.text := retorno.GetValue('nome').Value;
  edtApelido.text :=  retorno.GetValue('nome').Value;
  edtBairro.text := retorno.GetValue('bairro').Value;
  edtCEP.text := removeLetras(retorno.GetValue('cep').Value);
  edtNumero.text := retorno.GetValue('numero').Value;
  edtEndereco.text := retorno.GetValue('logradouro').Value;
  edtComplemento.text := retorno.GetValue('complemento').Value;
  cbUf.ItemIndex := cbUf.Items.IndexOf(retorno.GetValue('uf').Value);
  VariaveisSrv.oUtilsController.PreencheCidade(retorno.GetValue('uf').Value,cbCidade);
  cbCidade.ItemIndex := cbCidade.Items.IndexOf(RemoveAcento(retorno.GetValue('municipio').Value));
  edtEmail.text := retorno.GetValue('email').Value;
  edtDescricao.setfocus;
  end;
except

end;

end;

procedure TfrmFornecedor.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmFornecedor.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  if edtCEP.text <> '' then
  begin
    ACBrCEP1.BuscarPorCEP(edtCEP.text);
  end;
  edtEndereco.SetFocus;
end;
end;

procedure TfrmFornecedor.edtCPFCNPJExit(Sender: TObject);
var
  oFornecedor:TFornecedor;
begin
  if FOperacao = opNovo then
  begin
    oFornecedor := TFornecedor.Create;
    oFornecedor.Pessoa.CPFCNPJ := edtCPFCNPJ.text;
    if VariaveisSrv.oFornecedorController.VerificaFornecedor(oFornecedor) then
    begin

        // ja existe fornecedor cadastrado com esse cnpj
        If  MessageDlg('Já existe um fornecedor cadastrado com esse CNPJ/CPF, deseja visualizar ?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
          PreencherCampos(oFornecedor);
          HabilitarControles(opAlterar);
        end
        else
        begin
          btnCancelar.Click;
        end;


    end;

    oFornecedor.Destroy;
  end;

end;

procedure TfrmFornecedor.edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Length(edtCPFCNPJ.Text) = 14 then
    begin
    If  MessageDlg('Deseja fazer busca por CNPJ ?, pode demorar de acordo com o servidor da Receita',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
    ConsultarCNPJ(edtCPFCNPJ.text);
    end;
    end;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;

end;

procedure TfrmFornecedor.edtIEKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmFornecedor.edtIMKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;

end;

procedure TfrmFornecedor.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oFornecedorController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  begin
      VariaveisSrv.oFornecedorController.PreencherGrid(edtloc.text,ds,codigo);
  end;

end;

procedure TfrmFornecedor.edtObservacaoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
btnGravar.SetFocus;
end;
end;

procedure TfrmFornecedor.Excluir;
var
  oFornecedor:TFornecedor;
begin
    If  MessageDlg('Tem certeza que deseja excluir o Fornecedor: '+grid.Fields[1].AsString   ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oFornecedor:= TFornecedor.Create;
      oFornecedor.codigo := grid.Fields[0].AsString;
      VariaveisSrv.oFornecedorController.ExcluirFornecedor(oFornecedor);
      HabilitarControles(opNavegar);
      oFornecedor.Destroy;
    end;

end;

procedure TfrmFornecedor.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmFornecedor.g1Click(Sender: TObject);
begin
if btnGravar.enabled then
btnGravar.Click;
end;

procedure TfrmFornecedor.Gravar;
begin
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmFornecedor.GridCellClick(Column: TColumn);
var
  oFornecedor:TFornecedor;
begin
  if FOperacao = opNavegar then
  begin
      oFornecedor := TFornecedor.Create;
      oFornecedor.Codigo := grid.Fields[0].AsString;
      VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor);
      PreencherCampos(oFornecedor);
      oFornecedor.Destroy;
  end;
end;

procedure TfrmFornecedor.GridDblClick(Sender: TObject);
begin
if btnAlterar.Enabled then
btnAlterar.Click;
end;

procedure TfrmFornecedor.HabilitarControles(aOperacao: TOperacao);
var
  oFornecedor:TFornecedor;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigo.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcFornecedor.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oFornecedor := TFornecedor.Create;
      oFornecedor.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('Fornecedor','CODIGO');
      PreencherCampos(oFornecedor);
      freeandnil(oFornecedor);
      //
        edtCPFCNPJ.Enabled := true;
      edtCPFCNPJ.setfocus;


      FOperacao := opNovo;
    end;
    opAlterar:begin
          if edtCodigo.Text <> '' then
      begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcFornecedor.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;

        edtCPFCNPJ.Enabled := false;
        edtDescricao.setFocus;




        oFornecedor := TFornecedor.Create;
        oFornecedor.Codigo := grid.Fields[0].AsString;
        VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor);
        PreencherCampos(oFornecedor);
        FOperacao := opAlterar;
        finally
          FreeAndNil(oFornecedor);
        end;
      end;




    end;

    opNavegar:begin
      FOperacao := opNavegar;
      pcFornecedor.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oFornecedor := TFornecedor.Create;
      PreencherCampos(oFornecedor);
      VariaveisSrv.oFornecedorController.PreencherGrid('',ds,nome);
      VariaveisSrv.oUtilsController.PreencheUF(cbUF);


      oFornecedor.Destroy;

    end;
  end;
finally

end;
end;

procedure TfrmFornecedor.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
btnIncluir.Click;
end;

procedure TfrmFornecedor.Incluir;
var
  oFornecedor:TFornecedor;
begin
  oFornecedor := TFornecedor.Create;
  with oFornecedor do
  begin
    Codigo := edtCodigo.text;
    Pessoa.Nome := edtDescricao.text;
    Pessoa.Apelido := edtApelido.Text;
    Pessoa.Telefone1 := edtTelefone1.text;
    Pessoa.Telefone2 := edtTelefone2.text;
    pessoa.Celular1 := edtCelular.text;
    Pessoa.Email := edtEmail.text;
    Pessoa.CPFCNPJ := edtCPFCNPJ.text;

    IE :=edtIE.text;
    IM := edtIM.Text;
    Observacao := edtObservacao.text;

    Endereco.Endereco := edtEndereco.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := cbCidade.Text;
    Endereco.UF := cbUF.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Complemento := edtComplemento.Text;
    VariaveisSrv.oFornecedorController.InserirFornecedor(oFornecedor);
  end;

  oFornecedor.Destroy;

end;

procedure TfrmFornecedor.pcFornecedorChange(Sender: TObject);
begin
if (pcFornecedor.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? o fornecedor não sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcFornecedor.ActivePage := tsLista;
end
else
begin
pcFornecedor.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmFornecedor.PreencherCampos(oFornecedor: TFornecedor);
begin
  with oFornecedor do
  begin
  edtCodigo.text:=Codigo;
  edtDescricao.text:=Pessoa.Nome;
  edtApelido.Text:=Pessoa.Apelido;
  edtTelefone1.text:=Pessoa.Telefone1;
  edtTelefone2.text:=Pessoa.Telefone2;
  edtCelular.text:=pessoa.Celular1;
  edtEmail.text:=Pessoa.Email;
  edtCPFCNPJ.text:=Pessoa.CPFCNPJ;

  edtIE.text:=IE;
  edtIM.Text:=IM;
  edtObservacao.text:=Observacao;

  edtEndereco.Text:=Endereco.Endereco;
  edtNumero.Text:=Endereco.Numero;
  edtBairro.Text:=Endereco.Bairro;
    cbUF.ItemIndex := cbUF.Items.IndexOf(Endereco.UF);
    VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
    cbCidade.ItemIndex :=   cbCidade.Items.IndexOf(RemoveAcento(endereco.Cidade));
  edtCEP.Text:=Endereco.CEP;
  edtComplemento.Text:=Endereco.Complemento;

  end;
end;

procedure TfrmFornecedor.S1Click(Sender: TObject);
begin
Close;
end;




end.
