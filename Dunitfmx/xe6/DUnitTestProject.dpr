program DUnitTestProject;

uses
  FMX.Forms,
  FMXListBoxLib in '..\FMXListBoxLib.pas',
  TestDUnit in '..\TestDUnit.pas',
  FMXTreeViewLib in '..\FMXTreeViewLib.pas',
  GUITestRunnerFMXMobile in '..\XE6Form\GUITestRunnerFMXMobile.pas' {MobileGUITestRunner};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMobileGUITestRunner, MobileGUITestRunner);
  Application.Run;
end.
