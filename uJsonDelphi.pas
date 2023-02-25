unit uJsonDelphi;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, System.JSON, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, uBitmapHelper;

type
  TfrmJSONDelphi = class(TForm)
    MemoJSON: TMemo;
    MemoPokemon: TMemo;
    Image1: TImage;
    edtNomePokemon: TEdit;
    btnCarregarJSON: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Label1: TLabel;
    Panel1: TPanel;
    procedure btnCarregarJSONClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmJSONDelphi: TfrmJSONDelphi;

implementation

{$R *.fmx}

procedure TfrmJSONDelphi.btnCarregarJSONClick(Sender: TObject);
var
  jsonObj: TJSONObject;
  jsonValue: TJSONValue;
  ArrayPokemon, ArraySprites: TJSONArray;
  i, idPokemon: Integer;
  urlImg: string;
begin
  MemoJSON.Lines.Clear;
  MemoPokemon.Lines.Clear;
  Try
    RESTClient1.BaseURL := 'https://pokeapi.co/api/v2/pokemon/' + edtNomePokemon.Text;
    RESTRequest1.Execute;

    if RESTResponse1.StatusCode = 200 then
    begin
      jsonValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);

      Try
        jsonObj := jsonValue as TJSONObject;
        MemoJSON.Lines.Add(jsonValue.ToString);

        MemoPokemon.Lines.Add('ID: ' +jsonValue.GetValue<string>('id'));
        MemoPokemon.Lines.Add('Nome: ' +jsonValue.GetValue<string>('name'));

        idPokemon := StrToInt(jsonValue.GetValue<string>('id'));

        jsonValue := jsonObj.Get('types').JsonValue;
        //MemoJSON.Lines.Add(jsonValue.ToString);
        ArrayPokemon :=  TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jsonValue.ToString), 0) as TJSONArray;

        for i := 0 to ArrayPokemon.Size - 1 do
        begin
          MemoPokemon.Lines.Add('Tipo: ' +ArrayPokemon.Items[i].GetValue<string>('slot') + ' - '
                                +ArrayPokemon.Items[i].FindValue('type').GetValue<string>('name'));
        end;

        urlImg := 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' +IntToStr(idPokemon)+ '.png';
        Image1.Bitmap.LoadFromUrl(urlImg);
      Finally
        jsonValue.Free;
        ArrayPokemon.DisposeOf;
      End;
    end;
  Except
    on e:exception do
    begin
      ShowMessage(e.Message);
    end;
  End;
end;

end.
