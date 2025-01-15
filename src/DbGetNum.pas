unit DbGetNum;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, GetNum, Db, DbCtrls;

type
  TDbGetNumber = class(TGetNumber)
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
  RegisterComponents('Mais Solucoes', [TDbGetNumber]);
end;

function TDbGetNumber.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDbGetNumber.SetDataSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDbGetNumber.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TDbGetNumber.SetDataField(const Value: string);
begin
  if not (csDesigning in ComponentState) then
    ResetMaxLength;
  FDataLink.FieldName := Value;
end;

procedure TDbGetNumber.ResetMaxLength;
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

Constructor TDbGetNumber.Create(AOwner: TComponent);
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

procedure TDbGetNumber.DataChange(Sender: TObject);
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

procedure TDbGetNumber.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

procedure TDbGetNumber.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  FDataLink.Field.Value := Value;
end;

procedure TDbGetNumber.ActiveChange(Sender: TObject);
begin
  ResetMaxLength;
end;

end.
