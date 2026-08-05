unit RetaguardaNivelSeeder;

interface
uses system.Generics.collections,RetaguardaNivelModel,RetaguardaNivelRepositoryImpl;

type TRetaguardaNivelSeeder = class
  private
    FItems:TObjectList<TRetaguardaNivelModel>;
    FRetaguardaNivelRepository:IRetaguardaNivelRepository;
  public
    constructor create;
    procedure Execute;

end;

implementation

{ TRetaguardaNivelSeeder }

constructor TRetaguardaNivelSeeder.create;
begin
FItems := TObjectList<TRetaguardaNivelModel>.Create(true);
FRetaguardaNivelRepository := TRetaguardaNivelRepositoryFirebird.Create;

FItems.Add(TRetaguardaNivelModel.create);

FItems := TObjectList<TRetaguardaNivelModel>.Create(True);

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000001';
FItems.Last.descricao := 'Produto';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000002';
FItems.Last.descricao := 'Grupo';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000003';
FItems.Last.descricao := 'Subgrupo';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000004';
FItems.Last.descricao := 'Funcionário';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000006';
FItems.Last.descricao := 'Cliente';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000007';
FItems.Last.descricao := 'Fornecedor';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000008';
FItems.Last.descricao := 'Tributação';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000009';
FItems.Last.descricao := 'Finalizadora';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000010';
FItems.Last.descricao := 'Próprio';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000011';
FItems.Last.descricao := 'Carga PDV';
FItems.Last.categoria := 'EXPORTAR';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000012';
FItems.Last.descricao := 'Carga Balança';
FItems.Last.categoria := 'EXPORTAR';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000013';
FItems.Last.descricao := 'Pré Venda';
FItems.Last.categoria := 'VENDAS';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000014';
FItems.Last.descricao := 'Contas a Receber';
FItems.Last.categoria := 'FINANCEIRO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000015';
FItems.Last.descricao := 'Caixa>Finalização';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000016';
FItems.Last.descricao := 'Caixa>Produto';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000017';
FItems.Last.descricao := 'Caixa>Cupom';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000018';
FItems.Last.descricao := 'Caixa>Saldo Estoque';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000019';
FItems.Last.descricao := 'Caixa>Gráfico de Vendas';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000020';
FItems.Last.descricao := 'Funcionários>Comissão';
FItems.Last.categoria := 'RELATORIO';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000021';
FItems.Last.descricao := 'Etiqueta';
FItems.Last.categoria := 'IMPRIMIR';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000022';
FItems.Last.descricao := 'Auditoria';
FItems.Last.categoria := 'CONFIGURACOES';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000023';
FItems.Last.descricao := 'Configurações';
FItems.Last.categoria := 'CONFIGURACOES';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000024';
FItems.Last.descricao := 'Nível Acesso > PDV';
FItems.Last.categoria := 'CONFIGURACOES';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000025';
FItems.Last.descricao := 'Nível Acesso > Retaguarda';
FItems.Last.categoria := 'CONFIGURACOES';
FItems.Last.nivel := '0;1;2;';
FItems.Last.solicita_senha := False;

FItems.Add(TRetaguardaNivelModel.Create);
FItems.Last.codigo := '000026';
FItems.Last.descricao := 'Importar';
FItems.Last.categoria := 'CADASTRO';
FItems.Last.nivel := '';
FItems.Last.solicita_senha := False;

end;

procedure TRetaguardaNivelSeeder.Execute;
var
  RetaguardaNivel:TRetaguardaNivelModel;
begin
  for RetaguardaNivel in FItems do
  begin
    if (FRetaguardaNivelRepository.get(RetaguardaNivel.codigo) = nil) then
    begin
      FRetaguardaNivelRepository.insert(RetaguardaNivel);
    end;

  end;

end;



end.
