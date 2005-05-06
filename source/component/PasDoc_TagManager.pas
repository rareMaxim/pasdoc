unit PasDoc_TagManager;

interface

uses
  SysUtils,
  Classes,
  PasDoc_Types;

type
  TTagManager = class;

  { TagManager can be useful for various things:

    E.g. you can use it in tag handler to report a message
    by @code(TagManager.DoMessage(...)), this is e.g. used
    by implementation of TPasItem.StoreAbstractTag.
    
    You could also use this to manually force recursive
    behavior of a given tag. I.e let's suppose that you
    have a tag with TagOptions = [toParameterRequired],
    so the TagDesc parameter passed to handler was
    not recursively expanded. Then you can do inside your handler
    @longcode# NewTagDesc := TagManager.Execute(TagDesc) #
    and this way you have explicitly recursively expanded the tag.

    This is not used anywhere for now, but this will be used
    when I will implement auto-linking (making links without
    the need to use @@link tag). Then I will have to make @@nolink
    tag, and TTagManager.Execute will get a parameter
    @code(AutoLink: boolean). Then inside @@nolink tag I will
    be able to call TTagManager.Execute(TagDesc, false)
    thus preventing auto-linking inside text within @@nolink. }
  TTagHandler = procedure(TagManager: TTagManager;
    const TagName: string; const TagDesc: string; var ReplaceStr: string)
    of object;
  TStringConverter = function(const s: string): string of object;
  
  TTagOption = (
    { This means that tag expects parameters. If this is not included 
      in TagOptions then tag should not be given any parameters,
      i.e. TagDesc passed to @link(TTagHandlerObj.Execute) should be ''.
      We will display a warning if user will try to give
      some parameters for such tag. }
    toParameterRequired, 
    
    { This means that parameters of this tag will be expanded
      before passing them to @link(TTagHandlerObj.Execute).
      This means that we will expand recursive tags inside
      parameters, that we will ConvertString inside parameters,
      that we will handle paragraphs inside parameters etc. --
      all that does @link(TTagManager.Execute).

      If toParameterRequired is not present in TTagOptions than
      it's not important whether you included toRecursiveTags.

      It's useful for some tags to include toParameterRequired
      without including toRecursiveTags, e.g. @@longcode or @@html,
      that want to get their parameters "verbatim", not processed. }
    toRecursiveTags);
      
  TTagOptions = set of TTagOption;

  TTagHandlerObj = class
  private
    FTagHandler: TTagHandler;
    FTagOptions: TTagOptions;
  public
    constructor Create(ATagHandler: TTagHandler;
      const ATagOptions: TTagOptions);

    property TagOptions: TTagOptions read FTagOptions write FTagOptions;

    procedure Execute(TagManager: TTagManager;
      const TagName: string; const TagDesc: string; var ReplaceStr: string);
  end;

  TTagManager = class
  private
    FTags: TStringList;
    FStringConverter: TStringConverter;
    FAbbreviations: TStringList;
    FOnMessage: TPasDocMessageEvent;
    FParagraph: string;

    function ConvertString(const s: string): string;
    procedure Unabbreviate(var s: string);
  public
    constructor Create;
    destructor Destroy; override;

    { Call OnMessage (if assigned) with given params. }
    procedure DoMessage(const AVerbosity: Cardinal;
      const MessageType: TMessageType; const AMessage: string;
      const AArguments: array of const);

    { This will be used to print messages from within @link(Execute).

      Note that in this unit we essentialy "don't know"
      that parsed Description string is probably attached to some TPasItem.
      It's good that we don't know it (because it makes this class more flexible).
      But it also means that OnMessage that you assign here may want to add
      to passed AMessage something like + ' (Expanded_TPasItem_Name)',
      see e.g. TDocGenerator.DoMessageFromExpandDescription.
      Maybe in the future we will do some descendant of this class,
      like TTagManagerForPasItem. }
    property OnMessage: TPasDocMessageEvent read FOnMessage write FOnMessage;

    { This will be inserted on paragraph marker (two consecutive newlines,
      see wiki page WritingDocumentation) in the text.
      This should specify how paragraphs are marked in particular
      output format, e.g. html generator may set this to '<p>'.
      
      Default value is ' ' (one space). }
    property Paragraph: string read FParagraph write FParagraph;

    { See @link(TTagHandlerObj) for the meaning of parameter TagOption.
      Don't worry about the case of TagName, it does *not* matter. }
    procedure AddHandler(const TagName: string; Handler: TTagHandler;
      const TagOptions: TTagOptions);

    function Execute(const Description: string): string;
    property StringConverter: TStringConverter read FStringConverter write FStringConverter;
    property Abbreviations: TStringList read FAbbreviations write FAbbreviations;
  end;

implementation

uses Utils {$ifndef VER1_0}, StrUtils {$endif};

{ TTagHandlerObj }

constructor TTagHandlerObj.Create(ATagHandler: TTagHandler;
  const ATagOptions: TTagOptions);
begin
  inherited Create;
  FTagHandler := ATagHandler;
  FTagOptions := ATagOptions;
end;

procedure TTagHandlerObj.Execute(TagManager: TTagManager;
  const TagName, TagDesc: string; var ReplaceStr: string);
begin
  if Assigned(fTagHandler) then
    fTagHandler(TagManager, TagName, TagDesc, ReplaceStr);
end;

{ TTagManager }

constructor TTagManager.Create;
begin
  inherited Create;
  FTags := TStringList.Create;
  FTags.Sorted := true;
  FParagraph := ' ';
end;

destructor TTagManager.Destroy;
var
  i: integer;
begin
  if FTags <> nil then
    begin
      for i:=0 to FTags.Count-1 do
        FTags.Objects[i].Free;
      FTags.Free;
    end;
  inherited;
end;

procedure TTagManager.AddHandler(const TagName: string; Handler: TTagHandler;
  const TagOptions: TTagOptions);
begin
  FTags.AddObject(LowerCase(Tagname),
    TTagHandlerObj.Create(Handler, TagOptions));
end;

function TTagManager.ConvertString(const s: string): string;
begin
  if Assigned(FStringConverter) then
    Result := FStringConverter(s)
  else
    Result := s;
end;

procedure TTagManager.Unabbreviate(var s: string);
var
  idx: Integer;
begin
  if Assigned(Abbreviations) then begin
    idx := Abbreviations.IndexOfName(s);
    if idx>=0 then begin
      s := Abbreviations.Values[s];
    end;
  end;
end;

procedure TTagManager.DoMessage(const AVerbosity: Cardinal; const
  MessageType: TMessageType; const AMessage: string;
  const AArguments: array of const);
begin
  if Assigned(FOnMessage) then
    FOnMessage(MessageType, Format(AMessage, AArguments), AVerbosity);
end;

function TTagManager.Execute(const Description: string): string;
var
  { This is the position of next char in Description to work with,
    i.e. first FOffset-1 chars in Description are considered "done"
    ("done" means that their converted version is appended to Result) }
  FOffset: Integer;

  { This checks if some tag starts at Description[FOffset + 1].
    If yes then it returns true and sets
    -- TagHandlerObj to given tag object
    -- TagName to lowercased name of this tag (e.g. 'link')
    -- Parameters to params for this tag (text specified between '(' ')',
       parsed to the matching parenthesis)
    -- OffsetEnd to the index of *next* character in Description right
       after this tag (including it's parameters, if there were any)

    Note that it may also change it's var parameters even when it returns
    false; this doesn't harm anything for now, so I don't think there's
    a reason to correct this for now.

    In case some string looking as tag name (A-Za-z*) is here,
    but it's not a name of any existing tag,
    it not only returns false but also emits a warning for user. }
  function FindTag(var TagHandlerObj: TTagHandlerObj;
    var TagName: string; var Parameters: string;
    var OffsetEnd: Integer): Boolean;
  var
    i: Integer;
    BracketCount: integer;
    TagIndex: integer;
  begin
    Result := False;
    Parameters := '';
    i := FOffset + 1;

    while (i <= Length(Description)) and
          (Description[i] in ['A'..'Z', 'a'..'z']) do
      Inc(i);

    if i = FOffset + 1 then Exit; { exit with false }

    TagName := LowerCase(Copy(Description, FOffset + 1, i - FOffset - 1));
    OffsetEnd := i;

    if not FTags.Find(TagName, TagIndex) then
    begin
      DoMessage(1, mtWarning, 'Unknown tag name "%s"', [TagName]);
      Exit;
    end;

    TagHandlerObj := FTags.Objects[TagIndex] as TTagHandlerObj;
    Result := true;

    { OK, we found the correct tag.
      TagHandlerObj and TagName are already set.
      Now lets get the parameters, setting Parameters and OffsetEnd. }

    if (i <= Length(Description)) and (Description[i] = '(') then
    begin
      { Read Parameters to a matching parenthesis.
        Note that we didn't check here whether
        toParameterRequired in TagHandlerObj.TagOptions.
        Caller of FindTag will give a warning for user if it will
        receive some Parameters <> '' while
        toParameterRequired is *not* in TagHandlerObj.TagOptions }
      Inc(i);
      BracketCount := 1;
      repeat
        case Description[i] of
          '(': Inc(BracketCount);
          ')': Dec(BracketCount);
        end;
        Inc(i);
      until (i > Length(Description)) or (BracketCount = 0);
      if (BracketCount = 0) then begin
        Parameters := Copy(Description, OffsetEnd + 1, i - OffsetEnd - 2);
        OffsetEnd := i;
      end else
        DoMessage(1, mtWarning,
          'No matching closing parenthesis for tag "%s"', [TagName]);
    end else
    if toParameterRequired in TagHandlerObj.TagOptions then
    begin
      { Read Parameters to the end of Description or newline. }
      while (i <= Length(Description)) and
            (not (Description[i] in [#10, #13])) do
        Inc(i);
      Parameters := Trim(Copy(Description, OffsetEnd, i - OffsetEnd));
      OffsetEnd := i;
    end;
  end;

  { This checks whether we are looking (i.e. Description[FOffset] 
    starts with) at a pargraph marker
    (i.e. newline + 
          optional whitespace + 
          newline + 
          some more optional whitespaces and newlines)
    and if it is so, returns true and sets OffsetEnd to the next
    index in Description after this paragraph marker. }
  function FindParagraph(var OffsetEnd: Integer): boolean;
  const
    { Whitespace that is not any part of newline. }
    WhiteSpaceNotNL = [' ', #9];
    { Whitespace that is some part of newline. }
    WhiteSpaceNL = [#10, #13];
    { Any whitespace (that may indicate newline or not) }
    WhiteSpace = WhiteSpaceNotNL + WhiteSpaceNL;
  var i: Integer;
  begin
    Result := false;
    
    i := FOffset;
    while SCharIs(Description, i, WhiteSpaceNotNL) do Inc(i);
    if not SCharIs(Description, i, WhiteSpaceNL) then Exit;
    { In case newline is two-characters wide, read it to the end
      (to not accidentaly take #13#10 as two newlines.) }
    Inc(i);
    if (i <= Length(Description)) and
       ( ((Description[i-1] = #10) and (Description[i] = #13)) or
         ((Description[i-1] = #13) and (Description[i] = #10))
       ) then
      Inc(i);
    while SCharIs(Description, i, WhiteSpaceNotNL) do Inc(i);
    if not SCharIs(Description, i, WhiteSpaceNL) then Exit;
    
    { OK, so we found 2nd newline. So we got paragraph marker.
      Now read it to the end. }
    Result := true;
    while SCharIs(Description, i, WhiteSpace) do Inc(i);
    OffsetEnd := i;
    
    {}{Writeln('Para --------------------');
    Writeln('"', Description, '" ', FOffset);
    Writeln('--------------------');}
  end;

var
  { Always ConvertBeginOffset <= FOffset. 
    Description[ConvertBeginOffset ... FOffset - 1] 
    is the string that should be filtered by ConvertString. }
  ConvertBeginOffset: Integer;

  { This function increases ConvertBeginOffset to FOffset,
    appending converted version of
    Description[ConvertBeginOffset ... FOffset - 1]
    to Result. }
  procedure DoConvert;
  begin
    Result := Result + ConvertString(
      Copy(Description, ConvertBeginOffset, FOffset - ConvertBeginOffset));
    ConvertBeginOffset := FOffset;
  end;

var
  ReplaceStr: string;
  TagName: string;
  Params: string;
  OffsetEnd: Integer;
  TagHandlerObj: TTagHandlerObj;
begin
  Result := '';
  FOffset := 1;
  ConvertBeginOffset := 1;
  
  { Description[FOffset] is the next char that must be processed
    (we're "looking at it" right now). }

  while FOffset <= Length(Description) do
  begin
    if (Description[FOffset] = '@') and
       FindTag(TagHandlerObj, TagName, Params, OffsetEnd) then
    begin
      DoConvert;
      
      if Params <> '' then
      begin
        if toParameterRequired in TagHandlerObj.TagOptions then
        begin
          Unabbreviate(Params);
          if toRecursiveTags in TagHandlerObj.TagOptions then
            Params := Execute(Params); { recursively expand Params }
        end else
        begin
          { Note that in this case we ignore whether
            toRecursiveTags is in TagHandlerObj.TagOptions,
            we always behave like toRecursiveTags was not included.

            This is reported as a serious warning,
            because tag handler procedure will probably ignore
            passed value of Params and will set ReplaceStr to something
            unrelated to Params. This means that user input is completely
            discarded. So user should really correct it.

            I didn't mark this as an mtError only because some sensible
            output will be generated anyway. }
          DoMessage(1, mtWarning,
            'Tag "%s" is not allowed to have any parameters', [TagName]);
        end;
        ReplaceStr := ConvertString('@(' + TagName) + Params + ConvertString(')');
      end else
        ReplaceStr := ConvertString('@' + TagName);
      TagHandlerObj.Execute(Self, TagName, Params, ReplaceStr);

      Result := Result + ReplaceStr;
      FOffset := OffsetEnd;
      
      ConvertBeginOffset := FOffset;
    end else
    if (Description[FOffset] = '@') and
       (FOffset < Length(Description)) and
       (Description[FOffset + 1] = '@') then
    begin
      DoConvert;
      
      { convert '@@' to '@' }      
      Result := Result + '@';
      FOffset := FOffset + 2;
      
      ConvertBeginOffset := FOffset;
    end else
    if FindParagraph(OffsetEnd) then
    begin
      DoConvert;
      
      Result := Result + Paragraph;
      FOffset := OffsetEnd;
      
      ConvertBeginOffset := FOffset;
    end else
      Inc(FOffset);
  end;

  DoConvert;

  { Only for testing:
  Writeln('----');
  Writeln('Description was "', Description, '"');
  Writeln('Result is "', Result, '"');
  Writeln('----');}
end;

end.
