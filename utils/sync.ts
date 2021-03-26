import {cockpitClient} from 'cockpit-http-client'
import * as fs from 'fs'
import * as path from 'path'

const contentFolder = `content`

type Entry = {
    url: string
    title: string
    description: string
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
    site: unknown
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

const createFile = (url: string, frontmatter: Metadata, data: Data) => {
    const fileContent = `${contentFolder}${url === '/' ? '/index.md' : url.slice(-1) === '/' ? `/${url.slice(0, -1)}.md` : `/${url}.md`}`

    fs.mkdir(path.dirname(fileContent), {recursive: true}, (err) => {
        if (err) return
        fs.writeFile(fileContent, `---\n${JSON.stringify(frontmatter, null, 2)}\n---\n${JSON.stringify(data, null, 2)}`, () => {
        })
    })
}

const syncContent = async ({cockpitAPIURL, cockpitAPIToken}: Config) => {
    const client = cockpitClient({apiURL: cockpitAPIURL, apiToken: cockpitAPIToken})

    const sync = await client.sync.all<Collections, Singletons>()

    if (sync.collections && sync.singletons) {
        const [meta] = Object.values(sync.singletons)

        Object.entries(sync.collections).map(([collection, data]) => {
            data.entries.map(entry => createFile(entry.url, {
                collection: collection,
                meta: {
                    title: entry.title,
                    description: entry.description,
                    feed: entry.postsFeed || null,
                },
                site: meta!.site
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