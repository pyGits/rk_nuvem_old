module.exports = {
  moduleFileExtensions: ["js", "ts", "json", "vue"],
  clearMocks: true,
  transform: {
    "^.+\\.vue$": "vue-jest",
    "^.+\\.tsx?$": "ts-jest",
  },

  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
    "\\.xml$": "<rootDir>/__mocks__/xmlMock.js",
  },

  testMatch: ["<rootDir>/tests/**/*.test.(js|jsx|ts|tsx)", "<rootDir>/tests/**/*.spec.(js|jsx|ts|tsx)"],

  testURL: "http://localhost/",

  globals: {
    "ts-jest": {
      tsconfig: "tsconfig.json",
    },
  },

  testEnvironment: "jsdom",
  preset: "@vue/cli-plugin-unit-jest/presets/typescript-and-babel",
};
