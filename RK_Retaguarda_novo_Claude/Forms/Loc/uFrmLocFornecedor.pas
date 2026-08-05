unit uFrmLocFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Variaveis,Conversao;

type
  TfrmLocFornecedor = class(TForm)
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
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure S1Click(Sender: TObject);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocFornecedor: TfrmLocFornecedor;
  fornecedor:string;

implementation

{$R *.dfm}

procedure TfrmLocFornecedor.edtLocChange(Sender: TObject);
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

procedure TfrmLocFornecedor.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  grid.SetFocus;
end;
end;

class function TfrmLocFornecedor.Exibe: string;
var
  frm :TfrmLocFornecedor;

begin
     frm := TfrmLocFornecedor.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := Fornecedor;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocFornecedor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
fornecedor := grid.Fields[0].AsString;
end;

procedure TfrmLocFornecedor.FormShow(Sender: TObject);
begin
      VariaveisSrv.oFornecedorController.PreencherGrid('',ds,nome);
end;

procedure TfrmLocFornecedor.gridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocFornecedor.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  close;
end;
end;

procedure TfrmLocFornecedor.S1Click(Sender: TObject);
begin
Close;
end;

end.
