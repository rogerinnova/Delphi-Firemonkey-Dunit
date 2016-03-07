unit ImageListTestForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Rtti,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  ISFMXImageList, System.Generics.Collections, FMX.ListView.Types, FMX.ListView,
  FMX.Layouts, FMX.TreeView;

type
  TForm5 = class(TForm)
    BtnComponentEdit: TButton;
    FMXImageList1: TFMXImageList;
    BtnPropertyEdt: TButton;
    TreeView1: TTreeView;
    FMXImageList2: TFMXImageList;
    BtnAddItems: TButton;
    BtnAddSubItems: TButton;
    StyleBook1: TStyleBook;
    procedure BtnComponentEditClick(Sender: TObject);
    procedure BtnPropertyEdtClick(Sender: TObject);
    procedure BtnAddItemsClick(Sender: TObject);
    procedure BtnAddSubItemsClick(Sender: TObject);
    procedure TreeViewItemClick(Sender: TObject);
  private
    { Private declarations }
    CrossRefArray: TIsImageIndexArray;
    Procedure   SetCountArray;
    Procedure UpdateForm;
    Procedure AddFiveItems;
    Procedure AddFiveChildItems(AItem: TTreeViewItem);
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

uses ISFMXImagelistEditorDLG;

procedure TForm5.AddFiveChildItems(AItem: TTreeViewItem);
Var
  NewSize, i: integer;
  NewItem: TTreeViewItem;
begin
  AItem.BeginUpdate;
  Try
    NewSize := AItem.Count + 5;
    for i := AItem.Count to NewSize do
    Begin
      NewItem := TTreeViewItem.Create(nil);
      NewItem.Parent := AItem;
      NewItem.Text := 'Sub Item ' + IntToStr(i);
      NewItem.OnClick:=TreeViewItemClick;
      FMXImageList1.AssignAnImageTo(NewItem,0);
    end;
  SetCountArray;
  Finally
    AItem.EndUpdate;
  End;
end;

procedure TForm5.AddFiveItems;
Var
  NewSize, i: integer;
  NewItem: TTreeViewItem;
  {Data:TValue;
  {  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure);

  PPTypeInfo = ^PTypeInfo;
  PTypeInfo = ^TTypeInfo;
  TTypeInfo = record
    Kind: TTypeKind;
    Name: TSymbolName;
    function NameFld: TTypeInfoFieldAccessor; inline;
   {TypeData: TTypeData
    function TypeData: PTypeData; inline;
  end;

}
begin
  TreeView1.BeginUpdate;
  Try
    NewSize := TreeView1.Count + 5;
    SetLength(CrossRefArray, NewSize + 1);
    for i := TreeView1.Count to NewSize do
    Begin
      NewItem := TTreeViewItem.Create(nil);
      NewItem.Parent := TreeView1;
      NewItem.Text := 'Item ' + IntToStr(i);
      NewItem.OnClick:=TreeViewItemClick;
      FMXImageList1.AssignAnImageTo(NewItem,0);
      { // this code set event - when we need to setup item
        NewItem.OnApplyStyleLookup := DoApplyStyleLookup;
        // this set our style to new item
        NewItem.StyleLookup := 'CustomItem';
        { }
    end;
  SetCountArray;
  Finally
    TreeView1.EndUpdate;
  End;
  { From Example unit CustomTreeFrm;


    var
    I: Integer;
    Item: TTreeViewItem;
    begin
    TreeView1.BeginUpdate;
    for I := 1 to 100 do
    begin
    Item := TTreeViewItem.Create(nil);
    with Item do
    begin
    Parent := TreeView1;
    Text := 'Item ' + IntToStr(I);
    // this code set event - when we need to setup item
    Item.OnApplyStyleLookup := DoApplyStyleLookup;
    // this set our style to new item
    Item.StyleLookup := 'CustomItem';
    end;
    end;
    TreeView1.EndUpdate;
    end;
  }
end;

procedure TForm5.BtnComponentEditClick(Sender: TObject);
var
  DesignerForm: TFmxImageListEditor;
  Component: TObject;
begin
  DesignerForm := TFmxImageListEditor.Create(nil);
  try
    // Set curent value to designer form
    Component := FMXImageList1;
    if Component is TFMXImageList then
    Begin
      DesignerForm.CurrentFMXImageList := TFMXImageList(Component);
      // Show ModalForm, and then take result
      if DesignerForm.ShowModal = mrOK then
        { };
    End;
    // Designer.Modified;
  finally
    DesignerForm.Free;
  end;
  UpdateForm;
end;

procedure TForm5.BtnPropertyEdtClick(Sender: TObject);
// procedure TISFMXImageListComponentEditor.ShowDesigner;
var
  DesignerForm: TFmxImageListEditor;
begin
  DesignerForm := TFmxImageListEditor.Create(nil);
  try
    // Set curent value to designer form
    // Component;
    Begin
      DesignerForm.CurrentFMXImageList := FMXImageList2;
      // Show ModalForm, and then take result
      if DesignerForm.ShowModal = mrOK then
        { };
    End;
    // Designer.Modified;
  finally
    DesignerForm.Free;
  end;
end;

procedure TForm5.SetCountArray;
Var
  i:Integer;
begin
  SetLength(CrossRefArray,TreeView1.GlobalCount);
  for i:= 0 to TreeView1.GlobalCount-1 do
        CrossRefArray[i] := i
end;


procedure TForm5.TreeViewItemClick(Sender: TObject);
Var
  i:integer;
begin
  if Sender is TTreeviewItem then
   Begin
     i:=  TTreeviewItem(Sender).GlobalIndex mod 10;
     FMXImageList1.AssignAnImageTo(TTreeviewItem(Sender),i);
     TreeView1.RealignContent;
     //TTreeviewItem(Sender).Text:='99';
   End;
end;

procedure TForm5.BtnAddItemsClick(Sender: TObject);
begin
  AddFiveItems;
  UpdateForm;
end;

procedure TForm5.BtnAddSubItemsClick(Sender: TObject);
  Procedure AddSubItemsToChild(AItem: TTreeViewItem);
  Var
    j: integer;
    Done:Boolean;
  begin
    Done:=false;
    if AItem = nil then
      exit;
    for j := 0 to AItem.Count-1 do
      if AItem.Items[j] <> nil then
        if AItem.Items[j].IsSelected then
        begin
          Done:=true;
          AddFiveChildItems(AItem.Items[j]);
          AddSubItemsToChild(AItem.Items[j]);
        end;
  if Not Done then
    for j := 0 to AItem.Count-1 do
      if AItem.Items[j] <> nil then
          AddSubItemsToChild(AItem.Items[j]);
  end;

Var
  i: integer;
  Done:Boolean;
begin
  Done:=False;
  for i := 0 to TreeView1.Count - 1 do
    if TreeView1.Items[i] <> nil then
      if TreeView1.Items[i].IsSelected then
      begin
        Done:=true;
        AddFiveChildItems(TreeView1.Items[i]);
        AddSubItemsToChild(TreeView1.Items[i]);
      end;
  if Not Done then
    for i := 0 to TreeView1.Count - 1 do
     if TreeView1.Items[i] <> nil then
        AddSubItemsToChild(TreeView1.Items[i]);
  UpdateForm;
end;

procedure TForm5.UpdateForm;
begin
  if TreeView1.Count < 3 then
    AddFiveItems;
//  FMXImageList1.AssignImagesTo(TreeView1, CrossRefArray);
  // if TreeView1.item then

end;

end.
