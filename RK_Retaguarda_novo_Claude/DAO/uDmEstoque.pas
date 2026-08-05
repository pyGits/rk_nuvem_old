unit uDmEstoque;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni;

type
  TdmEstoque = class(TDataModule)
    qrAtualizarEstoque: TUniQuery;
  private
    { Private declarations }
  public
      function atualizarSaldo(qtdAnterior,qtdAtual:Real;codProduto:string):Boolean;
  end;

var
  dmEstoque: TdmEstoque;

implementation
uses Classe.Variaveis;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TdmEstoque.atualizarSaldo(qtdAnterior, qtdAtual: Real;codProduto:string): Boolean;
var
  qtdInserir:real;
begin
  qtdInserir := qtdAtual - qtdAnterior;
  if qtdInserir <> 0 then
  begin
    with qrAtualizarEstoque do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO ESTOQUE_MOVIMENTACAO (QTDE,CODPRODUTO,DATA,HORA,COD_FUNCIONARIO,ORIGEM) VALUES(:QTDE,:CODPRODUTO,:DATA,:HORA,:COD_FUNCIONARIO,:ORIGEM) ');
      ParamByName('QTDE').AsFloat := qtdInserir;
      ParamByName('CODPRODUTO').asstring := codproduto;
      ParamByName('DATA').AsDate := Now;
      ParamByName('HORA').AsDateTime := Now;
      ParamByName('COD_FUNCIONARIO').AsString := VariaveisSrv.oFuncionario.Codigo;
      ParamByName('ORIGEM').AsString := 'RETAGUARDA';



      ExecSQL;
    end;

  end;

end;

end.
