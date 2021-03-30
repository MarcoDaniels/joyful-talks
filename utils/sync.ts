import {cockpitClient} from 'cockpit-http-client'
import * as fs from 'fs'
import * as path from 'path'

const contentFolder = `content`

type Entry = {
    url: string
    title: string
    description: string
    image?: { path: string }
    postsFeed?: unknown
}

type CollectionData = {
    entries: Entry[]
    total: number
}

type Collections = {
    [n: string]: CollectionData
}

type Singletons = {
    [n: string]: Record<string, unknown>
}

type Metadata = {
    collection: string
    meta: unknown
}

type Data = {
    collection: string
    data: unknown
    settings: unknown
}

export type Config = {
    cockpitAPIURL: string
    cockpitAPIToken: string
}

const createContentFile = (url: string, frontmatter: Metadata, data: Data) => {
    const fileContent = `${contentFolder}${url === '/' ? '/index.md' : url.slice(-1) === '/' ? `/${url.slice(0, -1)}.md` : `/${url}.md`}`

    fs.mkdir(path.dirname(fileContent), {recursive: true}, (err) => {
        if (err) return
        fs.writeFile(fileContent, `---\n${JSON.stringify(frontmatter, null, 2)}\n---\n${JSON.stringify(data, null, 2)}`, () => {
        })
    })
}

type Settings = {
    title: string
    titlePrefix: string
    description: string
    baseURL: string
}

const createElmSettings = (data: Settings) => {
    const module = `modules/Settings.elm`
    const content = `module Settings exposing (..)


settings =
    { ${Object.entries(data).map(([key, value]) => `${key} = "${value}"`).join('\n    , ')}
    }
`

    fs.mkdir(path.dirname(module), {recursive: true}, (err) => {
        if (err) return
        fs.writeFile(module, content, () => {
        })
    })
}

const syncContent = async ({cockpitAPIURL, cockpitAPIToken}: Config) => {
    const client = cockpitClient({apiURL: cockpitAPIURL, apiToken: cockpitAPIToken})

    const sync = await client.sync.all<Collections, Singletons>()

    if (sync.collections && sync.singletons) {
        const [meta] = Object.values(sync.singletons)

        if (meta) createElmSettings(meta.site as Settings)

        Object.entries(sync.collections).map(([collection, data]) => {
            data.entries.map(entry => createContentFile(entry.url, {
                collection: collection,
                meta: {
                    title: entry.title,
                    description: entry.description,
                    image: entry.image ? entry.image.path : null,
                    feed: entry.postsFeed || null,
                }
            }, {collection: collection, data: entry, settings: meta}))
        })
    }
}

const cleanupContent = () =>
    new Promise((resolve => resolve(fs.rmdirSync(contentFolder, {recursive: true}))))

const runSync = () => {
    if (!process.env.COCKPIT_API_URL || !process.env.COCKPIT_API_TOKEN) {
        console.error(`💥 environment configuration (COCKPIT_API_URL and COCKPIT_API_TOKEN) missing`)
        process.exit(1)
    }

    const config: Config = {
        cockpitAPIURL: process.env.COCKPIT_API_URL,
        cockpitAPIToken: process.env.COCKPIT_API_TOKEN,
    }

    cleanupContent().then(() => {
        console.log(`💢 content clear`)

        syncContent(config).then(() => console.log(`🚀 content sync`))
    })
}

runSync()