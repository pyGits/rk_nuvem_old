unit UIAtualizarBancoInterface;

interface
type IAtualizarBanco = interface
  ['{0A80092B-5BF7-4037-8169-11DFCC462E07}']
  procedure AtualizarProgresso(atual:integer;total:integer;sql:string);
  procedure IniciarAtualizacao(versaoDB:integer);
  procedure ExibirMensagem(msg:string);
  procedure Abrir;
  procedure Finalizar;

end;
type TUIAtualizarBancoFake = class (TInterfacedObject,IAtualizarBanco)
public
  constructor create;
  procedure AtualizarProgresso(atual: Integer; total: Integer;sql:string);
  procedure IniciarAtualizacao(versaoDB:integer);
  procedure ExibirMensagem(msg: string);
  procedure Abrir;
    procedure Finalizar;




end;
implementation


{ TUIAtualizarBancoFake }


procedure TUIAtualizarBancoFake.Abrir;
begin

end;

procedure TUIAtualizarBancoFake.AtualizarProgresso(atual, total: Integer;sql:string);
begin
//
end;

constructor TUIAtualizarBancoFake.create;
begin

end;

procedure TUIAtualizarBancoFake.ExibirMensagem(msg: string);
begin
//
end;

procedure TUIAtualizarBancoFake.Finalizar;
begin
//
end;

procedure TUIAtualizarBancoFake.IniciarAtualizacao(versaoDB: integer);
begin
//
end;

end.
