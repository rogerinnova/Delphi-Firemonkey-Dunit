unit TestFporm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Menus, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, FMX.Layouts, FMX.Grid, IsAdvStringGrid, FMX.ListBox,
  IsBitButton, FMX.Edit, FMX.ExtCtrls, FMX.StdCtrls;

type
  TtestCnvterFM = class(TForm)
    MainMenuBar: TMenuBar;
    MnuRunTests: TMenuItem;
    MnuRunConverter: TMenuItem;
    MenuRunConverter: TMenuItem;
    MenuRunPasswordDialogTest: TMenuItem;
    MenuTestDataEntry: TMenuItem;
    MenuTestFindDialog: TMenuItem;
    MenuTestGenReportDialog: TMenuItem;
    MenuRunPasswordVerifyTest: TMenuItem;
    Button1: TButton;
    StyleBook1: TStyleBook;
    ComboBox1: TComboBox;
    ListItem1: TListBoxItem;
    ListItem2: TListBoxItem;
    Edit1: TEdit;
    ComboEdit1: TComboEdit;
    ComboBox2: TComboBox;
    SpeedButton1: TSpeedButton;
    CornerButton1: TCornerButton;
    ClearingEdit1: TClearingEdit;
    NumberBox1: TNumberBox;
    MenuTestTestForm: TMenuItem;
    IsBitButton1: TIsBitButton;
    IsBitButton2: TIsBitButton;
    CheckBox1: TCheckBox;
    procedure MenuRunConverterClick(Sender: TObject);
    procedure MenuRunPasswordDialogTestClick(Sender: TObject);
    procedure MenuTestDataEntryClick(Sender: TObject);
    procedure MenuTestFindDialogClick(Sender: TObject);
    procedure MenuTestGenReportDialogClick(Sender: TObject);
    procedure MenuRunPasswordVerifyTestClick(Sender: TObject);
    procedure IsBitButton2Click(Sender: TObject);
    procedure IsBitButton1Click(Sender: TObject);
    procedure MenuTestTestFormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  testCnvterFM: TtestCnvterFM;

implementation

{$R *.fmx}

uses ISDlgUsrPwdFMX, DFMToFMXFM, ISDlgDataEntryFMX, ISDlgFindFromDbIndexFMX,
  IsArrayLib, FmIsGeneralReportFMX, ISDbGeneralObj, IsDlgUsrPwdVerifyFMX,
  TestDialog;

procedure TtestCnvterFM.IsBitButton1Click(Sender: TObject);
Var
  StrList: TstringList;
  i: integer;
begin
  StrList := TstringList.Create;
  Try
    StrList.AddStrings(ComboBox1.Items);

    for i := 0 to StrList.Count-1 do
      Begin
        if StrList.Objects[i]<> IsBitButton2 then
          raise Exception.Create('Error Message::'+StrList[i]+'  '+IntToStr(i));
      End;
  Finally
   Strlist.Free;
  End;
end;

procedure TtestCnvterFM.IsBitButton2Click(Sender: TObject);
Var
  StrList: TstringList;
  i: integer;
begin
  StrList := TstringList.Create;
  Try
    for i := 1 to 20 do
      StrList.AddObject('Tst ' + IntToStr(i), IsBitButton2);
   ComboBox1.Items.Clear;
   ComboBox1.Items.AddStrings(StrList);
  Finally
   Strlist.Free;
  End;
end;

procedure TtestCnvterFM.MenuRunConverterClick(Sender: TObject);

begin
  if DFMtoFMXConvert = nil then
    DFMtoFMXConvert := TDFMtoFMXConvert.Create(Application);

  DFMtoFMXConvert.Show;
end;

procedure TtestCnvterFM.MenuRunPasswordDialogTestClick(Sender: TObject);
Var
  Dlg: TGetUserPasswordDlg;
begin
  Dlg := TGetUserPasswordDlg.Create(Self);
  try
    Dlg.SetData('OldUser', 'OldPassword', 'Test Dlg', 'User:::', 'Pwd:::');
    If Dlg.Execute then
    begin
      MessageDlg('Password:' + Dlg.EdtPassword.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
      MessageDlg('Username:' + Dlg.EdtUsername.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TtestCnvterFM.MenuRunPasswordVerifyTestClick(Sender: TObject);
Var
  Dlg: TUserPasswordVerifyDlg;
begin
  Dlg := TUserPasswordVerifyDlg.Create(Self);
  try
    Dlg.SetData('OldUser', 'OldPassword', 'Test Dlg', 'User:::', 'Pwd:::');
    If Dlg.Execute then
    begin
      MessageDlg('Password:' + Dlg.EdtPassword.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
      MessageDlg('Username:' + Dlg.EdtUsername.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TtestCnvterFM.MenuTestDataEntryClick(Sender: TObject);
Var
  Dlg: TDlgtVerifiyData;
begin
  Dlg := TDlgtVerifiyData.Create(Self);
  try
    Dlg.SetData(dtDollar, '$55.66', 'Edit Dollars', 'Cost per Item');
    if Dlg.Execute then
    begin
      MessageDlg('Value:' + Dlg.EdtData.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
    end;
    Dlg.SetData(dtUppercase, 'abcDE', 'Edit Uppercase', 'Uppercase');
    if Dlg.Execute then
    begin
      MessageDlg('Uppercase:' + Dlg.EdtData.Text, TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TtestCnvterFM.MenuTestFindDialogClick(Sender: TObject);
Var
  Dlg: TDlgDbSelectFromArrayForm;
  TwoDArraySource: TTwoDArrayOfAnsiString;
  i, j: integer;
begin
  SetLength(TwoDArraySource, 20);
  for i := 0 to 19 do
  begin
    SetLength(TwoDArraySource[i], 20);
    for j := 0 to 19 do
      TwoDArraySource[i, j] := 'dd:' + IntToStr(i) + ' fgd:' + IntToStr(j) +
        'kkkkkkkkkkkkkkkkkklllllllllll hhhhhhhhh';
  end;
  Dlg := TDlgDbSelectFromArrayForm.CreateDlg;
  try
    Dlg.AllowMultipleSelect := false;
    Dlg.HeaderArrayString :=
      'hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3|nnnn4|hhh1|jjj2|kkkk3'
      + '|nnnn4|hhh1|jjj2|kkkk3|nnnn4';
    Dlg.HeaderSeparator := '|';
    Dlg.ExplanationString := 'Select a Directory for Action';
    // Dlg.DbLink:=Database;
    Dlg.TwoDArraySource := TwoDArraySource;
    if Dlg.Execute then
    begin

    end;
  finally
    Dlg.Free;
  end;
end;

procedure TtestCnvterFM.MenuTestGenReportDialogClick(Sender: TObject);
Var
  Dlg: TFormISGeneralReport;
  TwoDArraySource: TTwoDArrayOfAnsiString;
  IndexArray: TArrayofLongWord;
  i, j: integer;
begin
  SetLength(TwoDArraySource, 20);
  SetLength(IndexArray, 0);
  for i := 0 to 19 do
  begin
    SetLength(TwoDArraySource[i], 20);
    for j := 0 to 19 do
      TwoDArraySource[i, j] := 'dd:' + IntToStr(i) + ' fgd:' + IntToStr(j)
        + ' jkjk';
  end;
  Dlg := TFormISGeneralReport.Create(Self);
  try
    // Dlg.AllowMultipleSelect:=false;
    Dlg.SetHeaders('hhh1|jjj2|kkkk3|nnnn4', '|');
    Dlg.Caption := 'Test Report Page';
    // Dlg.ThisDb:=TAddressDb(Self);
    //Dlg.IgnorDb := True;
    Dlg.SetReportData(TwoDArraySource, IndexArray, taLeftJustify, false);
    Dlg.Show;
  Except
    Dlg.Free;
  end;
end;

procedure TtestCnvterFM.MenuTestTestFormClick(Sender: TObject);
Var
  Dlg:TDlgTestFMXLib;
begin
  Dlg:=TDlgTestFMXLib.CreateWithObject(nil,Self);
  Dlg.NoLinkNeeded:=true;
  try
    Dlg.Execute;
  finally
    Dlg.Free;
  end;

end;

end.
