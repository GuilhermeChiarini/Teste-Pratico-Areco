{####################################################################################}
{                                                                                    }
{       DATA  AUTOR              Descrição                                           }
{-----------  ------------------ ----------------------------------------------------}
{ 22/06/2017  guilherme.chiarini Criação de arquivo                                  }
{####################################################################################}

unit Global;

interface

uses sysutils, StrUtils, Data.SqlExpr, uDataModule, winapi.windows, IdCoder, IdCoder3to4, IdCoderMIME,
     Winapi.Messages, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
     FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, dateutils,
     FireDAC.Comp.Client, Vcl.Forms;

function verificar_gen(Sequence: string): integer;

function aviso(AMensagem:string): string;
function alerta(AMensagem:string): Boolean;
function abortar(AMensagem: string): string;

implementation

function verificar_gen(Sequence: string): integer;
  var qrySequence : TFDQuery;
begin
  Result := 0;
  qrySequence := TFDQuery.Create(nil);
  try
    qrySequence.Connection := DM.CONEXAO;
    qrySequence.Close;

    qrySequence.SQL.Clear;
    qrySequence.SQL.Add('select max(chave) nextval from '+Sequence);
    qrySequence.Open;

    Result := qrySequence.FieldByName('nextval').AsInteger + 1;
  finally
    qrySequence.Free;
  end;
end;

function aviso(AMensagem: string): string;
begin
  Result := '';

  Application.MessageBox(PChar(AMensagem), PChar('Aviso'), MB_OK +  MB_ICONINFORMATION);

  Result := 'msg';
end;

function alerta(AMensagem: string): Boolean;
begin
  Result := False;

  if Application.MessageBox(PChar(AMensagem), PChar('Alerta'), MB_YESNO + MB_ICONWARNING) = IDYES then
  begin
    Result := True;
  end;
end;

function abortar(AMensagem: string): string;
begin
  Result := '';

  Application.MessageBox(PChar(AMensagem), PChar('Erro'), MB_OK + MB_ICONSTOP);

  Result := 'msg';
end;

End.
