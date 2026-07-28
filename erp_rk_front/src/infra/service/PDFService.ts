export default class PDFService {
  static exibirPDF(base64: string) {
    if (base64.trim() === "") throw new Error("Arquivo não informado !");
    const byteCharacters = atob(base64);
    const byteNumbers = Array.from(byteCharacters, (char) => char.charCodeAt(0));
    const byteArray = new Uint8Array(byteNumbers);
    const blob = new Blob([byteArray], { type: "application/pdf" });

    const url = URL.createObjectURL(blob);
    window.open(url);
  }
}
