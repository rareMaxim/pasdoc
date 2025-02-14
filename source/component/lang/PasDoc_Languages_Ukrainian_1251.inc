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
    {trLanguage} '���������', //<<<<<< replace with the name of the new language
  //map
    {trUnits} '������', //'Units',
    {trClassHierarchy} '�������� �����', //'Class Hierarchy',
    {trCio} '�����, ���������� �� ��''����', //'Classes, Interfaces, Objects and Records',
    {trNestedCR} strToDo, // 'Nested Classes and Records',
    {trNestedTypes} strToDo, // 'Nested Types',
    {trIdentifiers} '�������������', //'Identifiers',
    {trGvUses} '������ ��������� ������', //'Unit dependency graph',
    {trGvClasses} {trGvClasses}, //'Classes hierarchy graph',
  //tables and members
    {trClasses} '�����', //'Classes',
      {trClass} '����', //'Class',
      {trDispInterface} strToDo, //'DispInterface',
      {trInterface} '���������', //'Interface',
    {trObjects} '��''����', //'Objects',
      {trObject} '��''���', //'Object',
      {trRecord} strToDo, //'Record',
      {trPacked} strToDo, //'Packed',
        {trHierarchy} '��������', //'Hierarchy',
        {trFields} '����', //'Fields',
        {trMethods} '������', //'Methods',
        {trProperties} '����������', //'Properties',
    {trLibrary} strToDo,  //'Library',
    {trPackage} strToDo,  //'Package',
    {trProgram} '��������',  //'Program',
    {trUnit} '������', //'Unit',
      {trUses} '��������������� �����', //'Uses',
      {trConstants} '���������', //'Constants',
      {trFunctionsAndProcedures} '��������� �� �������', //'Functions and Procedures',
      {trTypes} '����', //'Types',
        {trType} '���', //'Type',
      {trVariables} '�����', //'Variables',
      {trAuthors} '������', //'Authors',
        {trAuthor} '�����', //'Author',
      {trCreated} '���������', //'Created',
      {trLastModified} '������� ����', //'Last Modified',
    {trSubroutine} strToDo, //'Subroutine',
      {trParameters} '���������', //'Parameters',
      {trReturns} '������� ��������', //'Returns',
      {trExceptionsRaised} '�� �������', //'Exceptions raised',
    {trExceptions} '�������', //'Exceptions',
      {trException} strToDo, //'Exception',
    {trEnum} '������', //'Enumeration',
  //visibilities
    {trVisibility} '���� ��������', //'Visibility',
      {trPrivate} strToDo, //'Private',
      {trStrictPrivate} strToDo, //'Strict Private',
      {trProtected} strToDo, //'Protected',
      {trStrictProtected} strToDo, //'Strict Protected',
      {trPublic} strToDo, //'Public',
      {trPublished} strToDo, //'Published',
      {trAutomated} strToDo, //'Automated',
      {trImplicit} strToDo, //'Implicit',
  //hints
    {trDeprecated} '��� ������ ����� �� ���������������', //'this symbol is deprecated',
    {trPlatformSpecific} '��� ������ �������� �� ���������', //'this symbol is specific to some platform',
    {trLibrarySpecific} '��� ������ �������� �� ��������', //'this symbol is specific to some library',
    {trExperimental} strToDo, //'this symbol is experimental',
  //headings
    {trOverview} '�����', //'Overview',
    {trIntroduction} '�����', //'Introduction',
    {trConclusion} '��������', //'Conclusion',
    {trAdditionalFile} strToDo, //'additional file',
    {trEnclosingClass} strToDo, //'Enclosing Class',
    {trHeadlineCio} '�� �����, ���������� �� ��''����', //'All Classes, Interfaces, Objects and Records',
    {trHeadlineConstants} '�� ���������', //'All Constants',
    {trHeadlineFunctionsAndProcedures} '�� ��������� �� �������', //'All Functions and Procedures',
    {trHeadlineIdentifiers} '�� ��������������', //'All Identifiers',
    {trHeadlineTypes} '�� ����', //'All Types',
    {trHeadlineUnits} '�� �����', //'All Units',
    {trHeadlineVariables} '�� �����', //'All Variables',
    {trSummaryCio} '������ �����, ���������� �� ��''����', //'Summary of Classes, Interfaces, Objects and Records',
  //column headings
    {trDeclaration} '����������', //'Declaration',
    {trDescription} '����', //'Description',
    {trDescriptions} strToDo, //'Descriptions', 'Detailed Descriptions'?
    {trName} '�����', //'Name',
    {trValues} '��������', //'Values',
  //tags with inbuilt heading
    {trWarningTag} strToDo,
    {trNoteTag} strToDo,
  //empty
    {trNone} '����', //'None',
    {trNoCIOs} '����� �� ������ �����, ����������, ��''���� �� ������.', //'The units do not contain any classes, interfaces, objects or records.',
    {trNoCIOsForHierarchy} '����� �� ������ �����, ���������� �� ��''����.', //'The units do not contain any classes, interfaces or objects.',
    {trNoTypes} '����� �� ������ ����.', //'The units do not contain any types.',
    {trNoVariables} '����� �� ������ ������.', //'The units do not contain any variables.',
    {trNoConstants} '����� �� ������ ���������.', //'The units do not contain any constants.',
    {trNoFunctions} '����� �� ������ ������� �� ��������.', //'The units do not contain any functions or procedures.',
    {trNoIdentifiers} '����� �� ������ ������� ��������������.', //'The units do not contain any identifiers.',
  //misc
    {trHelp} '��������', //'Help',
    {trLegend} '����������', //'Legend',
    {trMarker} '������', //'Marker',
    {trWarningOverwrite} '������������: �� ��������� - ��� ���� ��������� ����������� �, ������ �� ���, ���� ���� ������������', //'Warning: Do not edit - this file has been created automatically and is likely be overwritten',
    {trWarning} '�����', //'Warning',
    {trGeneratedBy} strToDo, //'Generated by',
    {trGeneratedOn} strToDo, //'Generated on'
    {trOnDateTime} strToDo, //'on',
    {trSearch} strToDo, //'Search',
    {trSeeAlso} strToDo, //'See also',
    {trNested} strToDo, //'nested',
    {trAttributes} strToDo, //'Attributes',
    ''  //dummy
  );
