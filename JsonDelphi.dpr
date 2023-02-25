program JsonDelphi;

uses
  System.StartUpCopy,
  FMX.Forms,
  uJsonDelphi in 'uJsonDelphi.pas' {frmJSONDelphi};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmJSONDelphi, frmJSONDelphi);
  Application.Run;
end.
