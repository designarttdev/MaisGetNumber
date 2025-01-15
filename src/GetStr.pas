{$R GetStr.dcr}
unit GetStr;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask;

type
  TCustomGetString = class(TCustomMaskEdit)
  private
    { Private declarations }
    FPromptChar: String;
    function GetValue:String;
    procedure SetValue(Value: String);
    function GetAlignment: TAlignment;
    procedure SetAlignment(const Value: TAlignment);
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Value: String Read GetValue Write SetValue;
    property Alignment: TAlignment Read GetAlignment Write SetAlignment;
    property PromptChar: String read FPromptChar write FPromptChar;
  end;

{ TGetString }

  TGetString = class(TCustomGetString)
  published
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
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
  RegisterComponents('Mais Solucoes', [TGetString]);
end;

{ TCustomGetString }

function TCustomGetString.GetAlignment: TAlignment;
begin
  Result := TALeftJustify;
end;

function TCustomGetString.GetValue: String;
begin
  Result := Self.Text;
end;

procedure TCustomGetString.SetAlignment(const Value: TAlignment);
begin

end;

procedure TCustomGetString.SetValue(Value: String);
begin
  Self.Text := Value;
end;

end.
