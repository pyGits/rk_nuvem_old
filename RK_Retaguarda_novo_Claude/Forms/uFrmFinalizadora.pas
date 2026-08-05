unit uFrmFinalizadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Conversao,Classe.Finalizadora,Classe.Variaveis,
  Vcl.Mask, JvExMask, JvSpin,Classe.Funcoes;

type
  TfrmFinalizadora = class(TForm)
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
    pcFinalizadora: TPageControl;
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
    rdEspecie: TRadioGroup;
    rdTipo: TRadioGroup;
    chk99: TCheckBox;
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure pcFinalizadoraChange(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure gridSelectCell(Sender: TObject; ACol, ARow: Integer);
  private
    // ESPECIE PARA RADIO GROUP
    function ConverteTipoRD(vlr:string):integer;
    function ConverteEspecieRD(vlr:integer):Integer;
    // RADIO GROUP PARA ESPECIE
    function ConverteRDEspecie(vlrEsp:integer):Integer;
    function ConverteRDTipo(vlrEsp:integer):String;
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oFinalizadora:TFinalizadora);
  public
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmFinalizadora: TfrmFinalizadora;
    FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmFinalizadora.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmFinalizadora.Alterar;
var
  oFinalizadora:TFinalizadora;
begin
  oFinalizadora := TFinalizadora.Create;
  with oFinalizadora do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    Especie := ConverteRDEspecie(rdEspecie.ItemIndex);
    tipo := ConverteRDTipo(rdTipo.ItemIndex);
    cod99 := BoolToInt(chk99.Checked);
    VariaveisSrv.oFinalizadoraController.alterarFinalizadora(oFinalizadora);
  end;

  oFinalizadora.Destroy;

end;

procedure TfrmFinalizadora.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmFinalizadora.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmFinalizadora.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmFinalizadora.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmFinalizadora.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmFinalizadora.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmFinalizadora.Cancelar;
begin
HabilitarControles(opNavegar);
end;

function TfrmFinalizadora.ConverteEspecieRD(vlr: integer): Integer;
begin
  // radio group para a tabela
  if vlr = 1 then
  begin
    Result := 0;
  end
  else
  if vlr = 2 then
  begin
    Result := 1;
  end
  else
  if vlr = 3 then
  begin
    Result := 2;
  end
  else
  if vlr = 4 then
  begin
    Result := 3;
  end
  else
  if vlr = 5 then
  begin
    Result := 4;
  end
  else
  if vlr = 10 then
  begin
    Result := 5;
  end
  else
  if vlr = 11 then
  begin
    Result := 6;
  end
  else
  if vlr = 17 then
  begin
    Result := 8;
  end
  else
  if vlr = 99 then
  begin
    Result := 7;
  end;

end;

function TfrmFinalizadora.ConverteRDEspecie(vlrEsp: integer): Integer;
begin
  // radio group para a tabela
  if VlrEsp = 0 then
  begin
    Result := 1;
  end
  else
  if VlrEsp = 1 then
  begin
    Result := 2;
  end
  else
  if VlrEsp = 2 then
  begin
    Result := 3;
  end
  else
  if VlrEsp = 3 then
  begin
    Result := 4;
  end
  else
  if VlrEsp = 4 then
  begin
    Result := 5;
  end
  else
  if VlrEsp = 5 then
  begin
    Result := 10;
  end
  else
  if VlrEsp = 6 then
  begin
    Result := 11;
  end
  else
  if VlrEsp = 7 then
  begin
    Result := 99;
  end;
  if VlrEsp = 8 then
  begin
    Result := 17;
  end;
end;

function TfrmFinalizadora.ConverteRDTipo(vlrEsp: integer): String;
begin

  if vlrEsp = 0 then
  begin
  result := 'N';
  end
  else
  if vlrEsp = 1 then
  begin
  result := 'C';
  end;

end;

function TfrmFinalizadora.ConverteTipoRD(vlr: string): integer;
begin
  if vlr = 'N' then
  begin
  result := 0;
  end
  else
  if vlr = 'C' then
  begin
  result := 1;
  end;

end;

procedure TfrmFinalizadora.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmFinalizadora.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
  // permitir apenas numeros
  Key := Ret_Numero(Key,edtCodigo.text);
end;

procedure TfrmFinalizadora.Excluir;
var
  oFinalizadora:TFinalizadora;
begin
    If  MessageDlg('Tem certeza que deseja excluir o Finalizadora: '+grid.Cell[1,grid.selectedrow].AsString + ' toda a movimentação dele de venda será excluída !' ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oFinalizadora:= TFinalizadora.Create;
      oFinalizadora.codigo := grid.Cell[0,grid.selectedrow].AsString;
      VariaveisSrv.oFinalizadoraController.ExcluirFinalizadora(oFinalizadora);
      HabilitarControles(opNavegar);
      oFinalizadora.Destroy;
    end;

end;

procedure TfrmFinalizadora.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmFinalizadora.g1Click(Sender: TObject);
begin
if btnGravar.enabled then
btnGravar.Click;
end;

procedure TfrmFinalizadora.Gravar;
begin
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmFinalizadora.gridDblClick(Sender: TObject);
begin
if btnAlterar.Enabled then
btnAlterar.Click;
end;

procedure TfrmFinalizadora.gridSelectCell(Sender: TObject; ACol, ARow: Integer);
var
  oFinalizadora:TFinalizadora;
begin
  if FOperacao = opNavegar then
  begin
      oFinalizadora := TFinalizadora.Create;
      oFinalizadora.codigo := grid.Cell[0, grid.SelectedRow].AsString;
      VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora);
      PreencherCampos(oFinalizadora);
      oFinalizadora.Destroy;
  end;
end;

procedure TfrmFinalizadora.HabilitarControles(aOperacao: TOperacao);
var
  oFinalizadora:TFinalizadora;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigo.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcFinalizadora.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oFinalizadora := TFinalizadora.Create;
      oFinalizadora.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('FINALIZADORA','CODIGO');
      PreencherCampos(oFinalizadora);
      freeandnil(oFinalizadora);
      //
      edtCodigo.SetFocus;

      FOperacao := opNovo;
    end;
    opAlterar:begin
          if grid.RowCount > 0 then
      begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcFinalizadora.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;



        oFinalizadora := TFinalizadora.Create;
        oFinalizadora.Codigo := grid.Cell[0,grid.SelectedRow].AsString;
        VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora);
        PreencherCampos(oFinalizadora);
        FOperacao := opAlterar;
        edtDescricao.setfocus;

        finally
          FreeAndNil(oFinalizadora);
        end;
      end;




    end;

    opNavegar:begin
      pcFinalizadora.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oFinalizadora := TFinalizadora.Create;
      PreencherCampos(oFinalizadora);
      VariaveisSrv.oFinalizadoraController.PreencherGrid('',grid,nome);

      FOperacao := opNavegar;
      freeandnil(OFinalizadora);

    end;
  end;
finally

end;
end;

procedure TfrmFinalizadora.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
btnIncluir.Click;
end;

procedure TfrmFinalizadora.Incluir;
var
  oFinalizadora:TFinalizadora;
begin
  oFinalizadora := TFinalizadora.Create;
  with oFinalizadora do
  begin
    Codigo := edtCodigo.text;
    Descricao := edtDescricao.text;
    Especie := ConverteRDEspecie(rdEspecie.ItemIndex);
    tipo := ConverteRDTipo(rdTipo.ItemIndex);
    cod99 := BoolToInt(chk99.Checked);
    VariaveisSrv.oFinalizadoraController.InserirFinalizadora(oFinalizadora);
  end;

  oFinalizadora.Destroy;

end;

procedure TfrmFinalizadora.pcFinalizadoraChange(Sender: TObject);
begin
if (pcFinalizadora.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? a finalizadora não sera salva',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcFinalizadora.ActivePage := tsLista;
end
else
begin
pcFinalizadora.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmFinalizadora.PreencherCampos(oFinalizadora: TFinalizadora);
begin
with oFinalizadora do
begin
  edtCodigo.text := Codigo;
  edtDescricao.Text := Descricao;
  rdEspecie.ItemIndex :=ConverteEspecieRD(especie);
  rdTipo.ItemIndex := ConverteTipoRD(tipo);
  chk99.checked := IntToBool(cod99);
end;
end;

procedure TfrmFinalizadora.S1Click(Sender: TObject);
begin
Close;
end;

end.
