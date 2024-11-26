import { massarg } from 'massarg'
import { withDefaultOpts } from '../common'
import { gitCommand, pullCommand, pushCommand, statusCommand } from './git_cmd'
import { HomeOpts } from './common'
import { utilsCommand } from './utils_cmd'
import { mushCommand } from './mush_cmd'
import { brewCommand } from './brew_cmd'

withDefaultOpts(
  massarg<HomeOpts>({
    name: 'home',
    description: 'Dotfiles management',
  }),
)
  .command(gitCommand)
  .command(statusCommand)
  .command(pushCommand)
  .command(pullCommand)
  .command(utilsCommand)
  .command(mushCommand)
  .command(brewCommand)
  .parse()
