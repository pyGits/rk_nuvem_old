// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost:8040/wsdl/IServidorRK
// Version  : 1.0
// (15/10/2019 11:08:43 - - $Rev: 76228 $)
// ************************************************************************ //

unit IServidorRK1;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:int             - "http://www.w3.org/2001/XMLSchema"[]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[]


  // ************************************************************************ //
  // Namespace : urn:ServerRK-IServidorRK
  // soapAction: urn:ServerRK-IServidorRK#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : IServidorRKbinding
  // service   : IServidorRKservice
  // port      : IServidorRKPort
  // URL       : http://localhost:8040/soap/IServidorRK
  // ************************************************************************ //
  IServidorRK = interface(IInvokable)
  ['{23656567-6FC8-556D-5A3A-089AF0237204}']
    function  teste: string; stdcall;
    function  recebeXML(const codigo: string; const cnpj: string; const xml: string; const tipo: Integer; const data: string): string; stdcall;
  end;

function GetIServidorRK(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IServidorRK;


implementation
  uses System.SysUtils;

function GetIServidorRK(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IServidorRK;
const
  defWSDL = 'http://localhost:8040/wsdl/IServidorRK';
  defURL  = 'http://localhost:8040/soap/IServidorRK';
  defSvc  = 'IServidorRKservice';
  defPrt  = 'IServidorRKPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IServidorRK);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { IServidorRK }
  InvRegistry.RegisterInterface(TypeInfo(IServidorRK), 'urn:ServerRK-IServidorRK', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IServidorRK), 'urn:ServerRK-IServidorRK#%operationName%');

end.