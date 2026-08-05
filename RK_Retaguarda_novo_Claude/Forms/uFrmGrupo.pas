unit uFrmGrupo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvToolEdit, Vcl.StdCtrls, JvExMask,
  JvBaseEdits, Vcl.Mask, RzEdit, RzDBEdit, RzDBBnEd, NxEdit, NxColumns,
  NxColumnClasses, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,
  Vcl.ComCtrls, AdvGlowButton, Vcl.ExtCtrls ,Conversao,Classe.Grupo,Classe.Variaveis,
  Vcl.Menus;

type
  TfrmGrupo = class(TForm)
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
    pcGrupo: TPageControl;
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
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure gridCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure gridDblClick(Sender: TObject);
    procedure pcGrupoChange(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oGrupo:TGrupo);
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmGrupo: TfrmGrupo;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

{ TfrmGrupo }

procedure TfrmGrupo.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmGrupo.Alterar;
var
  oGrupo:TGrupo;
begin
  oGrupo := TGrupo.Create;
  with oGrupo do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    VariaveisSrv.oGrupoController.alterarGrupo(oGrupo);
  end;

  oGrupo.Destroy;

end;

procedure TfrmGrupo.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmGrupo.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmGrupo.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmGrupo.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmGrupo.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmGrupo.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmGrupo.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmGrupo.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmGrupo.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oGrupoController.PreencherGrid(edtloc.text,grid,nome);
  end
  else
  begin
      VariaveisSrv.oGrupoController.PreencherGrid(edtloc.text,grid,codigo);
  end;
end;

procedure TfrmGrupo.Excluir;
var
  oGrupo:TGrupo;
begin
    If  MessageDlg('Tem certeza que deseja excluir o grupo: '+grid.Cell[1,grid.selectedrow].AsString   ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oGrupo:= TGrupo.Create;
      oGrupo.codigo := grid.Cell[0,grid.selectedrow].AsString;
      VariaveisSrv.oGrupoController.ExcluirGrupo(oGrupo);
      HabilitarControles(opNavegar);
      oGrupo.Destroy;
    end;

end;

procedure TfrmGrupo.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmGrupo.g1Click(Sender: TObject);
begin
if btnGravar.enabled then
btnGravar.Click;
end;

procedure TfrmGrupo.Gravar;
begin
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmGrupo.gridCellClick(Sender: TObject; ACol, ARow: Integer);
var
  oGrupo:TGrupo;
begin
  if FOperacao = opNavegar then
  begin
      oGrupo := TGrupo.Create;
      oGrupo.codigo := grid.Cell[0, grid.SelectedRow].AsString;
      VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo);
      PreencherCampos(oGrupo);
      oGrupo.Destroy;
  end;
end;

procedure TfrmGrupo.gridDblClick(Sender: TObject);
begin
btnAlterar.Click;
end;

procedure TfrmGrupo.HabilitarControles(aOperacao: TOperacao);
var
  oGrupo:TGrupo;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigo.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcGrupo.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oGrupo := TGrupo.Create;
      oGrupo.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('GRUPO','CODIGO');
      PreencherCampos(oGrupo);
      freeandnil(oGrupo);
      //
      edtDescricao.SetFocus;

      FOperacao := opNovo;
    end;
    opAlterar:begin
          if grid.RowCount > 0 then
      begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcGrupo.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;



        oGrupo := TGrupo.Create;
        oGrupo.Codigo := grid.Cell[0,grid.SelectedRow].AsString;
        VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo);
        PreencherCampos(oGrupo);
        FOperacao := opAlterar;
        finally
          FreeAndNil(oGrupo);
        end;
      end;




    end;

    opNavegar:begin
      pcGrupo.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oGrupo := TGrupo.Create;
      PreencherCampos(oGrupo);
      VariaveisSrv.oGrupoController.PreencherGrid('',grid,nome);

      FOperacao := opNavegar;
      freeandnil(OgRUPO);

    end;
  end;
finally

end;
end;

procedure TfrmGrupo.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
btnIncluir.Click;
end;

procedure TfrmGrupo.Incluir;
var
  oGrupo:TGrupo;
begin
  oGrupo := TGrupo.Create;
  with oGrupo do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    VariaveisSrv.oGrupoController.InserirGrupo(oGrupo);
  end;

  oGrupo.Destroy;

end;

procedure TfrmGrupo.pcGrupoChange(Sender: TObject);
begin
if (pcGrupo.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? o grupo não sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcGrupo.ActivePage := tsLista;
end
else
begin
pcGrupo.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmGrupo.PreencherCampos(oGrupo: TGrupo);
begin
with oGrupo do
begin
  edtCodigo.text := Codigo;
  edtDescricao.Text := Descricao;
end;
end;

procedure TfrmGrupo.S1Click(Sender: TObject);
begin
Close;
end;

end.
