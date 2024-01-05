import { massarg } from 'massarg'
import { Opts } from '../common'
import { strConcat } from 'massarg/utils'
import { format } from 'massarg/style'
import { main } from './tmux'
import { createCmd } from './create_cmd'
import { listCmd } from './list_cmd'
import { showCmd } from './show_cmd'
import { editCmd } from './edit_cmd'
import { rmCmd } from './rm_cmd'
import { attachCmd } from './attach_cmd'

// ================================================================================
// Commands
// ================================================================================
// TODO move to tmux.ts
const mainCmd = massarg<Opts>({
  name: 'tmux',
  description: 'Generate layouts for tmux using presets or on-the-fly args.',
})
  .main(main)
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'dry',
    aliases: ['d'],
    description: 'Dry run',
  })
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
  })
  .help({
    bindOption: true,
    bindCommand: true,
    usageText: strConcat(
      [
        format('tmux', { color: 'yellow' }),
        format('[options]', { color: 'gray' }),
        format('[-k] <tmux session name>', { color: 'green' }),
      ].join(' '),
      [format('tmux', { color: 'yellow' }), format('<command> [options]', { color: 'gray' })].join(
        ' ',
      ),
    ),
  })

mainCmd
  .command(listCmd)
  .command(showCmd)
  .command(editCmd)
  .command(rmCmd)
  .command(createCmd)
  .command(attachCmd)
  .parse()
