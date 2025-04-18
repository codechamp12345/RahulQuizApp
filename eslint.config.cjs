// ESLint flat config for modern JS, JSON, Markdown, and CSS linting
const js = require("@eslint/js");

/** @type {import("eslint").Linter.FlatConfig} */
module.exports = [
  js.configs.recommended,
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        self: "readonly",
        caches: "readonly",
        fetch: "readonly",
        console: "readonly",
        openDB: "readonly",
        getAllPendingChanges: "readonly",
        clearPendingChanges: "readonly",
        window: "readonly",
        WebSocket: "readonly",
        setTimeout: "readonly",
        indexedDB: "readonly",
        setInterval: "readonly"
      }
    },
    rules: {
      // Add project-specific JS rules here
    },
  },
  {
    files: ["**/*.json", "**/*.jsonc", "**/*.json5"],
    plugins: { jsonc: require("eslint-plugin-jsonc") },
    languageOptions: { parser: require.resolve("jsonc-eslint-parser") },
    rules: {
      "jsonc/auto": "error",
    },
  },
  {
    files: ["**/*.md"],
    plugins: { markdown: require("eslint-plugin-markdown") },
    processor: "markdown/markdown",
  },
  {
    files: ["**/*.css"],
    // For CSS linting, consider using stylelint in addition
  },
];
