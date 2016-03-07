program SampleProject;

uses
  FMX.Forms,
  ImageListTestForm in '..\..\FMXImageIist Components Old\ImageListTestForm.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
