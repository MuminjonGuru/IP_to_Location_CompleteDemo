unit IPtoLocation.MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TFormMain = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Text1: TText;
    StyleBook1: TStyleBook;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

uses
  System.JSON, System.Threading;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  // get host IP address here and set it to Edit1.Text;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      RESTClient1.ResetToDefaults;
      RESTClient1.Accept :=
        'application/json, text/plain; q=0.9, text/html;q=0.8,';
      RESTClient1.AcceptCharset := 'utf-8, *;q=0.8';
      RESTClient1.BaseURL := 'https://api.apilayer.com/ip_to_location/' +
        Edit1.Text;
      RESTClient1.ContentType := 'application/json';

      RESTRequest1.ClearBody;
      RESTRequest1.Params.Clear;

      // API acc. key
      RESTRequest1.Params.AddItem;
      RESTRequest1.Params.Items[0].Kind := pkHTTPHEADER;
      RESTRequest1.Params.Items[0].Name := 'apikey';
      RESTRequest1.Params.Items[0].Value := 'QdSe87VnIPlTkpLrS5i46iVl8XJqlDlf';
      RESTRequest1.Params.Items[0].Options := [poDoNotEncode];

      RESTRequest1.Execute;
    end);

  Memo1.Lines.Clear;
  Memo1.Lines.Add(RESTResponse1.Content);
end;

procedure TFormMain.Button3Click(Sender: TObject);
begin
  var ArrayElement: TJSONValue;
  var JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);
  var JSONArray := JSONValue.GetValue<TJSONArray>('currencies');
  try
    if JSONValue is TJSONObject then
    begin
      Memo1.Lines.Add('City: ' + JSONValue.GetValue<String>('city'));
      Memo1.Lines.Add('Country Code: ' + JSONValue.GetValue<String>('country_code'));
      Memo1.Lines.Add('Continent Name: ' + JSONValue.GetValue<String>('continent_name'));

      for ArrayElement in JSONArray do
      begin
        Memo1.Lines.Add('Info: ' + ArrayElement.GetValue<String>('name'));
        Memo1.Lines.Add('Info: ' + ArrayElement.GetValue<String>('code'));
      end;

    end;
  finally
    JSONValue.Free;
  end;
end;

end.

