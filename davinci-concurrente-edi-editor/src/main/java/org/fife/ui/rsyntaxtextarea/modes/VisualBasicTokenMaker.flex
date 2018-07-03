/*
 * 03/24/2013
 *
 * VisualBasicTokenMaker.java - Scanner for Visual Basic
 * 
 * This library is distributed under a modified BSD license.  See the included
 * RSyntaxTextArea.License.txt file for details.
 */
package org.fife.ui.rsyntaxtextarea.modes;

import java.io.*;
import javax.swing.text.Segment;

import org.fife.ui.rsyntaxtextarea.*;


/**
 * Scanner for Visual Basic.
 *
 * This implementation was created using
 * <a href="http://www.jflex.de/">JFlex</a> 1.4.1; however, the generated file
 * was modified for performance.  Memory allocation needs to be almost
 * completely removed to be competitive with the handwritten lexers (subclasses
 * of <code>AbstractTokenMaker</code>, so this class has been modified so that
 * Strings are never allocated (via yytext()), and the scanner never has to
 * worry about refilling its buffer (needlessly copying chars around).
 * We can achieve this because RText always scans exactly 1 line of tokens at a
 * time, and hands the scanner this line as an array of characters (a Segment
 * really).  Since tokens contain pointers to char arrays instead of Strings
 * holding their contents, there is no need for allocating new memory for
 * Strings.<p>
 *
 * The actual algorithm generated for scanning has, of course, not been
 * modified.<p>
 *
 * If you wish to regenerate this file yourself, keep in mind the following:
 * <ul>
 *   <li>The generated VisualBasicTokenMaker.java</code> file will contain two
 *       definitions of both <code>zzRefill</code> and <code>yyreset</code>.
 *       You should hand-delete the second of each definition (the ones
 *       generated by the lexer), as these generated methods modify the input
 *       buffer, which we'll never have to do.</li>
 *   <li>You should also change the declaration/definition of zzBuffer to NOT
 *       be initialized.  This is a needless memory allocation for us since we
 *       will be pointing the array somewhere else anyway.</li>
 *   <li>You should NOT call <code>yylex()</code> on the generated scanner
 *       directly; rather, you should use <code>getTokenList</code> as you would
 *       with any other <code>TokenMaker</code> instance.</li>
 * </ul>
 *
 * @author Robert Futrell
 * @version 1.0
 */
%%

%public
%class VisualBasicTokenMaker
%extends AbstractJFlexTokenMaker
%unicode
%ignorecase
%type org.fife.ui.rsyntaxtextarea.Token


%{


	/**
	 * Constructor.  This must be here because JFlex does not generate a
	 * no-parameter constructor.
	 */
	public VisualBasicTokenMaker() {
	}


	/**
	 * Adds the token specified to the current linked list of tokens.
	 *
	 * @param tokenType The token's type.
	 * @see #addToken(int, int, int)
	 */
	private void addHyperlinkToken(int start, int end, int tokenType) {
		int so = start + offsetShift;
		addToken(zzBuffer, start,end, tokenType, so, true);
	}


	/**
	 * Adds the token specified to the current linked list of tokens.
	 *
	 * @param tokenType The token's type.
	 */
	private void addToken(int tokenType) {
		addToken(zzStartRead, zzMarkedPos-1, tokenType);
	}


	/**
	 * Adds the token specified to the current linked list of tokens.
	 *
	 * @param tokenType The token's type.
	 * @see #addHyperlinkToken(int, int, int)
	 */
	private void addToken(int start, int end, int tokenType) {
		int so = start + offsetShift;
		addToken(zzBuffer, start,end, tokenType, so, false);
	}


	/**
	 * Adds the token specified to the current linked list of tokens.
	 *
	 * @param array The character array.
	 * @param start The starting offset in the array.
	 * @param end The ending offset in the array.
	 * @param tokenType The token's type.
	 * @param startOffset The offset in the document at which this token
	 *                    occurs.
	 * @param hyperlink Whether this token is a hyperlink.
	 */
	public void addToken(char[] array, int start, int end, int tokenType,
						int startOffset, boolean hyperlink) {
		super.addToken(array, start,end, tokenType, startOffset, hyperlink);
		zzStartRead = zzMarkedPos;
	}


	/**
	 * Returns the text to place at the beginning and end of a
	 * line to "comment" it in a this programming language.
	 *
	 * @return The start and end strings to add to a line to "comment"
	 *         it out.
	 */
	public String[] getLineCommentStartAndEnd() {
		return new String[] { "'", null };
	}


	/**
	 * Returns the first token in the linked list of tokens generated
	 * from <code>text</code>.  This method must be implemented by
	 * subclasses so they can correctly implement syntax highlighting.
	 *
	 * @param text The text from which to get tokens.
	 * @param initialTokenType The token type we should start with.
	 * @param startOffset The offset into the document at which
	 *        <code>text</code> starts.
	 * @return The first <code>Token</code> in a linked list representing
	 *         the syntax highlighted text.
	 */
	public Token getTokenList(Segment text, int initialTokenType, int startOffset) {

		resetTokenList();
		this.offsetShift = -text.offset + startOffset;

		// Start off in the proper state.
		int state = YYINITIAL;

		s = text;
		try {
			yyreset(zzReader);
			yybegin(state);
			return yylex();
		} catch (IOException ioe) {
			ioe.printStackTrace();
			return new Token();
		}

	}


	/**
	 * Refills the input buffer.
	 *
	 * @return      <code>true</code> if EOF was reached, otherwise
	 *              <code>false</code>.
	 */
	private boolean zzRefill() {
		return zzCurrentPos>=s.offset+s.count;
	}


	/**
	 * Resets the scanner to read from a new input stream.
	 * Does not close the old reader.
	 *
	 * All internal variables are reset, the old input stream 
	 * <b>cannot</b> be reused (internal buffer is discarded and lost).
	 * Lexical state is set to <tt>YY_INITIAL</tt>.
	 *
	 * @param reader   the new input stream 
	 */
	public final void yyreset(java.io.Reader reader) {
		// 's' has been updated.
		zzBuffer = s.array;
		/*
		 * We replaced the line below with the two below it because zzRefill
		 * no longer "refills" the buffer (since the way we do it, it's always
		 * "full" the first time through, since it points to the segment's
		 * array).  So, we assign zzEndRead here.
		 */
		//zzStartRead = zzEndRead = s.offset;
		zzStartRead = s.offset;
		zzEndRead = zzStartRead + s.count - 1;
		zzCurrentPos = zzMarkedPos = zzPushbackPos = s.offset;
		zzLexicalState = YYINITIAL;
		zzReader = reader;
		zzAtBOL  = true;
		zzAtEOF  = false;
	}


%}

Letter							= [A-Za-z]
LetterOrUnderscore				= ({Letter}|"_")
NonzeroDigit						= [1-9]
Digit							= ("0"|{NonzeroDigit})
HexDigit							= ({Digit}|[A-Fa-f])
NonSeparator						= ([^\t\f\r\n\ \(\)\{\}\[\]\;\,\.\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%\"\']|"#"|"\\")
IdentifierStart					= ({LetterOrUnderscore}|"$")
IdentifierPart						= ({IdentifierStart}|{Digit})

LineTerminator			= (\n)
WhiteSpace				= ([ \t\f])

UnclosedStringLiteral	= ([\"][^\"]*)
StringLiteral			= ({UnclosedStringLiteral}[\"])

LineCommentBegin		= "'"

NumTypeSuffix			= (([DRI\&SF]|"UI"|"UL"|"US")?)
IntegerLiteral			= ({Digit}+{NumTypeSuffix})
HexLiteral				= ("&h"{HexDigit}+{NumTypeSuffix})
FloatHelper				= ([eE][+-]?{Digit}+{NumTypeSuffix})
FloatLiteral1			= ({Digit}+"."({NumTypeSuffix}|{FloatHelper}|{Digit}+({NumTypeSuffix}|{FloatHelper})))
FloatLiteral2			= ("."{Digit}+({NumTypeSuffix}|{FloatHelper}))
FloatLiteral3			= ({Digit}+({NumTypeSuffix}|{FloatHelper}))
FloatLiteral			= ({FloatLiteral1}|{FloatLiteral2}|{FloatLiteral3})
ErrorNumberFormat		= (({IntegerLiteral}|{HexLiteral}|{FloatLiteral}){NonSeparator}+)
BooleanLiteral			= ("true"|"false")

Separator				= ([\(\)])
Separator2				= ([\;,.])

Operator				= ("&"|"&="|"*"|"*="|"+"|"+="|"="|"-"|"-="|"<<"|"<<="|">>"|">>="|"/"|"/="|"\\"|"\\="|"^"|"^=")

Identifier				= ({IdentifierStart}{IdentifierPart}*)
ErrorIdentifier			= ({NonSeparator}+)

URLGenDelim				= ([:\/\?#\[\]@])
URLSubDelim				= ([\!\$&'\(\)\*\+,;=])
URLUnreserved			= ({LetterOrUnderscore}|{Digit}|[\-\.\~])
URLCharacter			= ({URLGenDelim}|{URLSubDelim}|{URLUnreserved}|[%])
URLCharacters			= ({URLCharacter}*)
URLEndCharacter			= ([\/\$]|{Letter}|{Digit})
URL						= (((https?|f(tp|ile))"://"|"www.")({URLCharacters}{URLEndCharacter})?)

%state EOL_COMMENT

%%

<YYINITIAL> {

	/* Keywords */
	"AddHandler" |
	"AddressOf" |
	"Alias" |
	"And" |
	"AndAlso" |
	"As" |
	"ByRef" |
	"ByVal" |
	"Call" |
	"Case" |
	"Catch" |
	"CBool" |
	"CByte" |
	"CChar" |
	"CDate" |
	"CDbl" |
	"CDec" |
	"CInt" |
	"Class" |
	"CLng" |
	"CObj" |
	"Const" |
	"Continue" |
	"CSByte" |
	"CShort" |
	"CSng" |
	"CStr" |
	"CType" |
	"CUInt" |
	"CULng" |
	"CUShort" |
	"Declare" |
	"Default" |
	"Delegate" |
	"Dim" |
	"DirectCast" |
	"Do" |
	"Each" |
	"Else" |
	"ElseIf" |
	"End" |
	"EndIf" |
	"Enum" |
	"Erase" |
	"Error" |
	"Event" |
	"Exit" |
	"Finally" |
	"For" |
	"Friend" |
	"Function" |
	"Get" |
	"GetType" |
	"GetXMLNamespace" |
	"Global" |
	"GoSub" |
	"GoTo" |
	"Handles" |
	"If" |
	"If" |
	"Implements" |
	"Imports" |
	"In" |
	"Inherits" |
	"Interface" |
	"Is" |
	"IsNot" |
	"Let" |
	"Lib" |
	"Like" |
	"Loop" |
	"Me" |
	"Mod" |
	"Module" |
	"Module Statement" |
	"MustInherit" |
	"MustOverride" |
	"MyBase" |
	"MyClass" |
	"Namespace" |
	"Narrowing" |
	"New" |
	"New" |
	"Next" |
	"Not" |
	"Nothing" |
	"NotInheritable" |
	"NotOverridable" |
	"Of" |
	"On" |
	"Operator" |
	"Option" |
	"Optional" |
	"Or" |
	"OrElse" |
	"Out" |
	"Overloads" |
	"Overridable" |
	"Overrides" |
	"ParamArray" |
	"Partial" |
	"Private" |
	"Property" |
	"Protected" |
	"Public" |
	"RaiseEvent" |
	"ReadOnly" |
	"ReDim" |
	"REM" |
	"RemoveHandler" |
	"Resume" |
	"Select" |
	"Set" |
	"Shadows" |
	"Shared" |
	"Static" |
	"Step" |
	"Stop" |
	"Structure" |
	"Sub" |
	"SyncLock" |
	"Then" |
	"Throw" |
	"To" |
	"Try" |
	"TryCast" |
	"TypeOf" |
	"Using" |
	"Variant" |
	"Wend" |
	"When" |
	"While" |
	"Widening" |
	"With" |
	"WithEvents" |
	"WriteOnly" |
	"Xor"						{ addToken(Token.RESERVED_WORD); }
	"Return"					{ addToken(Token.RESERVED_WORD_2); }

	/* Data types. */
	"Boolean" |
	"Byte" |
	"Char" |
	"Date" |
	"Decimal" |
	"Double" |
	"Integer" |
	"Long" |
	"Object" |
	"SByte" |
	"Short" |
	"Single" |
	"String" |
	"UInteger" |
	"ULong" |
	"UShort"					{ addToken(Token.DATA_TYPE); }

	{BooleanLiteral}			{ addToken(Token.LITERAL_BOOLEAN); }

	{LineTerminator}			{ addNullToken(); return firstToken; }

	{Identifier}				{ addToken(Token.IDENTIFIER); }

	{WhiteSpace}+				{ addToken(Token.WHITESPACE); }

	{StringLiteral}				{ addToken(Token.LITERAL_STRING_DOUBLE_QUOTE); }
	{UnclosedStringLiteral}		{ addToken(Token.ERROR_STRING_DOUBLE); addNullToken(); return firstToken; }

	{LineCommentBegin}			{ start = zzMarkedPos-1; yybegin(EOL_COMMENT); }

	{Separator}					{ addToken(Token.SEPARATOR); }
	{Separator2}				{ addToken(Token.IDENTIFIER); }
	{Operator}					{ addToken(Token.OPERATOR); }

	{IntegerLiteral}			{ addToken(Token.LITERAL_NUMBER_DECIMAL_INT); }
	{HexLiteral}				{ addToken(Token.LITERAL_NUMBER_HEXADECIMAL); }
	{FloatLiteral}				{ addToken(Token.LITERAL_NUMBER_FLOAT); }
	{ErrorNumberFormat}			{ addToken(Token.ERROR_NUMBER_FORMAT); }

	{ErrorIdentifier}			{ addToken(Token.ERROR_IDENTIFIER); }

	/* Ended with a line not in a string or comment. */
	<<EOF>>						{ addNullToken(); return firstToken; }

	/* Catch any other (unhandled) characters. */
	.							{ addToken(Token.IDENTIFIER); }

}


<EOL_COMMENT> {
	[^hwf\n]+				{}
	{URL}					{ int temp=zzStartRead; addToken(start,zzStartRead-1, Token.COMMENT_EOL); addHyperlinkToken(temp,zzMarkedPos-1, Token.COMMENT_EOL); start = zzMarkedPos; }
	[hwf]					{}
	\n						{ addToken(start,zzStartRead-1, Token.COMMENT_EOL); addNullToken(); return firstToken; }
	<<EOF>>					{ addToken(start,zzStartRead-1, Token.COMMENT_EOL); addNullToken(); return firstToken; }
}
