unit uDmFinalizadoraPDV;

interface

uses
  System.SysUtils, System.Classes,ConexaoPDV, Data.DB, MemDS, DBAccess, Uni,Finalizadora;

type
  TDmFinalizadoraPDV = class(TDataModule)
    qrInsertFinalizadoraPDV: TUniQuery;
  private
    { Private declarations }
  public
    function insertFinalizadoraPDV(oFinalizadora:TFinalizadora):Boolean;
  end;

var
  DmFinalizadoraPDV: TDmFinalizadoraPDV;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDmFinalizadoraPDV }

function TDmFinalizadoraPDV.insertFinalizadoraPDV(
  oFinalizadora: TFinalizadora): Boolean;
begin
  with qrInsertFinalizadoraPDV do
  begin
    Close;
    SQL.Clear;
    SQl.Add('UPDATE OR INSERT INTO FINALIZADORA (FZCOD,FZDES,FZESPECIE,FZTIPO,FZCOD99)');
    SQl.Add('VALUES (:FZCOD,:FZDES,:FZESPECIE,:FZTIPO,:FZCOD99)');
    ParamByName('FZCOD').AsString := oFinalizadora.codigo;
    ParamByName('FZDES').AsString := oFinalizadora.nome;
    ParamByName('FZESPECIE').AsInteger := oFinalizadora.especie;
    ParamByName('FZTIPO').AsString := oFinalizadora.tipo;
    ParamByName('FZCOD99').AsInteger := oFinalizadora.utiliza99;

    try
      ExecSQL;
    except
    on E:Exception do
    begin
      raise Exception.Create('Erro ao inserir finalizadora no PDV: '+ E.message);
    end;

    end;
  end;
end;

end.
