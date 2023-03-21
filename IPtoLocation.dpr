program IPtoLocation;

uses
  System.StartUpCopy,
  FMX.Forms,
  IPtoLocation.MainUnit in 'IPtoLocation.MainUnit.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
