unit uFrmLocPreVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, JvExMask, JvToolEdit,Classe.Variaveis,Conversao;

type
  TfrmLocPreVenda = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    grid: TDBGrid;
    ds: TDataSource;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    dtInicio: TJvDateEdit;
    dtFim: TJvDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnPesquisar: TButton;
    procedure S1Click(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    class function Exibe:string;
  end;

var
  frmLocPreVenda: TfrmLocPreVenda;
  prevenda:string;

implementation

{$R *.dfm}

procedure TfrmLocPreVenda.btnPesquisarClick(Sender: TObject);
begin
VariaveisSrv.oPreVendaController.CarregarGridPreVenda(dtInicio.date,dtFim.date,ds);
end;

class function TfrmLocPreVenda.Exibe: string;
var
  frm :TfrmLocPreVenda;

begin
     frm := TfrmLocPreVenda.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := prevenda;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocPreVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
prevenda := grid.Fields[0].AsString;
end;

procedure TfrmLocPreVenda.FormShow(Sender: TObject);
begin
dtInicio.date := Date;
dtFim.date := Date;
btnPesquisar.Click;
end;

procedure TfrmLocPreVenda.gridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocPreVenda.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocPreVenda.S1Click(Sender: TObject);
begin
Close;
end;

end.
