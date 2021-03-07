import {createProxyMiddleware} from 'http-proxy-middleware'
import parseUrl from 'parseurl'
import express from 'express'
import * as path from 'path'
import got from 'got'

if (!process.env.COCKPIT_API_TOKEN || !process.env.COCKPIT_BASE_URL || !process.env.COCKPIT_MODE) {
    console.error(`💥 environment configuration (COCKPIT_API_TOKEN, COCKPIT_BASE_URL and COCKPIT_MODE) missing`)
    process.exit(1)
}

const token = process.env.COCKPIT_API_TOKEN
const baseURL = process.env.COCKPIT_BASE_URL
const mode = process.env.COCKPIT_MODE

const app = express()

app.use('/image/api', (req, res) => {
    const parsedURL = parseUrl(req)
    if (parsedURL) {
        const assetURL = `${baseURL}/api/cockpit/image?token=${token}&src=${baseURL}/storage/uploads${parsedURL.pathname}&${parsedURL.query}`
        got.stream(assetURL).pipe(res)
    }
})

// on start mode point proxy to elm app
if (mode === 'start') {
    app.use('*', createProxyMiddleware({
        target: 'http://localhost:3000',
        changeOrigin: true,
    }))
} else if (mode === 'serve') {
    // on serve mode point application to dist folder
    app.use(express.static(path.join(`${__dirname}/../dist/`)))
}

app.listen(8000)

console.log(`🚀  app running "${mode}" on http://localhost:8000`)