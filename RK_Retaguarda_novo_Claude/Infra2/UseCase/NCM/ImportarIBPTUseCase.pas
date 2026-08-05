unit ImportarIBPTUseCase;

interface
uses CSVService,System.Generics.collections,SYstem.SysUtils,System.IOUtils,NCMRepositoryImpl,NCMModel,Helpers;

type TImportarIBPTUseCase = class
  private
    FCSVService:TCSVService;
    FNCMRepository: INCMRepository;
  public
  constructor create;
  procedure execute(diretorioCsv:string);
end;

implementation

{ TImportarIBPTUseCase }

constructor TImportarIBPTUseCase.create;
begin
FCSVService := TCSVService.Create(';',true);
FNCMRepository := TNCMRepositoryFirebird.create;
end;

procedure TImportarIBPTUseCase.execute(diretorioCsv: string);
var
  rows: TList<TCSVRow>;
  row: TCSVRow;
  ncmList: TObjectList<TNCMModel>;
  ncmMap: TDictionary<string, Boolean>;
  ncm: string;
begin
  if not TFile.Exists(diretorioCsv) then
    raise Exception.Create('Arquivo não encontrado: ' + diretorioCsv);

  if not SameText(ExtractFileExt(diretorioCsv), '.csv') then
    raise Exception.Create('Arquivo inválido. Apenas arquivos .csv são permitidos.');

  rows := FCSVService.ReadAll(diretorioCsv);

  ncmList := TObjectList<TNCMModel>.Create(True); // True = dona dos objetos
  ncmMap  := TDictionary<string, Boolean>.Create;

  try
    for row in rows do
    begin
      ncm := Trim(row[0]);

      if Length(ncm) > 8 then
        Continue;

      if row[2] = '1' then
        Continue;

      // 🔑 já existe? pula
      if ncmMap.ContainsKey(ncm) then
        Continue;

      ncmMap.Add(ncm, True);

      ncmList.Add(TNCMModel.Create);
      ncmList.Last.ncm := ncm;
      ncmList.Last.descricao := row[3];
      ncmList.Last.nacional := row[4].ParaFloat();
      ncmList.Last.estadual := row[6].ParaFloat();
    end;

    FNCMRepository.DeleteAll;
    FNCMRepository.InsertList(ncmList);
  finally
    ncmMap.Free;
    ncmList.Free;
  end;

end;

end.
