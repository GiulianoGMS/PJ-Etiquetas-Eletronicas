-- Proc seria utilizada para chamada manual da API através de query view.
-- Foi definido que a chamada sera automatica e recorrente, nao necessario a manual

CREATE OR REPLACE PROCEDURE NAGP_ENVIA_CARGA_SEAL (psVariavelNada NUMBER)

  IS
  
  psUsuarioLiberacao VARCHAR2(4000);
  vLixo VARCHAR2(2000);
  VL_REQ       UTL_HTTP.REQ;
  VL_RESP      UTL_HTTP.RESP;
  VL_URL       VARCHAR2(1000) := 'http:/[...]';
  VL_API_KEY   VARCHAR2(1000) := 'VZiwVp94c6E2';
  VL_TEXTO     VARCHAR2(32767);
  VL_STATUS    NUMBER;
  VL_MENSAGEM  VARCHAR2(32767);
  
  BEGIN
    VL_REQ := UTL_HTTP.BEGIN_REQUEST(
        URL          => VL_URL,
        METHOD       => 'POST',
        HTTP_VERSION => 'HTTP/1.1'
    );

    UTL_HTTP.SET_HEADER(
        VL_REQ,
        'x-api-key',
        VL_API_KEY
    );

    UTL_HTTP.SET_HEADER(
        VL_REQ,
        'Content-Type',
        'application/json'
    );

    VL_RESP := UTL_HTTP.GET_RESPONSE(VL_REQ);

    VL_STATUS   := VL_RESP.STATUS_CODE;
    VL_MENSAGEM := VL_RESP.REASON_PHRASE;

    DBMS_OUTPUT.PUT_LINE('STATUS HTTP: ' || VL_STATUS);
    DBMS_OUTPUT.PUT_LINE('MENSAGEM: ' || VL_MENSAGEM);
    DBMS_OUTPUT.PUT_LINE('RETORNO DA API:');

    BEGIN
        LOOP
            UTL_HTTP.READ_TEXT(VL_RESP, VL_TEXTO, 32767);
            DBMS_OUTPUT.PUT_LINE(VL_TEXTO);
        END LOOP;
    EXCEPTION
        WHEN UTL_HTTP.END_OF_BODY THEN
            NULL;
    END;

    UTL_HTTP.END_RESPONSE(VL_RESP);
    
  INSERT INTO NAGT_LOG_ENVIO_CARGA_SEAL VALUES (SYSDATE, psUsuarioLiberacao);
  
  COMMIT;
  
  END;   
