import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generateKey", "signPetition"];

  connect() {
    if (this.hasGenerateKeyTarget) {
      this.generateKeyTarget.addEventListener('click', () => this.generateKeyPair());
    }

    if (this.hasSignPetitionTarget) {
      this.signPetitionTarget.addEventListener('click', () => this.signPetition());
    }
  }

  async generateKeyPair() {
    const keyPair = await window.crypto.subtle.generateKey(
      {
        name: "RSASSA-PKCS1-v1_5",
        modulusLength: 2048,
        publicExponent: new Uint8Array([1, 0, 1]), // 65537
        hash: "SHA-256",
      },
      true,
      ["sign", "verify"]
    );
    
    const publicKey = await window.crypto.subtle.exportKey("spki", keyPair.publicKey);
    const publicKeyPem = this.convertArrayBufferToPem(publicKey, "PUBLIC KEY");
    
    const privateKey = await window.crypto.subtle.exportKey("pkcs8", keyPair.privateKey);
    const privateKeyPem = this.convertArrayBufferToPem(privateKey, "PRIVATE KEY");

    await this.sendPublicKeyToServer(publicKeyPem);

    sessionStorage.setItem('privateKey', privateKeyPem);
    alert('Klucz prywatny został wygenerowany i zapisany lokalnie.');
  }

  async signPetition() {
    const privateKeyPem = sessionStorage.getItem('privateKey');
    if (!privateKeyPem) {
      alert('Brak klucza prywatnego. Wygeneruj klucz przed podpisaniem petycji.');
      return;
    }
  
    try {
      const privateKey = await this.importPrivateKey(privateKeyPem);
      const message = new TextEncoder().encode(this.element.dataset.petitionId);
  
      const signature = await window.crypto.subtle.sign(
        {
          name: "RSASSA-PKCS1-v1_5",
        },
        privateKey,
        message
      );
  
      const signatureBase64 = window.btoa(String.fromCharCode.apply(null, new Uint8Array(signature)));
  
      const response = await fetch(`/petitions/${this.element.dataset.petitionId}/signatures`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ signature: signatureBase64 })
      });
  
      if (response.ok) {
        const data = await response.json();
        window.location.reload(); 
      } else {
        const error = await response.json();
        alert(`Błąd podczas podpisywania petycji: ${error.errors.join(', ')}`);
      }
    } catch (err) {
      console.error("Error during signing petition:", err);
      alert('Wystąpił nieoczekiwany błąd. Spróbuj ponownie później.');
    }
  }

  async sendPublicKeyToServer(publicKeyPem) {
    await fetch('/users/upload_public_key', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ public_key: publicKeyPem })
    });
  }

  async importPrivateKey(pem) {
    const binaryDer = this.convertPemToArrayBuffer(pem);
    return await window.crypto.subtle.importKey(
      "pkcs8",
      binaryDer,
      {
        name: "RSASSA-PKCS1-v1_5",
        hash: "SHA-256",
      },
      false,
      ["sign"]
    );
  }

  convertArrayBufferToPem(buffer, label) {
    const binary = String.fromCharCode.apply(null, new Uint8Array(buffer));
    const base64 = window.btoa(binary);
    const pem = `-----BEGIN ${label}-----\n${base64}\n-----END ${label}-----`;
    return pem;
  }

  convertPemToArrayBuffer(pem) {
    const base64 = pem.replace(/-----BEGIN .*-----|-----END .*-----|\n/g, '');
    const binary = window.atob(base64);
    const buffer = new ArrayBuffer(binary.length);
    const view = new Uint8Array(buffer);
    for (let i = 0; i < binary.length; i++) {
      view[i] = binary.charCodeAt(i);
    }
    return buffer;
  }
}