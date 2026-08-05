unit Classe.Tributacao;

interface
type
  TTributacao = class
    private
    FCOD: string;
    FTRIBUTACAO: string;
    Fcst: string;
    FCFOP: string;

    FST: string;
    FCSOSN: string;
    FCodigo: string;
    FICMS: real;

    procedure SetTRIBUTACAO(const Value: string);
    procedure Setcst(const Value: string);
    procedure SetCFOP(const Value: string);
    procedure SetCSOSN(const Value: string);

    procedure SetST(const Value: string);
    procedure SetCodigo(const Value: string);
    procedure SetICMS(const Value: real);
    public

    property Codigo:string read FCodigo write SetCodigo;
    property Tributacao: string read FTRIBUTACAO write SetTRIBUTACAO;
    property cst:string read Fcst write Setcst;
    property CFOP : string read FCFOP write SetCFOP;
    property CSOSN : string read FCSOSN write SetCSOSN;
    property ST : string read FST write SetST;
    property ICMS : real read FICMS write SetICMS;



  end;

implementation

{ TTributacao }

procedure TTributacao.SetCFOP(const Value: string);
begin
  FCFOP := Value;
end;



procedure TTributacao.SetCodigo(const Value: string);
begin
  FCodigo := Value;
end;

procedure TTributacao.SetCSOSN(const Value: string);
begin
  FCSOSN := Value;
end;

procedure TTributacao.Setcst(const Value: string);
begin
  Fcst := Value;
end;




procedure TTributacao.SetICMS(const Value: real);
begin
  FICMS := Value;
end;

procedure TTributacao.SetST(const Value: string);
begin
  FST := Value;
end;

procedure TTributacao.SetTRIBUTACAO(const Value: string);
begin
  FTRIBUTACAO := Value;
end;

end.
