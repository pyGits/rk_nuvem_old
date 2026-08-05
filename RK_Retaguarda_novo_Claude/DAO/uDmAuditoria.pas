unit uDmAuditoria;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Conversao,uDmFuncionario;

type
  TdmAuditoria = class(TDataModule)
    qrAuditoriaInserir: TUniQuery;
    qrAuditoriaGrid: TUniQuery;
    qrAuditoriaGridDATA_REGISTRO: TDateTimeField;
    qrAuditoriaGridUSUARIO: TStringField;
    qrAuditoriaGridTABELA: TStringField;
    qrAuditoriaGridALTERADO: TMemoField;
    qrAuditoriaGridUSUARIO_NOME: TStringField;
    procedure qrAuditoriaGridALTERADOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    function InserirAuditoria(tabela:string;alteracao:string;tpAuditoria:TAuditoria):boolean;
    function PreencherGrid(ds:TDataSource;dtInicial,dtFinal:TDateTime;tipo:TAuditoria):Boolean;
  end;

var
  dmAuditoria: TdmAuditoria;

implementation
uses
Classe.Variaveis;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmAuditoria }

function TdmAuditoria.InserirAuditoria(tabela,alteracao: string;tpAuditoria:TAuditoria): boolean;
var
  auditoria:integer;

begin
  case tpAuditoria of
    tpInclusao: auditoria := 0 ;
    tpAlteracao: auditoria := 1 ;
    tpExclusao: auditoria := 2 ;
  end;

  with qrAuditoriaInserir do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO AUDITORIA (DATA_REGISTRO,USUARIO,TABELA,ALTERADO,TIPO)');
    SQL.Add('VALUES (:DATA_REGISTRO,:USUARIO,:TABELA,:ALTERADO,:TIPO)');
    ParamByName('DATA_REGISTRO').AsDateTime := Date()+ Time();
    ParamByName('USUARIO').AsString := VariaveisSrv.oFuncionario.Codigo;
    ParamByName('TABELA').AsString := TABELA;
    ParamByName('ALTERADO').AsString := alteracao;
    ParamByName('TIPO').AsInteger :=  auditoria;

    ExecSQL;
  end;
end;

function TdmAuditoria.PreencherGrid(ds: TDataSource;dtInicial,dtFinal:TDateTime;tipo:TAuditoria): Boolean;
begin
with qrAuditoriaGrid do
begin
  Close;
  SQL.CLEAR;
  SQL.Add('SELECT * FROM AUDITORIA WHERE DATA_REGISTRO >= :DTINICIAL AND DATA_REGISTRO <= :DTFINAL');
  case tipo of
    tpInclusao:begin
    sql.add('AND TIPO = 0');
    end;
    tpAlteracao:begin
    sql.add('AND TIPO = 1');
    end;
    tpExclusao:begin
    sql.add('AND TIPO = 2');
    end;
  end;

  ParamByName('DTINICIAL').AsDateTime := dtInicial;
  ParamByName('DTFINAL').AsDateTime := dtFinal;

  Open;
  ds.DataSet := qrAuditoriaGrid;
end;
end;

procedure TdmAuditoria.qrAuditoriaGridALTERADOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
TEXT :='';
end;

end.
