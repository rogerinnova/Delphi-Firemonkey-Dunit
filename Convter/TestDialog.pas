unit TestDialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, ISGeneralBaseForm,
  FMX.Edit, FMX.Layouts, FMX.Memo, FMX.ExtCtrls, IsBitButton, FMX.Filter.Effects,
  FMX.Grid, IsAdvStringGrid, FMX.StdCtrls;

type
  TDlgTestFMXLib = class(TIsGeneralBaseEditDialog)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    CornerButton1: TCornerButton;
    IsBitButton2: TIsBitButton;
    IsBitButton4: TIsBitButton;
    StyleBook1: TStyleBook;
    IsBitButton1: TIsBitButton;
    IsBitButton3: TIsBitButton;
    IsBitButton5: TIsBitButton;
    IsBitButton6: TIsBitButton;
    Break: TIsBitButton;
    procedure Edit1Exit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IsBitButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateForm; override; // Put Object Details on Form
    // procedure AdjustBtnColor;
    function UpdateObjects: Boolean; override;

  end;

var
  DlgTestFMXLib: TDlgTestFMXLib;

implementation

{$R *.fmx}

uses ISFormUtilFMX, ISLibFmxFrmwrk;

procedure TDlgTestFMXLib.Button1Click(Sender: TObject);
begin
  TWaitBoxOnForm.CreateWaitBox(Self,'Wait for me!','I am Coming',10);
end;

procedure TDlgTestFMXLib.Button3Click(Sender: TObject);
begin
  SetEditControlColor(Edit2,claYellow);
end;

procedure TDlgTestFMXLib.Edit1Exit(Sender: TObject);
begin
   SetCurrencyCaption(Label1,StrToFloatDef(Edit1.text,0));
   SetCurrencyText(Edit1,StrToFloatDef(Edit1.text,0));
   SetEditControlColor(Edit1,claRed);
end;

procedure TDlgTestFMXLib.IsBitButton1Click(Sender: TObject);
begin
  if sender is TIsBitButton then
    IsBitButton2.BitMap:=TIsBitButton(Sender).BitMap;
end;

procedure TDlgTestFMXLib.UpdateForm;
begin
  inherited;
  Label1.Text:='Some text';
  AlignLabelToRight(Label1,Edit1.Position.X-2);
  SetEditControlColor(Edit2,claYellow);
  SetEditControlColor(Edit1,claYellow);
end;

function TDlgTestFMXLib.UpdateObjects: Boolean;
begin
  Label1.Text:='Some text';
  result:=true;
end;


end.
