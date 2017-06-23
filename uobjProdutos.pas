{####################################################################################}
{                                                                                    }
{       DATA  AUTOR              Descrição                                           }
{-----------  ------------------ ----------------------------------------------------}
{ 22/06/2017  guilherme.chiarini Criação de arquivo                                  }
{####################################################################################}

unit uobjProdutos;

interface

uses System.Classes, FireDAC.Comp.Client, uDataModule, system.SysUtils, Global;

type
  TProduto = class

  private
    FID: integer;
    FDescricao: string;
    FChUnidade: Integer;
    FValor: Extended;
    FAtivo: string;

  public

    constructor Create(AOwner: TComponent);

    function GravarProduto: Boolean;
    function AlterarProduto: Boolean;
    function ExcluirProduto: Boolean;
    function Pesquisar(AChProduto: integer): TProduto;

    property chave:       integer   read FID        write FID;
    property Descricao:   string    read FDescricao write FDescricao;
    property unidade:     integer   read FChUnidade write FChUnidade;
    property Valor:       Extended  read FValor     write FValor;
    property Ativo:       string    read FAtivo     write FAtivo;

  published

  end;

implementation

{ TProduto }

function TProduto.AlterarProduto: Boolean;
var queryProduto: TFDQuery;
begin
  queryProduto := TFDQuery.Create(nil);
  try
    queryProduto.Connection := DM.CONEXAO;
    queryProduto.Close;

    queryProduto.SQL.Clear;
    queryProduto.SQL.Add('update cad_produto ' );
    queryProduto.SQL.Add('   set tdescricao = :descricao, ');
    queryProduto.SQL.Add('       nchunidade = :unidade,   ');
    queryProduto.SQL.Add('       nvalor = :valor,         ');
    queryProduto.SQL.Add('       lativo = :ativo          ');
    queryProduto.SQL.Add(' where chave = :id              ');


    queryProduto.ParamByName('id').AsInteger := chave;
    queryProduto.ParamByName('descricao').AsString := Descricao;
    queryProduto.ParamByName('unidade').AsInteger := unidade;
    queryProduto.ParamByName('valor').AsFloat := Valor;
    queryProduto.ParamByName('ativo').AsString := Ativo;

    try
      queryProduto.ExecSQL;
      AlterarProduto := True;
    except
      AlterarProduto := False;
    end;
  finally
    FreeAndNil(queryProduto);
  end;
end;

constructor TProduto.Create(AOwner: TComponent);
begin
//
end;

function TProduto.ExcluirProduto: Boolean;
var queryProduto: TFDQuery;
begin
  queryProduto := TFDQuery.Create(nil);
  try
    queryProduto.Connection := DM.CONEXAO;
    queryProduto.Close;

    queryProduto.SQL.Clear;
    queryProduto.SQL.Add('delete from cad_produto ');
    queryProduto.SQL.Add('      where chave = :id');

    queryProduto.ParamByName('id').AsInteger := chave;

    try
      queryProduto.ExecSQL;
      ExcluirProduto := True;
    except
      ExcluirProduto := False;
    end;
  finally
    FreeAndNil(queryProduto);
  end;
end;

function TProduto.GravarProduto: Boolean;
var queryProduto: TFDQuery;
begin
  queryProduto := TFDQuery.Create(nil);
  try
    queryProduto.Connection := DM.CONEXAO;
    queryProduto.Close;

    queryProduto.SQL.Clear;
    queryProduto.SQL.Add('insert into cad_produto ' );
    queryProduto.SQL.Add('       (chave,          ' );
    queryProduto.SQL.Add('       tdescricao,      ' );
    queryProduto.SQL.Add('       nchunidade,      ' );
    queryProduto.SQL.Add('       nvalor,          ' );
    queryProduto.SQL.Add('       lativo)          ' );
    queryProduto.SQL.Add(' values(:chave,         ' );
    queryProduto.SQL.Add('        :descricao,     ' );
    queryProduto.SQL.Add('        :unidade,       ' );
    queryProduto.SQL.Add('        :valor,         ' );
    queryProduto.SQL.Add('        :ativo)         ' );

    queryProduto.ParamByName('chave').AsInteger := Global.verificar_gen('cad_produto');
    queryProduto.ParamByName('descricao').AsString := Descricao;
    queryProduto.ParamByName('unidade').AsInteger := unidade;
    queryProduto.ParamByName('valor').AsFloat := Valor;
    queryProduto.ParamByName('ativo').AsString := Ativo;

    try
      queryProduto.ExecSQL;
      GravarProduto := True;
    except
      GravarProduto := False;
    end;
  finally
    FreeAndNil(queryProduto);
  end;
end;

function TProduto.Pesquisar(AChProduto: integer): TProduto;
var queryPesquisar: TFDQuery;
begin
  queryPesquisar := TFDQuery.Create(nil);
  try
    queryPesquisar.Connection := DM.CONEXAO;
    queryPesquisar.Close;

    queryPesquisar.SQL.Clear;
    queryPesquisar.SQL.Add('select * from cad_produto WHERE chave = :id ');
    queryPesquisar.ParamByName('id').AsInteger := AChProduto;
    queryPesquisar.Open;

    if not queryPesquisar.IsEmpty then
    begin
      chave := queryPesquisar.FieldByName('chave').AsInteger;
      Descricao := queryPesquisar.FieldByName('tdescricao').AsString;
      unidade := queryPesquisar.FieldByName('nchunidade').AsInteger;
      Valor := queryPesquisar.FieldByName('nvalor').AsFloat;
      Ativo := queryPesquisar.FieldByName('lativo').AsString;
    end
    else
    begin
      chave := 0;
    end;
  finally
    FreeAndNil(queryPesquisar);
  end;
end;

end.
