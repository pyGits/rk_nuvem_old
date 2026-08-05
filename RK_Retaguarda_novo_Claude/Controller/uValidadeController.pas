unit uValidadeController;

interface

uses uDmValidade,System.SysUtils,Data.DB,Classe.Validade,Classe.Relatorio,VCL.dbgrids;

type
  TValidadeController = class
    private
    public
    constructor create;
    destructor destroy;override;
    function carregarGridValidade(ds:TDataSource):Boolean;overload;
    function carregarGridValidade(ds:TDataSource;codigoProduto:string):Boolean;overload;
    function carregarGridValidade(ds:TDataSource;codigoProduto:string;oRelatorio:TRelatorio):Boolean;overload;
    function ordenarGrid(coluna:TColumn):Boolean;

    function carregarValidade(id:integer):TValidade;
    function inserirValidade(oValidade:TValidade):boolean;
    function atualizarValidade(oValidade:TValidade):Boolean;
    function deletarValidade(id:integer):boolean;
    function conferirValidade(oValidade:TValidade):boolean;
  end;

implementation

{ TValidadeController }

function TValidadeController.carregarGridValidade(ds: TDataSource): Boolean;
begin
result := dmValidade.carregarGridValidade(ds);
end;

function TValidadeController.atualizarValidade(oValidade: TValidade): Boolean;
begin
result := dmValidade.atualizarValidade(oValidade);
end;

function TValidadeController.carregarGridValidade(ds: TDataSource;
  codigoProduto: string;oRelatorio:TRelatorio): Boolean;
begin
result := dmValidade.carregarGridValidade(ds,codigoProduto,oRelatorio);
end;

function TValidadeController.carregarValidade(id: integer): TValidade;
begin
result := dmValidade.carregarValidade(id);
end;

function TValidadeController.carregarGridValidade(ds: TDataSource;
  codigoProduto: string): Boolean;
begin
result := dmValidade.carregarGridValidade(ds,codigoProduto);
end;

function TValidadeController.conferirValidade(oValidade: TValidade): boolean;
begin
result := dmValidade.conferirValidade(oValidade);
end;

constructor TValidadeController.create;
begin
  dmValidade := TdmValidade.Create(nil);
end;

function TValidadeController.deletarValidade(id: integer): boolean;
begin
result := dmValidade.deletarValidade(id);
end;

destructor TValidadeController.destroy;
begin
  freeandnil(dmValidade);
  inherited;
end;

function TValidadeController.inserirValidade(oValidade: TValidade): boolean;
begin
result := dmValidade.inserirValidade(oValidade);
end;

function TValidadeController.ordenarGrid(coluna: TColumn): Boolean;
begin
result := dmValidade.ordenarGrid(coluna);
end;

end.
