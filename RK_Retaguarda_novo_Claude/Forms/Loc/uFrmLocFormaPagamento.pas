unit uFrmLocFormaPagamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.ExtCtrls, Classe.Variaveis, Conversao;

type
  TfrmLocFormaPagamento = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    grid: TNextGrid;
    NxNumberColumn1: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocFormaPagamento: TfrmLocFormaPagamento;
  formaPagamento:string;

implementation

{$R *.dfm}

class function TfrmLocFormaPagamento.Exibe: string;
var
  frm :TfrmLocFormaPagamento;

begin
     frm := TfrmLocFormaPagamento.Create(nil);
     formaPagamento := '000';

  try
     frm.Visible := False;
     frm.ShowModal;
     result := formaPagamento;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocFormaPagamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
try
  if (grid.RowCount > 0) and (grid.SelectedRow >= 0) then
    formaPagamento := grid.Cell[0,grid.SelectedRow].AsString
  else
    formaPagamento := '000';
except
  formaPagamento := '000';
end;
end;

procedure TfrmLocFormaPagamento.FormShow(Sender: TObject);
begin
formaPagamento := '000';
VariaveisSrv.oFinalizadoraController.PreencherGrid('',grid,nome);
if grid.RowCount > 0 then
  grid.SelectedRow := 0;
end;

procedure TfrmLocFormaPagamento.gridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocFormaPagamento.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

end.
