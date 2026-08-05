unit uFrmSubGrupo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Conversao,Classe.Subgrupo,Classe.Variaveis,Classe.Grupo,uFrmLocGrupo,
  Vcl.Menus;

type
  TfrmSubGrupo = class(TForm)
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
    pcSubGrupo: TPageControl;
    tsLista: TTabSheet;
    grid: TNextGrid;
    NxNumberColumn1: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    tsDetalheSub: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    NxTextColumn2: TNxTextColumn;
    Label3: TLabel;
    edtCodigoGrupo: TEdit;
    edtGrupoDesc: TEdit;
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
    procedure edtCodigoGrupoExit(Sender: TObject);
    procedure pcSubGrupoChange(Sender: TObject);
    procedure edtCodigoGrupoKeyPress(Sender: TObject; var Key: Char);
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oSubGrupo:TSubGrupo);
    procedure ValidaCampos;
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmSubGrupo: TfrmSubGrupo;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

{ TfrmSubGrupo }

procedure TfrmSubGrupo.a1Click(Sender: TObject);
begin
btnAlterar.Click;
end;

procedure TfrmSubGrupo.Alterar;
var
  oSubGrupo:TSubGrupo;
begin
  oSubGrupo := TSubGrupo.Create;
  with oSubGrupo do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    codigoGrupo := edtCodigoGrupo.text;
    VariaveisSrv.oSubGrupoController.alterarSubGrupo(oSubGrupo);
  end;

  oSubGrupo.Destroy;

end;

procedure TfrmSubGrupo.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmSubGrupo.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmSubGrupo.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmSubGrupo.btnGravarClick(Sender: TObject);
begin
ValidaCampos;
Gravar;
end;

procedure TfrmSubGrupo.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmSubGrupo.C1Click(Sender: TObject);
begin
if btnCancelar.Enabled then
btnCancelar.Click;
end;

procedure TfrmSubGrupo.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmSubGrupo.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmSubGrupo.edtCodigoGrupoExit(Sender: TObject);
var
  oSubGrupo:TSubGrupo;
begin
  if FOperacao in [opNovo,opAlterar] then
  begin
  oSubGrupo := TSubGrupo.Create;
  TGrupo(oSubGrupo).Codigo := edtCodigoGrupo.Text;

  if VariaveisSrv.oGrupoController.CarregarGrupo(TGrupo(oSubGrupo)) then
  begin
    // encontrou grupo
    edtCodigoGrupo.text := TGrupo(oSubGrupo).Codigo;
    edtGrupoDesc.text := TGrupo(oSubGrupo).Descricao;
    edtDescricao.Enabled := true;
    edtDescricao.SetFocus;
    if FOperacao = opNovo then
    begin
    edtCodigo.Text := VariaveisSrv.oSubGrupoController.RetornaSequencial(oSubGrupo);    
    end;

  end
  else
  begin
    // tela de localizar rapido
    TGrupo(oSubGrupo).Codigo := frmLocGrupo.Exibe;
    if VariaveisSrv.oGrupoController.CarregarGrupo(TGrupo(oSubGrupo)) then
    begin
      // encontrou grupo
      edtCodigoGrupo.text := TGrupo(oSubGrupo).Codigo;
      edtGrupoDesc.text := TGrupo(oSubGrupo).Descricao;
      edtDescricao.Enabled := true;
      edtDescricao.SetFocus;
      if FOperacao = opNovo then
      begin
      edtCodigo.Text := VariaveisSrv.oSubGrupoController.RetornaSequencial(oSubGrupo);      
      end;
    end
    else
    begin
     // nao encontrou restar campos
      edtCodigoGrupo.text := '';
      edtGrupoDesc.text := '';     
      edtCodigoGrupo.SetFocus;
    end;


  end;
  oSubGrupo.Destroy;
  end;

end;

procedure TfrmSubGrupo.edtCodigoGrupoKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then //Se o comando for igual a enter
 Begin
  Key := #0;
  Perform (wm_nextdlgctl, 0, 0); //Para pular de campo em campo
 End;
end;

procedure TfrmSubGrupo.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnGravar.SetFocus;
end;
end;

procedure TfrmSubGrupo.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oSubGrupoController.PreencherGrid(edtloc.text,grid,nome);
  end
  else
  begin
      VariaveisSrv.oSubGrupoController.PreencherGrid(edtloc.text,grid,codigo);
  end;
end;

procedure TfrmSubGrupo.Excluir;
var
  oSubGrupo:TSubGrupo;
begin
    If  MessageDlg('Tem certeza que deseja excluir o SubGrupo: '+grid.Cell[2,grid.selectedrow].AsString  ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oSubGrupo:= TSubGrupo.Create;
      oSubGrupo.codigo := grid.Cell[0,grid.selectedrow].AsString;   
      oSubGrupo.codigoGrupo := Copy(grid.Cell[1, grid.SelectedRow].AsString,0,6);
      VariaveisSrv.oSubGrupoController.ExcluirSubGrupo(oSubGrupo);
      HabilitarControles(opNavegar);
      oSubGrupo.Destroy;
    end;

end;

procedure TfrmSubGrupo.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmSubGrupo.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
btnGravar.Click;
end;

procedure TfrmSubGrupo.Gravar;
begin
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmSubGrupo.gridCellClick(Sender: TObject; ACol, ARow: Integer);
var
  oSubGrupo:TSubGrupo;
begin
  if FOperacao = opNavegar then
  begin
      oSubGrupo := TSubGrupo.Create;
      oSubGrupo.codigo := grid.Cell[0, grid.SelectedRow].AsString;
      oSubGrupo.codigoGrupo :=  Copy(grid.Cell[1, grid.SelectedRow].AsString,0,6);
      VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubGrupo);
      PreencherCampos(oSubGrupo);
      oSubGrupo.Destroy;
  end;
end;

procedure TfrmSubGrupo.gridDblClick(Sender: TObject);
begin
btnAlterar.Click;
end;

procedure TfrmSubGrupo.HabilitarControles(aOperacao: TOperacao);
var
  oSubGrupo:TSubGrupo;
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
      edtLoc.Enabled := false;
      // grid
      oSubGrupo := TSubGrupo.Create;
      oSubGrupo.Codigo := '';
      PreencherCampos(oSubGrupo);
      oSubGrupo.Destroy;

      FOperacao := opNovo;
      // foco pagina
      edtDescricao.Enabled := False;
      edtCodigo.Enabled := true;
      tsDetalheSub.Enabled := true;
      pcSubGrupo.ActivePage := tsDetalheSub;
      edtCodigoGrupo.Enabled := true;      
      edtCodigoGrupo.SetFocus;
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
        edtLoc.Enabled := false;

        oSubGrupo := TSubGrupo.Create;
        oSubGrupo.Codigo := grid.Cell[0,grid.SelectedRow].AsString;
        oSubGrupo.codigoGrupo :=  Copy(grid.Cell[1, grid.SelectedRow].AsString,0,6);        
        VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubGrupo);
        PreencherCampos(oSubGrupo);

        FOperacao := opAlterar;
        // foco
        edtCodigo.Enabled := false;
        edtCodigoGrupo.Enabled := false;

        tsDetalheSub.Enabled := true;
        pcSubGrupo.ActivePage := tsDetalheSub;
        edtDescricao.Enabled := true;
        edtDescricao.setFocus;

        finally
          FreeAndNil(oSubGrupo);
        end;
      end;




    end;

    opNavegar:begin

      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oSubGrupo := TSubGrupo.Create;
      PreencherCampos(oSubGrupo);
      VariaveisSrv.oSubGrupoController.PreencherGrid('',grid,nome);

      FOperacao := opNavegar;

      pcSubGrupo.ActivePage := tsLista;
      tsDetalheSub.Enabled := false;
      edtDescricao.Enabled := False;

      freeandnil(oSubGrupo);

    end;
  end;
finally

end;
end;

procedure TfrmSubGrupo.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
begin
btnIncluir.Click;
end;
end;

procedure TfrmSubGrupo.Incluir;
var
  oSubGrupo:TSubGrupo;
begin
  oSubGrupo := TSubGrupo.Create;
  with oSubGrupo do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    codigoGrupo := edtCodigoGrupo.text;
    VariaveisSrv.oSubGrupoController.InserirSubGrupo(oSubGrupo);
  end;

  oSubGrupo.Destroy;

end;

procedure TfrmSubGrupo.pcSubGrupoChange(Sender: TObject);
begin
if (pcSubGrupo.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? o subgrupo não sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcSubGrupo.ActivePage := tsLista;
end
else
begin
pcSubGrupo.ActivePage := tsDetalheSub;
end;
end;
end;

procedure TfrmSubGrupo.PreencherCampos(oSubGrupo: TSubGrupo);
begin
with oSubGrupo do
begin
  edtCodigo.text := Codigo;
  edtDescricao.Text := Descricao;
  edtCodigoGrupo.Text := codigoGrupo;
  edtGrupoDesc.text := TGrupo(oSubGrupo).Descricao;
end;
end;

procedure TfrmSubGrupo.S1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmSubGrupo.ValidaCampos;
begin
if edtCodigo.text = '000000' then
begin
  raise Exception.Create('Erro ao validar campo código !');
end;
if Trim(edtCodigoGrupo.text) = '' then
begin
  raise Exception.Create('Campo código de grupo vazio !');
end;
if trim(edtDescricao.text) = '' then
begin
  raise Exception.Create('Campo subgrupo vazio !');
end;

end;

end.
