import {cockpitClient} from './cockiptClient'
import * as fs from 'fs'
import * as path from 'path'

// TODO: log to command line

type Entry = {
    url: string
}

type Data = {
    entries: Entry[]
    total: number
}

type Content = {
    collection: string
    data: any,
    meta: any
}

const createFile = (url: string, content: Content) => {
    const fileContent = `content${url === '/' ? '/index.md' : `/${url}.md`}`

    fs.mkdir(path.dirname(fileContent), {recursive: true}, (err) => {
        if (err) return
        fs.writeFile(fileContent, `---\n${JSON.stringify(content, null, 2)}\n---`, () => {
        })
    })
}

const fetchData = async () => {
    const collections = await cockpitClient.collections()
    const singletons = await cockpitClient.singletons()
    if (collections.success && singletons.success) {
        const singletonData = await Promise.all(singletons.data.map(cockpitClient.singletonData)).then(([singleton]) => {
            if (singleton && singleton.success) return singleton.data
        })

        collections.data.map(collection => {
            cockpitClient.collectionData<Data>(collection).then(collectionData => {
                if (collectionData.success) {
                    collectionData.data.entries.map(data => {
                        createFile(data.url, {
                            collection: collection,
                            data: data,
                            meta: singletonData
                        })
                    })
                }
            })
        })
    }

}

fetchData()