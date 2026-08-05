unit uDmCaixaAcesso;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Vcl.ComCtrls,Classe.AcessoPDV,Classe.AcessoRetaguarda;

type
  TdmCaixaAcesso = class(TDataModule)
    qrCaixaAcessoPesquisar: TUniQuery;
    qrCaixaAcessoAtualizar: TUniQuery;
  private
    { Private declarations }
  public
    function preencherTreeView(tv:TTreeView):Boolean;
    function preencherNivelAcesso(oAcessoPDV:TAcessoPDV):boolean;
    function AtualizarNivelAcesso(oAcessoPDV:TAcessoPDV):Boolean;

    function preencherTreeViewRetaguarda(tv:TTreeView):Boolean;
    function preencherNivelAcessoRetaguarda(oAcessoRetaguarda:TAcessoRetaguarda):boolean;
    function AtualizarNivelAcessoRetaguarda(oAcessoRetaguarda:TAcessoRetaguarda):Boolean;

  end;

var
  dmCaixaAcesso: TdmCaixaAcesso;

implementation
  uses Classe.Funcoes;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCaixaAcesso }

function TdmCaixaAcesso.AtualizarNivelAcesso(oAcessoPDV:TAcessoPDV): Boolean;
begin
  with qrCaixaAcessoAtualizar do
  begin
   Close;
  SQL.Clear;
  SQL.Add('UPDATE CAIXA_FUNCOES SET FUNCNIV =:NIVEL,FUNCSOLIC=:SOLICITASENHA WHERE FUNCDESC =:DESCRICAO');
  ParamByName('NIVEL').AsString := oAcessoPDV.FuncaoNivel;
  ParamByName('SOLICITASENHA').AsString := oAcessoPDV.funcaoSolicitaSenha;
  ParamByName('DESCRICAO').AsString := oAcessoPDV.Descricao;
  ExecSQL;

  end;

end;

function TdmCaixaAcesso.AtualizarNivelAcessoRetaguarda(
  oAcessoRetaguarda: TAcessoRetaguarda): Boolean;
begin
  with qrCaixaAcessoAtualizar do
  begin
   Close;
  SQL.Clear;
  SQL.Add('UPDATE RETAGUARDA_NIVEL SET FUNCNIV =:NIVEL,FUNCSOLIC=:SOLICITASENHA WHERE FUNCDESC =:DESCRICAO');
  ParamByName('NIVEL').AsString := oAcessoRetaguarda.FuncaoNivel;
  ParamByName('SOLICITASENHA').AsString := oAcessoRetaguarda.funcaoSolicitaSenha;
  ParamByName('DESCRICAO').AsString := oAcessoRetaguarda.Descricao;
  ExecSQL;

  end;
end;

function TdmCaixaAcesso.preencherNivelAcesso(oAcessoPDV:TAcessoPDV): boolean;
var
  arrayNiv: TArray<string>;
begin
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM CAIXA_FUNCOES WHERE FUNCDESC = '+Chr(39)+oAcessoPDV.Descricao+Chr(39)+'');
  Open;

  with oAcessoPDV do
  begin
    Codigo := FieldByName('CODIGO').AsString;
    CodigoFuncao := FieldByName('ACFUNC').AsString;
    Descricao := FieldByName('FUNCDESC').AsString;
    Categoria := FieldByName('FUNCCAT').AsString;
    FuncaoNivel := FieldByName('FUNCNIV').AsString;
    funcaoSolicitaSenha := FieldByName('FUNCSOLIC').AsString;
  end;

  end;
end;

function TdmCaixaAcesso.preencherNivelAcessoRetaguarda(
  oAcessoRetaguarda: TAcessoRetaguarda): boolean;
var
  arrayNiv: TArray<string>;
begin
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCDESC = '+Chr(39)+oAcessoRetaguarda.Descricao+Chr(39)+'');
    try
    Open;
        with oAcessoRetaguarda do
        begin
          Codigo := FieldByName('CODIGO').AsString;
          CodigoFuncao := FieldByName('ACFUNC').AsString;
          Descricao := FieldByName('FUNCDESC').AsString;
          Categoria := FieldByName('FUNCCAT').AsString;
          FuncaoNivel := FieldByName('FUNCNIV').AsString;
          funcaoSolicitaSenha := FieldByName('FUNCSOLIC').AsString;
        end;
      if qrCaixaAcessoPesquisar.RecordCount > 0 then
      begin

        result := True;

      end
      else
      begin
        Result := false;
      end;

    except
    on E:Exception do
    begin
      result := False;
      raise Exception.Create('Erro ao carregar nível acesso do retaguarda !');
    end;

    end;


  end;
end;

function TdmCaixaAcesso.preencherTreeView(tv: TTreeView): Boolean;
var
    ndCancelamento : TTreeNode;
begin
  tv.Items.Clear;
           // PREENCHE TREEVIEW
  ndCancelamento := tv.Items.Add(nil,'Cancelamentos');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM CAIXA_FUNCOES WHERE FUNCCAT=''CANCELAMENTOS''');
  Open;
  First;


  while not eof do
  begin
  tv.Items.AddChild(ndCancelamento,FieldByName('FUNCDESC').AsString);
  Next;
  end;


  end;




    //caixa
  ndCancelamento := tv.Items.Add(nil,'Caixa');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM CAIXA_FUNCOES WHERE FUNCCAT=''CAIXA''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndCancelamento,FieldByName('FUNCDESC').AsString);
  Next;
  end;

  end;

      //CONSULTAS
  ndCancelamento := tv.Items.Add(nil,'Consultas');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM CAIXA_FUNCOES WHERE FUNCCAT=''CONSULTAS''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndCancelamento,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;


      //CONTAS A RECEBER
  ndCancelamento := tv.Items.Add(nil,'Contas a receber');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM CAIXA_FUNCOES WHERE FUNCCAT=''CONTAS A RECEBER''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndCancelamento,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
end;

function TdmCaixaAcesso.preencherTreeViewRetaguarda(tv: TTreeView): Boolean;
var
    ndBase : TTreeNode;
begin
  tv.Items.Clear;
      //Cadastro
  ndBase := tv.Items.Add(nil,'Cadastro');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''CADASTRO''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;

  // exportar
    ndBase := tv.Items.Add(nil,'Exportar');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''EXPORTAR''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
  // exportar
    ndBase := tv.Items.Add(nil,'Vendas');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''VENDAS''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
  // exportar
    ndBase := tv.Items.Add(nil,'Financeiro');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''FINANCEIRO''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
  // exportar
    ndBase := tv.Items.Add(nil,'Relatórios');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''RELATORIO''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
  // exportar
    ndBase := tv.Items.Add(nil,'Imprimir');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''IMPRIMIR''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
  // exportar
    ndBase := tv.Items.Add(nil,'Configurações');
  with qrCaixaAcessoPesquisar do
  begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCCAT=''CONFIGURACOES''');
  Open;
  First;

  while not qrCaixaAcessoPesquisar.eof do
  begin
  tv.Items.AddChild(ndBase,FieldByName('FUNCDESC').AsString);
  Next;
  end;
  end;
end;

end.
