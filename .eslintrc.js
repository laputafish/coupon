module.exports = {
  root: true,
  env: {
    node: true
  },
  "extends": [
    "plugin:vue/essential",
    "eslint:recommended",
    "@vue/typescript/recommended"
  ],
  parserOptions: {
    ecmaVersion: 2020
  },
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? "error" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "error" : "off",
    "no-this-assignment": false,
    "no-this-alias": false,
    "properties": "never",
    "consistent-this": [2, "vm"],
    "disallow-aliasing-this": false,
    "allowedNames": ["vm"]
  }
}
