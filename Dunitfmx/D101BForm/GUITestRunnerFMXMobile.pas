{ $Id: GUITestRunnerFMX.pas 37 2011-04-15 19:43:36Z medington $ }
{: DUnit: An XTreme testing framework for Delphi programs.
   @author  The DUnit Group.
   @version $Revision: 37 $ 2001/03/08 uberto
}
(*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is DUnit.
 *
 * The Initial Developers of the Original Code are Kent Beck, Erich Gamma,
 * and Juancarlo A±ez.
 * Portions created The Initial Developers are Copyright (C) 1999-2000.
 * Portions created by The DUnit Group are Copyright (C) 2000-2004.
 * All rights reserved.
 *
 * Contributor(s):
 * Kent Beck <kentbeck@csi.com>
 * Erich Gamma <Erich_Gamma@oti.com>
 * Juanco Añez <juanco@users.sourceforge.net>
 * Chris Morris <chrismo@users.sourceforge.net>
 * Jeff Moore <JeffMoore@users.sourceforge.net>
 * Kenneth Semeijn <dunit@designtime.demon.nl>
 * Uberto Barbini <uberto@usa.net>
 * Brett Shearer <BrettShearer@users.sourceforge.net>
 * Kris Golko <neuromancer@users.sourceforge.net>
 * The DUnit group at SourceForge <http://dunit.sourceforge.net>
 *
 *)
unit GUITestRunnerFMXMobile;
interface

uses 
TestFramework,
System.IOUtils,
Math,
FMX.Controls,
FMX.Forms,
FMX.StdCtrls,
FMX.Menus,
FMX.ActnList,
FMX.Types,
System.Classes,
IniFiles,
//ToolWin,
DUnitConsts,
System.Actions,
System.SysUtils,
System.Types,
System.UITypes,
System.Variants,
System.UIConsts,
{$IfDef NextGen}
Posix.Unistd,
{$Endif}
FMXListBoxLib, FMXTreeViewLib,
FMX.Layouts, FMX.ListView.Types, FMX.Memo, FMX.ListView, FMX.TreeView,
  ISFMXImageList, FMX.ListBox, FMX.Objects, FMX.ScrollBox,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList;



const
  {: Section of the dunit.ini file where GUI information will be stored }
  cnConfigIniSection = 'GUITestRunner Config';

  {: Color constants for the progress bar and failure details panel }
  clOK      = claChartreuse;//ClaGreen ;
  clFAILURE = claFuchsia;
  clERROR   = claRed;

  {: Indexes of the color images used in the test tree and failure list }
  imgNONE     = 0;
  imgRUNNING  = 1;
  imgRUN      = 2;
  imgHASPROPS = 3;
  imgFAILED   = 4;
  imgERROR    = 5;

  {: Indexes of the images used for test tree checkboxes }
  imgDISABLED        = 1;
  imgPARENT_DISABLED = 2;
  imgENABLED         = 3;

type
  {: Function type used by the TDUnitDialog.ApplyToTests method
     @param item  The ITest instance on which to act
     @return true if processing should continue, false otherwise
  }


  TTestFunc = function (item :ITest):Boolean of object;

  TMobileGUITestRunner = class(TForm, ITestListener, ITestListenerX)
    //StateImages: TImageList;
    //RunImages: TImageList;
    DialogActions: TActionList;
    SelectAllAction: TAction;
    DeselectAllAction: TAction;
    SelectFailedAction: TAction;
    SaveConfigurationAction: TAction;
    AutoSaveAction: TAction;
    RestoreSavedAction: TAction;
    BodyPanel: TPanel;
    ErrorBoxVisibleAction: TAction;
    TopPanel: TPanel;
    TreePanel: TPanel;
    TestTree: TTreeView;
    ResultsPanel: TPanel;
    ProgressPanel: TPanel;
    ErrorBoxPanel: TPanel;
    ScorePanel: TPanel;
    ScoreBar: TProgressBar;
    HideTestNodesAction: TAction;
    HideTestNodesOnOpenAction: TAction;
    ExpandAllNodesAction: TAction;
    lblTestTree: TLabel;
    RunAction: TAction;
    ExitAction: TAction;
    BreakOnFailuresAction: TAction;
    ShowTestedNodeAction: TAction;
    CopyMessageToClipboardAction: TAction;
    LbProgress: TLabel;
    ErrorMessageRTF: TMemo;
    SelectCurrentAction: TAction;
    DeselectCurrentAction: TAction;
    StopAction: TAction;
    ToolBar1: TToolBar;
    SelectAllButton: TSpeedButton;
    DeselectAllButton: TSpeedButton;
    SelectFailedButton: TSpeedButton;
    SelectCurrentButton: TSpeedButton;
    DeselectCurrentButton: TSpeedButton;
    RunAllButton: TSpeedButton;
    StoplButton: TSpeedButton;
    Alt_R_RunAction: TAction;
    Alt_S_StopAction: TAction;
    CopyProcnameToClipboardAction: TAction;
    RunSelectedTestAction: TAction;
    RunSelectedTestButton: TSpeedButton;
    GoToNextSelectedTestAction: TAction;
    GoToPrevSelectedTestAction: TAction;
    FailIfNoChecksExecutedAction: TAction;
    FailTestCaseIfMemoryLeakedAction: TAction;
    ShowTestCasesWithRunTimePropertiesAction: TAction;
    WarnOnFailTestOverrideAction: TAction;
    TestCasePropertiesAction: TAction;
    PropertyPopUpAction: TAction;
    RunSelectedTestAltAction: TAction;
    IgnoreMemoryLeakInSetUpTearDownAction: TAction;
    ReportMemoryLeakTypeOnShutdownAction: TAction;
    RunImages: TFMXImageList;
    StateImages: TFMXImageList;
    ActionImages: TFMXImageList;
    StyleBook1: TStyleBook;
    TopProgressPanel: TPanel;
    ProgressBar: TProgressBar;
    LblProgress: TLabel;
    LblScore: TLabel;
    LbxResults: TListBox;
    ListBoxItem1: TListBoxItem;
    LbxFailure: TListBox;
    RectResultBar: TRectangle;
    Panel1: TPanel;
    FailIfNoChecksExecuted: TCheckBox;
    FailTestCaseIfMemoryLeaked: TCheckBox;
    IgnoreMemoryLeakInSetUpTearDown: TCheckBox;
    WarnOnFailTestOverride: TCheckBox;
    ShowTestCaseswithRunTimeProperties: TCheckBox;
    ImageList1: TImageList;
    PnlControl: TPanel;
    BtnUp: TButton;
    BtnDn: TButton;
    Splitter1: TSplitter;
    TBtnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TestTreeClick(Sender: TObject);
    procedure FailureListViewClick(Sender: TObject);
    procedure TestTreeKeyPress(Sender: TObject; var Key: Char);
    procedure SelectAllActionExecute(Sender: TObject);
    procedure DeselectAllActionExecute(Sender: TObject);
    procedure SelectFailedActionExecute(Sender: TObject);
    procedure SaveConfigurationActionExecute(Sender: TObject);
    procedure RestoreSavedActionExecute(Sender: TObject);
    procedure AutoSaveActionExecute(Sender: TObject);
    procedure ErrorBoxVisibleActionExecute(Sender: TObject);
    procedure HideTestNodesActionExecute(Sender: TObject);
    procedure HideTestNodesOnOpenActionExecute(Sender: TObject);
    procedure ExpandAllNodesActionExecute(Sender: TObject);
    procedure RunActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure BreakOnFailuresActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowTestedNodeActionExecute(Sender: TObject);
    procedure CopyMessageToClipboardActionExecute(Sender: TObject);
    procedure RunActionUpdate(Sender: TObject);
    procedure CopyMessageToClipboardActionUpdate(Sender: TObject);
    procedure SelectCurrentActionExecute(Sender: TObject);
    procedure DeselectCurrentActionExecute(Sender: TObject);
    procedure StopActionExecute(Sender: TObject);
    procedure StopActionUpdate(Sender: TObject);
   //procedure TestTreeChange(Sender: TObject; Node: TTreeNode);
    procedure CopyProcnameToClipboardActionExecute(Sender: TObject);
    procedure CopyProcnameToClipboardActionUpdate(Sender: TObject);
    procedure RunSelectedTestActionExecute(Sender: TObject);
    procedure RunSelectedTestActionUpdate(Sender: TObject);
    procedure TestTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GoToNextSelectedTestActionExecute(Sender: TObject);
    procedure GoToPrevSelectedTestActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FailIfNoChecksExecutedActionExecute(Sender: TObject);
    procedure FailTestCaseIfMemoryLeakedActionExecute(Sender: TObject);
    procedure ShowTestCasesWithRunTimePropertiesActionExecute(
      Sender: TObject);
    procedure WarnOnFailTestOverrideActionExecute(Sender: TObject);
    procedure TestCasePropertiesActionExecute(Sender: TObject);
    procedure Previous1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure TestTreeChange(Sender: TObject);
    procedure LbxFailureDblClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDnClick(Sender: TObject);
    procedure ScorePanelClick(Sender: TObject);
    procedure TBtnExitClick(Sender: TObject);
{    procedure TestCasePropertiesMeasureItem(Sender: TObject;
      ACanvas: TCanvas; var Width, Height: Integer);
    procedure TestCasePropertiesDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure FailNoCheckExecutedMenuItemDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure AllowedLeakSizeMemuItemDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure FailsOnMemoryRecoveryMenuItemDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure FailsOnMemoryLeakMenuItemDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure pmTestTreePopup(Sender: TObject);
    procedure FailNoCheckExecutedMenuItemClick(Sender: TObject);
    procedure AllowedLeakSizeMemuItemClick(Sender: TObject);
    procedure FailsOnMemoryLeakMenuItemClick(Sender: TObject);
    procedure FailsOnMemoryRecoveryMenuItemClick(Sender: TObject);
    procedure RunSelectedTestAltActionExecute(Sender: TObject);
    procedure Previous1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure RunSelectedTest1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure Next1DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure ReportMemoryLeakTypeOnShutdownActionExecute(Sender: TObject);
    procedure IgnoreMemoryLeakInSetUpTearDownActionExecute(
      Sender: TObject);
    procedure TestCaseIgnoreSetUpTearDownLeaksMenuItemClick(Sender: TObject);
    procedure TestCaseIgnoreSetUpTearDownLeaksMenuItemDrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);}
  private
    FNoCheckExecutedPtyOverridden: Boolean;
    FMemLeakDetectedPtyOverridden: Boolean;
    FIgnoreSetUpTearDownLeakPtyOverridden: Boolean;
    FPopupY: Integer;
    FPopupX: Integer;
    FProgressListItem:TListBoxItem;
    procedure ResetProgress;
    procedure ResetTestTreeView;
    Procedure TreeNodeClick(Sender:TObject);
    Function IniFileDirectory:String;
{    procedure MenuLooksInactive(ACanvas: TCanvas; ARect: TRect; Selected: Boolean;
      ATitle: string; TitlePosn: UINT; PtyOveridesGUI: boolean);
    procedure MenuLooksActive(ACanvas: TCanvas; ARect: TRect; Selected: Boolean;
      ATitle: string; TitlePosn: UINT);}
   // function  GetPropertyName(const Caption: string): string;
  protected
    FSuite:         ITest;
    FTestResult:    TTestResult;
    FRunning:       Boolean;
    FTests:         TInterfaceList;
    FSelectedTests: TInterfaceList;
    FTotalTime:     Int64;
    FRunTimeStr:    string;
    FNoChecksStr:   string;
    FMemLeakStr:    string;
    FMemGainStr:    string;
    FMemBytesStr:   string;
    FIgnoreLeakStr: string;
    FBytes:         string;
    FErrorCount:    Integer;
    FFailureCount:  Integer;
    FStrMaxLen:     Integer;
    FValMaxLen:     Integer;
    FUpdateTimer:   TTimer;
    FTimerExpired:  Boolean;
    FTotalTestsCount: Integer;

    procedure Setup;
    procedure SetUpStateImages;
    procedure SetSuite(value: ITest);
    procedure ClearResult;
    procedure DisplayFailureMessage(Item :TListBoxItem);
    procedure ClearFailureMessage;

    function  AddFailureItem(failure: TTestFailure): TListBoxItem;
    procedure UpdateStatus(const fullUpdate:Boolean);

    procedure FillTestTree(RootNode: TTreeNode; ATest: ITest); overload;
    procedure FillTestTree(ATest: ITest);                      overload;

    procedure UpdateNodeImage(node: TTreeNode);
    procedure UpdateNodeState(node: TTreeNode);
    procedure SetNodeState(node: TTreeNode; enabled :boolean);
    procedure SwitchNodeState(node: TTreeNode);
    procedure UpdateTestTreeState;

    procedure MakeNodeVisible(node :TTreeNode);
    procedure SetTreeNodeImage(Node :TTreeNode; imgIndex :Integer);
    procedure SelectNode(node: TTreeNode);

    function  NodeToTest(node :TTreeNode) :ITest;
    function  TestToNode(test :ITest) :TTreeNode;
    function  SelectedTest :ITest;
    procedure ListSelectedTests;

    function  EnableTest(test :ITest) : boolean;
    function  DisableTest(test :ITest) : boolean;
    procedure ApplyToTests(root :TTreeNode; const func :TTestFunc);

    procedure EnableUI(enable :Boolean);
    procedure RunTheTest(aTest: ITest);

    procedure InitTree; virtual;

    function  IniFileName :string;
    function  GetIniFile( const FileName : string ) :
 {$IFDEF MSWINDOWS}
tCustomIniFile;
{$ELSE}
TMemIniFile;
{$Endif}

    procedure LoadFormPlacement;
    procedure SaveFormPlacement;

    procedure SaveConfiguration;
    procedure LoadConfiguration;

    procedure LoadSuiteConfiguration;
    procedure AutoSaveConfiguration;

    function NodeIsGrandparent(ANode: TTreeNode): boolean;
    procedure CollapseNonGrandparentNodes(RootNode: TTreeNode);

    procedure ClearStatusMessage;

    procedure CopyTestNametoClipboard(ANode: TTreeNode);

    procedure SetupCustomShortcuts;
    procedure SetupGUINodes;

    function SelectNodeIfTestEnabled(ANode: TTreeNode): boolean;

    procedure OnUpdateTimer(Sender: TObject);
  public
    {: implement the ITestListener interface }
    procedure AddSuccess(test: ITest);
    procedure AddError(failure: TTestFailure);
    procedure AddFailure(failure: TTestFailure);
    function  ShouldRunTest(test :ITest):boolean;
    procedure StartSuite(suite: ITest); virtual;
    procedure EndSuite(suite: ITest); virtual;
    procedure StartTest(test: ITest); virtual;
    procedure EndTest(test: ITest); virtual;
    procedure TestingStarts;
    procedure TestingEnds(TestResult :TTestResult);
    procedure Status(test :ITest; const Msg :string);
    procedure Warning(test :ITest; const Msg :string);

    {: The number of errors in the last test run }
    property ErrorCount: Integer read FErrorCount;
    {: The number of failures in the last test run }
    property FailureCount: Integer read FFailureCount;
    {: The test suite to be run in this runner }
    property Suite: ITest read FSuite write SetSuite;
    {: The result of the last test run }
    property TestResult : TTestResult read FTestResult write FTestResult;

//    class procedure RunTest(test: ITest);
//    class procedure RunRegisteredTests;
  end;

Var MobileGUITestRunner:TMobileGUITestRunner;

implementation
{$IFDEF MSWINDOWS}
 Uses
{$IFDEF FASTMM}
  {$IFNDEF CLR}
    {$IFNDEF ManualLeakReportingControl}
      {$I FastMM4Options.inc}
    {$ENDIF}
    FastMM4,
  {$ENDIF}
{$ENDIF}
  Registry;
{$ELSE}
  Uses ISProcCl;
{$ENDIF}

//  Clipbrd;

{$BOOLEVAL OFF}  // Required or you'll get an AV
{$R *.FMX}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}

{ TMobileGUITestRunner }

procedure TMobileGUITestRunner.InitTree;
begin
  FTests.Clear;
  FillTestTree(Suite);
  Setup;
  if HideTestNodesOnOpenAction.Checked then
    HideTestNodesAction.Execute
  else
    ExpandAllNodesAction.Execute;
  if TestTree.count>0 then
      TestTree.Selected := TestTree.Items[0];
   //Mod
   //TestTree.Selected := TestTree.Items.GetFirstNode;
end;

function TMobileGUITestRunner.NodeToTest(Node: TTreeNode): ITest;
var
  idx: Integer;
begin
  assert(assigned(Node));

  idx  := Node.NodeInt;
  assert((idx >= 0) and (idx < FTests.Count));
  result := FTests[idx] as ITest;
end;

procedure TMobileGUITestRunner.OnUpdateTimer(Sender: TObject);
begin
  FTimerExpired := True;
  FUpdateTimer.Enabled := False;
end;

function TMobileGUITestRunner.TestToNode(test: ITest): TTreeNode;
begin
  assert(assigned(test));

  Result := test.GUIObject as TTreeNode;

  assert(assigned(Result));
end;

function TMobileGUITestRunner.ShouldRunTest(test: ITest): boolean;
begin
  if FSelectedTests = nil then
    Result := test.Enabled
  else
    Result := FSelectedTests.IndexOf(test as ITest) >= 0;
end;

procedure TMobileGUITestRunner.StartTest(test: ITest);
var
  node :TTreeNode;
begin
  assert(assigned(TestResult));
  assert(assigned(test));
  node := TestToNode(test);
  assert(assigned(node));
  SetTreeNodeImage(node, imgRunning);
  if ShowTestedNodeAction.Checked then
  begin
    MakeNodeVisible(node);
    TestTree.ApplyStyleLookup;
  end;
  ClearStatusMessage;
  UpdateStatus(False);
end;

procedure TMobileGUITestRunner.EndTest(test: ITest);
begin
  UpdateStatus(False);
end;

procedure TMobileGUITestRunner.TestingStarts;
begin
  FTotalTime := 0;
  UpdateStatus(True);
  //TProgressBarCrack(ScoreBar).Brush.Color := clagrey;
  //TProgressBarCrack(ScoreBar).RecreateWnd;
end;

procedure TMobileGUITestRunner.AddSuccess(test: ITest);
var
  OverridesGUI: Boolean;
  HasRunTimePropsSet: Boolean;
begin
  assert(assigned(test));
  if not IsTestMethod(test) then
    SetTreeNodeImage(TestToNode(Test), imgRun)
  else
  begin
    OverridesGUI :=
      ((FailIfNoChecksExecuted.IsChecked and not Test.FailsOnNoChecksExecuted) or
       (FailTestCaseIfMemoryLeaked.IsChecked and not Test.FailsOnMemoryLeak)) or
       (FailTestCaseIfMemoryLeaked.IsChecked and Test.IgnoreSetUpTearDownLeaks and
         not IgnoreMemoryLeakInSetUpTearDown.IsChecked);
    HasRunTimePropsSet :=
      ((Test.FailsOnNoChecksExecuted and not FailIfNoChecksExecuted.IsChecked) or
       (Test.FailsOnMemoryLeak and not FailTestCaseIfMemoryLeaked.IsChecked) or
       (FailTestCaseIfMemoryLeaked.IsChecked and Test.IgnoreSetUpTearDownLeaks) or
       (Test.AllowedMemoryLeakSize <> 0));

    if OverridesGUI then
      FTestResult.Overrides := FTestResult.Overrides + 1;

    if (WarnOnFailTestOverride.IsChecked and OverridesGUI) or
       (ShowTestCaseswithRunTimeProperties.IsChecked and HasRunTimePropsSet) then
      SetTreeNodeImage(TestToNode(Test), imgHASPROPS)
    else
      SetTreeNodeImage(TestToNode(Test), imgRun);
  end;
  UpdateStatus(True);
  //UpdateStatus(False);
end;

procedure TMobileGUITestRunner.AddError(failure: TTestFailure);
var
  ListItem: TListBoxItem;
begin
  ListItem := AddFailureItem(failure);
  RunImages.AssignAnImageTo(ListItem,imgERROR);
  RectResultBar.Fill.Color := clERROR;
  SetTreeNodeImage(TestToNode(failure.failedTest), imgERROR);
  UpdateStatus(True);
  //UpdateStatus(False);
end;

procedure TMobileGUITestRunner.AddFailure(failure: TTestFailure);
var
  ListItem: TListBoxItem;
begin
 ListItem:=AddFailureItem(failure);
 RunImages.AssignAnImageTo(ListItem,imgFAILED);
 if TestResult.errorCount = 0 then
  RectResultBar.Fill.Color := clFAILURE;
  SetTreeNodeImage(TestToNode(failure.failedTest), imgFAILED);
  UpdateStatus(True);
  //UpdateStatus(False);
end;

function TMobileGUITestRunner.IniFileDirectory: String;
begin
   Result:=
   System.IOUtils.TPath.Combine(
      System.IOUtils.TPath.GetHomePath , 'DUnitMob');
   if not DirectoryExists(Result) then
     ForceDirectories(Result);
end;

function TMobileGUITestRunner.IniFileName: string;
Var
  TEST_INI_FILE,Exenm:String;
begin
 Exenm:=ParamStr(0);
 Exenm:=ExtractFileName(Exenm);
 if Exenm.Length>4 then
    TEST_INI_FILE:=ChangeFileExt(Exenm,'.ini')
   else
    TEST_INI_FILE:= 'dunit.ini';

 Result:= System.IOUtils.TPath.Combine(IniFileDirectory , TEST_INI_FILE);
(*
{$Ifdef MSWINDOWS}
    result := ExtractFilePath(ParamStr(0)) + TEST_INI_FILE;
{$ELSE}
    result:=ExeFileDirectory + TEST_INI_FILE;
{$ENDIF}    *)
end;

procedure TMobileGUITestRunner.LoadFormPlacement;
begin
  with GetIniFile( IniFileName ) do
  try
    Self.SetBounds(
                   ReadInteger(cnConfigIniSection, 'Left',   Left),
                   ReadInteger(cnConfigIniSection, 'Top',    Top),
                   ReadInteger(cnConfigIniSection, 'Width',  Width),
                   ReadInteger(cnConfigIniSection, 'Height', Height)
                   );
    if ReadBool(cnConfigIniSection, 'Maximized', False ) then
      WindowState := TWindowState.wsMaximized;
  finally
    Free;
  end;
end;

procedure TMobileGUITestRunner.SaveFormPlacement;
begin
  with GetIniFile(IniFileName) do
    try
      WriteBool(cnConfigIniSection, 'AutoSave', AutoSaveAction.Checked);

      if WindowState <> TWindowState.wsMaximized then
      begin
        WriteInteger(cnConfigIniSection, 'Left',   Left);
        WriteInteger(cnConfigIniSection, 'Top',    Top);
        WriteInteger(cnConfigIniSection, 'Width',  Width);
        WriteInteger(cnConfigIniSection, 'Height', Height );
      end;

      WriteBool(cnConfigIniSection, 'Maximized', WindowState = TWindowState.wsMaximized );
    finally
      Free
    end;
end;



procedure TMobileGUITestRunner.ScorePanelClick(Sender: TObject);
begin
  if ResultsPanel.Height>20 then
    Begin
    ResultsPanel.Height:=20;
    ErrorBoxPanel.Height:=2;
    LbxResults.Height:=2;
    TopProgressPanel.Visible:=false;
    ProgressPanel.Height:=10;
    End
   else
   Begin
    LbxResults.Height:=59;
    TopProgressPanel.Visible:=True;
    ProgressPanel.Height:=43;
    ErrorBoxPanel.Height:=43;
    ResultsPanel.Height:=TopPanel.Height -3 * Toolbar1.Height;
   End;
end;

procedure TMobileGUITestRunner.LoadConfiguration;
begin
LoadFormPlacement;

{
Paul,

Have a look at
  System.IOUtils.TPath.GetHomePath

This works on different platforms.

Regards,
  Peter Evans
}


  LoadSuiteConfiguration;
  with GetIniFile(IniFileName) do
  try
    with AutoSaveAction do
      Checked := ReadBool(cnConfigIniSection, 'AutoSave', Checked);

    { center splitter location }
      ResultsPanel.Height := ReadFloat(cnConfigIniSection, 'ResultsPanel.Height',(ResultsPanel.Height));

    { error splitter location }
      ErrorBoxPanel.Height := ReadFloat(cnConfigIniSection, 'ErrorMessage.Height', (ErrorBoxPanel.Height));
    with ErrorBoxVisibleAction do
      Checked := ReadBool(cnConfigIniSection, 'ErrorMessage.Visible', Checked);

    ErrorBoxPanel.Visible    := ErrorBoxVisibleAction.Checked;

    { failure list configuration }
    {with FailureListView do begin
      for i := 0 to Columns.Count-1 do
      begin
        Columns[i].Width := Max(4, ReadInteger(cnConfigIniSection,
                                        Format('FailureList.ColumnWidth[%d]', [i]),
                                        Columns[i].Width)
                                        );
      end;
    end; }

    { other options }
    HideTestNodesOnOpenAction.Checked := ReadBool(cnConfigIniSection,
      'HideTestNodesOnOpen', HideTestNodesOnOpenAction.Checked);
    BreakOnFailuresAction.Checked := ReadBool(cnConfigIniSection,
      'BreakOnFailures', BreakOnFailuresAction.Checked);
    FailIfNoChecksExecutedAction.Checked := ReadBool(cnConfigIniSection,
      'FailOnNoChecksExecuted', FailIfNoChecksExecutedAction.Checked);
    FailTestCaseIfMemoryLeakedAction.Checked := ReadBool(cnConfigIniSection,
      'FailOnMemoryLeaked', FailTestCaseIfMemoryLeakedAction.Checked);
    IgnoreMemoryLeakInSetUpTearDownAction.Checked := ReadBool(cnConfigIniSection,
      'IgnoreSetUpTearDownLeaks', IgnoreMemoryLeakInSetUpTearDownAction.Checked);
    ReportMemoryLeakTypeOnShutdownAction.Checked := ReadBool(cnConfigIniSection,
      'ReportMemoryLeakTypes', ReportMemoryLeakTypeOnShutdownAction.Checked);
    WarnOnFailTestOverrideAction.Checked := ReadBool(cnConfigIniSection,
      'WarnOnFailTestOverride', WarnOnFailTestOverrideAction.Checked);
    ShowTestedNodeAction.Checked := ReadBool(cnConfigIniSection,
      'SelectTestedNode', ShowTestedNodeAction.Checked);
    FPopupX := ReadInteger(cnConfigIniSection,'PopupX', 350);
    FPopupY := ReadInteger(cnConfigIniSection,'PopupY', 30);
  finally
    Free;
  end;
  if Suite <> nil then
    UpdateTestTreeState;
end;

procedure TMobileGUITestRunner.AutoSaveConfiguration;
begin
  if AutoSaveAction.Checked then
    SaveConfiguration;
end;

procedure TMobileGUITestRunner.SaveConfiguration;

begin
  if Suite <> nil then
    Suite.SaveConfiguration(IniFileName, false, True);


  SaveFormPlacement;

  with GetIniFile(IniFileName) do
  try
    { center splitter location }
    WriteFloat(cnConfigIniSection, 'ResultsPanel.Height',
      (ResultsPanel.Height));

    { error box }
    WriteFloat(cnConfigIniSection, 'ErrorMessage.Height',
      ErrorBoxPanel.Height);
    WriteBool(cnConfigIniSection, 'ErrorMessage.Visible',
      ErrorBoxVisibleAction.Checked);

    { failure list configuration }
   { with FailureListView do begin
      for i := 0 to Columns.Count-1 do
      begin
       WriteInteger( cnConfigIniSection,
                     Format('FailureList.ColumnWidth[%d]', [i]),
                     Columns[i].Width);
      end;
    end; }

    { other options }
    WriteBool(cnConfigIniSection, 'HideTestNodesOnOpen',      HideTestNodesOnOpenAction.Checked);
    WriteBool(cnConfigIniSection, 'BreakOnFailures',          BreakOnFailuresAction.Checked);
    WriteBool(cnConfigIniSection, 'FailOnNoChecksExecuted',   FailIfNoChecksExecutedAction.Checked);
    WriteBool(cnConfigIniSection, 'FailOnMemoryLeaked',       FailTestCaseIfMemoryLeakedAction.Checked);
    WriteBool(cnConfigIniSection, 'IgnoreSetUpTearDownLeaks', IgnoreMemoryLeakInSetUpTearDownAction.Checked);
    WriteBool(cnConfigIniSection, 'ReportMemoryLeakTypes',    ReportMemoryLeakTypeOnShutdownAction.Checked);
    WriteBool(cnConfigIniSection, 'SelectTestedNode',         ShowTestedNodeAction.Checked);
    WriteBool(cnConfigIniSection, 'WarnOnFailTestOverride',   WarnOnFailTestOverrideAction.Checked);
    WriteInteger(cnConfigIniSection, 'PopupX',                FPopupX);
    WriteInteger(cnConfigIniSection, 'PopupY',                FPopupY);

  finally
    Free;
  end;
end;

procedure TMobileGUITestRunner.TestingEnds(TestResult :TTestResult);
begin
  FTotalTime := TestResult.TotalTime;
end;

procedure TMobileGUITestRunner.UpdateNodeState(node: TTreeNode);
var
  test: ITest;
begin
  assert(assigned(node));
  test := NodeToTest(node);
  assert(assigned(test));

  UpdateNodeImage(node);

  if node.HasChildren then
  begin
    node := node.getFirstChild;
    while node <> nil do
    begin
      UpdateNodeState(node);
      node := node.getNextSibling;
    end;
  end;
end;

procedure TMobileGUITestRunner.SetNodeState(node: TTreeNode; enabled :boolean);
var
  MostSeniorChanged :TTreeNode;
begin
   assert(node <> nil);

   // update ancestors if enabling
   NodeToTest(Node).Enabled := enabled;

   MostSeniorChanged := Node;
   if enabled then
   begin
     while Node.Parent is  TTreeNode do
     begin
       Node := Node.Parent As TTreeNode;
       if not NodeToTest(Node).Enabled then
       begin // changed
          NodeToTest(Node).Enabled := true;
          MostSeniorChanged := Node;
          UpdateNodeImage(Node);
       end
     end;
   end;
   TestTree.BeginUpdate;
   try
     UpdateNodeState(MostSeniorChanged);
   finally
     TestTree.EndUpdate;
   end
end;

procedure TMobileGUITestRunner.SwitchNodeState(node: TTreeNode);
begin
   assert(node <> nil);

   SetNodeState(node, not NodeToTest(node).enabled);
end;

procedure TMobileGUITestRunner.UpdateTestTreeState;
var
  node :TTreeNode;
begin
  if TestTree.Count > 0 then
  begin
    TestTree.BeginUpdate;
    try
      node := TestTree.Items[0] as TTreeNode;//.GetFirstNode;
      while node <> nil do
      begin
        UpdateNodeState(node);
        node := node.getNextSibling;
      end
    finally
      TestTree.EndUpdate;
    end;
  end;
end;

procedure TMobileGUITestRunner.UpdateStatus(const fullUpdate:Boolean);
var
  TestNumber: Integer;
  Tst:string;
  ProgressListArray:TColArray;

   function FormatElapsedTime(milli: Int64):string;
   var
     h,nn,ss,zzz: Cardinal;
   begin
     h := milli div 3600000;
     milli := milli mod 3600000;
     nn := milli div 60000;
     milli := milli mod 60000;
     ss := milli div 1000;
     milli := milli mod 1000;
     zzz := milli;
     Result := Format('%d:%2.2d:%2.2d.%3.3d', [h, nn, ss, zzz]);
   end;
begin
  if LbxResults.Items.Count = 0 then
    Exit;
  if not  FUpdateTimer.Enabled  then
       FTimerExpired:=true;

  if fullUpdate then
  begin
    FTotalTestsCount := Suite.countEnabledTestCases;
    if Assigned(Suite) then
      LbxResults.Items[0] := IntToStr(FTotalTestsCount)
    else
      LbxResults.Items[0] := '';
  end;

  TestNumber := 0;
  if TestResult <> nil then
  begin
    // Save the test number as we use it a lot
    TestNumber := TestResult.runCount;

    if fullUpdate or FTimerExpired or ((TestNumber and 15) = 0) then
    begin
      FmxListBoxUpdateColumnItem(FProgressListItem,
      GetColArrayFromString(
        IntToStr(TestNumber)+'   |   '+
        IntToStr(TestResult.RunCount)+'   |   '+
        IntToStr(TestResult.failureCount)+'   |   '+
        IntToStr(TestResult.errorCount)+'   |   '+
        IntToStr(TestResult.Overrides)+'   |   '+
        FormatElapsedTime(TestResult.TotalTime)+'   |   '+
        FormatElapsedTime(max(TestResult.TotalTime, FTotalTime)),'|'));
      with TestResult do
      begin
        ScoreBar.Value  := TestNumber - (failureCount + errorCount);
        ProgressBar.Value := TestNumber;

        // There is a possibility for zero tests
        if (TestNumber = 0) and (Suite.CountEnabledTestCases = 0) then
          LbProgress.Text := '100%'
        else
          LbProgress.Text := IntToStr(Round((100 * ScoreBar.Value) / ScoreBar.Max)) + '%';
      end;
      if FTimerExpired and (TestNumber < FTotalTestsCount) then
      begin
        FTimerExpired := False;
        FUpdateTimer.Enabled := True;
      end;
    end
     Else
    // Allow just the results pane to catch up
    //ResultsPanel.Update
    ApplyStyleLookup;
  end
  else
  if FProgressListItem<>nil then
  begin
    FProgressListItem.ApplyStyleLookup;
    Application.ProcessMessages;
    ProgressListArray:=FmxListBoxColumnItemValues(FProgressListItem);
    if Length(ProgressListArray)<2  then
       Tst:='0'
     else    Tst:=ProgressListArray[1];
    if StrToIntDef(Tst,0)=0 then
      FmxListBoxUpdateColumnItem(FProgressListItem,
      GetColArrayFromString(
        IntToStr(TestNumber)+' |  |  |   |  | ','|'));
    ResetProgress;
  end;

  if fullUpdate then
  begin
    // Allow the whole display to catch up and check for key strokes
    ApplyStyleLookup;
    Application.ProcessMessages;
  end;
end;

procedure TMobileGUITestRunner.ResetProgress;
begin
  RectResultBar.Fill.Color := clOK;
  ScoreBar.Value := 0;
  ProgressBar.Value := 0;
  LbProgress.Text := '';
end;

procedure TMobileGUITestRunner.ResetTestTreeView;
Var
  i:integer;
  node: TTreeNode;
begin
  for i := 0 to TestTree.GlobalCount - 1 do
  begin
    node := TestTree.ItemByGlobalIndex(i) as TTreeNode;
    node.ImageIndex    := imgNONE;
    node.SelectedIndex := imgNONE;
  end;
end;

function TMobileGUITestRunner.AddFailureItem(failure: TTestFailure): TListBoxItem;
var
  item : TListBoxItem;
  node : TTreeNode;
begin
  assert(assigned(failure));
  item := FmxListBoxAddColumnItem(LbxFailure,TestToNode(failure.failedTest),
  GetColArrayFromString(failure.failedTest.Name+'|'+
  failure.thrownExceptionName+'|'+failure.thrownExceptionMessage+'|'+
  failure.LocationInfo+ ' ' + failure.AddressInfo+'|'+failure.StackTrace,'|'),
     LbxFailureDblClick,'ListBoxWithColsStyle');
  node := testToNode(failure.failedTest);
  while node <> nil do
  begin
    node.Expand;//(false);
    if node.Parent is TTreeNode then
        node := node.Parent as TTreeNode
      else Node:=nil;
  end;

  Result := item;
end;

procedure TMobileGUITestRunner.FillTestTree(RootNode: TTreeNode; ATest: ITest);
var
  TestTests: IInterfaceList;
  i: Integer;
begin
  if ATest = nil then
    EXIT;
  RootNode := FmxTreeViewAddChild(TestTree,RootNode, ATest.Name,RunImages,StateImages);
  RootNode.OnClick := TreeNodeClick;
  RootNode.NodeInt := FTests.Add(ATest);
  ATest.GUIObject := RootNode; //Can we do this here for FMX

  {Was in ShowForm
  { Set up the GUI nodes in the test nodes. We do it here because the form,
    the tree and all its tree nodes get recreated in TCustomForm.ShowModal
    in D8+ so we cannot do it sooner.

  SetupGUINodes; }

  TestTests := ATest.Tests;
  for i := 0 to TestTests.count - 1 do
  begin
    FillTestTree(RootNode, TestTests[i] as ITest);
  end;
end;

procedure TMobileGUITestRunner.FillTestTree(ATest: ITest);
begin
  TestTree.Clear;
  FTests.Clear;
  FillTestTree(nil, Suite);
end;

procedure TMobileGUITestRunner.SetTreeNodeImage(Node :TTreeNode; imgIndex :Integer);
begin
  TestTree.Selected := Node;
  while Node <> nil do
  begin
    if imgIndex > Node.ImageIndex then
    begin
       Node.ImageIndex    := imgIndex;
       Node.SelectedIndex := imgIndex;
    end;
    if imgIndex = imgRunning then
      Node := nil
    else
     if  Node.Parent is TTreeNode then
        Node := Node.Parent as TTreeNode
        else Node:=nil;
  end;
end;

procedure TMobileGUITestRunner.SetSuite(value: ITest);
begin
  FSuite := value;
  if FSuite <> nil then
  begin
    LoadSuiteConfiguration;
    EnableUI(True);
    InitTree;
  end
  else
    EnableUI(False)
end;

procedure TMobileGUITestRunner.DisplayFailureMessage(Item: TListBoxItem);
var
//  hlColor :TAlphaColor;
  Test    :ITest;
  Status  :string;
  Node :TTreeNode;
  ColData:TColArray;

begin
  if Item=nil Then Exit;
  Node:=nil;
  if Item.data is TTreeNode then
      Node:= Item.data as TTreeNode;
  if Node=nil then Exit;

  ColData:=FmxListBoxColumnItemValues(Item);
  TestTree.Selected := Node;
  Test := NodeToTest(Node);
{  hlColor := clFAILURE;
  if Node.ImageIndex >= imgERROR then
     hlColor := clERROR;  }
  with ErrorMessageRTF do
   //No FM RTF Consider HTML
    begin
      Lines.Clear;

      Lines.Add(ColData[0]);
      if ColData[1] <> '' then
      begin
        Lines.Add('');
        Lines.Add(ColData[1]);
      end;
      Status := Test.Status;
      if Status <> '' then
      begin
        Lines.Add('');
        Lines.Add('');
        Lines.Add('Status Messages');
        Lines.Add(Status);
      end;
      if ColData[3] <> '' then
      begin
        Lines.Add('');
        Lines.Add('StackTrace');
        Lines.Add(ColData[3]);
      end;

    {  SelAttributes.Size  := self.Font.Size;
      SelAttributes.Style := [fsBold];
      SelText := Item.Caption + ': ';

      SelAttributes.Color := hlColor;
      SelAttributes.Style := [fsBold];
      SelText := Item.SubItems[0]; }

      Lines.Add('');
      {SelAttributes.Color := clWindowText;
      SelAttributes.Style := [];
      SelText := 'at ' + Item.SubItems[2];

      if Item.SubItems[1] <> '' then
      begin
        SelAttributes.Color := clWindowText;
        Lines.Add('');
        SelAttributes.Size  := 12;
        SelAttributes.Style := [];
        SelText := Item.SubItems[1];
        SelAttributes.Size  := self.Font.Size;
      end;

      Status := Test.Status;
      if Status <> '' then
      begin
        Lines.Add('');
        Lines.Add('');
        SelAttributes.Style := [fsBold];
        Lines.Add('Status Messages');
        SelAttributes.Style := [];
        Lines.Add(Status);
      end;

      if Item.SubItems[3] <> '' then
      begin
        Lines.Add('');
        SelAttributes.Style := [fsBold];
        Lines.Add('StackTrace');
        SelAttributes.Style := [];
        SelText := Item.SubItems[3];
      end;
    }
    end
end;

procedure TMobileGUITestRunner.ClearFailureMessage;
begin
  ErrorMessageRTF.Text:='';//Clear;
end;

procedure TMobileGUITestRunner.ClearResult;
begin
  if FTestResult <> nil then
  begin
    FTestResult.Free;
    FTestResult := nil;
    ClearFailureMessage;
  end;
end;

procedure TMobileGUITestRunner.SetUp;
var
  i: Integer;
begin
  ClearListBox(LbxFailure);
  ClearListBox(LbxResults);
  if Suite <> nil then
    begin
      i := Suite.countEnabledTestCases;
      ProgressBar.Max := i
    end
    else
    begin
      i:=0;
      ProgressBar.Max:= 10000;
    end;
    ScoreBar.Max := ProgressBar.Max;

// Add Header to Results
  FmxListBoxAddColumnItem(LbxResults,nil,
  GetColArrayFromString('Tests|Run|Failures|Errors|Overrides|Test Time|Total Time','|'),nil,
  'ListBoxWithSevenColsStyle');
  FProgressListItem:=FmxListBoxAddColumnItem(LbxResults,nil,
  GetColArrayFromString(IntToStr(i)+'|Col1|Col2','|'),nil,
  'ListBoxWithSevenColsStyle');
  FmxListBoxAddColumnItem(LbxFailure,nil,
  GetColArrayFromString('Test Name|FailureType|Message|Location','|'),nil,
  'ListBoxWithColsStyle');
  //'listboxwithcolsstyle');
  ResetTestTreeView;
  ResetProgress;
  UpdateTestTreeState;
end;

procedure TMobileGUITestRunner.EnableUI(enable: Boolean);
begin
  SelectAllAction.Enabled    := enable;
  DeselectAllAction.Enabled  := enable;
  SelectFailedAction.Enabled := enable;
  SelectCurrentAction.Enabled := enable;
  DeselectCurrentAction.Enabled := enable;
  HideTestNodesAction.Enabled   := enable;
  ExpandAllNodesAction.Enabled  := enable;
end;

procedure TMobileGUITestRunner.FormCreate(Sender: TObject);
begin
  inherited;
  FTests := TInterfaceList.Create;
  LoadConfiguration;

  FormatSettings.TimeSeparator := ':';
  SetUpStateImages;
  SetupCustomShortcuts; //Does Nothing Yet
  ClearTreeView(TestTree);
  EnableUI(false);
  ClearFailureMessage;
  FUpdateTimer := TTimer.Create(Self);
  FUpdateTimer.Interval := 200;
  FUpdateTimer.Enabled := False;
  FUpdateTimer.OnTimer := OnUpdateTimer;
  Setup;

  {$IFDEF FASTMM}
    FailTestCaseIfMemoryLeakedAction.Enabled := True;
    {$IFDEF ManualLeakReportingControl}
      ReportMemoryLeaksOnShutdown := ReportMemoryLeakTypeOnShutdownAction.Checked;
    {$ELSE}
      ReportMemoryLeakTypeOnShutdownAction.Checked := False;
      ReportMemoryLeakTypeOnShutdownAction.Enabled := False;
    {$ENDIF}
  {$ELSE}
    FailTestCaseIfMemoryLeakedAction.Enabled := False;
    ReportMemoryLeakTypeOnShutdownAction.Checked := False;
    ReportMemoryLeakTypeOnShutdownAction.Enabled := False;
  {$ENDIF}

  if not FailTestCaseIfMemoryLeakedAction.Enabled then
    FailTestCaseIfMemoryLeakedAction.Checked := False;
  IgnoreMemoryLeakInSetUpTearDownAction.Enabled :=
    FailTestCaseIfMemoryLeakedAction.Checked;
  if not IgnoreMemoryLeakInSetUpTearDownAction.Enabled then
    IgnoreMemoryLeakInSetUpTearDownAction.Checked := False;
{}
  if not Assigned(FSuite) then
     Suite:=RegisteredTests;
end;

procedure TMobileGUITestRunner.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FUpdateTimer);
  ClearResult;
  AutoSaveConfiguration;
  Suite := nil;
  FTests.Free;
  FTests := nil;
  inherited;
end;

procedure TMobileGUITestRunner.FormShow(Sender: TObject);
begin
  { Set up the GUI nodes in the test nodes. We do it here because the form,
    the tree and all its tree nodes get recreated in TCustomForm.ShowModal
    in D8+ so we cannot do it sooner. }

  //SetupGUINodes;
end;

procedure TMobileGUITestRunner.TestTreeChange(Sender: TObject);
var
  i : Integer;
  Node:TTreeNode;
  Item:TTreeViewItem;

begin
  Item:= TestTree.Selected;
  if Item is TTreeNode then
  begin
    Node:=item as TTreeNode;
    LbxFailure.ItemIndex:=-1;
    for i := 0 to LbxFailure.Items.count - 1 do
    begin
      if LbxFailure.ItemByIndex(i).Data Is TTreeNode then
       if LbxFailure.ItemByIndex(i).Data=Node then
      begin
        LbxFailure.ItemIndex:=i;
        break;
      end;
    end;
    UpdateStatus(True);
  end;
end;

procedure TMobileGUITestRunner.TestTreeClick(Sender: TObject);
begin
  if FRunning then
    EXIT;

  //ProcessClickOnStateIcon;
  TestTreeChange(Sender{, TestTree.Selected as TTreeNode});
end;

procedure TMobileGUITestRunner.FailureListViewClick(Sender: TObject);
begin
  if LbxFailure.Selected <> nil then
    if LbxFailure.Selected.data is TTreeNode then
       TestTree.Selected := TTreeNode(LbxFailure.Selected.data);
end;


function TMobileGUITestRunner.DisableTest(test: ITest): boolean;
begin
  test.enabled := false;
  result := true;
end;

function TMobileGUITestRunner.EnableTest(test: ITest): boolean;
begin
  test.enabled := true;
  result := true;
end;

procedure TMobileGUITestRunner.ApplyToTests(root :TTreeNode; const func :TTestFunc);

  procedure DoApply(rootnode :TTreeNode);
  var
    test: ITest;
    node: TTreeNode;
  begin
    if rootnode <> nil then
    begin
      test := NodeToTest(rootnode);
      if func(test) then
      begin
        node := rootnode.getFirstChild;
        while node <> nil do
        begin
          DoApply(node);
          node := node.getNextSibling;
        end;
      end;
    end;
  end;
begin
  TestTree.BeginUpdate;
  try
    DoApply(root)
  finally
    TestTree.EndUpdate
  end;
  UpdateTestTreeState;
end;

procedure TMobileGUITestRunner.TestTreeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ' ') and (TestTree.Selected <> nil) then
  begin
    SwitchNodeState(TestTree.Selected as TTreeNode);
    UpdateStatus(True);
    Key := #0
  end;
end;

procedure TMobileGUITestRunner.SelectAllActionExecute(Sender: TObject);
begin
  if TestTree.count>0 then
     ApplyToTests(TestTree.Items[0] as TTreeNode, EnableTest);
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.DeselectAllActionExecute(Sender: TObject);
begin
  if TestTree.Count>0 then
      ApplyToTests(TestTree.Items[0] as TTreeNode, DisableTest);
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.SelectFailedActionExecute(Sender: TObject);
var
  i: integer;
  ANode: TTreeNode;
begin
  { deselect all }
  ApplyToTests(TestTree.Items[0] as TTreeNode, DisableTest);

  { select failed }
  for i := 0 to LbxFailure.Items.Count - 1 do
   if LbxFailure.ItemByIndex(i).Data is TTreeNode then

  begin
    ANode := LbxFailure.ItemByIndex(i).Data as TTreeNode;
    SetNodeState(ANode, true);
  end;
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.SaveConfigurationActionExecute(Sender: TObject);
begin
  SaveConfiguration
end;

procedure TMobileGUITestRunner.RestoreSavedActionExecute(Sender: TObject);
begin
  LoadConfiguration
end;

procedure TMobileGUITestRunner.AutoSaveActionExecute(Sender: TObject);
begin
  with AutoSaveAction do
  begin
    Checked := not Checked
  end;
  AutoSaveConfiguration;
end;

procedure TMobileGUITestRunner.ErrorBoxVisibleActionExecute(Sender: TObject);
begin
   with ErrorBoxVisibleAction do
   begin
     Checked := not Checked;
     ErrorBoxPanel.Visible    := Checked;
     if Checked then
     begin
      // Solve bugs with Delphi4 resizing with constraints
      // ErrorBoxSplitter.position.y := ErrorBoxPanel.position.y-8;
     end
   end;
end;

function TMobileGUITestRunner.NodeIsGrandparent(ANode: TTreeNode): boolean;
var
  AChildNode: TTreeNode;
begin
  Result := false;
  if ANode.HasChildren then
  begin
    AChildNode := ANode.GetFirstChild;
    while AChildNode <> nil do
    begin
      Result := AChildNode.HasChildren or Result;
      AChildNode := ANode.GetNextChild(AChildNode);
    end;
  end;
end;

procedure TMobileGUITestRunner.CollapseNonGrandparentNodes(RootNode: TTreeNode);
var
  AChildNode: TTreeNode;
begin
  if not NodeIsGrandparent(RootNode) then
    RootNode.Collapse;

  AChildNode := RootNode.GetFirstChild;
  while AChildNode <> nil do
  begin
    CollapseNonGrandparentNodes(AChildNode);
    AChildNode := RootNode.GetNextChild(AChildNode);
  end;
end;

procedure TMobileGUITestRunner.HideTestNodesActionExecute(Sender: TObject);
var
  ANode: TTreeNode;
begin
  inherited;
  if TestTree.Count = 0 then
    EXIT;

  TestTree.BeginUpdate;
  try
    ANode := TestTree.Items[0] as TTreeNode;
    if ANode <> nil then
    begin
      ANode.Expand;
      CollapseNonGrandparentNodes(ANode);
      SelectNode(ANode);
    end;
  finally
    TestTree.EndUpdate;
  end;
end;

procedure TMobileGUITestRunner.HideTestNodesOnOpenActionExecute(Sender: TObject);
begin
  HideTestNodesOnOpenAction.Checked := not HideTestNodesOnOpenAction.Checked;
end;

procedure TMobileGUITestRunner.ExpandAllNodesActionExecute(Sender: TObject);
begin
  TestTree.ExpandAll;
  if (TestTree.Selected <> nil) then
    MakeNodeVisible(TestTree.Selected As TTreeNode )
  else if(TestTree.Count > 0) then
    TestTree.Selected := TestTree.Items[0];
end;

procedure TMobileGUITestRunner.RunTheTest(aTest : ITest);
begin
  if aTest = nil then
    EXIT;
  if FRunning then
  begin
    // warning: we're reentering this method if FRunning is true
    assert(FTestResult <> nil);
    FTestResult.Stop;
    EXIT;
  end;

  FRunning := true;
  try
    RunAction.Enabled  := False;
    StopAction.Enabled := True;

    CopyMessageToClipboardAction.Enabled := false;

    EnableUI(false);
    AutoSaveConfiguration;
    ClearResult;
    TestResult := TTestResult.create;
    try
      TestResult.addListener(self);
      TestResult.BreakOnFailures := BreakOnFailuresAction.Checked;
      TestResult.FailsIfNoChecksExecuted := FailIfNoChecksExecutedAction.Checked;
      TestResult.FailsIfMemoryLeaked := FailTestCaseIfMemoryLeakedAction.Checked;
      TestResult.IgnoresMemoryLeakInSetUpTearDown :=
        IgnoreMemoryLeakInSetUpTearDownAction.Checked;
      aTest.run(TestResult);
    finally
      FErrorCount := TestResult.ErrorCount;
      FFailureCount := TestResult.FailureCount;
      TestResult.Free;
      TestResult := nil;
    end;
  finally
      FRunning := false;
      EnableUI(true);
  end;
end;

procedure TMobileGUITestRunner.RunActionExecute(Sender: TObject);
begin
  if Suite = nil then
    EXIT;

  Setup;
  RunTheTest(Suite);
end;

procedure TMobileGUITestRunner.ExitActionExecute(Sender: TObject);
begin
  if FTestResult <> nil then
     FTestResult.stop;
  self.ModalResult := mrCancel;
  Close;
end;

procedure TMobileGUITestRunner.TBtnExitClick(Sender: TObject);
begin
 Close;
end;

procedure TMobileGUITestRunner.BreakOnFailuresActionExecute(Sender: TObject);
begin
  with BreakOnFailuresAction do
   Checked := not Checked;
end;

procedure TMobileGUITestRunner.BtnDnClick(Sender: TObject);
Var
  ThisNode:TTreeViewItem;
  NxtNode:TTreeNode;
  Cnt:integer;
begin
 NxtNode:=nil;
 ThisNode:=TestTree.Selected;
 if ThisNode is TTreeNode then
  begin
    NxtNode:= ThisNode as TTreeNode;
//    Nxtnode:=NowNode.GetPrevSibling;
   Cnt:=5;
   While (NxtNode<>nil) and (Cnt>0) do
     begin
        Dec(Cnt);
        NxtNode:=NxtNode.GetNext;
        if NxtNode<>nil then
          TestTree.Selected:=NxtNode;
     end;
  end;
end;

procedure TMobileGUITestRunner.BtnUpClick(Sender: TObject);
Var
  ThisNode:TTreeViewItem;
  NxtNode:TTreeNode;
  cnt:integer;
begin
 NxtNode:=nil;
 ThisNode:=TestTree.Selected;
 if ThisNode is TTreeNode then
  begin
    NxtNode:= ThisNode as TTreeNode;
//    Nxtnode:=NowNode.GetPrevSibling;
   Cnt:=5;
   While (NxtNode<>nil) and (Cnt>0) do
     begin
        Dec(Cnt);
        NxtNode:=NxtNode.GetPrev;
        if NxtNode<>nil then
          TestTree.Selected:=NxtNode;
     end;
  end;
end;

procedure TMobileGUITestRunner.FailIfNoChecksExecutedActionExecute(Sender: TObject);
begin
  with FailIfNoChecksExecutedAction do
    Checked := not Checked;
end;

procedure TMobileGUITestRunner.FailTestCaseIfMemoryLeakedActionExecute(Sender: TObject);
begin
  with FailTestCaseIfMemoryLeakedAction do
  begin
    Checked := not Checked;
    IgnoreMemoryLeakInSetUpTearDownAction.Enabled := Checked;
    if not Checked then
      IgnoreMemoryLeakInSetUpTearDownAction.Checked := False;
  end;
end;

procedure TMobileGUITestRunner.ShowTestCasesWithRunTimePropertiesActionExecute(
  Sender: TObject);
begin
  with ShowTestCasesWithRunTimePropertiesAction do
  begin
    Checked := not Checked;
    if Checked then
      WarnOnFailTestOverrideAction.Checked := False;
  end;
end;

procedure TMobileGUITestRunner.WarnOnFailTestOverrideActionExecute(
  Sender: TObject);
begin
  with WarnOnFailTestOverrideAction do
  begin
    Checked := not Checked;
    if Checked then
      ShowTestCasesWithRunTimePropertiesAction.Checked := False;
  end;
end;

procedure TMobileGUITestRunner.ShowTestedNodeActionExecute(Sender: TObject);
begin
  with ShowTestedNodeAction do
    Checked := not Checked;
end;

procedure TMobileGUITestRunner.SetUpStateImages;
begin
   //ActionImages.AssignActionImagesToMenu(MainMenu);
   //ActionImages.AssignActionImagesToMenu(pmTestTree);
   //ActionImages.AssignActionImagesToMenu(TestCaseProperty);   popupmenu
   //ActionImages.AssignActionImagesToMenu(ErrorMessagePopup);
   SelectAllButton.Text:='';
   SelectFailedButton.Text:='';
   RunAllButton.Text:='';
   RunSelectedTestButton.Text:='';
   DeselectCurrentButton.Text:='';
   SelectCurrentButton.Text:='';
   DeselectAllButton.Text:='';
   RunAllButton.Text:='';
   StoplButton.Text:='';
   ActionImages.AssignActionImagesTo(SelectAllButton);
   ActionImages.AssignActionImagesTo(SelectFailedButton);
   ActionImages.AssignActionImagesTo(RunSelectedTestButton);
   ActionImages.AssignActionImagesTo(DeselectCurrentButton);
   ActionImages.AssignActionImagesTo(SelectCurrentButton);
   ActionImages.AssignActionImagesTo(DeselectAllButton);
   ActionImages.AssignActionImagesTo(RunAllButton);
   ActionImages.AssignActionImagesTo(StoplButton);
end;

procedure TMobileGUITestRunner.LoadSuiteConfiguration;
begin
  if Suite <> nil then
    Suite.LoadConfiguration(IniFileName, False, True);
end;

procedure TMobileGUITestRunner.MakeNodeVisible(node: TTreeNode);
begin
  Node.MakeVisible
end;


procedure TMobileGUITestRunner.UpdateNodeImage(node: TTreeNode);
var
  test :ITest;
begin
  test := NodeToTest(node);
  if not test.enabled then
  begin
    node.StateIndex := imgDISABLED;
  end
  else if (node.ParentNode is  TTreeNode)
  and ((node.ParentNode as TTreeNode).StateIndex <= imgPARENT_DISABLED) then
  begin
    node.StateIndex := imgPARENT_DISABLED;
  end
  else
  begin
    node.StateIndex := imgENABLED;
  end;
  Node.ApplyStyleLookup;
end;

procedure TMobileGUITestRunner.CopyMessageToClipboardActionExecute(Sender: TObject);
begin
  ErrorMessageRTF.SelectAll;
  ErrorMessageRTF.CopyToClipboard;
end;

function TMobileGUITestRunner.GetIniFile(const FileName: string) :
 {$IFDEF MSWINDOWS}
tCustomIniFile;
{$ELSE}
TMemIniFile;
{$Endif}
begin
    Result := tIniFile.Create( FileName );
end;

procedure TMobileGUITestRunner.RunActionUpdate(Sender: TObject);
begin
  RunAction.Enabled := not FRunning and assigned( Suite ) and (Suite.countEnabledTestCases > 0);
end;

procedure TMobileGUITestRunner.CopyMessageToClipboardActionUpdate(Sender: TObject);
begin
  CopyMessageToClipboardAction.Enabled := LbxResults.Selected <> nil;
end;

procedure TMobileGUITestRunner.SelectCurrentActionExecute(Sender: TObject);
begin
  ApplyToTests(TestTree.Selected  As TTreeNode , EnableTest);
  SetNodeState(TestTree.Selected As TTreeNode , true);
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.DeselectCurrentActionExecute(Sender: TObject);
begin
  ApplyToTests(TestTree.Selected As TTreeNode , DisableTest);
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.StopActionExecute(Sender: TObject);
begin
  if FTestResult <> nil then
     FTestResult.stop;
end;

procedure TMobileGUITestRunner.StopActionUpdate(Sender: TObject);
begin
  StopAction.Enabled := FRunning and (FTestResult <> nil);
end;

procedure TMobileGUITestRunner.Status(test: ITest; const Msg: string);
begin
  if ErrorMessageRTF.Lines.Count = 0 then
    ErrorMessageRTF.Lines.Add(test.Name + ':');

  ErrorMessageRTF.Lines.Add(Msg);

  //ErrorMessageRTF.Update;
end;

procedure TMobileGUITestRunner.Warning(test: ITest; const Msg: string);
begin
  if ErrorMessageRTF.Lines.Count = 0 then
    ErrorMessageRTF.Lines.Add(test.Name + ':');

  ErrorMessageRTF.Lines.Add(Msg);

 //ErrorMessageRTF.Update;
end;

procedure TMobileGUITestRunner.ClearStatusMessage;
begin
  ErrorMessageRTF.Lines.Clear;
end;

procedure TMobileGUITestRunner.CopyProcnameToClipboardActionExecute(
  Sender: TObject);
begin
  CopyTestNametoClipboard(TestTree.Selected As TTreeNode );
end;

procedure TMobileGUITestRunner.CopyTestNametoClipboard(ANode: TTreeNode);
begin
  if Assigned(ANode) then
  begin
    //Clipboard.AsText := ANode.Text;
  end;
end;

procedure TMobileGUITestRunner.CopyProcnameToClipboardActionUpdate(
  Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(TestTree.Selected)
                                 and isTestMethod(NodeToTest(TestTree.Selected As TTreeNode ));
end;

function TMobileGUITestRunner.SelectedTest: ITest;
begin
  if TestTree.Selected = nil then
    Result := nil
  else
    Result := NodeToTest(TestTree.Selected As TTreeNode );
end;

procedure TMobileGUITestRunner.LbxFailureDblClick(Sender: TObject);
begin
 // if not Selected then     ClearFailureMessage  else

  ClearFailureMessage;
  if Sender is TListBoxItem then
    DisplayFailureMessage(TListBoxItem(Sender));
end;

procedure TMobileGUITestRunner.ListSelectedTests;
var
  aTest: ITest;
  aNode: TTreeNode;
begin
  FSelectedTests.Free;
  FSelectedTests := nil;
  FSelectedTests := TInterfaceList.Create;

  aNode := TestTree.Selected As TTreeNode ;

  while Assigned(aNode) do
  begin
    aTest := NodeToTest(aNode);
    FSelectedTests.Add(aTest as ITest);
    if aNode.Parent is TTreeNode then
      aNode := aNode.Parent As TTreeNode
    else aNode:=nil;
  end;
end;

procedure TMobileGUITestRunner.RunSelectedTestActionExecute(Sender: TObject);
begin
  Setup;
  ListSelectedTests;
  ProgressBar.Max := 1;
  ScoreBar.Max    := 1;
  RunTheTest(Suite);
  {$IFDEF VER130}
    FreeAndNil(FSelectedTests);
  {$ELSE}
    FSelectedTests.Free;
    FSelectedTests := nil;
  {$ENDIF}
end;

procedure TMobileGUITestRunner.RunSelectedTestActionUpdate(Sender: TObject);
var
  aTest :ITest;
begin
  ATest := SelectedTest;
  RunSelectedTestAction.Enabled := (aTest <> nil) and (aTest.CountTestCases = 1);
end;

{class procedure TMobileGUITestRunner.RunTest(test: ITest);
var
  myform: TMobileGUITestRunner;
begin
  Application.CreateForm(TMobileGUITestRunner, MyForm);
  with MyForm do
  begin
    try
      suite := test;
      ShowModal;
    finally
      MyForm.Free;
    end;
  end;
end; }

{class procedure TMobileGUITestRunner.RunRegisteredTests;
begin
  RunTest(RegisteredTests);
end;
}

procedure TMobileGUITestRunner.EndSuite(suite: ITest);
begin
  UpdateStatus(True);
end;

procedure TMobileGUITestRunner.StartSuite(suite: ITest);
begin
end;

procedure TMobileGUITestRunner.TestTreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewNode: TTreeNode;
begin
  { a version of this code was in the pmTestTreePopup event, but it created
    an intermittent bug. OnPopup is executed if any of the ShortCut keys
    belonging to items on the popup menu are used. This caused weird behavior,
    with the selected node suddenly changing to whatever was under the mouse
    cursor (or AV-ing if the mouse cursor wasn't over the DUnit form) when
    the user executed one of the keyboard shortcuts.

    It was intermittent most likely because the ShortCuts belonged to
    Main Menu items as well (shared from the Action.ShortCut), and the bug
    dependended on the Popup menu items receiving the ShortCut Windows message
    first.

    This code ensures that node selection occurs prior to the popup menu
    appearing when the user right-clicks on a non-selected tree node. }
{
  if (Button = TMouseButton.mbRight) and (htOnItem in TestTree.GetHitTestInfoAt(X, Y)) then
  begin
    NewNode := TestTree.GetNodeAt(X, Y);
    if TestTree.Selected <> NewNode then
      TestTree.Selected := NewNode;
  end; {}
end;

procedure TMobileGUITestRunner.TreeNodeClick(Sender: TObject);
// procedure TGUITestRunner.ProcessClickOnStateIcon;
var
  node: TTreeNode;
//  PointPos: TPoint;
begin
  if Not (Sender is TTReeNode) then Exit;

  node := Sender As TTreeNode;
  SwitchNodeState(node);
end;

procedure TMobileGUITestRunner.GoToNextSelectedTestActionExecute(
  Sender: TObject);
var
  aNode: TTreeNode;
begin
  if TestTree.Selected <> nil then
  begin
    aNode := TTreeNode(TestTree.Selected).GetNext;
    while aNode <> nil do
    begin
      if SelectNodeIfTestEnabled(aNode) then
        break
      else
        aNode := aNode.GetNext;
    end;
  end;
end;

function TMobileGUITestRunner.SelectNodeIfTestEnabled(ANode: TTreeNode): boolean;
var
  ATest: ITest;
begin
  ATest := NodeToTest(ANode);
  if (ATest.Enabled) and (IsTestMethod(ATest)) then
  begin
    Result := true;
    SelectNode(ANode);
  end
  else
    Result := false;
end;

procedure TMobileGUITestRunner.GoToPrevSelectedTestActionExecute(
  Sender: TObject);
var
  aNode: TTreeNode;
begin
  if TestTree.Selected <> nil then
  begin
    aNode := (TestTree.Selected as TTreeNode).GetPrev;
    while aNode <> nil do
    begin
      if SelectNodeIfTestEnabled(aNode) then
        break
      else
        aNode := aNode.GetPrev;
    end;
  end;
end;

procedure TMobileGUITestRunner.SelectNode(node: TTreeNode);
begin
  node.Selected := true;
  MakeNodeVisible(node);
end;

procedure TMobileGUITestRunner.SetupCustomShortcuts;
begin
  { the following shortcuts are not offered as an option in the
    form designer, but can be set up here }
  {GoToNextSelectedTestAction.ShortCut := ShortCut(VK_RIGHT, [ssCtrl]);
  GoToPrevSelectedTestAction.ShortCut := ShortCut(VK_LEFT, [ssCtrl]);}
end;

procedure TMobileGUITestRunner.SetupGUINodes;
var
  node: TTreeNode;
  test: ITest;
begin
  { Set up the GUI nodes in the test nodes. We do it here because the form,
    the tree and all its tree nodes get recreated in TCustomForm.ShowModal
    in D8+ so we cannot do it sooner.
    This method is also called after loading test libraries }
  if TestTree.count<1 then
     node:=nil
   else
     node := (TestTree.Items[0] as TTreeNode).GetFirstNode;
  while assigned(node) do
  begin
    // Get and check the test for the tree node

    test := NodeToTest(node);
    assert(Assigned(test));

    // Save the tree node in the test and get the next tree node

    test.GUIObject := node;

    node := node.GetNext;
  end;
end;

const
  NoChecksStrT = ' FailsOnNoChecksExecuted  := True ';
  NoChecksStrF = ' FailsOnNoChecksExecuted  := False';
  MemLeakStrT  = ' FailsOnMemoryLeak        := True ';
  MemLeakStrF  = ' FailsOnMemoryLeak        := False';
  MemGainStrT  = ' FailsOnMemoryRecovery    := True ';
  MemGainStrF  = ' FailsOnMemoryRecovery    := False';
  MemBytesStr0 = ' AllowedMemoryLeakSize '           ;
  IgnoreStrT   = ' IgnoreSetUpTearDownLeaks := True ';
  IgnoreStrF   = ' IgnoreSetUpTearDownLeaks := False';

procedure TMobileGUITestRunner.TestCasePropertiesActionExecute(Sender: TObject);
var
  aNode: TTreeNode;
  ATest: ITest;

begin
  if TestTree.Selected <> nil then
  begin
    aNode := TestTree.Selected  As TTreeNode ;
    if (aNode <> nil) then
    begin
      ATest := NodeToTest(ANode);
      if IsTestMethod(ATest) then
      begin
        if ATest.FailsOnNoChecksExecuted then
          FNoChecksStr := NoChecksStrT
        else
          FNoChecksStr := NoChecksStrF;
        fNoCheckExecutedPtyOverridden := FailIfNoChecksExecutedAction.Checked and
          (not ATest.FailsOnNoChecksExecuted);

        if ATest.FailsOnMemoryLeak then
          FMemLeakStr := MemLeakStrT
        else
          FMemLeakStr := MemLeakStrF;
        fMemLeakDetectedPtyOverridden := FailTestCaseIfMemoryLeakedAction.Checked and
          (not ATest.FailsOnMemoryLeak);
        if (ATest.FailsOnMemoryLeak and ATest.FailsOnMemoryRecovery) then
          FMemGainStr := MemGainStrT
        else
          FMemGainStr := MemGainStrF;

        if (ATest.IgnoreSetUpTearDownLeaks) and ATest.FailsOnMemoryLeak then
          FIgnoreLeakStr := IgnoreStrT
        else
          FIgnoreLeakStr := IgnoreStrF;
        FIgnoreSetUpTearDownLeakPtyOverridden := ATest.IgnoreSetUpTearDownLeaks and
          ATest.FailsOnMemoryLeak and (not IgnoreMemoryLeakInSetUpTearDownAction.Checked);

        FBytes := ':= ' + IntToStr(Atest.AllowedMemoryLeakSize) + ' Bytes';
        FMemBytesStr := MemBytesStr0 + FBytes;
        //TestCaseProperty.Popup(Self.Left + FPopupX,Self.Top + FPopupY);
      end;
    end;
    ATest := nil;
  end;
end;

procedure TMobileGUITestRunner.Previous1Click(Sender: TObject);
begin
  GoToPrevSelectedTestActionExecute(Self);
  TestCasePropertiesActionExecute(self);
end;

procedure TMobileGUITestRunner.Next1Click(Sender: TObject);
begin
  GoToNextSelectedTestActionExecute(Self);
  TestCasePropertiesActionExecute(self);
end;

{procedure TGUITestRunner.TestCasePropertiesMeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
var
  ImageSize: TSize;
begin
  if GetTextExtentPoint32(ACanvas.Handle,
                          PChar(sPopupTitle),
                          Length(sPopupTitle),
                          ImageSize) then
  begin
    Width  := ImageSize.cx + 60;
    Height := ImageSize.cy + 4;
  end;
end;

procedure TGUITestRunner.MenuLooksInactive(ACanvas: TCanvas;
                                           ARect: TRect;
                                           Selected: Boolean;
                                           ATitle: string;
                                           TitlePosn: UINT;
                                           PtyOveridesGUI: boolean);
var
  Count: integer;
  SecondPart: string;
  SecondRect: TRect;
begin
  if TitlePosn = DT_CENTER then
    ACanvas.Font.Style := [fsBold];
  if Selected then
    ACanvas.Font.Color := clBlack;
  if PtyOveridesGUI then
    ACanvas.Brush.Color := clYellow
  else
    ACanvas.Brush.Color := TColor($C0FCC0);  //Sort of Moneygreen
  ACanvas.FillRect(ARect);
  Count := Pos(':=', ATitle);
  if Count = 0 then
    DrawText(ACanvas.Handle,
             PChar(ATitle),
             Length(ATitle),
             ARect,
             DT_VCENTER or DT_SINGLELINE or DT_NOCLIP or DT_NOPREFIX or TitlePosn)
  else
  begin
    DrawText(ACanvas.Handle,
             PChar(ATitle),
             Count-1,
             ARect,
             DT_VCENTER or DT_SINGLELINE or DT_NOCLIP or DT_NOPREFIX or TitlePosn);

    SecondPart := Copy(ATitle, Count, Length(ATitle));
    SecondRect := ARect;
    SecondRect.Left := 5 * ((ARect.Right - ARect.Left) div 8);
    DrawText(ACanvas.Handle,
             PChar(SecondPart),
             Length(SecondPart),
             SecondRect,
             DT_VCENTER or DT_SINGLELINE or DT_NOCLIP or DT_NOPREFIX or TitlePosn)
  end;
end;

procedure TGUITestRunner.MenuLooksActive(ACanvas: TCanvas;
                                         ARect: TRect;
                                         Selected: Boolean;
                                         ATitle: string;
                                         TitlePosn: UINT);
begin
  ACanvas.FillRect(ARect);
  DrawText(ACanvas.Handle,
           PChar(ATitle),
           Length(ATitle),
           ARect,
           DT_VCENTER or DT_SINGLELINE or DT_NOCLIP or DT_NOPREFIX or TitlePosn);
end;

procedure TGUITestRunner.TestCasePropertiesDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, sPopupTitle, DT_CENTER, False);
end;

procedure TGUITestRunner.Previous1DrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksActive(ACanvas, ARect, Selected, sPopupPrevious, DT_LEFT);
end;

procedure TGUITestRunner.RunSelectedTest1DrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksActive(ACanvas, ARect, Selected, sPopupRun, DT_LEFT);
end;

procedure TGUITestRunner.Next1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
  MenuLooksActive(ACanvas, ARect, Selected, sPopupNext, DT_LEFT);
end;

procedure TGUITestRunner.FailNoCheckExecutedMenuItemDrawItem(
  Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, FNoChecksStr,
    DT_LEFT, fNoCheckExecutedPtyOverridden);
end;

procedure TGUITestRunner.FailsOnMemoryLeakMenuItemDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, FMemLeakStr,
    DT_LEFT, fMemLeakDetectedPtyOverridden);
end;

procedure TGUITestRunner.FailsOnMemoryRecoveryMenuItemDrawItem(
  Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, FMemGainStr,
    DT_LEFT, False);
end;

procedure TGUITestRunner.AllowedLeakSizeMemuItemDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, FMemBytesStr, DT_LEFT, False);
end;

procedure TGUITestRunner.TestCaseIgnoreSetUpTearDownLeaksMenuItemDrawItem(
  Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  MenuLooksInactive(ACanvas, ARect, Selected, FIgnoreLeakStr,
    DT_LEFT, FIgnoreSetUpTearDownLeakPtyOverridden);
end;

procedure TGUITestRunner.pmTestTreePopup(Sender: TObject);
var
  aNode: TTreeNode;
  ATest: ITest;

begin
  if TestTree.Selected <> nil then
  begin
    aNode := TestTree.Selected;
    if (aNode <> nil) then
    begin
      ATest := NodeToTest(ANode);
      TestCasePopup.Enabled := IsTestMethod(ATest);
    end;
    ATest := nil;
  end;
end;

function TGUITestRunner.GetPropertyName(const Caption: string): string;
var
  TempStr: string;
  PosSpace: integer;
begin
  TempStr := Trim(Caption);
  PosSpace := Pos(' ',TempStr);
  if (PosSpace > 1)  then
    result := Copy(TempStr, 1, PosSpace-1);
end;

procedure TGUITestRunner.FailNoCheckExecutedMenuItemClick(Sender: TObject);
begin
  Clipboard.AsText := GetPropertyName(NoChecksStrT);
end;

procedure TGUITestRunner.FailsOnMemoryLeakMenuItemClick(Sender: TObject);
begin
  Clipboard.AsText := GetPropertyName(MemLeakStrT);
end;

procedure TGUITestRunner.AllowedLeakSizeMemuItemClick(Sender: TObject);
begin
  Clipboard.AsText := GetPropertyName(MemBytesStr0);
end;

procedure TGUITestRunner.FailsOnMemoryRecoveryMenuItemClick(
  Sender: TObject);
begin
  Clipboard.AsText := GetPropertyName(MemGainStrT);
end;

procedure TGUITestRunner.TestCaseIgnoreSetUpTearDownLeaksMenuItemClick(
  Sender: TObject);
begin
  Clipboard.AsText := GetPropertyName(IgnoreStrT);
end;

procedure TGUITestRunner.RunSelectedTestAltActionExecute(Sender: TObject);
begin
  RunSelectedTestActionExecute(Self);
  TestCasePropertiesActionExecute(Self);
end;

procedure TGUITestRunner.IgnoreMemoryLeakInSetUpTearDownActionExecute(
  Sender: TObject);
begin
  with IgnoreMemoryLeakInSetUpTearDownAction do
    Checked := not Checked;
end;
}
(*
procedure TGUITestRunner.ReportMemoryLeakTypeOnShutdownActionExecute(
  Sender: TObject);
begin
  with ReportMemoryLeakTypeOnShutdownAction do
  begin
    Checked := not Checked;

{$IFDEF FASTMM}
  {$IFDEF ManualLeakReportingControl}
    ReportMemoryLeaksOnShutdown := Checked;
  {$ENDIF}
{$ENDIF}
  end;    // with
end;

*)

end.
