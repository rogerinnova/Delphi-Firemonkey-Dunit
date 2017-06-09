program VCLToFireMonkeyFormConvtr;
{You need to add either WinHelpViewer or HTMLHelpViewer to the uses
clause in your project somewhere so that it gets linked in.
}


uses
  FMX.Forms,
  DFMToFMXFM in 'DFMToFMXFM.pas' {DFMtoFMXConvert},
  CvtrObj in 'CvtrObj.pas',
  PatchLib in 'PatchLib.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.HelpFile := 'HlpFile';
  Application.CreateForm(TDFMtoFMXConvert, DFMtoFMXConvert);
  Application.Run;
end.
