*&---------------------------------------------------------------------*
*& Report  ZZ_MSTEI_CALCULATUR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zz_mstei_calculatur.

PARAMETERS: operand1 TYPE i OBLIGATORY,
            operator TYPE c LENGTH 1 OBLIGATORY,
            operand2 TYPE i OBLIGATORY
           .

DATA result TYPE i.

*IF operator = '+'.
*  result = operand1 + operand2.
*ELSEIF operator = '-'.
*  result = operand1 - operand2.
*ELSEIF operator = '*'.
*  result = operand1 * operand2.
*ELSEIF operator = ':'.
*  result = operand1 / operand2.
*ELSEIF operator = '%'.
*  result = operand1 MOD operand2.
*ENDIF.
*
*WRITE: operand1, ' ', operator, ' ', operand2, ' ergibt ', result.

CALL FUNCTION 'Z_MSTEI_F_CALC'
  EXPORTING
    iv_operand1      = operand1
    iv_operand2      = operand2
    iv_operator      = operator
  IMPORTING
    ev_result        = result
  EXCEPTIONS
    zero_division    = 1
    invalid_operator = 2
   .

* Zero Division?
IF sy-subrc = 1.
  MESSAGE 'Critical Error: Division through zero!' TYPE 'I'.
  RETURN.
* Invalid operand
ELSEIF sy-subrc = 2.
  MESSAGE 'Error: Unknown operand! Valid operands: +, -, *, :, %' TYPE 'I'.
  RETURN.
* Some other undefined error
ELSEIF sy-subrc <> 0.
  MESSAGE 'Unknown Error!' TYPE 'I'.
  RETURN.
ENDIF.

WRITE: operand1, ' ', operator, ' ', operand2, ' ergibt ', result.