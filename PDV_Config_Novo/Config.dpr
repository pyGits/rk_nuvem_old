program Config;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmPrincipal},
  modulo in 'modulo.pas' {dmConfiguracoes: TDataModule},
  unit2 in 'unit2.pas' {frSelecionarCertificado};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmConfiguracoes, dmConfiguracoes);
  Application.CreateForm(TfrSelecionarCertificado, frSelecionarCertificado);
  Application.Run;
end.
