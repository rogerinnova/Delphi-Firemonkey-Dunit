unit FMXListBoxLib;
// TreeView Helper Code in Lib.FMXTreeViewLib
// ListBox Helper Code in Lib.FMXListBoxLib
interface

uses
  FMX.Styles.Objects,
  FMX.Graphics, FMX.Types, FMX.Objects, FMX.TreeView, FMX.ListBox,
  FMX.Layouts, Sysutils, ISFMXImageList;
Type
  TColArray = array of string;
  TListItemClickProc = procedure(Sender: TObject) of Object;


Procedure ClearListBox(AListBox: TListBox);
Function FmxListBoxAddColumnItem(AListBox: TListBox; AObject: TObject;
  ACols: TColArray; AClickProc: TListItemClickProc; AStyleName: String = '')
  : TListBoxItem;
{ Expects a the style applied to have a series of TText
  if then the style is ListBoxItemStyle
  containing Length(ACols) TText items
  These Items Named 'col0','col1', etc.
}
Procedure FmxListBoxUpdateColumnItem(AListBoxItem: TListBoxItem;
  ACols: TColArray);
{ Expects item created by FmxListBoxAddColumnItem above }
Function FmxListBoxColumnItemValues(AListBoxItem: TListBoxItem): TColArray;
{ Expects item created by FmxListBoxAddColumnItem above }

function GetColArrayFromString(const S: UnicodeString; SepVal: WideChar;
  ARemoveQuote: boolean = false; ATrim: boolean = True): TColArray;

implementation
uses
{$IFDEF MSWINDOWS}
  WinAPi.Windows, //For  OutputDebugString
{$Endif}
  FMXTreeViewLib;

procedure ErrorFlag(ATxt:String);
begin
{$IFDEF MSWINDOWS}
  OutputDebugString(PWideChar(ATxt[1]));
{$Endif}
end;


Procedure ClearListBox(AListBox: TListBox);
Var
  Item: TListBoxItem;
begin
  While AListBox.Count > 0 do
  Begin // Clear;
    if AListBox.ListItems[0] is TListBoxItem then
      Item := AListBox.ListItems[0] as TListBoxItem
    else
      Item := nil;
    AListBox.ListItems[0].Parent := nil;
    Try
      Item.Free;
    Except
      On E:Exception do
         ErrorFlag('ClearListBox::'+E.Message);
    End;
  End;
end;

Function FmxListBoxAddColumnItem(AListBox: TListBox; AObject: TObject;
  ACols: TColArray; AClickProc: TListItemClickProc; AStyleName: String = '')
  : TListBoxItem;
{ Expects a the style applied to have a series of TText
  if then the style is ListBoxItemStyle
  containing Length(ACols) TText items
  These Items Named 'col0','col1', etc.
}
Var
  NewItem: TListBoxItem;
  bb: TActiveStyleTextObject;
begin
  Result := nil;
  if AListBox = nil then
    Exit;
  NewItem := TListBoxItem.Create(AListBox);
  if AStyleName <> '' then
    NewItem.StyleLookup := LowerCase(AStyleName);

  NewItem.OnClick := AClickProc;
  NewItem.Data := AObject;
  NewItem.Parent := AListBox;
  NewItem.ApplyStyleLookup;
  FmxListBoxUpdateColumnItem(NewItem, ACols);
  Result := NewItem;
end;

Procedure FmxListBoxUpdateColumnItem(AListBoxItem: TListBoxItem;
  ACols: TColArray);
Var
  i: integer;
  TxtName: String;
  T: TFMXObject;
Begin
  if AListBoxItem = nil then
    Exit;
  if Length(ACols) < 1 then
    Exit;

  //AListBoxItem.ApplyStyleLookup;
  for i := 0 to High(ACols) do
    try
      TxtName := 'co' + IntToStr(i);
      T:=nil;
      T := AListBoxItem.FindStyleResource(TxtName);
      if (T <> nil) and (T is TText) then
        (T as TText).Text := ACols[i];
    except
    end;
end;

Function FmxListBoxColumnItemValues(AListBoxItem: TListBoxItem): TColArray;
Var
  i, ColCount, RsltSz, MissedCount: integer;
  TxtName: String;
  T: TFMXObject;
Begin
  SetLength(Result, 0);
  if AListBoxItem = nil then
    Exit;

  ColCount := 0;
  MissedCount := 0;
  RsltSz := 5;
  SetLength(Result, RsltSz);
  i := 0;
  while MissedCount < 3 do
  Begin
      if RsltSz < i+1 then
      begin
        Inc(RsltSz, 5);
        SetLength(Result, RsltSz);
      end;
    TxtName := 'co' + IntToStr(i);
    T := AListBoxItem.FindStyleResource(TxtName);
    if (T <> nil) and (T is TText) then
    Begin
      MissedCount := 0;
      ColCount:=i+1;
      Result[i]:= (T as TText).Text;
    End
     Else
     begin
       Inc(MissedCount);
       Result[i]:= '';
     end;
    inc(i);
  End;
  SetLength(Result,ColCount);
End;

function FieldSep(var ss: PWideChar; SepVal: WideChar): UnicodeString;
var
  CharPointer: PWideChar;
  j: integer;

begin
  if ss <> nil then
  begin
    if (SepVal <> WideChar(0)) then
      while ss[0] = SepVal do
        Inc(ss);
    CharPointer := AnsiStrScan(ss, SepVal);
    if CharPointer = nil then
      Result := StrPas(ss) { Last Field }
    else
    begin
      j := CharPointer - ss;
      Result := Copy(ss, 0, j);
    end;
    if CharPointer = nil then
      ss := nil
    else
      ss := CharPointer + 1;
  end
  else
    Result := '';
end;

function GetColArrayFromString(const S: UnicodeString; SepVal: WideChar;
  ARemoveQuote: boolean = false; ATrim: boolean = True): TColArray;
var
  i: integer;
  NextChar, SecondQuoteChar: PWideChar;
  QuoteVal: UnicodeString;
  TstChar: Char;
  fs: UnicodeString;
begin

  SetLength(Result, 0);
  if S = '' then
    Exit;

  NextChar := @S[1];
  i := 0;
  while NextChar <> nil do
  begin
    if NextChar[0] = SepVal then
    begin
      Inc(NextChar);
      fs := '';
    end
    else if ARemoveQuote and (NextChar[0] in ['''', '"', '[', '{', '(', '<'])
    then
    begin
      TstChar := NextChar[0];
      case TstChar of
        '''', '"':
          QuoteVal := NextChar[0];
        '[':
          QuoteVal := ']';
        '{':
          QuoteVal := '}';
        '(':
          QuoteVal := ')';
        '<':
          QuoteVal := '>';
      else
        QuoteVal := NextChar[0];
      end;
      SecondQuoteChar := StrPos(PWideChar(NextChar) + 1, PWideChar(QuoteVal));
      if (SecondQuoteChar <> nil) and
        ((SecondQuoteChar[1] = SepVal) or (SecondQuoteChar[1] = #0)) then
      begin
        Inc(NextChar);
        fs := FieldSep(NextChar, QuoteVal[1]);
        if SecondQuoteChar[1] = #0 then
          NextChar := nil
        else
          Inc(NextChar);
      end
      else
        fs := FieldSep(NextChar, SepVal);
    end
    else
      fs := FieldSep(NextChar, SepVal);
    if i > high(Result) then
      SetLength(Result, i + 6);
    if ATrim then
      Result[i] := Trim(fs)
    else
      Result[i] := fs;
    Inc(i);
  end;
  SetLength(Result, i);
end;


end.
