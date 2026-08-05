unit uFrmPDVCarga;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,Classe.Variaveis, Vcl.ComCtrls,Conversao,Classe.Caixa,
  System.ImageList, Vcl.ImgList, dxGDIPlusClasses,Global;

type
  TfrmPDVCarga = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnCargaCompleta: TSpeedButton;
    btnCargaAlterados: TSpeedButton;
    grid: TDBGrid;
    ds: TDataSource;
    Panel1: TPanel;
    pbCarga: TProgressBar;
    Image1: TImage;
    Image2: TImage;
    ImageList1: TImageList;
    lblCarga: TLabel;
    tmCargaAlterado: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnCargaAlteradosClick(Sender: TObject);
    procedure gridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnCargaCompletaClick(Sender: TObject);
    procedure tmCargaAlteradoTimer(Sender: TObject);
  private
    { Private declarations }
  public
    class function EnviarCargaAlterados:boolean;
  end;

var
  frmPDVCarga: TfrmPDVCarga;

implementation

{$R *.dfm}

procedure TfrmPDVCarga.btnCargaCompletaClick(Sender: TObject);
var
  oCaixa:TCaixa;
begin
try
ds.DataSet.First;
while not ds.DataSet.Eof do
begin
  oCaixa := TCaixa.Create;
  oCaixa.Codigo := ds.dataset.FieldByName('CODIGO').AsString;
  oCaixa.Descricao := ds.dataset.FieldByName('NOME').AsString;
  oCaixa.IP := ds.dataset.FieldByName('IP').AsString;

  VariaveisSrv.oCargaPDVController.EnviarCargaPDV(cgCompleta,oCaixa,lblCarga,pbCarga);
  CargaUseCase.EnviarCargaPDV;

  oCaixa.Destroy;
  ds.DataSet.Next;
end;
VariaveisSrv.oCaixaController.PreencherGrid(ds);
  MessageDlg('Carga enviada com sucesso !',mtInformation,[mbOK],0);

except
on E:Exception do
begin
VariaveisSrv.oCaixaController.PreencherGrid(ds);
showmessage(e.Message);

end;

end;
end;

class function TfrmPDVCarga.EnviarCargaAlterados: boolean;
var
  frm :TfrmPDVCarga;

begin
     frm := TfrmPDVCarga.Create(nil);

  try
     frm.Visible := False;
     frm.tmCargaAlterado.Enabled := True;
     frm.ShowModal;


  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmPDVCarga.FormShow(Sender: TObject);
begin
VariaveisSrv.oCaixaController.PreencherGrid(ds);
VariaveisSrv.oCargaPDVController.AtualizarRecebimento('',nil);
end;

procedure TfrmPDVCarga.gridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
   if Column.FieldName = 'RECEBIDO' then
   begin
     TDBGrid(Sender).Canvas.FillRect(Rect);

     if Column.Field.Value = 'S' then
     begin
      // recebeu carga
      ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 2)
     end
     else
     if Column.Field.Value = 'N' then
     begin
     // erro carga
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 3);
     end;
     if Column.Field.Value = '' then
     begin
          // sem status
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
     end;
   end;
end;



procedure TfrmPDVCarga.tmCargaAlteradoTimer(Sender: TObject);
begin
Application.ProcessMessages;
tmCargaAlterado.Enabled := false;
btnCargaAlterados.Click;
Close;
end;

procedure TfrmPDVCarga.btnCargaAlteradosClick(Sender: TObject);
var
  oCaixa:TCaixa;
begin
try
  ds.DataSet.First;
  while not ds.DataSet.Eof do
  begin
    oCaixa := TCaixa.Create;
    oCaixa.Codigo := ds.dataset.FieldByName('CODIGO').AsString;
    oCaixa.Descricao := ds.dataset.FieldByName('NOME').AsString;
    oCaixa.IP := ds.dataset.FieldByName('IP').AsString;

    VariaveisSrv.oCargaPDVController.EnviarCargaPDV(cgAlterados,oCaixa,lblCarga,pbCarga);
    oCaixa.Destroy;
    ds.DataSet.Next;
  end;
  // sucesso na carga zerar tabela alterados
  VariaveisSrv.oCaixaController.PreencherGrid(ds);
  VariaveisSrv.oCargaPDVController.ZerarCargaAlterados;

  except
  on E:Exception do
  begin
  VariaveisSrv.oCaixaController.PreencherGrid(ds);
  end;

end;

end;


end.
