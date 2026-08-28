export default class PDFService {
  static exibirPDF(base64: string) {
    if (base64.trim() === "") throw new Error("Arquivo não informado !");
    const byteCharacters = atob(base64);
    const byteNumbers = Array.from(byteCharacters, (char) => char.charCodeAt(0));
    const byteArray = new Uint8Array(byteNumbers);
    const blob = new Blob([byteArray], { type: "application/pdf" });

    const url = URL.createObjectURL(blob);
    const janela = window.open(url);

    // O window.open acontece depois de um await, então o navegador pode
    // bloquear por não considerar mais o clique do usuário. Sem esta saída o
    // documento simplesmente não aparece e nada explica o porquê.
    if (!janela) {
      const link = document.createElement("a");
      link.href = url;
      link.download = "documento.pdf";
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  }
}
