unit Classe.Impressao.Prevenda;

interface
uses system.SysUtils,system.Classes,Classe.Prevenda,Classe.Proprio,Classe.Cliente;
type
  TFonte = set of (fNegrito, fItalico, t10cpi, t12cpi, t17cpi, tExp, Justif, Esquerda, Centraliza, Direita);
type TImpressaoPreVenda = class
  private
  function criar_linha(sTexto:string;fonte:TFonte):string;
  function imprimir_cabecalho(oProprio:TProprio):TStringList;
  function imprimir_cliente(oCliente:TCliente):TStringList;
  function imprimir_itens(oPrevenda:TPrevenda):TStringList;
  function imprimir_pagamento(oPrevenda:TPrevenda):TStringList;
  public
  function imprimir_cupom_completo(oProprio:TProprio;oCliente:TCliente;oPrevenda:TPrevenda):TStringList;
end;

implementation
uses Classe.funcoes;

{ TImpressaoPreVenda }

function TImpressaoPreVenda.criar_linha(sTexto: string; fonte: TFonte): string;
var
  sFonteInicia:string;
  sFonteFecha:string;
begin
    sFonteInicia := '';
    sFonteInicia := '';
  if fNegrito in Fonte then
  begin
//    sFonteInicia := '<n>';
//    sFonteInicia := '</n>';
    sFonteInicia :=  '<n>';
    sFonteFecha :=  '</n>';
  end;
  if Centraliza in Fonte then
  begin
//    sFonteInicia :=  sFonteInicia + '<ce>';
//    sFonteInicia :=  sFonteFecha + '</ce>';
      sFonteInicia :=  '<ce>';
      sFonteFecha :=  '</ce>';
  end;
  if Direita in Fonte then
  begin
      sFonteInicia :=  '<ad>';
      sFonteFecha :=  '</ad>';
//    sFonteInicia :=  sFonteInicia + '<ad>';
//    sFonteInicia :=  sFonteFecha + '</ad>';
  end;
  if Esquerda in Fonte then
  begin
    sFonteInicia :=  '<ae>';
    sFonteFecha := '</ae>';
//    sFonteInicia :=  sFonteFecha + '</ae>';
  end;
//  impressora.Buffer.Add('</zera>');
  result := sFonteInicia + sTexto + sFonteFecha;
end;

function TImpressaoPreVenda.imprimir_cabecalho(oProprio: TProprio): TStringList;
begin
result := TStringList.Create;
result.Add('<n><ce>'+oProprio.Pessoa.Nome+'</n></ce>');
result.Add('<n><ce> CNPJ: '+oProprio.Pessoa.Nome+'</n></ce>');
end;

function TImpressaoPreVenda.imprimir_cliente(oCliente: TCliente): TStringList;
begin
result := TStringList.Create;
result.add(criar_linha('</linha_simples>',[Centraliza]));
result.add(criar_linha('CLIENTE:',[CENTRALIZA]));
result.add(criar_linha('CÓD.: '+oCliente.codigo,[Esquerda]));
result.add(criar_linha('NOME: '+oCliente.Pessoa.Nome,[Esquerda]));
result.add(criar_linha('TELEFONE 1: '+oCliente.Pessoa.telefone1,[Esquerda]));
result.add(criar_linha('TELEFONE 2: '+oCliente.Pessoa.telefone2,[Esquerda]));
result.add(criar_linha('CELULAR: '+oCliente.Pessoa.Celular1,[Esquerda]));
result.add(criar_linha('CPF/CNPJ: '+oCliente.Pessoa.CPFCNPJ,[Esquerda]));
result.add(criar_linha('ENDEREÇO: '+oCliente.Endereco.Endereco,[Esquerda]));
result.add(criar_linha('COMPLEMENTO: '+oCliente.Endereco.Complemento,[Esquerda]));
result.add(criar_linha('BAIRRO: '+oCliente.Endereco.Bairro,[Esquerda]));
result.add(criar_linha('CEP: '+oCliente.Endereco.CEP,[Esquerda]));
result.add(criar_linha('</linha_simples>',[Centraliza]));
end;

function TImpressaoPreVenda.imprimir_cupom_completo(oProprio:TProprio;oCliente:TCliente;oPrevenda:TPrevenda): TStringList;
begin
result := TStringList.Create;
Result.AddStrings(imprimir_cabecalho(oProprio));
result.AddStrings(imprimir_cliente(oCliente));
result.AddStrings(imprimir_itens(oPrevenda));
Result.AddStrings(imprimir_pagamento(oPrevenda));
end;

function TImpressaoPreVenda.imprimir_itens(oPrevenda: TPrevenda): TStringList;
var
  item:TPrevendaItem;
begin
result := TStringList.Create;
result.Add(criar_linha('No. ' + oPrevenda.codigo + '  Emis: ' + DateToStr(oPrevenda.data) + ' Caixa: ' + oPrevenda.terminal, [Centraliza]));
result.Add(criar_linha('</linha_simples>',[Centraliza]));
result.Add(criar_linha('P R O D U T O  QTDE   X   UNITARIO  =  VLR.TOTAL',
  [Centraliza]));
result.Add(criar_linha('</linha_simples>',[Centraliza]));

for Item in oPrevenda.items do
begin
result.Add(criar_linha(item.codigo_barras + ' ' + item.produto.descricao, [Esquerda]));

  result.Add(criar_linha(CompletaStr(FormatFloat('###,##0.000', item.qtde) + ' ' +
  item.produto.Unidade + '  X ', ' ', 16) + FormatFloat('###,##0.00', item.valorUnitario) +
  '    =    ' + FormatFloat('###,##0.00', item.valorTotal), [Direita]));
end;
result.Add(criar_linha('</linha_simples>',[Centraliza]));


end;

function TImpressaoPreVenda.imprimir_pagamento(
  oPrevenda: TPrevenda): TStringList;
begin
result := TStringList.Create;
Result.add(criar_linha(CompletaStr('VLR TOTAL', '.', 35) + ': ' + FormatFloat('###,##0.00', oPrevenda.getTotal), [Esquerda]));
end;

end.
