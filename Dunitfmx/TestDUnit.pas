unit TestDUnit;

interface

uses TestFramework,System.SysUtils;

type
  TTestCaseFMx = class(TTestCase)
  published
    procedure TestOne;
    procedure TestTwo;
    procedure TestThree;
    procedure TestFour;
    procedure TestFive;
    procedure TestSix;
    procedure TestSeven;
    procedure TestEight;
    procedure TestNone;
    procedure TestTen;
    procedure TestEleven;
  end;

implementation


{ TTestCaseFMx }

procedure TTestCaseFMx.TestEight;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestEleven;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestFive;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestFour;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestNone;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestOne;
begin
  Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestSeven;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestSix;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestTen;
begin
 Sleep(500);
  Check(True,'ggggggg');
end;

procedure TTestCaseFMx.TestTHree;
begin
  Sleep(1000);
  raise Exception.Create('TestThree Forced Exception Fail');
end;

procedure TTestCaseFMx.TestTwo;
begin
  Sleep(500);
  Check(False,'Test Two Forced Check Fail');
end;

initialization
   TestFramework.RegisterTest(TTestCaseFMx.Suite);

end.
