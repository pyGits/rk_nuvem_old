unit uDmProprio;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Proprio,
  frxClass, frxDBSet;

type
  TdmProprio = class(TDataModule)
    qrProprioPesquisar: TUniQuery;
    qrProprioAlterar: TUniQuery;
    fxemitente: TfrxDBDataset;
    qrEmitente: TUniQuery;
    qrEmitenteCODIGO: TStringField;
    qrEmitenteNOME: TStringField;
    qrEmitenteFANTASIA: TStringField;
    qrEmitenteENDERECO: TStringField;
    qrEmitenteBAIRRO: TStringField;
    qrEmitenteCIDADE: TStringField;
    qrEmitenteUF: TStringField;
    qrEmitenteCEP: TStringField;
    qrEmitenteTELEFONE: TStringField;
    qrEmitenteCNPJCPF: TStringField;
    qrEmitenteIE: TStringField;
    qrEmitenteEMAIL: TStringField;
    qrEmitenteRESPONSAVEL: TStringField;
    qrEmitenteCELULAR: TStringField;
    qrEmitenteLOGO: TBlobField;
    qrEmitenteNUMERO: TStringField;
    qrEmitenteCOMPLEMENTO: TStringField;
    qrEmitenteRG: TStringField;
    qrEmitenteINSC_MUNICIPAL: TStringField;
    qrEmitenteCOD_MUNICIPIO_IBGE: TStringField;
    qrEmitenteIBGE: TStringField;
  private
    { Private declarations }
  public
    function CarregarProprio(oProprio : TProprio): Boolean;
    function AlterarProprio(oProprio:TProprio):Boolean;
  end;

var
  dmProprio: TdmProprio;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmProprio }

function TdmProprio.AlterarProprio(oProprio: TProprio): Boolean;
begin
with qrProprioAlterar,oProprio do
begin
  ParamByName('CODIGO').AsString:=Codigo;
  ParamByName('ENDERECO').AsString:=Endereco.Endereco;
  ParamByName('NUMERO').AsString:=Endereco.Numero;
  ParamByName('BAIRRO').AsString:=Endereco.Bairro;
  ParamByName('CIDADE').AsString:=Endereco.Cidade;
  ParamByName('UF').AsString:=Endereco.UF;
  ParamByName('CEP').AsString:=Endereco.CEP;
  ParamByName('COMPLEMENTO').AsString:=Endereco.Complemento;
  ParamByName('NOME').AsString:=Pessoa.Nome;
  ParamByName('FANTASIA').AsString:=Pessoa.Apelido;
  ParamByName('CNPJCPF').AsString:=Pessoa.CPFCNPJ;
  ParamByName('TELEFONE').AsString:=Pessoa.Telefone1;
  ParamByName('CELULAR').AsString:=Pessoa.Celular1;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('IE').AsString:=IE;
  ParamByName('IBGE').AsString:=IBGE;

  ExecSQL;
end;
end;

function TdmProprio.CarregarProprio(oProprio: TProprio): Boolean;
begin
with qrProprioPesquisar,oProprio do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM PROPRIO WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := '000001';
    try
      qrProprioPesquisar.Open;
      if qrProprioPesquisar.RecordCount > 0 then
      begin
      Codigo := FieldByName('CODIGO').AsString;
      Endereco.Endereco := FieldByName('ENDERECO').AsString;
      Endereco.Numero := FieldByName('NUMERO').AsString;
      Endereco.Bairro := FieldByName('BAIRRO').AsString;
      Endereco.Cidade := FieldByName('CIDADE').AsString;
      Endereco.UF := FieldByName('UF').AsString;
      Endereco.CEP := FieldByName('CEP').AsString;
      Endereco.Complemento := FieldByName('COMPLEMENTO').AsString;
      Pessoa.Nome := FieldByName('NOME').AsString;
      Pessoa.Apelido := FieldByName('FANTASIA').AsString;
      Pessoa.CPFCNPJ := FieldByName('CNPJCPF').AsString;
      Pessoa.Telefone1 := FieldByName('TELEFONE').AsString;
      Pessoa.Celular1 := FieldByName('CELULAR').AsString;
      Pessoa.Email := FieldByName('EMAIL').AsString;
      IE := FieldByName('IE').AsString;
      IBGE := FieldByName('IBGE').AsString;

      result := True;
      end
      else
      begin
        Codigo := '000001';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar próprio: '+ e.MESSAGE);
          Result := False;
      end;

    end;
end;
end;

end.
