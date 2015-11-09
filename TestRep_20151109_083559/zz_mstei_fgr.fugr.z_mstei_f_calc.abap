FUNCTION z_mstei_f_calc.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_OPERAND1) TYPE  I
*"     REFERENCE(IV_OPERAND2) TYPE  I
*"     REFERENCE(IV_OPERATOR) TYPE  C
*"  EXPORTING
*"     REFERENCE(EV_RESULT) TYPE  I
*"  EXCEPTIONS
*"      ZERO_DIVISION
*"      INVALID_OPERATOR
*"----------------------------------------------------------------------

* Check for Division through Zero
  IF ( iv_operator = '%' or iv_operator = ':' ) AND iv_operand2 = 0.
    RAISE zero_division.
  ENDIF.

  IF iv_operator <> '+' and iv_operator <> '-' and iv_operator <> '%' and iv_operator <> ':' and iv_operator <> '*'.
    RAISE invalid_operator.
  ENDIF.

IF iv_operator = '+'.
  ev_result = iv_operand1 + iv_operand2.
ELSEIF iv_operator = '-'.
  ev_result = iv_operand1 - iv_operand2.
ELSEIF iv_operator = '*'.
  ev_result = iv_operand1 * iv_operand2.
ELSEIF iv_operator = ':'.
  ev_result = iv_operand1 / iv_operand2.
ELSEIF iv_operator = '%'.
  ev_result = iv_operand1 MOD iv_operand2.
ENDIF.

ENDFUNCTION.