unit FBankAccountLookup;

interface

uses
    ActnList
  , Classes
  , Controls
  , Forms
  , FrBankAcctIDSearchGrid
  , FrSearchGrids
  , FTransactViewForms
  , Menus
  , omBankAccountLookupModels
  , omComponentGroupManagers
  , omSecureActions
  , omStatusBars
  , StdCtrls
  , System.Actions
  , SysUtils
  , Variants
  , Vcl.AppEvnts
  , Vcl.ImgList
  , Windows
  ;


type
  TFormBankAccountLookup = class(TomTransactViewForm)
    FrameBankAcctIDSearchGrid: TFrameBankAcctIDSearchGrid;
    PopupMenuIdentity: TPopupMenu;
    ActionShowInIdentityMaster: TAction;
    MenuItemShowInIdentityMaster: TMenuItem;
    ImageList1: TImageList;
    ButtonShowInIDMaster: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionShowInIdentityMasterExecute(Sender: TObject);
    procedure ActionShowInIdentityMasterUpdate(Sender: TObject);
    procedure FrameBankAcctIDSearchGridButtonCloseClick(Sender: TObject);
  private
    function Model: TomBankAccountLookupModel;
  end;

implementation

{$R *.dfm}

uses
    omIdentityMasterModels
  , FTransactConsoles
  , omCxGridUtils
  , cxGridCustomTableView
  , cxGridDBTableView
  ;

//__________________________________________________________________________________________________

procedure TFormBankAccountLookup.ActionShowInIdentityMasterExecute(Sender: TObject);
var
  IDMasterModel: TomIdentityMasterModel;
  TransactConsoleForm : TFormTransactConsole;
  SelectedRow: TcxCustomGridRecord;
  IDRefColIndex: Integer;
  IDRef: String;
begin
  IDMasterModel := Model.ParentModel as TomIdentityMasterModel;
  TransactConsoleForm := IDMasterModel.MVC.View.Form.Owner as TFormTransactConsole;

  SelectedRow := FrameBankAcctIDSearchGrid.cxGridIdDBTableView.Controller.SelectedRows[0];
  IDRefColIndex :=
    (SelectedRow.GridView as TcxGridDBTableView).DataController.GetItemByFieldName('IdRef').Index;
  IDRef := SelectedRow.Values[IDRefColIndex];

  TransactConsoleForm.SwitchToMultiIdentityMasterGrid(IDRef, False);
end;

//__________________________________________________________________________________________________

procedure TFormBankAccountLookup.ActionShowInIdentityMasterUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    omCxGridUtils.IsSingleDataRowSelected(FrameBankAcctIDSearchGrid.cxGridIdDBTableView);
end;

//__________________________________________________________________________________________________

procedure TFormBankAccountLookup.FormDestroy(Sender: TObject);
begin
  FrameBankAcctIDSearchGrid.Deinit;
  inherited;
end;

//__________________________________________________________________________________________________

procedure TFormBankAccountLookup.FormShow(Sender: TObject);
begin
  inherited;
  if not Assigned(FrameBankAcctIDSearchGrid.SearchParams) then begin
    FrameBankAcctIDSearchGrid.Init(Model.Workspace, Model.SearchParams, Self);
  end;
  if FrameBankAcctIDSearchGrid.MaskEditSortCode.CanFocus then begin
    FrameBankAcctIDSearchGrid.MaskEditSortCode.SetFocus;
  end;
end;

//__________________________________________________________________________________________________

procedure TFormBankAccountLookup.FrameBankAcctIDSearchGridButtonCloseClick(
  Sender: TObject);
begin
  Close;
end;

//__________________________________________________________________________________________________

function TFormBankAccountLookup.Model: TomBankAccountLookupModel;
begin
  Result := Self.MVC.Model.ModelObject as TomBankAccountLookupModel;
end;

//__________________________________________________________________________________________________

end.
