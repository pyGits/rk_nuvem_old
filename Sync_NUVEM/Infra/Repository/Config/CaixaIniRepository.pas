unit CaixaIniRepository;

interface
uses System.Generics.Collections, CaixaModel, CaixaRepository;

// Os caixas que recebem a carga sao cadastrados no proprio agente e ficam no
// config.ini, ao lado do token e da loja. Antes a lista vinha da tabela CAIXA
// do banco da retaguarda - com a nuvem esse cadastro deixou de ser feito
// localmente, entao o agente passou a ser o dono da lista.
//
// Formato da secao (os valores vao criptografados, como todo o config.ini):
//
//   [CAIXAS]
//   QTD=2
//   CAIXA1_NOME=Caixa 1
//   CAIXA1_IP=127.0.0.1
//   CAIXA2_NOME=Caixa 2
//   CAIXA2_IP=192.168.0.20

const
  SECAO_CAIXAS = 'CAIXAS';
  IP_LOCALHOST = '127.0.0.1';
  NOME_CAIXA_LOCAL = 'Caixa 1';

type ICaixaIniRepository = interface
  ['{5D2A7F13-8C46-4E9B-A071-63B8F2D45C10}']
  function getAll: TObjectList<TCaixaModel>;
  procedure salvar(caixas: TObjectList<TCaixaModel>);
end;

type TCaixaIniRepository = class(TInterfacedObject, ICaixaRepository, ICaixaIniRepository)
  private
    // O caixa 1 e o PDV da propria maquina: existe em toda instalacao e e o
    // unico que vale antes de qualquer cadastro. Por isso ele e garantido na
    // leitura e na gravacao, e nao so na tela.
    procedure garantirCaixaLocal(caixas: TObjectList<TCaixaModel>);
    function novoCaixa(const nome, ip: string): TCaixaModel;
  public
    function getAll: TObjectList<TCaixaModel>;
    procedure salvar(caixas: TObjectList<TCaixaModel>);
end;

implementation

uses System.SysUtils, Utils;

{ TCaixaIniRepository }

function TCaixaIniRepository.novoCaixa(const nome, ip: string): TCaixaModel;
begin
  Result := TCaixaModel.Create;
  Result.nome := nome;
  Result.ip := ip;
end;

procedure TCaixaIniRepository.garantirCaixaLocal(caixas: TObjectList<TCaixaModel>);
var
  i: integer;
begin
  if (caixas.Count = 0) or (Trim(caixas[0].ip) <> IP_LOCALHOST) then
    caixas.Insert(0, novoCaixa(NOME_CAIXA_LOCAL, IP_LOCALHOST));

  // O numero do caixa e a posicao na lista: e por ele que o log diz para qual
  // PDV a carga foi.
  for i := 0 to caixas.Count - 1 do
    caixas[i].codigo := IntToStr(i + 1);
end;

function TCaixaIniRepository.getAll: TObjectList<TCaixaModel>;
var
  qtd, i: integer;
  nome, ip: string;
begin
  Result := TObjectList<TCaixaModel>.Create(true);

  qtd := StrToIntDef(Utils.ReadIniString(SECAO_CAIXAS, 'QTD', ''), 0);

  for i := 1 to qtd do
  begin
    nome := Utils.ReadIniString(SECAO_CAIXAS, Format('CAIXA%d_NOME', [i]), '');
    ip := Trim(Utils.ReadIniString(SECAO_CAIXAS, Format('CAIXA%d_IP', [i]), ''));

    // Sem IP nao ha para onde mandar a carga: a conexao com o PDV so conhece o
    // endereco. Linha assim so aparece se alguem editar o ini na mao.
    if ip = '' then Continue;

    Result.Add(novoCaixa(nome, ip));
  end;

  garantirCaixaLocal(Result);
end;

procedure TCaixaIniRepository.salvar(caixas: TObjectList<TCaixaModel>);
var
  i, gravados, qtdAnterior: integer;
  ip: string;
begin
  garantirCaixaLocal(caixas);

  qtdAnterior := StrToIntDef(Utils.ReadIniString(SECAO_CAIXAS, 'QTD', ''), 0);

  gravados := 0;
  for i := 0 to caixas.Count - 1 do
  begin
    ip := Trim(caixas[i].ip);
    if ip = '' then Continue;

    Inc(gravados);
    Utils.WriteIniString(SECAO_CAIXAS, Format('CAIXA%d_NOME', [gravados]), caixas[i].nome);
    Utils.WriteIniString(SECAO_CAIXAS, Format('CAIXA%d_IP', [gravados]), ip);
  end;

  // Quem removeu caixa deixaria as chaves antigas para tras. O QTD sozinho ja
  // as ignoraria, mas o ini ficaria mentindo para quem o abrisse.
  for i := gravados + 1 to qtdAnterior do
  begin
    Utils.WriteIniString(SECAO_CAIXAS, Format('CAIXA%d_NOME', [i]), '');
    Utils.WriteIniString(SECAO_CAIXAS, Format('CAIXA%d_IP', [i]), '');
  end;

  Utils.WriteIniString(SECAO_CAIXAS, 'QTD', IntToStr(gravados));
end;

end.
