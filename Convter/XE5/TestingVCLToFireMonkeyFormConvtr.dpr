program TestingVCLToFireMonkeyFormConvtr;
{You need to add either WinHelpViewer or HTMLHelpViewer to the uses
clause in your project somewhere so that it gets linked in.
}


uses
  DFMToFMXFM in '..\DFMToFMXFM.pas' {DFMtoFMXConvert},
  IsArrayLib in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\IsArrayLib.pas',
  CvtrObj in '..\CvtrObj.pas',
  IsUnicodeStrUtl in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\IsUnicodeStrUtl.pas',
  IsProcCl in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\IsProcCl.pas',
  ISDlgUsrPwdFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\ISDlgUsrPwdFMX.pas' {GetUserPasswordDlg},
  TestFporm in '..\TestFporm.pas' {testCnvterFM},
  ISDlgDataEntryFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\ISDlgDataEntryFMX.pas' {DlgtVerifiyData},
  FmIsGeneralReportFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\FmIsGeneralReportFMX.pas' {FormISGeneralReport},
  ISDlgAboutFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\ISDlgAboutFMX.pas' {AboutInnovaSolutions},
  ISFormUtilFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\ISFormUtilFMX.pas',
  ISFMXStringGridUtils in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISFMXStringGridUtils.pas',
  ISDlgFindFromDbIndexFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FMXLib\ISDlgFindFromDbIndexFMX.pas' {DlgDbIdxSelectForm},
  ISDbGeneralObj in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISDbGeneralObj.pas',
  ISMultiUserRemoteDb in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISMultiUserRemoteDb.pas',
  IsMultiUserPermObjFileStm in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\IsMultiUserPermObjFileStm.pas',
  ISStrUtl in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISStrUtl.pas',
  ISPermObjFileStm in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISPermObjFileStm.pas',
  IsSecurity in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\IsSecurity.pas',
  FMX.Grid in 'c:\program files\embarcadero\rad studio\9.0\source\fmx\FMX.Grid.pas',
  IsDlgUsrPwdVerifyFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\IsDlgUsrPwdVerifyFMX.pas' {UserPasswordVerifyDlg},
  ISDlgAuthorizeEditFMX in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\FmxLib\ISDlgAuthorizeEditFMX.pas' {SoftwareLicenceDlg},
  ISGeneralBaseForm in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISGeneralBaseForm.pas',
  ISLibFmxFrmwrk in '..\..\..\..\Delphi 3_5 Source Code\LibraryV3\ISLibFmxFrmwrk.pas',
  TestDialog in '..\TestDialog.pas' {DlgTestFMXLib},
  FMX.Controls in 'c:\program files\embarcadero\rad studio\9.0\source\fmx\FMX.Controls.pas',
  FMX.Types in 'c:\program files\embarcadero\rad studio\9.0\source\fmx\FMX.Types.pas',
  FMX.Layers3D in 'C:\Program Files\Embarcadero\RAD Studio\9.0\source\fmx\FMX.Layers3D.pas',
  FMX.Forms in 'c:\program files\embarcadero\rad studio\9.0\source\fmx\FMX.Forms.pas',
  FMX.Objects in 'c:\program files\embarcadero\rad studio\9.0\source\fmx\FMX.Objects.pas',
  IsBitButton in '..\..\Components\PackageFile\IsBitButton.pas',
  IsAdvStringGrid in '..\..\Components\PackageFile\IsAdvStringGrid.pas',
  System.Classes in 'c:\program files\embarcadero\rad studio\9.0\source\rtl\common\System.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.HelpFile := 'HlpFile';
  Application.CreateForm(TtestCnvterFM, testCnvterFM);
  Application.Run;
end.
