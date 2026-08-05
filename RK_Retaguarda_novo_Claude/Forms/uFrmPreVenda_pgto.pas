unit uFrmPreVenda_pgto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, JvBaseEdits, Vcl.ExtCtrls,Classe.Variaveis,Classe.Finalizadora,uFrmLocFinalizadora;

type
  TfrmPreVendaPgto = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Panel1: TPanel;
    lblTipoDesconto: TLabel;
    lblTipoAcrescimo: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edtDesconto: TJvCalcEdit;
    edtAcrescimo: TJvCalcEdit;
    Panel2: TPanel;
    lblVlrTotal: TLabel;
    edtVlrPagamento: TJvCalcEdit;
    edtCodFin: TEdit;
    edtDescFin: TEdit;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    A1: TMenuItem;
    procedure edtCodFinExit(Sender: TObject);
    procedure edtCodFinKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    class function Exibe(preVenda:string):Boolean;
  end;

var
  frmPreVendaPgto: TfrmPreVendaPgto;

implementation

{$R *.dfm}

{ TfrmPreVendaPgto }

procedure TfrmPreVendaPgto.edtCodFinExit(Sender: TObject);
var
  oFinalizadora:TFinalizadora;
begin
  oFinalizadora := TFinalizadora.Create;
  oFinalizadora.codigo := edtCodFin.Text;
  if VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora) then
  begin
    edtCodFin.text := oFinalizadora.codigo;
    edtDescFin.text := oFinalizadora.descricao;
  end
  else
  begin
    edtCodFin.Text := TfrmLocFinalizadora.Exibe;
    edtCodFin.SetFocus;
  end;
  oFinalizadora.Destroy;

end;

procedure TfrmPreVendaPgto.edtCodFinKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

class function TfrmPreVendaPgto.Exibe(preVenda: string): Boolean;
var
  frm :TfrmPreVendaPgto;

begin
     frm := TfrmPreVendaPgto.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

end.
