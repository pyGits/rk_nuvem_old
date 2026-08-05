unit uFrmFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Conversao,Classe.Funcionario,Classe.Variaveis,
  Data.DB, Vcl.Grids, Vcl.DBGrids,Classe.Funcoes, Vcl.Mask, JvExMask,
  JvToolEdit, JvBaseEdits;

type
  TfrmFuncionario = class(TForm)
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
    pcFuncionario: TPageControl;
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
    edtApelido: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    edtEmail: TEdit;
    edtCPF: TEdit;
    Label6: TLabel;
    edtSenha: TEdit;
    Label7: TLabel;
    rdCargo: TRadioGroup;
    Grid: TDBGrid;
    ds: TDataSource;
    edtComissao: TJvCalcEdit;
    Label8: TLabel;
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure pcFuncionarioChange(Sender: TObject);
    procedure GridCellClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oFuncionario:TFuncionario);
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmFuncionario: TfrmFuncionario;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmFuncionario.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmFuncionario.Alterar;
var
  oFuncionario:TFuncionario;
begin
  oFuncionario := TFuncionario.Create;
  with oFuncionario do
  begin
      Codigo := edtCodigo.Text;
      Pessoa.Nome := edtDescricao.text;
      Pessoa.Apelido := edtApelido.text;
      Pessoa.Email := edtEmail.Text;
      Pessoa.CPFCNPJ := edtCPF.text;
      cargo := rdCargo.ItemIndex;
      senha := edtSenha.Text;
      comissao := edtComissao.value;
    VariaveisSrv.oFuncionarioController.alterarFuncionario(oFuncionario);
  end;

  oFuncionario.Destroy;
end;

procedure TfrmFuncionario.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmFuncionario.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmFuncionario.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmFuncionario.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmFuncionario.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmFuncionario.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmFuncionario.Cancelar;
begin
 HabilitarControles(opNavegar);
end;


procedure TfrmFuncionario.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmFuncionario.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;

end;

procedure TfrmFuncionario.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oFuncionarioController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  begin
      VariaveisSrv.oFuncionarioController.PreencherGrid(edtloc.text,ds,codigo);
  end;

end;

procedure TfrmFuncionario.Excluir;
var
  oFuncionario:TFuncionario;
begin
    If  MessageDlg('Tem certeza que deseja excluir o Funcionario: '+grid.Fields[1].AsString   ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oFuncionario:= TFuncionario.Create;
      oFuncionario.codigo := grid.Fields[0].AsString;
      VariaveisSrv.oFuncionarioController.ExcluirFuncionario(oFuncionario);
      HabilitarControles(opNavegar);
      oFuncionario.Destroy;
    end;

end;

procedure TfrmFuncionario.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmFuncionario.g1Click(Sender: TObject);
begin
if btnGravar.enabled then
btnGravar.Click;
end;

procedure TfrmFuncionario.Gravar;
begin
      case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmFuncionario.GridCellClick(Column: TColumn);
var
  oFuncionario:TFuncionario;
begin
  if FOperacao = opNavegar then
  begin
      oFuncionario := TFuncionario.Create;
      oFuncionario.Codigo := grid.Fields[0].AsString;
      VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
      PreencherCampos(oFuncionario);
      oFuncionario.Destroy;
  end;
end;

procedure TfrmFuncionario.GridDblClick(Sender: TObject);
begin
if btnAlterar.Enabled then
begin
  btnAlterar.Click;
end;
end;

procedure TfrmFuncionario.HabilitarControles(aOperacao: TOperacao);
var
  oFuncionario:TFuncionario;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigo.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcFuncionario.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oFuncionario := TFuncionario.Create;
      oFuncionario.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('Funcionario','CODIGO');
      PreencherCampos(oFuncionario);
      freeandnil(oFuncionario);
      //
      edtDescricao.setfocus;

      FOperacao := opNovo;
    end;
    opAlterar:begin
          if edtCodigo.Text <> '' then
      begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcFuncionario.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;



        oFuncionario := TFuncionario.Create;
        oFuncionario.Codigo := grid.Fields[0].AsString;
        VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
        PreencherCampos(oFuncionario);
        FOperacao := opAlterar;
        finally
          FreeAndNil(oFuncionario);
        end;
      end;




    end;

    opNavegar:begin
      pcFuncionario.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oFuncionario := TFuncionario.Create;
      PreencherCampos(oFuncionario);
      VariaveisSrv.oFuncionarioController.PreencherGrid('',ds,nome);

      FOperacao := opNavegar;
      oFuncionario.Destroy;

    end;
  end;
finally

end;
end;

procedure TfrmFuncionario.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
btnIncluir.Click;
end;

procedure TfrmFuncionario.Incluir;
var
  oFuncionario:TFuncionario;
begin
  oFuncionario := TFuncionario.Create;
  with oFuncionario do
  begin
      Codigo := edtCodigo.Text;
      Pessoa.Nome := edtDescricao.text;
      Pessoa.Apelido := edtApelido.text;
      Pessoa.Email := edtEmail.Text;
      Pessoa.CPFCNPJ := edtCPF.text;
      cargo := rdCargo.ItemIndex;
      senha := edtSenha.Text;
      comissao := edtComissao.Value;
    VariaveisSrv.oFuncionarioController.InserirFuncionario(oFuncionario);
  end;

  oFuncionario.Destroy;

end;

procedure TfrmFuncionario.pcFuncionarioChange(Sender: TObject);
begin
if (pcFuncionario.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? o Funcionario não sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcFuncionario.ActivePage := tsLista;
end
else
begin
pcFuncionario.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmFuncionario.PreencherCampos(oFuncionario: TFuncionario);
begin
with oFuncionario do
  begin


    edtCodigo.text := Codigo;
    edtDescricao.text := pessoa.Nome;
    edtApelido.text := pessoa.Apelido;
    edtEmail.text := pessoa.Email;
    edtCPF.Text := Pessoa.CPFCNPJ;
    edtComissao.Value := comissao;
    rdCargo.ItemIndex := cargo;
    edtSenha.Text := Cript('D',senha);

  end;
end;

procedure TfrmFuncionario.S1Click(Sender: TObject);
begin
Close;
end;

end.
