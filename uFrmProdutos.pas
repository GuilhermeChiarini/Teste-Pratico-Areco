{####################################################################################}
{                                                                                    }
{       DATA  AUTOR              Descrição                                           }
{-----------  ------------------ ----------------------------------------------------}
{ 22/06/2017  guilherme.chiarini Criação de arquivo                                  }
{####################################################################################}

unit uFrmProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls,
  cxControls, Vcl.DBCtrls, Vcl.Mask, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataModule, ucadUnidade, cxStyles,
  cxEdit, cxNavigator, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, uobjProdutos, dxBarBuiltInMenu, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData, cxPC, Global;

type
  TfrmCadProdutos = class(TForm)
    pnl3: TPanel;
    pnl4: TPanel;
    pnl25: TPanel;
    pnl26: TPanel;
    pnl27: TPanel;
    btnNovo: TcxButton;
    btnSalvar: TcxButton;
    btnCancelar: TcxButton;
    btnAlterar: TcxButton;
    btnExcluir: TcxButton;
    btnAnterior: TcxButton;
    btnProximo: TcxButton;
    btnSair: TcxButton;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    lblCodigo: TLabel;
    edtCodigo: TDBEdit;
    edtDescricao: TDBEdit;
    lblDescricao: TLabel;
    cboUnidade: TDBLookupComboBox;
    lblUnidade: TLabel;
    btnunidade: TcxButton;
    edtValor: TDBEdit;
    lbl1: TLabel;
    qryProdutos: TFDQuery;
    dsProdutos: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qryProdutoschave: TIntegerField;
    qryProdutostdescricao: TWideStringField;
    qryProdutosnchunidade: TIntegerField;
    qryProdutosnvalor: TFloatField;
    qryProdutoslativo: TWideStringField;
    qryUnidade: TFDQuery;
    qryUnidadechave: TIntegerField;
    qryUnidadetdescricao: TWideStringField;
    dsUnidade: TDataSource;
    cxGrid7: TcxGrid;
    cxGridDBTableView6: TcxGridDBTableView;
    grdGridDBTableView6Column1: TcxGridDBColumn;
    grdGridDBTableView6Column2: TcxGridDBColumn;
    grdGridDBTableView6Column3: TcxGridDBColumn;
    cxGridLevel6: TcxGridLevel;
    chklativo: TDBCheckBox;
    qryProdutosclcAtivo: TStringField;
    grdGridDBTableView6Column4: TcxGridDBColumn;
    procedure btnAlterarClick(Sender: TObject);
    procedure controle;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnunidadeClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qryProdutosCalcFields(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadProdutos: TfrmCadProdutos;

implementation

{$R *.dfm}

procedure TfrmCadProdutos.btnAlterarClick(Sender: TObject);
begin
  qryProdutos.Edit;
  Controle;
end;

procedure TfrmCadProdutos.btnAnteriorClick(Sender: TObject);
begin
  qryProdutos.Prior;
end;

procedure TfrmCadProdutos.btnCancelarClick(Sender: TObject);
begin
  qryProdutos.cancel;
  controle;
end;

procedure TfrmCadProdutos.btnExcluirClick(Sender: TObject);
var produto: uobjProdutos.TProduto;
begin
  Controle;
  if Global.alerta('Deseja realmente excluir o produto?') then
  begin
    produto := Tproduto.Create(Self);
    try
      produto.chave := qryProdutos.FieldByName('chave').AsInteger;
      produto.ExcluirProduto;
    finally
      FreeAndNil(produto);
    end;

    qryProdutos.Close;
    qryProdutos.Open;
  end;
end;

procedure TfrmCadProdutos.btnNovoClick(Sender: TObject);
begin
  qryProdutos.Close;
  qryProdutos.Open;
  qryUnidade.open;
  qryProdutos.Append;
  Controle;

  FocusControl(edtDescricao);
end;

procedure TfrmCadProdutos.btnProximoClick(Sender: TObject);
begin
  qryProdutos.next;
end;

procedure TfrmCadProdutos.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadProdutos.btnSalvarClick(Sender: TObject);
var produto: uobjProdutos.Tproduto;
begin
  if (qryProdutos.State in [dsInsert , dsEdit]) then
  begin
    if Trim(edtDescricao.Text) = EmptyStr then
    begin
      Global.aviso('Insira a descrição do produto.');
      edtDescricao.Color := $006F6FFD;
      FocusControl(edtDescricao);
      Abort;
    end;

    if cboUnidade.KeyValue = Null then
    begin
      Global.aviso('Insira a unidade de medida.');
      FocusControl(cboUnidade);
      Abort;
    end;

    produto := Tproduto.Create(Self);
    try
      if edtCodigo.Text = EmptyStr then
      begin
        produto.Descricao := edtDescricao.Text;
        produto.unidade := cboUnidade.KeyValue;

        if edtValor.Text = EmptyStr then
        begin
          produto.Valor := 0;
        end
        else
        begin
          produto.Valor := StrToFloat(edtValor.Text);
        end;

        if chklativo.Checked then
        begin
          produto.Ativo := 'T';
        end
        else
        begin
          produto.Ativo := 'F';
        end;

        produto.GravarProduto;
      end
      else
      begin
        produto.chave := qryProdutos.FieldByName('chave').AsInteger;
        produto.Descricao := edtDescricao.Text;
        produto.unidade := cboUnidade.KeyValue;
        produto.Valor := StrToFloat(edtValor.Text);

        if chklativo.Checked then
        begin
          produto.Ativo := 'T';
        end
        else
        begin
          produto.Ativo := 'F';
        end;

        produto.AlterarProduto;
      end;
    finally
      FreeAndNil(produto);
    end;

    qryprodutos.close;
    qryprodutos.open;
  end;
  Controle;
end;

procedure TfrmCadProdutos.btnunidadeClick(Sender: TObject);
var unidade: TfrmUnidade;
begin
  unidade := TfrmUnidade.Create(self);
  try
    unidade.ShowModal;

    qryUnidade.Close;
    qryUnidade.Open;
  finally
    FreeAndNil(unidade);
  end;
end;

procedure TfrmCadProdutos.controle;
begin
  if (qryProdutos.State in [dsInsert, dsEdit]) then
  begin
    btnSalvar.Enabled := True;
    btnCancelar.Enabled := True;
    btnNovo.Enabled := False;
    btnAlterar.Enabled := False;
    btnExcluir.Enabled := False;
    btnProximo.Enabled := False;
    btnAnterior.Enabled := False;
    chklativo.ReadOnly := false;
    cboUnidade.Enabled := true;
    edtDescricao.ReadOnly := false;
    edtValor.ReadOnly := False;
  end
  else
  begin
    btnSalvar.Enabled := False;
    btnCancelar.Enabled := False;
    btnNovo.Enabled := true;
    btnAlterar.Enabled := True;
    btnExcluir.Enabled := True;
    btnProximo.Enabled := True;
    btnAnterior.Enabled := True;
    chklativo.ReadOnly := True;
    cboUnidade.Enabled := False;
    edtDescricao.ReadOnly := True;
    edtValor.ReadOnly := true;
  end;
end;

procedure TfrmCadProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qryProdutos.close;
  qryUnidade.close;
end;

procedure TfrmCadProdutos.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    close;
  end;
end;

procedure TfrmCadProdutos.FormShow(Sender: TObject);
begin
  qryProdutos.Open;
  qryUnidade.open;
  controle;
end;

procedure TfrmCadProdutos.qryProdutosCalcFields(DataSet: TDataSet);
begin
  if qryProdutoslativo.AsBoolean then
  begin
    qryProdutosclcAtivo.AsString := 'Ativo';
  end
  else
  begin
    qryProdutosclcAtivo.AsString := 'Inativo';
  end;
end;

end.
