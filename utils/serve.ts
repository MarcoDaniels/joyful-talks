import express from 'express'
import parseUrl from 'parseurl'
import got from 'got'
import {createProxyMiddleware} from 'http-proxy-middleware'

const token = process.env.COCKPIT_API_TOKEN
const baseURL = process.env.COCKPIT_BASE_URL

const app = express()

app.use('/storage/uploads', (req, res) => {
    const parsedURL = parseUrl(req)
    if (parsedURL) {
        const assetURL = `${baseURL}/api/cockpit/image?token=${token}&src=${baseURL}/storage/uploads${parsedURL.pathname}&${parsedURL.query}`
        got.stream(assetURL).pipe(res)
    }
})

app.use('*', createProxyMiddleware({
    target: 'http://localhost:3000',
    changeOrigin: true,
}))

app.listen(8000)

console.log(`server on http://localhost:8000/`)