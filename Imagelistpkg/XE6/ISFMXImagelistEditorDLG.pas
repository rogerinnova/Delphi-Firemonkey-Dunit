unit ISFMXImagelistEditorDLG;
// http://docwiki.embarcadero.com/RADStudio/XE5/en/Creating_a_Component_Editor_and_a_Property_Editor_for_FireMonkey_Components
{$I InnovaLibDefs.inc}
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Win.Registry, FMX.ListView.Types, FMX.Controls,
  ISFMXImageList, FMX.ListView, FMX.Types, FMX.StdCtrls,
{$IFDEF ISXE5_DELPHI}
  FMX.Graphics,
{$ENDIF}
FMX.Forms, FMX.Dialogs,
  FMX.ActnList,
  System.Actions, FMX.StdActns, System.Generics.Collections, FMX.Layouts,
  FMX.ListBox, FMX.Objects;

type
  TFmxImageListEditor = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    BtnAddImage: TButton;
    ListView1: TListView;
    btnSaveImages: TButton;
    BtnDropImage: TButton;
    BtnInsertImage: TButton;
    FMXImageList1: TFMXImageList;
    ImageMoveUp: TButton;
    ImageMoveDown: TButton;
    FMXImageButtons: TFMXImageList;
    StyleBook1: TStyleBook;
    procedure RefreshFormExecute(Sender: TObject);
    procedure btnSaveImagesClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnDropImageClick(Sender: TObject);
    procedure BtnNewImageClick(Sender: TObject);
    procedure ImageMoveApplyStyleLookup(Sender: TObject);
    procedure ImageMoveClick(Sender: TObject);
  private
    { Private declarations }
    FImagesLoaded: Boolean;
    function LastPicDirectory: string;
    procedure SaveLastPicDirectory(ADlg: TOpenDialog);
  public
    { Public declarations }
    CurrentFMXImageList: TFMXImageList;
  end;

var
  FmxImageListEditor: TFmxImageListEditor;

implementation

{$R *.fmx}

const
  FMXImageRegistryCurrentUserAppRoot =
    '\Software\INNOVA Solutions\Delphi\FMXEditors';
  CDelphiImageEdt = 'ImageFiles';
  CLastImageLoadDirectory = 'LastImageDirectory';

procedure TFmxImageListEditor.BtnDropImageClick(Sender: TObject);
Var
  ObjIns: Integer;

begin
  ObjIns := ListView1.ItemIndex;
  if (ObjIns >= 0) Then
    FMXImageList1.RemoveImage(ObjIns);
  RefreshFormExecute(nil);
end;

procedure TFmxImageListEditor.BtnNewImageClick(Sender: TObject);
  Procedure LoadThisFile(AFileName: String; AObjIns: Integer);
  Var
    Image: TBitMap;
  Begin
    if FileExists(AFileName) then
    begin
      Image := TBitMap.Create;
      try
        Image.LoadFromFile(AFileName);
        FMXImageList1.InsertImage(AObjIns, Image);
      except
        Image.Free;
      end;
    end;
  End;

var
  D: TOpenDialog;
  i, ObjIns: Integer;
begin
  D := TOpenDialog.Create(Self);
  try
    ObjIns := ListView1.ItemIndex;
    If (BtnAddImage = Sender) then
      ObjIns := ListView1.Items.Count;
    if (ObjIns < 0) Then
      ObjIns := 0;
    D.InitialDir := LastPicDirectory;
    D.Filter := TBitmapCodecManager.GetFilterString;
    D.Options := [TOpenOption.ofAllowMultiSelect, TOpenOption.ofEnableSizing,
      TOpenOption.ofFileMustExist];
    if D.Execute then
    begin
      SaveLastPicDirectory(D);
      if D.Files.Count > 1 then
      Begin
        for i := D.Files.Count - 1 downTo 0 do
          LoadThisFile(D.Files[i], ObjIns);
      End
      Else
        LoadThisFile(D.FileName, ObjIns);
    end;
  finally
    D.Free;
  end;
  RefreshFormExecute(nil);
end;

procedure TFmxImageListEditor.BtnOKClick(Sender: TObject);
begin
  if CurrentFMXImageList <> nil then
    CurrentFMXImageList.MoveImages(FMXImageList1);
end;

procedure TFmxImageListEditor.btnSaveImagesClick(Sender: TObject);
Var
  // Dlg: TBitmapDesignerIsCopy;
  Dlg: TSaveDialog;
  ObjIns: Integer;
  Image: TBitMap;

begin
  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Filter := TBitmapCodecManager.GetFilterString;
    Dlg.Options := [TOpenOption.ofEnableSizing];
    Dlg.InitialDir := LastPicDirectory;
    If (btnSaveImages = Sender) then
    begin
      ObjIns := ListView1.ItemIndex;
      if ObjIns < 0 then
        Exit
      else if Dlg.Execute then
      begin
        if FileExists(Dlg.FileName) then
          if MessageDlg('Do you want to replace file ' +
            ExtractFileName(Dlg.FileName), TMsgDlgType.mtWarning,
            [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes
          then
            DeleteFile(Dlg.FileName);
        if not DirectoryExists(ExtractFileDir(Dlg.FileName)) then
          ForceDirectories(ExtractFileDir(Dlg.FileName));
        SaveLastPicDirectory(Dlg);
        if FMXImageList1.Image[ObjIns] <> nil then
          (FMXImageList1.Image[ObjIns].SaveToFile(Dlg.FileName));
      end;
    end;
  finally
    Dlg.Free;
  end;
  RefreshFormExecute(nil);
end;

procedure TFmxImageListEditor.ImageMoveApplyStyleLookup(Sender: TObject);
Var
  ImageIdx: Integer;
begin
  if Sender = ImageMoveUp then
    ImageIdx := 0
  else if Sender = ImageMoveDown then
    ImageIdx := 1
  else
    Exit;
  FMXImageButtons.AssignAnImageTo(Sender as TButton, ImageIdx);
  FMXImageButtons.DoApplyImageStyleLookup(Sender);
end;

procedure TFmxImageListEditor.ImageMoveClick(Sender: TObject);
Var
  ObjIns: Integer;

begin
  ObjIns := ListView1.ItemIndex;
  if (ObjIns >= 0) Then
    ListView1.ItemIndex := FMXImageList1.MoveImageInList(ObjIns,
      Sender = ImageMoveUp);
  RefreshFormExecute(nil);
end;

function TFmxImageListEditor.LastPicDirectory: string;
Var
  IniFile: TRegIniFile;
begin
  IniFile := TRegIniFile.Create(FMXImageRegistryCurrentUserAppRoot);
  try
    Result := IniFile.ReadString(CDelphiImageEdt, CLastImageLoadDirectory, '');
  finally
    IniFile.Free;
  end;
end;

procedure TFmxImageListEditor.RefreshFormExecute(Sender: TObject);
Var
  NxtItem: TListViewItem;
  // NxtObj:TFmxObject;

begin
  If not FImagesLoaded then
  begin
    FMXImageList1.AssignImages(CurrentFMXImageList);
    FImagesLoaded := true;
  end;
  While ListView1.Items.Count < FMXImageList1.Images.Count do
  Begin
    NxtItem := ListView1.Items.AddItem;
    NxtItem.Text := 'Image ' + IntToStr(ListView1.Items.Count - 1);
  End;
  While ListView1.Items.Count > FMXImageList1.Images.Count do
    ListView1.Items.Delete(ListView1.Items.Count - 1);

  FMXImageList1.AssignImagesTo(ListView1);
end;

procedure TFmxImageListEditor.SaveLastPicDirectory(ADlg: TOpenDialog);
Var
  IniFile: TRegIniFile;
  DirName: String;
begin
  DirName := ExtractFileDir(ADlg.FileName);
  if Trim(DirName) <> '' then
  begin
    IniFile := TRegIniFile.Create(FMXImageRegistryCurrentUserAppRoot);
    try
      IniFile.ReadString(CDelphiImageEdt, CLastImageLoadDirectory, DirName);
    finally
      IniFile.Free;
    end;
  end;
end;

end.
