unit uFrmLocCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Variaveis,Conversao,classe.funcoes;

type
  TfrmLocCliente = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    grid: TDBGrid;
    ds: TDataSource;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    procedure edtLocKeyPress(Sender: TObject; var Key: Char);
    procedure S1Click(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure cbPesqChange(Sender: TObject);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocCliente: TfrmLocCliente;
  cliente:string;

implementation

{$R *.dfm}

procedure TfrmLocCliente.cbPesqChange(Sender: TObject);
begin
GravaIni('./Preferencias.ini','LocCliente','CB',IntToStr(cbPesq.ItemIndex));
end;

procedure TfrmLocCliente.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oClienteController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  if cbPesq.ItemIndex = 1 then  
  begin
      VariaveisSrv.oClienteController.PreencherGrid(edtloc.text,ds,codigo);
  end;
  if cbPesq.ItemIndex = 2 then
  begin
      VariaveisSrv.oClienteController.PreencherGrid(edtloc.text,ds,telefone);
  end;
end;

procedure TfrmLocCliente.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  grid.SetFocus;
end;
end;

class function TfrmLocCliente.Exibe: string;
var
  frm :TfrmLocCliente;

begin
     frm := TfrmLocCliente.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := cliente;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
cliente := grid.Fields[0].AsString;
end;

procedure TfrmLocCliente.FormShow(Sender: TObject);
begin
VariaveisSrv.oClienteController.PreencherGrid('',ds,nome);
cbPesq.ItemIndex :=  LerIni('./Preferencias.ini','LocCliente','CB','0').ToInteger();
end;

procedure TfrmLocCliente.gridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocCliente.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  close;
end;
end;

procedure TfrmLocCliente.S1Click(Sender: TObject);
begin
Close;
end;

end.
