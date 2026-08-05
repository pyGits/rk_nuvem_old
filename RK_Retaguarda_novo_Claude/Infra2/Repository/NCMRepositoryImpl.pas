unit NCMRepositoryImpl;

interface
uses uConexao,System.Generics.Collections,NCMModel,Firedac.comp.client;
type INCMRepository = interface
  ['{68FB8359-E578-40AE-A487-D824BC743125}']
  procedure deleteAll;
  procedure insertList(ncmList:TObjectList<TNCMModel>);
end;

type TNCMRepositoryFirebird = class(TInterfacedObject,INCMRepository)
  public
    procedure deleteAll;
    procedure insertList(ncmList: System.Generics.Collections.TObjectList<NCMModel.TNCMModel>);

end;
implementation

{ TNCMRepositoryFirebird }

procedure TNCMRepositoryFirebird.deleteAll;
begin
TConexao.GetInstance.ExecSQL('DELETE FROM NCM');
end;

procedure TNCMRepositoryFirebird.insertList(
  ncmList: System.Generics.Collections.TObjectList<NCMModel.TNCMModel>);
var
  ncm:TNCMModel;
  query:TFDQuery;
  i:integer;
begin
  query := TConexao.GetInstance.CreateQuery('');
  QUERY.SQL.Text :='INSERT INTO NCM(NCM,DESCRICAO,NACIONAL,ESTADUAL) VALUES(:NCM,:DESCRICAO,:NACIONAL,:ESTADUAL)';

  QUERY.Params.ArraySize := ncmList.Count;
  //
  for i := 0 to QUERY.Params.ArraySize-1 do
  begin
    with ncmList[i] do
    begin
    query.ParamByName('NCM').AsStrings[i] := ncm;
    query.ParamByName('DESCRICAO').AsStrings[i] := descricao;
    query.ParamByName('NACIONAL').AsFloats[i] := nacional;
    query.ParamByName('ESTADUAL').AsFloats[i] := estadual;
    end;
  end;
  QUERY.Execute(QUERY.Params.ArraySize,0);


end;

end.
