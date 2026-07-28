module.exports = {
  root: true,

  env: {
    node: true,
  },

  extends: ["plugin:vue/essential", "eslint:recommended", "@vue/typescript/recommended"],

  parserOptions: {
    ecmaVersion: 2020,
    parser: "@typescript-eslint/parser",
  },

  rules: {
    "vue/no-unused-components":"off",
    "vue/valid-v-slot": "off",
    "no-console": process.env.NODE_ENV === "production" ? "warn" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "warn" : "off",
    "vue/multi-word-component-names": "off",
    "@typescript-eslint/no-unused-vars": "off",
    "@typescript-eslint/no-explicit-any": "off",
    "vue/no-use-v-if-with-v-for": "off",
    "@typescript-eslint/no-inferrable-types": "off",
  },

  overrides: [
    {
      files: ["**/__tests__/*.{j,t}s?(x)", "**/tests/**/*.test.{j,t}s?(x)"],
      env: {
        jest: true,
      },
    },
  ],

  extends: ["plugin:vue/essential", "eslint:recommended", "@vue/typescript/recommended", "@vue/typescript"],
};
