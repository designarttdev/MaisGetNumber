{$R GetNum.dcr}
unit GetNum;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, {$IFNDEF VER130}MaskUtils,{$ENDIF}
  Windows, Graphics, ExtCtrls;

type
  TCustomGetNumber = class(TCustomMaskEdit)
  private
    FEditMask: String;
    InternalMask: String;
    FAlignment: TAlignment;
    Mudanca: Boolean;
    DigitouVirgula: Boolean; //Verifica se digitou a vírgula no getnumber
    FDigitouMenos: Boolean;
    Entrou: Boolean;
    PosNum: Integer;
    CanvasAux: TCanvas;
    ImageAux: TImage;
    { Private declarations }
    function GetValue:Double;
    procedure SetValue(Value: Double);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetEditMask(const Value: String);
    function ApenasNumeroseVirgula(pStr: String): String;
    procedure AlinhaDireita;
    procedure PosicionaCursor;
    function ContaDigitos(S: String): integer;
    procedure PosUltimoDigitoSignificativo;
    function GetIsNull: Boolean;
    procedure SetDigitouMenos(const Value: Boolean); //Apeanas para compatibilidade com o GetNumber original.
    function GetMaxLength: Integer;
    procedure SetMaxLength(const Value: Integer); //Apeanas para compatibilidade com o GetNumber original.
  protected
    { Protected declarations }
    property EditMask: String read FEditMask write SetEditMask;
    property DigitouMenos: Boolean read FDigitouMenos write SetDigitouMenos;
    procedure change; override;
    procedure keypress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure doEnter; Override;
    procedure doExit; Override;
    procedure Click; Override;
    procedure DblClick; Override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure SetFocus; Override;
  published
    { Published declarations }
    property Value: Double Read GetValue Write SetValue;
    property IsNull: Boolean Read GetIsNull;
    property Alignment: TAlignment read FAlignment write SetAlignment
      default taRightJustify;
    property MaxLength: Integer read GetMaxLength write SetMaxLength default 0;
  end;

{ TGetNumber }

  TGetNumber = class(TCustomGetNumber)
  published
    property Alignment;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property Value;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Mais Solucoes', [TGetNumber]);
end;

{ TCustomGetNumber }

function TCustomGetNumber.GetValue: Double;
begin
  Try
    If Trim(ApenasNumerosEVirgula(Self.Text)) = '' then
      Result := 0
    Else
      Result := StrToFloat(ApenasNumerosEVirgula(Self.Text));
  Except
    Result := 0;
  End;
end;

procedure TCustomGetNumber.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGetNumber.SetEditMask(const Value: String);
var
  i: integer;
  Aux: String;
begin
  Aux := Value;
  For i := 1 to Length(Value) do
  Begin
    If Value[i] = 'Z' then
    begin
      if i = Length(Value) then
        Aux[i] := '0'
      else
        Aux[i] := '#';
    end;
    If Value[i] = '.' then
      Aux[i] := ',';
    If Value[i] = ',' then
      Aux[i] := '.';
    If Value[i] = '-' then
      Aux[i] := '#';
    If Value[i] = '9' then
      Aux[i] := '0';
  End;
  InternalMask := Aux;
  FEditMask := Value;
  SetValue(Self.Value);
end;

procedure TCustomGetNumber.SetValue(Value: Double);
var
  vEventoAnt: TNotifyEvent;
begin
  Try
    vEventoAnt := Self.OnChange;
    if Trim(Self.Text) = FormatFloat(InternalMask, Value) then
      Self.OnChange := nil;

    DigitouMenos := StrToFloat(StringReplace(FormatFloat(InternalMask, Value),'.','',[rfReplaceAll])) < 0;
    Self.Text := FormatFloat(InternalMask, Value);
    AlinhaDireita;

    Self.OnChange := vEventoAnt;
  Except
    Self.Text := '0';
  End;
end;

function TCustomGetNumber.ApenasNumeroseVirgula(pStr:String): String;
Var
I: Integer;
begin
  Result := '';
  For I := 1 To Length(pStr) do
   If pStr[I] In ['1','2','3','4','5','6','7','8','9','0',','] Then
     Result := Result + pStr[I];
  If (Result <> '') and DigitouMenos then
    Result := '-' + Result;
end;

procedure TCustomGetNumber.change;
var
  Aux: String;
begin
  inherited change;
  If mudanca then
  Begin
    mudanca := False;
    Aux := ApenasNumerosEVirgula(Self.Text);
    If Aux = '' then
      Aux := '0';

    Self.Value := StrToFloat(Aux);
    If not Self.Focused then
      PosUltimoDigitoSignificativo;
    PosicionaCursor;
    mudanca := True;
  End;
end;

//Coipado do DTDelphi
procedure TCustomGetNumber.AlinhaDireita;
var
  n: Integer;
Begin
  Try
    CanvasAux.Font := Self.Font;
    n := round((Self.Width - CanvasAux.TextWidth(Self.Text) - 8) / CanvasAux.TextWidth(' '))
  Except
    n := 0;
  End;
  Self.Text := stringofchar(' ', n) + Self.Text;
End;

procedure TCustomGetNumber.keypress;
begin
  inherited;
  if Self.ReadOnly then
    Exit;

  If (Key = ',') and (Pos(',', FEditMask) > 0) and (Self.SelStart < Pos(',',Self.Text)) then
  Begin
    DigitouVirgula := true;
    if Trim(Self.SelText) = Trim(Self.Text) then
      Self.Value := 0; 
    Self.Selstart:= Pos(',',Self.Text);
  End;

  If (Self.SelStart >= Pos(',',Self.Text)) and (Pos(',', FEditMask) > 0) then
  Begin
    If Key = Chr(VK_BACK) then
    Begin
      PosNum := Self.SelStart - 1;
      If Self.SelStart = Pos(',',Self.Text) then
      Begin
        Key := #0;
        PosicionaCursor;
      End;
    End
    Else If Self.SelStart < Length(Self.Text) then
      PosNum := Self.SelStart + 1
    Else
      Key := #0;
  End;

  If (DigitouVirgula) and (Self.SelStart < Pos(',',Self.Text)) then
    DigitouVirgula := False;

  If not ((Key in ['0'..'9','-',',']) Or
    (Key = Chr(VK_Back)) OR (Key = Chr(VK_Delete)))   Then
    Key := #0;

  If (Pos(',',FEditMask) <= 0) and (Key = ',') then
    Key := #0;

  If (Pos('-',FEditMask) <=0) and (Key = '-') then
    Key := #0;

  If (Key = ',') and (Pos(',',Self.Text) > 0) then
    Key := #0;

  If (Length(FormatFloat('#',Self.Value)) >= ContaDigitos(FEditMask)) and (key in ['0'..'9'])
    and (not DigitouVirgula) and (Self.SelLength < ContaDigitos(FEditMask)) then
  Begin
    Key := #0;
    If (Pos(',', FEditMask) > 0) then
    Begin
      DigitouVirgula := true;
      Self.Selstart:= Pos(',',Self.Text);
    End;
  End;
end;

procedure TCustomGetNumber.DoEnter;
begin
  inherited;
  If (Pos(',', FEditMask) > 0) and (not DigitouVirgula) then
    PosNum := Pos(',', Self.Text);

  PosicionaCursor;
  Self.SelectAll;
  Entrou := True;
end;

constructor TCustomGetNumber.Create(AOwner: TComponent);
begin
  inherited;
  ImageAux := TImage.Create(Self);
  CanvasAux := ImageAux.Canvas;
  Self.Mudanca := True;
  Self.PosNum := 0;
  DigitouVirgula := False;
  Entrou := False;
end;

procedure TCustomGetNumber.doExit;
begin
  inherited;
  If ApenasNumerosEVirgula(Self.Text) <> '' then
    Self.Value := StrToFloat(ApenasNumerosEVirgula(Self.Text))
  Else
    Self.Value := 0;
  Entrou := False;
  DigitouMenos := Pos('-', Self.Text) > 0;
end;

procedure TCustomGetNumber.Click;
begin
  inherited;
  If not Entrou then
    PosicionaCursor
  Else
  Begin
    SelectAll;
    Entrou := False;
  End;
end;

procedure TCustomGetNumber.PosicionaCursor;
Begin
  If Self.Parent <> nil then
  Begin
    If (Pos(',',Self.Text) > 0) then
    Begin
      If not DigitouVirgula then
        Self.Selstart := Pos(',',Self.Text) - 1
      Else
        Self.SelStart := PosNum;
    End
    Else
      Self.Selstart:= Length(Self.text);
  End;
End;

function TCustomGetNumber.ContaDigitos(S: String): integer;
var
  i, cont: integer;
Begin
  cont := 0;
  For i := 1 to Length(S) do
  Begin
    If S[i] = ',' then
      Break;
    If S[i] <> '.' then
      inc(cont);
  End;
  Result := Cont;
end;

procedure TCustomGetNumber.SetFocus;
begin
  inherited;
  If not Entrou then
    PosicionaCursor;
  Entrou := False;
  Self.SelectAll;
end;

procedure TCustomGetNumber.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  If (key = VK_RIGHT) or (key = VK_LEFT) then
    PosicionaCursor;

end;

procedure TCustomGetNumber.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  If (pos('-',FEditMask) > 0) then
  Begin
    If (Key = 109) or (Key = 189) then
    Begin
      DigitouMenos := not DigitouMenos;
      Key := 0;
      If DigitouVirgula then
        PosNum := Self.SelStart - 1;
      Self.change;
    End;
  End;

  If (Key = VK_Back) and (DigitouMenos) and (Self.Value = 0) then
    DigitouMenos := False;

  If (Key = VK_DELETE) and (Pos(',', FEditMask) > 0) and (Self.SelStart = Pos(',',Self.Text) - 1) then
  Begin
    DigitouVirgula := true;
    Self.Selstart:= Pos(',',Self.Text);
    Key := 0;
  End;
end;

procedure TCustomGetNumber.PosUltimoDigitoSignificativo;
var
  i: integer;
Begin
  If (Pos(',', FEditMask) > 0) then
  Begin
    For i := Length(Self.Text) downto Pos(',',Self.Text) do
    Begin
      If Self.Text[i] = '0' then
        PosNum := i-1;
    End;
    PosicionaCursor;
  End;
End;

function TCustomGetNumber.GetIsNull: Boolean;
begin
  Result := Self.Value = 0;
end;

procedure TCustomGetNumber.SetDigitouMenos(const Value: Boolean);
begin
  If Pos('-',FEditMask) > 0 then
    FDigitouMenos := Value
  Else
    FDigitouMenos := False;
end;

destructor TCustomGetNumber.Destroy;
begin
  ImageAux.Free;
  inherited;
end;

//Ariel 14/01/2013 - Início
function TCustomGetNumber.GetMaxLength: Integer;
begin
  Result := inherited MaxLength;
end;

procedure TCustomGetNumber.SetMaxLength(const Value: Integer);
begin
  inherited MaxLength := 0; //Ariel 14/01/2013 - Se tiver maxlength > 0 não deixa digitar, não precisa da propriedade já que a máscara limita os dígitos.
end;
//Ariel 14/01/2013 - Fim

procedure TCustomGetNumber.DblClick;
begin
  inherited;
  if Self.Enabled then
    Self.SelectAll;
end;

end.
