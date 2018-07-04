/**
 *  Derived from  the main text of the Java Language Specification
 *
 *  author: Ali Afroozeh
 */
module java::JavaNatural

extend java::\lexical::ContextAware;


/************************************************************************************************************************
 * Types, Values, and Variables
 ***********************************************************************************************************************/

syntax Type 
     = PrimitiveType ("[" "]")*
     | ReferenceType ("[" "]")*
     ;

syntax PrimitiveType 
     = "byte"
     | "short"
     | "char"
     | "int"
     | "long"
     | "float"
     | "double"
     | "boolean"
     ;
     
syntax ReferenceType
     = Identifier TypeArguments? ( "." Identifier TypeArguments? )*
     ;
     
syntax TypeArguments 
     = "\<" {TypeArgument ","}+ "\>" 
     ;
        
syntax TypeArgument 
     = simpleTypeArgument:   Type
     | wildCardTypeArgument: "?" (("extends" | "super") Type)?  
     ;     

syntax TypeList
     = {Type ","}+
     ;
     
syntax NonWildTypeArguments
     = "\<" { Type ","}+ "\>"
     ;     
     
syntax TypeArgumentsOrDiamond 
     = "\<" "\>" 
     | TypeArguments
     ;     
     
syntax ReferenceTypeNonArrayType
     = TypeDeclSpecifier TypeArguments?
     ;
     
syntax TypeParameters 
     = "\<" {TypeParameter ","}+ "\>"
     ;

syntax TypeParameter 
     = Identifier TypeBound?
     ;     
     
syntax TypeBound 
     = "extends" {ReferenceType "&"}+
     ;      
      
syntax QualifiedIdentifier 
     = {Identifier "."}+;

syntax QualifiedIdentifierList 
     = {QualifiedIdentifier  ","}+;

/************************************************************************************************************************
 * Top level
 ***********************************************************************************************************************/

start syntax CompilationUnit 
    = PackageDeclaration? ImportDeclaration* TypeDeclaration*
      ;
  
syntax PackageDeclaration 
     = Annotation* "package"  QualifiedIdentifier ";" 
     ;  
  
syntax ImportDeclaration 
    = "import" "static"? {Identifier "."}+ ("." "*")? ";" 
    ;
  
syntax TypeDeclaration
    = ClassDeclaration
    | InterfaceDeclaration
    | ";"
    ;
    
syntax ClassDeclaration 
     = NormalClassDeclaration
     | EnumDeclaration
     ;
    
syntax InterfaceDeclaration 
     = NormalInterfaceDeclaration
     | AnnotationTypeDeclaration
     ;

syntax NormalClassDeclaration 
     = ClassModifier* "class" Identifier TypeParameters? ("extends" Type)? ("implements" TypeList)? ClassBody;
    

syntax EnumDeclaration
     = ClassModifier* "enum" Identifier ("implements" TypeList)? EnumBody
     ;
     
syntax NormalInterfaceDeclaration 
     = InterfaceModifier* "interface" Identifier TypeParameters? ("extends" TypeList)? InterfaceBody
     ;

syntax AnnotationTypeDeclaration 
     = InterfaceModifier* "@" "interface" Identifier AnnotationTypeBody
     ;
    
 /************************************************************************************************************************
 * Classes
 ***********************************************************************************************************************/
      

syntax ClassModifier
     = Annotation
     | "public"
     | "protected" 
     | "private"
     | "abstract" 
     | "static" 
     | "final" 
     | "strictfp"
     ;
     
syntax ConstructorModifier
     = Annotation 
     | "public"
     | "protected"
     | "private"
     ;
     
syntax InterfaceModifier
     = Annotation
     | "public"
     | "protected"
     | "private"
     | "abstract"
     | "static"
     | "strictfp"
     ;
     
syntax ConstantModifier
     = Annotation
     | "public"
     | "static"
     | "final"
     ;

syntax AbstractMethodModifier
     = Annotation
     | "public"
     | "abstract"
     ;          
     
syntax FieldModifier
     = Annotation 
     | "public" 
     | "protected" 
     | "private"
     | "static"
     | "final" 
     | "transient"
     | "volatile"
     ;

syntax MethodModifier 
     = Annotation
     | "public" 
     | "protected"
     | "private"
     | "abstract" 
     | "static"
     | "final"
     | "synchronized"
     | "native"
     | "strictfp"
     ;
     
syntax VariableModifier 
    = Annotation
    | "final"
    ;     
     
/************************************************************************************************************************
 * Annotations
 ***********************************************************************************************************************/
  
syntax Annotation 
    = "@" QualifiedIdentifier  ( "(" AnnotationElement? ")" )?
    ;
    
syntax AnnotationElement
    = { ElementValuePair "," }+
    | { ElementValue "," }+
    ;        

syntax ElementValuePair 
    = Identifier "=" ElementValue
    ;

syntax ElementValue 
    = Expression !ao
    | Annotation
    | ElementValueArrayInitializer
    ;

syntax ElementValueArrayInitializer 
    = "{" { ElementValue "," }* ","? "}"
    ;
    
syntax ClassBody 
    = "{" ClassBodyDeclaration* "}"
    ;

syntax ClassBodyDeclaration
     = Initializer
     | ConstructorDeclaration
     | FieldDeclaration 
     | MethodDeclaration 
     | ClassDeclaration 
     | InterfaceDeclaration
     | ";"
     ;
     
syntax Initializer
     = "static"? Block
     ;     
     
syntax ConstructorDeclaration
     = ConstructorModifier* TypeParameters? Identifier "(" FormalParameterList? ")" Throws? Block
     ;
     
/************************************************************************************************************************
 * Interfaces
 ***********************************************************************************************************************/	 
	           
syntax InterfaceBody
     = "{" InterfaceMemberDeclaration* "}"
     ;
     
syntax InterfaceMemberDeclaration
     = ConstantDeclaration 
     | AbstractMethodDeclaration 
     | ClassDeclaration 
     | InterfaceDeclaration
     | ";"
     ;
     
syntax ConstantDeclaration
     = ConstantModifier* Type {VariableDeclarator ","}+ ";"
     ;
          
syntax AbstractMethodDeclaration
     = AbstractMethodModifier* TypeParameters? Result MethodDeclarator Throws? ";"
     ;
          
syntax AnnotationTypeBody
     = "{" AnnotationTypeElementDeclaration* "}"
     ;

syntax AnnotationTypeElementDeclaration 
     = AbstractMethodModifier* Type Identifier "(" ")" ("[" "]")* DefaultValue? ";" 
     | ConstantDeclaration
     | ClassDeclaration
     | InterfaceDeclaration
     | AnnotationTypeDeclaration
     | ";"
     ;
     
syntax DefaultValue
     = "default" ElementValue
     ;
	 
/************************************************************************************************************************
 * Fields
 ***********************************************************************************************************************/
	 
syntax FieldDeclaration
     = FieldModifier* Type {VariableDeclarator ","}+ ";"
     ;

syntax VariableDeclarator
     = VariableDeclaratorId ("=" VariableInitializer)?
     ;
     
syntax VariableDeclaratorId 
    = Identifier ("[" "]")*
    ;

syntax VariableInitializer 
    = ArrayInitializer
    | Expression
    ;
    
syntax ArrayInitializer 
    = "{"  {VariableInitializer ","}* ","? "}"
    ;
    
/************************************************************************************************************************
 * Methods
 ***********************************************************************************************************************/

syntax MethodDeclaration
     = MethodModifier* TypeParameters? Result MethodDeclarator Throws? MethodBody
     ;
     
syntax MethodDeclarator
     = Identifier "(" FormalParameterList? ")" ("[" "]")*
     ;
     
syntax FormalParameterList
     = (FormalParameter ",")* LastFormalParameter
     ;
     
syntax FormalParameter
     = VariableModifier* Type VariableDeclaratorId
     ;

syntax LastFormalParameter
     = VariableModifier* Type "..." VariableDeclaratorId
     | FormalParameter
     ;
     
syntax Result
     = Type
     | "void"
     ;

syntax Throws
     = "throws" {QualifiedIdentifier ","}+
     ;
     
syntax MethodBody
     = Block
     | ";"
     ;

/************************************************************************************************************************
 * Enums
 ***********************************************************************************************************************/
     
syntax EnumBody
     = "{" {EnumConstant ","}* ","? EnumBodyDeclarations? "}"
     ;     
     
syntax EnumConstant
     = Annotation* Identifier Arguments? ClassBody?
     ;
     
syntax Arguments
     = "(" ArgumentList? ")"
     ;
     
syntax EnumBodyDeclarations
     = ";" ClassBodyDeclaration*
     ;

/************************************************************************************************************************
 * Statements
 ***********************************************************************************************************************/

syntax Block 
     = "{" BlockStatement* "}"
     ;

syntax BlockStatement 
     = LocalVariableDeclarationStatement
     | ClassDeclaration
     | Statement
     ;

syntax LocalVariableDeclarationStatement 
     = VariableModifier* Type {VariableDeclarator ","}+ ";"
     ;

syntax Statement
     = Block
     | ";" 
     | StatementExpression ";"
     | "assert" Expression (":" Expression)? ";" 
     | "switch" "(" Expression ")" "{" SwitchBlockStatementGroup* SwitchLabel* "}" 
     | "do" Statement "while" "(" Expression ")" ";" 
     | "break" Identifier? ";" 
     | "continue" Identifier? ";" 
     | "return" Expression? ";" 
     | "synchronized" "(" Expression ")" Block 
     | "throw" Expression ";" 
     | "try" Block (CatchClause+ | (CatchClause* Finally))
     | "try" ResourceSpecification Block CatchClause* Finally? 
     | Identifier ":" Statement
     | "if" "(" Expression ")" Statement !>>> "else"
     | "if" "(" Expression ")" Statement "else" Statement
     | "while" "(" Expression ")" Statement
     | "for" "(" ForControl ")" Statement
     ;

syntax ForControl
	= ForInit? ";" Expression? ";" ForUpdate?
	| FormalParameter ":" Expression
	;

syntax StatementExpression
     = Expression !lt !gt
     ;
    
syntax CatchClause 
    = "catch" "(" VariableModifier* CatchType Identifier ")" Block
    ;

syntax CatchType  
    =  {QualifiedIdentifier "|"}+
    ;

syntax Finally 
    = "finally" Block
    ;

syntax ResourceSpecification 
    = "(" Resources ";"? ")"
    ;

syntax Resources 
    = {Resource ";"}+
    ;

syntax Resource 
     = VariableModifier* ReferenceType VariableDeclaratorId "=" Expression
     ; 

syntax SwitchBlockStatementGroup 
	     = SwitchLabel+ BlockStatement+
     ;

syntax SwitchLabel 
     = "case" ConstantExpression ":"
     | "default" ":"
     ;

syntax LocalVariableDeclaration 
    = VariableModifier* Type { VariableDeclarator ","}+
    ;

syntax ForInit 
     = {StatementExpression ","}+
     | LocalVariableDeclaration
     ;
     
syntax ForUpdate 
     = {StatementExpression ","}+
     ;    

/************************************************************************************************************************
 * Expressions
 ***********************************************************************************************************************/

syntax Expression
     = Expression !io "." Identifier
     | Expression "." "this"
	 | Expression "." "new" TypeArguments? Identifier TypeArgumentsOrDiamond? "(" ArgumentList? ")" ClassBody?
	 | Expression "." NonWildTypeArguments ExplicitGenericInvocationSuffix     
     | Expression "." "super" ("." Identifier)? Arguments
     | Type "." "class"
     | "void" "." "class"
	 | Expression !brackets "(" ArgumentList? ")"     
     | Expression "[" Expression "]"
     | Expression "++"
     | Expression "--"
     > up: "+" !>> "+" Expression
     | um: "-" !>> "-" Expression
     | "++" Expression
     | "--" Expression 
     | "!" Expression
     | "~" Expression
     | "new" ClassInstanceCreationExpression
     | newArray: "new" ArrayCreationExpression
     | "(" Type ")" Expression 
     > left( Expression "*" Expression 
     |       Expression "/" Expression
     |       Expression "%" Expression )
     > left( Expression "+" !>> "+" Expression
     |       Expression "-" !>> "-" Expression )
     > left( Expression "\<\<" Expression 
     |       Expression "\>\>" !>> "\>" Expression
     |       Expression "\>\>\>" Expression )
     > left( 
       lt:   Expression "\<" !>> "=" !>> "\<" Expression
     | gt:   Expression "\>" !>> "=" !>> "\>" Expression 
     |       Expression "\<=" Expression
     |       Expression "\>=" Expression )
     > io:   Expression "instanceof" Type
     > left( Expression "==" Expression
     |       Expression "!=" Expression )
     > left  Expression "&" !>> "&" Expression
     > left  Expression "^" Expression
     > left  Expression "|" !>> "|" Expression 
     > left  Expression "&&" Expression
     > left  Expression "||" Expression
     > right Expression "?" Expression ":" Expression 
     > right ao: Expression !lt !gt AssignmentOperator Expression
     | brackets: "(" Expression ")"
     | Primary
     ;
     
syntax Primary
	 = Literal
     | "this"
     | "super"
     | Identifier
     ;     

syntax ClassInstanceCreationExpression
     =  TypeArguments? TypeDeclSpecifier TypeArgumentsOrDiamond? "(" ArgumentList? ")" ClassBody? 
     ;
          
syntax ArgumentList
     = {Expression ","}+
     ;     

syntax ArrayCreationExpression
	 = (PrimitiveType | ReferenceType) DimExpr+ ("[" "]")*
	 | (PrimitiveType | ReferenceTypeNonArrayType) ("[" "]")+ ArrayInitializer
     ;

syntax DimExpr
     = "[" Expression "]"
     ;
     
syntax ConstantExpression
     = Expression
     ;
     
syntax ClassName
	 = QualifiedIdentifier
	 ;
	 
syntax MethodName
     = QualifiedIdentifier
     ;
     
syntax TypeDeclSpecifier
     = Identifier (TypeArguments? "." Identifier)*
     ;     

syntax SuperSuffix 
     =  Arguments 
     | "." Identifier Arguments?
     ;

 syntax ExplicitGenericInvocationSuffix 
 	  = "super" SuperSuffix
 	  | Identifier Arguments
 	  ;
     
     