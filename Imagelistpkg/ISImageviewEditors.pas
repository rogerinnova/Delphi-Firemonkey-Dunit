unit ISImageviewEditors;
//http://docwiki.embarcadero.com/RADStudio/XE5/en/Creating_a_Component_Editor_and_a_Property_Editor_for_FireMonkey_Components
{$I InnovaLibDefs.inc}
interface

uses
  DesignEditors, DesignIntf, System.SysUtils, System.UITypes
  ;

type
  TISFMXImageListComponentEditor = class(TComponentEditor)
  private
    procedure ShowDesigner;
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

{  TISFMXImageListPropertyEditor = class(TPropertyEditor)
  private
    procedure ShowDesigner;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;
}

procedure Register;

implementation

uses ISFMXImagelistEditorDLG, IsFMXImageList;

{ Register the component editor in the IDE
  To register a component editor to IDE, you need to call the RegisterComponentEditor routine from a register procedure, as follows:
}
procedure Register;
begin
  RegisterComponentEditor(TFMXImageList, TISFMXImageListComponentEditor);
//  RegisterPropertyEditor(TypeInfo(string), TFMXImageList, 'Format', TISFMXImageListPropertyEditor);
end;
{ TISFMXImageListComponentEditor }

procedure TISFMXImageListComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
      ShowDesigner;
  else
    raise ENotImplemented.Create
      ('TISFMXImageListComponentEditor has only one verb (index = 0) supported.');
  end;
end;

function TISFMXImageListComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
      Result := '&Show Editor';
  else
    raise ENotImplemented.Create
      ('TISFMXImageListComponentEditor has only one verb (index = 0) supported.');
  end;
end;

function TISFMXImageListComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TISFMXImageListComponentEditor.ShowDesigner;
var
  DesignerForm: TFmxImageListEditor;
begin
  DesignerForm := TFmxImageListEditor.Create(nil);
  try
    // Set curent value to designer form
    //Component;
    if Component is TFMXImageList   then
      Begin
        DesignerForm.CurrentFMXImageList := TFMXImageList(Component);
        // Show ModalForm, and then take result
        if DesignerForm.ShowModal = mrOK then
           {};
      End;
    Designer.Modified;
  finally
    DesignerForm.Free;
  end;
end;

(*
{ TISFMXImageListPropertyEditor  }

procedure TISFMXImageListPropertyEditor.Edit;
begin
  ShowDesigner;
end;

function TISFMXImageListPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;


procedure TISFMXImageListPropertyEditor.ShowDesigner;
var
  DesignerForm: TFmxImageListEditor;
  Component:Tobject;
begin
  DesignerForm := TFmxImageListEditor.Create(nil);
  try
    // Set curent value to designer form
    Component:=GetComponent(0);
    if Component is TFMXImageList   then
      Begin
        DesignerForm.CurrentFMXImageList := TFMXImageList(Component);
        // Show ModalForm, and then take result
        if DesignerForm.ShowModal = mrOK then
           {};
      End;
    Designer.Modified;
  finally
    DesignerForm.Free;
  end;
end; *)
end.
