unit NFcePendenteRepositoryImpl;

interface
uses NFCeModel,uConexao,FireDAC.comp.client;

type INFCePendenteRepository = interface
  ['{2B2076B0-5C50-42EF-BE44-6641EE4C04B3}']
  function GetByChave(chave:string):TNFceModel;
end;
type TNFcePendenteRepositoryFirebird = class(TInterfacedObject,INFCePendenteRepository)
  private
  query:TFDQuery;
  public
    function GetByChave(chave: string): TNFceModel;
end;

implementation

{ TNFcePendenteRepositoryFirebird }

function TNFcePendenteRepositoryFirebird.GetByChave(chave: string): TNFceModel;
begin
result := nil;
query := TConexao.GetInstance.CreateQuery('SELECT * FROM NFCE_PENDENTE WHERE CHAVE = :CHAVE');
query.ParamByName('CHAVE').AsString := chave;
query.open;

if query.RecordCount <> 1 then exit;

result := TNFceModel.Create;
Result.chave := query.FieldByName('CHAVE').AsString;
result.status := query.FieldByName('STATUS').AsString;
result.xml := query.FieldByName('XML').AsString;

end;

end.
