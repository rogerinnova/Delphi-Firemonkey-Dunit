unit ISFMXImageList;
// http://docwiki.embarcadero.com/RADStudio/XE5/en/Creating_a_Component_Editor_and_a_Property_Editor_for_FireMonkey_Components

{
  To Make The List component storable
  Override DefineProperties
  Adding
  a Property
  a ReadProc
  a WriteProc
  and
  a not default test

  Via
  Filer.DefineBinaryProperty
  Reader/Writer both      TStreamProc = procedure(Stream: TStream) of object;
  Or
  Filer.DefineProperty
  TReaderProc = procedure(Reader: TReader) of object;
  TWriterProc = procedure(Writer: TWriter) of object;





  Eg
  procedure TBitmap.DefineProperties(Filer: TFiler);
  begin
  inherited;
  Filer.DefineBinaryProperty('PNG', ReadBitmap, WriteBitmap, FWidth * FHeight > 0);
  end;

  The Read Proc - Recovers a property from a stream
  Eg
  procedure TBitmap.ReadBitmap(Stream: TStream);
  begin
  LoadFromStream(Stream);
  end;

  The WriteProc - Stores the property to the stream
  procedure TBitmap.WriteBitmap(Stream: TStream);
  begin
  SaveToStream(Stream);
  end;




}

{$I InnovaLibDefs.inc}

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
{$IFDEF ISXE5_DELPHI}
  FMX.Graphics,
{$ENDIF}
{$IFDEF ISXE4_DELPHI}
  FMX.StdCtrls,
  FMX.Styles,
{$ENDIF}
{$IFDEF ISD10S_DELPHI}
  FMX.ListView.Appearances,
  FMX.ImgList,
{$ENDIF}
  FMX.Menus,FMX.ActnList,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.ListView, FMX.TreeView,
  FMX.ListView.Types;

Type
  TFMXImageStore = TList<TBitMap>;
  TFMXImageDictionary = TDictionary<TFMXObject, Integer>;
  TIsImageIndexArray = Array of Word;

  TFMXImageList = Class(TFMXObject)
  private
    FImages: TFMXImageStore;
    FImageCrossRef: TFMXImageDictionary;
    //FDummy:integer;
    function GetImage(i: Integer): TBitMap;
    procedure SetImage(i: Integer; const Value: TBitMap);
    function GetImages: TFMXImageStore;
    procedure SetImages(const Value: TFMXImageStore);
    procedure ConfirmIndex(AIndex: Integer);
    procedure InsertAtIndex(AIndex: Integer);
    procedure ClearAllImages;
    Procedure TrimImages;
    // Filer Procs
    procedure ReadBitmapList(AStream: TStream);
    procedure WriteBitmapList(AStream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    procedure DoApplyImageStyleLookup(Sender: TObject);
    Destructor Destroy; override;
    function PopImage(AIndex: Integer): TBitMap;
    // Releases ownership of the image leaving nil
    Procedure InsertImage(AIndex: Integer; ABitmap: TBitMap);
    // Grabs ownership of an image
    Procedure AssignImage(AIndex: Integer; ABitmap: TBitMap); // Copies an image
    Procedure AssignImages(AImageList: TFMXImageList); // Copies all images
    Procedure MoveImages(AImageList: TFMXImageList);
    // Moves all images leaving empty list
    Procedure NullImage(AIndex: Integer);
    Procedure RemoveImage(AIndex: Integer);
    Function MoveImageInList(AIndex: Integer;GoDown:Boolean):Integer;
    Procedure AssignAnImageTo(AControl: TControl; AImageIndex: Integer);overload;
    Procedure AssignAnImageTo(AListItem: TListItem; AImageIndex: Integer);overload;
    Procedure AssignImagesTo(ATreeView: TCustomTreeView); overload;
    Procedure AssignImagesTo(ATreeView: TCustomTreeView;
      AIndexs: TIsImageIndexArray); overload;
    Procedure AssignImagesTo(AListView: TCustomListView); overload;
    Procedure AssignImagesTo(AListView: TCustomListView;
      AIndexs: TIsImageIndexArray); overload;
    Procedure AssignActionImagesToMenu(AMenu: TFMXObject);
    Procedure AssignActionImagesTo(AMenuItem: TMenuItem); overload;
    Procedure AssignActionImagesTo(AButton: TCustomButton); overload;
    function Count: Integer;
    Property Image[i: Integer]: TBitMap Read GetImage Write SetImage;
    Property Images: TFMXImageStore read GetImages Write SetImages;
  published
    //Property Dummy:Integer read FDummy write FDummy;
  End;

procedure Register;

implementation

const
  CIdleFlag: longint = 78190982;

procedure Register;
begin
  RegisterComponents('Innova Solutions', [TFMXImageList]);
end;

{ TFMXImageList }

procedure TFMXImageList.AssignAnImageTo(AControl: TControl;
  AImageIndex: Integer);
Var
  T: TFMXObject;

begin
  if not Assigned(AControl.OnApplyStyleLookup) then
    AControl.OnApplyStyleLookup := DoApplyImageStyleLookup;

  If FImageCrossRef.ContainsKey(AControl) then
    FImageCrossRef[AControl] := AImageIndex
  else
    FImageCrossRef.Add(AControl, AImageIndex);
  {
    else if not
    (TNotifyEvent(Item.OnApplyStyleLookup) = TNotifyEvent(DoApplyImageStyleLookup)) then
    raise Exception.Create('Style Lookup Already Assigned');
  }
  T := AControl.FindStyleResource('listimage');
  if (T = nil) then
    T := AControl.FindStyleResource('image');
  if (T <> nil) and (T is TImage) then
  Begin
    AControl.BeginUpdate;
    Try
      If (AImageIndex >= 0) and (AImageIndex < FImages.Count) then
      Begin
        If FImages[AImageIndex] <> nil then
          TImage(T).Bitmap.Assign(FImages[AImageIndex])
        else
          TImage(T).Bitmap.Assign(nil);
      End
      else
        TImage(T).Bitmap.Assign(nil);
    Finally
      AControl.EndUpdate;
    End;
  End;
end;


procedure TFMXImageList.AssignActionImagesTo(AMenuItem: TMenuItem);
var
  i:integer;
  ChildItem:TMenuItem;
begin
  if AMenuItem<>nil then
  begin
    if (AMenuItem.Action is TAction) then
      AMenuItem.Bitmap:=Image[TAction(AMenuItem.Action).ImageIndex];
    for i:= 0 to AMenuItem.ItemsCount-1 do
        begin
          ChildItem:=AMenuItem.Items[i];
          AssignActionImagesTo(ChildItem);
        end;
  end;
end;


procedure TFMXImageList.AssignActionImagesTo(AButton: TCustomButton);
begin
  if AButton<>nil then
    if (AButton.Action is TAction) then
      AssignAnImageTo(AButton,TAction(AButton.Action).ImageIndex);
end;

procedure TFMXImageList.AssignActionImagesToMenu(AMenu: TFMXObject);
var
  i:integer;
  ChildItem:TMenuItem;
  MBar:TMenuBar;
  MPopUp:TPopupMenu;
begin
  if AMenu is TMenuBar then
  begin
    MBar:= AMenu as TMenuBar;
    for i:= 0 to MBar.ItemsCount-1 do
        begin
          ChildItem:=MBar.Items[i];
          AssignActionImagesTo(ChildItem);
        end;
  end
  Else
  if AMenu is TPopupMenu then
  begin
    MPopUp:= AMenu as TPopupMenu;
    for i:= 0 to MPopUp.ItemsCount-1 do
        begin
          ChildItem:=MPopUp.Items[i];
          AssignActionImagesTo(ChildItem);
        end;
  end;
end;
{ DONE : ISImageViews D10S TlistviewItem
$IFDEF ISD10S_DELPHI
  FMX.ListView.Appearances,}

procedure TFMXImageList.AssignAnImageTo(AListItem: TListItem;
  AImageIndex: Integer);
Var
  LVItem:TListViewItem;
begin
  LVItem:=nil;
  if AListItem is TListViewItem then
       LvItem:= AListItem as TListViewItem;
  If AImageIndex >= 0 then
  Begin
  if LVItem<>nil then
        If FImages[AImageIndex] <> nil then
          LVItem.Bitmap.Assign(FImages[AImageIndex])
        Else
          // AListView.Items[i].Bitmap.Assign(nil)
          LVItem.Bitmap := nil;
  End;
end;

procedure TFMXImageList.AssignImage(AIndex: Integer; ABitmap: TBitMap);
begin
  InsertImage(AIndex, TBitMap.Create);
  FImages[AIndex].Assign(ABitmap);
end;

procedure TFMXImageList.AssignImages(AImageList: TFMXImageList);
Var
  i: Integer;
begin
  ClearAllImages;
  if AImageList <> nil then
    for i := 0 to AImageList.Count - 1 do
      AssignImage(i, AImageList.Image[i]);
  TrimImages;
end;

procedure TFMXImageList.AssignImagesTo(AListView: TCustomListView);
var
  AIndexs: TIsImageIndexArray;
begin
  SetLength(AIndexs, 0);
  AssignImagesTo(AListView, AIndexs);
end;

procedure TFMXImageList.AssignImagesTo(AListView: TCustomListView;
  AIndexs: TIsImageIndexArray);
Var
  i, Idx, MaxIdxAry: Integer;

begin
  MaxIdxAry := High(AIndexs);
  AListView.BeginUpdate;
  try
    for i := 0 to AListView.Items.Count - 1 do
    Begin
      if MaxIdxAry < 0 then
        Idx := i
      else if MaxIdxAry > i then
        Idx := -1
      else
        Idx := AIndexs[i];

      AssignAnImageTo(AListView.Items[i],Idx);
    End;
  finally
    AListView.EndUpdate;
  end;
end;

procedure TFMXImageList.AssignImagesTo(ATreeView: TCustomTreeView);
var
  AIndexs: TIsImageIndexArray;
begin
  SetLength(AIndexs, 0);
  AssignImagesTo(ATreeView, AIndexs);
end;

procedure TFMXImageList.AssignImagesTo(ATreeView: TCustomTreeView;
  AIndexs: TIsImageIndexArray);
Var
  i, Idx, MaxIdxAry: Integer;
  Item: TTreeViewItem;

begin
  MaxIdxAry := High(AIndexs);
  ATreeView.BeginUpdate;
  try
    for i := 0 to ATreeView.GlobalCount - 1 do
    Begin
      Item := ATreeView.ItemByGlobalIndex(i);
      begin
        if not Assigned(Item.OnApplyStyleLookup) then
          Item.OnApplyStyleLookup := DoApplyImageStyleLookup; {
          else if not
          (Addr(Item.OnApplyStyleLookup) = Addr(Self.DoApplyImageStyleLookup)) then
          raise Exception.Create('Style Lookup Already Assigned');
          { }
        if MaxIdxAry < 0 then
          Idx := i
        else if MaxIdxAry < i then
          Idx := -1
        else
          Idx := AIndexs[i];
        AssignAnImageTo(Item, Idx);
      end;
    end;
  finally
    ATreeView.EndUpdate;
  end;
end;

procedure TFMXImageList.ClearAllImages;
Var
  i: Integer;
begin
  if FImages <> nil then
    for i := 0 to FImages.Count - 1 do
      NullImage(i);
  Fimages.count:=0;
end;

procedure TFMXImageList.ConfirmIndex(AIndex: Integer);
var
  i: Integer;
begin
  if Images.Count <= AIndex then
    for i := FImages.Count to AIndex do
      FImages.Add(nil);
end;

function TFMXImageList.Count: Integer;
begin
  Result := Images.Count;
end;

procedure TFMXImageList.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('AllImages', ReadBitmapList, WriteBitmapList,
    Images.Count > 0);
end;

destructor TFMXImageList.Destroy;
begin
  ClearAllImages;
  FImages.Free;
  FImageCrossRef.Free;
  inherited;
end;

procedure TFMXImageList.DoApplyImageStyleLookup(Sender: TObject);
Var
  Idx: Integer;
  ImgObj: TFMXObject;
  T: TFMXObject;
begin
  if Sender is TFMXObject then
  Begin
    ImgObj := TFMXObject(Sender);
    T := ImgObj.FindStyleResource('listimage');
    if (T = nil) then
      T := ImgObj.FindStyleResource('image');
    if (T <> nil) and (T is TImage) then
    begin
      If Not FImageCrossRef.TryGetValue(ImgObj, Idx) then
        Idx := -1;
      If (Idx >= 0) and (Idx < FImages.Count) then
        If FImages[Idx] <> nil then
          TImage(T).Bitmap.Assign(FImages[Idx])
        else
          TImage(T).Bitmap.Assign(nil);
    end;
  end;
end;

function TFMXImageList.GetImage(i: Integer): TBitMap;
begin
  if (i<0) or (FImages.Count <= i) then
    Result := nil
  else
    Result := FImages[i];
end;

function TFMXImageList.GetImages: TFMXImageStore;
begin
  if FImages = nil then
  begin
    FImages := TFMXImageStore.Create;
    if FImageCrossRef = nil then
      FImageCrossRef := TFMXImageDictionary.Create;
  end;
  Result := FImages;
end;

procedure TFMXImageList.InsertAtIndex(AIndex: Integer);
var
  i: Integer;
begin
  if Images.Count <= AIndex then
    for i := FImages.Count to AIndex do
      FImages.Add(nil)
  else
    FImages.Insert(AIndex, nil);
end;

procedure TFMXImageList.InsertImage(AIndex: Integer; ABitmap: TBitMap);
begin
  InsertAtIndex(AIndex);
  FImages[AIndex].Free;
  FImages[AIndex] := ABitmap;
end;


function TFMXImageList.MoveImageInList(AIndex: Integer; GoDown: Boolean):integer;
Var
  CurImage:TBitMap;
  Dest:Integer;
begin
  Result:=  AIndex;
  If GoDown then Dest:= AIndex-1 else
    Dest:=AIndex+1;
  if Dest<0 then Exit;
  if Dest>= Count then Exit;

  CurImage:=PopImage(AIndex);
  FImages[AIndex]:=FImages[Dest];
  FImages[Dest]:=CurImage;
  Result:=Dest;
end;

procedure TFMXImageList.MoveImages(AImageList: TFMXImageList);
Var
  i: Integer;
begin
  ClearAllImages;
  for i := 0 to AImageList.Count - 1 do
    InsertImage(i, AImageList.PopImage(i));
  TrimImages;
end;

procedure TFMXImageList.NullImage(AIndex: Integer);
begin
  if (FImages <> nil) and (AIndex >= 0) then
    if FImages.Count > AIndex then
      try
        FImages[AIndex].Free;
        FImages[AIndex] := nil;
      Except
        FImages[AIndex] := nil;
      end;
end;

function TFMXImageList.PopImage(AIndex: Integer): TBitMap;
begin
  ConfirmIndex(AIndex);
  Result := FImages[AIndex];
  FImages[AIndex] := nil;
end;

procedure TFMXImageList.ReadBitmapList(AStream: TStream);
Var
  i, Count, ImageSize, IdleFlag: longint;
  Token: TValueType;
  NewBitMap: TBitMap;
  LocalStream: TMemoryStream;
begin
  ClearAllImages;
  AStream.Read(Count, SizeOf(Count));
  AStream.Read(IdleFlag, SizeOf(IdleFlag));
  if IdleFlag <> CIdleFlag then
    raise Exception.Create('ReadBitmapList Error');
  LocalStream := TMemoryStream.Create;
  try
    if Count > 0 then
      for i := 0 to Count - 1 do
      Begin
        AStream.Read(Token, SizeOf(Token));
        case Token of
          vaTrue:
            begin
              AStream.Read(ImageSize, SizeOf(ImageSize));
              LocalStream.Position := 0;
              LocalStream.CopyFrom(AStream, ImageSize);
              LocalStream.Position := 0;
              NewBitMap := TBitMap.Create;
              NewBitMap.LoadFromStream(LocalStream);
              FImages.Add(NewBitMap);
              // AReader.ReadComponent(NewBitMap);
              // Images[i].LoadFromStream(AStream);
            end;
          vaNil:
            FImages.Add(nil);
        end;
        AStream.Read(IdleFlag, SizeOf(IdleFlag));
        if IdleFlag <> CIdleFlag then
          raise Exception.Create('ReadBitmapList Error at' + IntToStr(i));
      End;
  finally
    LocalStream.Free;
  end;
end;

procedure TFMXImageList.RemoveImage(AIndex: Integer);
begin
  if (FImages <> nil) and (AIndex >= 0) then
    if FImages.Count > AIndex then
      try
        FImages[AIndex].Free;
        FImages.Delete(AIndex);
      Except
        FImages.Delete(AIndex);
      end;
end;

procedure TFMXImageList.SetImage(i: Integer; const Value: TBitMap);
begin
  ConfirmIndex(i);
  FImages[i] := Value;
end;

procedure TFMXImageList.SetImages(const Value: TFMXImageStore);
begin
  if FImages <> nil then
    FImages.Free;
  FImages := Value;
end;

procedure TFMXImageList.TrimImages;
Var
  i: Integer;
begin
  if FImages <> nil then
  Begin
    i := FImages.Count - 1;
    while (i >= 0) and (FImages[i] = nil) do
    begin
      FImages.Delete(i);
      Dec(i);
    end;
  End;
end;

procedure TFMXImageList.WriteBitmapList(AStream: TStream);
Var
  i, Count, ImageSize, IdleFlag: longint;
  Token: TValueType;
  LocalStream: TMemoryStream;

begin
  Count := Images.Count;
  IdleFlag := CIdleFlag;
  AStream.Write(Count, SizeOf(Count));
  AStream.Write(IdleFlag, SizeOf(IdleFlag));
  LocalStream := TMemoryStream.Create;
  try
    if Count > 0 then
      for i := 0 to Count - 1 do
      Begin
        if FImages[i] = nil then
          Token := vaFalse
        else
          Token := vaTrue;
        AStream.Write(Token, SizeOf(Token));
        case Token of
          vaTrue:
            begin
              LocalStream.Position := 0;
              Images[i].SaveToStream(LocalStream);
              ImageSize := LocalStream.Position;
              LocalStream.Position := 0;
              AStream.Write(ImageSize, SizeOf(ImageSize));
              AStream.CopyFrom(LocalStream, ImageSize);
            end;
          vaNil:
            ;
        end;
        AStream.Write(IdleFlag, SizeOf(IdleFlag));
      End;

  finally
    LocalStream.Free;
  end;
end;

end.
