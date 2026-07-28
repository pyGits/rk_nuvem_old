import CryptoJS from "crypto-js";

export function deepAssignWithClasses<T>(target: T, source: any, classMap: { [key: string]: new () => any } = {}): T {
  for (const key in source) {
    if (Array.isArray(source[key])) {
      const itemClass = classMap[key];
      if (itemClass) {
        target[key] = source[key].map((item: any) => deepAssignWithClasses(new itemClass(), item, classMap));
      } else {
        target[key] = source[key];
      }
    } else if (typeof source[key] === "object" && source[key] !== null) {
      const itemClass = classMap[key];
      if (itemClass) {
        target[key] = deepAssignWithClasses(new itemClass(), source[key], classMap);
      } else {
        target[key] = source[key];
      }
    } else {
      target[key] = source[key];
    }
  }
  return target;
}

export function md5WithSalt(password: string) {
  const hashedPassword = CryptoJS.MD5(password + "B0RG55!").toString();
  return hashedPassword;
}
export function CriptRK(Action: any, Src: any) {
  let KeyLen: any, KeyPos: any, OffSet: any, Dest: any, key: any, SrcPos: any, SrcAsc: any, TmpSrcAsc: any, Range: any;

  if (Src === "") {
    return "";
  }

  key = "YUQL23K1PIUF90AERVNNMKH02NMIHJ12042 E18XM01HIBQAS150AVDOUYQA90UD1APSA12POIENC1K3210N0419RTIKJ";
  Dest = "";
  KeyLen = key.length;
  KeyPos = 0;
  SrcPos = 0;
  SrcAsc = 0;
  Range = 256;

  if (Action.toUpperCase() === "C") {
    OffSet = Math.floor(Math.random() * Range);
    Dest = OffSet.toString(16).padStart(2, "0");

    for (SrcPos = 0; SrcPos < Src.length; SrcPos++) {
      SrcAsc = (Src.charCodeAt(SrcPos) + OffSet) % 255;

      if (KeyPos < KeyLen) {
        KeyPos++;
      } else {
        KeyPos = 1;
      }

      SrcAsc ^= key.charCodeAt(KeyPos - 1);
      Dest += SrcAsc.toString(16).padStart(2, "0");
      OffSet = SrcAsc;
    }
  } else if (Action.toUpperCase() === "D") {
    OffSet = parseInt(Src.substr(0, 2), 16);
    SrcPos = 2;

    while (SrcPos < Src.length) {
      SrcAsc = parseInt(Src.substr(SrcPos, 2), 16);

      if (KeyPos < KeyLen) {
        KeyPos++;
      } else {
        KeyPos = 1;
      }

      TmpSrcAsc = SrcAsc ^ key.charCodeAt(KeyPos - 1);

      if (TmpSrcAsc <= OffSet) {
        TmpSrcAsc = 255 + TmpSrcAsc - OffSet;
      } else {
        TmpSrcAsc -= OffSet;
      }

      Dest += String.fromCharCode(TmpSrcAsc);
      OffSet = SrcAsc;
      SrcPos += 2;
    }
  }

  return Dest;
}
