unit uFrmTributacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Conversao,Classe.Tributacao,Classe.Variaveis,
  Vcl.Mask, RzEdit;

type
  TfrmTributacao = class(TForm)
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
    pcTributacao: TPageControl;
    tsLista: TTabSheet;
    grid: TNextGrid;
    NxNumberColumn1: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
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
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxNumberColumn2: TNxNumberColumn;
    Label3: TLabel;
    Label5: TLabel;
    cbCST: TComboBox;
    cbCFOP: TComboBox;
    Label6: TLabel;
    cbCSOSN: TComboBox;
    cbST: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    edtICMS: TRzNumericEdit;
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
    procedure FormShow(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure cbCSTKeyPress(Sender: TObject; var Key: Char);
    procedure cbCFOPKeyPress(Sender: TObject; var Key: Char);
    procedure cbCSOSNKeyPress(Sender: TObject; var Key: Char);
    procedure cbSTKeyPress(Sender: TObject; var Key: Char);
    procedure edtICMSKeyPress(Sender: TObject; var Key: Char);
    procedure cbCSTChange(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure pcTributacaoChange(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure gridSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oTributacao:TTributacao);
    procedure ValidaCampos;
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmTributacao: TfrmTributacao;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmTributacao.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmTributacao.Alterar;
var
  oTributacao:TTributacao;
begin
  oTributacao := TTributacao.Create;
  with oTributacao do
  begin
    Codigo := edtCodigo.text;
    TRIBUTACAO := edtDescricao.text;
    cst :=cbCST.text;
    CFOP := cbCFOP.text;
    CSOSN := cbCSOSN.text;
    st := cbST.Text;
    ICMS := edtICMS.Value;
    VariaveisSrv.oTributacaoController.alterarTributacao(oTributacao);
  end;

  oTributacao.Destroy;

end;

procedure TfrmTributacao.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmTributacao.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmTributacao.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmTributacao.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmTributacao.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmTributacao.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmTributacao.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmTributacao.cbCFOPKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.cbCSOSNKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.cbCSTChange(Sender: TObject);
begin
if cbCST.Text = '00' then
begin
  cbCFOP.Clear;
  cbCSOSN.Clear;
  cbST.Clear;
  cbCFOP.Items.Add('5102');
  cbCSOSN.Items.Add('102');
  cbST.Items.Add('T');
  edtICMS.value := 18;
end
else
if cbCST.Text = '40' then
begin
  cbCFOP.Clear;
  cbCSOSN.Clear;
  cbST.Clear;
  cbCFOP.Items.Add('5102');
  cbCSOSN.Items.Add('300');
  cbST.Items.Add('I');
  edtICMS.value := 0;
end
else
if cbCST.Text = '060' then
begin
  cbCFOP.Clear;
  cbCSOSN.Clear;
  cbST.Clear;
  cbCFOP.Items.Add('5405');
  cbCSOSN.Items.Add('500');
  cbST.Items.Add('F');
  edtICMS.value := 0;
end;
end;

procedure TfrmTributacao.cbCSTKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.cbSTKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.E1Click(Sender: TObject);
begin
if btnExcluir.Enabled then
btnExcluir.click;

end;

procedure TfrmTributacao.edtCodigoExit(Sender: TObject);
var
  oTributacao : TTributacao;
begin
oTributacao := TTributacao.create;
oTributacao.codigo := edtCodigo.text;
if VariaveisSrv.oTributacaoController.CarregarTributacao(oTributacao) then
begin
  // ja existe cadastrado
      If  MessageDlg('Já existe uma tributação cadastrada com esse código , deseja visualizar ?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      PreencherCampos(oTributacao);
      HabilitarControles(opAlterar);
    end
    else
    begin
    tsDetalhe.SetFocus;
    end;


end;
oTributacao.Destroy

end;

procedure TfrmTributacao.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmTributacao.edtICMSKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnGravar.setfocus;
  end;
end;

procedure TfrmTributacao.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oTributacaoController.PreencherGrid(edtloc.text,grid,nome);
  end;
end;

procedure TfrmTributacao.Excluir;
var
  oTributacao:TTributacao;
begin
    If  MessageDlg('Tem certeza que deseja excluir o Tributacao: '+grid.Cell[1,grid.selectedrow].AsString + ' toda a movimentação dele de venda será excluída !' ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oTributacao:= TTributacao.Create;
      oTributacao.codigo := grid.Cell[0,grid.selectedrow].AsString;
      VariaveisSrv.oTributacaoController.ExcluirTributacao(oTributacao);
      HabilitarControles(opNavegar);
      oTributacao.Destroy;
    end;
end;

procedure TfrmTributacao.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmTributacao.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
btnGravar.Click;
end;

procedure TfrmTributacao.Gravar;
begin
    ValidaCampos;
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmTributacao.gridDblClick(Sender: TObject);
begin
btnAlterar.Click;
end;

procedure TfrmTributacao.gridSelectCell(Sender: TObject; ACol, ARow: Integer);
var
  oTributacao:TTributacao;
begin
  if FOperacao = opNavegar then
  begin
      oTributacao := TTributacao.Create;
      oTributacao.codigo := grid.Cell[0, grid.SelectedRow].AsString;
      VariaveisSrv.oTributacaoController.CarregarTributacao(oTributacao);
      PreencherCampos(oTributacao);
      oTributacao.Destroy;
  end;
end;

procedure TfrmTributacao.HabilitarControles(aOperacao: TOperacao);
var
  oTributacao:TTributacao;
begin
try
  case aOperacao of
    opNovo:begin
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := False;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcTributacao.ActivePage := tsDetalhe;
      edtCodigo.Enabled := true;
      // grid
      oTributacao := TTributacao.Create;
      PreencherCampos(oTributacao);
      oTributacao.Destroy;
      //
      edtCodigo.SetFocus;


      FOperacao := opNovo;
    end;
    opAlterar:begin
      if grid.RowCount > 0 then
      begin
        try
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := False;
        // foco
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcTributacao.ActivePage := tsDetalhe;
        edtDescricao.SetFocus;

        oTributacao := TTributacao.Create;
        oTributacao.Codigo := edtCodigo.Text;
        VariaveisSrv.oTributacaoController.CarregarTributacao(oTributacao);
        PreencherCampos(oTributacao);
        FOperacao := opAlterar;
        finally
          FreeAndNil(oTributacao);
        end;
      end;




    end;

    opNavegar:begin
      pcTributacao.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := True;


      VariaveisSrv.oTributacaoController.PreencherGrid('',grid,nome);

      oTributacao := TTributacao.Create;
      if grid.RowCount > 0 then
      begin
      oTributacao.Codigo := grid.Cell[0,grid.SelectedRow].AsString;
      end;
      VariaveisSrv.oTributacaoController.CarregarTributacao(oTributacao);
      PreencherCampos(oTributacao);





      FOperacao := opNavegar;

    end;
  end;
finally

end;
end;

procedure TfrmTributacao.I1Click(Sender: TObject);
begin
if btnIncluir.Enabled then
btnIncluir.Click;
end;

procedure TfrmTributacao.Incluir;
var
  oTributacao:TTributacao;
begin
  oTributacao := TTributacao.Create;
  with oTributacao do
  begin
    Codigo := edtCodigo.text;
    TRIBUTACAO := edtDescricao.text;
    cst :=cbCST.text;
    CFOP := cbCFOP.text;
    CSOSN := cbCSOSN.text;
    st := cbST.Text;
    ICMS := edtICMS.Value;
    VariaveisSrv.oTributacaoController.InserirTributacao(oTributacao);
  end;

  oTributacao.Destroy;
end;

procedure TfrmTributacao.pcTributacaoChange(Sender: TObject);
begin
if (pcTributacao.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? a tributação não sera salva',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcTributacao.ActivePage := tsLista;
end
else
begin
pcTributacao.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmTributacao.PreencherCampos(oTributacao: TTributacao);
begin
with oTributacao do
begin
  edtCodigo.text := Codigo;
  edtDescricao.Text := Tributacao;
  cbCST.TEXT := cst;
  cbCFOP.text := cfop;
  cbCSOSN.text := CSOSN;
  cbST.text := st;
  edtICMS.Value := ICMS;
end;
end;

procedure TfrmTributacao.S1Click(Sender: TObject);
begin
CLOSE;
end;

procedure TfrmTributacao.ValidaCampos;
begin
if Trim(edtCodigo.text) = '' then
begin
  raise Exception.Create('Preencha o campo código !');
end;
if Trim(edtDescricao.text) = '' then
begin
  raise Exception.Create('Preencha o campo Descricao !');
end;
if Trim(cbST.text) = '' then
begin
  raise Exception.Create('Preencha o campo ST !');
end;
if Trim(cbCFOP.text) = '' then
begin
  raise Exception.Create('Preencha o campo CFOP !');
end;
if Trim(cbCST.text) = '' then
begin
  raise Exception.Create('Preencha o campo cst !');
end;
if Trim(cbCSOSN.text) = '' then
begin
  raise Exception.Create('Preencha o campo csosn !');
end;
if edtICMS.value < 0 then
begin
  raise Exception.Create('Icms não pode ser negativo !');
end;
end;

end.
