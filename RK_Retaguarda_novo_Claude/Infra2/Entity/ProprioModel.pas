unit ProprioModel;

interface
uses
  System.SysUtils,PessoaModel,EnderecoModel;
  type
  TProprioModel = class
    private
    Fcodigo: string;
    FDescricao: string;
    FPessoa: TPessoa;
    FEndereco: TEndereco;
    FIE: String;
    FIBGE: string;
    procedure Setcodigo(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetEndereco(const Value: TEndereco);
    procedure SetPessoa(const Value: TPessoa);
    procedure SetIE(const Value: String);
    procedure SetIBGE(const Value: string);



    public
    property Codigo: string read Fcodigo write Setcodigo;
    property Pessoa:TPessoa read FPessoa write SetPessoa;
    property Endereco:TEndereco read FEndereco write SetEndereco;
    property IE:String read FIE write SetIE;
    property IBGE:string read FIBGE write SetIBGE;
    constructor create;
    destructor destroy;override;


  end;

implementation


{ TNCM }


{ TProprio }

constructor TProprioModel.create;
begin
FPessoa := TPessoa.Create;
FEndereco := TEndereco.Create;
end;

destructor TProprioModel.destroy;
begin
  FPessoa.Destroy;
  FEndereco.Destroy;
  inherited;
end;

procedure TProprioModel.Setcodigo(const Value: string);
begin
  Fcodigo := value;
end;



procedure TProprioModel.SetDescricao(const Value: string);
begin

end;

procedure TProprioModel.SetEndereco(const Value: TEndereco);
begin
  FEndereco := Value;
end;

procedure TProprioModel.SetIBGE(const Value: string);
begin
  FIBGE := Value;
end;

procedure TProprioModel.SetIE(const Value: String);
begin
  FIE := Value;
end;

procedure TProprioModel.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

end.
