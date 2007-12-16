unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;
procedure dbupdate(aDsn ,aSql : string );
Function dbquery(aDsn ,aSql : string ):Array of TStringList;
implementation

{$R *.DFM}
uses odbc ;
Function dbquery(aDsn ,aSql : string ):Array of TStringList;
var
query1 : Todbcst;
r : Array of TStringList;
begin
 try
   PSQLAllocEnv;
   PSQLAllocConnect;
   If PSQLConnect(pchar(aDsn),'','') = 0 Then
   Begin
      Try
         Query1 := Todbcst.Create;
         With Query1 do
         Begin
            Try
               Sql := asql;
               execute;
            Except
               On E: Error_Odbc do
                  ;
            End;
         End;
      Finally
         Query1.Free;
      End;

   End;
 Finally
   PSQLDisconnect;
   PSQLFreeConnect;
   PSQLFreeEnv;
 End;
end;
procedure dbquery(aDsn ,aSql : string );
var
query1 : Todbcst;
i : integer ;
begin
 try
   PSQLAllocEnv;
   PSQLAllocConnect;
   If PSQLConnect(pchar(aDsn),'','') = 0 Then
   Begin
      Try
         Query1 := Todbcst.Create;
         With Query1 do
         Begin
            Try
               Sql := asql;
               execute;
               //  table -
               While Next do
               Begin
                 //  table -
                 for i :=1 to NumbCols do
                   form1.caption := form1.caption + cellstring(i) ;
               End;
            Except
               On E: Error_Odbc do
                  ;
            End;
         End;
      Finally
         Query1.Free;
      End;

   End;
 Finally
   PSQLDisconnect;
   PSQLFreeConnect;
   PSQLFreeEnv;
 End;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   //dbupdate('gongjiao','update [三日表] set [车号]=12305' );
   dbquery('gongjiao','select * from [三日表] ' );
end;

end.
