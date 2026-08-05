unit uDmProduto;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,NxGrid,Classe.Produto,conversao,Classe.Funcoes,Vcl.DBGrids,Vcl.StdCtrls,
  frxClass, frxDBSet, frxBarcode,Classe.Relatorio,VCL.dialogs,Produto;

type
  TdmProduto = class(TDataModule)
    qrProdutoPesq: TUniQuery;
    qrProdutoInserir: TUniQuery;
    qrProdutoAlterar: TUniQuery;
    qrProdutoExcluir: TUniQuery;
    qrGridProduto: TUniQuery;
    qrGridProdutoCODIGO: TStringField;
    qrGridProdutoCODIGO_BARRAS: TStringField;
    qrGridProdutoDESCRICAO: TStringField;
    qrGridProdutoGRUPO: TStringField;
    qrGridProdutoSUBGRUPO: TStringField;
    qrGridProdutoFORNECEDOR: TStringField;
    qrGridProdutoTRIBUTACAO: TStringField;
    qrGridProdutoNCM: TStringField;
    qrGridProdutoCEST: TStringField;
    qrGridProdutoVALIDADE: TStringField;
    qrGridProdutoBALANCA: TIntegerField;
    qrGridProdutoFRACIONADO: TIntegerField;
    qrGridProdutoCUSTO: TFloatField;
    qrGridProdutoPRECO: TFloatField;
    qrGridProdutoMARGEM: TFloatField;
    qrGridProdutoESTOQUE: TFloatField;
    qrGridProdutoUNIDADE: TStringField;
    qrGridProdutoINATIVO: TIntegerField;
    qrGridProdutoDIVERSOS: TIntegerField;
    qrGridProdutoDATA_CADASTRO: TDateField;
    qrGridProdutoDATA_ALTERADO: TDateField;
    qrGridProdutoPENDENTE: TIntegerField;
    qrProduto: TUniQuery;
    qrProdutoCODIGO: TStringField;
    qrProdutoCODIGO_BARRAS: TStringField;
    qrProdutoDESCRICAO: TStringField;
    qrProdutoGRUPO: TStringField;
    qrProdutoSUBGRUPO: TStringField;
    qrProdutoFORNECEDOR: TStringField;
    qrProdutoTRIBUTACAO: TStringField;
    qrProdutoNCM: TStringField;
    qrProdutoCEST: TStringField;
    qrProdutoVALIDADE: TStringField;
    qrProdutoBALANCA: TIntegerField;
    qrProdutoFRACIONADO: TIntegerField;
    qrProdutoCUSTO: TFloatField;
    qrProdutoPRECO: TFloatField;
    qrProdutoMARGEM: TFloatField;
    qrProdutoESTOQUE: TFloatField;
    qrProdutoUNIDADE: TStringField;
    qrProdutoINATIVO: TIntegerField;
    qrProdutoDIVERSOS: TIntegerField;
    qrProdutoDATA_CADASTRO: TDateField;
    qrProdutoDATA_ALTERADO: TDateField;
    qrProdutoPENDENTE: TIntegerField;
    qrEtiquetaInserir: TUniQuery;
    qrGridEtiqueta_old: TUniQuery;
    qrGridEtiqueta_oldID: TIntegerField;
    qrGridEtiqueta_oldCODIGO: TStringField;
    qrGridEtiqueta_oldCODIGO_BARRAS: TStringField;
    qrGridEtiqueta_oldPRODUTO: TStringField;
    qrGridEtiqueta_oldUNIDADE: TStringField;
    qrGridEtiqueta_oldPRECO: TFloatField;
    dbGridEtiqueta: TfrxDBDataset;
    frxEtiqueta: TfrxReport;
    frxBarCodeObject1: TfrxBarCodeObject;
    qrGridEtiqueta_oldID_1: TIntegerField;
    qrGridEtiqueta_oldCODIGO_PRODUTO: TStringField;
    qrGridEtiqueta_oldLOCALIZACAO: TStringField;
    qrGridEtiqueta_oldQUANTIDADE: TFloatField;
    qrGridEtiqueta_oldVALIDADE_1: TDateField;
    qrGridEtiqueta_oldSITUACAO: TIntegerField;
    qrGridEtiqueta_oldDIAS_VENCER: TIntegerField;
    qrGridEtiqueta_oldDATA_ENTRADA: TDateField;
    qrGridEtiqueta_oldSELECIONADO: TIntegerField;
    qrGridEtiqueta_oldPROXIMO_VENCIMENTO: TIntegerField;
    qrGridEtiqueta_oldLOTE: TStringField;
    qrGridEtiqueta_oldOBSERVACAO: TStringField;
    qrGridEtiqueta_oldVALIDADE: TStringField;
    qrGridEtiqueta_oldPRECO2: TFloatField;
    qrGridEtiqueta_oldPRECO2_QTD: TFloatField;
    qrGridEtiqueta_oldPRECO3: TFloatField;
    qrGridEtiqueta_oldPRECO3_QTD: TFloatField;
    qrGridEtiqueta: TUniQuery;
    dbGridEtiqueta_old: TfrxDBDataset;
    qrGridEtiquetaID: TIntegerField;
    qrGridEtiquetaCODIGO: TStringField;
    qrGridEtiquetaCODIGO_BARRAS: TStringField;
    qrGridEtiquetaPRODUTO: TStringField;
    qrGridEtiquetaUNIDADE: TStringField;
    qrGridEtiquetaPRECO: TFloatField;
    qrGridEtiquetaVALIDADE: TIntegerField;
  private
    function serializarTexto(const texto:string;tamanhoTotal:integer):string;
    function serializarZeroEsquerda(const texto:string;tamanhoTotal:integer):string;
    procedure ExportarBalancaToledo(lblProgresso: TLabel;memProgresso:TMemo;diretorio:string);
    procedure ExportarBalancaFilizola(lblProgresso: TLabel;memProgresso:TMemo;diretorio:string);
    procedure ExportarBalancaUpx(lblProgresso: TLabel;memProgresso:TMemo;diretorio:string);
    procedure ExportarBalancaItensMGV(lblProgresso:TLabel;memProgresso:TMemo;diretorio:string);
  public
    function PreencherGrid(sProduto:string;ds:TDataSource;tipo:TPesquisar):Boolean;
    function InserirProduto(oProduto:Classe.Produto.TProduto):Boolean;
    function AlterarProduto(oProduto:Classe.Produto.TProduto):boolean;
    function ExcluirProduto(oProduto:Classe.Produto.TProduto):boolean;
    function CarregarProduto(oProduto:Classe.Produto.TProduto):boolean;
    function VerificaCodigoBarras(oProduto:Classe.Produto.TProduto):Boolean;
    function ExportarProdutosBalanca(bal:TBalanca;lblProgresso:TLabel;memProgresso:TMemo;diretorio:string):Boolean;

    // etiqueta
    function InserirEtiqueta(oProduto:Produto.TProduto):boolean;
    function InserirEtiquetaCodigoAuxiliar(oProduto:Classe.Produto.TProduto):boolean;
    function PreencherGridEtiqueta(ds:TDataSource;imprimirLote:boolean):boolean;
    function PreencherGridAlterados(oRelatorio:TRelatorio):Boolean;
    function ImprimirEtiqueta(ds:TDatasource;layout:string):Boolean;

    function LimparGridEtiqueta(ds:TDataSource):Boolean;


  end;

var
  dmProduto: TdmProduto;

implementation
uses Classe.Variaveis;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmProduto }

function TdmProduto.AlterarProduto(oProduto: Classe.Produto.TProduto): boolean;
begin
    with qrProdutoAlterar, oProduto do begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('CODIGO_BARRAS').AsString := CodigoBarras;
     Params.ParamByName('DESCRICAO').AsString := Descricao;
     Params.ParamByName('GRUPO').AsString := Grupo;
     Params.ParamByName('SUBGRUPO').AsString := Subgrupo;
     Params.ParamByName('FORNECEDOR').AsString := Fornecedor;
     Params.ParamByName('Tributacao').AsString := Tributacao;
     Params.ParamByName('NCM').AsString := NCM;
     Params.ParamByName('CEST').AsString := CEST;
     Params.ParamByName('Validade').AsString := Validade;//
     Params.ParamByName('BALANCA').AsInteger := getBalanca;
     Params.ParamByName('Fracionado').AsInteger := getFracionado;
     Params.ParamByName('INATIVO').AsInteger := getInativo;
     Params.ParamByName('DIVERSOS').AsInteger := getDiversos;
     Params.ParamByName('CUSTO').AsFloat := Custo;
     Params.ParamByName('PRECO').AsFloat := Preco;
     Params.ParamByName('MARGEM').AsFloat := Margem;
     Params.ParamByName('ESTOQUE').AsFloat := estoqueAnterior;
     Params.ParamByName('Unidade').AsString := Unidade;
     Params.ParamByName('DATA_ALTERADO').asDate := date;
     Params.ParamByName('DATA_CADASTRO').asDate := date;
     Params.ParamByName('PENDENTE').AsInteger := 1;
     Params.ParamByName('ESTOQUE_MINIMO').AsFloat := estoqueMinimo;
     Params.ParamByName('ESTOQUE_MAXIMO').AsFloat := estoqueMaximo;
     Params.ParamByName('OBSERVACAO').AsString := observacao;
     try
       ExecSQL();
       Result := True;
     except
       on E : Exception do
       begin
        raise Exception.Create(E.Message);
        Result := false;
       end;

     end;


    end;
end;

function TdmProduto.CarregarProduto(oProduto: Classe.Produto.TProduto): boolean;
begin

  if oProduto.CodigoBarras = '' then
  begin
    qrProdutoPesq.Close;
    qrProdutoPesq.SQL.Clear;
    qrProdutoPesq.SQL.Add('SELECT * FROM produto WHERE CODIGO = :CODIGO');
    qrProdutoPesq.ParamByName('CODIGO').AsString := oProduto.Codigo;
  end
  else
  begin
    qrProdutoPesq.Close;
    qrProdutoPesq.SQL.Clear;
    qrProdutoPesq.SQL.Add('SELECT * FROM PRODUTO WHERE CODIGO_BARRAS = :CODIGO_BARRAS');
    qrProdutoPesq.ParamByName('CODIGO_BARRAS').AsString := oProduto.CodigoBarras;
  end;

    try
      qrProdutoPesq.Open;
      if qrProdutoPesq.RecordCount > 0 then
      begin
      oProduto.Codigo       := qrProdutoPesq.FieldByName('CODIGO').AsString;
      oProduto.CodigoBarras := qrProdutoPesq.FieldByName('CODIGO_BARRAS').asstring;
      with oProduto do
      begin
      Descricao    := qrProdutoPesq.FieldByName('DESCRICAO').asstring;
      Grupo        := qrProdutoPesq.FieldByName('GRUPO').asstring;
      Subgrupo     := qrProdutoPesq.FieldByName('SUBGRUPO').asstring;
      Fornecedor   := qrProdutoPesq.FieldByName('FORNECEDOR').asstring;
      Tributacao   := qrProdutoPesq.FieldByName('Tributacao').AsString;
      NCM          := qrProdutoPesq.FieldByName('NCM').AsString;
      CEST         := qrProdutoPesq.FieldByName('CEST').AsString;
      Validade     := qrProdutoPesq.FieldByName('Validade').AsString;
      Unidade      := qrProdutoPesq.FieldByName('Unidade').AsString;

      Custo        := qrProdutoPesq.FieldByName('CUSTO').AsFloat;
      Preco        := qrProdutoPesq.FieldByName('PRECO').AsFloat;
      Margem       := qrProdutoPesq.FieldByName('MARGEM').AsFloat;
      Estoque      := qrProdutoPesq.FieldByName('Estoque').AsFloat;
      DataCadastro := qrProdutoPesq.FieldByName('DATA_CADASTRO').AsDateTime;
      DataAlterado := qrProdutoPesq.FieldByName('DATA_ALTERADO').AsDateTime;
      Balanca      := getBoolBalanca(qrProdutoPesq.FieldByName('BALANCA').AsInteger);
      Fracionado   := getBoolFracionado(qrProdutoPesq.FieldByName('Fracionado').AsInteger);
      Inativo      := getBoolInativo(qrProdutoPesq.FieldByName('INATIVO').AsInteger);
      Diversos     := getBoolDiversos(qrProdutoPesq.FieldByName('DIVERSOS').AsInteger);
      estoqueMaximo := qrProdutoPesq.FieldByName('ESTOQUE_MAXIMO').AsFloat;
      estoqueMinimo := qrProdutoPesq.FieldByName('ESTOQUE_MINIMO').AsFloat;
      OBSERVACAO := qrProdutoPesq.FieldByName('OBSERVACAO').ASSTRING;
      end;


       Result := True;
      end
      else
      begin
        Result := false;
      end;
    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar produto: '+E.Message);
          Result := False;
      end;

    end;
end;



function TdmProduto.ExcluirProduto(oProduto: Classe.Produto.TProduto): boolean;
begin
  // verifica se existe movimentação no produto
  with qrProdutoPesq do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_PRODUTO FROM CUPOM_ITEM WHERE COD_PRODUTO = :COD_PRODUTO');
    ParamByName('COD_PRODUTO').AsString := oProduto.Codigo;
    open;
    if qrProdutoPesq.RecordCount > 0 then
    begin
      raise Exception.Create('Ja existe movimentação de venda no produto, o produto não pode ser excluído apenas inativo');
    end;

  end;
  with qrProdutoExcluir, oProduto do
  begin
    ParamByName('CODIGO').AsString := Codigo;
    ExecSQL;
  end;
end;

procedure TdmProduto.ExportarBalancaFilizola(lblProgresso: TLabel;
  memProgresso: TMemo;diretorio:string);
  var txt_produto, txt_nutri, txt_setor, txt_receita: textfile;
  texto3, texto, texto1, texto2, texto4, TEXTO5: string;
  porc, CALo, VDCALo, CARB, VDCARB, PROT, VDPROT, GORD, VDGORD, SATU, VDSATU, COLE, VDCOLE, FIBR, VDFIBR, CALC, VDCALC, FERR, VDFERR, SODI, VDSODI: string;
begin
with qrProdutoPesq do
begin
  memProgresso.Clear;
    close;
    SQL.Clear;
    sql.add('select * from produto where INATIVO = 0 and balanca = 1 order by codigo');
    open;
    First;
    assignfile(txt_produto, diretorio+'\cadtxt.txt'); // txt
    assignfile(txt_setor, diretorio+'\setortxt.txt'); // txt2
    assignfile(txt_receita, diretorio+'\rec_ass.txt'); // txt3
    assignfile(txt_nutri, diretorio+'\nutri.txt'); // txt3

    rewrite(txt_produto);
    rewrite(txt_setor);
    rewrite(txt_receita);
    rewrite(txt_nutri);

    while not qrProdutoPesq.eof do
    begin
          // remover zero esquerda ?
//        texto := FieldByName('CODIGO_BARRAS').AsString;
        texto := Copy (FieldByName('CODIGO_BARRAS').AsString, Length(FieldByName('CODIGO_BARRAS').AsString) - 5, Length(FieldByName('CODIGO_BARRAS').AsString));
        texto1 := FieldByName('DESCRICAO').AsString;
        texto2 := formatfloat('###,###,##0.00', FieldByName('PRECO').AsFloat);
        texto3 := FieldByName('VALIDADE').AsString;
        if FieldByName('UNIDADE').AsString = 'UN' then
        begin
        TEXTO4 := 'U';
        end
        else
        begin
        TEXTO4 := 'P';
        end;

        while length(texto) < 6 do texto := '0' + texto;
        while length(texto1) < 22 do texto1 := texto1 + ' ';
        while length(texto1) > 22 do System.delete( texto1, 23, 1);
        System.delete(texto2, pos(',', texto2), 1);
        while length(texto2) < 7 do texto2 := '0' + texto2;
        while length(texto3) < 3 do texto3 := '0' + texto3;

        porc := ''; CALo := ''; VDCALo := ''; CARB := ''; VDCARB := ''; PROT := ''; VDPROT := ''; GORD := ''; VDGORD := ''; SATU := ''; VDSATU := ''; COLE := ''; VDCOLE := ''; FIBR := ''; VDFIBR := ''; CALC := ''; VDCALC := ''; FERR := ''; VDFERR := ''; SODI := ''; VDSODI := '';
        writeln(txt_produto, texto + TEXTO4 + texto1 + texto2 + TEXTO3);

          //grupo
        texto := 'GERAL       ';
//        texto1 := FieldByName('CODIGO_BARRAS').AsString;
        texto1 := Copy (FieldByName('CODIGO_BARRAS').AsString, Length(FieldByName('CODIGO_BARRAS').AsString) - 7, Length(FieldByName('CODIGO_BARRAS').AsString));
        TEXTO2 := '0';
        TEXTO3 := '0';
        while length(texto1) < 6 do texto1 := '0' + texto1;
        while length(texto2) < 4 do texto2 := '0' + texto2;
        while length(texto3) < 3 do texto3 := '0' + texto3;
        writeln(txt_setor, texto + texto1 + texto2 + texto3);


          texto := '';
          texto1 := '';
          texto2 := '';
          texto3 := '';

      memProgresso.Lines.Add(FieldByName('CODIGO').AsString+ ' : '+ FieldByName('DESCRICAO').AsString);
      qrProdutoPesq.Next;


    end;
    end;





    closefile(txt_produto);
    closefile(txt_setor);
    closefile(txt_receita);
    closefile(txt_nutri);

end;


procedure TdmProduto.ExportarBalancaItensMGV(lblProgresso: TLabel;
  memProgresso: TMemo; diretorio: string);
var
  txt_produto:TextFile;
  texto1,texto2,texto3,texto4,texto5,texto6:string;
begin
    //defaults
    texto1 := '0'; // unidade do produto

    memProgresso.Clear;
    with qrProdutoPesq do
    begin
      close;
      SQL.Clear;
      sql.add('select * from produto where INATIVO = 0 AND balanca = 1 order by codigo');
      open;
      assignfile(txt_PRODUTO, diretorio+'\ITENSMGV.TXT');
      rewrite(txt_PRODUTO);

      while not qrProdutoPesq.eof do
      begin
        if qrProduto.FieldByName('UNIDADE').AsString = 'UN' then
        begin
          texto1 := '1';
        end;
        texto2 := zeroEsquerda(inttostr(FieldByName('CODIGO_BARRAS').AsInteger),6);
        texto3 := zeroEsquerda(FormatFloat('###,###,##0.00', FieldByName('PRECO').AsFloat),6);
        texto4 := zeroEsquerda(IntToStr(FieldByName('VALIDADE').AsInteger),3);
        texto5 := serializarTexto(FieldByName('DESCRICAO').AsString , 50);
        texto6 := '0000000000000000110000000000000000            000000000000000000000000            000000||                                                                      0000000000000000000000000||0||';
        writeln(txt_PRODUTO, '01' + texto1 + texto2 + texto3 + texto4 + texto5 + texto6);
        memProgresso.Lines.Add(FieldByName('DESCRICAO').AsString);
        qrProdutoPesq.Next;
      end;
      CloseFile(txt_produto);
      end;
end;

procedure TdmProduto.ExportarBalancaToledo(lblProgresso: TLabel;memProgresso:TMemo;diretorio:string);
var
  txt_produto:TextFile;
  texto3, texto, texto1, texto2, texto4, TEXTO5: string;
begin
  memProgresso.Clear;
    with qrProdutoPesq do
    begin
      close;
      SQL.Clear;
      sql.add('select * from produto where INATIVO = 0 AND balanca = 1 order by codigo');
      open;
      // criar txt
      assignfile(txt_PRODUTO, diretorio+'\TXITENS.TXT');
      rewrite(txt_PRODUTO);
      while not qrProdutoPesq.eof do
      begin

        texto := Copy (FieldByName('CODIGO_BARRAS').AsString, Length(FieldByName('CODIGO_BARRAS').AsString) - 5, Length(FieldByName('CODIGO_BARRAS').AsString));
//        texto := FieldByName('CODIGO_BARRAS').AsString;
        texto1 := FieldByName('DESCRICAO').AsString;
        texto2 := formatfloat('###,###,##0.00', FieldByName('preco').AsFloat);
        texto3 := FieldByName('VALIDADE').AsString;
        // unidade de medida
        if FieldByName('UNIDADE').AsString = 'UN' then
        begin
        TEXTO4 := '1';
        end
        else
        begin
        TEXTO4 := '0';
        end;

        while length(texto) < 6 do texto := '0' + texto;
        while length(texto1) < 50 do texto1 := texto1 + ' ';
        while length(texto1) > 50 do System.delete(texto1, 51, 1);
        System.delete(texto2, pos(',', texto2), 1);
        System.delete(texto2, pos('.', texto2), 1);
        while length(texto2) < 6 do texto2 := '0' + texto2;
        while length(texto3) < 3 do texto3 := '0' + texto3;
        texto5 := '';
        while length(texto5) < 250 do texto5 := texto5 + ' ';
        // layout             dep 22
        while length(texto5) > 250 do System.delete(texto5, 251, 1);
        writeln(txt_PRODUTO, '01' + '00' + TEXTO4 + TEXTO + TEXTO2 + TEXTO3 + TEXTO1 + TEXTO5);
        memProgresso.Lines.Add(FieldByName('CODIGO').AsString+ ' : '+ FieldByName('DESCRICAO').AsString);



        qrProdutoPesq.Next;

      end;
      closefile(txt_PRODUTO);

    end;
end;

procedure TdmProduto.ExportarBalancaUpx(lblProgresso: TLabel;
  memProgresso: TMemo; diretorio: string);
  var txt_produto, txt_nutri, txt_setor, txt_receita: textfile;
  texto3, texto, texto1, texto2, texto4, TEXTO5: string;
  porc, CALo, VDCALo, CARB, VDCARB, PROT, VDPROT, GORD, VDGORD, SATU, VDSATU, COLE, VDCOLE, FIBR, VDFIBR, CALC, VDCALC, FERR, VDFERR, SODI, VDSODI: string;
begin
with qrProdutoPesq do
begin
  memProgresso.Clear;
    close;
    SQL.Clear;
    sql.add('select * from produto where INATIVO = 0 and balanca = 1 order by codigo');
    open;
    First;
    assignfile(txt_produto, diretorio+'\cadtxt.txt'); // txt
    assignfile(txt_setor, diretorio+'\setortxt.txt'); // txt2
    assignfile(txt_receita, diretorio+'\rec_ass.txt'); // txt3
    assignfile(txt_nutri, diretorio+'\nutri.txt'); // txt3

    rewrite(txt_produto);
    rewrite(txt_setor);
    rewrite(txt_receita);
    rewrite(txt_nutri);

    while not qrProdutoPesq.eof do
    begin
          // remover zero esquerda ?
        texto := Copy (FieldByName('CODIGO_BARRAS').AsString, Length(FieldByName('CODIGO_BARRAS').AsString) - 5, Length(FieldByName('CODIGO_BARRAS').AsString));
        texto1 := FieldByName('DESCRICAO').AsString;
        texto2 := formatfloat('###,###,##0.00', FieldByName('PRECO').AsFloat);
        texto3 := FieldByName('VALIDADE').AsString;
        if FieldByName('UNIDADE').AsString = 'UN' then
        begin
        TEXTO4 := 'U';
        end
        else
        begin
        TEXTO4 := 'P';
        end;

        while length(texto) < 6 do texto := '0' + texto;
        while length(texto1) < 22 do texto1 := texto1 + ' ';
        while length(texto1) > 22 do System.delete( texto1, 23, 1);
        System.delete(texto2, pos(',', texto2), 1);
        while length(texto2) < 7 do texto2 := '0' + texto2;
        while length(texto3) < 3 do texto3 := '0' + texto3;

        porc := ''; CALo := ''; VDCALo := ''; CARB := ''; VDCARB := ''; PROT := ''; VDPROT := ''; GORD := ''; VDGORD := ''; SATU := ''; VDSATU := ''; COLE := ''; VDCOLE := ''; FIBR := ''; VDFIBR := ''; CALC := ''; VDCALC := ''; FERR := ''; VDFERR := ''; SODI := ''; VDSODI := '';
        writeln(txt_produto, texto + TEXTO4 + texto1 + texto2 + TEXTO3);

          //grupo
        texto := 'GERAL       ';
//        texto1 := FieldByName('CODIGO_BARRAS').AsString;
        texto1 := Copy (FieldByName('CODIGO_BARRAS').AsString, Length(FieldByName('CODIGO_BARRAS').AsString) - 7, Length(FieldByName('CODIGO_BARRAS').AsString));
        TEXTO2 := '0';
        TEXTO3 := '0';
        while length(texto1) < 6 do texto1 := '0' + texto1;
        while length(texto2) < 4 do texto2 := '0' + texto2;
        while length(texto3) < 3 do texto3 := '0' + texto3;
        writeln(txt_setor, texto + texto1 + texto2 + texto3);


          texto := '';
          texto1 := '';
          texto2 := '';
          texto3 := '';

      memProgresso.Lines.Add(FieldByName('CODIGO').AsString+ ' : '+ FieldByName('DESCRICAO').AsString);
      qrProdutoPesq.Next;


    end;
    end;





    closefile(txt_produto);
    closefile(txt_setor);
    closefile(txt_receita);
    closefile(txt_nutri);
end;

function TdmProduto.ExportarProdutosBalanca(bal:TBalanca;lblProgresso: TLabel;
  memProgresso: TMemo;diretorio:string): Boolean;
begin
memProgresso.Lines.Clear;
  case bal of
    balToledo:
    begin
      ExportarBalancaToledo(lblProgresso,memProgresso,diretorio);
    end;
    balFilizola:
    begin
      ExportarBalancaFilizola(lblProgresso,memProgresso,diretorio);
    end;
    balUPX:
    begin
      ExportarBalancaUpx(lblProgresso,memProgresso,diretorio);
    end;
    balItensMGV:
    begin
      ExportarBalancaItensMGV(lblProgresso,memProgresso,diretorio);
    end;

  end;


end;



function TdmProduto.ImprimirEtiqueta(ds: TDatasource;layout:string): Boolean;
begin
if layout = '' then
begin
ShowMessage('Layout não selecionado !');
end
else
begin
qrGridEtiqueta.Close;
qrGridEtiqueta.Open;
  if VariaveisSrv.oConfiguracoes.Etiqueta.VisualizarImpressao then
  begin
    dbGridEtiqueta.DataSet := qrGridEtiqueta;
    frxEtiqueta.LoadFromFile('\System_RK\server\Etiquetas\'+layout);
    frxEtiqueta.PrintOptions.ShowDialog:= True;
    frxEtiqueta.PrepareReport;
    frxEtiqueta.ShowReport;
  end
  else
  begin
    frxEtiqueta.PrintOptions.Printer := VariaveisSrv.oConfiguracoes.Etiqueta.Impressora;
    frxEtiqueta.LoadFromFile('\System_RK\server\Etiquetas\'+layout);
    frxEtiqueta.PrintOptions.ShowDialog:= False;
    frxEtiqueta.PrepareReport;
    frxEtiqueta.Print;
  end;

end;

end;

function TdmProduto.InserirEtiqueta(oProduto: Produto.TProduto): boolean;
begin
with qrEtiquetaInserir do
begin
  Params.ParamByName('CODIGO').AsString := oProduto.Codigo;
  Params.ParamByName('CODIGO_BARRAS').AsString := removeZeroEsquerda(oProduto.CodigoBarras);
  Params.ParamByName('PRODUTO').AsString := oProduto.Descricao;
  Params.ParamByName('UNIDADE').AsString := oProduto.Unidade;
  Params.ParamByName('PRECO').AsFloat := oProduto.Preco;
if not Trim(oProduto.Validade).IsEmpty then
begin
  Params.ParamByName('VALIDADE').AsInteger := StrToInt(oProduto.Validade)
end
else
begin
  Params.ParamByName('VALIDADE').Clear;
end;
  ExecSQL;
end;
end;

function TdmProduto.InserirEtiquetaCodigoAuxiliar(oProduto: Classe.Produto.TProduto): boolean;
begin
 with qrEtiquetaInserir,oProduto do
begin
  Params.ParamByName('CODIGO').AsString := Codigo;
  Params.ParamByName('CODIGO_BARRAS').AsString := removeZeroEsquerda(oProduto.CodigoAuxiliar.codigo_auxiliar);
  Params.ParamByName('PRODUTO').AsString := Descricao;
  Params.ParamByName('UNIDADE').AsString := Unidade;
  Params.ParamByName('PRECO').AsFloat := Preco;
if not Trim(Validade).IsEmpty then
begin
  Params.ParamByName('VALIDADE').AsInteger := StrToInt(Validade)
end
else
begin
  Params.ParamByName('VALIDADE').Clear;
end;
  ExecSQL;
end;
end;

function TdmProduto.InserirProduto(oProduto: Classe.Produto.TProduto): Boolean;
begin
    with qrProdutoInserir, oProduto do begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('CODIGO_BARRAS').AsString := CodigoBarras;
     Params.ParamByName('DESCRICAO').AsString := Descricao;
     Params.ParamByName('GRUPO').AsString := Grupo;
     Params.ParamByName('SUBGRUPO').AsString := Subgrupo;
     Params.ParamByName('FORNECEDOR').AsString := Fornecedor;
     Params.ParamByName('Tributacao').AsString := Tributacao;
     Params.ParamByName('NCM').AsString := NCM;
     Params.ParamByName('CEST').AsString := CEST;
     Params.ParamByName('Validade').AsString := Validade;//
     Params.ParamByName('BALANCA').AsInteger := getBalanca;
     Params.ParamByName('Fracionado').AsInteger := getFracionado;
     Params.ParamByName('INATIVO').AsInteger := getInativo;
     Params.ParamByName('DIVERSOS').AsInteger := getDiversos;
     Params.ParamByName('CUSTO').AsFloat := Custo;
     Params.ParamByName('PRECO').AsFloat := Preco;
     Params.ParamByName('MARGEM').AsFloat := Margem;
     Params.ParamByName('ESTOQUE').AsFloat := Estoque;
     Params.ParamByName('Unidade').AsString := Unidade;
     Params.ParamByName('DATA_ALTERADO').asDate := date;
     Params.ParamByName('DATA_CADASTRO').asDate := date;
     Params.ParamByName('PENDENTE').AsInteger := 1;
     Params.ParamByName('ESTOQUE_MINIMO').AsFloat := estoqueMinimo;
     Params.ParamByName('ESTOQUE_MAXIMO').AsFloat := estoqueMaximo;
     Params.ParamByName('OBSERVACAO').AsString := observacao;

     try
       ExecSQL();
       Result := True;
     except
       on E : Exception do
       begin
        raise Exception.Create(E.Message);
        Result := false;
       end;

     end;


    end;
end;

function TdmProduto.LimparGridEtiqueta(ds: TDataSource): Boolean;
begin
qrGridEtiqueta.Close;
qrGridEtiqueta.sql.Clear;
qrGridEtiqueta.sql.Add('delete from etiqueta');
qrGridEtiqueta.execsql;

qrGridEtiqueta.SQL.Clear;

qrGridEtiqueta.Close;
qrGridEtiqueta.SQL.Clear;

qrGridEtiqueta.SQL.Add('select * from etiqueta');
//qrGridEtiqueta.SQL.Add(
//  'select ' +
//  '  id, ' +
//  '  produto.codigo, ' +
//  '  produto, ' +
//  '  etiqueta.codigo_barras, ' +
//  '  produto.unidade, ' +
//  '  produto.preco, ' +
//  '  produto.validade, ' +
//  '  produto.observacao, ' +
//  '  produto.preco2, ' +
//  '  produto.preco2_qtd, ' +
//  '  produto.preco3, ' +
//  '  produto.preco3_qtd, ' +
//  '  0 as ID_1, ' +
//  '  '''' as CODIGO_PRODUTO, ' +
//  '  '''' as LOCALIZACAO, ' +
//  '  0.01 as QUANTIDADE, ' +
//  '  current_date as VALIDADE_1, ' +
//  '  0 as SITUACAO, ' +
//  '  0 as DIAS_VENCER, ' +
//  '  current_date as DATA_ENTRADA, ' +
//  '  0 as SELECIONADO, ' +
//  '  0 as PROXIMO_VENCIMENTO, ' +
//  '  '''' as LOTE ' +
//  'from etiqueta ' +
//  'left join produto on etiqueta.codigo = produto.codigo'
//);

qrGridEtiqueta.Open;
ds.DataSet := qrGridEtiqueta;

end;

function TdmProduto.PreencherGrid(sProduto:string;ds: TDataSource;tipo:TPesquisar): Boolean;
var
  i:integer;
begin
with qrGridProduto do
begin
  ds.DataSet := qrGridProduto;
  sProduto := StringReplace(sProduto,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM PRODUTO');

   if sProduto = EmptyStr then
   begin
      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE DESCRICAO LIKE '+Chr(39)+'%'+sProduto+'%'+Chr(39));
      SQL.Add('ORDER BY DESCRICAO');

    end
    else
    if tipo = Codigo then
    begin
      sProduto := zeroEsquerda(sProduto,14);
      SQL.Add('WHERE CODIGO_BARRAS = :CODIGO_BARRAS');
      ParamByName('CODIGO_BARRAS').AsString := sProduto;
      SQL.Add('ORDER BY CODIGO_BARRAS');
    end;

   end;

Open;

end;
end;

function TdmProduto.PreencherGridAlterados(oRelatorio: TRelatorio): Boolean;
begin
with qrProdutoPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM PRODUTO WHERE DATA_ALTERADO >=:DTINICIO AND DATA_ALTERADO <=:DTFIM');
  ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
  ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;
  if oRelatorio.filtro1 <> 'TODOS' then
  begin
    sql.Add(' AND UNIDADE =:UNIDADE');
    ParamByName('UNIDADE').AsString := oRelatorio.filtro1;
  end;
  Open;
  while not qrProdutoPesq.Eof do
  begin
  qrEtiquetaInserir.Params.ParamByName('CODIGO').AsString := FieldByName('CODIGO').AsString;
  qrEtiquetaInserir.Params.ParamByName('CODIGO_BARRAS').AsString := FieldByName('CODIGO_BARRAS').AsString;
  qrEtiquetaInserir.Params.ParamByName('PRODUTO').AsString := FieldByName('DESCRICAO').AsString;
  qrEtiquetaInserir.Params.ParamByName('UNIDADE').AsString := FieldByName('UNIDADE').AsString;
  qrEtiquetaInserir.Params.ParamByName('PRECO').AsFloat := FieldByName('PRECO').AsFloat;
  qrEtiquetaInserir.ExecSQL;

  qrProdutoPesq.Next;
  end;
end;
end;

function TdmProduto.PreencherGridEtiqueta(ds:TDataSource;imprimirLote:boolean): boolean;
begin
with qrGridEtiqueta do
begin
  Close;
  Open;

if imprimirLote then
begin
  qrGridEtiqueta.Close;
  qrGridEtiqueta.SQL.Clear;
  qrGridEtiqueta.SQL.Add('select * from etiqueta');

//  qrGridEtiqueta.SQL.Add(
//    'select ' +
//    '  etiqueta.id, ' +
//    '  etiqueta.codigo, ' +
//    '  etiqueta.codigo_barras, ' +
//    '  etiqueta.produto, ' +
//    '  etiqueta.unidade, ' +
//    '  etiqueta.preco, ' +
//    '  cast(etiqueta.validade as varchar(3)) as VALIDADE, ' +
//    '  validade.ID, ' +
//    '  validade.CODIGO_PRODUTO, ' +
//    '  validade.localizacao, ' +
//    '  validade.quantidade, ' +
//    '  validade.validade as VALIDADE_1, ' +
//    '  validade.situacao, ' +
//    '  validade.dias_vencer, ' +
//    '  validade.data_entrada, ' +
//    '  validade.selecionado, ' +
//    '  validade.proximo_vencimento, ' +
//    '  validade.lote, ' +
//    '  produto.observacao ' +
//    'from etiqueta ' +
//    'join validade on etiqueta.codigo = validade.codigo_produto ' +
//    'left join produto on etiqueta.codigo = produto.codigo'
//  );

  qrGridEtiqueta.Open;
end
else
begin
  qrGridEtiqueta.Close;
  qrGridEtiqueta.SQL.Clear;
  qrGridEtiqueta.SQL.Add('SELECT * FROM ETIQUETA');

//  qrGridEtiqueta.SQL.Add(
//    'select ' +
//    '  id, ' +
//    '  produto.codigo, ' +
//    '  produto, ' +
//    '  etiqueta.codigo_barras, ' +
//    '  produto.unidade, ' +
//    '  produto.preco, ' +
//    '  produto.validade, ' +
//    '  produto.observacao, ' +
//    '  produto.preco2, ' +
//    '  produto.preco2_qtd, ' +
//    '  produto.preco3, ' +
//    '  produto.preco3_qtd, ' +
//    '  0 as ID_1, ' +
//    '  '''' as CODIGO_PRODUTO, ' +
//    '  '''' as LOCALIZACAO, ' +
//    '  0.01 as QUANTIDADE, ' +
//    '  current_date as VALIDADE_1, ' +
//    '  0 as SITUACAO, ' +
//    '  0 as DIAS_VENCER, ' +
//    '  current_date as DATA_ENTRADA, ' +
//    '  0 as SELECIONADO, ' +
//    '  0 as PROXIMO_VENCIMENTO, ' +
//    '  '''' as LOTE ' +
//    'from etiqueta ' +
//    'left join produto on etiqueta.codigo = produto.codigo'
//  );

  qrGridEtiqueta.Open;
end;




  ds.DataSet := qrGridEtiqueta;
end;
end;

function TdmProduto.serializarTexto(const texto: string;
  tamanhoTotal: integer): string;
begin
  if Length(Texto) > TamanhoTotal then
    Result := Copy(Texto, 1, TamanhoTotal)  // Corta o texto
  else
    Result := Texto + StringOfChar(' ', TamanhoTotal - Length(Texto));  // Preenche com espaços
end;

function TdmProduto.serializarZeroEsquerda(const texto: string;
  tamanhoTotal: integer): string;
begin
  if Length(Texto) > TamanhoTotal then
    Result := Copy(Texto, 1, TamanhoTotal)  // Corta o texto
  else
    Result := StringOfChar('0', TamanhoTotal - Length(Texto)) + Texto;  // Preenche com zeros à esquerda
end;

function TdmProduto.VerificaCodigoBarras(oProduto: Classe.Produto.TProduto): Boolean;
begin
with qrProdutoPesq do
begin

  try
    close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PRODUTO WHERE CODIGO_BARRAS = :CODIGO_BARRAS');
    ParamByName('CODIGO_BARRAS').AsString := oProduto.CodigoBarras;
    Open;

    if qrProdutoPesq.RecordCount > 0 then
    begin
      Result := True;
    end
    else
    begin
      Result := false;
    end;

  except
    Result := true;
  end;


end;
end;

end.
