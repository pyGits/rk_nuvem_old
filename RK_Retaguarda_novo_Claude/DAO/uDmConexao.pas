unit uDmConexao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, UniProvider,
  InterBaseUniProvider, DASQLMonitor, UniSQLMonitor,VCL.Forms,
  ZAbstractConnection, ZConnection, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB;

type
  TdmConexao = class(TDataModule)
    conexao: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
    FDConnection1: TFDConnection;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function InicializarConexao:boolean;
  end;

var
  dmConexao: TdmConexao;

implementation
  Uses Classe.Funcoes;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConexao }

procedure TdmConexao.DataModuleCreate(Sender: TObject);
begin
InicializarConexao;
end;

function TdmConexao.InicializarConexao: boolean;
var IP,Banco:string;
begin
try
    IP := LerIni(ExtractFilePath(Application.ExeName) + '\Retaguarda.Ini' , 'cfg', 'IP','127.0.0.1');
    banco := LerIni(ExtractFilePath(Application.ExeName) + '\Retaguarda.Ini' , 'cfg', 'BANCO','c:\system_rk\server\bd\banco.fdb');

    conexao.Connected := false;
    conexao.Database := Banco;
    conexao.Server := IP;

    conexao.Connected := true;

    result :=true;

except
   ON E:EXCEPTION DO
   begin
    raise exception.Create('Erro ao conectar no banco de dados: '+ E.Message);
    Result := false;
   end;

end;
end;

end.
