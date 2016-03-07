unit FMXTreeViewLib;

interface
uses
  //WinAPi.Windows,
  FMX.Styles.Objects,
  FMX.Graphics, FMX.Types, FMX.Objects, FMX.TreeView, FMX.ListBox,
  FMX.Layouts, Sysutils, ISFMXImageList;
Type
  TTreeNode = Class(TTreeViewItem)
  protected
    procedure ApplyStyle; override;
  private
    FSelected: boolean;
    FData: integer;
    FParentNode: TObject;
    FStateImages, FImages: TFMXImageList;
    FStateIndex, FImageIndex, FSelectedIndex: integer;
    procedure SetImageIndex(const Value: integer);
    procedure SetStateIndex(const Value: integer);
  Public
    Function HasChildren: boolean;
    Function GetNextSibling: TTreeNode;
    // Next at this level
    Function GetPrevSibling: TTreeNode;
    // Prev at this level
    Function GetFirstNode: TTreeNode;
    // First node as siblings
    Function GetLastNode: TTreeNode;
    // Last node as siblings
    Function GetFirstChild: TTreeNode;
    Function GetLastChild: TTreeNode;
    Function GetNextChild(ARef: TTreeNode): TTreeNode;
    Function GetPrevChild(ARef: TTreeNode): TTreeNode;
    Function GetNext: TTreeNode;
    // Get Next Is the Next By Global Index
    Function GetPrev: TTreeNode;
    // Get Next Is the Prev By Global Index
    procedure MakeVisible;
    property Selected: boolean read FSelected write FSelected;
    property StateIndex: integer read FStateIndex write SetStateIndex;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
    property SelectedIndex: integer read FSelectedIndex write FSelectedIndex;
    property NodeInt: integer read FData write FData;
    property ParentNode: TObject read FParentNode;
  End;


Procedure ClearTreeView(ATree: TTreeView);
Function FmxTreeViewAddChild(ATree: TTreeView; AParentNode: TTreeViewItem;
  const S: string; AImages, AStateImages: TFMXImageList): TTreeNode;

implementation
Function FmxTreeViewAddChild(ATree: TTreeView; AParentNode: TTreeViewItem;
  const S: string; AImages, AStateImages: TFMXImageList): TTreeNode;

Var
  NewItem: TTreeNode;
Begin
  NewItem := TTreeNode.Create(ATree);
  NewItem.Text := S;
  if AParentNode <> nil then
  begin
    NewItem.Parent := AParentNode;
    NewItem.FParentNode := AParentNode;
  end
  else
  begin
    NewItem.Parent := ATree;
    NewItem.FParentNode := ATree;
  end;
  NewItem.NodeInt := -1;
  NewItem.FImages := AImages;
  NewItem.FStateImages := AStateImages;
  // NewItem.StyleLookup:='TreeNodeStyle' is the default;
  Result := NewItem;
end;

Procedure ClearTreeView(ATree: TTreeView);
Var
  Item: TTreeViewItem;
begin
  While ATree.Count < 0 do
  Begin // Clear;
    if ATree.Items[0] is TTreeViewItem then
      Item := ATree.Items[0] as TTreeViewItem
    else
      Item := nil;
    ATree.Items[0].Parent := nil;
    Item.Free;
  End;

end;
{ TTreeNode }

procedure TTreeNode.ApplyStyle;
Var
  T: TFMXObject;
  Image: TBitMap;

begin
  inherited;
  if FStateImages <> nil then
    Try
      T := FindStyleResource('stateimage');
      if (T <> nil) and (T is TImage) then
      Begin
        Image := FStateImages.Image[FStateIndex];
        TImage(T).Bitmap.Assign(Image);
      End;
    except
    end;

  if FImages <> nil then
    Try
      T := FindStyleResource('image');
      if (T <> nil) and (T is TImage) then
      Begin
        if Selected then
          Image := FImages.Image[FSelectedIndex]
        else
          Image := FImages.Image[FImageIndex];
        TImage(T).Bitmap.Assign(Image);
      End;
    Except
    end;
end;

function TTreeNode.GetFirstChild: TTreeNode;
begin
  Result := nil;
  If Count > 0 then
    Result := Items[0] as TTreeNode;
end;

function TTreeNode.GetFirstNode: TTreeNode;
begin
  Result := nil;
  if FParentNode is TTreeNode then
    Result := (FParentNode as TTreeNode).GetFirstChild
  else if (FParentNode is TTreeView) then
    if (TTreeView(FParentNode).Count > 0) then
      Result := (FParentNode as TTreeView).Items[0] as TTreeNode;
end;

function TTreeNode.GetLastChild: TTreeNode;
begin
  Result := nil;
  If Count > 0 then
    Result := Items[Count - 1] as TTreeNode;
end;

function TTreeNode.GetLastNode: TTreeNode;
begin
  Result := nil;
  if FParentNode is TTreeNode then
    Result := (FParentNode as TTreeNode).GetLastChild
  else if FParentNode is TTreeView then
    if (TTreeView(FParentNode).Count > 0) then
      Result := TTreeView(FParentNode).Items[TTreeView(FParentNode).Count - 1]
        as TTreeNode;
end;

function TTreeNode.GetNext: TTreeNode;
begin
  Result := nil;
  if Count > 0 then
    Result := Items[0] as TTreeNode
  else
    Result := GetNextSibling;

  if Result = nil then
    if FParentNode is TTreeNode then
      Result := (FParentNode as TTreeNode).GetNextSibling
    Else if (FParentNode is TTreeView) and
      (Index + 1 < TTreeView(FParentNode).Count) then
      Result := TTreeView(FParentNode).Items[Index + 1] as TTreeNode;
end;

function TTreeNode.GetNextChild(ARef: TTreeNode): TTreeNode;
Var
  NxtNode, ThisNode: TObject;
  Idx: integer;
begin
  NxtNode := nil;
  Result := nil;
  if ARef = nil then
    NxtNode := GetFirstNode
  else
  Begin
    Idx := 0;
    While Not(NxtNode is TTreeNode) and (Idx < Count) do
    begin
      ThisNode := Items[Idx];
      Inc(Idx);
      if ThisNode = ARef then
        While Not(NxtNode is TTreeNode) and (Idx < Count) do
        begin
          NxtNode := Items[Idx];
          Inc(Idx);
        end;
    end;
  End;
  if (NxtNode is TTreeNode) then
    Result := NxtNode as TTreeNode;
end;

function TTreeNode.GetNextSibling: TTreeNode;
var
  NxtNode, ThisNode: TTreeViewItem;
  Idx: integer;
begin
  NxtNode := nil;
  ThisNode := nil;
  Result := nil;
  if FParentNode is TTreeNode then
    Result := (FParentNode as TTreeNode).GetNextChild(Self)
  else if FParentNode is TTreeView then
  begin
    Idx := 0;
    While Not(NxtNode is TTreeNode) and (Idx < TTreeView(FParentNode).Count) do
    begin
      ThisNode := TTreeView(FParentNode).Items[Idx];
      Inc(Idx);
      if ThisNode = Self then
        While Not(NxtNode is TTreeNode) and
          (Idx > TTreeView(FParentNode).Count) do
        begin
          NxtNode := TTreeView(FParentNode).Items[Idx];
          Inc(Idx);
        end;
    end;
  End;
  if (NxtNode is TTreeNode) then
    Result := NxtNode as TTreeNode;
end;

function TTreeNode.GetPrev: TTreeNode;
var
  PrevSibling: TTreeViewItem;
begin
  Result := nil;
  if index > 0 then
  begin
    if FParentNode is TTreeNode then
      Result := (FParentNode as TTreeNode).Items[Index - 1] as TTreeNode
    else if (FParentNode is TTreeView) then
      Result := TTreeView(FParentNode).Items[Index - 1] as TTreeNode;
  end
  else
  Begin
    if FParentNode is TTreeNode then
      PrevSibling := (FParentNode as TTreeNode).GetPrevSibling
    else // if (FParentTreeView <> nil) then
      Result := nil; // index=0 at top of tree
  End;
end;

function TTreeNode.GetPrevChild(ARef: TTreeNode): TTreeNode;
Var
  NxtNode, ThisNode: TObject;
  Idx: integer;
begin
  NxtNode := nil;
  Result := nil;
  if ARef = nil then
    NxtNode := GetLastNode
  else
  Begin
    Idx := Count;
    While Not(NxtNode is TTreeNode) and (Idx > 0) do
    begin
      Dec(Idx);
      ThisNode := Items[Idx];
      if ThisNode = ARef then
        While Not(NxtNode is TTreeNode) and (Idx > 0) do
        begin
          Dec(Idx);
          NxtNode := Items[Idx];
        end;
    end;
  End;
  if (NxtNode is TTreeNode) then
    Result := NxtNode as TTreeNode;
end;

function TTreeNode.GetPrevSibling: TTreeNode;
var
  NxtNode, ThisNode: TTreeViewItem;
  Idx: integer;
begin
  NxtNode := nil;
  ThisNode := nil;
  Result := nil;
  if FParentNode is TTreeNode then
    Result := (FParentNode as TTreeNode).GetPrevChild(Self)
  else if FParentNode is TTreeView then
  begin
    Idx := TTreeView(FParentNode).Count;
    While Not(NxtNode is TTreeNode) and (Idx > 0) do
    begin
      Dec(Idx);
      ThisNode := TTreeView(FParentNode).Items[Idx];
      if ThisNode = Self then
        While Not(NxtNode is TTreeNode) and (Idx > 0) do
        begin
          Dec(Idx);
          NxtNode := TTreeView(FParentNode).Items[Idx];
        end;
    end;
  End;
  if (NxtNode is TTreeNode) then
    Result := NxtNode as TTreeNode;
end;

function TTreeNode.HasChildren: boolean;
begin
  Result := Count > 0;
end;

procedure TTreeNode.MakeVisible;
begin
  Visible := True;
  ApplyStyleLookup;
end;

procedure TTreeNode.SetImageIndex(const Value: integer);
begin
  if FImageIndex <> Value then
    NeedStyleLookup; // Activates ApplyStyleLookup
  FImageIndex := Value;
  ApplyStyleLookup;
end;

procedure TTreeNode.SetStateIndex(const Value: integer);
begin
  if FStateIndex <> Value then
    NeedStyleLookup; // Activates ApplyStyleLookup
  FStateIndex := Value;
  ApplyStyleLookup;
end;

end.
