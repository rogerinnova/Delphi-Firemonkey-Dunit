program ImageListTestProj;

uses
  FMX.Forms,
  ImageListTestForm in '..\ImageListTestForm.pas' {Form5},
  CustomTreeFrm in '..\..\..\Sample Code\Delphi Samples\CustomTreeFrm.pas' {CustomTreeViewFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  //Application.RegisterFormFamily('TForm', [TCustomTreeViewFrm]);
  Application.Run;
end.
