unit uFrmLocProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids,Classe.Variaveis,conversao, Vcl.Menus;

type
  TfrmLocProduto = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    grid: TDBGrid;
    ds: TDataSource;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    procedure edtLocChange(Sender: TObject);
    procedure edtLocKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure gridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocProduto: TfrmLocProduto;
  produto:string;
implementation

{$R *.dfm}

procedure TfrmLocProduto.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oProdutoController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  begin
      VariaveisSrv.oProdutoController.PreencherGrid(edtloc.text,ds,codigo);
  end;

end;

procedure TfrmLocProduto.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  grid.SetFocus;
end;
end;

class function TfrmLocProduto.Exibe: string;
var
  frm :TfrmLocProduto;

begin
     frm := TfrmLocProduto.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := produto;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
produto := grid.Fields[1].AsString;
end;

procedure TfrmLocProduto.FormShow(Sender: TObject);
begin
      VariaveisSrv.oProdutoController.PreencherGrid('',ds,nome);
end;

procedure TfrmLocProduto.gridDblClick(Sender: TObject);
begin
//
end;

procedure TfrmLocProduto.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocProduto.S1Click(Sender: TObject);
begin
Close;
end;

end.

