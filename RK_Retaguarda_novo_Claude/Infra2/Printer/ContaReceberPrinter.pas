unit ContaReceberPrinter;

interface
uses ContaReceberModel,ImpressoraService,ProprioModel,ProprioRepositoryImpl,System.SysUtils,ContaReceberItemModel,ConfiguracaoRepositoryImpl;
type IContaReceberPrinter = interface
  ['{9E8A0F60-1D97-402A-9F24-6F79D2453DB3}']
  procedure imprimir(conta:TContaReceberModel);
end;

type TContaReceberPrinter = class(TInterfacedObject,IContaReceberPrinter)
  private

  FImpressora:IImpressoraService;
  FProprioRepository:IProprioRepository;

  procedure ImprimirCabecalho(conta:TContaReceberModel);
  procedure ImprimirItens(conta:TContaReceberModel);
  procedure ImprimirFinalizar(conta:TContaReceberModel);


  const
  mascara_qtde = '###,##0.000';
  mascara_Valor = '###,##0.00';


  public
    constructor create;
    procedure imprimir(conta: TContaReceberModel);
end;

implementation

{ TContaReceberPrinter }

constructor TContaReceberPrinter.create;
begin
FProprioRepository := TProprioRepositoryFirebird.create;
FImpressora :=TImpressoraService.create;
end;

procedure TContaReceberPrinter.imprimir(conta: TContaReceberModel);
begin
FImpressora.Limpar;
FImpressora.Configurar(FConfiguracaoRepositoryFirebird.Obter.porta_impressora);
ImprimirCabecalho(conta);
ImprimirItens(conta);
ImprimirFinalizar(conta);
FImpressora.Imprimir;
end;

procedure TContaReceberPrinter.ImprimirCabecalho(conta:TContaReceberModel);
begin
  with FProprioRepository.Get do
  begin
    FImpressora.ImprimirBuffer(Pessoa.Nome ,[fNegrito, Centraliza]);
    FImpressora.ImprimirBuffer('CNPJ: '+Pessoa.CPFCNPJ ,[fNegrito, Centraliza]);
    FImpressora.ImprimirBuffer(Endereco.Endereco, [Centraliza]);

    FImpressora.ImprimirBuffer(Endereco.Cidade + ' - ' +Endereco.UF +' - CEP ' + Endereco.CEP, [Centraliza]);
    FImpressora.ImprimirBuffer('Telefone: ' + Pessoa.Telefone1, [Centraliza]);
    FImpressora.ImprimirBuffer('</linha_simples>',[Esquerda]);

    FImpressora.ImprimirBuffer('Conta A Receber',[Centraliza]);
    FImpressora.ImprimirBuffer('',[Esquerda]);
    FImpressora.ImprimirBuffer('Data Emissão:'+DateToStr(conta.data_emissao),[Esquerda]);
    FImpressora.ImprimirBuffer('Data Vencimento:'+DateToStr(conta.data_vencimento),[Esquerda]);
    FImpressora.ImprimirBuffer('Cód Venda:'+conta.codigo,[Esquerda]);
    FImpressora.ImprimirBuffer('</linha_simples>',[Esquerda]);
  end;
end;

procedure TContaReceberPrinter.ImprimirItens(conta: TContaReceberModel);
var
  item:TContaReceberItemModel;

begin
FImpressora.ImprimirBuffer('</linha_simples>',[Centraliza]);
FImpressora.ImprimirBuffer('P R O D U T O  QTDE   X   UNITARIO  =  VLR.TOTAL',[Centraliza]);

for item in conta.items do
begin
  FImpressora.ImprimirBuffer(item.produto.codigo + ' ' + item.produto.Descricao, [Esquerda]);

  FImpressora.ImprimirBuffer(FormatFloat(mascara_qtde, item.qtd) + ' ' +
  item.unidade + '  X ' + FormatFloat(mascara_Valor, item.vlr_unitario) +
  '    =    ' + FormatFloat(mascara_Valor, item.vlr_total), [Direita]);
  if item.vlr_desconto > 0 then
  begin
  FImpressora.ImprimirBuffer('DESCONTO: '+FormatFloat(mascara_Valor,item.vlr_desconto),[Esquerda]);
  FImpressora.ImprimirBuffer('',[Esquerda]);
  end;
end;

FImpressora.ImprimirBuffer('</linha_simples>',[Centraliza]);
end;

procedure TContaReceberPrinter.ImprimirFinalizar(conta: TContaReceberModel);
begin
FImpressora.ImprimirBuffer('Total: '+FormatFloat( mascara_Valor,conta.valor),[esquerda]);
FImpressora.ImprimirBuffer('Valor Pago: '+FormatFloat(mascara_Valor,conta.valor_pago),[Esquerda]);
FImpressora.ImprimirBuffer('Valor Restante: '+FormatFloat(mascara_Valor,conta.valor_restante),[Esquerda]);
FImpressora.ImprimirBuffer('</linha_simples>',[Centraliza]);
FImpressora.ImprimirBuffer('',[Centraliza]);
end;

end.
