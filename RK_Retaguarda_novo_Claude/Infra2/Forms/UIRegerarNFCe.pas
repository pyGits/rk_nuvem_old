unit UIRegerarNFCe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Global,
  AdvGlowButton, System.Generics.Collections, NFCePendente, uFrmEnviaNFCe;

type
  TfrmUIRegerarNFCe = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    edtNCM: TEdit;
    Label4: TLabel;
    edtCEST: TEdit;
    AdvGlowButton2: TAdvGlowButton;
    procedure AdvGlowButton2Click(Sender: TObject);
  private
    FListaNFCe:TObjectList<TNFCePendente>;
  public
    class procedure Abrir(ListaNFCe:TObjectList<TNFCePendente>);
  end;

var
  frmUIRegerarNFCe: TfrmUIRegerarNFCe;



implementation

{$R *.dfm}

{ TfrmUIRegerarNFCe }



{ TfrmUIRegerarNFCe }

class procedure TfrmUIRegerarNFCe.Abrir(ListaNFCe: TObjectList<TNFCePendente>);
begin
  frmUIRegerarNFCe := TfrmUIRegerarNFCe.Create(nil);
  frmUIRegerarNFCe.FListaNFCe := ListaNFCe;
  frmUIRegerarNFCe.ShowModal;
  frmUIRegerarNFCe.Free;
end;

procedure TfrmUIRegerarNFCe.AdvGlowButton2Click(Sender: TObject);
begin
  if Trim(edtNCM.Text) = '' then
    raise Exception.Create('Informe o NCM!');

  TfrmEnviaNFce.enviarComNCM(FListaNFCe, edtNCM.Text);
  Close;
end;

end.
