unit DFMToFMXFM;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Win.Registry, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.Layouts, FMX.Memo,
  CvtrObj, FMX.StdCtrls;
type
  TDFMtoFMXConvert = class(TForm)
    OpenDialog1: TOpenDialog;
    BtnOpenFile: TButton;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    BtnProcess: TButton;
    BtnEditIniFile: TButton;
    BtnSaveIni: TButton;
    BtnSaveFMX: TButton;
    BtnHelp: TButton;
    StyleBook1: TStyleBook;
    procedure BtnOpenFileClick(Sender: TObject);
    procedure BtnProcessClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnEditIniFileClick(Sender: TObject);
    procedure BtnSaveIniClick(Sender: TObject);
    procedure BtnSaveFMXClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnHelpClick(Sender: TObject);
  private
    { Private declarations }
    DFMObj: TDfmToFmxObject;
    FIniFileName: AnsiString;
    FInPasFileName: AnsiString;
    FInDfmFileName: AnsiString;
    FOutPasFileName: AnsiString;
    FOutFmxFileName: AnsiString;
    function GetRegFile: TRegistryIniFile;
    Procedure RegIniLoad;
    Procedure RegIniSave;
    Procedure UpdateForm;
  public
    { Public declarations }
  end;


var
  DFMtoFMXConvert: TDFMtoFMXConvert;

implementation

{$R *.fmx}

uses IsXml, IsArrayLib, ISStrUtl, IsProcCl;

procedure TDFMtoFMXConvert.BtnEditIniFileClick(Sender: TObject);
Var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(Self);
  try
    Dlg.FileName := ExtractFileName(FIniFileName);
    Dlg.InitialDir := ExtractFilePath(FIniFileName);
    Dlg.DefaultExt := '.ini';
    Dlg.Filter := 'Ini Files|*.ini|All Files|*.*';
    if Dlg.Execute then
    begin
      Memo1.Lines.Clear;
      Memo1.Lines.LoadFromFile(Dlg.FileName);
      FIniFileName := Dlg.FileName;
      BtnSaveIni.Enabled := true;
      BtnProcess.Enabled := false;
    end;
    UpdateForm;
  finally
    Dlg.Free;
  end;
end;

procedure TDFMtoFMXConvert.BtnHelpClick(Sender: TObject);
Var
  HelpFileDocument: AnsiString;
begin
  HelpFileDocument := ChangeFileExt(ParamStr(0), '.chm');
  ShellExecuteDocument(HelpFileDocument, '', '');
end;

procedure TDFMtoFMXConvert.BtnOpenFileClick(Sender: TObject);
begin
  BtnSaveIni.Enabled := false;
  BtnProcess.Enabled := false;
  FreeAndNil(DFMObj);
  if FInDfmFileName <> '' then
    OpenDialog1.InitialDir := ExtractFileDir(FInDfmFileName);
  if OpenDialog1.Execute then
  begin
    FInPasFileName := ChangeFileExt(OpenDialog1.FileName, '.Pas');
    FInDfmFileName := ChangeFileExt(FInPasFileName, '.dfm');
    if FileExists(FInDfmFileName) then
      if TDfmToFmxObject.DFMIsTextBased(FInDfmFileName) then
      begin
        Memo1.Lines.Clear;
        Memo1.Lines.LoadFromFile(FInDfmFileName);
        BtnSaveIni.Enabled := false;
        BtnProcess.Enabled := true;
      end
      Else
        Raise Exception.Create('Dfm File is Not Text Based:' + FInDfmFileName);
  end;
  UpdateForm;
end;

procedure TDFMtoFMXConvert.BtnProcessClick(Sender: TObject);
Var
  Names, Values: TArrayOfAnsiStrings;
  Data, Errors: AnsiString;
  Stm: TStringStream;
  i: integer;
begin
  if Memo1.Text <> '' then
  begin
    FreeAndNil(DFMObj);
    Data := Memo1.Text;
    Stm := TStringStream.Create;
    Stm.LoadFromFile(FInDfmFileName);
    Stm.Seek(0,soFromBeginning);
    try
      Data := Trim(ReadLineFrmStream(Stm));
      if Pos(AnsiString('object'), Data) = 1 then
      begin
        DFMObj := TDfmToFmxObject.Create(Data, Stm, 0);
      end
    finally
      Stm.Free;
    end;
  end;
  Memo1.Text := '';
  DFMObj.LoadInfileDefs(FIniFileName);
  Memo1.Text := DFMObj.FMXFile('');
  BtnSaveIni.Enabled := false;
  BtnProcess.Enabled := false;
  UpdateForm;
end;

procedure TDFMtoFMXConvert.BtnSaveFMXClick(Sender: TObject);
Var
  Msgtype: TMsgDlgType;

  DlgBtns: TMsgDlgButtons;
  {

    TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
    mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose);
    = set of TMsgDlgBtn; }

begin
  // Msgtype:= Ord(mtWarning);
  if DFMObj = nil then
    UpdateForm
  else
  begin
    FOutPasFileName := ExtractFilePath(FOutPasFileName) +
      ChangeFileExt(ExtractFileName(FInDfmFileName), 'FMX.pas');

    if FOutPasFileName <> '' then
    begin
      SaveDialog1.InitialDir := ExtractFileDir(FOutPasFileName);
      SaveDialog1.FileName :=
        ExtractFileName(ChangeFileExt(FOutPasFileName, '.fmx'));
    end;
    if SaveDialog1.Execute then
    Begin
      FOutPasFileName := ChangeFileExt(SaveDialog1.FileName, '.pas');
      FOutFmxFileName := ChangeFileExt(FOutPasFileName, '.fmx');
      if FileExists(FOutFmxFileName) or FileExists(FOutPasFileName) then
        if MessageDlg('Overwrite Existing Files: ' + FOutFmxFileName +
          ' and/or ' + FOutPasFileName, TMsgDlgType.mtWarning,
          [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) = mrOk then
        begin
          DeleteFile(FOutFmxFileName);
          DeleteFile(FOutPasFileName);
        end;
      if FileExists(FOutFmxFileName) then
        raise Exception.Create(FOutFmxFileName + 'Already exists');
      DFMObj.WriteFMXToFile(FOutFmxFileName);
      if FileExists(FOutPasFileName) then
        raise Exception.Create(FOutPasFileName + 'Already exists');
      DFMObj.WritePasToFile(FOutPasFileName, FInPasFileName);
    End;
  end;
end;

procedure TDFMtoFMXConvert.BtnSaveIniClick(Sender: TObject);
begin
  // IniFile:=TFileStream.Create(,fmCreate);
  FreeAndNil(DFMObj);
  if FileExists(FIniFileName) then
    DeleteFile(FIniFileName);
  Memo1.Lines.SaveToFile(FIniFileName);
  UpdateForm;
end;

procedure TDFMtoFMXConvert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RegIniSave;
end;

procedure TDFMtoFMXConvert.FormCreate(Sender: TObject);
begin
  BtnSaveIni.Enabled := false;
  RegIniLoad;
  if not FileExists(FIniFileName) then
    FIniFileName := ChangeFileExt(ParamStr(0), '.ini');
  UpdateForm;
end;

function TDFMtoFMXConvert.GetRegFile: TRegistryIniFile;
begin
  Result := TRegistryIniFile.Create('DFMtoFMXConvertor');
end;

procedure TDFMtoFMXConvert.RegIniLoad;
Var
  RegFile: TRegistryIniFile;
begin
  RegFile := GetRegFile;
  try
    FIniFileName := RegFile.ReadString('Files', 'inifile', '');
    FInDfmFileName := RegFile.ReadString('Files', 'InputDFm', '');
    FOutPasFileName := RegFile.ReadString('Files', 'OutputPas', '');
    if FInDfmFileName <> '' then
      FInPasFileName := ChangeFileExt(FInDfmFileName, '.pas');
    if FOutPasFileName <> '' then
    begin
      FOutFmxFileName := ChangeFileExt(FOutPasFileName, '.FMX');
      OpenDialog1.InitialDir := ExtractFileDir(FOutPasFileName);
    end;
    if FileExists(FInDfmFileName) then
      if TDfmToFmxObject.DFMIsTextBased(FInDfmFileName) then
      begin
        Memo1.Lines.Clear;
        Memo1.Lines.LoadFromFile(FInDfmFileName);
      end;
  finally
    RegFile.Free;
  end;
end;

procedure TDFMtoFMXConvert.RegIniSave;
Var
  RegFile: TRegistryIniFile;
begin
  RegFile := GetRegFile;
  try
    RegFile.WriteString('Files', 'inifile', FIniFileName);
    RegFile.WriteString('Files', 'InputDFm', FInDfmFileName);
    RegFile.WriteString('Files', 'OutputPas', FOutPasFileName);
  finally
    RegFile.Free;
  end;
end;

procedure TDFMtoFMXConvert.UpdateForm;
begin
  BtnSaveFMX.Visible := DFMObj <> nil;
end;

end.
