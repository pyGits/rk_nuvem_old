module.exports = {
  preset: "ts-jest",
  // O build local (npx tsc) deixa uma copia compilada de TUDO em dist/,
  // inclusive dos testes - sem isto cada suite roda duas vezes, e a copia
  // dentro de dist enxerga o proprio dist como raiz do projeto.
  testPathIgnorePatterns: ["/node_modules/", "/dist/"],
  transform: {
    "^.+\\.(ts|tsx)?$": "ts-jest",
    "^.+\\.(js|jsx)$": "babel-jest",
  },
};
