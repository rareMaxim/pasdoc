(* New language template. To add a new language or encoding:

  1) Copy this file (PasDoc_Languages_Template_New_Language.inc)
     into more approprate filename.

  2) Add your language to PasDoc_Languages.pas array. See other languages
     for examples. You want to
     - add a new value to TLanguageID type,
     - define a const named aXxx,
     - and add a new row to LANGUAGE_ARRAY table describing your language.

  3) Then, of course, do the actual translation :)
     Replace all occurences of strToDo by
     - your translation of the text in the comment,
     - or rename them into strKeep for all strings that need no translation,
     - or leave the strToDo in place, if you don't know the translation.

     For "normal" PasDoc builds, both strToDo and strKeep are equal
     (in fact, they are just empty strings) and mean
     "use the English version". The distinction between strToDo and strKeep
     is mainly for you, and other devs/translators, so that we know
     when you really want to show English version and when you just can't
     decide what is the proper translation.
*)
RTransTable = (
    {trNoTrans} '<what?>', //no ID assigned, so far
    {trLanguage} 'Українська', //<<<<<< replace with the name of the new language
  //map
    {trUnits} 'Модуль', //'Units',
    {trClassHierarchy} 'Ієрархія класів', //'Class Hierarchy',
    {trCio} 'Класи, інтерфейси та Об''єкти', //'Classes, Interfaces, Objects and Records',
    {trNestedCR} strToDo, // 'Nested Classes and Records',
    {trNestedTypes} strToDo, // 'Nested Types',
    {trIdentifiers} 'Ідентифікатор', //'Identifiers',
    {trGvUses} 'Графік залежності модулів', //'Unit dependency graph',
    {trGvClasses} 'Графік ієрархії класів', //'Classes hierarchy graph',
  //tables and members
    {trClasses} 'Класи', //'Classes',
      {trClass} 'Клас', //'Class',
      {trDispInterface} strToDo, //'DispInterface',
      {trInterface} 'Інтерфейс', //'Interface',
    {trObjects} 'Об''єкти', //'Objects',
      {trObject} 'Об''єкт', //'Object',
      {trRecord} strToDo, //'Record',
      {trPacked} strToDo, //'Packed',
        {trHierarchy} 'Ієрархія', //'Hierarchy',
        {trFields} 'Поля', //'Fields',
        {trMethods} 'Методи', //'Methods',
        {trProperties} 'Властивості', //'Properties',
    {trLibrary} strToDo,  //'Library',
    {trPackage} strToDo,  //'Package',
    {trProgram} 'Програма',  //'Program',
    {trUnit} 'Модуль', //'Unit',
      {trUses} 'Використовувані модулі', //'Uses',
      {trConstants} 'Константи', //'Constants',
      {trFunctionsAndProcedures} 'Процедури та функції', //'Functions and Procedures',
      {trTypes} 'Типи', //'Types',
        {trType} 'Тип', //'Type',
      {trVariables} 'Змінні', //'Variables',
      {trAuthors} 'Автори', //'Authors',
        {trAuthor} 'Автор', //'Author',
      {trCreated} 'Створений', //'Created',
      {trLastModified} 'Остання зміна', //'Last Modified',
    {trSubroutine} strToDo, //'Subroutine',
      {trParameters} 'Параметри', //'Parameters',
      {trReturns} 'Повертає значення', //'Returns',
      {trExceptionsRaised} 'Дає винятки', //'Exceptions raised',
    {trExceptions} 'Винятки', //'Exceptions',
      {trException} strToDo, //'Exception',
    {trEnum} 'Перелік', //'Enumeration',
  //visibilities
    {trVisibility} 'Зона видимості', //'Visibility',
      {trPrivate} strToDo, //'Private',
      {trStrictPrivate} strToDo, //'Strict Private',
      {trProtected} strToDo, //'Protected',
      {trStrictProtected} strToDo, //'Strict Protected',
      {trPublic} strToDo, //'Public',
      {trPublished} strToDo, //'Published',
      {trAutomated} strToDo, //'Automated',
      {trImplicit} strToDo, //'Implicit',
  //hints
    {trDeprecated} 'Цей символ більше не використовується', //'this symbol is deprecated',
    {trPlatformSpecific} 'Цей символ залежить від платформи', //'this symbol is specific to some platform',
    {trLibrarySpecific} 'Цей символ залежить від бібліотеки', //'this symbol is specific to some library',
    {trExperimental} strToDo, //'this symbol is experimental',
  //headings
    {trOverview} 'Огляд', //'Overview',
    {trIntroduction} 'Вступ', //'Introduction',
    {trConclusion} 'Висновок', //'Conclusion',
    {trAdditionalFile} strToDo, //'additional file',
    {trEnclosingClass} strToDo, //'Enclosing Class',
    {trHeadlineCio} 'Усі класи, інтерфейси та Об''єкти', //'All Classes, Interfaces, Objects and Records',
    {trHeadlineConstants} 'Всі константи', //'All Constants',
    {trHeadlineFunctionsAndProcedures} 'Усі процедури та функції', //'All Functions and Procedures',
    {trHeadlineIdentifiers} 'Усі ідентифікатори', //'All Identifiers',
    {trHeadlineTypes} 'Всі типи', //'All Types',
    {trHeadlineUnits} 'Всі модулі', //'All Units',
    {trHeadlineVariables} 'Всі змінні', //'All Variables',
    {trSummaryCio} 'Список класів, інтерфейсів та Об''єктів', //'Summary of Classes, Interfaces, Objects and Records',
  //column headings
    {trDeclaration} 'Оголошення', //'Declaration',
    {trDescription} 'Опис', //'Description',
    {trDescriptions} strToDo, //'Descriptions', 'Detailed Descriptions'?
    {trName} 'Назва', //'Name',
    {trValues} 'Значення', //'Values',
  //tags with inbuilt heading
    {trWarningTag} strToDo,
    {trNoteTag} strToDo,
  //empty
    {trNone} 'Немає', //'None',
    {trNoCIOs} 'Модулі не містять класів, інтерфейсів, Об''єктів та записів.', //'The units do not contain any classes, interfaces, objects or records.',
    {trNoCIOsForHierarchy} 'Модулі не містять класів, інтерфейсів та Об''єктів.', //'The units do not contain any classes, interfaces or objects.',
    {trNoTypes} 'Модулі не містять типів.', //'The units do not contain any types.',
    {trNoVariables} 'Модулі не містять змінних.', //'The units do not contain any variables.',
    {trNoConstants} 'Модулі не містять константи.', //'The units do not contain any constants.',
    {trNoFunctions} 'Модулі не містять функцій та процедур.', //'The units do not contain any functions or procedures.',
    {trNoIdentifiers} 'Модулі не містять жодного ідентифікатора.', //'The units do not contain any identifiers.',
  //misc
    {trHelp} 'Допомога', //'Help',
    {trLegend} 'Позначення', //'Legend',
    {trMarker} 'Маркер', //'Marker',
    {trWarningOverwrite} 'ПОПЕРЕДЖЕННЯ: Не редагуйте - цей файл створений автоматично і, швидше за все, його буде перезаписано', //'Warning: Do not edit - this file has been created automatically and is likely be overwritten',
    {trWarning} 'Увага', //'Warning',
    {trGeneratedBy} strToDo, //'Generated by',
    {trGeneratedOn} strToDo, //'Generated on'
    {trOnDateTime} strToDo, //'on',
    {trSearch} strToDo, //'Search',
    {trSeeAlso} strToDo, //'See also',
    {trNested} strToDo, //'nested',
    {trAttributes} strToDo, //'Attributes',
    ''  //dummy
  );
