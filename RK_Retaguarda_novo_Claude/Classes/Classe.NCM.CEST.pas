unit Classe.NCM.CEST;

interface
uses
  Classe.NCM, Classe.Funcoes;
type TCest = class(TNCM)
  private
    FCEST: String;
    FdescricaoCEST: string;
    procedure SetCEST(const Value: String);
    procedure SetdescricaoCEST(const Value: string);
  public
  property CEST:String read FCEST write SetCEST;
  property descricaoCEST: string read FdescricaoCEST write SetdescricaoCEST;
end;

implementation

{ TCest }

procedure TCest.SetCEST(const Value: String);
var
  CEST:string;
begin
  CEST := zeroEsquerda(Value,7);
  FCest := CEST;
end;

procedure TCest.SetdescricaoCEST(const Value: string);
begin
  FdescricaoCEST := Value;
end;

end.
