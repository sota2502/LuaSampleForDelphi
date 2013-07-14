unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, Lua, LuaUtils;

type
    TCard = class
    private
        FHeart:   TBitmap;
        FSpade:   TBitmap;
        FCurrentImage: TBitmap;
        FX, FY:   Double;
        FVX, FVY: Double;
        FLuaState: Plua_State;
    public
        constructor Create(PosX, PosY: Double);
        destructor Destroy; override;

        procedure ChangeImage;
        procedure Move;

        property CurrentImage: TBitmap read FCurrentImage;
        property X: Double read FX;
        property Y: Double read FY;
        property VX: Double read FVX;
        property VY: Double read FVY;
    end;

type
    TForm1 = class(TForm)
        Timer1: TTimer;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    private
        { Private êÈåæ }
        FCard: TCard;
        FBuffer: TBitmap;
    public
        { Public êÈåæ }

        property Card: TCard read FCard;
    end;

var
    Form1: TForm1;

const
    CANVAS_WIDTH  = 320;
    CANVAS_HEIGHT = 240;

function ChangeImageGlue(L: Plua_State): Integer; cdecl;


implementation

{$R *.dfm}

function ChangeImageGlue(L: Plua_State): Integer;
begin
    Form1.Card.ChangeImage;
    Result := 1;
end;

constructor TCard.Create(PosX, PosY: Double);
begin
    FX := PosX;
    FY := PosY;
    FVX := 1;
    FVY := 1;

    FHeart := TBitmap.Create;
    FHeart.LoadFromFile('heart.bmp');

    FSpade := TBitmap.Create;
    FSpade.LoadFromFile('spade.bmp');

    FCurrentImage := FHeart;

    FLuaState := luaL_newstate;
    luaL_openlibs(FLuaState);
    luaL_dofile(FLuaState, 'operate.lua');
    lua_register(FLuaState, 'ChangeImageGlue', ChangeImageGlue);
end;

destructor TCard.Destroy;
begin
    FHeart.Free;
    FSpade.Free;

    lua_close(FLuaState);
end;

procedure TCard.ChangeImage;
begin
    if FCurrentImage = FHeart then
        FCurrentImage := FSpade
    else
        FCurrentImage := FHeart;
end;

procedure TCard.Move;
begin
    lua_getglobal(FLuaState, 'move_for_lua');
    lua_pushnumber(FLuaState, FX);
    lua_pushnumber(FLuaState, FY);
    lua_pushnumber(FLuaState, FVX);
    lua_pushnumber(FLuaState, FVY);

    lua_call(FLuaState, 4, 4);

    FX  := lua_tonumber(FLuaState, -4);
    FY  := lua_tonumber(FLuaState, -3);
    FVX := lua_tonumber(FLuaState, -2);
    FVY := lua_tonumber(FLuaState, -1);
end;

procedure TForm1.FormCreate(Sender: TObject);
var x, y: Double;
begin
    Self.ClientWidth  := CANVAS_WIDTH;
    Self.ClientHeight := CANVAS_HEIGHT;

    Randomize;
    x := Random(CANVAS_WIDTH);
    y := Random(CANVAS_HEIGHT);

    FCard := TCard.Create(x, y);

    FBuffer                    := TBitmap.Create;
    FBuffer.Canvas.Brush.Color := clWhite;
    FBuffer.Width              := CANVAS_WIDTH;
    FBuffer.Height             := CANVAS_HEIGHT;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    FCard.Free;
    FBuffer.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var x, y: Integer;
begin
    FCard.Move;

    x := Trunc(FCard.X);
    y := Trunc(FCard.Y);
    FBuffer.Canvas.FillRect(Rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT));
    FBuffer.Canvas.Draw(x, y, FCard.CurrentImage);

    Self.Canvas.Draw(0, 0, FBuffer);
end;

end.
