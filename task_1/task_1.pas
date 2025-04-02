program task_1;
{$mode objfpc}{$H+}
uses crt, fpcunit, testregistry, testreport;

const
    MIN_VAL = 0;     // Min rand int
    MAX_VAL = 100;   // max rand int
    NUM_COUNT = 50;  

type
    IA = Array of Integer;

var
    List: IA;
    I: Integer;  

procedure RandInit(var List: IA);
var
    I: Integer;
begin
    if (MAX_VAL >= MIN_VAL) and (NUM_COUNT > 0) then
    begin
        SetLength(List, NUM_COUNT);
        for I := 0 to NUM_COUNT - 1 do  
        begin
            List[I] := MIN_VAL + Random(MAX_VAL - MIN_VAL + 1);
        end;
    end
    else
        writeln('Incorrect arguments');
end;

procedure BubbleSort(var List: IA);
var 
    I, J, temp: Integer;
begin
    for J := 0 to High(List) - 1 do
        for I := 0 to High(List) - J - 1 do
            if List[I] > List[I+1] then
            begin
                temp := List[I];
                List[I] := List[I+1];
                List[I+1] := temp;
            end;
end;
type
  TestRandInit = class(TTestCase)
  published
    procedure TestRandInitListSize;
    procedure TestRandInitMinRange;
    procedure TestRandInitMaxRange;
  end;

procedure TestRandInit.TestRandInitListSize;
begin
    RandInit(List);
    AssertEquals('List size should be NUM_COUNT', NUM_COUNT, Length(List));
end;

procedure TestRandInit.TestRandInitMinRange;
var
  I: Integer;
begin
    RandInit(List);
    for I := 0 to High(List) do
        AssertTrue('Out of range', List[I] >= MIN_VAL);
end;

procedure TestRandInit.TestRandInitMaxRange;
var
  I: Integer;
begin
    RandInit(List);
    for I := 0 to High(List) do
        AssertTrue('Out of range', List[I] <= MAX_VAL);
end;

type
  TestBubbleSort = class(TTestCase)
  published
    procedure TestBubbleSortSorted;
    procedure TestBubbleSortNotEmpty;
  end;

procedure TestBubbleSort.TestBubbleSortSorted;
var
  I: Integer;
begin
    RandInit(List); 
    BubbleSort(List);  
    for I := 0 to High(List) - 1 do
        AssertTrue('List is not sorted', List[I] <= List[I + 1]);
end;

procedure TestBubbleSort.TestBubbleSortNotEmpty;
begin
    RandInit(List); 
    BubbleSort(List); 
    AssertTrue('List is empty', Length(List) > 0);  
end;
var
    Writer : TPlainResultsWriter;
    TestResult : TTestResult;
    Test : TTest;
begin
    Randomize;
    RandInit(List);  

    writeln('Randomized list before sorting:');
    for I := 0 to High(List) do
        writeln(List[I]);

    BubbleSort(List);

    writeln('Sorted:');
    for I := 0 to High(List) do  
        writeln(List[I]);
    
    RegisterTest(TestRandInit);
    RegisterTest(TestBubbleSort);

    Writer := TPlainResultsWriter.Create;
    TestResult := TTestResult.Create;
    Test := GetTestRegistry;

    Test.Run(TestResult);
    Writer.WriteResult(TestResult);

    Writer.Free;
    TestResult.Free;
end.