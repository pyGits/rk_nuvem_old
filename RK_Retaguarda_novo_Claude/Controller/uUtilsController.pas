unit uUtilsController;

interface
uses
System.SysUtils,uDmUtils,NxGrid,Vcl.StdCtrls,Classe.Configuracoes,Vcl.ComCtrls,uDmCaixaAcesso,Classe.AcessoPDV,Data.DB,Classe.AcessoRetaguarda;

type TUtilsController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function GravarConfiguracoesBD(oConfiguracoes:TConfiguracoes):Boolean;
  function CarregarConfiguracoesBD(oConfiguracoes:TConfiguracoes):Boolean;
  function RetornaSequencial(Tabela:string;Coluna:string):string;
  function RetornaSequencialFin(Tabela:string;Coluna:string;cupom:string):string;
  function ExisteCadastro(Tabela:string;Coluna:string;Valor:string):boolean;
  function PreencheUF(cbUF:TComboBox):Boolean;
  function PreencheCidade(cidade:string;cbCidade:TComboBox):Boolean;
  function InserirCarga(tabela:string;codigo:string):boolean;
  function PreencherGridIBGE(sIBGE:string;ds:TDatasource):boolean;



      // NIVEL ACESSO - PDV
    function preencherTreeView(tv:TTreeView):Boolean;
    function preencherNivelAcesso(oAcessoPDV:TAcessoPDV):boolean;
    function AtualizarNivelAcesso(oAcessoPDV:TAcessoPDV):Boolean;

    // nivel acesso retaguarda
    function preencherTreeViewRetaguarda(tv:TTreeView):Boolean;
    function preencherNivelAcessoRetaguarda(oAcessoRetaguarda:TAcessoRetaguarda):boolean;
    function AtualizarNivelAcessoRetaguarda(oAcessoRetaguarda:TAcessoRetaguarda):Boolean;
      // ETIQUETA

      function carregarEtiquetaLista(cmbEtiqueta:TComboBox):Boolean;
      function carregarEtiqueta(etiqueta:array of string):TArray<string>;
      function DAOEtiqueta(tipo:string;etiqueta:array of string):boolean;

      function zerarBD:boolean;


end;

implementation



function TUtilsController.AtualizarNivelAcesso(oAcessoPDV: TAcessoPDV): Boolean;
begin
Result :=dmCaixaAcesso.AtualizarNivelAcesso(oAcessoPDV);
end;

function TUtilsController.AtualizarNivelAcessoRetaguarda(
  oAcessoRetaguarda: TAcessoRetaguarda): Boolean;
begin
result := dmCaixaAcesso.AtualizarNivelAcessoRetaguarda(oAcessoRetaguarda);
end;

function TUtilsController.CarregarConfiguracoesBD(
  oConfiguracoes: TConfiguracoes): Boolean;
begin
result := dmUtils.CarregarConfiguracoesBD(oConfiguracoes);
end;



function TUtilsController.carregarEtiqueta(etiqueta: array  of string):TArray<string>;
begin
result := dmUtils.carregarEtiqueta(etiqueta);
end;

function TUtilsController.carregarEtiquetaLista(
  cmbEtiqueta: TComboBox): Boolean;
begin
  Result := uDmUtils.dmUtils.carregarEtiquetaLista(cmbEtiqueta);
end;

constructor TUtilsController.create;
begin
  dmUtils := TdmUtils.create(nil);
  dmCaixaAcesso := TdmCaixaAcesso.Create(nil);
end;


function TUtilsController.DAOEtiqueta(tipo: string;
  etiqueta: array of string): boolean;
begin
result := dmUtils.DAOEtiqueta(tipo,etiqueta);
end;

destructor TUtilsController.destroy;
begin
  FreeAndNil(dmUtils);
  FreeAndNil(dmCaixaAcesso);
  inherited;
end;


function TUtilsController.ExisteCadastro(Tabela, Coluna,
  Valor: string): boolean;
begin
result := dmUtils.ExisteCadastro(tabela,coluna,valor);
end;



function TUtilsController.GravarConfiguracoesBD(
  oConfiguracoes: TConfiguracoes): Boolean;
begin
Result := dmUtils.GravarConfiguracoesBD(oConfiguracoes);
end;

function TUtilsController.InserirCarga(tabela, codigo: string): boolean;
begin
result := dmUtils.InserirCarga(tabela,codigo);
end;

function TUtilsController.PreencheCidade(cidade: string;
  cbCidade: TComboBox): Boolean;
begin
result := dmUtils.PreencheCidade(cidade,cbCidade);
end;

function TUtilsController.PreencherGridIBGE(sIBGE: string;
  ds: TDatasource): boolean;
begin
result := dmUtils.PreencherGridIBGE(sIBGE,ds);
end;

function TUtilsController.preencherNivelAcesso(oAcessoPDV: TAcessoPDV): boolean;
begin
result := dmCaixaAcesso.preencherNivelAcesso(oAcessoPDV);
end;

function TUtilsController.preencherNivelAcessoRetaguarda(
  oAcessoRetaguarda: TAcessoRetaguarda): boolean;
begin
result := dmCaixaAcesso.preencherNivelAcessoRetaguarda(oAcessoRetaguarda);
end;

function TUtilsController.preencherTreeView(tv: TTreeView): Boolean;
begin
result := dmCaixaAcesso.preencherTreeView(tv);
end;

function TUtilsController.preencherTreeViewRetaguarda(tv: TTreeView): Boolean;
begin
result := dmCaixaAcesso.preencherTreeViewRetaguarda(tv);
end;

function TUtilsController.PreencheUF(cbUF: TComboBox): Boolean;
begin
Result :=dmUtils.PreencheUF(cbUF);
end;

function TUtilsController.RetornaSequencial(Tabela, Coluna: string): string;
begin
result := dmUtils.RetornaSequencial(tabela,coluna);
end;

function TUtilsController.RetornaSequencialFin(Tabela, Coluna,
  cupom: string): string;
begin
Result := dmUtils.RetornaSequencialFin(tabela,Coluna,cupom);
end;

function TUtilsController.zerarBD: boolean;
begin
result := dmUtils.ZerarBancoDeDados;
end;

end.
