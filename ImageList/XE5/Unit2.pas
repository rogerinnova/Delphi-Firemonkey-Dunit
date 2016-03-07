unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  ISFMXImageList;

type
  TForm2 = class(TForm)
    FMXImageList1: TFMXImageList;
    SpeedButton1: TSpeedButton;
    StyleBook1: TStyleBook;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
   FMXImageList1.AssignAnImageTo(SpeedButton1,10);
end;

end.
