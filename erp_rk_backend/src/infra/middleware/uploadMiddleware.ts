import multer from "multer";

// Aqui o arquivo será mantido na memória (ótimo para XML pequenos)
const storage = multer.memoryStorage();

const upload = multer({ storage });

export default upload;
