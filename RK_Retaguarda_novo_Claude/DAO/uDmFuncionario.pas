unit uDmFuncionario;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Funcionario,NxGrid,Conversao,Classe.Funcoes;

type
  TdmFuncionario = class(TDataModule)
    qrFuncionarioPesquisar: TUniQuery;
    qrFuncionarioAlterar: TUniQuery;
    qrFuncionarioInserir: TUniQuery;
    qrFuncionarioExcluir: TUniQuery;
    qrGridFuncionario: TUniQuery;
    qrListaFuncionarios: TUniQuery;
    qrListaFuncionariosCODIGO: TStringField;
    qrListaFuncionariosNOME: TStringField;
    qrListaFuncionariosAPELIDO: TStringField;
    qrListaFuncionariosEMAIL: TStringField;
    qrListaFuncionariosCPF: TStringField;
    qrListaFuncionariosCARGO: TIntegerField;
    qrListaFuncionariosSENHA: TStringField;
  private
    { Private declarations }
  public
    function CarregarFuncionario(oFuncionario : TFuncionario): Boolean;
    function AlterarFuncionario(oFuncionario:TFuncionario):Boolean;
    function InserirFuncionario(oFuncionario:TFuncionario):Boolean;
    function ExcluirFuncionario(oFuncionario:TFuncionario):Boolean;
    function PreencherGrid(sFuncionario:string;ds:TDataSource;tipo:TPesquisar):Boolean;
    function ValidaSenha(oFuncionario:TFuncionario):Boolean;
  end;

var
  dmFuncionario: TdmFuncionario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmFuncionario }

function TdmFuncionario.AlterarFuncionario(oFuncionario: TFuncionario): Boolean;
begin
with qrFuncionarioAlterar,oFuncionario do
begin
  ParamByName('CODIGO').AsString:=Codigo;
  ParamByName('NOME').AsString:=Pessoa.Nome;
  ParamByName('APELIDO').AsString:=Pessoa.Apelido;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('CPF').AsString:=Pessoa.CPFCNPJ;
  ParamByName('CARGO').AsInteger:= Cargo;
  ParamByName('SENHA').AsString:=Cript('C',SENHA);
  ParamByName('COMISSAO').AsFloat := comissao;

  ExecSQL;
end;
end;

function TdmFuncionario.CarregarFuncionario(oFuncionario: TFuncionario): Boolean;
begin
with qrFuncionarioPesquisar,oFuncionario do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM Funcionario WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oFuncionario.Codigo;
    try
      qrFuncionarioPesquisar.Open;
      if qrFuncionarioPesquisar.RecordCount > 0 then
      begin
      Codigo := qrFuncionarioPesquisar.FieldByName('CODIGO').AsString;
      Pessoa.Nome := qrFuncionarioPesquisar.FieldByName('NOME').AsString;
      Pessoa.Apelido := qrFuncionarioPesquisar.FieldByName('APELIDO').AsString;
      Pessoa.Email := qrFuncionarioPesquisar.FieldByName('EMAIL').AsString;
      Pessoa.CPFCNPJ := qrFuncionarioPesquisar.FieldByName('CPF').AsString;
      cargo := qrFuncionarioPesquisar.FieldByName('CARGO').AsInteger;
      senha := qrFuncionarioPesquisar.FieldByName('SENHA').AsString;
      comissao := qrFuncionarioPesquisar.FieldByName('COMISSAO').AsFloat;

      result := True;
      end
      else
      begin
        Codigo := '000000';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar Funcionario: '+E.Message);
          Result := False;
      end;

    end;
end;
end;

function TdmFuncionario.ExcluirFuncionario(oFuncionario: TFuncionario): Boolean;
begin
 with qrFuncionarioExcluir do
begin
  ParamByName('CODIGO').AsString := oFuncionario.Codigo;
  ExecSQL;
end;
end;

function TdmFuncionario.InserirFuncionario(oFuncionario: TFuncionario): Boolean;
begin
 with qrFuncionarioInserir,oFuncionario do
begin
  ParamByName('CODIGO').AsString:=Codigo;
  ParamByName('NOME').AsString:=Pessoa.Nome;
  ParamByName('APELIDO').AsString:=Pessoa.Apelido;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('CPF').AsString:=Pessoa.CPFCNPJ;
  ParamByName('CARGO').AsInteger:= Cargo;
  ParamByName('SENHA').AsString:=Cript('C',SENHA);
  ParamByName('COMISSAO').AsFloat := comissao;
  ExecSQL;
end;
end;
function TdmFuncionario.PreencherGrid(sFuncionario:string;ds:TDataSource;tipo:TPesquisar):Boolean;
begin
with qrGridFuncionario do
begin
ds.DataSet := qrGridFuncionario;
sFuncionario := StringReplace(sFuncionario,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM Funcionario');

   if sFuncionario = EmptyStr then
   begin
      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%'+sFuncionario+'%'+Chr(39));
      SQL.Add('ORDER BY NOME');

    end
    else
    if tipo = codigo then
    begin
      SQL.Add('WHERE CPF LIKE '+Chr(39)+sFuncionario+'%'+Chr(39));
      SQL.Add('ORDER BY CPF');
    end;


   end;

Open;


end;
end;

function TdmFuncionario.ValidaSenha(oFuncionario: TFuncionario): Boolean;
begin

end;

end.
