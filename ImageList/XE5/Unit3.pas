unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  ISFMXImageList;

type
  TForm3 = class(TForm)
    FMXImageList1: TFMXImageList;
    SpeedButton1: TSpeedButton;
    StyleBook1: TStyleBook;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.FormCreate(Sender: TObject);
begin
   FMXImageList1.AssignAnImageTo(SpeedButton1,2);
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
 FMXImageList1.AssignAnImageTo(SpeedButton2,5);
end;

end.
