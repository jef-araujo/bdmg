unit uLogger;

interface

type
  TLogger = class
  private
    class function DataHoraAtual: string; static;
  public
    class procedure LogarEmTela(AMensagem: string);
  end;

implementation

uses
  System.SysUtils;

{ TLogger }

class function TLogger.DataHoraAtual: string;
begin
  result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
end;

class procedure TLogger.LogarEmTela(AMensagem: string);
begin
  Writeln(Format('[%s] %s', [DataHoraAtual, AMensagem]));
end;

end.
