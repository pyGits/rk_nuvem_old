unit uFrmLocVendedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,Classe.Variaveis,Conversao;

type
  TfrmLocVendedor = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    grid: TDBGrid;
    ds: TDataSource;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    procedure S1Click(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocVendedor: TfrmLocVendedor;
  vendedor:string;

implementation

{$R *.dfm}

procedure TfrmLocVendedor.edtLocChange(Sender: TObject);
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

class function TfrmLocVendedor.Exibe: string;
var
  frm :TfrmLocVendedor;

begin
     frm := TfrmLocVendedor.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := vendedor;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocVendedor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
vendedor := grid.Fields[0].AsString;
end;

procedure TfrmLocVendedor.FormShow(Sender: TObject);
begin
      VariaveisSrv.oFuncionarioController.PreencherGrid('',ds,nome);
end;

procedure TfrmLocVendedor.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocVendedor.S1Click(Sender: TObject);
begin
Close;
end;

end.
