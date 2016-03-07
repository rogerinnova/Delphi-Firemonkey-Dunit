program TryDUnitTestApp;
 Firemonkey Cannot Support Modal Form so Create Form normally
 Also  DUnitTestXE5;

uses
  FMX.Forms,
  TestFrameWork,
  TestDUnit in '..\TestDUnit.pas',
  FMXListBoxLib in '..\FMXListBoxLib.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunnerFMX.RunRegisteredTests;
end.
