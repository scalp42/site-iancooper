###
# Public domain VGL Brush for Alex Gorbatchev's SyntaxHighlighter
# http://iancooper.name/vgl-brush-for-syntaxhighlighter
#
# Ian Cooper
# 14 Jan 2013
###

SyntaxHighlighter.brushes.VGL = ->

  keywords = new RegExp '\\b(' + [
    '$ENDLITERAL', 'ACTIONS', 'ACTIVE', 'AND', 'ARCCOS', 'ARCSIN',
    'ARCTAN', 'ARRAY', 'ARRAYSIZE', 'ASCENDING', 'ASCII', 'ASSIGN',
    'AT', 'AUDIT_EVENT', 'AVG', 'BARCODE', 'BLANK', 'BOLD', 'BORDER',
    'BROWSE', 'CALL_MENU', 'CALLROUTINE', 'CALL_ROUTINE',
    'CAN_ACCESS_MENU', 'CHANGE', 'CHOOSE', 'CLASS', 'CLEAR', 'CLOSE',
    'COMMIT', 'COMPILE_OPTION', 'COMPLETE', 'CONFIRM', 'CONSIGN',
    'CONSTANT', 'CONTROL_C', 'COPY', 'COS', 'COUNT', 'CREATE', 'DATE',
    'DATE_FORMAT_VALIDATE', 'DAYNUMBER', 'DECLARE', 'DECONSIGN',
    'DEFINE', 'DELETE', 'DESCENDING', 'DISABLE', 'DISPLAY', 'DISTINCT',
    'DIV', 'DO', 'DRAW', 'ELSE', 'ELSEIF', 'EMPTY', 'ENABLE', 'END',
    'ENDIF', 'ENDON', 'ENDROUTINE', 'ENDWHILE', 'ENTRY', 'ERROR',
    'EXISTS', 'EXIT', 'EXP', 'EXTEND', 'FALSE', 'FIELD_CHANGED',
    'FILE', 'FIND', 'FLUSH_LITERAL', 'FOOTER', 'FOR', 'FORMAT', 'FROM',
    'GABS', 'GET', 'GETKEY', 'GET_CHARACTER_AT', 'GET_FIELD_DETAILS',
    'GET_SAMPLE_SYNTAX', 'GET_TABLE_DETAILS', 'GET_TEST_RESULTS',
    'GET_USER_MESSAGE', 'GET_USER_SEVERITY', 'GLOBAL', 'GOSUB', 'GOTO',
    'GRAPH', 'GRAPHICS', 'HEADER', 'HEIGHT', 'HKEY_CLASSES_ROOT',
    'HKEY_CURRENT_CONFIG', 'HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE',
    'HKEY_USERS', 'HKEY_PERFORMANCE_DATA', 'IF', 'IN', 'INCLUDE',
    'INCREMENT', 'INDEX', 'INHERIT', 'INITIALISATION', 'INTERVAL',
    'IS_DATE', 'IS_INTERVAL', 'JOB STATUS', 'JOBNAME', 'JOB_STATUS',
    'JOIN', 'JUSTIFY', 'KEYPRESSED', 'LABEL', 'LASTKEY', 'LEFTSTRING',
    'LENGTH', 'LIBRARY', 'LINE', 'LINESLEFT', 'LITERAL', 'LN',
    'LOCKED', 'LOG', 'LOGICAL', 'LOGMESSAGE', 'MAX', 'MENUNUMBER',
    'MENUPROC', 'MESSAGE', 'MIDSTRING', 'MIN', 'MOD', 'MODE',
    'MULTIBYTE PROCESSING', 'NAME', 'NEW', 'NEWJOB', 'NEWRESULT',
    'NEWSAMPLE', 'NEWTEST', 'NEXT', 'NOT', 'NOT_PROTECTED',
    'NOTPROTECTED', 'NOW', 'NULL', 'NUMBER_TO_TEXT', 'NUMERIC',
    'NUMTEXT', 'OBJECT', 'ON', 'OPEN', 'OPERATOR', 'OR', 'ORD',
    'ORDER', 'OUTOF', 'PACKED_DECIMAL', 'PAD', 'PAGE', 'PASTE',
    'PAUSE', 'PIPE', 'PLOT', 'POINT', 'PRINTERCODES', 'PROMPT',
    'PROPERTIES', 'PUT_TEST_RESULTS', 'RANDOM', 'READ', 'READ_ARRAY',
    'READ_LOCK', 'REMOVED', 'REPEAT', 'RESERVE', 'RESTORE',
    'RESULT STATUS', 'RESULT_AUTHORISE', 'RESULT_DISPLAY',
    'RESULT_ENTRY', 'RESULT_STRING', 'RESULT_VALUE', 'RETURN',
    'RETURNING', 'RIGHTSTRING', 'ROLLBACK', 'ROUND', 'ROUTINE',
    'SAMPLE', 'SAMPLE_STATUS', 'SCREEN', 'SCROLL', 'SELECT', 'SEND',
    'SET', 'SIN', 'SLEEP', 'SPAWN', 'SPLITWORDS', 'SQRT',
    'STANDARD_LIBRARY', 'START', 'STATUS', 'STATUS_CHECK_SUPPRESS',
    'STRING', 'STRINGLENGTH', 'STRIP', 'SUBSTITUTE', 'SUBSTRING',
    'SUM', 'SYMBOL', 'SYNTAX', 'TABLES', 'TAN', 'TEST', 'TEST PAGE',
    'TEST STATUS', 'TEXT', 'TEXT WINDOW', 'THEN', 'TO', 'TODAY',
    'TOLOWER', 'TOP', 'TOUPPER', 'TRANSACTION', 'TRUE', 'TRUNC',
    'UNPASTE GRAPHICS WINDOW', 'UNPASTE TEXT WINDOW', 'UNTIL',
    'UPDATE', 'USING', 'VALUE', 'WAIT', 'WAKEUP', 'WAKE_UP_BACKGROUND',
    'WHERE', 'WHILE', 'WIDTH', 'WINDOW', 'WINDOWS', 'WITH', 'WRITE',
    'WRITE_ARRAY'
  ].join('|') + ')\\b', 'gm'

  @regexList = [
    { css: 'comments', regex: /{[^}]*}/gm }
    { css: 'string',   regex: SyntaxHighlighter.regexLib.doubleQuotedString }
    { css: 'string',   regex: SyntaxHighlighter.regexLib.singleQuotedString }
    { css: 'color1',  regex: /(?:&lt;|&gt;|&amp;|[\-+*\/<>!~%\^&|=,.])/gm }
    { css: 'keyword',  regex: keywords }
  ]

  undefined

SyntaxHighlighter.brushes.VGL:: = new SyntaxHighlighter.Highlighter()
SyntaxHighlighter.brushes.VGL.aliases = [ 'vgl', 'rpf', 'samplemanager' ]