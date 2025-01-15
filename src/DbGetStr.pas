unit DbGetStr;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, GetStr, Db, DbCtrls;

type
  TDbGetString = class(TGetString)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    FFocused: Boolean;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure ResetMaxLength;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure ActiveChange(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property DataSource: TDataSource read GetDataSource Write SetDataSource;
    property DataField: String read GetDataField Write SetDataField;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Mais Solucoes', [TDbGetString]);
end;

function TDbGetString.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDbGetString.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDbGetString.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDbGetString.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then
    ResetMaxLength;
  FDataLink.FieldName := Value;
end;

procedure TDbGetString.ResetMaxLength;
var
  F: TField;
begin
  if (MaxLength > 0) and Assigned(DataSource) and Assigned(DataSource.DataSet) then
  begin
    F := DataSource.DataSet.FindField(DataField);
    if Assigned(F) and (F.DataType in [ftString, ftWideString]) and (F.Size = MaxLength) then
      MaxLength := 0;
  end;
end;

Constructor TDbGetString.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited ReadOnly := True;
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
end;

procedure TDbGetString.DataChange(Sender: TObject);
Begin
  if FDataLink.Field <> nil then
  Begin
    If FDataLink.Field.DataType in [ftFloat,ftInteger] then
    Begin
      if FFocused and FDataLink.CanModify then
        Value := FDataLink.Field.Value;
    End;
  End;
End;

procedure TDbGetString.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TDbGetString.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  FDataLink.Field.Value := Value;
end;

procedure TDbGetString.ActiveChange(Sender: TObject);
begin
  ResetMaxLength;
end;

end.
