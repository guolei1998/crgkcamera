unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzCommon, RzTray, StdCtrls, ComCtrls,SyncObjs, XmlRpcServer, XmlRpcTypes,
  EncdDecd ,  IdCoderMIME,IdGlobal,DateUtils ;

type
  TForm1 = class(TForm)
    chk1: TCheckBox;
    btn1: TButton;
    RzTrayIcon1: TRzTrayIcon;
    rzrgnfl1: TRzRegIniFile;
    btn2: TButton;
    Button1: TButton;
    lstMessages: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure chk1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FRpcServer: TRpcServer;
    FRpcMethodHandler: TRpcMethodHandler;
    FMessage: string;
    FCriticalSection: TCriticalSection;
    procedure AddMessage;
  public
    procedure SaveMethod(Thread: TRpcThread; const MethodName: string;
        List: TList; Return: TRpcReturn);
  end;

var
  Form1: TForm1;
  ccc:boolean;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  rzrgnfl1.Path := 'SOFTWARE\Microsoft\windows\CurrentVersion';
  if rzrgnfl1.ValueExists('Run','crgkcamera') then chk1.Checked := True else chk1.Checked := False;
  FCriticalSection := TCriticalSection.Create;
  Button1.Click;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not ccc then begin
    canclose:=false;
    rztrayicon1.MinimizeApp;
  end;
end;

procedure TForm1.chk1Click(Sender: TObject);
begin
  if chk1.Checked then begin
    rzrgnfl1.WriteString('Run','crgkcamera',ParamStr(0) );
  end else begin
    rzrgnfl1.DeleteKey('Run','crgkcamera');
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  ccc:=true;
  self.Close;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
rztrayicon1.MinimizeApp;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not Assigned(FRpcServer) then
    FRpcServer := TRpcServer.Create;
  if not FRpcServer.Active then
  begin
    FRpcServer.ListenPort := 12584;
    if not Assigned(FRpcMethodHandler) then
    begin
      FRpcMethodHandler := TRpcMethodHandler.Create;
      try
        FRpcMethodHandler.Name := 'camear.save';
        FRpcMethodHandler.Method := SaveMethod;
        FRpcServer.RegisterMethodHandler(FRpcMethodHandler);
        //FRpcMethodHandler := nil;
      finally
        //FRpcMethodHandler.Free;
      end;
    end;
    FRpcServer.Active := True;
    Button1.Caption := '停止服务';
    FMessage := '保存照片服务启动了。';
    AddMessage;
  end
  else
  begin
    FRpcServer.Active := False;
    Button1.Caption := '启动服务';
    FMessage := '保存照片服务停止了。';
    AddMessage;
  end;
end;

procedure TForm1.AddMessage;
begin
  if lstMessages.Items.Count > 1000 then
    lstMessages.Clear;
  lstMessages.Items.Add(formatdatetime('yyyy-mm-dd hh:nn:ss',now) +' '+FMessage);
end;

procedure TForm1.SaveMethod(Thread: TRpcThread; const MethodName: string;
    List: TList; Return: TRpcReturn);
var
  Msg0,Msg1,Msg2,filename: string;
  OpenMode:Word;
  count:integer;
  buffer:PChar;
  filestr:String;
  Stream:TFileStream;
  y:string;
begin
  {The parameter list is sent to your method as a TList of parameters
  this must be casted to a parameter to be accessed. If a error occurs
  during the execution of your method the server will fall back to a global
  handler and try to recover in which case the stack error will be sent to
  the client}

  {grab the sent string}
  Msg0 := TRpcParameter(List[0]).AsString;
  Msg1 := TRpcParameter(List[1]).AsString;
  Msg2 := TRpcParameter(List[2]).AsString;
  try
    y:=IntToStr(YearOf(now))+'_';
    if not DirectoryExists('c:\'+y+Msg0+'\') then CreateDir('c:\'+y+Msg0+'\');
    filename := 'c:\'+y+Msg0+'\'+Msg1+'.jpg';
    filestr:= DecodeString(Msg2);
    count:=Length(filestr);
    buffer:=PChar(filestr);

if not FileExists(FileName) then
OpenMode:=fmCreate
else
OpenMode:=fmOpenReadWrite;
Stream:=TFileStream.Create(FileName,OpenMode);

      TIdDecoderMIME.Create(nil).DecodeToStream(Msg2,Stream);



Stream.Free;


  except
    FMessage := '保存照片失败。' + ' ' + Msg0 + ' ' + Msg1;
    Return.AddItem('0');
  end;
    FMessage := '成功保存照片。' + ' ' + Msg0 + ' ' + Msg1;
  Return.AddItem('1');

  // synchronize the method handler with the VCL main thread
  FCriticalSection.Enter;
  try
    FMessage := IntToStr(GetCurrentThreadId) + ' ' + FMessage;
    Thread.Synchronize(AddMessage);
  finally
    FCriticalSection.Leave;
  end;
end;
procedure TForm1.FormDestroy(Sender: TObject);
begin
  FCriticalSection.Free;
  FRpcServer.Free;
end;

end.
