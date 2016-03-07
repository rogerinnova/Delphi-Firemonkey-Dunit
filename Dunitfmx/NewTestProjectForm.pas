unit NewTestProjectForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Menus, FMX.ListView.Types, FMX.ListView;

type
  TStarterForm = class(TForm)
    BTNRUNTESTS: TButton;
    procedure BTNRUNTESTSClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StarterForm: TStarterForm;

implementation

{$R *.fmx}

uses GUITestRunnerFMX;//,GUITestRunnerFMXPlay;

procedure TStarterForm.BTNRUNTESTSClick(Sender: TObject);
begin
  GUITestRunnerFMX.RunRegisteredTests;
  //GUITestRunnerFMXPlay.RunRegisteredTests;
end;

end.
