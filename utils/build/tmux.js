"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const cosmiconfig_1 = require("cosmiconfig");
const explorer = (0, cosmiconfig_1.cosmiconfig)('tmux');
async function main() {
    const result = await explorer.search();
    console.log(result);
}
