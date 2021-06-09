unit CvtrObj;

interface

uses PatchLib, System.Classes, System.Types, System.SysUtils, Contnrs,
  {IsArrayLib,} inifiles;

Type
  TDfmToFmxObject = class(TObject)
  private
    FDFMClass: AnsiString;
    FObjName: AnsiString;
    FOwnedObjs: TObjectList;
    FOwnedItems: TObjectList;
    FDepth: integer;
    F2DPropertyArray: TTwoDArrayOfAnsiString;
    FPropertyArraySz, FPropertyMax: integer;
    FIniReplaceValues, FIniIncludeValues, FIniSectionValues, FIniAddProperties,
      FUsesTranslation, FIniObjectTranslations: TStringlist;
    Function OwnedObjs: TObjectList;
    Function OwnedItems: TObjectList;
    Function IniObjectTranslations: TStringList;
    Function IniSectionValues: TStringlist;
    function UsesTranslation: TStringlist;
    function IniReplaceValues: TStringlist;
    function IniIncludeValues: TStringlist;
    function IniAddProperties: TStringlist;
    Function PropertyArray(ARow: integer): TArrayOfAnsiStrings;
    Procedure UpdateUsesStringList(AUsesList: TStrings);
    Procedure ReadProperties(AData:AnsiString;AStm:TStream;var AIdx:Integer);
    Function ProcessUsesString(AOrigUsesArray: TArrayOfAnsiStrings): AnsiString;
    Function ProcessCodeBody(Const ACodeBody:AnsiString):AnsiString;
    procedure IniFileLoad(AIni: TIniFile);
    procedure ReadItems(APropertyIdx:integer;AStm:TStream);
    function FMXClass: AnsiString;
    function TransformProperty(ACurrentName, ACurrentValue: AnsiString)
      : AnsiString;
    function AddArrayOfItemProperties(APropertyIdx:Integer;APad:AnsiString):AnsiString;
    function FMXProperties(APad:AnsiString): AnsiString;
    function FMXSubObjects(APad:AnsiString): AnsiString;
  public
    Constructor Create(ACreateText: AnsiString; AStm: TStream; ADepth: integer);
    Destructor Destroy;
    Procedure LoadInfileDefs(AIniFileName: AnsiString);
    Class Function DFMIsTextBased(ADfmFileName: AnsiString): Boolean;
    function GenPasFile(Const APascalSourceFileName: AnsiString): AnsiString;
    Function FMXFile(APad:AnsiString): AnsiString;
    Function WriteFMXToFile(Const AFmxFileName: AnsiString): Boolean;
    Function WritePasToFile(Const APasOutFileName, APascalSourceFileName
      : AnsiString): Boolean;
  end;

  TDfmToFmxListItem = Class (TDfmToFmxObject)
    FHasMore:Boolean;
    FPropertyIndex:Integer;
    FOwner:TDfmToFmxObject;
    public
    constructor Create(AOwner:TDfmToFmxObject;APropertyIdx: integer; AStm: TStream;ADepth: integer);
    Property HasMore:Boolean Read FHasMore;
    end;

implementation

Const
  ContinueCode: AnsiString = '#$Continue$#';

  { DfmToFmxObject }
function TDfmToFmxObject.AddArrayOfItemProperties(APropertyIdx: Integer;
  APad: AnsiString): AnsiString;
begin
  Result := APad + 'item' + CRLF +
    APad + 'Prop1 = 6' + CRLF +
    APad + 'end>' + CRLF;



  //Tempary patch
end;

constructor TDfmToFmxObject.Create(ACreateText: AnsiString; AStm: TStream;
  ADepth: integer);
Var
  InputArray: TArrayOfAnsiStrings;
  Data: AnsiString;
  NxtChr: PAnsiChar;
  i: integer;
begin
  i := 0;
  FDepth := ADepth;
  if Pos(AnsiString('object'), Trim(ACreateText)) = 1 then
  begin
    InputArray := GetArrayFromString(ACreateText, ' ');
    NxtChr := @InputArray[1][1];
    FObjName := FieldSep(NxtChr, ':');
    FDFMClass := InputArray[2];
    Data := Trim(ReadLineFrmStream(AStm));
    while Data <> AnsiString('end') do
    Begin
      if Pos(AnsiString('object'), Data) = 1 then
        OwnedObjs.add(TDfmToFmxObject.Create(Data, AStm, FDepth + 1))
      else
        ReadProperties(Data,AStm,i);
      Data := Trim(ReadLineFrmStream(AStm));
    end
  end
  else
    Raise Exception.Create('Bad Start::' + ACreateText);
  SetLength(F2DPropertyArray, FPropertyMax + 1);
end;

destructor TDfmToFmxObject.Destroy;
begin
  SetLength(F2DPropertyArray, 0);
  FOwnedObjs.Free;
  FOwnedItems.Free;
  FIniReplaceValues.Free;
  FIniIncludeValues.Free;
  FIniSectionValues.Free;
  FUsesTranslation.Free;
  FIniAddProperties.Free;
end;

class function TDfmToFmxObject.DFMIsTextBased(ADfmFileName: AnsiString)
  : Boolean;
Var
  Sz: Int64;
  Idx: integer;
  DFMFile: TFileStream;
  TestString: AnsiString;

begin
  Result := false;
  if not FileExists(ADfmFileName) then
    Exit;

  DFMFile := TFileStream.Create(ADfmFileName, fmOpenRead);
  try
    Sz := DFMFile.Size;
    if Sz > 20 then
    begin
      SetLength(TestString, 20);
      Idx := DFMFile.read(TestString[1], 20);
      if Idx <> 20 then
        raise Exception.Create('Error Dfm file read');
      if PosNoCase('object', TestString) > 0 then
        Result := true;
      if not Result then
      Begin
        Try
          TestString := CompressedUnicode(TestString);
          if PosNoCase('object', TestString) > 0 then
            Result := true;
        Except
        End;
      End;
    end;
  finally
    DFMFile.Free;
  end;
end;

function TDfmToFmxObject.FMXClass: AnsiString;
begin
  Result := FDFMClass;
end;

function TDfmToFmxObject.FMXFile(APad:AnsiString): AnsiString;

begin
  Result := APad + 'Object ' + FObjName + ': ' + FMXClass + CRLF + FMXProperties(APad + '  ') +
    FMXSubObjects(APad + '  ') + APad + 'end' + CRLF;
end;

function TDfmToFmxObject.FMXProperties(APad:AnsiString): AnsiString;
Var
  Temp: AnsiString;
  i: integer;
begin
  Result := '';
  for i := Low(F2DPropertyArray) to High(F2DPropertyArray) do
    if F2DPropertyArray[i, 1] = '<' then
    begin
      Temp := TransformProperty(F2DPropertyArray[i, 0], F2DPropertyArray[i, 1]);
      if Trim(Temp) <> '' then
        Result := Result + APad + Temp + CRLF;
      Result := Result + AddArrayOfItemProperties(i, APad) + CRLF;
    end
    else if F2DPropertyArray[i, 0] <> '' then
    begin
      Temp := TransformProperty(F2DPropertyArray[i, 0], F2DPropertyArray[i, 1]);
      if Trim(Temp) <> '' then
        Result := Result + APad + Temp + CRLF;
    end;
  if IniAddProperties.Count > 0 then
    for i := 0 to FIniAddProperties.Count - 1 do
      Result := Result + APad + StringReplace(FIniAddProperties[i], '=', ' = ',
        []) + CRLF;
end;

function TDfmToFmxObject.FMXSubObjects(APad:AnsiString): AnsiString;
Var
  i: integer;
begin
  Result := '';
  if FOwnedObjs = nil then
    Exit;

  for i := 0 to FOwnedObjs.Count - 1 do
    if FOwnedObjs[i] is TDfmToFmxObject then
      Result := Result + TDfmToFmxObject(FOwnedObjs[i]).FMXFile(APad);
end;

function TDfmToFmxObject.GenPasFile(const APascalSourceFileName: AnsiString)
  : AnsiString;

Var
  PasFile: TFileStream;
  PreUsesString, PostUsesString, UsesString: AnsiString;
  UsesArray: TArrayOfAnsiStrings;
  NxtChar, StartChr, EndChar: PAnsiChar;
  Sz: integer;
  Idx: integer;
  s: AnsiString;
begin
  Result := '';
  PostUsesString := '';
  UsesString := '';
  if not FileExists(APascalSourceFileName) then
    Exit;

  PasFile := TFileStream.Create(APascalSourceFileName, fmOpenRead);
  try
    Sz := PasFile.Size;
    // if sz>200000 then  ????/
    if Sz > 20 then
    begin
      SetLength(PreUsesString, Sz);
      // PasFile.Seek(0,soBeginning);
      Idx := PasFile.read(PreUsesString[1], Sz);
      if Idx <> Sz then
        raise Exception.Create('Error Pas file read');
    end
    else
      PreUsesString := '';
  finally
    PasFile.Free;
  end;

  if Sz > 20 then
  begin
    Idx := PosNoCase('uses', PreUsesString);
    StartChr := @PreUsesString[Idx + 4];
    s := ';';
    EndChar := StrPos(StartChr, PAnsiChar(s));
    UsesArray := GetArrayFromString
      (AnsiString(StringReplace(Copy(PreUsesString, Idx + 4,
      EndChar - StartChr), CRLF, '', [rfReplaceAll])), ',');
    PostUsesString := Copy(PreUsesString, EndChar - StartChr + Idx + 4, Sz);
    PostUsesString := ProcessCodeBody(PostUsesString);
    SetLength(PreUsesString, Idx - 1);
    UsesString := ProcessUsesString(UsesArray);
  end;
  Result := PreUsesString + UsesString + PostUsesString;
end;

function TDfmToFmxObject.IniAddProperties: TStringlist;
begin
  if FIniAddProperties = nil then
    FIniAddProperties := TStringlist.Create;
  Result := FIniAddProperties;
end;

procedure TDfmToFmxObject.IniFileLoad(AIni: TIniFile);
Var
  i: integer;
  NewClassName: AnsiString;

begin
  if AIni = nil then
    Exit;
  if FDepth < 1 then // is the base form
  Begin
    AIni.ReadSectionValues('ObjectChanges', IniObjectTranslations);
    AIni.ReadSectionValues('TForm', IniSectionValues);
    AIni.ReadSectionValues('TFormReplace', IniReplaceValues);
    AIni.ReadSectionValues('TFormReplace', IniReplaceValues);
    AIni.ReadSection('TFormInclude', IniIncludeValues);
  End
  else
  begin
    NewClassName := AIni.ReadString('ObjectChanges', FDFMClass, '');
    if NewClassName <> '' then
      FDFMClass := NewClassName;
    AIni.ReadSectionValues(FDFMClass, IniSectionValues);
    AIni.ReadSectionValues(FDFMClass + 'Replace', IniReplaceValues);
    AIni.ReadSection(FDFMClass + 'Include', IniIncludeValues);
    AIni.ReadSectionValues(FDFMClass + 'AddProperty', IniAddProperties);

  end;
  for i := 0 to OwnedObjs.Count - 1 do
    if OwnedObjs[i] is TDfmToFmxObject then
      TDfmToFmxObject(OwnedObjs[i]).IniFileLoad(AIni);

  if FOwnedItems<>nil then
    for i := 0 to fOwnedItems.Count - 1 do
     if fOwnedItems[i] is TDfmToFmxListItem then
       TDfmToFmxListItem(fOwnedItems[i]).IniFileLoad(AIni{,FDFMClass});

  if IniSectionValues.Count < 1 then
  Begin
    AIni.WriteString(FDFMClass, 'Empty', 'Add Transformations');
    AIni.WriteString(FDFMClass, 'Top', 'Position.Y');
    AIni.WriteString(FDFMClass, 'Left', 'Position.X');
  End;

  if IniIncludeValues.Count < 1 then
  Begin
    AIni.WriteString(FDFMClass + 'Include', 'FMX.Controls', 'Empty Include');
  End;
end;

function TDfmToFmxObject.IniIncludeValues: TStringlist;
begin
  if FIniIncludeValues = nil then
    FIniIncludeValues := TStringlist.Create;
  Result := FIniIncludeValues;
end;

function TDfmToFmxObject.IniObjectTranslations: TStringList;
begin
  if FIniObjectTranslations = nil then
    FIniObjectTranslations := TStringlist.Create;
  Result := FIniObjectTranslations;
end;

function TDfmToFmxObject.IniReplaceValues: TStringlist;
begin
  if FIniReplaceValues = nil then
    FIniReplaceValues := TStringlist.Create;
  Result := FIniReplaceValues;
end;

function TDfmToFmxObject.IniSectionValues: TStringlist;
begin
  if FIniSectionValues = nil then
    FIniSectionValues := TStringlist.Create;
  Result := FIniSectionValues;
end;

procedure TDfmToFmxObject.LoadInfileDefs(AIniFileName: AnsiString);
Var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(AIniFileName);
  IniFileLoad(Ini);
end;

function TDfmToFmxObject.OwnedItems: TObjectList;
begin
  if FOwnedItems = nil then
  begin
    FOwnedItems := TObjectList.Create;
    FOwnedItems.OwnsObjects := true;
  end;
  Result := FOwnedItems;
end;

function TDfmToFmxObject.OwnedObjs: TObjectList;
begin
  if FOwnedObjs = nil then
  begin
    FOwnedObjs := TObjectList.Create;
    FOwnedObjs.OwnsObjects := true;
  end;
  Result := FOwnedObjs;
end;

function TDfmToFmxObject.ProcessCodeBody(
  const ACodeBody: AnsiString): AnsiString;
Var
  BdyStr:AnsiString;
  Idx:Integer;
  TransArray:TArrayOfAnsiStrings;
begin
  BdyStr:=  StringReplace(ACodeBody, AnsiString('{$R *.DFM}'),
      AnsiString('{$R *.FMX}'), [rfIgnoreCase]);
  If FIniObjectTranslations<>nil then
   for Idx := 0 to FIniObjectTranslations.Count-1 do
      Begin
        TransArray := GetArrayFromString(
        AnsiString(FIniObjectTranslations[Idx]),'=');
        if Length(TransArray)>1 then
        BdyStr:=  StringReplace(BdyStr, TransArray[0], TransArray[1],
        [rfReplaceAll,rfIgnoreCase]);
      End;
   Result:= BdyStr;
end;

function TDfmToFmxObject.ProcessUsesString(AOrigUsesArray: TArrayOfAnsiStrings)
  : AnsiString;
var
  i: integer;
begin
  PopulateStringsFromArray(UsesTranslation, AOrigUsesArray);
  UpdateUsesStringList(UsesTranslation);
  Result := 'uses ';
  for i := 0 to UsesTranslation.Count - 1 do
    if Trim(FUsesTranslation[i]) <> '' then
      Result := Result + CRLF + FUsesTranslation[i] + ',';
  SetLength(Result, Length(Result) - 1);
end;

function TDfmToFmxObject.PropertyArray(ARow: integer): TArrayOfAnsiStrings;
begin
  While ARow >= FPropertyArraySz do
  Begin
    inc(FPropertyArraySz, 5);
    SetLength(F2DPropertyArray, FPropertyArraySz);
  End;
  if ARow > FPropertyMax then
    FPropertyMax := ARow;
  Result := F2DPropertyArray[ARow];
end;

procedure TDfmToFmxObject.ReadItems(APropertyIdx: integer; AStm: TStream);
Var
  Data: AnsiString;
  ThisItem: TDfmToFmxListItem;
  NotDone:Boolean;
begin
  NotDone:=true;
  Data := Trim(ReadLineFrmStream(AStm));
  While NotDone do
   If Pos(AnsiString('item'), Data) = 1 then
  begin
    ThisItem:= TDfmToFmxListItem.Create(Self,APropertyIdx, AStm,FDepth) ;
    OwnedItems.Add(ThisItem);
    NotDone:= ThisItem.HasMore;
    if NotDone then
     Data := Trim(ReadLineFrmStream(AStm));
  end
   else
    if Pos(AnsiString('>'), Data)>0 then
       NotDone:=false
     else
       Raise Exception.Create('Bad Items');
end;


procedure TDfmToFmxObject.ReadProperties(AData: AnsiString; AStm:TStream; var AIdx: Integer);
begin
        PropertyArray(AIdx);
        F2DPropertyArray[AIdx] := GetArrayFromString(AData, '=');
        if High(F2DPropertyArray[AIdx]) < 1 then
        begin
          SetLength(F2DPropertyArray[AIdx], 2);
          F2DPropertyArray[AIdx, 0] := ContinueCode;
          F2DPropertyArray[AIdx, 1] := AData;
        end
         Else
           If (F2DPropertyArray[AIdx,1]='<') then
               ReadItems(AIdx,AStm);
        inc(AIdx);
end;

function TDfmToFmxObject.TransformProperty(ACurrentName, ACurrentValue
  : AnsiString): AnsiString;
Var
  s: AnsiString;

begin
  if ACurrentName = ContinueCode then
    Result := ACurrentValue
  Else
  begin
    s := FIniSectionValues.Values[ACurrentName];
    if s = '' then
      s := ACurrentName;
    if s = '#Delete#' then
      Result := ''
     else
      Result := s + ' = ' + ACurrentValue;
  end;
end;

procedure TDfmToFmxObject.UpdateUsesStringList(AUsesList: TStrings);
var
  i: integer;
  Idx: integer;
begin
  if FIniReplaceValues <> nil then
    for i := 0 to AUsesList.Count - 1 do
    Begin
      Idx := FIniReplaceValues.IndexOfName(AUsesList[i]);
      if Idx >= 0 then
        AUsesList[i] := FIniReplaceValues.ValueFromIndex[Idx];
    End;
  for i := AUsesList.Count - 1 downto 0 do
    if Trim(AUsesList[i]) = '' then
      AUsesList.Delete(i);
  if FIniIncludeValues <> nil then
    for i := 0 to FIniIncludeValues.Count - 1 do
    Begin
      Idx := AUsesList.IndexOf(FIniIncludeValues[i]);
      if Idx < 0 then
        AUsesList.add(FIniIncludeValues[i]);
    End;

  if FOwnedObjs = nil then
    Exit;
  for i := 0 to FOwnedObjs.Count - 1 do
    if FOwnedObjs[i] is TDfmToFmxObject then
      TDfmToFmxObject(FOwnedObjs[i]).UpdateUsesStringList(AUsesList);
end;

function TDfmToFmxObject.UsesTranslation: TStringlist;
begin
  if FUsesTranslation = nil then
    FUsesTranslation := TStringlist.Create;
  Result := FUsesTranslation;
end;

function TDfmToFmxObject.WriteFMXToFile(const AFmxFileName: AnsiString)
  : Boolean;
Var
  OutFile: TFileStream;
  s: AnsiString;
begin
  Result := false;
  s := FMXFile('');
  If s = '' then
    raise Exception.Create('No Data for FMX File');

  if FileExists(AFmxFileName) then
    RenameFile(AFmxFileName, ChangeFileExt(AFmxFileName, '.fbk'));
  OutFile := TFileStream.Create(AFmxFileName, fmCreate);
  try
    OutFile.Write(s[1], Length(s));
    Result := true;
  finally
    OutFile.Free;
  end;
end;

function TDfmToFmxObject.WritePasToFile(const APasOutFileName,
  APascalSourceFileName: AnsiString): Boolean;
Var
  OutFile, InFile: TFileStream;
  s: AnsiString;
begin
  Result := false;
  if not FileExists(APascalSourceFileName) then
    raise Exception.Create('Pascal Source:' + APascalSourceFileName +
      ' Does not Exist');

  s := GenPasFile(APascalSourceFileName);
  If s = '' then
    raise Exception.Create('No Data for Pas File');
  s := StringReplace(s, ChangeFileExt(ExtractFileName(APascalSourceFileName),
    ''), ChangeFileExt(ExtractFileName(APasOutFileName), ''), [rfIgnoreCase]);
  if FileExists(APasOutFileName) then
    RenameFile(APasOutFileName, ChangeFileExt(APasOutFileName, '.bak'));
  OutFile := TFileStream.Create(APasOutFileName, fmCreate);
  try
    OutFile.Write(s[1], Length(s));
    Result := true;
  finally
    OutFile.Free;
  end;
end;

{ TDfmToFmxListItem }

constructor TDfmToFmxListItem.Create (AOwner:TDfmToFmxObject;APropertyIdx: integer;
  AStm: TStream;ADepth: integer);

  Var
  Data: AnsiString;
  i,LoopCount: integer;
  Begin
    FPropertyIndex:=APropertyIdx;
    FOwner:=AOwner;
    i := 0;
    FDepth := ADepth;
    Data:='';
    LoopCount:=55;
    while (LoopCount>0) and (Pos(AnsiString('end'),Data)<>1)  do
     Begin
        Dec(LoopCount);
        if Pos(AnsiString('object'), Data) = 1 then
        OwnedObjs.add(TDfmToFmxObject.Create(Data, AStm, FDepth + 1))
      else
        ReadProperties(Data,AStm,i);
      Data := Trim(ReadLineFrmStream(AStm));
      if (Data<>'') then LoopCount:=55;
    end;
  SetLength(F2DPropertyArray, FPropertyMax + 1);
  FHasMore:= (Pos(AnsiString('end'),Data)=1) and not  (Pos(AnsiString('end>'),Data)=1);
end;

end.
