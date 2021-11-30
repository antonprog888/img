{*******************************************************}
{                                                       }
{                       EhLib v5.6                      }
{                       EhLib v6.0                      }
{                   Resource of strings                 }
{                                                       }
{      Copyright (c) 2001-2012 by Dmitry V. Bolshakov   }
{                                                       }
{*******************************************************}

unit EhLibConsts;

interface

resourcestring
  SClearSelectedCellsEh = 'Очистити виділені комірки?';
  SInvalidTextFormatEh = 'Неправильний формат тексту';
  SInvalidVCLDBIFFormatEh = 'Неправильний формат VCLDBIF';
  SErrorDuringInsertValueEh = 'Помилка при вставці значення:';
  SIgnoreErrorEh = 'Ігнорувати помилку?';
  STabularInformationEh = 'Таблична інформація';
  SPageOfPagesEh = 'Сторінка %d з %d';
  SPreviewEh =  'Попередній перегляд';
  SFieldNameNotFoundEh = 'Ім''я поля ''%s'' не знайдено';
  SFindDialogStringNotFoundMessageEh = 'Строка "%s" не знайдена';
  SVisibleColumnsEh = 'Видимі колонки';
  SCutEh = 'Вирізати';
  SCopyEh = 'Копиювати';
  SPasteEh = 'Вставити';
  SDeleteEh = 'Видалити';
  SSelectAllEh = 'Виділити все';

  SSTFilterListItem_Empties = '(Пусті)';
  SSTFilterListItem_NotEmpties = '(Не пусті)';
  SSTFilterListItem_All = '(Все)';
  SSTFilterListItem_ClearFilter = '(Очистити фільтр)';
  SSTFilterListItem_SortingByDescend = '(Упорядкувати за збільшенням)';
  SSTFilterListItem_SortingByAscend = '(Упорядкувати по убуванню)';
  SSTFilterListItem_ApplyFilter = '(Apply filter)';
  SSTFilterListItem_CustomFilter = '(Custom...)';

  SSimpFilter_equals              = 'equals';
  SSimpFilter_does_not_equal      = 'does not equal';
  SSimpFilter_is_greate_than      = 'is greate than';
  SSimpFilter_is_greate_than_or_equall_to = 'is greate than or equall to';
  SSimpFilter_is_less_than        = 'is less than';
  SSimpFilter_is_less_than_or_equall_to = 'is less than or equall to';
  SSimpFilter_begins_with         = 'begins with';
  SSimpFilter_does_not_begin_with = 'does not begin with';
  SSimpFilter_ends_with           = 'ends with';
  SSimpFilter_does_not_end_with   = 'does not end with';
  SSimpFilter_contains            = 'contains';
  SSimpFilter_does_not_contain    = 'does not contain';
  SSimpFilter_like                = 'like';
  SSimpFilter_not_like            = 'not like';
  SSimpFilter_in_list             = 'in list';
  SSimpFilter_not_in_list         = 'not in list';
  SSimpFilter_is_blank            = 'is blank';
  SSimpFilter_is_not_blank        = 'is not blank';

  SGroupingPanelText = 'Drag a column header here to group by that column';

  SNoDataEh = '<No Records>'; //'No data';

    // Error message
  SQuoteIsAbsentEh = 'Quote is absent: ';
  SLeftBracketExpectedEh = '''('' expected: ';
  SRightBracketExpectedEh = ''')'' expected: ';
  SErrorInExpressionEh = 'Error in expression: ';
  SUnexpectedExpressionBeforeNullEh = 'Unexpected expression before Null: ';
  SUnexpectedExpressionAfterOperatorEh = 'Unexpected expression after operator: ';
  SIncorrectExpressionEh = 'Incorrect expression: ';
  SUnexpectedANDorOREh = 'Unexpected AND or OR: ';

  SGridSelectionInfo_Sum = 'Sum';
  SGridSelectionInfo_Cnt = 'Count';
  SGridSelectionInfo_Evg = 'Average';
  SGridSelectionInfo_Min = 'Min';
  SGridSelectionInfo_Max = 'Max';

  SFirstRecordEh = 'First record';
  SPriorRecordEh = 'Prior record';
  SNextRecordEh = 'Next record';
  SLastRecordEh = 'Last record';
  SInsertRecordEh = 'Insert record';
  SDeleteRecordEh = 'Delete record';
  SEditRecordEh = 'Edit record';
  SPostEditEh = 'Post edit';
  SCancelEditEh = 'Cancel edit';
  SConfirmCaptionEh = 'Confirm';
  SRefreshRecordEh = 'Refresh data';

  SDeleteMultipleRecordsQuestionEh = 'Delete %d selected records?';
  SDeleteAllRecordsQuestionEh = 'Delete All records?';

  SDuplicateVarNameEh = 'A Variable named ''%s'' already exists in the Collection';

  SSearchPanelEditorPromptText = 'Search...';
  SUnsupportedFieldTypeEh = 'Unsupported field type (%s) in field %s';

implementation

end.

