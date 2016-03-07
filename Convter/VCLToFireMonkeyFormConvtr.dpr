program VCLToFireMonkeyFormConvtr;
{You need to add either WinHelpViewer or HTMLHelpViewer to the uses
clause in your project somewhere so that it gets linked in.
}


uses
  FMX.Forms,
  DFMToFMXFM in 'DFMToFMXFM.pas' {DFMtoFMXConvert},
  IsArrayLib in '..\..\..\Delphi 3_5 Source Code\LibraryV3\IsArrayLib.pas',
  ISStrUtl in '..\..\..\Delphi 3_5 Source Code\LibraryV3\ISStrUtl.pas',
  CvtrObj in 'CvtrObj.pas',
  IsUnicodeStrUtl in '..\..\..\Delphi 3_5 Source Code\LibraryV3\IsUnicodeStrUtl.pas',
  IsProcCl in '..\..\..\Delphi 3_5 Source Code\LibraryV3\IsProcCl.pas',
  aaaaaDelphiProjectUsefulStuff in '..\..\..\Delphi 3_5 Source Code\LibraryV3\aaaaaDelphiProjectUsefulStuff.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.HelpFile := 'HlpFile';
  Application.CreateForm(TDFMtoFMXConvert, DFMtoFMXConvert);
  Application.Run;
end.
