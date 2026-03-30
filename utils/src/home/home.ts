import { massarg } from 'massarg'
import { withDefaultOpts } from '../common'
import { HomeOpts } from './common'
import { mushCommand } from './mush_cmd'
import { brewCommand } from './brew_cmd'

withDefaultOpts(
  massarg<HomeOpts>({
    name: 'hutil',
    description: 'Dotfiles utilities',
  }),
)
  .command(mushCommand)
  .command(brewCommand)
  .parse()
