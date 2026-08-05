unit uGrupoTeste;

interface
uses
  DUnitX.TestFramework,uGrupoController,System.SysUtils,Classe.Grupo,uDmConexao,Classe.Variaveis,IBCErrorUni;

type

  [TestFixture('Teste retaguarda')]
  RetaguardaTest = class(TObject)
  private
    oGrupoTest:TGrupo;
    uDmConexao :TdmConexao;
    uGrupoController :TGrupoController;
    uVariaveis:TVariaveis;

  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCaseAttribute('Inserção 1','99;Teste',';')]
    [TestCaseAttribute('Inserção 2','0123;Teste 2',';')]
    procedure InserirGrupo(codigo,grupo:string);


    [Test]
    [TestCaseAttribute('Teste truncando código','12345612316456;Teste 2',';')]
    [TestCaseAttribute('Teste truncando descrição','123;dksalçfdj askldjasdjk saljdklsa jdlkjsa lkdjas kljdlk asjdkl jaslkdj klasjd kljasdj askljd asghj ksad',';')]
    procedure TesteObjeto(codigo,grupo:string);


  end;

implementation


procedure RetaguardaTest.InserirGrupo(codigo,grupo:string);
begin
  oGrupoTest.Codigo := codigo;
  oGrupoTest.Descricao := grupo;
  // se existir grupo
  uGrupoController.ExcluirGrupo(oGrupoTest);

  Assert.IsTrue(uGrupoController.InserirGrupo(oGrupoTest),'Inserção deveria retornar true');
  // chave duplicada
  Assert.WillRaise(procedure begin uGrupoController.InserirGrupo(oGrupoTest) end, Exception,'Deveria gerar erro de chave primaria');
  // consultar se cadastrou grupo
  Assert.IsTrue(uGrupoController.CarregarGrupo(oGrupoTest),'Deveria consultar grupo');

  uGrupoController.ExcluirGrupo(oGrupoTest);
end;

procedure RetaguardaTest.Setup;
begin
uDmConexao := TdmConexao.Create(nil);
VariaveisSrv := TVariaveis.create;
uGrupoController := TGrupoController.create;
oGrupoTest := TGrupo.Create;

end;

procedure RetaguardaTest.TearDown;
begin
FreeAndNil(uGrupoController);

end;


procedure RetaguardaTest.TesteObjeto(codigo, grupo: string);
begin
  if Length(codigo) > 6 then
  begin
    Assert.WillRaise(procedure begin oGrupoTest.Codigo := codigo end,Exception,'Deveria ter limite de 6 digitos código');
  end;

  if Length(grupo) > 40 then
  begin
    Assert.WillRaise(procedure begin oGrupoTest.Descricao := grupo end,Exception,'Deveria ter limite de 40 digitos descrição do grupo');
  end;

end;

initialization
  TDUnitX.RegisterTestFixture(RetaguardaTest);
end.
