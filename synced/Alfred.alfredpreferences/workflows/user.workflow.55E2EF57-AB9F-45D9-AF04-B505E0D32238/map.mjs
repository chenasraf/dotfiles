import list from './list.mjs'

function getMaps(name) {
  return list.filter((item) => item.name.toLowerCase().includes(name.toLowerCase()))
}

const results = getMaps(process.argv[2])

console.log(JSON.stringify({
  items: results.map((it) => ({
    title: `Open Gaardian Map for "${it.name}"`,
    arg: it.href,
  }))
}))
