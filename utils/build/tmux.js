"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const massarg_1 = require("massarg");
const cosmiconfig_1 = require("cosmiconfig");
const path = __importStar(require("node:path"));
const os = __importStar(require("node:os"));
const node_child_process_1 = require("node:child_process");
const explorer = (0, cosmiconfig_1.cosmiconfig)('tmux');
const defaultPanes = [
    {
        dir: '.',
        cmd: 'nvim .',
    },
    { dir: '.' },
    { dir: '.' },
];
function log({ verbose }, ...content) {
    if (!verbose)
        return;
    console.log(...content);
}
async function main(opts) {
    const { key } = opts;
    const config = await getTmuxConfig();
    const item = config[key];
    if (!item) {
        throw new Error(`tmux config item ${key} not found`);
    }
    const tmuxConfig = parseConfig(item);
    const { root, windows } = tmuxConfig;
    log(opts, tmuxConfig);
    const commands = [];
    let sessionName = key;
    commands.push(`tmux -f ~/.config/.tmux.conf new-session -d -s ${sessionName} -n general -c ${root}`);
    for (const window of windows) {
        const dir = window.dir;
        const windowName = window.name || path.basename(dir).replaceAll(/[^a-z0-9_\-]+/i, '_');
        const [firstPane, ...restPanes] = window.panes;
        commands.push(`tmux new-window -n ${windowName} -c ${dir}`);
        const cmd = firstPane.cmd ? transformCmdToTmuxKeys(firstPane.cmd) : null;
        if (cmd) {
            commands.push(`tmux send-keys -t ${sessionName}:${windowName} ${cmd} Enter`);
        }
        let direction = '-h';
        for (const pane of restPanes) {
            const cmd = pane.cmd ? transformCmdToTmuxKeys(pane.cmd) : '';
            commands.push(`tmux split-window ${direction} -t ${sessionName}:${windowName} -c ${dir} ${cmd}`.trim());
            direction = '-v';
        }
        commands.push(`tmux select-pane -t 0`);
        commands.push(`tmux resize-pane -Z`);
    }
    commands.push(`tmux select-window -t ${sessionName}:1`);
    for (const command of commands) {
        await runCommand(opts, command);
    }
    await runCommand(opts, `tmux attach -t ${sessionName}`);
}
async function runCommand(opts, command) {
    const [cmd, ...args] = command.split(' ');
    log(opts, '$ ' + command);
    const proc = (0, node_child_process_1.spawn)(cmd, args, { stdio: 'inherit' });
    return new Promise((resolve, reject) => {
        proc.on('close', (code) => {
            if (code === 0) {
                resolve(code);
            }
            else {
                reject(code);
            }
        });
    });
}
function transformCmdToTmuxKeys(cmd) {
    let string = '';
    const map = {
        ' ': 'Space',
        '\n': 'Enter',
    };
    for (const letter of cmd.split('')) {
        string += map[letter] ? ` ${map[letter]} ` : letter;
    }
    return string.toString();
}
function parseConfig(item) {
    const dirFix = (dir) => dir.replace('~', os.homedir());
    const root = dirFix(item.root);
    const windows = item.windows.map((w) => {
        if (typeof w === 'string') {
            return {
                name: w,
                dir: dirFix(path.resolve(root, w)),
                panes: defaultPanes,
            };
        }
        return {
            name: w.name,
            dir: path.resolve(root, w.dir),
            panes: w.panes
                ? w.panes.map((p) => {
                    if (typeof p === 'string') {
                        return {
                            dir: dirFix(path.resolve(root, w.dir, p)),
                        };
                    }
                    return {
                        dir: dirFix(path.resolve(root, w.dir, p.dir)),
                        cmd: p.cmd,
                    };
                })
                : defaultPanes,
        };
    });
    const tmuxConfig = {
        root,
        windows,
    };
    return tmuxConfig;
}
async function getTmuxConfig() {
    const searchIn = [process.cwd(), os.homedir()];
    for (const dir of searchIn) {
        const result = await explorer.search(dir);
        if (result) {
            return result.config;
        }
    }
    throw new Error('tmux config file not found');
}
(0, massarg_1.massarg)({ name: 'utils', description: 'RTFM' })
    .main(main)
    .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
    negatable: true,
})
    .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
    required: true,
})
    .parse(process.argv.slice(2));
