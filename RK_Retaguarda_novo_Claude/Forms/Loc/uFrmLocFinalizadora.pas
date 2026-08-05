unit uFrmLocFinalizadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.StdCtrls,
  Vcl.ExtCtrls,Classe.Variaveis,Conversao;

type
  TfrmLocFinalizadora = class(TForm)
    Panel6: TPanel;
    lblNCM: TLabel;
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
  frmLocFinalizadora: TfrmLocFinalizadora;
  finalizadora:string;

implementation

{$R *.dfm}

{ TfrmLocFinalizadora }

class function TfrmLocFinalizadora.Exibe: string;
var
  frm :TfrmLocFinalizadora;

begin
     frm := TfrmLocFinalizadora.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := Finalizadora;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocFinalizadora.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
finalizadora := grid.Cell[0,grid.SelectedRow].AsString;
end;

procedure TfrmLocFinalizadora.FormShow(Sender: TObject);
begin
VariaveisSrv.oFinalizadoraController.PreencherGrid('',grid,nome);
end;

procedure TfrmLocFinalizadora.gridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocFinalizadora.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

end.
