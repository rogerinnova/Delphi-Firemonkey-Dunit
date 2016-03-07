unit ActionListFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdActns, Vcl.Menus, Vcl.ActnList,
  Vcl.ImgList, Vcl.ExtActns, System.Actions, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    FileOpen1: TFileOpen;
    FileOpenWith1: TFileOpenWith;
    FileSaveAs1: TFileSaveAs;
    FilePrintSetup1: TFilePrintSetup;
    FilePageSetup1: TFilePageSetup;
    FileRun1: TFileRun;
    FileExit1: TFileExit;
    BrowseForFolder1: TBrowseForFolder;
    ActionsImages: TImageList;
    ActLookup: TAction;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    else1: TMenuItem;
    EditPaste1: TEditPaste;
    Paste1: TMenuItem;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    SpeedButton2: TSpeedButton;
    Button1: TButton;
    PageSetup1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
