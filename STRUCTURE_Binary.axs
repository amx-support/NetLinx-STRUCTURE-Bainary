PROGRAM_NAME='STRUCTURE_Binary'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvTP	= 10001:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

FILENAME	= 'struct.dat'

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE _tagData
{
    integer	nIntVal
    integer	nIntArr[5]
    char	strVal[16]
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

_tagData	tagData

VOLATILE integer nSelect

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT [dvTP]
{
    STRING:
    {
	IF (FIND_STRING(DATA.TEXT,'AKB-',1))
	{
	    REMOVE_STRING(DATA.TEXT,'AKB-',1)
	
	    SWITCH(nSelect)
	    {
		CASE 1:
		{
		    tagData.nIntVal = ATOI(DATA.TEXT)
		    SEND_COMMAND dvTP,"'^TXT-1,0,',ITOA(tagData.nIntVal)"
		}
		CASE 2:
		CASE 3:
		CASE 4:
		CASE 5:
		CASE 6:
		{
		    tagData.nIntArr[nSelect-1] = ATOI(DATA.TEXT)
		    SEND_COMMAND dvTP,"'^TXT-',ITOA(nSelect),',0,',ITOA(tagData.nIntArr[nSelect-1])"
		}
		CASE 7:
		{
		    tagData.strVal = DATA.TEXT
		    SEND_COMMAND dvTP,"'^TXT-7,0,',tagData.strVal"
		}
	    }
	}
    }
}

BUTTON_EVENT [dvTP,1]
BUTTON_EVENT [dvTP,2]
BUTTON_EVENT [dvTP,3]
BUTTON_EVENT [dvTP,4]
BUTTON_EVENT [dvTP,5]
BUTTON_EVENT [dvTP,6]
BUTTON_EVENT [dvTP,7]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
    
	nSelect = BUTTON.INPUT.CHANNEL
	
	SEND_COMMAND dvTP,'^AKB'
    }
}
BUTTON_EVENT [dvTP,11]	// SAVE
{
    PUSH:
    {
	STACK_VAR slong	hFile
	STACK_VAR char cData[64]
	
	TO[BUTTON.INPUT]
	
	SET_LENGTH_ARRAY(tagData.nIntArr,MAX_LENGTH_ARRAY(tagData.nIntArr))
	VARIABLE_TO_STRING(tagData,cData,1)
	
	hFile = FILE_OPEN(FILENAME,FILE_RW_NEW)
	IF (hFile)
	{
	    FILE_WRITE(hFile,cData,LENGTH_STRING(cData))
	    FILE_CLOSE(hFile)
	}
    }
}
BUTTON_EVENT [dvTP,12]	// LOAD
{
    PUSH:
    {
	STACK_VAR slong	hFile
	STACK_VAR char cData[64]
	
	TO[BUTTON.INPUT]
	
	hFile = FILE_OPEN(FILENAME,FILE_READ_ONLY)
	IF (hfile)
	{
	    FILE_READ(hFile,cData,64)
	    STRING_TO_VARIABLE(tagData,cData,1)
	    
	    SEND_COMMAND dvTP,"'^TXT-1,0,',ITOA(tagData.nIntVal)"
	    SEND_COMMAND dvTP,"'^TXT-2,0,',ITOA(tagData.nIntArr[1])"
	    SEND_COMMAND dvTP,"'^TXT-3,0,',ITOA(tagData.nIntArr[2])"
	    SEND_COMMAND dvTP,"'^TXT-4,0,',ITOA(tagData.nIntArr[3])"
	    SEND_COMMAND dvTP,"'^TXT-5,0,',ITOA(tagData.nIntArr[4])"
	    SEND_COMMAND dvTP,"'^TXT-6,0,',ITOA(tagData.nIntArr[5])"
	    SEND_COMMAND dVTP,"'^TXT-7,0,',tagData.strVal"
	}
    }
}
BUTTON_EVENT [dvTP,13]	// CLEAR
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	tagData.nIntVal = 0
	tagData.nIntArr[1] = 0
	tagData.nIntArr[2] = 0
	tagData.nIntArr[3] = 0
	tagData.nIntArr[4] = 0
	tagData.nIntArr[5] = 0
	tagData.strVal = ''
	
	SEND_COMMAND dvTP,"'^TXT-1,0,',ITOA(tagData.nIntVal)"
	SEND_COMMAND dvTP,"'^TXT-2,0,',ITOA(tagData.nIntArr[1])"
	SEND_COMMAND dvTP,"'^TXT-3,0,',ITOA(tagData.nIntArr[2])"
	SEND_COMMAND dvTP,"'^TXT-4,0,',ITOA(tagData.nIntArr[3])"
	SEND_COMMAND dvTP,"'^TXT-5,0,',ITOA(tagData.nIntArr[4])"
	SEND_COMMAND dvTP,"'^TXT-6,0,',ITOA(tagData.nIntArr[5])"
	SEND_COMMAND dVTP,"'^TXT-7,0,',tagData.strVal"
    }
}

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


