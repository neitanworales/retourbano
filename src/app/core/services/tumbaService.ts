import { Injectable } from "@angular/core";
import * as CryptoJS from 'crypto-js';

@Injectable()
export class TumbaService {
    
    key = CryptoJS.enc.Utf8.parse('12345678901234567890123456789012'); // 32 caracteres
    iv = CryptoJS.enc.Utf8.parse('1234567890123456'); // 16 caracteres
    
    encryptar(text: String){
        const encrypted = CryptoJS.AES.encrypt(
            CryptoJS.enc.Utf8.parse(text.toString()),
            this.key,
            { iv: this.iv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 }
          );
          return encrypted.ciphertext.toString(CryptoJS.enc.Base64);
    }

    desencryptar(cipherText: String){
        const encryptedHexStr = CryptoJS.enc.Base64.parse(cipherText.toString());
        const encryptedBase64Str = CryptoJS.enc.Base64.stringify(encryptedHexStr);
        const decrypted = CryptoJS.AES.decrypt(
            encryptedBase64Str,
            this.key,
            { iv: this.iv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 }
        );
        return decrypted.toString(CryptoJS.enc.Utf8);
    }
}